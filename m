Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0C15E7D0A2
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Sep 2023 18:36:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjIUSgi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 14:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjIUSgM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 14:36:12 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19137B010A;
        Thu, 21 Sep 2023 11:08:05 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB8DC433C9;
        Thu, 21 Sep 2023 18:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695319684;
        bh=yIuYqI2DOC5wZ+yWw5W7Z9M+ZrB9G96DR1SWzBWoM6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fbQCoMEZzBSm1HxAQLnW5Ecsn0AyJxkKOZ6HQPBjXq/yc1jwBjFeo2aD8OUeR9Sg8
         lr4/ook3NYkbKxbWBioXBdggenoMwHXkNrR/eT2OWRZpWGN6tRvK4u/BNHYktQbBjF
         F8tb4gwV3hxCK2LmdJmOXulC/X6p2oiTamiI63QpLQ4v1FlziA5t7PDsuFAGELPL0/
         Nd3A/1GtNTYn42ZGSeZdm9Zv3pwhOgVpdyef2iADFKN6ckH2CyebDZJZYqmAp8I8BZ
         yjW3OBqlBWBSBQ12HCoOPZCxrfxIckDsY2fh8jFsl/PyEOY0+e1m7PrSr6mDXqv3dK
         rPoACUYIbhlyA==
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
Subject: [PATCH v5 02/23] ata: libata-core: Fix port and device removal
Date:   Fri, 22 Sep 2023 03:07:37 +0900
Message-ID: <20230921180758.955317-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230921180758.955317-1-dlemoal@kernel.org>
References: <20230921180758.955317-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Whenever an ATA adapter driver is removed (e.g. rmmod),
ata_port_detach() is called repeatedly for all the adapter ports to
remove (unload) the devices attached to the port and delete the port
device itself. Removing of devices is done using libata EH with the
ATA_PFLAG_UNLOADING port flag set. This causes libata EH to execute
ata_eh_unload() which disables all devices attached to the port.

ata_port_detach() finishes by calling scsi_remove_host() to remove the
scsi host associated with the port. This function will trigger the
removal of all scsi devices attached to the host and in the case of
disks, calls to sd_shutdown() which will flush the device write cache
and stop the device. However, given that the devices were already
disabled by ata_eh_unload(), the synchronize write cache command and
start stop unit commands fail. E.g. running "rmmod ahci" with first
removing sd_mod results in error messages like:

ata13.00: disable device
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Synchronize Cache(10) failed: Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:0:0: [sda] Stopping disk
sd 0:0:0:0: [sda] Start/Stop Unit failed: Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK

Fix this by removing all scsi devices of the ata devices connected to
the port before scheduling libata EH to disable the ATA devices.
Also delete the WAR_ON() call checking that the ATA_PFLAG_UNLOADING flag
was cleared as that is done without holding the port lock.

Fixes: 720ba12620ee ("[PATCH] libata-hp: update unload-unplug")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/ata/libata-core.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 732f3d0b4fd9..8e35afe5e560 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5948,11 +5948,30 @@ static void ata_port_detach(struct ata_port *ap)
 	struct ata_link *link;
 	struct ata_device *dev;
 
-	/* tell EH we're leaving & flush EH */
+	/* Wait for any ongoing EH */
+	ata_port_wait_eh(ap);
+
+	mutex_lock(&ap->scsi_scan_mutex);
 	spin_lock_irqsave(ap->lock, flags);
+
+	/* Remove scsi devices */
+	ata_for_each_link(link, ap, HOST_FIRST) {
+		ata_for_each_dev(dev, link, ALL) {
+			if (dev->sdev) {
+				spin_unlock_irqrestore(ap->lock, flags);
+				scsi_remove_device(dev->sdev);
+				spin_lock_irqsave(ap->lock, flags);
+				dev->sdev = NULL;
+			}
+		}
+	}
+
+	/* Tell EH to disable all devices */
 	ap->pflags |= ATA_PFLAG_UNLOADING;
 	ata_port_schedule_eh(ap);
+
 	spin_unlock_irqrestore(ap->lock, flags);
+	mutex_unlock(&ap->scsi_scan_mutex);
 
 	/* wait till EH commits suicide */
 	ata_port_wait_eh(ap);
-- 
2.41.0

