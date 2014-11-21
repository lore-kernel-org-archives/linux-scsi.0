From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/10] esp: Use FIFO for command submission
Date: Fri, 21 Nov 2014 10:27:54 +0100
Message-ID: <1416562077-105715-8-git-send-email-hare@suse.de>
References: <1416562077-105715-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47172 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757176AbaKUJ2F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2014 04:28:05 -0500
In-Reply-To: <1416562077-105715-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The am53c974 has a design flaw causing it to throw an
DMA interrupt whenever a DMA transmission completed,
even though DMA interrupt reporting is disabled.
This confuses the esp routines as it would register
a DMA interrupt whenever a cdb has been transmitted
to the drive.
So implement an option to use the FIFO for command
submission and enable it for am53c974.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/am53c974.c |  1 +
 drivers/scsi/esp_scsi.c | 83 ++++++++++++++++++++++++++++++++++++++-----------
 drivers/scsi/esp_scsi.h |  1 +
 3 files changed, 66 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/am53c974.c b/drivers/scsi/am53c974.c
index b9af8b0..652762e 100644
--- a/drivers/scsi/am53c974.c
+++ b/drivers/scsi/am53c974.c
@@ -401,6 +401,7 @@ static int pci_esp_probe_one(struct pci_dev *pdev,
 	esp->host = shost;
 	esp->dev = pdev;
 	esp->ops = &pci_esp_ops;
+	esp->flags |= ESP_FLAG_USE_FIFO;
 	pep->esp = esp;
 
 	if (pci_request_regions(pdev, DRV_MODULE_NAME)) {
diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 92ab921..ab7d2bc 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -605,7 +605,7 @@ static void esp_autosense(struct esp *esp, struct esp_cmd_entry *ent)
 {
 	struct scsi_cmnd *cmd = ent->cmd;
 	struct scsi_device *dev = cmd->device;
-	int tgt, lun;
+	int tgt, lun, i;
 	u8 *p, val;
 
 	tgt = dev->id;
@@ -626,7 +626,10 @@ static void esp_autosense(struct esp *esp, struct esp_cmd_entry *ent)
 
 	esp->active_cmd = ent;
 
-	p = esp->command_block;
+	if (esp->flags & ESP_FLAG_USE_FIFO)
+		p = esp->fifo;
+	else
+		p = esp->command_block;
 	esp->msg_out_len = 0;
 
 	*p++ = IDENTIFY(0, lun);
@@ -648,12 +651,21 @@ static void esp_autosense(struct esp *esp, struct esp_cmd_entry *ent)
 	esp_write_tgt_sync(esp, tgt);
 	esp_write_tgt_config3(esp, tgt);
 
-	val = (p - esp->command_block);
+	if (esp->flags & ESP_FLAG_USE_FIFO)
+		val = (p - esp->fifo);
+	else
+		val = (p - esp->command_block);
 
 	if (esp->rev == FASHME)
 		scsi_esp_cmd(esp, ESP_CMD_FLUSH);
-	esp->ops->send_dma_cmd(esp, esp->command_block_dma,
-			       val, 16, 0, ESP_CMD_DMA | ESP_CMD_SELA);
+	if (esp->flags & ESP_FLAG_USE_FIFO) {
+		scsi_esp_cmd(esp, ESP_CMD_FLUSH);
+		for (i = 0; i < val; i++)
+			esp_write8(esp->fifo[i], ESP_FDATA);
+		scsi_esp_cmd(esp, ESP_CMD_SELA);
+	} else
+		esp->ops->send_dma_cmd(esp, esp->command_block_dma,
+				       val, 16, 0, ESP_CMD_DMA | ESP_CMD_SELA);
 }
 
 static struct esp_cmd_entry *find_and_prep_issuable_command(struct esp *esp)
@@ -727,7 +739,10 @@ static void esp_maybe_execute_command(struct esp *esp)
 
 	esp_check_command_len(esp, cmd);
 
-	p = esp->command_block;
+	if (esp->flags & ESP_FLAG_USE_FIFO)
+		p = esp->fifo;
+	else
+		p = esp->command_block;
 
 	esp->msg_out_len = 0;
 	if (tp->flags & ESP_TGT_CHECK_NEGO) {
@@ -789,13 +804,15 @@ build_identify:
 	}
 
 	if (!(esp->flags & ESP_FLAG_DOING_SLOWCMD)) {
-		start_cmd = ESP_CMD_DMA | ESP_CMD_SELA;
+		start_cmd = ESP_CMD_SELA;
 		if (ent->tag[0]) {
 			*p++ = ent->tag[0];
 			*p++ = ent->tag[1];
 
-			start_cmd = ESP_CMD_DMA | ESP_CMD_SA3;
+			start_cmd = ESP_CMD_SA3;
 		}
+		if (!(esp->flags & ESP_FLAG_USE_FIFO))
+			start_cmd |= ESP_CMD_DMA;
 
 		for (i = 0; i < cmd->cmd_len; i++)
 			*p++ = cmd->cmnd[i];
@@ -814,7 +831,9 @@ build_identify:
 			esp->msg_out_len += 2;
 		}
 
-		start_cmd = ESP_CMD_DMA | ESP_CMD_SELAS;
+		start_cmd = ESP_CMD_SELAS;
+		if (!(esp->flags & ESP_FLAG_USE_FIFO))
+			start_cmd |= ESP_CMD_DMA;
 		esp->select_state = ESP_SELECT_MSGOUT;
 	}
 	val = tgt;
@@ -825,7 +844,10 @@ build_identify:
 	esp_write_tgt_sync(esp, tgt);
 	esp_write_tgt_config3(esp, tgt);
 
-	val = (p - esp->command_block);
+	if (esp->flags & ESP_FLAG_USE_FIFO)
+		val = (p - esp->fifo);
+	else
+		val = (p - esp->command_block);
 
 	if (esp_debug & ESP_DEBUG_SCSICMD) {
 		printk("ESP: tgt[%d] lun[%d] scsi_cmd [ ", tgt, lun);
@@ -836,8 +858,17 @@ build_identify:
 
 	if (esp->rev == FASHME)
 		scsi_esp_cmd(esp, ESP_CMD_FLUSH);
-	esp->ops->send_dma_cmd(esp, esp->command_block_dma,
-			       val, 16, 0, start_cmd);
+
+	if (esp->flags & ESP_FLAG_USE_FIFO) {
+		scsi_esp_cmd(esp, ESP_CMD_FLUSH);
+		for (i = 0; i < val; i++)
+			esp_write8(esp->fifo[i], ESP_FDATA);
+
+		scsi_esp_cmd(esp, start_cmd);
+	} else {
+		esp->ops->send_dma_cmd(esp, esp->command_block_dma,
+				       val, 16, 0, start_cmd);
+	}
 }
 
 static struct esp_cmd_entry *esp_get_ent(struct esp *esp)
@@ -1646,7 +1677,7 @@ static int esp_msgin_process(struct esp *esp)
 
 static int esp_process_event(struct esp *esp)
 {
-	int write;
+	int write, i;
 
 again:
 	write = 0;
@@ -1872,6 +1903,10 @@ again:
 			if (esp->msg_out_len == 1) {
 				esp_write8(esp->msg_out[0], ESP_FDATA);
 				scsi_esp_cmd(esp, ESP_CMD_TI);
+			} else if (esp->flags & ESP_FLAG_USE_FIFO) {
+				for (i = 0; i < esp->msg_out_len; i++)
+					esp_write8(esp->msg_out[i], ESP_FDATA);
+				scsi_esp_cmd(esp, ESP_CMD_TI);
 			} else {
 				/* Use DMA. */
 				memcpy(esp->command_block,
@@ -1947,13 +1982,23 @@ again:
 		}
 		break;
 	case ESP_EVENT_CMD_START:
-		memcpy(esp->command_block, esp->cmd_bytes_ptr,
-		       esp->cmd_bytes_left);
-		if (esp->rev == FASHME)
+		if (esp->flags & ESP_FLAG_USE_FIFO) {
 			scsi_esp_cmd(esp, ESP_CMD_FLUSH);
-		esp->ops->send_dma_cmd(esp, esp->command_block_dma,
-				       esp->cmd_bytes_left, 16, 0,
-				       ESP_CMD_DMA | ESP_CMD_TI);
+			while (esp->cmd_bytes_left) {
+				esp_write8(esp->cmd_bytes_ptr[0], ESP_FDATA);
+				esp->cmd_bytes_ptr++;
+				esp->cmd_bytes_left--;
+			}
+			scsi_esp_cmd(esp, ESP_CMD_TI);
+		} else {
+			memcpy(esp->command_block, esp->cmd_bytes_ptr,
+			       esp->cmd_bytes_left);
+			if (esp->rev == FASHME)
+				scsi_esp_cmd(esp, ESP_CMD_FLUSH);
+			esp->ops->send_dma_cmd(esp, esp->command_block_dma,
+					       esp->cmd_bytes_left, 16, 0,
+					       ESP_CMD_DMA | ESP_CMD_TI);
+		}
 		esp_event(esp, ESP_EVENT_CMD_DONE);
 		esp->flags |= ESP_FLAG_QUICKIRQ_CHECK;
 		break;
diff --git a/drivers/scsi/esp_scsi.h b/drivers/scsi/esp_scsi.h
index 975d293..27dcaf8 100644
--- a/drivers/scsi/esp_scsi.h
+++ b/drivers/scsi/esp_scsi.h
@@ -478,6 +478,7 @@ struct esp {
 #define ESP_FLAG_WIDE_CAPABLE	0x00000008
 #define ESP_FLAG_QUICKIRQ_CHECK	0x00000010
 #define ESP_FLAG_DISABLE_SYNC	0x00000020
+#define ESP_FLAG_USE_FIFO	0x00000040
 
 	u8			select_state;
 #define ESP_SELECT_NONE		0x00 /* Not selecting */
-- 
1.8.5.2

