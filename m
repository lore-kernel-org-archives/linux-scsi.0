From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 26/39] scsi: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:24:47 +0900
Message-ID: <002f01ceefb5$b09bc280$11d34780$%han@samsung.com>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:30576 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab3LBXYt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Dec 2013 18:24:49 -0500
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
is not preferred.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/scsi/BusLogic.c              |    2 +-
 drivers/scsi/be2iscsi/be_main.c      |    2 +-
 drivers/scsi/csiostor/csio_init.c    |    2 +-
 drivers/scsi/isci/init.c             |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |    2 +-
 drivers/scsi/mvumi.c                 |    2 +-
 drivers/scsi/ufs/ufshcd-pci.c        |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 972f817..64c7514 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -3893,7 +3893,7 @@ __setup("BusLogic=", blogic_setup);
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ }
 };*/
-static DEFINE_PCI_DEVICE_TABLE(blogic_pci_tbl) = {
+static const struct pci_device_id blogic_pci_tbl[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_MULTIMASTER)},
 	{PCI_DEVICE(PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_MULTIMASTER_NC)},
 	{PCI_DEVICE(PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_FLASHPOINT)},
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 1f37505..1f1f39d 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -534,7 +534,7 @@ static umode_t beiscsi_eth_get_attr_visibility(void *data, int type)
 }
 
 /*------------------- PCI Driver operations and data ----------------- */
-static DEFINE_PCI_DEVICE_TABLE(beiscsi_pci_id_table) = {
+static const struct pci_device_id beiscsi_pci_id_table[] = {
 	{ PCI_DEVICE(BE_VENDOR_ID, BE_DEVICE_ID1) },
 	{ PCI_DEVICE(BE_VENDOR_ID, BE_DEVICE_ID2) },
 	{ PCI_DEVICE(BE_VENDOR_ID, OC_DEVICE_ID1) },
diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
index 1aafc33..17794ad 100644
--- a/drivers/scsi/csiostor/csio_init.c
+++ b/drivers/scsi/csiostor/csio_init.c
@@ -1167,7 +1167,7 @@ static struct pci_error_handlers csio_err_handler = {
 	.resume		= csio_pci_resume,
 };
 
-static DEFINE_PCI_DEVICE_TABLE(csio_pci_tbl) = {
+static const struct pci_device_id csio_pci_tbl[] = {
 	CSIO_DEVICE(CSIO_DEVID_T440DBG_FCOE, 0),        /* T4 DEBUG FCOE */
 	CSIO_DEVICE(CSIO_DEVID_T420CR_FCOE, 0),		/* T420CR FCOE */
 	CSIO_DEVICE(CSIO_DEVID_T422CR_FCOE, 0),		/* T422CR FCOE */
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index d25d0d8..c457138 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -75,7 +75,7 @@ MODULE_VERSION(DRV_VERSION);
 
 static struct scsi_transport_template *isci_transport_template;
 
-static DEFINE_PCI_DEVICE_TABLE(isci_id_table) = {
+static const struct pci_device_id isci_id_table[] = {
 	{ PCI_VDEVICE(INTEL, 0x1D61),},
 	{ PCI_VDEVICE(INTEL, 0x1D63),},
 	{ PCI_VDEVICE(INTEL, 0x1D65),},
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index a961fe1..2834108 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -247,7 +247,7 @@ struct _scsi_io_transfer {
 /*
  * The pci device ids are defined in mpi/mpi2_cnfg.h.
  */
-static DEFINE_PCI_DEVICE_TABLE(scsih_pci_table) = {
+static const struct pci_device_id scsih_pci_table[] = {
 	/* Fury ~ 3004 and 3008 */
 	{ MPI2_MFGPAGE_VENDORID_LSI, MPI25_MFGPAGE_DEVID_SAS3004,
 		PCI_ANY_ID, PCI_ANY_ID },
diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index edbee8d..27e5986 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -48,7 +48,7 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("jyli@marvell.com");
 MODULE_DESCRIPTION("Marvell UMI Driver");
 
-static DEFINE_PCI_DEVICE_TABLE(mvumi_pci_table) = {
+static const struct pci_device_id mvumi_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, PCI_DEVICE_ID_MARVELL_MV9143) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, PCI_DEVICE_ID_MARVELL_MV9580) },
 	{ 0 }
diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index 8b95312..ff1f0c3 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -211,7 +211,7 @@ static const struct dev_pm_ops ufshcd_pci_pm_ops = {
 	.runtime_idle    = ufshcd_pci_runtime_idle,
 };
 
-static DEFINE_PCI_DEVICE_TABLE(ufshcd_pci_tbl) = {
+static const struct pci_device_id ufshcd_pci_tbl[] = {
 	{ PCI_VENDOR_ID_SAMSUNG, 0xC00C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
 	{ }	/* terminate list */
 };
-- 
1.7.10.4


