From: kushwaha.a@samsung.com
Subject: [PATCH v2] scsi: hpsa: remove memory allocate failure message
Date: Mon, 12 Dec 2016 16:34:21 +0530
Message-ID: <1481540661-18493-1-git-send-email-kushwaha.a@samsung.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:39905 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752848AbcLLLFk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2016 06:05:40 -0500
Received: from epcpsbgm1new.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OI200OT4K5D6O90@mailout3.samsung.com> for
 linux-scsi@vger.kernel.org; Mon, 12 Dec 2016 20:05:38 +0900 (KST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: don.brace@microsemi.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, akkushwaha9896@gmail.com, vidushi.koul@samsung.com

From: Amit Kushwaha <kushwaha.a@samsung.com>

This patch cleanup warning reported by checkpatch.pl
WARNING: Possible unnecessary 'out of memory' message
With no available memory, a warn on message already gets printed
by page alloc apis and modified goto use if memory unallocated.

Signed-off-by: Amit Kushwaha <kushwaha.a@samsung.com>
---
Changes in v2:
  - using driver version "3.4.16-0"

 drivers/scsi/hpsa.c |   37 ++++++++++++-------------------------
 1 file changed, 12 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index d007ec1..42844ef 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1543,10 +1543,9 @@ static void hpsa_monitor_offline_device(struct ctlr_info *h,
 
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
@@ -2127,17 +2126,15 @@ static int hpsa_alloc_sg_chain_blocks(struct ctlr_info *h)
 
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
 
@@ -3443,11 +3440,8 @@ static void hpsa_get_sas_address(struct ctlr_info *h, unsigned char *scsi3addr,
 		struct bmic_sense_subsystem_info *ssi;
 
 		ssi = kzalloc(sizeof(*ssi), GFP_KERNEL);
-		if (ssi == NULL) {
-			dev_warn(&h->pdev->dev,
-				"%s: out of memory\n", __func__);
+		if (!ssi)
 			return;
-		}
 
 		rc = hpsa_bmic_sense_subsystem_information(h,
 					scsi3addr, 0, ssi, sizeof(*ssi));
@@ -4295,8 +4289,6 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h)
 
 		currentsd[i] = kzalloc(sizeof(*currentsd[i]), GFP_KERNEL);
 		if (!currentsd[i]) {
-			dev_warn(&h->pdev->dev, "out of memory at %s:%d\n",
-				__FILE__, __LINE__);
 			h->drv_req_rescan = 1;
 			goto out;
 		}
@@ -8599,14 +8591,12 @@ static int hpsa_luns_changed(struct ctlr_info *h)
 	 */
 
 	if (!h->lastlogicals)
-		goto out;
+		return rc;
 
 	logdev = kzalloc(sizeof(*logdev), GFP_KERNEL);
-	if (!logdev) {
-		dev_warn(&h->pdev->dev,
-			"Out of memory, can't track lun changes.\n");
-		goto out;
-	}
+	if (!logdev)
+		return rc;
+
 	if (hpsa_scsi_do_report_luns(h, 1, logdev, sizeof(*logdev), 0)) {
 		dev_warn(&h->pdev->dev,
 			"report luns failed, can't track lun changes.\n");
@@ -8992,11 +8982,8 @@ static void hpsa_disable_rld_caching(struct ctlr_info *h)
 		return;
 
 	options = kzalloc(sizeof(*options), GFP_KERNEL);
-	if (!options) {
-		dev_err(&h->pdev->dev,
-			"Error: failed to disable rld caching, during alloc.\n");
+	if (!options)
 		return;
-	}
 
 	c = cmd_alloc(h);
 
-- 
1.7.9.5

