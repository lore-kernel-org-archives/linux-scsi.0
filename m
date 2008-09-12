From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Block timeouts seem not to be working
Date: Fri, 12 Sep 2008 16:46:51 -0500
Message-ID: <1221256012.3319.21.camel@localhost.localdomain>
References: <1221145521.3330.2.camel@localhost.localdomain>
	 <20080911183509.GX20055@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51109 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755487AbYILVq5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Sep 2008 17:46:57 -0400
In-Reply-To: <20080911183509.GX20055@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2008-09-11 at 20:35 +0200, Jens Axboe wrote:
> On Thu, Sep 11 2008, James Bottomley wrote:
> > I just noticed this with a rather finickey SAS system I have.  It's got
> > a SATA DVD attached over an expander.  Periodically the DVD just hangs
> > up, so we wait for the timeout and then send a phy reset which clears
> > it.
> > 
> > What I'm seeing with the new block timer code is that the timer never
> > expires.  I can dig some more into this, but if you wanted to test it as
> > well, the timer code is easy to excite.  Just throw away one command in
> > every 128 or so in the queuecommand routine of your favourite HBA
> > driver.
> 
> James, I've seen a few oddities as well, I'll be beating on it tomorrow
> again to shake out the last bug(s).

Actually, turns out it's nothing to do with block timeouts, it's a
target reset bug.

This loop:

	for (id = 0; id <= shost->max_id; id++) {

Never terminates if shost->max_id is set to ~0, like aic94xx does.

It's also pretty inefficient since you mostly have compact target
numbers, but the max_id can be very high.  The best way would be to sort
the recovery list by target id and skip them if they're equal, but even
a worst case O(N^2) traversal is probably OK here.

James

---
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index ad019ec..94ed262 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1065,10 +1065,10 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 				struct list_head *done_q)
 {
 	struct scsi_cmnd *scmd, *tgtr_scmd, *next;
-	unsigned int id;
+	unsigned int id = 0;
 	int rtn;
 
-	for (id = 0; id <= shost->max_id; id++) {
+	do {
 		tgtr_scmd = NULL;
 		list_for_each_entry(scmd, work_q, eh_entry) {
 			if (id == scmd_id(scmd)) {
@@ -1076,8 +1076,18 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 				break;
 			}
 		}
+		if (!tgtr_scmd) {
+			/* not one exactly equal; find the next highest */
+			list_for_each_entry(scmd, work_q, eh_entry) {
+				if (scmd_id(scmd) > id &&
+				    (!tgtr_scmd ||
+				     scmd_id(tgtr_scmd) > scmd_id(scmd)))
+						tgtr_scmd = scmd;
+			}
+		}
 		if (!tgtr_scmd)
-			continue;
+			/* no more commands, that's it */
+			break;
 
 		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Sending target reset "
 						  "to target %d\n",
@@ -1096,7 +1106,8 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 							  " failed target: "
 							  "%d\n",
 							  current->comm, id));
-	}
+		id++;
+	} while(id != 0);
 
 	return list_empty(work_q);
 }





