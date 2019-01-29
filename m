From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 2/4] mpt3sas: Add support for NVMe Switch Adapter
Date: Tue, 29 Jan 2019 07:14:41 -0500
Message-ID: <1548764083-5781-3-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1548764083-5781-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1548764083-5781-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Added device ID for NVMe Switch Adapter (Ambrosia).
VID: 0x1000
DID: 0x02B1

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h | 1 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
index a53a758..a2f4a55 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
@@ -549,6 +549,7 @@ typedef struct _MPI2_CONFIG_REPLY {
 #define MPI2_MFGPAGE_DEVID_SAS2308_2                (0x0087)
 #define MPI2_MFGPAGE_DEVID_SAS2308_3                (0x006E)
 #define MPI2_MFGPAGE_DEVID_SWITCH_MPI_EP            (0x02B0)
+#define MPI2_MFGPAGE_DEVID_SWITCH_MPI_EP_1          (0x02B1)
 
 /*MPI v2.5 SAS products */
 #define MPI25_MFGPAGE_DEVID_SAS3004                 (0x0096)
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index c3a0f70..4a73753 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -10257,6 +10257,7 @@ _scsih_determine_hba_mpi_version(struct pci_dev *pdev)
 	case MPI2_MFGPAGE_DEVID_SAS2308_2:
 	case MPI2_MFGPAGE_DEVID_SAS2308_3:
 	case MPI2_MFGPAGE_DEVID_SWITCH_MPI_EP:
+	case MPI2_MFGPAGE_DEVID_SWITCH_MPI_EP_1:
 		return MPI2_VERSION;
 	case MPI25_MFGPAGE_DEVID_SAS3004:
 	case MPI25_MFGPAGE_DEVID_SAS3008:
@@ -10344,6 +10345,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 			ioc->hide_ir_msg = 1;
 			break;
 		case MPI2_MFGPAGE_DEVID_SWITCH_MPI_EP:
+		case MPI2_MFGPAGE_DEVID_SWITCH_MPI_EP_1:
 			ioc->is_mcpu_endpoint = 1;
 			break;
 		default:
@@ -10785,6 +10787,8 @@ static const struct pci_device_id mpt3sas_pci_table[] = {
 		PCI_ANY_ID, PCI_ANY_ID },
 	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SWITCH_MPI_EP,
 		PCI_ANY_ID, PCI_ANY_ID },
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SWITCH_MPI_EP_1,
+		PCI_ANY_ID, PCI_ANY_ID },
 	/* SSS6200 */
 	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SSS6200,
 		PCI_ANY_ID, PCI_ANY_ID },
-- 
1.8.3.1
