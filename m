Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0817AE7D0AB
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Sep 2023 22:12:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbjIUWMU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 18:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233003AbjIUWL5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 18:11:57 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F0AB0138;
        Thu, 21 Sep 2023 11:08:17 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC05C433C8;
        Thu, 21 Sep 2023 18:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695319697;
        bh=O7oF0hNk00rZAS4qiKFR+aE3J/ZVsOyz8wvJQD0MWAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OQ3bcOz5jQb5XhY57ROY9l6yu0YImQhMZ76XS87mFLmjXHDmz0XS/LvYu7r2Ta/7D
         7yE5Z6vMWD/qz13kJn6y5d0HbDcUKCecJBXIFvyPWESPIT5OLpuy9TMUAdVwiVhkAh
         7Y5OHAVnUVHToPVSEk3k5o9JZLyGH/S758xPmyYzCNszfK00tPY6YrDedy4wAMkdjd
         duda1i7/HcfaLv3UdVBwmqkrRXsvJ3H04P3+zLhXYPir2Du9rWe02QD8VFxX8vFGwL
         I3KnlMNkOIZI/y6ODzRXDUIqRMG5C2FFzffe6c30uk3JJtXBmc9RYxQk4ydbGfeFUU
         DV1hn1hb8+vbw==
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
Subject: [PATCH v5 09/23] scsi: sd: Do not issue commands to suspended disks on shutdown
Date:   Fri, 22 Sep 2023 03:07:44 +0900
Message-ID: <20230921180758.955317-10-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230921180758.955317-1-dlemoal@kernel.org>
References: <20230921180758.955317-1-dlemoal@kernel.org>
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
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
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

