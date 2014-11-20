From: Christoph Hellwig <hch@infradead.org>
Subject: Re: BUG in scsi_lib.c due to a bad commit
Date: Wed, 19 Nov 2014 22:09:33 -0800
Message-ID: <20141120060933.GA21432@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42737 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaKTGJi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Nov 2014 01:09:38 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Barto <mister.freeman@laposte.net>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

I

Hi Barto,

sorry for the late reply, and thanks for drilling down the exact
conditions.

I think we have some issues with the lack of the host lock vs error
handling, but I still don't undertand the details.

I've got a test patch for you that just adds the host lock back in a few
places while keeing the atomic_t.  Can you try to reproduce with that
one?

When breaking an existing setup in software it's always the softwares
fault, btw..


diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 994eb08..99b77f7 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -311,16 +311,16 @@ void scsi_device_unbusy(struct scsi_device *sdev)
 	struct scsi_target *starget = scsi_target(sdev);
 	unsigned long flags;
 
+	spin_lock_irqsave(shost->host_lock, flags);
 	atomic_dec(&shost->host_busy);
 	if (starget->can_queue > 0)
 		atomic_dec(&starget->target_busy);
 
 	if (unlikely(scsi_host_in_recovery(shost) &&
 		     (shost->host_failed || shost->host_eh_scheduled))) {
-		spin_lock_irqsave(shost->host_lock, flags);
 		scsi_eh_wakeup(shost);
-		spin_unlock_irqrestore(shost->host_lock, flags);
 	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	atomic_dec(&sdev->device_busy);
 }
@@ -1504,6 +1504,8 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
 	if (scsi_host_in_recovery(shost))
 		return 0;
 
+	spin_lock_irq(shost->host_lock);
+
 	busy = atomic_inc_return(&shost->host_busy) - 1;
 	if (atomic_read(&shost->host_blocked) > 0) {
 		if (busy)
@@ -1527,21 +1529,19 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
 
 	/* We're OK to process the command, so we can't be starved */
 	if (!list_empty(&sdev->starved_entry)) {
-		spin_lock_irq(shost->host_lock);
 		if (!list_empty(&sdev->starved_entry))
 			list_del_init(&sdev->starved_entry);
-		spin_unlock_irq(shost->host_lock);
 	}
 
+	spin_unlock_irq(shost->host_lock);
 	return 1;
 
 starved:
-	spin_lock_irq(shost->host_lock);
 	if (list_empty(&sdev->starved_entry))
 		list_add_tail(&sdev->starved_entry, &shost->starved_list);
-	spin_unlock_irq(shost->host_lock);
 out_dec:
 	atomic_dec(&shost->host_busy);
+	spin_unlock_irq(shost->host_lock);
 	return 0;
 }
 
