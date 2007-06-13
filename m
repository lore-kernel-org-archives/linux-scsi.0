From: David Miller <davem@davemloft.net>
Subject: [PATCH]: ESP reset bug fix
Date: Wed, 13 Jun 2007 12:58:53 -0700 (PDT)
Message-ID: <20070613.125853.119242891.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41568
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751673AbXFMT6h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jun 2007 15:58:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, tsbogend@alpha.franken.de


James could you please push this bug fix from Thomas to Linus?

Thanks a lot!

[SCSI] ESP: Don't forget to clear ESP_FLAG_RESETTING.

From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

esp_reset_cleanup() does everything necessary except clear
the flag, so we never exit resetting state.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index ec71061..71caf2d 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2033,6 +2033,7 @@ static void esp_reset_cleanup(struct esp *esp)
 			starget_for_each_device(tp->starget, NULL,
 						esp_clear_hold);
 	}
+	esp->flags &= ~ESP_FLAG_RESETTING;
 }
 
 /* Runs under host->lock */
