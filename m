Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BF6FE7D258
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Sep 2023 08:15:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233979AbjIZIPp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Sep 2023 04:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbjIZIPg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Sep 2023 04:15:36 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D2A4FC;
        Tue, 26 Sep 2023 01:15:28 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91CD4C433C7;
        Tue, 26 Sep 2023 08:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695716128;
        bh=2w/6rA2GHOKalsTPwz93JFAq7sA7uKKP+M6htVhEBPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qjen2LN4oY6UvhI+2/5qhMdt1a4EVjG5OnZkJ1A3JoXfk8t+lwh1KZZ3aGqdeyeE1
         pbi8PrL6zmH8w3KnEBQsv8D9R2VpXign3tqH+cqGTw3+g1npLV7Quw5CQETTu9VnSG
         +EYdQZqaCDAIBsOLB/QWhu1Z8hxegFORrjxvB/eIpYWZW2BqSxHKH6mezY1cp3GEOz
         L+hkSBDLoy4TUnpbCOz7dRNDDLAPcbrlQX0UJwDKc5hAwxR8NHKf4bnnrStaKitIFU
         J1nnK0whJ5ybepBd4dnqFrSsmQd8AbJbEMIxIOlQMF3Eoj3b9MD3u5fB6U31uZocIn
         5i06oLIQ8wXng==
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
Subject: [PATCH v7 09/23] scsi: sd: Do not issue commands to suspended disks on shutdown
Date:   Tue, 26 Sep 2023 17:14:53 +0900
Message-ID: <20230926081507.69346-10-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230926081507.69346-1-dlemoal@kernel.org>
References: <20230926081507.69346-1-dlemoal@kernel.org>
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

