Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69D65EE7FF4
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 04:02:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233507AbjIKECk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 00:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232941AbjIKECa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 00:02:30 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4EF19C;
        Sun, 10 Sep 2023 21:02:25 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE403C433C7;
        Mon, 11 Sep 2023 04:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694404945;
        bh=0idNs5N9Qj1ZU591NUPPrUJELFVxRgTalSNvSxDPc7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UdcxuK8cGOTS3ugbIO5IdBse0G3cBH6Vn4fOBwP5uWtqb+gbm/d/8eKnkWOon/Lcl
         oTEa5N6NPl1Dpdv50TPC4v+KSksdn8KywzODim4QnVcXLgNVFuAUpXsbiiyQu1TJwW
         xGdlRIHv3mfYYFj6SUmfX5x+aDWy3uY28LudY7w+2A7A8kUpQSkJFwxt5HA6YzzMKD
         ywqMNavNgwc4tCLGyZz9WhBBZooVvLBbZH8jg3/pf6rzIABU1B0IIy2vGxCtuOSeal
         eEn1e46C79RPHf367RLRf+HzrwxoB15GXNJ/TEP5PPLdw1p+Zt6HVokDOU0lDep9Pa
         CicYX/no8bh3Q==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: [PATCH 02/19] ata: libata-core: Fix port and device removal
Date:   Mon, 11 Sep 2023 13:02:00 +0900
Message-ID: <20230911040217.253905-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230911040217.253905-1-dlemoal@kernel.org>
References: <20230911040217.253905-1-dlemoal@kernel.org>
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
---
 drivers/ata/libata-core.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index c4898483d716..693cb3cd70cd 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5952,11 +5952,30 @@ static void ata_port_detach(struct ata_port *ap)
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

