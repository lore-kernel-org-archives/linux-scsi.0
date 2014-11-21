From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 05/10] esp_scsi: read status registers
Date: Fri, 21 Nov 2014 10:27:52 +0100
Message-ID: <1416562077-105715-6-git-send-email-hare@suse.de>
References: <1416562077-105715-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47160 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753877AbaKUJ2D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2014 04:28:03 -0500
In-Reply-To: <1416562077-105715-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

A read to ESP_INTRPT will clear ESP_STATUS and ESP_SSTEP. So read
all status registers in one go to avoid losing information.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/esp_scsi.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index fe3278e..92ab921 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -982,7 +982,6 @@ static int esp_check_spur_intr(struct esp *esp)
 
 	default:
 		if (!(esp->sreg & ESP_STAT_INTR)) {
-			esp->ireg = esp_read8(ESP_INTRPT);
 			if (esp->ireg & ESP_INTR_SR)
 				return 1;
 
@@ -2056,7 +2055,12 @@ static void __esp_interrupt(struct esp *esp)
 	int finish_reset, intr_done;
 	u8 phase;
 
+       /*
+	* Once INTRPT is read STATUS and SSTEP are cleared.
+	*/
 	esp->sreg = esp_read8(ESP_STATUS);
+	esp->seqreg = esp_read8(ESP_SSTEP);
+	esp->ireg = esp_read8(ESP_INTRPT);
 
 	if (esp->flags & ESP_FLAG_RESETTING) {
 		finish_reset = 1;
@@ -2069,8 +2073,6 @@ static void __esp_interrupt(struct esp *esp)
 			return;
 	}
 
-	esp->ireg = esp_read8(ESP_INTRPT);
-
 	if (esp->ireg & ESP_INTR_SR)
 		finish_reset = 1;
 
-- 
1.8.5.2

