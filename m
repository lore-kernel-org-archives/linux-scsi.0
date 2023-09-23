Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37A53CE7A88
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Sep 2023 00:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbjIWAaB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Sep 2023 20:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbjIWA3y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2023 20:29:54 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD4321AC;
        Fri, 22 Sep 2023 17:29:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B37FC433C9;
        Sat, 23 Sep 2023 00:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695428988;
        bh=MuctF/o58jy6c7woF6om1M9AQSPCX03Gki7M9JuoGGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rIQsjzKr4uSvuP4wV7hWiVrhLlpYofA4KPsSz4eEn2ITpwXfS5x4Gc5omdNsGWSSk
         N69g2EpJygjlmcQJxDpmiNYOBF6BCejF3xTqnH+fKDqXDhW0NiRaI8k0kNz4Olj9fQ
         C12dyYo18BBkE+AmwUYi/TPEGYW6ucwkYj6zmy936PcpeTJW/FO6sAgICPbNEb8gjs
         I8QWgJrw94jLabwEz/THb1K7YVEVRIuO34YVNPp0SsWV3yx5tSbzcBlscsQ1ctQkoQ
         oDcZmqWOiWl9M5ydW8t62dSKaPLo0t1UmNnpehPz8MdhWA0s8YDgDSgz24F73bXrzJ
         keV5P8r8Ey74A==
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
Subject: [PATCH v6 09/23] scsi: sd: Do not issue commands to suspended disks on shutdown
Date:   Sat, 23 Sep 2023 09:29:18 +0900
Message-ID: <20230923002932.1082348-10-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230923002932.1082348-1-dlemoal@kernel.org>
References: <20230923002932.1082348-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If an error occurs when resuming a host adapter before the devices
attached to the adapter are resumed, the adapter low level driver may
remove the scsi host, resulting in a call to sd_remove() for the
disks of the host. This in turn results in a call to sd_shutdown() which
will issue a synchronize cache command and a start stop unit command to
spindown the disk. sd_shutdown() issues the commands only if the device
is not already runtime suspended but does not check the power state for
system-wide suspend/resume. That is, the commands may be issued with the
device in a suspended state, which causes PM resume to hang, forcing a
reset of the machine to recover.

Fix this by tracking the suspended state of a disk using the sicsi_disk
suspended flag and by not calling sd_shutdown() in sd_remove() if the
disk is not running.

Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/sd.c | 17 +++++++++++++----
 drivers/scsi/sd.h |  1 +
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a1ef4eef904f..bff8663be7e0 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3741,7 +3741,8 @@ static int sd_remove(struct device *dev)
 
 	device_del(&sdkp->disk_dev);
 	del_gendisk(sdkp->disk);
-	sd_shutdown(dev);
+	if (!sdkp->suspended)
+		sd_shutdown(dev);
 
 	put_disk(sdkp->disk);
 	return 0;
@@ -3872,6 +3873,9 @@ static int sd_suspend_common(struct device *dev, bool runtime)
 			ret = 0;
 	}
 
+	if (!ret)
+		sdkp->suspended = 1;
+
 	return ret;
 }
 
@@ -3891,21 +3895,26 @@ static int sd_suspend_runtime(struct device *dev)
 static int sd_resume(struct device *dev, bool runtime)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
-	int ret;
+	int ret = 0;
 
 	if (!sdkp)	/* E.g.: runtime resume at the start of sd_probe() */
 		return 0;
 
-	if (!sd_do_start_stop(sdkp->device, runtime))
+	if (!sd_do_start_stop(sdkp->device, runtime)) {
+		sdkp->suspended = 0;
 		return 0;
+	}
 
 	if (!sdkp->device->no_start_on_resume) {
 		sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
 		ret = sd_start_stop_device(sdkp, 1);
 	}
 
-	if (!ret)
+	if (!ret) {
 		opal_unlock_from_suspend(sdkp->opal_dev);
+		sdkp->suspended = 0;
+	}
+
 	return ret;
 }
 
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 5eea762f84d1..4d42392fae07 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -150,6 +150,7 @@ struct scsi_disk {
 	unsigned	urswrz : 1;
 	unsigned	security : 1;
 	unsigned	ignore_medium_access_errors : 1;
+	unsigned	suspended : 1;
 };
 #define to_scsi_disk(obj) container_of(obj, struct scsi_disk, disk_dev)
 
-- 
2.41.0

