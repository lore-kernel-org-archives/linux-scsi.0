Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC159CE79CE
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Sep 2023 13:56:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236702AbjITN4t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Sep 2023 09:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236416AbjITNzk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Sep 2023 09:55:40 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980F6F9;
        Wed, 20 Sep 2023 06:55:23 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6923C433C8;
        Wed, 20 Sep 2023 13:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695218123;
        bh=I6x+jalffrxGED0afbi/0vQx6Z0ArIwCHliTfTBizYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FNn5gFLQxrqK4d/0ccnmU8mOXkaF2DY72f1O4hlnXy0Xw7trS6CU7hC+TnYVO9hB9
         3sE2szmlwb+B+LQcYpeVm4fefi08RGpRxfss+Ce/q95GWBOGXSch0eRG2crVBN/0LO
         ti/WrLLdIHldjS0V6m42osBxu+0qWvTYaHuOBGaL19/g49eTNEzCIw0csf9wplltaZ
         qDeLtybcb+q6BnypbeXZO5PdC1gjD/qyf6/MOUE1h3bhu0JRD9/8E+bCG1tKbwg1xO
         81PAitQkNmM445hlM5gG4K/ROdMc02dZm4T3QK+oERMtt4+/+QCYl6sauz6oXUNb0b
         HwddbLUPrvA7Q==
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
Subject: [PATCH v4 22/23] ata: libata-eh: Reduce "disable device" message verbosity
Date:   Wed, 20 Sep 2023 22:54:38 +0900
Message-ID: <20230920135439.929695-23-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230920135439.929695-1-dlemoal@kernel.org>
References: <20230920135439.929695-1-dlemoal@kernel.org>
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

