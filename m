Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8EC0E80AAD
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Sep 2023 14:19:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232241AbjI0OTu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 10:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232160AbjI0OTK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 10:19:10 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA69019E;
        Wed, 27 Sep 2023 07:19:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D204C433CA;
        Wed, 27 Sep 2023 14:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695824348;
        bh=zkev2ircY3fnbSzJ0bCWRHN59K1mwL4l6wGAngimylw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZzvlAwZm4NiejxsJdlpgf15l85QOtigN3u53YlIJWuW5sUkHydiryIAXac8SqzFw6
         I/Rfydc6n33KylwgPggKT0ad5ze7nHLsTgQkxqTCJDRADmU/HdiAfzjn0kFF6O7YyH
         tPA/6g4QG+rXWlaQVkuAmWUtcfu67LfAlu/TcUv0VUMHLqU7i9cO93p8n/hOzGd8c7
         urwLm7aDMMcYMBEf9+l2a2J+4hTfxoJYZyPm34e1DGtmgbZJhoTvZidiZ9n407rdxh
         nR9LkuexkTK9zrjx9NVeIkPdEW9qNXGSEN61MasnlsM1x6hCyygmppgLiMYUJcS6xH
         t+RGjlwbrtqrA==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
Subject: [PATCH v8 22/23] ata: libata-eh: Reduce "disable device" message verbosity
Date:   Wed, 27 Sep 2023 23:18:27 +0900
Message-ID: <20230927141828.90288-23-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230927141828.90288-1-dlemoal@kernel.org>
References: <20230927141828.90288-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is no point in warning about a device being disabled when we
expect it to be, that is, on suspend, shutdown or when detaching the
device.

Suppress the message "disable device" for these cases by introducing the
EH static function ata_eh_dev_disable() and by using it in
ata_eh_unload() and ata_eh_detach_dev(). ata_dev_disable() code is
modified to call this new function after printing the "disable device"
message.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/ata/libata-eh.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 67387d602735..945675f6b822 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -494,6 +494,18 @@ void ata_eh_release(struct ata_port *ap)
 	mutex_unlock(&ap->host->eh_mutex);
 }
 
+static void ata_eh_dev_disable(struct ata_device *dev)
+{
+	ata_acpi_on_disable(dev);
+	ata_down_xfermask_limit(dev, ATA_DNXFER_FORCE_PIO0 | ATA_DNXFER_QUIET);
+	dev->class++;
+
+	/* From now till the next successful probe, ering is used to
+	 * track probe failures.  Clear accumulated device error info.
+	 */
+	ata_ering_clear(&dev->ering);
+}
+
 static void ata_eh_unload(struct ata_port *ap)
 {
 	struct ata_link *link;
@@ -517,8 +529,8 @@ static void ata_eh_unload(struct ata_port *ap)
 	 */
 	ata_for_each_link(link, ap, PMP_FIRST) {
 		sata_scr_write(link, SCR_CONTROL, link->saved_scontrol & 0xff0);
-		ata_for_each_dev(dev, link, ALL)
-			ata_dev_disable(dev);
+		ata_for_each_dev(dev, link, ENABLED)
+			ata_eh_dev_disable(dev);
 	}
 
 	/* freeze and set UNLOADED */
@@ -1211,14 +1223,8 @@ void ata_dev_disable(struct ata_device *dev)
 		return;
 
 	ata_dev_warn(dev, "disable device\n");
-	ata_acpi_on_disable(dev);
-	ata_down_xfermask_limit(dev, ATA_DNXFER_FORCE_PIO0 | ATA_DNXFER_QUIET);
-	dev->class++;
 
-	/* From now till the next successful probe, ering is used to
-	 * track probe failures.  Clear accumulated device error info.
-	 */
-	ata_ering_clear(&dev->ering);
+	ata_eh_dev_disable(dev);
 }
 EXPORT_SYMBOL_GPL(ata_dev_disable);
 
@@ -1240,12 +1246,12 @@ void ata_eh_detach_dev(struct ata_device *dev)
 
 	/*
 	 * If the device is still enabled, transition it to standby power mode
-	 * (i.e. spin down HDDs).
+	 * (i.e. spin down HDDs) and disable it.
 	 */
-	if (ata_dev_enabled(dev))
+	if (ata_dev_enabled(dev)) {
 		ata_dev_power_set_standby(dev);
-
-	ata_dev_disable(dev);
+		ata_eh_dev_disable(dev);
+	}
 
 	spin_lock_irqsave(ap->lock, flags);
 
-- 
2.41.0

