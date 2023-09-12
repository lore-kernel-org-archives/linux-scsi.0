Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 084CACA0EC6
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 03:02:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241544AbjILDC5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 23:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241554AbjILDCm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 23:02:42 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947FE1A77AB;
        Mon, 11 Sep 2023 18:32:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2760C32797;
        Tue, 12 Sep 2023 00:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694480232;
        bh=x6jvPESpbov3ycsJPcmUwKrEk2OxyEuUoVUKo1mhocI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QFeLPrG8jGGM82UuS4jzs+D40xa1iqF93X4r4Wj71Uz/4f8Nam/Z/M71uAA9fMUB3
         i4Kr1uj2QXAikRjwEpryhCKlWJSr2jyDWGpmCc+Hkhg+3IAV1RjqaxSaACu8sFZ+Nz
         T5Ht1DuAFzg7/m6YinTHFvFE4CidwK+luNOP+T0KT+VNrmS+GcgbEqrSTi1KPT45I5
         V1ReV4xWsEoc+Uew7nqusOYQlB4USw8gqxFzhWbcucrS29DSHfYXLbxsHHiO61o/TN
         Nm6bMz36Vui0dh/0lTtMdelkX2WI+KxOoUamtxEwtfTsfkpzHmO+jo9t82WjMy9UCc
         2MlgpZpBKS+FQ==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: [PATCH v2 10/21] scsi: Remove scsi device no_start_on_resume flag
Date:   Tue, 12 Sep 2023 09:56:44 +0900
Message-ID: <20230912005655.368075-11-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230912005655.368075-1-dlemoal@kernel.org>
References: <20230912005655.368075-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The scsi device flag no_start_on_resume is not set by any scsi low
level driver. Remove it.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/sd.c          | 7 ++-----
 include/scsi/scsi_device.h | 1 -
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a415abb721d3..b9504bb3cf4d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3846,11 +3846,8 @@ static int sd_resume(struct device *dev)
 	if (!sdkp->device->manage_start_stop)
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
index b9230b6add04..75b2235b99e2 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -194,7 +194,6 @@ struct scsi_device {
 	unsigned no_start_on_add:1;	/* do not issue start on add */
 	unsigned allow_restart:1; /* issue START_UNIT in error handler */
 	unsigned manage_start_stop:1;	/* Let HLD (sd) manage start/stop */
-	unsigned no_start_on_resume:1; /* Do not issue START_STOP_UNIT on resume */
 	unsigned start_stop_pwr_cond:1;	/* Set power cond. in START_STOP_UNIT */
 	unsigned no_uld_attach:1; /* disable connecting to upper level drivers */
 	unsigned select_no_atn:1;
-- 
2.41.0

