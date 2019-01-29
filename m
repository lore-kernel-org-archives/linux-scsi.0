From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 3/4] mpt3sas: Add support for ATLAS PCIe switch.
Date: Tue, 29 Jan 2019 07:14:42 -0500
Message-ID: <1548764083-5781-4-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1548764083-5781-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1548764083-5781-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Add Atlas PCIe Switch Management Port device PNPID,
Vendor Id: 0x1000
device Id: 0x00B2

This device is based on MPI 2.6 spec and it exposes one
SES device to accept management commands for the PCIe switch.

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h  | 3 +++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 8003519..db12c1b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -193,6 +193,9 @@ struct mpt3sas_nvme_cmd {
 #define SAS2_PCI_DEVICE_B0_REVISION	(0x01)
 #define SAS3_PCI_DEVICE_C0_REVISION	(0x02)
 
+/* Atlas PCIe Switch Management Port */
+#define MPI26_ATLAS_PCIe_SWITCH_DEVID	(0x00B2)
+
 /*
  * Intel HBA branding
  */
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 4a73753..8bb5b8f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -10283,6 +10283,7 @@ _scsih_determine_hba_mpi_version(struct pci_dev *pdev)
 	case MPI26_MFGPAGE_DEVID_SAS3516_1:
 	case MPI26_MFGPAGE_DEVID_SAS3416:
 	case MPI26_MFGPAGE_DEVID_SAS3616:
+	case MPI26_ATLAS_PCIe_SWITCH_DEVID:
 	case MPI26_MFGPAGE_DEVID_CFG_SEC_3916:
 	case MPI26_MFGPAGE_DEVID_HARD_SEC_3916:
 	case MPI26_MFGPAGE_DEVID_CFG_SEC_3816:
@@ -10373,6 +10374,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		case MPI26_MFGPAGE_DEVID_SAS3516_1:
 		case MPI26_MFGPAGE_DEVID_SAS3416:
 		case MPI26_MFGPAGE_DEVID_SAS3616:
+		case MPI26_ATLAS_PCIe_SWITCH_DEVID:
 			ioc->is_gen35_ioc = 1;
 			break;
 		case MPI26_MFGPAGE_DEVID_CFG_SEC_3816:
@@ -10853,6 +10855,10 @@ static const struct pci_device_id mpt3sas_pci_table[] = {
 	{ MPI2_MFGPAGE_VENDORID_LSI, MPI26_MFGPAGE_DEVID_HARD_SEC_3916,
 		PCI_ANY_ID, PCI_ANY_ID },
 
+	/* Atlas PCIe Switch Management Port */
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI26_ATLAS_PCIe_SWITCH_DEVID,
+		PCI_ANY_ID, PCI_ANY_ID },
+
 	/* Sea SI 0x00E5 Configurable Secure
 	 * 0x00E6 Hard Secure
 	 */
-- 
1.8.3.1
