From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/10] esp_scsi: debug event and command
Date: Fri, 21 Nov 2014 10:27:51 +0100
Message-ID: <1416562077-105715-5-git-send-email-hare@suse.de>
References: <1416562077-105715-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47159 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754699AbaKUJ2D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2014 04:28:03 -0500
In-Reply-To: <1416562077-105715-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Add new debug definitions for event and command logging.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/esp_scsi.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 492c51b..fe3278e 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -49,6 +49,8 @@ static u32 esp_debug;
 #define ESP_DEBUG_DATADONE	0x00000100
 #define ESP_DEBUG_RECONNECT	0x00000200
 #define ESP_DEBUG_AUTOSENSE	0x00000400
+#define ESP_DEBUG_EVENT		0x00000800
+#define ESP_DEBUG_COMMAND	0x00001000
 
 #define esp_log_intr(f, a...) \
 do {	if (esp_debug & ESP_DEBUG_INTR) \
@@ -100,6 +102,16 @@ do {	if (esp_debug & ESP_DEBUG_AUTOSENSE) \
 		shost_printk(KERN_DEBUG, esp->host, f, ## a);	\
 } while (0)
 
+#define esp_log_event(f, a...) \
+do {   if (esp_debug & ESP_DEBUG_EVENT)	\
+		shost_printk(KERN_DEBUG, esp->host, f, ## a);	\
+} while (0)
+
+#define esp_log_command(f, a...) \
+do {   if (esp_debug & ESP_DEBUG_COMMAND)	\
+		shost_printk(KERN_DEBUG, esp->host, f, ## a);	\
+} while (0)
+
 #define esp_read8(REG)		esp->ops->esp_read8(esp, REG)
 #define esp_write8(VAL,REG)	esp->ops->esp_write8(esp, VAL, REG)
 
@@ -126,6 +138,7 @@ void scsi_esp_cmd(struct esp *esp, u8 val)
 
 	esp->esp_event_cur = (idx + 1) & (ESP_EVENT_LOG_SZ - 1);
 
+	esp_log_command("cmd[%02x]\n", val);
 	esp_write8(val, ESP_CMD);
 }
 EXPORT_SYMBOL(scsi_esp_cmd);
@@ -1638,6 +1651,8 @@ static int esp_process_event(struct esp *esp)
 
 again:
 	write = 0;
+	esp_log_event("process event %d phase %x\n",
+		      esp->event, esp->sreg & ESP_STAT_PMASK);
 	switch (esp->event) {
 	case ESP_EVENT_CHECK_PHASE:
 		switch (esp->sreg & ESP_STAT_PMASK) {
-- 
1.8.5.2

