Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF496CE79D1
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Sep 2023 13:55:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236578AbjITNz7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Sep 2023 09:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236582AbjITNzV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Sep 2023 09:55:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C68CC8;
        Wed, 20 Sep 2023 06:55:04 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA32C433C7;
        Wed, 20 Sep 2023 13:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695218104;
        bh=Rjmy6H7vMZEpzGgQrIn37F8mFUqbq5OVbs7tVk9/yf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VtNfVD+neNIvGSmvenKCiQhgjyRfgwIwYxNmTI+NCeiz6By+/FJzIq/310CCaX4DW
         XVou0Rur+1VXV5/kygV2BSm3BTRX5hGS+u6WzwJqvsCXAO2rFGjs+9rRc+eUyE28hj
         GuMmdwuxj7vBdBMVey4OiLZIWpTNggNPWHJ37E8gz24kGjCr8soe9Mp2X+Qgep7Ie/
         L86X5oezCt7ezvrnxMm6toktY//k4AXbDNId2jtUQUICqtYfXfWSbeqUi41BmaCsIV
         y+2J2lF30dzR01ABOVWrgHeuyJOfhh6PUQeKwhoHNKqtTSjVkhHGIt9XUUcAolkZFZ
         Fc/veptMJrjtQ==
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
Subject: [PATCH v4 12/23] scsi: Remove scsi device no_start_on_resume flag
Date:   Wed, 20 Sep 2023 22:54:28 +0900
Message-ID: <20230920135439.929695-13-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230920135439.929695-1-dlemoal@kernel.org>
References: <20230920135439.929695-1-dlemoal@kernel.org>
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
---
 drivers/scsi/sd.c          | 7 ++-----
 include/scsi/scsi_device.h | 1 -
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d86306d42445..49e9b4ce2e33 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3886,11 +3886,8 @@ static int sd_resume(struct device *dev, bool runtime)
 	if (!sd_do_start_stop(sdkp->device, runtime))
 		return 0;
 
-	if (!sdkp->device->no_start_on_resume) {
-		sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
-		ret = sd_start_stop_device(sdkp, 1);
-	}
-
+	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
+	ret = sd_start_stop_device(sdkp, 1);
 	if (!ret)
 		opal_unlock_from_suspend(sdkp->opal_dev);
 	return ret;
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

