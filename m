From: James Smart <james.smart@emulex.com>
Subject: [PATCH 4/7] lpfc 8.3.13: Misc fixes
Date: Wed, 12 May 2010 09:31:59 -0400
Message-ID: <1273671144.24670.20.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:16386 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753982Ab0ELNcq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2010 09:32:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


- Change the Max receive size on CIN FCFs to 0x800
- (From linux community) Check boundary before checking for NULL.
- Update last completion time for completed I/O to prevent heartbeat.
- Add Balius PCI Device IDs

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hw.h    |    1 +
 lpfc_init.c  |    6 ++++++
 lpfc_sli.c   |    4 ++++
 lpfc_sli4.h  |    2 +-
 lpfc_vport.c |    2 +-
 5 files changed, 13 insertions(+), 2 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2010-05-12 09:03:12.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2010-05-12 09:03:52.000000000 -0400
@@ -1170,6 +1170,7 @@ typedef struct {
 #define PCI_DEVICE_ID_TIGERSHARK    0x0704
 #define PCI_DEVICE_ID_TOMCAT        0x0714
 #define PCI_DEVICE_ID_FALCON        0xf180
+#define PCI_DEVICE_ID_BALIUS        0xe131
 
 #define JEDEC_ID_ADDRESS            0x0080001c
 #define FIREFLY_JEDEC_ID            0x1ACC
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-05-12 09:03:12.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-05-12 09:03:52.000000000 -0400
@@ -1826,6 +1826,10 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 		m = (typeof(m)){"LPSe12002-ML1-E", "PCIe",
 				"EmulexSecure Fibre"};
 		break;
+	case PCI_DEVICE_ID_BALIUS:
+		m = (typeof(m)){"LPVe12002", "PCIe Shared I/O",
+				"Fibre Channel Adapter"};
+		break;
 	default:
 		m = (typeof(m)){"Unknown", "", ""};
 		break;
@@ -8835,6 +8839,8 @@ static struct pci_device_id lpfc_id_tabl
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_FALCON,
 		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_BALIUS,
+		PCI_ANY_ID, PCI_ANY_ID, },
 	{ 0 }
 };
 
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2010-05-05 08:52:38.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2010-05-12 09:03:41.000000000 -0400
@@ -58,7 +58,7 @@
 #define LPFC_FCOE_FCF_MAP0	0x0E
 #define LPFC_FCOE_FCF_MAP1	0xFC
 #define LPFC_FCOE_FCF_MAP2	0x00
-#define LPFC_FCOE_MAX_RCV_SIZE	0x5AC
+#define LPFC_FCOE_MAX_RCV_SIZE	0x800
 #define LPFC_FCOE_FKA_ADV_PER	0
 #define LPFC_FCOE_FIP_PRIORITY	0x80
 
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-05-12 09:02:39.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-05-12 09:03:41.000000000 -0400
@@ -9194,6 +9194,7 @@ lpfc_sli4_fp_handle_wcqe(struct lpfc_hba
 {
 	struct lpfc_wcqe_release wcqe;
 	bool workposted = false;
+	unsigned long iflag;
 
 	/* Copy the work queue CQE and convert endian order if needed */
 	lpfc_sli_pcimem_bcopy(cqe, &wcqe, sizeof(struct lpfc_cqe));
@@ -9202,6 +9203,9 @@ lpfc_sli4_fp_handle_wcqe(struct lpfc_hba
 	switch (bf_get(lpfc_wcqe_c_code, &wcqe)) {
 	case CQE_CODE_COMPL_WQE:
 		/* Process the WQ complete event */
+		spin_lock_irqsave(&phba->hbalock, iflag);
+		phba->last_completion_time = jiffies;
+		spin_unlock_irqrestore(&phba->hbalock, iflag);
 		lpfc_sli4_fp_handle_fcp_wcqe(phba,
 				(struct lpfc_wcqe_complete *)&wcqe);
 		break;
diff -upNr a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
--- a/drivers/scsi/lpfc/lpfc_vport.c	2010-05-05 08:52:38.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_vport.c	2010-05-12 09:03:41.000000000 -0400
@@ -782,7 +782,7 @@ lpfc_destroy_vport_work_array(struct lpf
 	int i;
 	if (vports == NULL)
 		return;
-	for (i = 0; vports[i] != NULL && i <= phba->max_vports; i++)
+	for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++)
 		scsi_host_put(lpfc_shost_from_vport(vports[i]));
 	kfree(vports);
 }


