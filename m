From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 3/3] ipr: Add scsi multi-queue support
Date: Tue, 12 Jul 2016 16:02:09 -0500
Message-ID: <1468357329-3790-3-git-send-email-wenxiong@linux.vnet.ibm.com>
References: <1468357329-3790-1-git-send-email-wenxiong@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33457 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750889AbcGLVHy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jul 2016 17:07:54 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u6CL3qsL016859
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2016 17:07:49 -0400
Received: from e24smtp05.br.ibm.com (e24smtp05.br.ibm.com [32.104.18.26])
	by mx0a-001b2d01.pphosted.com with ESMTP id 2452xr2t5v-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2016 17:07:48 -0400
Received: from localhost
	by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wenxiong@us.ibm.com>;
	Tue, 12 Jul 2016 18:07:45 -0300
Received: from d24relay02.br.ibm.com (d24relay02.br.ibm.com [9.13.184.26])
	by d24dlp01.br.ibm.com (Postfix) with ESMTP id 0AE933520074
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2016 17:07:25 -0400 (EDT)
Received: from d24av02.br.ibm.com (d24av02.br.ibm.com [9.8.31.93])
	by d24relay02.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u6CL7hBL34144624
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2016 18:07:43 -0300
Received: from d24av02.br.ibm.com (localhost [127.0.0.1])
	by d24av02.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u6CL7gCW029107
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2016 18:07:43 -0300
In-Reply-To: <1468357329-3790-1-git-send-email-wenxiong@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@Odin.com, martin.petersen@oracle.com, brking@linux.vnet.ibm.com, krisman@linux.vnet.ibm.com, Wen Xiong <wenxiong@linux.vnet.ibm.com>

From: Wen Xiong <wenxiong@linux.vnet.ibm.com>

Add scsi multi-queue support in ipr driver. This feature
is enabled by setting ipr_use_blk_mq=1 when loading ipr
module and scsi blk-mq is enabled in the kernel.

Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c |   16 ++++++++++++++--
 drivers/scsi/ipr.h |    1 +
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 1f539c2..21b6da6 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -100,6 +100,7 @@ static unsigned int ipr_max_devs = IPR_DEFAULT_SIS64_DEVS;
 static unsigned int ipr_dual_ioa_raid = 1;
 static unsigned int ipr_number_of_msix = 16;
 static unsigned int ipr_fast_reboot;
+static unsigned int ipr_use_blk_mq = 0;
 static DEFINE_SPINLOCK(ipr_driver_lock);
 
 /* This table describes the differences between DMA controller chips */
@@ -225,6 +226,8 @@ module_param_named(number_of_msix, ipr_number_of_msix, int, 0);
 MODULE_PARM_DESC(number_of_msix, "Specify the number of MSIX interrupts to use on capable adapters (1 - 16).  (default:16)");
 module_param_named(fast_reboot, ipr_fast_reboot, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(fast_reboot, "Skip adapter shutdown during reboot. Set to 1 to enable. (default: 0)");
+module_param_named(use_blk_mq, ipr_use_blk_mq, uint, S_IRUGO);
+MODULE_PARM_DESC(use_blk_mq, "ipr use block mq enable/disable. (default: 0)");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(IPR_DRIVER_VERSION);
 
@@ -6316,6 +6319,7 @@ static int ipr_queuecommand(struct Scsi_Host *shost,
 	int rc;
 	struct ipr_hrr_queue *hrrq;
 	int hrrq_id;
+	uint32_t tag;
 
 	ioa_cfg = (struct ipr_ioa_cfg *)shost->hostdata;
 
@@ -6329,7 +6333,12 @@ static int ipr_queuecommand(struct Scsi_Host *shost,
 		return rc;
 	}
 
-	hrrq_id = ipr_get_hrrq_index(ioa_cfg);
+	if (ioa_cfg->use_blk_mq && shost_use_blk_mq(scsi_cmd->device->host)) {
+		tag = blk_mq_unique_tag(scsi_cmd->request);
+		hrrq_id = blk_mq_unique_tag_to_hwq(tag);
+	} else
+		hrrq_id = ipr_get_hrrq_index(ioa_cfg);
+
 	hrrq = &ioa_cfg->hrrq[hrrq_id];
 
 	spin_lock_irqsave(hrrq->lock, hrrq_flags);
@@ -10144,6 +10153,8 @@ static int ipr_probe_ioa(struct pci_dev *pdev,
 				(unsigned int)num_online_cpus(),
 				(unsigned int)IPR_MAX_HRRQ_NUM);
 
+	host->nr_hw_queues = ioa_cfg->hrrq_num;
+
 	if ((rc = ipr_save_pcix_cmd_reg(ioa_cfg)))
 		goto out_msi_disable;
 
@@ -10377,7 +10388,7 @@ static int ipr_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 		return rc;
 	}
 
-	rc = scsi_add_host(ioa_cfg->host, &pdev->dev);
+	rc = scsi_add_host_with_dma(ioa_cfg->host, &pdev->dev, &pdev->dev);
 
 	if (rc) {
 		__ipr_remove(pdev);
@@ -10406,6 +10417,7 @@ static int ipr_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 
 	scsi_scan_host(ioa_cfg->host);
 	ioa_cfg->iopoll_weight = ioa_cfg->chip_cfg->iopoll_weight;
+	ioa_cfg->use_blk_mq = ipr_use_blk_mq;
 
 	if (ioa_cfg->iopoll_weight && ioa_cfg->sis64 && ioa_cfg->nvectors > 1) {
 		for (i = 1; i < ioa_cfg->hrrq_num; i++) {
diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index 1d42c74..f79c96b 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -1597,6 +1597,7 @@ struct ipr_ioa_cfg {
 	} vectors_info[IPR_MAX_MSIX_VECTORS];
 
 	u32 iopoll_weight;
+	u32 use_blk_mq;
 
 }; /* struct ipr_ioa_cfg */
 
-- 
1.7.1

