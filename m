From: Maurizio Lombardi <mlombard@redhat.com>
Subject: [PATCH] qla4xxx: check the return value of dma_alloc_coherent()
Date: Mon, 28 Jul 2014 14:55:27 +0200
Message-ID: <1406552127-9405-1-git-send-email-mlombard@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbaG1Mzg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jul 2014 08:55:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: iscsi-driver@qlogic.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, hch@lst.de

the qla4xxx_alloc_fw_dump() calls dma_alloc_coherent() but does not
check its return value.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/scsi/qla4xxx/ql4_init.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 6f12f85..4180d6d 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -334,6 +334,12 @@ void qla4xxx_alloc_fw_dump(struct scsi_qla_host *ha)
 	/* Allocate memory for saving the template */
 	md_tmp = dma_alloc_coherent(&ha->pdev->dev, ha->fw_dump_tmplt_size,
 				    &md_tmp_dma, GFP_KERNEL);
+	if (!md_tmp) {
+		ql4_printk(KERN_INFO, ha,
+			   "scsi%ld: Failed to allocate DMA memory\n",
+			   ha->host_no);
+		return;
+	}
 
 	/* Request template */
 	status =  qla4xxx_get_minidump_template(ha, md_tmp_dma);
-- 
Maurizio Lombardi

