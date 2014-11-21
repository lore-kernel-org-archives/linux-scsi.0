From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/10] am53c974: BLAST residual handling
Date: Fri, 21 Nov 2014 10:27:55 +0100
Message-ID: <1416562077-105715-9-git-send-email-hare@suse.de>
References: <1416562077-105715-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47161 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754611AbaKUJ2D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2014 04:28:03 -0500
In-Reply-To: <1416562077-105715-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The am53c974 has an design issue where a single byte might be
left in the SCSI FIFO after a DMA transfer.
As the handling code is currently untested add a WARN_ON()
statement here.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/am53c974.c |  6 ++++++
 drivers/scsi/esp_scsi.c | 29 +++++++++++++++++++++++++++++
 drivers/scsi/esp_scsi.h |  1 +
 3 files changed, 36 insertions(+)

diff --git a/drivers/scsi/am53c974.c b/drivers/scsi/am53c974.c
index 652762e..0b7643e 100644
--- a/drivers/scsi/am53c974.c
+++ b/drivers/scsi/am53c974.c
@@ -195,6 +195,12 @@ static void pci_esp_dma_drain(struct esp *esp)
 	shost_printk(KERN_INFO, esp->host,
 		     "DMA blast done (%d tries, %d bytes left)\n", lim, resid);
 #endif
+	/* BLAST residual handling is currently untested */
+	if (WARN_ON(resid == 1)) {
+		struct esp_cmd_entry *ent = esp->active_cmd;
+
+		ent->flags |= ESP_CMD_FLAG_RESIDUAL;
+	}
 }
 
 static void pci_esp_dma_invalidate(struct esp *esp)
diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index ab7d2bc..88272bb 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -1353,6 +1353,35 @@ static int esp_data_bytes_sent(struct esp *esp, struct esp_cmd_entry *ent,
 	bytes_sent = esp->data_dma_len;
 	bytes_sent -= ecount;
 
+	/*
+	 * The am53c974 has a DMA 'pecularity'. The doc states:
+	 * In some odd byte conditions, one residual byte will
+	 * be left in the SCSI FIFO, and the FIFO Flags will
+	 * never count to '0 '. When this happens, the residual
+	 * byte should be retrieved via PIO following completion
+	 * of the BLAST operation.
+	 */
+	if (fifo_cnt == 1 && ent->flags & ESP_CMD_FLAG_RESIDUAL) {
+		size_t count = 1;
+		size_t offset = bytes_sent;
+		u8 bval = esp_read8(ESP_FDATA);
+
+		if (ent->flags & ESP_CMD_FLAG_AUTOSENSE)
+			ent->sense_ptr[bytes_sent] = bval;
+		else {
+			struct esp_cmd_priv *p = ESP_CMD_PRIV(cmd);
+			u8 *ptr;
+
+			ptr = scsi_kmap_atomic_sg(p->cur_sg, p->u.num_sg,
+						  &offset, &count);
+			if (likely(ptr)) {
+				*(ptr + offset) = bval;
+				scsi_kunmap_atomic_sg(ptr);
+			}
+		}
+		bytes_sent += fifo_cnt;
+		ent->flags &= ~ESP_CMD_FLAG_RESIDUAL;
+	}
 	if (!(ent->flags & ESP_CMD_FLAG_WRITE))
 		bytes_sent -= fifo_cnt;
 
diff --git a/drivers/scsi/esp_scsi.h b/drivers/scsi/esp_scsi.h
index 27dcaf8..5fa456c 100644
--- a/drivers/scsi/esp_scsi.h
+++ b/drivers/scsi/esp_scsi.h
@@ -269,6 +269,7 @@ struct esp_cmd_entry {
 #define ESP_CMD_FLAG_WRITE	0x01 /* DMA is a write */
 #define ESP_CMD_FLAG_ABORT	0x02 /* being aborted */
 #define ESP_CMD_FLAG_AUTOSENSE	0x04 /* Doing automatic REQUEST_SENSE */
+#define ESP_CMD_FLAG_RESIDUAL	0x08 /* AM53c974 BLAST residual */
 
 	u8			tag[2];
 	u8			orig_tag[2];
-- 
1.8.5.2

