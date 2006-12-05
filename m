From: "Ed Lin" <ed.lin@promise.com>
Subject: [repost][PATCH 4/8] stex: adjust default queue length
Date: Mon, 4 Dec 2006 17:49:34 -0800
Message-ID: <NONAMEB0cWL0Wu33GOe00001571@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:18934 "EHLO
	nonameb.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S968011AbWLEBtK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Dec 2006 20:49:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: "James.Bottomley" <James.Bottomley@SteelEye.com>, jeff <jeff@garzik.org>, promise_linux <promise_linux@promise.com>


Firmware of new version may adjust default queue length. It is
backward compatible.

Signed-off-by: Ed Lin <ed.lin@promise.com>
---
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 92dbac0..a20cbd9 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -78,6 +78,7 @@ enum {
 
 	MU_MAX_DELAY_TIME			= 240000,
 	MU_HANDSHAKE_SIGNATURE			= 0x55aaaa55,
+	MU_HANDSHAKE_SIGNATURE_HALF		= 0x5a5a0000,
 	HMU_PARTNER_TYPE			= 2,
 
 	/* firmware returned values */
@@ -902,6 +903,7 @@ static int stex_handshake(struct st_hba 
 	void __iomem *base = hba->mmio_base;
 	struct handshake_frame *h;
 	dma_addr_t status_phys;
+	u32 data;
 	int i;
 
 	if (readl(base + OMR0) != MU_HANDSHAKE_SIGNATURE) {
@@ -923,6 +925,13 @@ static int stex_handshake(struct st_hba 
 
 	udelay(10);
 
+	data = readl(base + OMR1);
+	if ((data & 0xffff0000) == MU_HANDSHAKE_SIGNATURE_HALF) {
+		data &= 0x0000ffff;
+		if (hba->host->can_queue > data)
+			hba->host->can_queue = data;
+	}
+
 	h = (struct handshake_frame *)(hba->dma_mem + MU_REQ_BUFFER_SIZE);
 	h->rb_phy = cpu_to_le32(hba->dma_handle);
 	h->rb_phy_hi = cpu_to_le32((hba->dma_handle >> 16) >> 16);
@@ -1234,7 +1243,7 @@ stex_probe(struct pci_dev *pdev, const s
 	if (err)
 		goto out_free_irq;
 
-	err = scsi_init_shared_tag_map(host, ST_CAN_QUEUE);
+	err = scsi_init_shared_tag_map(host, host->can_queue);
 	if (err) {
 		printk(KERN_ERR DRV_NAME "(%s): init shared queue failed\n",
 			pci_name(pdev));


