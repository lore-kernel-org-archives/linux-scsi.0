Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CAF1C31E40
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 07:34:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D902C20897
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 07:34:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Wn/uPuYt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgIOHeA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 03:34:00 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:12674 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbgIOHdz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 03:33:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1600155235; x=1631691235;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z3tdZv2HdAJTutU9+KdZfpGJxtZq1aztwB81CJn6IeM=;
  b=Wn/uPuYtF7d8SG2tVs/6tx/7iG1dLe7+5WTPro6txHqViCqpgxrgp83h
   uPvPa1o39gNwvrv4gaUENCkkquUjqFHZkZmSuJdOdlpc4Pth8HehfpNta
   qkDPefUCT4qVm2Nz/NGFPrxI7FE8Kdd5JF30EyQijbRYd0/h6uA3rRMED
   WKgdWRV6ydnKTGT559ii5NrQLq+quiKOYV28FdY+p4LtNxU4+wgu65v6B
   4dlD6txAVJLn/ipCt1c1ggKwDp/xalZecLZH87Sg4+f5obb6evcJt8g2J
   BPwQbNMqTnd3FvyktoYHjrqafQlTpUpsjfiUPI+896TGUIj+QYN+Au23m
   g==;
IronPort-SDR: rpRCmpb07t8M8EnNnvbmTFtwYWYlNrf+x0L91A5Oq8pYRdshfQEc7q0aW0WcInnokV/gq44Qxi
 WsEWRZ7XlipRMCVxte4yxFt77Sq1jnRg+h5m2iPeJvCpycXE6xiDR8wsR/Mne2rgv9TOclUInw
 huBILlWzBByjh/HuooQq6uMfw5ChbqVO2u9PDYXREHAoKTNAZAM1F/qi7/8OnqZCX4vbc/rdUP
 jaasKatQbPdzPY/0j6o9DZCyQLqlRvnrtYpJR022PHWYhirHzWzyrcZOco0G9HpKinUypkVgP7
 4c4=
X-IronPort-AV: E=Sophos;i="5.76,429,1592841600"; 
   d="scan'208";a="147405121"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 15 Sep 2020 15:33:55 +0800
IronPort-SDR: 0FAnXRuqajsTWL0I4vR6fimjCJ17n96hzdnrq4bb1HfDLBjzTxcD6d34WGWBLElb2BVdbck5YA
 NHqTGPe9ejlA==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 00:21:05 -0700
IronPort-SDR: xoj4a8N0O4zFK2mqvo0pbKTkvZsCCs5PZHkKO/10cRWvswoDRR/Ie/Aixb8p6y/6Q/p2QDOtgo
 SFmfBBryflgA==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 15 Sep 2020 00:33:53 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Borislav Petkov <bp@suse.de>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 2/2] scsi: Fix ZBC disk initialization
Date:   Tue, 15 Sep 2020 16:33:47 +0900
Message-Id: <20200915073347.832424-3-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915073347.832424-1-damien.lemoal@wdc.com>
References: <20200915073347.832424-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make sure to call sd_zbc_init_disk() when the sdkp->zoned field is
known, that is, once sd_read_block_characteristics() is executed in
sd_revalidate_disk(), so that host-aware disks also get initialized.
To do so, move sd_zbc_init_disk() call in sd_zbc_revalidate_zones() and
make sure to execute it for all zoned disks, including for host-aware
disks used as regular disks as these disk zoned model may be changed
back to BLK_ZONED_HA when partitions are deleted.

Reported-by: Borislav Petkov <bp@alien8.de>
Fixes: 5795eb443060 ("scsi: sd_zbc: emulate ZONE_APPEND commands")
Cc: <stable@vger.kernel.org> # v5.8+
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Tested-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/scsi/sd.c     |  4 ---
 drivers/scsi/sd.h     |  6 -----
 drivers/scsi/sd_zbc.c | 60 +++++++++++++++++++++++++------------------
 3 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 06286b6aeaec..16503e22691e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3410,10 +3410,6 @@ static int sd_probe(struct device *dev)
 	sdkp->first_scan = 1;
 	sdkp->max_medium_access_timeouts = SD_MAX_MEDIUM_TIMEOUTS;
 
