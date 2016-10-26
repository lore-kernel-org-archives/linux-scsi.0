From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v2 06/11] mpt3sas: Added Device ID's for SAS35 devices and updated MPI header.
Date: Wed, 26 Oct 2016 13:34:37 +0530
Message-ID: <1477469082-32395-7-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1477469082-32395-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1477469082-32395-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com, Sathya Prakash <sathya.prakash@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Added Device ID's for SAS35 devices (Ventura, Crusader, Harpoon &
Tomcat) and updated mpi header file for the same. Also added
"is_gen35_ioc" to MPT3SAS_ADAPTER structure for identifying SAS35 adapters.

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h |  7 +++++++
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  1 +
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   |  5 ++++-
 drivers/scsi/mpt3sas/mpt3sas_ctl.h   |  1 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 31 +++++++++++++++++++++++++++++++
 5 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
index 95356a8..fa61baf 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
@@ -478,6 +478,13 @@ typedef struct _MPI2_CONFIG_REPLY {
 #define MPI26_MFGPAGE_DEVID_SAS3324_3               (0x00C2)
 #define MPI26_MFGPAGE_DEVID_SAS3324_4               (0x00C3)
 
+#define MPI26_MFGPAGE_DEVID_SAS3516                 (0x00AA)
+#define MPI26_MFGPAGE_DEVID_SAS3516_1               (0x00AB)
+#define MPI26_MFGPAGE_DEVID_SAS3416                 (0x00AC)
+#define MPI26_MFGPAGE_DEVID_SAS3508                 (0x00AD)
+#define MPI26_MFGPAGE_DEVID_SAS3508_1               (0x00AE)
+#define MPI26_MFGPAGE_DEVID_SAS3408                 (0x00AF)
+
 /*Manufacturing Page 0 */
 
 typedef struct _MPI2_CONFIG_PAGE_MAN_0 {
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 6f03a86..3d75c57 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1191,6 +1191,7 @@ struct MPT3SAS_ADAPTER {
 	struct SL_WH_MPI_TRIGGERS_T diag_trigger_mpi;
 	void		*device_remove_in_progress;
 	u16		device_remove_in_progress_sz;
+	u8		is_gen35_ioc;
 };
 
 typedef u8 (*MPT_CALLBACK)(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index de720c9..a287bfb 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -1096,7 +1096,10 @@ _ctl_getiocinfo(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 		break;
 	case MPI25_VERSION:
 	case MPI26_VERSION:
-		karg.adapter_type = MPT3_IOCTL_INTERFACE_SAS3;
+		if (ioc->is_gen35_ioc)
+			karg.adapter_type = MPT3_IOCTL_INTERFACE_SAS35;
+		else
+			karg.adapter_type = MPT3_IOCTL_INTERFACE_SAS3;
 		strcat(karg.driver_version, MPT3SAS_DRIVER_VERSION);
 		break;
 	}
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.h b/drivers/scsi/mpt3sas/mpt3sas_ctl.h
index 8940835..f3e17a8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.h
@@ -143,6 +143,7 @@ struct mpt3_ioctl_pci_info {
 #define MPT2_IOCTL_INTERFACE_SAS2	(0x04)
 #define MPT2_IOCTL_INTERFACE_SAS2_SSS6200	(0x05)
 #define MPT3_IOCTL_INTERFACE_SAS3	(0x06)
+#define MPT3_IOCTL_INTERFACE_SAS35	(0x07)
 #define MPT2_IOCTL_VERSION_LENGTH	(32)
 
 /**
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 9584d6b..521849d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -8660,6 +8660,12 @@ _scsih_determine_hba_mpi_version(struct pci_dev *pdev)
 	case MPI26_MFGPAGE_DEVID_SAS3324_2:
 	case MPI26_MFGPAGE_DEVID_SAS3324_3:
 	case MPI26_MFGPAGE_DEVID_SAS3324_4:
+	case MPI26_MFGPAGE_DEVID_SAS3508:
+	case MPI26_MFGPAGE_DEVID_SAS3508_1:
+	case MPI26_MFGPAGE_DEVID_SAS3408:
+	case MPI26_MFGPAGE_DEVID_SAS3516:
+	case MPI26_MFGPAGE_DEVID_SAS3516_1:
+	case MPI26_MFGPAGE_DEVID_SAS3416:
 		return MPI26_VERSION;
 	}
 	return 0;
@@ -8728,6 +8734,18 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		ioc->hba_mpi_version_belonged = hba_mpi_version;
 		ioc->id = mpt3_ids++;
 		sprintf(ioc->driver_name, "%s", MPT3SAS_DRIVER_NAME);
+		switch (pdev->device) {
+		case MPI26_MFGPAGE_DEVID_SAS3508:
+		case MPI26_MFGPAGE_DEVID_SAS3508_1:
+		case MPI26_MFGPAGE_DEVID_SAS3408:
+		case MPI26_MFGPAGE_DEVID_SAS3516:
+		case MPI26_MFGPAGE_DEVID_SAS3516_1:
+		case MPI26_MFGPAGE_DEVID_SAS3416:
+			ioc->is_gen35_ioc = 1;
+			break;
+		default:
+			ioc->is_gen35_ioc = 0;
+		}
 		if ((ioc->hba_mpi_version_belonged == MPI25_VERSION &&
 			pdev->revision >= SAS3_PCI_DEVICE_C0_REVISION) ||
 			(ioc->hba_mpi_version_belonged == MPI26_VERSION))
@@ -9134,6 +9152,19 @@ static const struct pci_device_id mpt3sas_pci_table[] = {
 		PCI_ANY_ID, PCI_ANY_ID },
 	{ MPI2_MFGPAGE_VENDORID_LSI, MPI26_MFGPAGE_DEVID_SAS3324_4,
 		PCI_ANY_ID, PCI_ANY_ID },
+	/* Ventura, Crusader, Harpoon & Tomcat ~ 3516, 3416, 3508 & 3408*/
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI26_MFGPAGE_DEVID_SAS3508,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI26_MFGPAGE_DEVID_SAS3508_1,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI26_MFGPAGE_DEVID_SAS3408,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI26_MFGPAGE_DEVID_SAS3516,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI26_MFGPAGE_DEVID_SAS3516_1,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI26_MFGPAGE_DEVID_SAS3416,
+		PCI_ANY_ID, PCI_ANY_ID },
 	{0}     /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(pci, mpt3sas_pci_table);
-- 
2.4.3
