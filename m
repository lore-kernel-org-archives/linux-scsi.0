Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5877DE80AAD
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Sep 2023 14:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbjI0OTD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 10:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbjI0OSr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 10:18:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9428180;
        Wed, 27 Sep 2023 07:18:46 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28838C433C9;
        Wed, 27 Sep 2023 14:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695824326;
        bh=sAio6aqIhgHlSbAesQVdGPbpJneLSr2tVn08yBMf2Yw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kuMM1Ouh4caZU0D4lu4C8WDNhufKdgDwCQScv+K3kdNXEkaeAxE5X8mm9JfGc2PbF
         n9U9IpAf98qKdcgPeUwRkQldmxcRXfmHLNX2lv3vgAQQz4hrKdqOCPMxFXHNqoGAo1
         8m52GddjUaazszMdBrJHPfcdoNxyKb7NIJbtUYSx0CxxTwlCdHaZLL41OZ01OKk03p
         x2vSHI4L7PAGJGDhdw751mNtggZzgNg8D8FonYJE9JAiYYzoLKCFA4cp/BUl1Z7c8R
         jDCYmBNtf0Bb81YnROOKJtM87EZd+PyITWec/eV1rns1zQvd6wILp0PMF9qVOdsMal
         tvEcoE/9cNb3A==
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
Subject: [PATCH v8 09/23] scsi: sd: Do not issue commands to suspended disks on shutdown
Date:   Wed, 27 Sep 2023 23:18:14 +0900
Message-ID: <20230927141828.90288-10-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230927141828.90288-1-dlemoal@kernel.org>
References: <20230927141828.90288-1-dlemoal@kernel.org>
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

Fix this by tracking the suspended state of a disk by introducing the
suspended boolean field in the scsi_disk structure. This flag is set to
true when the disk is suspended is sd_suspend_common() and resumed with
sd_resume(). When suspended is true, sd_shutdown() is not executed from
sd_remove().

Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/sd.c | 17 +++++++++++++----
 drivers/scsi/sd.h |  1 +
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a1ef4eef904f..f911a64521e6 100644
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
+		sdkp->suspended = true;
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
+		sdkp->suspended = false;
 		return 0;
+	}
 
 	if (!sdkp->device->no_start_on_resume) {
 		sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
 		ret = sd_start_stop_device(sdkp, 1);
 	}
 
-	if (!ret)
+	if (!ret) {
 		opal_unlock_from_suspend(sdkp->opal_dev);
+		sdkp->suspended = false;
+	}
+
 	return ret;
 }
 
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 5eea762f84d1..14153ef7a414 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -131,6 +131,7 @@ struct scsi_disk {
 	u8		provisioning_mode;
 	u8		zeroing_mode;
 	u8		nr_actuators;		/* Number of actuators */
+	bool		suspended;	/* Disk is supended (stopped) */
 	unsigned	ATO : 1;	/* state of disk ATO bit */
 	unsigned	cache_override : 1; /* temp override of WCE,RCD */
 	unsigned	WCE : 1;	/* state of disk WCE bit */
-- 
2.41.0

