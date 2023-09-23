Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60F99CE7A81
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Sep 2023 00:31:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbjIWAbT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Sep 2023 20:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbjIWAax (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2023 20:30:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A2C1B0;
        Fri, 22 Sep 2023 17:30:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 217B0C433C9;
        Sat, 23 Sep 2023 00:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695429008;
        bh=zkev2ircY3fnbSzJ0bCWRHN59K1mwL4l6wGAngimylw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kS4h11z6UqxH/cHJGYC2xIy6Ls7dmPTD1th+A/oKyMeeyqzTlwkiedMoxJ2AhcPfl
         siXB803wypcEb4NqaMSYNQcLWETNT6C3tZDonxjba9/OQfdcM45KDgyqkD+R0hHAgw
         3rvsipyHoIP7q1UKhUfcU+VdfW0IHZiMCbcT+dKqDp3UTEv5bY+i6QiZA0p7jY+IfW
         oCxVDiQOI5JVsCTFOxKjMDoCdPiuOQex8sVnsiN4UXAxqpsXOV/RXm9WADh3NED1yP
         x17l9S9iulg+RcEW+h6rnJtepKQ5Y+FgdLWxAX9KrTYlhLDgSkcflG4VzsaQCCv+M3
         b/4RTHdoN3Whw==
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
Subject: [PATCH v6 22/23] ata: libata-eh: Reduce "disable device" message verbosity
Date:   Sat, 23 Sep 2023 09:29:31 +0900
Message-ID: <20230923002932.1082348-23-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230923002932.1082348-1-dlemoal@kernel.org>
References: <20230923002932.1082348-1-dlemoal@kernel.org>
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

