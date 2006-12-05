From: "Ed Lin" <ed.lin@promise.com>
Subject: [repost][PATCH 6/8] stex: add new device type support
Date: Mon, 4 Dec 2006 17:49:39 -0800
Message-ID: <NONAMEB2BS7QTDVd94w00001573@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:18934 "EHLO
	nonameb.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S968013AbWLEBtO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Dec 2006 20:49:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: "james.Bottomley" <james.Bottomley@SteelEye.com>, jeff <jeff@garzik.org>, promise_linux <promise_linux@promise.com>


Add support for st_vsc1 type device (st_vsc is ok because it does not
require extra buffer).

Signed-off-by: Ed Lin <ed.lin@promise.com>
---
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 0fd115c..bfd7983 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -121,7 +121,8 @@ enum {
 
 	st_shasta				= 0,
 	st_vsc					= 1,
-	st_yosemite				= 2,
+	st_vsc1					= 2,
+	st_yosemite				= 3,
 
 	PASSTHRU_REQ_TYPE			= 0x00000001,
 	PASSTHRU_REQ_NO_WAKEUP			= 0x00000100,
@@ -151,6 +152,8 @@ enum {
 	MGT_CMD_SIGNATURE			= 0xba,
 
 	INQUIRY_EVPD				= 0x01,
+
+	ST_ADDITIONAL_MEM			= 0x200000,
 };
 
 /* SCSI inquiry data */
@@ -212,7 +215,9 @@ struct handshake_frame {
 	__le32 partner_ver_minor;
 	__le32 partner_ver_oem;
 	__le32 partner_ver_build;
-	u32 reserved1[4];
+	__le32 extra_offset;	/* NEW */
+	__le32 extra_size;	/* NEW */
+	u32 reserved1[2];
 };
 
 struct req_msg {
@@ -303,6 +308,7 @@ struct st_hba {
 	void __iomem *mmio_base;	/* iomapped PCI memory space */
 	void *dma_mem;
 	dma_addr_t dma_handle;
+	size_t dma_size;
 
 	struct Scsi_Host *host;
 	struct pci_dev *pdev;
@@ -941,6 +947,11 @@ static int stex_handshake(struct st_hba 
 	h->status_cnt = cpu_to_le16(MU_STATUS_COUNT);
 	stex_gettime(&h->hosttime);
 	h->partner_type = HMU_PARTNER_TYPE;
+	if (hba->dma_size > STEX_BUFFER_SIZE) {
+		h->extra_offset = cpu_to_le32(STEX_BUFFER_SIZE);
+		h->extra_size = cpu_to_le32(ST_ADDITIONAL_MEM);
+	} else
+		h->extra_offset = h->extra_size = 0;
 
 	status_phys = hba->dma_handle + MU_REQ_BUFFER_SIZE;
 	writel(status_phys, base + IMR0);
@@ -1203,8 +1214,13 @@ stex_probe(struct pci_dev *pdev, const s
 		goto out_iounmap;
 	}
 
+	hba->cardtype = (unsigned int) id->driver_data;
+	if (hba->cardtype == st_vsc && (pdev->subsystem_device & 0xf) == 0x1)
+		hba->cardtype = st_vsc1;
+	hba->dma_size = (hba->cardtype == st_vsc1) ?
+		(STEX_BUFFER_SIZE + ST_ADDITIONAL_MEM) : (STEX_BUFFER_SIZE);
 	hba->dma_mem = dma_alloc_coherent(&pdev->dev,
-		STEX_BUFFER_SIZE, &hba->dma_handle, GFP_KERNEL);
+		hba->dma_size, &hba->dma_handle, GFP_KERNEL);
 	if (!hba->dma_mem) {
 		err = -ENOMEM;
 		printk(KERN_ERR DRV_NAME "(%s): dma mem alloc failed\n",
@@ -1217,8 +1233,6 @@ stex_probe(struct pci_dev *pdev, const s
 	hba->copy_buffer = hba->dma_mem + MU_BUFFER_SIZE;
 	hba->mu_status = MU_STATE_STARTING;
 
-	hba->cardtype = (unsigned int) id->driver_data;
-
 	/* firmware uses id/lun pair for a logical drive, but lun would be
 	   always 0 if CONFIG_SCSI_MULTI_LUN not configured, so we use
 	   channel to map lun here */
@@ -1266,7 +1280,7 @@ stex_probe(struct pci_dev *pdev, const s
 out_free_irq:
 	free_irq(pdev->irq, hba);
 out_pci_free:
-	dma_free_coherent(&pdev->dev, STEX_BUFFER_SIZE,
+	dma_free_coherent(&pdev->dev, hba->dma_size,
 			  hba->dma_mem, hba->dma_handle);
 out_iounmap:
 	iounmap(hba->mmio_base);
@@ -1327,7 +1341,7 @@ static void stex_hba_free(struct st_hba 
 
 	pci_release_regions(hba->pdev);
 
-	dma_free_coherent(&hba->pdev->dev, STEX_BUFFER_SIZE,
+	dma_free_coherent(&hba->pdev->dev, hba->dma_size,
 			  hba->dma_mem, hba->dma_handle);
 }
 


