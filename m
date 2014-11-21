From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/12] esp: enable CONFIG2_FENAB for am53c974
Date: Fri, 21 Nov 2014 13:41:55 +0100
Message-ID: <1416573716-73890-12-git-send-email-hare@suse.de>
References: <1416573716-73890-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51591 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758274AbaKUMmD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2014 07:42:03 -0500
In-Reply-To: <1416573716-73890-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, "David S. Miller" <davem@davemloft.net>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

CONFIG2_FENAB ('feature enable') changed definition between chip
revisions, from 'Latch SCSI Phase' to 'Latch SCSI Phase, display
chip ID upon reset, and enable 24 bit addresses'.
So only enable it for am53c974 where we know what it's doing.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/am53c974.c | 41 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/esp_scsi.c |  2 ++
 2 files changed, 43 insertions(+)

diff --git a/drivers/scsi/am53c974.c b/drivers/scsi/am53c974.c
index 340cb2f..55622eb 100644
--- a/drivers/scsi/am53c974.c
+++ b/drivers/scsi/am53c974.c
@@ -17,6 +17,8 @@
 #define DRV_MODULE_NAME "am53c974"
 #define DRV_MODULE_VERSION "1.00"
 
+static bool am53c974_fenab = true;
+
 // #define ESP_DMA_DEBUG
 
 #define ESP_DMA_CMD 0x10
@@ -254,6 +256,8 @@ static void pci_esp_send_dma_cmd(struct esp *esp, u32 addr, u32 esp_count,
 
 	pci_esp_write8(esp, (esp_count >> 0) & 0xff, ESP_TCLOW);
 	pci_esp_write8(esp, (esp_count >> 8) & 0xff, ESP_TCMED);
+	if (esp->config2 & ESP_CONFIG2_FENAB)
+		pci_esp_write8(esp, (esp_count >> 16) & 0xff, ESP_TCHI);
 
 	pci_esp_write32(esp, esp_count, ESP_DMA_STC);
 	pci_esp_write32(esp, addr, ESP_DMA_SPA);
@@ -267,6 +271,33 @@ static void pci_esp_send_dma_cmd(struct esp *esp, u32 addr, u32 esp_count,
 	pci_esp_write8(esp, ESP_DMA_CMD_START | val, ESP_DMA_CMD);
 }
 
+static u32 pci_esp_dma_length_limit(struct esp *esp, u32 dma_addr, u32 dma_len)
+{
+	int dma_limit = 16;
+	u32 base, end;
+
+	/*
+	 * If CONFIG2_FENAB is set we can
+	 * handle up to 24 bit addresses
+	 */
+	if (esp->config2 & ESP_CONFIG2_FENAB)
+		dma_limit = 24;
+
+	if (dma_len > (1U << dma_limit))
+		dma_len = (1U << dma_limit);
+
+	/*
+	 * Prevent crossing a 24-bit address boundary.
+	 */
+	base = dma_addr & ((1U << 24) - 1U);
+	end = base + dma_len;
+	if (end > (1U << 24))
+		end = (1U <<24);
+	dma_len = end - base;
+
+	return dma_len;
+}
+
 static const struct esp_driver_ops pci_esp_ops = {
 	.esp_write8	=	pci_esp_write8,
 	.esp_read8	=	pci_esp_read8,
@@ -280,6 +311,7 @@ static const struct esp_driver_ops pci_esp_ops = {
 	.dma_invalidate	=	pci_esp_dma_invalidate,
 	.send_dma_cmd	=	pci_esp_send_dma_cmd,
 	.dma_error	=	pci_esp_dma_error,
+	.dma_length_limit =	pci_esp_dma_length_limit,
 };
 
 /*
@@ -417,6 +449,12 @@ static int pci_esp_probe_one(struct pci_dev *pdev,
 	 * DMA for command submission.
 	 */
 	esp->flags |= ESP_FLAG_USE_FIFO;
+	/*
+	 * Enable CONFIG2_FENAB to allow for large DMA transfers
+	 */
+	if (am53c974_fenab)
+		esp->config2 |= ESP_CONFIG2_FENAB;
+
 	pep->esp = esp;
 
 	if (pci_request_regions(pdev, DRV_MODULE_NAME)) {
@@ -535,5 +573,8 @@ MODULE_AUTHOR("Hannes Reinecke <hare@suse.de>");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_MODULE_VERSION);
 
+module_param(am53c974_fenab, bool, 0444);
+MODULE_PARM_DESC(am53c974_fenab, "Enable 24-bit DMA transfer sizes");
+
 module_init(am53c974_module_init);
 module_exit(am53c974_module_exit);
diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index bd17516..56f361e 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -1343,6 +1343,8 @@ static int esp_data_bytes_sent(struct esp *esp, struct esp_cmd_entry *ent,
 			  (((unsigned int)esp_read8(ESP_TCMED)) << 8));
 		if (esp->rev == FASHME)
 			ecount |= ((unsigned int)esp_read8(FAS_RLO)) << 16;
+		if (esp->rev == PCSCSI && (esp->config2 & ESP_CONFIG2_FENAB))
+			ecount |= ((unsigned int)esp_read8(ESP_TCHI)) << 16;
 	}
 
 	bytes_sent = esp->data_dma_len;
-- 
1.8.5.2

