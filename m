Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30E5DE80AB0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Sep 2023 14:18:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbjI0OSj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 10:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232096AbjI0OSf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 10:18:35 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A334AF3;
        Wed, 27 Sep 2023 07:18:34 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D29C433C8;
        Wed, 27 Sep 2023 14:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695824314;
        bh=iHRP9E9cPqufgIWxI2IH2yhDdyqES2Tr5fpai5AjM9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d3J9TWT+UIorePXJZS1yk9fZTHTMyOWV5vzwLYIAkEXgkiP/pycXP+li4x+L6OF+3
         QME4qWxpEZyVqSShrXocdoTjbSar1YkaLUmEj2/39mg2olXbeUIzAIXQQ8mbzj2F1S
         FocJgG7PyVz4Xb4X3KEvRimT+GJssmg99s6SIn7S3JSnopBHqmwrNukOkfL7aA0XqD
         z4w/0dAHXXYaKD4Af1ZCoeEmyCXnQS40a/DflDoeoIq8KQkSTpNNjidO14Gmq9UPtm
         DWyeR2J83p29DY84v2Sv4qBtOWXIZpKG6n7zXm9mBLp3AwLOyYTdx0CboF5mkIIO+t
         jS25lCmJhEGjg==
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
Subject: [PATCH v8 02/23] ata: libata-core: Fix port and device removal
Date:   Wed, 27 Sep 2023 23:18:07 +0900
Message-ID: <20230927141828.90288-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230927141828.90288-1-dlemoal@kernel.org>
References: <20230927141828.90288-1-dlemoal@kernel.org>
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

Fixes: 720ba12620ee ("[PATCH] libata-hp: update unload-unplug")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
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

