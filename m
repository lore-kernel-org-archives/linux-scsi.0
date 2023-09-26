Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E21CE7D24D
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Sep 2023 08:15:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233983AbjIZIP4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Sep 2023 04:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233957AbjIZIPk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Sep 2023 04:15:40 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3013597;
        Tue, 26 Sep 2023 01:15:34 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497B9C433C8;
        Tue, 26 Sep 2023 08:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695716133;
        bh=AMOyvsYQxQGFS3m/Fmi55tP8CTkB6JNj/0oj+wsXCcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZAXO4xIhDZDoi/yt2DZlF4YTE9AkkaWGjPaG5qdtygEnXZUecFRBKodYJekSoUlas
         4WaAi9PlRFYSwyeIKdhXq5d/VV/XSoPVowtgZoABhoBIcS/a0S23zwey9rIkNBxDxP
         9KQZRSHHIhSDV+Lcq4Vdd8TK+/tmmGoYc78YS3hgMxHeNvcwXB2RJR/RqzPr6ihE2Q
         TVHvB1PoPmagpH3aRf2TWuqIdQjd9FG5Q2RwWfa15lDxJUcH9jWOn+hIQKmcIaAVFf
         7W4mJbB7Jxfq8nGr2hX5dQQ511pHzGXpPP7/ZFUNOAfKvUr8dWzgCXm4iAphIwn9te
         I0s++FppIkl2A==
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
Subject: [PATCH v7 12/23] scsi: Remove scsi device no_start_on_resume flag
Date:   Tue, 26 Sep 2023 17:14:56 +0900
Message-ID: <20230926081507.69346-13-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230926081507.69346-1-dlemoal@kernel.org>
References: <20230926081507.69346-1-dlemoal@kernel.org>
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
 drivers/scsi/sd.c          | 13 ++++---------
 include/scsi/scsi_device.h |  1 -
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f911a64521e6..c94c1087eaf4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3900,20 +3900,15 @@ static int sd_resume(struct device *dev, bool runtime)
 	if (!sdkp)	/* E.g.: runtime resume at the start of sd_probe() */
 		return 0;
 
-	if (!sd_do_start_stop(sdkp->device, runtime)) {
-		sdkp->suspended = false;
-		return 0;
-	}
-
-	if (!sdkp->device->no_start_on_resume) {
+	if (sd_do_start_stop(sdkp->device, runtime)) {
 		sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
 		ret = sd_start_stop_device(sdkp, 1);
+		if (!ret)
+			opal_unlock_from_suspend(sdkp->opal_dev);
 	}
 
-	if (!ret) {
-		opal_unlock_from_suspend(sdkp->opal_dev);
+	if (!ret)
 		sdkp->suspended = false;
-	}
 
 	return ret;
 }
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index b7df1e6da969..8db0c88cf48e 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -195,7 +195,6 @@ struct scsi_device {
 	unsigned allow_restart:1; /* issue START_UNIT in error handler */
 	unsigned manage_system_start_stop:1; /* Let HLD (sd) manage system start/stop */
 	unsigned manage_runtime_start_stop:1; /* Let HLD (sd) manage runtime start/stop */
-	unsigned no_start_on_resume:1; /* Do not issue START_STOP_UNIT on resume */
 	unsigned start_stop_pwr_cond:1;	/* Set power cond. in START_STOP_UNIT */
 	unsigned no_uld_attach:1; /* disable connecting to upper level drivers */
 	unsigned select_no_atn:1;
-- 
2.41.0

