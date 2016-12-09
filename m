From: kushwaha.a@samsung.com
Subject: [PATCH] scsi: hpsa: remove memory allocate failure message
Date: Fri, 09 Dec 2016 16:47:44 +0530
Message-ID: <1481282264-11103-1-git-send-email-kushwaha.a@samsung.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:48337 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932320AbcLILUJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2016 06:20:09 -0500
Received: from epcpsbgm1new.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OHX035CB0T72J70@mailout3.samsung.com> for
 linux-scsi@vger.kernel.org; Fri, 09 Dec 2016 20:20:07 +0900 (KST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: don.brace@pmcs.com, JBottomley@odin.com
Cc: linux-scsi@vger.kernel.org, kushwaha.a@samsung.com, d.wadhawan@samsung.com

From: Amit Kushwaha <kushwaha.a@samsung.com>

This patch cleanup warning reported by checkpatch.pl
WARNING: Possible unnecessary 'out of memory' message
With no available memory, a warn on message already gets printed
by page alloc apis

Signed-off-by: Amit Kushwaha <kushwaha.a@samsung.com>
---
 drivers/scsi/hpsa.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 40669f8..bf14405 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1455,10 +1455,9 @@ static void hpsa_monitor_offline_device(struct ctlr_info *h,
 
 	/* Device is not on the list, add it. */
 	device = kmalloc(sizeof(*device), GFP_KERNEL);
-	if (!device) {
-		dev_warn(&h->pdev->dev, "out of memory in %s\n", __func__);
+	if (!device)
 		return;
-	}
+
 	memcpy(device->scsi3addr, scsi3addr, sizeof(device->scsi3addr));
 	spin_lock_irqsave(&h->offline_device_lock, flags);
 	list_add_tail(&device->offline_list, &h->offline_device_list);
@@ -1928,17 +1927,15 @@ static int hpsa_alloc_sg_chain_blocks(struct ctlr_info *h)
 
 	h->cmd_sg_list = kzalloc(sizeof(*h->cmd_sg_list) * h->nr_cmds,
 				GFP_KERNEL);
-	if (!h->cmd_sg_list) {
-		dev_err(&h->pdev->dev, "Failed to allocate SG list\n");
+	if (!h->cmd_sg_list)
 		return -ENOMEM;
-	}
+
 	for (i = 0; i < h->nr_cmds; i++) {
 		h->cmd_sg_list[i] = kmalloc(sizeof(*h->cmd_sg_list[i]) *
 						h->chainsize, GFP_KERNEL);
-		if (!h->cmd_sg_list[i]) {
-			dev_err(&h->pdev->dev, "Failed to allocate cmd SG\n");
+		if (!h->cmd_sg_list[i])
 			goto clean;
-		}
+
 	}
 	return 0;
 
@@ -3759,11 +3756,9 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 		}
 
 		currentsd[i] = kzalloc(sizeof(*currentsd[i]), GFP_KERNEL);
-		if (!currentsd[i]) {
-			dev_warn(&h->pdev->dev, "out of memory at %s:%d\n",
-				__FILE__, __LINE__);
+		if (!currentsd[i])
 			goto out;
-		}
+
 		ndev_allocated++;
 	}
 
-- 
1.7.9.5

