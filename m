Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEDA9E80AB4
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Sep 2023 14:19:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbjI0OTW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 10:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232137AbjI0OTA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 10:19:00 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F406A1AA;
        Wed, 27 Sep 2023 07:18:51 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD5FC433C8;
        Wed, 27 Sep 2023 14:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695824331;
        bh=MCJ2jnqPb87vnj3cqQeOcdyKKQhFLSSAKk5so46G2FI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nJr+zJbgZ98G6NBn0QWyHk35M2UTRTqR7yjXL+jQei2Edy4WjUcN7gArnfNCGlsYq
         WiN9baeIusrnhDZde1bN7j3HC9IK2Dx3MGhSBuHSszo4Ask/Ua/xueiymox0TZyN9d
         q0TsuunbYLO+LDtq2bS4O/IWcMJfZ/QO8yrgCGhvU9WPdRJsuQUpWyVwTZ30+AeZzi
         nv+UO8aCzWFhK/YxMFeKxlE+yZg2qB/uvzP/cvOq2PBNvhJ7l/bRwHYCbtH3BpzUlP
         d5ViG7+o8OovjrxziHspAW0UPjpKx08fjFDRbf5DgSxaMJrP9QOiQ3x70M2F9GW3sN
         s6wp16Ou53XBQ==
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
Subject: [PATCH v8 12/23] scsi: Remove scsi device no_start_on_resume flag
Date:   Wed, 27 Sep 2023 23:18:17 +0900
Message-ID: <20230927141828.90288-13-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230927141828.90288-1-dlemoal@kernel.org>
References: <20230927141828.90288-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The scsi device flag no_start_on_resume is not set by any scsi low
level driver. Remove it. This reverts the changes introduced by commit
0a8589055936 ("ata,scsi: do not issue START STOP UNIT on resume").

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c          | 9 +++------
 include/scsi/scsi_device.h | 1 -
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f911a64521e6..37a7d9cd2df3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3895,7 +3895,7 @@ static int sd_suspend_runtime(struct device *dev)
 static int sd_resume(struct device *dev, bool runtime)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
-	int ret = 0;
+	int ret;
 
 	if (!sdkp)	/* E.g.: runtime resume at the start of sd_probe() */
 		return 0;
@@ -3905,11 +3905,8 @@ static int sd_resume(struct device *dev, bool runtime)
 		return 0;
 	}
 
-	if (!sdkp->device->no_start_on_resume) {
-		sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
-		ret = sd_start_stop_device(sdkp, 1);
-	}
-
+	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
+	ret = sd_start_stop_device(sdkp, 1);
 	if (!ret) {
 		opal_unlock_from_suspend(sdkp->opal_dev);
 		sdkp->suspended = false;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index fd41fdac0a8e..e6e476fe2272 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -197,7 +197,6 @@ struct scsi_device {
 	unsigned use_192_bytes_for_3f:1; /* ask for 192 bytes from page 0x3f */
 	unsigned no_start_on_add:1;	/* do not issue start on add */
 	unsigned allow_restart:1; /* issue START_UNIT in error handler */
-	unsigned no_start_on_resume:1; /* Do not issue START_STOP_UNIT on resume */
 	unsigned start_stop_pwr_cond:1;	/* Set power cond. in START_STOP_UNIT */
 	unsigned no_uld_attach:1; /* disable connecting to upper level drivers */
 	unsigned select_no_atn:1;
-- 
2.41.0

