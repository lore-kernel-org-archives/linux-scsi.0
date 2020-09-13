Return-Path: <SRS0=npVx=CW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EE42C43461
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Sep 2020 06:03:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC89C21655
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Sep 2020 06:03:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="BMrL7GgI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgIMGDY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Sep 2020 02:03:24 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:60247 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgIMGDM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Sep 2020 02:03:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1599976991; x=1631512991;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jxd9y2JXL2aUJ7WYNs3dtOces+LIigDvq1lvki3gPVk=;
  b=BMrL7GgIcedUlE/mgI18JitShiPyKlFS9IYwvM998U5S4zjPGVE/WFh8
   fNE+BcyTPw2TfDy+qHtKGUZNoTSPcPpl0ElgFZiaLne9jZ9xJr6GzuXhN
   ZskcpprfOKTReMcAgMDyrw84Q4yWNBkCBabXZOmVrkBgAp6uWL1FJ9hXs
   GZzjOKy7ETyirRF5DL5S4XhEtFCEVJ034fmqTyIdkiZ2dPUPG4rp2bs7B
   sv5its/sEzxbCIUiYtdAXLusb3gprx9I0GIADVxnUqUsk4y9TC5KrGcPx
   W0WmlrlmM8RCNgTqsJM97P3WrpZvSP7EwZa6e4Rw6LKj58nQmWv51ugVq
   g==;
IronPort-SDR: Qfbojx1AjKVSvhP35JPtdgsvAmIR3SLBZ4R71P0btHxakHpG7DQWDZpSZBxEKQ899egDBWawYB
 W7CEjBYxr91sB5xtIIgMUJPrOPEvl4f1QYtDttBGZcWzdovzxTusZPFYyGwaTsA8lo2QCMNEuF
 wAIP91JzjoQ2vQBjSvG51XU9jw4R02sTSQJv4snFSq3OEdVDe3fYCMBhqrOBftW4R6V0I4OEZ1
 iS/eWsKHth/13AxHYreNspr8PvQq2hFzPbZwJ4t9FQdBl5Si+QKO+MyIRnlyZ0qoLaqIUEAXo/
 Ht8=
X-IronPort-AV: E=Sophos;i="5.76,421,1592841600"; 
   d="scan'208";a="148458736"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 13 Sep 2020 14:03:11 +0800
IronPort-SDR: ZbusAnwiNjm6KS07uwyzwB4ys857MwGOc1WL9FS5wDZIYs7ILGwHz7CWIG29+IXf3sBBLYvi/5
 f+7pzP4x+UCg==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2020 22:49:29 -0700
IronPort-SDR: NtwP2buxnEKly/SpYwBfPl0DoYL9CswEBrsbgvIb4Us04KZ6H0knJi77SNHEtXJEnPve8iypHT
 1YG+X+AwAo/w==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 12 Sep 2020 23:03:10 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Borislav Petkov <bp@alien8.de>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 2/2] scsi: Fix ZBC disk initialization
Date:   Sun, 13 Sep 2020 15:03:04 +0900
Message-Id: <20200913060304.294898-3-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200913060304.294898-1-damien.lemoal@wdc.com>
References: <20200913060304.294898-1-damien.lemoal@wdc.com>
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
---
 drivers/scsi/sd.c     |  4 ---
 drivers/scsi/sd.h     |  6 -----
 drivers/scsi/sd_zbc.c | 60 +++++++++++++++++++++++++------------------
 3 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 7f0371185a45..3d2cffb8e9aa 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3418,10 +3418,6 @@ static int sd_probe(struct device *dev)
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

