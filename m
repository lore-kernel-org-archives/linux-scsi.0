From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V3 2/3] hpsa: limit outstanding rescans
Date: Fri, 10 Mar 2017 14:35:17 -0600
Message-ID: <148917811749.17050.10796225321668028334.stgit@brunhilda>
References: <148917802486.17050.17178463722401202189.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0076.outbound.protection.outlook.com ([104.47.37.76]:3440
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755440AbdCJUfh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 10 Mar 2017 15:35:37 -0500
In-Reply-To: <148917802486.17050.17178463722401202189.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

avoid rescan storms. No need to queue another
if one is pending.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com> review
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |   16 +++++++++++++++-
 drivers/scsi/hpsa.h |    1 +
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 90b76c4..0a8ac68 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5555,7 +5555,7 @@ static void hpsa_scan_complete(struct ctlr_info *h)
 
 	spin_lock_irqsave(&h->scan_lock, flags);
 	h->scan_finished = 1;
-	wake_up_all(&h->scan_wait_queue);
+	wake_up(&h->scan_wait_queue);
 	spin_unlock_irqrestore(&h->scan_lock, flags);
 }
 
@@ -5573,11 +5573,23 @@ static void hpsa_scan_start(struct Scsi_Host *sh)
 	if (unlikely(lockup_detected(h)))
 		return hpsa_scan_complete(h);
 
+	/*
+	 * If a scan is already waiting to run, no need to add another
+	 */
+	spin_lock_irqsave(&h->scan_lock, flags);
+	if (h->scan_waiting) {
+		spin_unlock_irqrestore(&h->scan_lock, flags);
+		return;
+	}
+
+	spin_unlock_irqrestore(&h->scan_lock, flags);
+
 	/* wait until any scan already in progress is finished. */
 	while (1) {
 		spin_lock_irqsave(&h->scan_lock, flags);
 		if (h->scan_finished)
 			break;
+		h->scan_waiting = 1;
 		spin_unlock_irqrestore(&h->scan_lock, flags);
 		wait_event(h->scan_wait_queue, h->scan_finished);
 		/* Note: We don't need to worry about a race between this
@@ -5587,6 +5599,7 @@ static void hpsa_scan_start(struct Scsi_Host *sh)
 		 */
 	}
 	h->scan_finished = 0; /* mark scan as in progress */
+	h->scan_waiting = 0;
 	spin_unlock_irqrestore(&h->scan_lock, flags);
 
 	if (unlikely(lockup_detected(h)))
@@ -8789,6 +8802,7 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	init_waitqueue_head(&h->event_sync_wait_queue);
 	mutex_init(&h->reset_mutex);
 	h->scan_finished = 1; /* no scan currently in progress */
+	h->scan_waiting = 0;
 
 	pci_set_drvdata(pdev, h);
 	h->ndevices = 0;
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index bf6cdc1..6f04f2a 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -201,6 +201,7 @@ struct ctlr_info {
 	dma_addr_t		errinfo_pool_dhandle;
 	unsigned long  		*cmd_pool_bits;
 	int			scan_finished;
+	u8			scan_waiting : 1;
 	spinlock_t		scan_lock;
 	wait_queue_head_t	scan_wait_queue;
 
