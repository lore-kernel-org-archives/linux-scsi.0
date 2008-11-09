From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 11898] mke2fs hang on AIC79 device.
Date: Sun, 09 Nov 2008 09:47:17 -0600
Message-ID: <1226245637.19841.7.camel@localhost.localdomain>
References: <20081105040154.9690A108048@picon.linux-foundation.org>
	 <1225898691.4703.32.camel@localhost.localdomain>
	 <4911D6F2.2080309@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58571 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755114AbYKIPrV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Nov 2008 10:47:21 -0500
In-Reply-To: <4911D6F2.2080309@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

On Wed, 2008-11-05 at 11:25 -0600, Mike Christie wrote:
> James Bottomley wrote:
> > The reason for doing it like this is so that if someone slices the loop
> > apart again (which is how this crept in) they won't get a continue or
> > something which allows this to happen.
> > 
> > It shouldn't be conditional on the starved list (or anything else)
> > because it's probably a register and should happen at the same point as
> > the list deletion but before we drop the problem lock (because once we
> > drop that lock we'll need to recompute starvation).
> > 
> > James
> > 
> > ---
> > 
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index f5d3b96..f9a531f 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -606,6 +606,7 @@ static void scsi_run_queue(struct request_queue *q)
> >  		}
> >  
> >  		list_del_init(&sdev->starved_entry);
> > +		starved_entry = NULL;
> 
> Should this be starved_head?
> 
> >  		spin_unlock(shost->host_lock);
> >  
> >  		spin_lock(sdev->request_queue->queue_lock);
> > 
> 
> Do you think we can just splice the list like the attached patch (patch 
> is example only and is not tested)?
> 
> I thought the code is clearer, but I think it may be less efficient. If 
> scsi_run_queue is run on multiple processors then with the attached 
> patch one processor would splice the list and possibly have to execute 
> __blk_run_queue for all the devices on the list serially.
> 
> Currently we can at least prep the devices in parallel. One processor 
> would grab one entry on the list and drop the host lock, so then another 
> processor could grab another entry on the list and start the execution 
> process (I wrote start the process because it might turn out that this 
> second entry execution might have to wait on the first one when the scsi 
> layer has to grab the queue lock again).

I reconsidered:  I think something like this would work well if we
simply to run through the starved list once each time, giving them the
chance of executing.  Something like this.

James

---

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f5d3b96..979e07a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -567,15 +567,18 @@ static inline int scsi_host_is_busy(struct Scsi_Host *shost)
  */
 static void scsi_run_queue(struct request_queue *q)
 {
-	struct scsi_device *starved_head = NULL, *sdev = q->queuedata;
+	struct scsi_device *tmp, *sdev = q->queuedata;
 	struct Scsi_Host *shost = sdev->host;
+	LIST_HEAD(starved_list);
 	unsigned long flags;
 
 	if (scsi_target(sdev)->single_lun)
 		scsi_single_lun_run(sdev);
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	while (!list_empty(&shost->starved_list) && !scsi_host_is_busy(shost)) {
+	list_splice_init(&shost->starved_list, &starved_list);
+
+	list_for_each_entry_safe(sdev, tmp, &starved_list, starved_entry) {
 		int flagset;
 
 		/*
@@ -588,22 +591,10 @@ static void scsi_run_queue(struct request_queue *q)
 		 * scsi_request_fn must get the host_lock before checking
 		 * or modifying starved_list or starved_entry.
 		 */
-		sdev = list_entry(shost->starved_list.next,
-					  struct scsi_device, starved_entry);
-		/*
-		 * The *queue_ready functions can add a device back onto the
-		 * starved list's tail, so we must check for a infinite loop.
-		 */
-		if (sdev == starved_head)
+		if (scsi_host_is_busy(shost))
 			break;
-		if (!starved_head)
-			starved_head = sdev;
-
-		if (scsi_target_is_busy(scsi_target(sdev))) {
-			list_move_tail(&sdev->starved_entry,
-				       &shost->starved_list);
+		if (scsi_target_is_busy(scsi_target(sdev)))
 			continue;
-		}
 
 		list_del_init(&sdev->starved_entry);
 		spin_unlock(shost->host_lock);
@@ -621,6 +612,9 @@ static void scsi_run_queue(struct request_queue *q)
 
 		spin_lock(shost->host_lock);
 	}
+
+	/* put any unprocessed entries back */
+	list_splice(&starved_list, &shost->starved_list);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	blk_run_queue(q);


