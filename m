From: Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH V4 2/2] scsi: ufshcd-pci: Add Intel CNL support
Date: Tue,  6 Jun 2017 14:35:31 +0300
Message-ID: <1496748931-17162-3-git-send-email-adrian.hunter@intel.com>
References: <1496748931-17162-1-git-send-email-adrian.hunter@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1496748931-17162-1-git-send-email-adrian.hunter@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Subhash Jadavani <subhashj@codeaurora.org>, Santosh Yaragnavi <santosh.sy@samsung.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Szymon Mielczarek <szymonx.mielczarek@intel.com>, Michal Potomski <michalx.potomski@intel.com>, Grzegorz Janca <grzegorz.janca@intel.com>
List-Id: linux-scsi@vger.kernel.org

Add PCI id and variant ops for Intel CNL UFS host controller.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/scsi/ufs/ufshcd-pci.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index 0dcff829f8b6..925b0ec7ec54 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -37,6 +37,41 @@
 #include <linux/pci.h>
 #include <linux/pm_runtime.h>
 
+static int ufs_intel_disable_lcc(struct ufs_hba *hba)
+{
+	u32 attr = UIC_ARG_MIB(PA_LOCAL_TX_LCC_ENABLE);
+	u32 lcc_enable = 0;
+
+	ufshcd_dme_get(hba, attr, &lcc_enable);
+	if (lcc_enable)
+		ufshcd_dme_set(hba, attr, 0);
+
+	return 0;
+}
+
+static int ufs_intel_link_startup_notify(struct ufs_hba *hba,
+					 enum ufs_notify_change_status status)
+{
+	int err = 0;
+
+	switch (status) {
+	case PRE_CHANGE:
+		err = ufs_intel_disable_lcc(hba);
+		break;
+	case POST_CHANGE:
+		break;
+	default:
+		break;
+	}
+
+	return err;
+}
+
+static struct ufs_hba_variant_ops ufs_intel_cnl_hba_vops = {
+	.name                   = "intel-pci",
+	.link_startup_notify	= ufs_intel_link_startup_notify,
+};
+
 #ifdef CONFIG_PM_SLEEP
 /**
  * ufshcd_pci_suspend - suspend power management function
@@ -139,6 +174,8 @@ static void ufshcd_pci_remove(struct pci_dev *pdev)
 		return err;
 	}
 
+	hba->vops = (struct ufs_hba_variant_ops *)id->driver_data;
+
 	err = ufshcd_init(hba, mmio_base, pdev->irq);
 	if (err) {
 		dev_err(&pdev->dev, "Initialization failed\n");
@@ -163,6 +200,7 @@ static void ufshcd_pci_remove(struct pci_dev *pdev)
 
 static const struct pci_device_id ufshcd_pci_tbl[] = {
 	{ PCI_VENDOR_ID_SAMSUNG, 0xC00C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
+	{ PCI_VDEVICE(INTEL, 0x9DFA), (kernel_ulong_t)&ufs_intel_cnl_hba_vops },
 	{ }	/* terminate list */
 };
 
-- 
1.9.1
