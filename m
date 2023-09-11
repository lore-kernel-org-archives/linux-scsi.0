Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7301EE801F
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 04:03:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbjIKEDb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 00:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233656AbjIKEDG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 00:03:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 599C41B9;
        Sun, 10 Sep 2023 21:02:55 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52609C433CA;
        Mon, 11 Sep 2023 04:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694404974;
        bh=Dgf8t8rvF95CKc1xqlbfk/7IBYHIUJKutmuItoRyjiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PU0vaAhY4Bsv0sxM3UbSBIR99xY+n8YrZMEnMRnNrUdqC3Q5svOUPd86NBP6XXGD5
         4nQWcDrLS04+x5kikYxXHDIIosoRQUbI5GqWUyE4pnOt6kot/YakUuese0r5H9PaVJ
         xtrLFDaONKXCsh7NcQw3vUGZWnSTMw0tjU1dMuHcIKYOED0P/J+EoI1kQa543XMHWZ
         KoKbJ++TD3fmreythi5QBVsPmG7m5tKd5FVohzME9jAaiiP4ZD+sbJRQ7N74LQ+ilu
         /sCMExDQpazo/4UyIsLjr7TUccYQSDrlBz1I+m1eFnBWqto+vYjjiRRMScmy/ndYQl
         hVnpZBFc2whlQ==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: [PATCH 18/19] ata: libata-eh: Reduce "disable device" message verbosity
Date:   Mon, 11 Sep 2023 13:02:16 +0900
Message-ID: <20230911040217.253905-19-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230911040217.253905-1-dlemoal@kernel.org>
References: <20230911040217.253905-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is no point in warning about a device being diabled when we expect
it to be, that is, on suspend, shutdown or when detaching a device.
Suppress this message for these cases by introducing the EH static
function ata_eh_dev_disable() and by using it in ata_eh_unload() and
ata_eh_detach_dev(). ata_dev_disable() code is modified to call this new
function after printing the "disable device" message.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ata/libata-eh.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index bbc522d16f44..5bad5dabffe0 100644
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

