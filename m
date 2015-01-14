From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 28/48] hpsa: use per-controller work queue
Date: Wed, 14 Jan 2015 16:02:05 -0600
Message-ID: <20150114220205.21325.5519.stgit@brunhilda>
References: <20150114215756.21325.41198.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:55650 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232AbbANWCx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2015 17:02:53 -0500
Received: from g2t2353.austin.hp.com (g2t2353.austin.hp.com [15.217.128.52])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id 3E67AE8
	for <linux-scsi@vger.kernel.org>; Wed, 14 Jan 2015 22:02:52 +0000 (UTC)
In-Reply-To: <20150114215756.21325.41198.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Webb Scales <webbnh@hp.com>

There is a possibility of deadlock if we use the system work queue
for command resubmission since something in the queue may be depending
on the I/O that gets resubmitted, and the resubmitted I/O will be
behind the thing that depends on it in the queue.  Using a driver
specific, per-controller work queue avoids this.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Webb Scales <webbnh@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   16 +++++++++++++---
 drivers/scsi/hpsa.h |    1 +
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c1166a5..dcacb29 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1651,7 +1651,7 @@ static void process_ioaccel2_completion(struct ctlr_info *h,
 
 retry_cmd:
 	INIT_WORK(&c->work, hpsa_command_resubmit_worker);
-	schedule_work_on(raw_smp_processor_id(), &c->work);
+	queue_work_on(raw_smp_processor_id(), h->resubmit_wq, &c->work);
 }
 
 static void complete_scsi_command(struct CommandList *cp)
@@ -1722,7 +1722,8 @@ static void complete_scsi_command(struct CommandList *cp)
 			if (ei->CommandStatus == CMD_IOACCEL_DISABLED)
 				dev->offload_enabled = 0;
 			INIT_WORK(&cp->work, hpsa_command_resubmit_worker);
-			schedule_work_on(raw_smp_processor_id(), &cp->work);
+			queue_work_on(raw_smp_processor_id(),
+					h->resubmit_wq, &cp->work);
 			return;
 		}
 	}
@@ -6418,6 +6419,7 @@ static void fail_all_outstanding_cmds(struct ctlr_info *h)
 	int i;
 	struct CommandList *c = NULL;
 
+	flush_workqueue(h->resubmit_wq); /* ensure all cmds are fully built */
 	for (i = 0; i < h->nr_cmds; i++) {
 		if (!test_bit(i & (BITS_PER_LONG - 1),
 				h->cmd_pool_bits + (i / BITS_PER_LONG)))
@@ -6653,6 +6655,12 @@ reinit_after_soft_reset:
 	spin_lock_init(&h->scan_lock);
 	spin_lock_init(&h->passthru_count_lock);
 
+	h->resubmit_wq = alloc_workqueue("hpsa", WQ_MEM_RECLAIM, 0);
+	if (!h->resubmit_wq) {
+		dev_err(&h->pdev->dev, "Failed to allocate work queue\n");
+		rc = -ENOMEM;
+		goto clean1;
+	}
 	/* Allocate and clear per-cpu variable lockup_detected */
 	h->lockup_detected = alloc_percpu(u32);
 	if (!h->lockup_detected) {
@@ -6785,6 +6793,8 @@ clean2_and_free_irqs:
 	hpsa_free_irqs(h);
 clean2:
 clean1:
+	if (h->resubmit_wq)
+		destroy_workqueue(h->resubmit_wq);
 	if (h->lockup_detected)
 		free_percpu(h->lockup_detected);
 	kfree(h);
@@ -6860,9 +6870,9 @@ static void hpsa_remove_one(struct pci_dev *pdev)
 	h->remove_in_progress = 1;
 	cancel_delayed_work(&h->monitor_ctlr_work);
 	spin_unlock_irqrestore(&h->lock, flags);
-
 	hpsa_unregister_scsi(h);	/* unhook from SCSI subsystem */
 	hpsa_shutdown(pdev);
+	destroy_workqueue(h->resubmit_wq);
 	iounmap(h->vaddr);
 	iounmap(h->transtable);
 	iounmap(h->cfgtable);
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 06a3e81..a0f4268 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -236,6 +236,7 @@ struct ctlr_info {
 	struct list_head offline_device_list;
 	int	acciopath_status;
 	int	raid_offload_debug;
+	struct workqueue_struct *resubmit_wq;
 };
 
 struct offline_device_entry {

