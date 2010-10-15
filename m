From: madhu.iyengar@qlogic.com
Subject: [PATCH 09/12] qla2xxx: Addition of shutdown callback handler.
Date: Fri, 15 Oct 2010 11:27:46 -0700
Message-ID: <1287167269-8034-10-git-send-email-madhu.iyengar@qlogic.com>
References: <1287167269-8034-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36966 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1756420Ab0JOSg3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Oct 2010 14:36:29 -0400
In-Reply-To: <1287167269-8034-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>

From: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>

This patch adds a shutdown handler to qla2xxx driver to make sure that all
DMA and firmware activities are stopped, and any associated driver resources
are released. The need for this handler arose when executing kexec in specific
environments caused the data of the 2nd kernel to be corrupted, due to DMA
activities.

Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    7 +++
 drivers/scsi/qla2xxx/qla_os.c   |   82 +++++++++++++++++++++++++++++++-------
 2 files changed, 74 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 77c68a7..a7ad22b 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1344,6 +1344,13 @@ cont_alloc:
 		qla_printk(KERN_WARNING, ha, "Unable to allocate (%d KB) for "
 		    "firmware dump!!!\n", dump_size / 1024);
 
+		if (ha->fce) {
+			dma_free_coherent(&ha->pdev->dev, FCE_SIZE, ha->fce,
+			    ha->fce_dma);
+			ha->fce = NULL;
+			ha->fce_dma = 0;
+		}
+
 		if (ha->eft) {
 			dma_free_coherent(&ha->pdev->dev, eft_size, ha->eft,
 			    ha->eft_dma);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8e40e27..c9f9ed3 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -260,6 +260,7 @@ static void qla2x00_rst_aen(scsi_qla_host_t *);
 
 static int qla2x00_mem_alloc(struct qla_hw_data *, uint16_t, uint16_t,
 	struct req_que **, struct rsp_que **);
+static void qla2x00_free_fw_dump(struct qla_hw_data *);
 static void qla2x00_mem_free(struct qla_hw_data *);
 static void qla2x00_sp_free_dma(srb_t *);
 
@@ -2342,6 +2343,42 @@ probe_out:
 }
 
 static void
+qla2x00_shutdown(struct pci_dev *pdev)
+{
+	scsi_qla_host_t *vha;
+	struct qla_hw_data  *ha;
+
+	vha = pci_get_drvdata(pdev);
+	ha = vha->hw;
+
+	/* Turn-off FCE trace */
+	if (ha->flags.fce_enabled) {
+		qla2x00_disable_fce_trace(vha, NULL, NULL);
+		ha->flags.fce_enabled = 0;
+	}
+
+	/* Turn-off EFT trace */
+	if (ha->eft)
+		qla2x00_disable_eft_trace(vha);
+
+	/* Stop currently executing firmware. */
+	qla2x00_try_to_stop_firmware(vha);
+
+	/* Turn adapter off line */
+	vha->flags.online = 0;
+
+	/* turn-off interrupts on the card */
+	if (ha->interrupts_on) {
+		vha->flags.init_done = 0;
+		ha->isp_ops->disable_intrs(ha);
+	}
+
+	qla2x00_free_irqs(vha);
+
+	qla2x00_free_fw_dump(ha);
+}
+
+static void
 qla2x00_remove_one(struct pci_dev *pdev)
 {
 	scsi_qla_host_t *base_vha, *vha;
@@ -2830,28 +2867,48 @@ fail:
 }
 
 /*
-* qla2x00_mem_free
-*      Frees all adapter allocated memory.
+* qla2x00_free_fw_dump
+*	Frees fw dump stuff.
 *
 * Input:
-*      ha = adapter block pointer.
+*	ha = adapter block pointer.
 */
 static void
-qla2x00_mem_free(struct qla_hw_data *ha)
+qla2x00_free_fw_dump(struct qla_hw_data *ha)
 {
-	if (ha->srb_mempool)
-		mempool_destroy(ha->srb_mempool);
-
 	if (ha->fce)
 		dma_free_coherent(&ha->pdev->dev, FCE_SIZE, ha->fce,
-		ha->fce_dma);
+		    ha->fce_dma);
 
 	if (ha->fw_dump) {
 		if (ha->eft)
 			dma_free_coherent(&ha->pdev->dev,
-			ntohl(ha->fw_dump->eft_size), ha->eft, ha->eft_dma);
+			    ntohl(ha->fw_dump->eft_size), ha->eft, ha->eft_dma);
 		vfree(ha->fw_dump);
 	}
+	ha->fce = NULL;
+	ha->fce_dma = 0;
+	ha->eft = NULL;
+	ha->eft_dma = 0;
+	ha->fw_dump = NULL;
+	ha->fw_dumped = 0;
+	ha->fw_dump_reading = 0;
+}
+
+/*
+* qla2x00_mem_free
+*      Frees all adapter allocated memory.
+*
+* Input:
+*      ha = adapter block pointer.
+*/
+static void
+qla2x00_mem_free(struct qla_hw_data *ha)
+{
+	qla2x00_free_fw_dump(ha);
+
+	if (ha->srb_mempool)
+		mempool_destroy(ha->srb_mempool);
 
 	if (ha->dcbx_tlv)
 		dma_free_coherent(&ha->pdev->dev, DCBX_TLV_DATA_SIZE,
@@ -2925,8 +2982,6 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 
 	ha->srb_mempool = NULL;
 	ha->ctx_mempool = NULL;
-	ha->eft = NULL;
-	ha->eft_dma = 0;
 	ha->sns_cmd = NULL;
 	ha->sns_cmd_dma = 0;
 	ha->ct_sns = NULL;
@@ -2946,10 +3001,6 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 
 	ha->gid_list = NULL;
 	ha->gid_list_dma = 0;
-
-	ha->fw_dump = NULL;
-	ha->fw_dumped = 0;
-	ha->fw_dump_reading = 0;
 }
 
 struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
@@ -4049,6 +4100,7 @@ static struct pci_driver qla2xxx_pci_driver = {
 	.id_table	= qla2xxx_pci_tbl,
 	.probe		= qla2x00_probe_one,
 	.remove		= qla2x00_remove_one,
+	.shutdown	= qla2x00_shutdown,
 	.err_handler	= &qla2xxx_err_handler,
 };
 
-- 
1.6.0.2