-	error = sd_zbc_init_disk(sdkp);
-	if (error)
-		goto out_free_index;
-
 	sd_revalidate_disk(gd);
 
 	gd->flags = GENHD_FL_EXT_DEVT;
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 7251434100e6..a3aad608bc38 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -215,7 +215,6 @@ static inline int sd_is_zoned(struct scsi_disk *sdkp)
 
 #ifdef CONFIG_BLK_DEV_ZONED
 
-int sd_zbc_init_disk(struct scsi_disk *sdkp);
 void sd_zbc_release_disk(struct scsi_disk *sdkp);
 int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buffer);
 int sd_zbc_revalidate_zones(struct scsi_disk *sdkp);
@@ -231,11 +230,6 @@ blk_status_t sd_zbc_prepare_zone_append(struct scsi_cmnd *cmd, sector_t *lba,
 
 #else /* CONFIG_BLK_DEV_ZONED */
 
-static inline int sd_zbc_init_disk(struct scsi_disk *sdkp)
-{
-	return 0;
-}
-
 static inline void sd_zbc_release_disk(struct scsi_disk *sdkp) {}
 
 static inline int sd_zbc_read_zones(struct scsi_disk *sdkp,
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index a739456dea02..cf07b7f93579 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -651,6 +651,28 @@ static void sd_zbc_print_zones(struct scsi_disk *sdkp)
 			  sdkp->zone_blocks);
 }
 
+static int sd_zbc_init_disk(struct scsi_disk *sdkp)
+{
+	sdkp->zones_wp_offset = NULL;
+	spin_lock_init(&sdkp->zones_wp_offset_lock);
+	sdkp->rev_wp_offset = NULL;
+	mutex_init(&sdkp->rev_mutex);
+	INIT_WORK(&sdkp->zone_wp_offset_work, sd_zbc_update_wp_offset_workfn);
+	sdkp->zone_wp_update_buf = kzalloc(SD_BUF_SIZE, GFP_KERNEL);
+	if (!sdkp->zone_wp_update_buf)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void sd_zbc_release_disk(struct scsi_disk *sdkp)
+{
+	kvfree(sdkp->zones_wp_offset);
+	sdkp->zones_wp_offset = NULL;
+	kfree(sdkp->zone_wp_update_buf);
+	sdkp->zone_wp_update_buf = NULL;
+}
+
 static void sd_zbc_revalidate_zones_cb(struct gendisk *disk)
 {
 	struct scsi_disk *sdkp = scsi_disk(disk);
@@ -667,6 +689,19 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 	u32 max_append;
 	int ret = 0;
 
+	/*
+	 * For all zoned disks, initialize zone append emulation data if not
+	 * already done. This is necessary also for host-aware disks used as
+	 * regular disks due to the presence of partitions as these partitions
+	 * may be deleted and the disk zoned model changed back from
+	 * BLK_ZONED_NONE to BLK_ZONED_HA.
+	 */
+	if (sd_is_zoned(sdkp) && !sdkp->zone_wp_update_buf) {
+		ret = sd_zbc_init_disk(sdkp);
+		if (ret)
+			return ret;
+	}
+
 	/*
 	 * There is nothing to do for regular disks, including host-aware disks
 	 * that have partitions.
@@ -768,28 +803,3 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 
 	return ret;
 }
-
-int sd_zbc_init_disk(struct scsi_disk *sdkp)
-{
-	if (!sd_is_zoned(sdkp))
-		return 0;
-
-	sdkp->zones_wp_offset = NULL;
-	spin_lock_init(&sdkp->zones_wp_offset_lock);
-	sdkp->rev_wp_offset = NULL;
-	mutex_init(&sdkp->rev_mutex);
-	INIT_WORK(&sdkp->zone_wp_offset_work, sd_zbc_update_wp_offset_workfn);
-	sdkp->zone_wp_update_buf = kzalloc(SD_BUF_SIZE, GFP_KERNEL);
-	if (!sdkp->zone_wp_update_buf)
-		return -ENOMEM;
-
-	return 0;
-}
-
-void sd_zbc_release_disk(struct scsi_disk *sdkp)
-{
-	kvfree(sdkp->zones_wp_offset);
-	sdkp->zones_wp_offset = NULL;
-	kfree(sdkp->zone_wp_update_buf);
-	sdkp->zone_wp_update_buf = NULL;
-}
-- 
2.26.2

