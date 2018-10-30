From: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Subject: [v1 2/2] mpt3sas: Add support to Aero PCI IDs.
Date: Tue, 30 Oct 2018 12:05:16 +0530
Message-ID: <1540881316-13577-3-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1540881316-13577-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1540881316-13577-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, Suganath Prabu <suganath-prabu.subramani@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Add support for Aero/Sea controllers and
add warning for configurable secure type IOC.

Signed-off-by: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index df56cbe..e13ff84 100644
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
@@ -10336,6 +10340,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		ioc->hba_mpi_version_belonged = hba_mpi_version;
 		ioc->id = mpt2_ids++;
 		sprintf(ioc->driver_name, "%s", MPT2SAS_DRIVER_NAME);
+		sprintf(ioc->name, "%s_cm%d", ioc->driver_name, ioc->id);
 		switch (pdev->device) {
 		case MPI2_MFGPAGE_DEVID_SSS6200:
 			ioc->is_warpdrive = 1;
@@ -10361,7 +10366,11 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		ioc->hba_mpi_version_belonged = hba_mpi_version;
 		ioc->id = mpt3_ids++;
 		sprintf(ioc->driver_name, "%s", MPT3SAS_DRIVER_NAME);
+		sprintf(ioc->name, "%s_cm%d", ioc->driver_name, ioc->id);
 		switch (pdev->device) {
+		case MPI26_MFGPAGE_DEVID_CFG_SEC_3816:
+		case MPI26_MFGPAGE_DEVID_CFG_SEC_3916:
+			ioc_warn(ioc, "HBA is in Configurable Secure mode\n");
 		case MPI26_MFGPAGE_DEVID_SAS3508:
 		case MPI26_MFGPAGE_DEVID_SAS3508_1:
 		case MPI26_MFGPAGE_DEVID_SAS3408:
@@ -10369,6 +10378,8 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		case MPI26_MFGPAGE_DEVID_SAS3516_1:
 		case MPI26_MFGPAGE_DEVID_SAS3416:
 		case MPI26_MFGPAGE_DEVID_SAS3616:
+		case MPI26_MFGPAGE_DEVID_HARD_SEC_3816:
+		case MPI26_MFGPAGE_DEVID_HARD_SEC_3916:
 			ioc->is_gen35_ioc = 1;
 			break;
 		default:
@@ -10437,8 +10448,6 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_LIST_HEAD(&ioc->delayed_tr_volume_list);
 	INIT_LIST_HEAD(&ioc->reply_queue_list);
 
-	sprintf(ioc->name, "%s_cm%d", ioc->driver_name, ioc->id);
-
 	/* init shost parameters */
 	shost->max_cmd_len = 32;
 	shost->max_lun = max_lun;
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
