From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Bug 11898] mke2fs hang on AIC79 device.
Date: Tue, 11 Nov 2008 13:42:35 -0600
Message-ID: <4919E02B.9050204@cs.wisc.edu>
References: <20081105040154.9690A108048@picon.linux-foundation.org>	 <1225898691.4703.32.camel@localhost.localdomain>	 <4911D6F2.2080309@cs.wisc.edu> <1226245637.19841.7.camel@localhost.localdomain> <4919CD6E.7010901@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010404070905090409000000"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37510 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbYKKTnV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Nov 2008 14:43:21 -0500
In-Reply-To: <4919CD6E.7010901@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------010404070905090409000000
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Mike Christie wrote:
> I can sort of replicate this now. Let me do some testing on the changes 
> and I will submit something in a minute.

I do not think I am replicating the original problem. The attached patch 
should fix the oops in James's splice use patch though.

--------------010404070905090409000000
Content-Type: text/x-patch;
 name="splice2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="splice2.patch"

Close possible infinite loop when devices are added back to the
starved list.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f5d3b96..fa45a1a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -567,15 +567,18 @@ static inline int scsi_host_is_busy(struct Scsi_Host *shost)
  */
 static void scsi_run_queue(struct request_queue *q)
 {
-	struct scsi_device *starved_head = NULL, *sdev = q->queuedata;
+	struct scsi_device *sdev = q->queuedata;
 	struct Scsi_Host *shost = sdev->host;
+	LIST_HEAD(starved_list);
 	unsigned long flags;
 
 	if (scsi_target(sdev)->single_lun)
 		scsi_single_lun_run(sdev);
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	while (!list_empty(&shost->starved_list) && !scsi_host_is_busy(shost)) {
+	list_splice_init(&shost->starved_list, &starved_list);
+
+	while (!list_empty(&starved_list)) {
 		int flagset;
 
 		/*
@@ -588,24 +591,18 @@ static void scsi_run_queue(struct request_queue *q)
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
 
+		sdev = list_entry(starved_list.next,
+				  struct scsi_device, starved_entry);
+		list_del_init(&sdev->starved_entry);
 		if (scsi_target_is_busy(scsi_target(sdev))) {
 			list_move_tail(&sdev->starved_entry,
 				       &shost->starved_list);
 			continue;
 		}
 
-		list_del_init(&sdev->starved_entry);
 		spin_unlock(shost->host_lock);
 
 		spin_lock(sdev->request_queue->queue_lock);
@@ -621,6 +618,8 @@ static void scsi_run_queue(struct request_queue *q)
 
 		spin_lock(shost->host_lock);
 	}
+	/* put any unprocessed entries back */
+	list_splice(&starved_list, &shost->starved_list);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	blk_run_queue(q);

--------------010404070905090409000000--
