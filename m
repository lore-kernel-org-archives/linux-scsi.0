From: James Smart <james.smart@emulex.com>
Subject: [PATCH 3/6] lpfc 8.3.7: Fix hardware/SLI relates issues
Date: Mon, 21 Dec 2009 17:02:28 -0500
Message-ID: <1261432968.12238.14.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:38078 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755710AbZLUWIN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2009 17:08:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix hardware/SLI relates issues:
- Fix CNA uses more than one EQ when in INTx interrupt mode.
- Fix driver tries to process failed read FCF record mailbox request.
- Fix allocating single receive buffer breaks FCoE receive queue.
- Support new read FCF record mailbox error case.

Signed-off-by: James Smart <james.smart@emulex.com>

---

 drivers/scsi/lpfc/lpfc_hbadisc.c |   14 ++++++++++----
 drivers/scsi/lpfc/lpfc_hw4.h     |    1 +
 drivers/scsi/lpfc/lpfc_init.c    |    3 +++
 drivers/scsi/lpfc/lpfc_sli.c     |   27 +++++++++++++++------------
 drivers/scsi/lpfc/lpfc_sli4.h    |    2 +-
 5 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 401167d..f40b960 100755
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1555,10 +1555,16 @@ lpfc_mbx_cmpl_read_fcf_record(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	 * to book keeping the FCFIs can be used.
 	 */
 	if (shdr_status || shdr_add_status) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"2521 READ_FCF_RECORD mailbox failed "
-				"with status x%x add_status x%x, mbx\n",
-				shdr_status, shdr_add_status);
+		if (shdr_status == STATUS_FCF_TABLE_EMPTY) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"2726 READ_FCF_RECORD Indicates empty "
+					"FCF table.\n");
+		} else {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"2521 READ_FCF_RECORD mailbox failed "
+					"with status x%x add_status x%x, mbx\n",
+					shdr_status, shdr_add_status);
+		}
 		goto out;
 	}
 	/* Interpreting the returned information of FCF records */
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
old mode 100644
new mode 100755
index 09c8e36..8a2a1c5
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -1371,6 +1371,7 @@ struct lpfc_mbx_query_fw_cfg {
 #define STATUS_ERROR_ACITMAIN				0x2a
 #define STATUS_REBOOT_REQUIRED				0x2c
 #define STATUS_FCF_IN_USE				0x3a
+#define STATUS_FCF_TABLE_EMPTY				0x43
 
 struct lpfc_mbx_sli4_config {
 	struct mbox_header header;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index d4da6bd..7083ef3 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7507,6 +7507,9 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 			error = -ENODEV;
 			goto out_free_sysfs_attr;
 		}
+		/* Default to single FCP EQ for non-MSI-X */
+		if (phba->intr_type != MSIX)
+			phba->cfg_fcp_eq_count = 1;
 		/* Set up SLI-4 HBA */
 		if (lpfc_sli4_hba_setup(phba)) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 50f72bf..589549b 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1383,7 +1383,7 @@ lpfc_sli_hbq_to_firmware_s4(struct lpfc_hba *phba, uint32_t hbqno,
 /* HBQ for ELS and CT traffic. */
 static struct lpfc_hbq_init lpfc_els_hbq = {
 	.rn = 1,
-	.entry_count = 200,
+	.entry_count = 256,
 	.mask_count = 0,
 	.profile = 0,
 	.ring_mask = (1 << LPFC_ELS_RING),
@@ -1482,8 +1482,11 @@ err:
 int
 lpfc_sli_hbqbuf_add_hbqs(struct lpfc_hba *phba, uint32_t qno)
 {
-	return(lpfc_sli_hbqbuf_fill_hbqs(phba, qno,
-					 lpfc_hbq_defs[qno]->add_count));
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		return 0;
+	else
+		return lpfc_sli_hbqbuf_fill_hbqs(phba, qno,
+					 lpfc_hbq_defs[qno]->add_count);
 }
 
 /**
@@ -1498,8 +1501,12 @@ lpfc_sli_hbqbuf_add_hbqs(struct lpfc_hba *phba, uint32_t qno)
 static int
 lpfc_sli_hbqbuf_init_hbqs(struct lpfc_hba *phba, uint32_t qno)
 {
-	return(lpfc_sli_hbqbuf_fill_hbqs(phba, qno,
-					 lpfc_hbq_defs[qno]->init_count));
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		return lpfc_sli_hbqbuf_fill_hbqs(phba, qno,
+					 lpfc_hbq_defs[qno]->entry_count);
+	else
+		return lpfc_sli_hbqbuf_fill_hbqs(phba, qno,
+					 lpfc_hbq_defs[qno]->init_count);
 }
 
 /**
@@ -4110,6 +4117,7 @@ lpfc_sli4_read_rev(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq,
 	if (rc) {
 		dma_free_coherent(&phba->pcidev->dev, dma_size,
 				  dmabuf->virt, dmabuf->phys);
+		kfree(dmabuf);
 		return -EIO;
 	}
 
@@ -11409,14 +11417,9 @@ lpfc_sli4_handle_received_buffer(struct lpfc_hba *phba,
 		return;
 	}
 	/* If not last frame in sequence continue processing frames. */
-	if (!lpfc_seq_complete(seq_dmabuf)) {
-		/*
-		 * When saving off frames post a new one and mark this
-		 * frame to be freed when it is finished.
-		 **/
-		lpfc_sli_hbqbuf_fill_hbqs(phba, LPFC_ELS_HBQ, 1);
+	if (!lpfc_seq_complete(seq_dmabuf))
 		return;
-	}
+
 	/* Send the complete sequence to the upper layer protocol */
 	lpfc_sli4_send_seq_to_ulp(vport, seq_dmabuf);
 }
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 25d66d0..44e5f57 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -28,7 +28,7 @@
 /* Multi-queue arrangement for fast-path FCP work queues */
 #define LPFC_FN_EQN_MAX       8
 #define LPFC_SP_EQN_DEF       1
-#define LPFC_FP_EQN_DEF       1
+#define LPFC_FP_EQN_DEF       4
 #define LPFC_FP_EQN_MIN       1
 #define LPFC_FP_EQN_MAX       (LPFC_FN_EQN_MAX - LPFC_SP_EQN_DEF)
 
-- 
1.6.5.2



