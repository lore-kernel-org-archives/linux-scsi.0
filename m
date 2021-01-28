Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7465FC433E9
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 04:51:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBF7A64DBD
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 04:51:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbhA1EvN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 23:51:13 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:22123 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231271AbhA1EvM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 23:51:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611809472; x=1643345472;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EKhsyGUiAPT9iVQna/YmfrtwycQGpAjmcTYD4lMXNEs=;
  b=F8CO0xB+JrFMmUADhb671gvZ7/rsY9mBFbEdvyPq1uQfurdHbDiQQZDZ
   vGKVqnsXqmkaytrKt5R0T3oB1rJtYmMh+7XowbEQ3SCrHZUAglxQ8F+3p
   7j1GXF3Eg2mpAVk5w6kVwlgc8ARExPAkgP01uBDSMfKeCuGFFaL/UggoC
   GqppXWS0C7ehkTh9BsGkPJywZrC0tztL2+EAm/LSbyN3HCyt/rQKpO6FB
   wMgCV58TqUShSh+uMW7PuYODj+f7o+zzCYysalV7rcUzrPJRPFtUZagvU
   QCC+9Xuiwu2oA4jJo/GivQ7j1krjk8T9uRibI5pei1BLDkawpYu0fqg+U
   w==;
IronPort-SDR: V4rqozJW9Sq7D8lXq1FNDM9lyU/ZO8RK2gE7stvk007UnQf0ciPTIyxlfQP+zm9sgtJhb+WEO4
 SKQPJBrCGJJS5vDKcvJmRPBicHIABANtxBc5mDwWUpvzEkMRTDImc7TjJJYEuJMK1Ic5AA2hZ4
 7t5vlJokDrPYaDFeieqqJvV5TaVbTMRSlwVM6VSwxSI9YeGfbjrbE5o9inXkjGf/Hqk/UtkkNY
 F+36/8tQuzmMMRVNIKLf5PQpLok7nYKlBSrY18yvHBPK/kY0zmE3VnOBCwClnJZ7CIa0vJ3Flw
 n0M=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; 
   d="scan'208";a="158509147"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 12:47:48 +0800
IronPort-SDR: n2Y0JBCq46eC4M76Hm9c539F+BGALk68FyhJ2p81TOl1QUUb4IN5X9S8keqL4DVrUyESNr3hUG
 jfVrJkiNddKWPPE0V7ezbUej9VYb+3wDKihtek/1/ITWAMaRCgLLnGvDaYKI5cVKmsjxL9yrP4
 RATQXemYntgKLVhtLGv3hejWhFKzbxMmV1J1DrCMMRbOXZE86dOnOm+mSWFEjbWu6yZ5v/rozh
 vlehcQEvzt6w1vvBFGlvw06vsglE7SjeGzYyMGhcsh+vEStM3rZBPPSbLtKZuSiJeYKK5Mh9ev
 tkkwkzCdni28Vfu9M/oZlnfK
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2021 20:30:07 -0800
IronPort-SDR: knyvuuTglsAK3pbOeeqHjtips90rfYXAkh0tF9qiqV8q622wCBoNmRVWyT4smvYPHCxcmQW8Nv
 5n/7SR1uTfIc1B7bD3bC3dHb/4kWkp4ClLXSY+Ols9XKvR92VtUEyUEDwgyPw9Ptq3Sri5d0Eb
 mMBGu1ItA6JFERgoKHOrFitedPGVM89nDfpFO/smM+lfQcRTNrq+w0sS5bEsdovt5rr6arFNBX
 OPfmdQMrczo2Wnp8wPeuFBfoYFjYLXKj1DbOOBxX+EzO1WuCANQcdrTSCliTIrl3luDlpFezyn
 LKI=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Jan 2021 20:47:47 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@wdc.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH v4 8/8] sd_zbc: clear zone resources for non-zoned case
Date:   Thu, 28 Jan 2021 13:47:33 +0900
Message-Id: <20210128044733.503606-9-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210128044733.503606-1-damien.lemoal@wdc.com>
References: <20210128044733.503606-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For host-aware ZBC disk, setting the device zoned model to BLK_ZONED_HA
using blk_queue_set_zoned() in sd_read_block_characteristics() may
result in the block device effective zoned model to be "none"
(BLK_ZONED_NONE) if partitions are present on the device. In this case,
sd_zbc_read_zones() should not setup the zone related queue limits for
the disk so that the device limits and configuration is consistent with
a regular disk and resources not uselessly allocated (e.g. the zone
write pointer tracking array for zone append emulation).

Furthermore, if the disk zoned model changes at run time due to the
creation of a partition by the user, the zone related resources can be
released.

Fix both problems by introducing the function sd_zbc_clear_zone_info()
to reset the scsi disk zone information and free resources and by
returning early in sd_zbc_read_zones() for a block device that has a
zoned model equal to BLK_ZONED_NONE.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd_zbc.c | 37 ++++++++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 8293b29584b3..03adb39293c2 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -665,12 +665,28 @@ static int sd_zbc_init_disk(struct scsi_disk *sdkp)
 	return 0;
 }
 
-void sd_zbc_release_disk(struct scsi_disk *sdkp)
+static void sd_zbc_clear_zone_info(struct scsi_disk *sdkp)
 {
+	/* Serialize against revalidate zones */
+	mutex_lock(&sdkp->rev_mutex);
+
 	kvfree(sdkp->zones_wp_offset);
 	sdkp->zones_wp_offset = NULL;
 	kfree(sdkp->zone_wp_update_buf);
 	sdkp->zone_wp_update_buf = NULL;
+
+	sdkp->nr_zones = 0;
+	sdkp->rev_nr_zones = 0;
+	sdkp->zone_blocks = 0;
+	sdkp->rev_zone_blocks = 0;
+
+	mutex_unlock(&sdkp->rev_mutex);
+}
+
+void sd_zbc_release_disk(struct scsi_disk *sdkp)
+{
+	if (sd_is_zoned(sdkp))
+		sd_zbc_clear_zone_info(sdkp);
 }
 
 static void sd_zbc_revalidate_zones_cb(struct gendisk *disk)
@@ -769,6 +785,21 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 		 */
 		return 0;
 
+	/* READ16/WRITE16 is mandatory for ZBC disks */
+	sdkp->device->use_16_for_rw = 1;
+	sdkp->device->use_10_for_rw = 0;
+
+	if (!blk_queue_is_zoned(q)) {
+		/*
+		 * This can happen for a host aware disk with partitions.
+		 * The block device zone information was already cleared
+		 * by blk_queue_set_zoned(). Only clear the scsi disk zone
+		 * information and exit early.
+		 */
+		sd_zbc_clear_zone_info(sdkp);
+		return 0;
+	}
+
 	/* Check zoned block device characteristics (unconstrained reads) */
 	ret = sd_zbc_check_zoned_characteristics(sdkp, buf);
 	if (ret)
@@ -797,10 +828,6 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 	if (blk_queue_zoned_model(q) == BLK_ZONED_HM)
 		blk_queue_zone_write_granularity(q, sdkp->physical_block_size);
 
-	/* READ16/WRITE16 is mandatory for ZBC disks */
-	sdkp->device->use_16_for_rw = 1;
-	sdkp->device->use_10_for_rw = 0;
-
 	sdkp->rev_nr_zones = nr_zones;
 	sdkp->rev_zone_blocks = zone_blocks;
 
-- 
2.29.2

