From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH RESEND 10/25] mpt3sas: Manage MSIX vectors according to HBA device type
Date: Wed, 11 Nov 2015 17:30:26 +0530
Message-ID: <1447243241-10912-11-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, chaitra.basappa@avagotech.com, suganath-prabu.subramani@avagotech.com, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>

1. Don't enable MSI-X vector for SAS2008 B0 controller,
2. Enable only single MSI-X vectors for below HBA's
   a. SAS2004
   b. SAS2008
   c. SAS2008_1
   d. SAS2008_2
   e. SAS2008_3
   f. SAS2116_1
   g. SAS2116_2
3. Enable Combined Reply Post Queue Support (i.e. 96 MSI-X vector)
   for only Gen3 Invader/Fury C0 and above revision HBA's
4. Enable Combined Reply Post Queue Support (i.e. 96 MSI-X vector)
   for all Intruder and Cutlass HBA's

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  | 39 +++++++++++++++++++-----------------
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  3 +++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  7 +++++++
 3 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 62dc312..2b33e48 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1712,6 +1712,14 @@ _base_check_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 	int base;
 	u16 message_control;
 
+	/* Check whether controller SAS2008 B0 controller,
+	 * if it is SAS2008 B0 controller use IO-APIC instead of MSIX
+	 */
+	if (ioc->pdev->device == MPI2_MFGPAGE_DEVID_SAS2008 &&
+	    ioc->pdev->revision == SAS2_PCI_DEVICE_B0_REVISION) {
+		return -EINVAL;
+	}
+
 	base = pci_find_capability(ioc->pdev, PCI_CAP_ID_MSIX);
 	if (!base) {
 		dfailprintk(ioc, pr_info(MPT3SAS_FMT "msix not supported\n",
@@ -1720,9 +1728,19 @@ _base_check_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 	}
 
 	/* get msix vector count */
-
-	pci_read_config_word(ioc->pdev, base + 2, &message_control);
-	ioc->msix_vector_count = (message_control & 0x3FF) + 1;
+	/* NUMA_IO not supported for older controllers */
+	if (ioc->pdev->device == MPI2_MFGPAGE_DEVID_SAS2004 ||
+	    ioc->pdev->device == MPI2_MFGPAGE_DEVID_SAS2008 ||
+	    ioc->pdev->device == MPI2_MFGPAGE_DEVID_SAS2108_1 ||
+	    ioc->pdev->device == MPI2_MFGPAGE_DEVID_SAS2108_2 ||
+	    ioc->pdev->device == MPI2_MFGPAGE_DEVID_SAS2108_3 ||
+	    ioc->pdev->device == MPI2_MFGPAGE_DEVID_SAS2116_1 ||
+	    ioc->pdev->device == MPI2_MFGPAGE_DEVID_SAS2116_2)
+		ioc->msix_vector_count = 1;
+	else {
+		pci_read_config_word(ioc->pdev, base + 2, &message_control);
+		ioc->msix_vector_count = (message_control & 0x3FF) + 1;
+	}
 	dinitprintk(ioc, pr_info(MPT3SAS_FMT
 		"msix is supported, vector_count(%d)\n",
 		ioc->name, ioc->msix_vector_count));
@@ -4979,7 +4997,6 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 {
 	int r, i;
 	int cpu_id, last_cpu_id = 0;
-	u8 revision;
 
 	dinitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
 	    __func__));
@@ -4999,20 +5016,6 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 		goto out_free_resources;
 	}
 
-	/* Check whether the controller revision is C0 or above.
-	 * only C0 and above revision controllers support 96 MSI-X vectors.
-	 */
-	revision = ioc->pdev->revision;
-
-	if ((ioc->pdev->device == MPI25_MFGPAGE_DEVID_SAS3004 ||
-	     ioc->pdev->device == MPI25_MFGPAGE_DEVID_SAS3008 ||
-	     ioc->pdev->device == MPI25_MFGPAGE_DEVID_SAS3108_1 ||
-	     ioc->pdev->device == MPI25_MFGPAGE_DEVID_SAS3108_2 ||
-	     ioc->pdev->device == MPI25_MFGPAGE_DEVID_SAS3108_5 ||
-	     ioc->pdev->device == MPI25_MFGPAGE_DEVID_SAS3108_6) &&
-	     (revision >= 0x02))
-		ioc->msix96_vector = 1;
-
 	ioc->rdpq_array_enable_assigned = 0;
 	ioc->dma_mask = 0;
 	r = mpt3sas_base_map_resources(ioc);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 4c9a154..08f46a7 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -142,6 +142,9 @@
 #define MPT_TARGET_FLAGS_DELETED	0x04
 #define MPT_TARGET_FASTPATH_IO		0x08
 
+#define SAS2_PCI_DEVICE_B0_REVISION	(0x01)
+#define SAS3_PCI_DEVICE_C0_REVISION	(0x02)
+
 /*
  * Intel HBA branding
  */
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 80469d0..2b51a41 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -7938,6 +7938,13 @@ _scsih_determine_hba_mpi_version(struct MPT3SAS_ADAPTER *ioc) {
 	case MPI25_MFGPAGE_DEVID_SAS3108_5:
 	case MPI25_MFGPAGE_DEVID_SAS3108_6:
 		ioc->hba_mpi_version_belonged = MPI25_VERSION;
+
+		/* Check whether the controller revision is C0 or above.
+		 * only C0 and above revision controllers support 96 MSI-X
+		 * vectors.
+		 */
+		if (ioc->pdev->revision >= SAS3_PCI_DEVICE_C0_REVISION)
+			ioc->msix96_vector = 1;
 		break;
 	}
 }
-- 
2.0.2
