From: "Ed Lin" <ed.lin@promise.com>
Subject: [PATCH 2/5] stex:add MSI support
Date: Tue, 31 Mar 2009 17:30:25 -0800
Message-ID: <200903311730249316892@promise.com>
Reply-To: ed.lin@promise.com
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway.promise.com ([67.111.72.2]:21550 "EHLO
	nonamew.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752316AbZDAApj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Mar 2009 20:45:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, promise_linux <promise_linux@promise.com>

This adds the MSI support (default 0=off)

Signed-off-by: Ed Lin <ed.lin@promise.com>
---

 drivers/scsi/stex.c |   48 +++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 43 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index de6c30e..c4eb5c1 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -292,11 +292,15 @@ struct st_hba {
 	struct st_ccb *wait_ccb;
 
 	unsigned int mu_status;
-	int out_req_cnt;
-
 	unsigned int cardtype;
+	int msi_enabled;
+	int out_req_cnt;
 };
 
+static int msi;
+module_param(msi, int, 0);
+MODULE_PARM_DESC(msi, "Enable Message Signaled Interrupts(0=off, 1=on)");
+
 static const char console_inq_page[] =
 {
 	0x03,0x00,0x03,0x03,0xFA,0x00,0x00,0x30,
@@ -1041,6 +1045,40 @@ static int stex_set_dma_mask(struct pci_dev * pdev)
 	return ret;
 }
 
+static int stex_request_irq(struct st_hba *hba)
+{
+	struct pci_dev *pdev = hba->pdev;
+	int status;
+
+	if (msi) {
+		status = pci_enable_msi(pdev);
+		if (status != 0)
+			printk(KERN_ERR DRV_NAME
+				"(%s): error %d setting up MSI\n",
+				pci_name(pdev), status);
+		else
+			hba->msi_enabled = 1;
+	} else
+		hba->msi_enabled = 0;
+
+	status = request_irq(pdev->irq, stex_intr, IRQF_SHARED, DRV_NAME, hba);
+
+	if (status != 0) {
+		if (hba->msi_enabled)
+			pci_disable_msi(pdev);
+	}
+	return status;
+}
+
+static void stex_free_irq(struct st_hba *hba)
+{
+	struct pci_dev *pdev = hba->pdev;
+
+	free_irq(pdev->irq, hba);
+	if (hba->msi_enabled)
+		pci_disable_msi(pdev);
+}
+
 static int __devinit
 stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
@@ -1125,7 +1163,7 @@ stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	hba->host = host;
 	hba->pdev = pdev;
 
-	err = request_irq(pdev->irq, stex_intr, IRQF_SHARED, DRV_NAME, hba);
+	err = stex_request_irq(hba);
 	if (err) {
 		printk(KERN_ERR DRV_NAME "(%s): request irq failed\n",
 			pci_name(pdev));
@@ -1157,7 +1195,7 @@ stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 out_free_irq:
-	free_irq(pdev->irq, hba);
+	stex_free_irq(hba);
 out_pci_free:
 	dma_free_coherent(&pdev->dev, hba->dma_size,
 			  hba->dma_mem, hba->dma_handle);
@@ -1216,7 +1254,7 @@ static void stex_hba_stop(struct st_hba *hba)
 
 static void stex_hba_free(struct st_hba *hba)
 {
-	free_irq(hba->pdev->irq, hba);
+	stex_free_irq(hba);
 
 	iounmap(hba->mmio_base);
 


