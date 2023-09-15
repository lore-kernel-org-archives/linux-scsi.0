Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C838FEE643D
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 08:28:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233188AbjIOI2L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 04:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233319AbjIOI1z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 04:27:55 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F9F49FA;
        Fri, 15 Sep 2023 01:23:47 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC39C433D9;
        Fri, 15 Sep 2023 08:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694765727;
        bh=Fv8EC/3JKlOdzDCCl3PyvLRMaFFYh8IvyAKJkinGyIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M0svciAH3NG/OsWu0CDL1RW3i5dATkD56FZHmXnNhQ111FXFU28hj3+zLlwmYUDAF
         Ew3Wh7v5yhwVS8nYZVOkj4AAmBFpY/B90whe5PLZKNS8a1vk8kwqBL3vAXQ7kquaVO
         KjZwpaKLEjWFhihO53mJvgDS2v7ayy+XIyn7WFQRW62bNon6F2JPR+cgrlNPRE3Z8c
         U4UvssavcXU7Zn3KDfsFXk8/DIH2BfPLWJswD2HlpY4lm67lGQk/DmUV1ObBFJpR7P
         fkqUeTOyGdEKgW0FOz9q8ROAQOzgVpXQQOcD0NmpuBX9/ClkfCNEiNzM5ZSbGanDSx
         fGwI3gOPPcDPA==
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
Subject: [PATCH v3 09/23] scsi: sd: Do not issue commands to suspended disks on shutdown
Date:   Fri, 15 Sep 2023 17:14:53 +0900
Message-ID: <20230915081507.761711-10-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230915081507.761711-1-dlemoal@kernel.org>
References: <20230915081507.761711-1-dlemoal@kernel.org>
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

