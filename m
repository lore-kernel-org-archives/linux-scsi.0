From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 1/2] bfa: firmware download fix
Date: Wed, 13 Apr 2011 12:09:05 -0700
Message-ID: <1302721745-4487-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:44160 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752502Ab1DMTJP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Apr 2011 15:09:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, Jing Huang <huangj@brocade.com>

This patch includes fixes for two issues releated to firmware download
implementation: 1) Merged memory leak fix provided by Jesper Juhl
<jj@chaosbits.net>. Basically we need to call release_firmware() after
request_firmware(). 2) fixed issues with the firmware download interface
as pointed out by Rolf Eike Beer <eike@sf-mail.de> in linux-scsi. Rearranged
the code and fixed related function protypes.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfad.c    |   39 +++++++++++++++++++++++++++++----------
 drivers/scsi/bfa/bfad_im.h |   25 -------------------------
 2 files changed, 29 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 44524cf..00d92ae 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -57,9 +57,19 @@ int		pcie_max_read_reqsz;
 int		bfa_debugfs_enable = 1;
 int		msix_disable_cb = 0, msix_disable_ct = 0;
 
+/* Firmware releated */
 u32	bfi_image_ct_fc_size, bfi_image_ct_cna_size, bfi_image_cb_fc_size;
 u32     *bfi_image_ct_fc, *bfi_image_ct_cna, *bfi_image_cb_fc;
 
+#define BFAD_FW_FILE_CT_FC      "ctfw_fc.bin"
+#define BFAD_FW_FILE_CT_CNA     "ctfw_cna.bin"
+#define BFAD_FW_FILE_CB_FC      "cbfw_fc.bin"
+
+static u32 *bfad_load_fwimg(struct pci_dev *pdev);
+static void bfad_free_fwimg(void);
+static void bfad_read_firmware(struct pci_dev *pdev, u32 **bfi_image,
+		u32 *bfi_image_size, char *fw_name);
+
 static const char *msix_name_ct[] = {
 	"cpe0", "cpe1", "cpe2", "cpe3",
 	"rme0", "rme1", "rme2", "rme3",
@@ -1550,7 +1560,7 @@ bfad_exit(void)
 }
 
 /* Firmware handling */
-u32 *
+static void
 bfad_read_firmware(struct pci_dev *pdev, u32 **bfi_image,
 		u32 *bfi_image_size, char *fw_name)
 {
@@ -1558,27 +1568,25 @@ bfad_read_firmware(struct pci_dev *pdev, u32 **bfi_image,
 
 	if (request_firmware(&fw, fw_name, &pdev->dev)) {
 		printk(KERN_ALERT "Can't locate firmware %s\n", fw_name);
-		goto error;
+		*bfi_image = NULL;
+		goto out;
 	}
 
 	*bfi_image = vmalloc(fw->size);
 	if (NULL == *bfi_image) {
 		printk(KERN_ALERT "Fail to allocate buffer for fw image "
 			"size=%x!\n", (u32) fw->size);
-		goto error;
+		goto out;
 	}
 
 	memcpy(*bfi_image, fw->data, fw->size);
 	*bfi_image_size = fw->size/sizeof(u32);
-
-	return *bfi_image;
-
-error:
-	return NULL;
+out:
+	release_firmware(fw);
 }
 
-u32 *
-bfad_get_firmware_buf(struct pci_dev *pdev)
+static u32 *
+bfad_load_fwimg(struct pci_dev *pdev)
 {
 	if (pdev->device == BFA_PCI_DEVICE_ID_CT_FC) {
 		if (bfi_image_ct_fc_size == 0)
@@ -1598,6 +1606,17 @@ bfad_get_firmware_buf(struct pci_dev *pdev)
 	}
 }
 
+static void
+bfad_free_fwimg(void)
+{
+	if (bfi_image_ct_fc_size && bfi_image_ct_fc)
+		vfree(bfi_image_ct_fc);
+	if (bfi_image_ct_cna_size && bfi_image_ct_cna)
+		vfree(bfi_image_ct_cna);
+	if (bfi_image_cb_fc_size && bfi_image_cb_fc)
+		vfree(bfi_image_cb_fc);
+}
+
 module_init(bfad_init);
 module_exit(bfad_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/bfa/bfad_im.h b/drivers/scsi/bfa/bfad_im.h
index bfee63b..c296c89 100644
--- a/drivers/scsi/bfa/bfad_im.h
+++ b/drivers/scsi/bfa/bfad_im.h
@@ -141,29 +141,4 @@ extern struct device_attribute *bfad_im_vport_attrs[];
 
 irqreturn_t bfad_intx(int irq, void *dev_id);
 
-/* Firmware releated */
-#define BFAD_FW_FILE_CT_FC      "ctfw_fc.bin"
-#define BFAD_FW_FILE_CT_CNA     "ctfw_cna.bin"
-#define BFAD_FW_FILE_CB_FC      "cbfw_fc.bin"
-
-u32 *bfad_get_firmware_buf(struct pci_dev *pdev);
-u32 *bfad_read_firmware(struct pci_dev *pdev, u32 **bfi_image,
-		u32 *bfi_image_size, char *fw_name);
-
-static inline u32 *
-bfad_load_fwimg(struct pci_dev *pdev)
-{
-	return bfad_get_firmware_buf(pdev);
-}
-
-static inline void
-bfad_free_fwimg(void)
-{
-	if (bfi_image_ct_fc_size && bfi_image_ct_fc)
-		vfree(bfi_image_ct_fc);
-	if (bfi_image_ct_cna_size && bfi_image_ct_cna)
-		vfree(bfi_image_ct_cna);
-	if (bfi_image_cb_fc_size && bfi_image_cb_fc)
-		vfree(bfi_image_cb_fc);
-}
 #endif
-- 
1.6.5.2

