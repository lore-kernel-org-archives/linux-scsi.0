From: David Miller <davem@davemloft.net>
Subject: [PATCH]: Fix ESP instance numbering.
Date: Fri, 24 Aug 2007 22:25:58 -0700 (PDT)
Message-ID: <20070824.222558.105816330.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33639
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754332AbXHYFZ7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Aug 2007 01:25:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com


Because the ->unique_id is set too late, the ESP scsi host
instance numbers in the kernel log during probing are
wrong.

Bug reported by Meelis Roos.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 77b06a9..95cf7b6 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2314,6 +2314,7 @@ int __devinit scsi_esp_register(struct esp *esp, struct device *dev)
 	esp->host->transportt = esp_transport_template;
 	esp->host->max_lun = ESP_MAX_LUN;
 	esp->host->cmd_per_lun = 2;
+	esp->host->unique_id = instance;
 
 	esp_set_clock_params(esp);
 
@@ -2337,7 +2338,7 @@ int __devinit scsi_esp_register(struct esp *esp, struct device *dev)
 	if (err)
 		return err;
 
-	esp->host->unique_id = instance++;
+	instance++;
 
 	scsi_scan_host(esp->host);
 
