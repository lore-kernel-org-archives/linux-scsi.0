From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH][RESEND] esp_scsi: remove check for ESP_MAX_TAGS
Date: Fri,  2 Jan 2015 15:18:13 +0100
Message-ID: <1420208293-96647-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47503 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbbABOSQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Jan 2015 09:18:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

'num_tags' is an unsigned char, so the check for 'ESP_MAX_TAGS'
(which is set to 256) is pointless.

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/esp_scsi.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index ce5bd52..065b25d 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2396,8 +2396,6 @@ int scsi_esp_register(struct esp *esp, struct device *dev)
 
 	if (!esp->num_tags)
 		esp->num_tags = ESP_DEFAULT_TAGS;
-	else if (esp->num_tags >= ESP_MAX_TAG)
-		esp->num_tags = ESP_MAX_TAG - 1;
 	esp->host->transportt = esp_transport_template;
 	esp->host->max_lun = ESP_MAX_LUN;
 	esp->host->cmd_per_lun = 2;
-- 
1.8.4.5

