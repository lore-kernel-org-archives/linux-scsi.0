From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/10] esp_scsi: make number of tags configurable
Date: Fri, 21 Nov 2014 10:27:49 +0100
Message-ID: <1416562077-105715-3-git-send-email-hare@suse.de>
References: <1416562077-105715-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47173 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbaKUJ2F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2014 04:28:05 -0500
In-Reply-To: <1416562077-105715-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Add a field 'num_tags' to the esp structure to allow drivers
to overwrite the number of avialable tags if required.
Default is ESP_DEFAULT_TAGS.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/esp_scsi.c | 10 ++++------
 drivers/scsi/esp_scsi.h |  3 +--
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 38c23e0..99cd42f 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2317,6 +2317,8 @@ int scsi_esp_register(struct esp *esp, struct device *dev)
 	static int instance;
 	int err;
 
+	if (!esp->num_tags)
+		esp->num_tags = ESP_DEFAULT_TAGS;
 	esp->host->transportt = esp_transport_template;
 	esp->host->max_lun = ESP_MAX_LUN;
 	esp->host->cmd_per_lun = 2;
@@ -2403,12 +2405,8 @@ static int esp_slave_configure(struct scsi_device *dev)
 	struct esp *esp = shost_priv(dev->host);
 	struct esp_target_data *tp = &esp->target[dev->id];
 
-	if (dev->tagged_supported) {
-		/* XXX make this configurable somehow XXX */
-		int goal_tags = min(ESP_DEFAULT_TAGS, ESP_MAX_TAG);
-
-		scsi_adjust_queue_depth(dev, goal_tags);
-	}
+	if (dev->tagged_supported)
+		scsi_adjust_queue_depth(dev, esp->num_tags);
 
 	tp->flags |= ESP_TGT_DISCONNECT;
 
diff --git a/drivers/scsi/esp_scsi.h b/drivers/scsi/esp_scsi.h
index b5862e4..975d293 100644
--- a/drivers/scsi/esp_scsi.h
+++ b/drivers/scsi/esp_scsi.h
@@ -283,7 +283,6 @@ struct esp_cmd_entry {
 	struct completion	*eh_done;
 };
 
-/* XXX make this configurable somehow XXX */
 #define ESP_DEFAULT_TAGS	16
 
 #define ESP_MAX_TARGET		16
@@ -445,7 +444,7 @@ struct esp {
 	u8			prev_soff;
 	u8			prev_stp;
 	u8			prev_cfg3;
-	u8			__pad;
+	u8			num_tags;
 
 	struct list_head	esp_cmd_pool;
 
-- 
1.8.5.2

