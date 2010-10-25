From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] fix id computation in scsi_eh_target_reset()
Date: Mon, 25 Oct 2010 15:53:41 -0500
Message-ID: <1288040021.5487.826.camel@mulgrave.site>
References: <AANLkTin-Tkj3Ab312usO2FWE57m3St2iG2oz881F-Zhw@mail.gmail.com>
	 <4CBBDC19.1090806@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45468 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab0JYUxp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Oct 2010 16:53:45 -0400
In-Reply-To: <4CBBDC19.1090806@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hillf Danton <dhillf@gmail.com>, linux-scsi@vger.kernel.org

On Mon, 2010-10-18 at 00:33 -0500, Mike Christie wrote:
> On 10/14/2010 09:04 AM, Hillf Danton wrote:
> > There seems that the id of the tgtr_scmd processed by
> > scsi_try_target_reset() does not match the id in case that
> > SUCCESS is returned by scsi_try_target_reset().
> >
> > The mismatch is fixed, and the loop to find the next highest
> > is also simplified.
> >
> > Signed-off-by: Hillf Danton<dhillf@gmail.com>
> > ---
> >
> > --- a/drivers/scsi/scsi_error.c	2010-09-13 07:07:38.000000000 +0800
> > +++ b/drivers/scsi/scsi_error.c	2010-10-14 21:45:56.000000000 +0800
> > @@ -1173,14 +1173,19 @@ static int scsi_eh_target_reset(struct S
> >   			list_for_each_entry(scmd, work_q, eh_entry) {
> >   				if (scmd_id(scmd)>  id&&
> >   				(!tgtr_scmd ||
> > -				     scmd_id(tgtr_scmd)>  scmd_id(scmd)))
> > +				     scmd_id(tgtr_scmd)>  scmd_id(scmd))) {
> >   						tgtr_scmd = scmd;
> > +						if (1 + id == scmd_id(scmd))
> > +							break;
> > +				}
> >   			}
> >   		}
> >   		if (!tgtr_scmd)
> >   			/* no more commands, that's it */
> >   			break;
> >
> > +		id = scmd_id(tgtr_scmd);
> > +
> >   		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Sending target reset "
> >   						  "to target %d\n",
> >   						  current->comm, id));
> 
> 
> Thanks. Fixes the extra target resets I have been seeing and commands 
> not getting cleaned up properly.
> 
> Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

The routine is still a bit fiendishly complicated, though.  What about
unwinding all of the id processing? it's only required if we want to do
target resets in numerical order (a number which has no real meaning on
a hot plug bus anyway).

What about just a simple list processor that chunks down the work_q,
resets the target and pulls all equal targets out, like this?

James

---

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 1de30eb..484b128 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1156,51 +1156,40 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 				struct list_head *work_q,
 				struct list_head *done_q)
 {
-	struct scsi_cmnd *scmd, *tgtr_scmd, *next;
-	unsigned int id = 0;
-	int rtn;
+	LIST_HEAD(tmp_list);
 
-	do {
-		tgtr_scmd = NULL;
-		list_for_each_entry(scmd, work_q, eh_entry) {
-			if (id == scmd_id(scmd)) {
-				tgtr_scmd = scmd;
-				break;
-			}
-		}
-		if (!tgtr_scmd) {
-			/* not one exactly equal; find the next highest */
-			list_for_each_entry(scmd, work_q, eh_entry) {
-				if (scmd_id(scmd) > id &&
-				    (!tgtr_scmd ||
-				     scmd_id(tgtr_scmd) > scmd_id(scmd)))
-						tgtr_scmd = scmd;
-			}
-		}
-		if (!tgtr_scmd)
-			/* no more commands, that's it */
-			break;
+	list_splice(work_q, &tmp_list);
+
+	while (!list_empty(&tmp_list)) {
+		struct scsi_cmnd *next, *scmd; 
+		int rtn;
+		unsigned int id;
+
+		scmd = list_entry(tmp_list.next, struct scsi_cmnd, eh_entry);
+		id = scmd_id(scmd);
 
 		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Sending target reset "
 						  "to target %d\n",
 						  current->comm, id));
-		rtn = scsi_try_target_reset(tgtr_scmd);
-		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
-			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
-				if (id == scmd_id(scmd))
-					if (!scsi_device_online(scmd->device) ||
-					    rtn == FAST_IO_FAIL ||
-					    !scsi_eh_tur(tgtr_scmd))
-						scsi_eh_finish_cmd(scmd,
-								   done_q);
-			}
-		} else
+		rtn = scsi_try_target_reset(scmd);
+		if (rtn != SUCCESS && rtn != FAST_IO_FAIL)
 			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Target reset"
 							  " failed target: "
 							  "%d\n",
 							  current->comm, id));
-		id++;
-	} while(id != 0);
+		list_for_each_entry_safe(scmd, next, &tmp_list, eh_entry) {
+			if (scmd_id(scmd) != id)
+				continue;
+
+			if ((rtn == SUCCESS || rtn == FAST_IO_FAIL)
+			    && (!scsi_device_online(scmd->device) ||
+				 rtn == FAST_IO_FAIL || !scsi_eh_tur(scmd)))
+				scsi_eh_finish_cmd(scmd, done_q);
+			else
+				/* push back on work queue for further processing */
+				list_move(&scmd->eh_entry, work_q);
+		}
+	}
 
 	return list_empty(work_q);
 }


