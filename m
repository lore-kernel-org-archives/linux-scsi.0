From: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 2/2] mpt3sas: Add support to Aero PCI IDs.
Date: Thu, 25 Oct 2018 15:40:49 +0530
Message-ID: <1540462249-9984-3-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1540462249-9984-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1540462249-9984-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, Suganath Prabu <suganath-prabu.subramani@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Add support for Aero/Sea controllers and
add warning for configurable secure type IOC.

Signed-off-by: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  1 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 7fdaf29..b11f5f5 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -55,6 +55,7 @@
 #include "mpi/mpi2_tool.h"
 #include "mpi/mpi2_sas.h"
 #include "mpi/mpi2_pci.h"
+#include "mpi/mpi2_image.h"
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index df56cbe..5001439 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -10284,6 +10284,10 @@ _scsih_determine_hba_mpi_version(struct pci_dev *pdev)
 	case MPI26_MFGPAGE_DEVID_SAS3516_1:
 	case MPI26_MFGPAGE_DEVID_SAS3416:
 	case MPI26_MFGPAGE_DEVID_SAS3616:
+	case MPI26_MFGPAGE_DEVID_CFG_SEC_3916:
+	case MPI26_MFGPAGE_DEVID_HARD_SEC_3916:
+	case MPI26_MFGPAGE_DEVID_CFG_SEC_3816:
+	case MPI26_MFGPAGE_DEVID_HARD_SEC_3816:
 		return MPI26_VERSION;
 	}
 	return 0;
@@ -10369,6 +10373,11 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		case MPI26_MFGPAGE_DEVID_SAS3516_1:
 		case MPI26_MFGPAGE_DEVID_SAS3416:
 		case MPI26_MFGPAGE_DEVID_SAS3616:
+		case MPI26_MFGPAGE_DEVID_CFG_SEC_3816:
+		case MPI26_MFGPAGE_DEVID_CFG_SEC_3916:
+			ioc_warn(ioc, "HBA is in Configurable Secure mode\n");
+		case MPI26_MFGPAGE_DEVID_HARD_SEC_3816:
+		case MPI26_MFGPAGE_DEVID_HARD_SEC_3916:
 			ioc->is_gen35_ioc = 1;
 			break;
 		default:
@@ -10830,6 +10839,23 @@ static const struct pci_device_id mpt3sas_pci_table[] = {
 	/* Mercator ~ 3616*/
 	{ MPI2_MFGPAGE_VENDORID_LSI, MPI26_MFGPAGE_DEVID_SAS3616,
 		PCI_ANY_ID, PCI_ANY_ID },
+
+	/* Aero SI 0x00E1 Configurable Secure
+	 * 0x00E2 Hard Secure
+	 */
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI26_MFGPAGE_DEVID_CFG_SEC_3916,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI26_MFGPAGE_DEVID_HARD_SEC_3916,
+		PCI_ANY_ID, PCI_ANY_ID },
+
+	/* Sea SI 0x00E5 Configurable Secure
+	 * 0x00E6 Hard Secure
+	 */
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI26_MFGPAGE_DEVID_CFG_SEC_3816,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI26_MFGPAGE_DEVID_HARD_SEC_3816,
+		PCI_ANY_ID, PCI_ANY_ID },
+
 	{0}     /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(pci, mpt3sas_pci_table);
-- 
1.8.3.1
