From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 10/12] qla2xxx: Correct regression in DMA-mask setting prior to allocations.
Date: Thu, 22 Jan 2009 09:45:37 -0800
Message-ID: <1232646339-32503-11-git-send-email-andrew.vasquez@qlogic.com>
References: <1232646339-32503-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:46489 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758772AbZAVRp6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jan 2009 12:45:58 -0500
In-Reply-To: <1232646339-32503-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Jeremy Higdon noted
(http://marc.info/?l=linux-scsi&m=123262143131788&w=2) that the
rework done in commit e315cd28b9ef0d7b71e462ac16e18dbaa2f5adfe
was not setting the proper consistent and streaming DMA masks
prior to memory allocations.  Correct this and remove the
unnecessary prototype.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index f344b68..c11f872 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -65,8 +65,6 @@ MODULE_PARM_DESC(ql2xextended_error_logging,
 
 static void qla2x00_free_device(scsi_qla_host_t *);
 
-static void qla2x00_config_dma_addressing(scsi_qla_host_t *ha);
-
 int ql2xfdmienable=1;
 module_param(ql2xfdmienable, int, S_IRUGO|S_IRUSR);
 MODULE_PARM_DESC(ql2xfdmienable,
@@ -1242,9 +1240,8 @@ qla2x00_change_queue_type(struct scsi_device *sdev, int tag_type)
  * supported addressing method.
  */
 static void
-qla2x00_config_dma_addressing(scsi_qla_host_t *vha)
+qla2x00_config_dma_addressing(struct qla_hw_data *ha)
 {
-	struct qla_hw_data *ha = vha->hw;
 	/* Assume a 32bit DMA mask. */
 	ha->flags.enable_64bit_addressing = 0;
 
@@ -1870,6 +1867,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	set_bit(0, (unsigned long *) ha->vp_idx_map);
 
+	qla2x00_config_dma_addressing(ha);
 	ret = qla2x00_mem_alloc(ha, req_length, rsp_length, &req, &rsp);
 	if (!ret) {
 		qla_printk(KERN_WARNING, ha,
@@ -1896,8 +1894,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	pci_set_drvdata(pdev, base_vha);
 
-	qla2x00_config_dma_addressing(base_vha);
-
 	host = base_vha->host;
 	base_vha->req_ques[0] = req->id;
 	host->can_queue = req->length + 128;
-- 
1.6.1.48.ge9b8

