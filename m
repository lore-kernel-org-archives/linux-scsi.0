From: David Miller <davem@davemloft.net>
Subject: [PATCH]: Revert ESP_BUS_TIMEOUT back down to 250
Date: Mon, 30 Jul 2007 16:19:20 -0700 (PDT)
Message-ID: <20070730.161920.08323520.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59298
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757377AbXG3XTV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jul 2007 19:19:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, mark@mtfhpc.demon.co.uk


James, please push upstream, thanks a lot!

[SCSI] ESP: Drop ESP_BUS_TIMEOUT back down to 250

This reverts d73f5222a618a91452d41c29f5996ce3d9c63673

The bug that made us increase ESP_BUS_TIMEOUT to 275 turned out to be
a memset bug on 32-bit sparc.

It is better to put this back at the correct timeout value than to
leave it increased when there is no reason for doing so.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/scsi/esp_scsi.h b/drivers/scsi/esp_scsi.h
index 856e38b..d5576d5 100644
--- a/drivers/scsi/esp_scsi.h
+++ b/drivers/scsi/esp_scsi.h
@@ -220,7 +220,7 @@
 #define ESP_BUSID_RESELID     0x10
 #define ESP_BUSID_CTR32BIT    0x40
 
-#define ESP_BUS_TIMEOUT        275     /* In milli-seconds */
+#define ESP_BUS_TIMEOUT        250     /* In milli-seconds */
 #define ESP_TIMEO_CONST       8192
 #define ESP_NEG_DEFP(mhz, cfact) \
         ((ESP_BUS_TIMEOUT * ((mhz) / 1000)) / (8192 * (cfact)))
