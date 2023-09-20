Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 229B3CE79D4
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Sep 2023 13:55:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236547AbjITNzl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Sep 2023 09:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236487AbjITNzT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Sep 2023 09:55:19 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8C31A5;
        Wed, 20 Sep 2023 06:54:59 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C04C433C7;
        Wed, 20 Sep 2023 13:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695218098;
        bh=mG4AOSJ2tKgBFtMRYuc+NOx0925Ulw05m8L5UF/PyvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uoPzvu6ocd/PzkFk2kcB25nIKC9sV+ZlWpFg6nWzcPP0nAepqJw6PrsQU7JBDytpP
         f2chiXHQ21n5N21yjgyoZbjvy6Y1aS+FzJTouZRs+C6UeX/GptCfTuhrwW/Tu0AwKm
         zN0nx9jlJOpS+ynYb48U1R2yn02WUDRakNLX7XJYKgN0jzlP6pY4BShe7JEzR6jabh
         XhYQ+yRtLtR1dIffvbeDrS0PaU2EUZhyGfsfRNqi6nSoSn5t+X2o2nknOOCCdC9/3f
         k7VyBTAVR/pdMuxjgQhZpAteoX/i0De8oiHMPsoZQjo+LjhFmWd8MFE25CEAFxD5J5
         Rv9CW1hiJUBgQ==
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
Subject: [PATCH v4 09/23] scsi: sd: Do not issue commands to suspended disks on shutdown
Date:   Wed, 20 Sep 2023 22:54:25 +0900
Message-ID: <20230920135439.929695-10-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230920135439.929695-1-dlemoal@kernel.org>
References: <20230920135439.929695-1-dlemoal@kernel.org>
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
is not already suspended but does not check the power state for
system-wide suspend/resume. That is, the commands may be issued with the
device in a suspended state, which causes PM resume to hang, forcing a
reset of the machine to recover.

Fix this by not calling sd_shutdown() in sd_remove() if the device
is not running.

Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 1d106c8ad5af..d86306d42445 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3727,7 +3727,8 @@ static int sd_remove(struct device *dev)
 
 	device_del(&sdkp->disk_dev);
 	del_gendisk(sdkp->disk);
-	sd_shutdown(dev);
+	if (sdkp->device->sdev_state == SDEV_RUNNING)
+		sd_shutdown(dev);
 
 	put_disk(sdkp->disk);
 	return 0;
-- 
2.41.0

