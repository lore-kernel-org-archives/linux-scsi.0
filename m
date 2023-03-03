Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 619A2C7EE30
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Mar 2023 01:44:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbjCCBoa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Mar 2023 20:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjCCBo1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2023 20:44:27 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A4F16ADF
        for <linux-scsi@vger.kernel.org>; Thu,  2 Mar 2023 17:44:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1677807866; x=1709343866;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YHyqQfuv+Sm93/GRfIpQjsYqDC3iRxNtGoLckagaCfM=;
  b=ko7EMaWPxUmH/i26Sy1+d3Et1+rnQQOWe4Vnj8KG3UJPZ6VbV74Rp2XK
   o+W/GwHZJvYmUlCQW2qipIh5pgHKvBnwBgIvNwHWdlgUULryAETIRRdx5
   7qgzcX/Ty1swjeOC+FNuzZvxFNzcDDJBrGC/FEKVU9Mz+W83g3IcP4o/Y
   T1ZJFeii15ZEXi2A1O2ftW2/Cnr4O0iapFV8rRwsO7WnJRdH1qdG05hSd
   LV4+fnqM+El7WPUfnx2KzZtsluo0ZrrP7zw+2ogNz4nDG0BOx4WX8mmlK
   CZIYjh3qY0og8rQN54cJ7gkHMFKzkLRFsjrRHlAJjLBinXsrYB5b8GhJZ
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,229,1673884800"; 
   d="scan'208";a="229650329"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 03 Mar 2023 09:44:26 +0800
IronPort-SDR: BYISYjZ7+vPOVYnqRbY6zJF/2wVqgiSBCGVeTbRs5KDYGcorK6jIqMfwWCZZ7OjP7LFxvbpOlT
 y0Px6/LoqfNQEacU0eJfczbGx1sy8sXA3pCKhLBH5mjj3juFPqa63V5FnuKSTWxkCFzsvR+twG
 2fQoidZ3Ms9AsMFIaXvtDIbgel4HtReBoAUhOS+GRpmMpwjo10Xaf41BQTWiBuOeBp5bvdOUpa
 35+XUmatqqjuok/g+hlsNVB/z+hgu/Dglv7wH1P5FGKFlkBhLxb9U/jVVXdFkuhmG5K0ZxwXvg
 p30=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Mar 2023 17:01:14 -0800
IronPort-SDR: /iPeLZFpkClLx+Mobpb38KUqnTzzodBjAgJ1Yo2RSZGZzx2oucEBL5Eob3Iqh1z9fZN1yCsYKp
 IBL8uyxVET/B1z1498PCq/ONL5C1QHDSGfn+ZCkhDDGM5217fmZOwA8KlPOym3dzSxJyP4X7zB
 NMSFfygCyj/2LIJRlzu4kO/tU3+Fkqx0tSYpxK/MaWIBko0NpRRIoEiqmKoz2MxtGYPX6XssvR
 TPTV1baKqbrtRr8tJOXXewXVeJMZRrjGN8KRGAbOMa6xBMPDVykwCSW8hfAkg1CPBl+Tm76/0B
 ffU=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 02 Mar 2023 17:44:26 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 2/2] scsi: sd: Fix wrong zone_write_granularity value at revalidate
Date:   Fri,  3 Mar 2023 10:44:22 +0900
Message-Id: <20230303014422.2466103-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230303014422.2466103-1-shinichiro.kawasaki@wdc.com>
References: <20230303014422.2466103-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When sd driver revalidates host-managed SMR disks, it calls
disk_set_zoned() which changes the zone_write_granularity attribute
value to the logical block size regardless of the device type. After
that, the sd driver overwrites the value in sd_zbc_read_zone() with
the physical block size, since ZBC/ZAC requires it for the host-managed
disks. Between the calls to disk_set_zoned() and sd_zbc_read_zone(),
there exists a window that the attribute shows the logical block size as
the zone_write_granularity value, which is wrong for the host-managed
disks. The duration of the window is from 20ms to 200ms, depending on
report zone command execution time.

To avoid the wrong zone_write_granularity value between disk_set_zoned()
and sd_zbc_read_zone(), modify the value not in sd_zbc_read_zone() but
just after disk_set_zoned() call.

Fixes: a805a4fa4fa3 ("block: introduce zone_write_granularity limit")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 drivers/scsi/sd.c     | 7 ++++++-
 drivers/scsi/sd_zbc.c | 8 --------
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 6d115b2fa99a..d9be7b387e1b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2984,8 +2984,13 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 	}
 
 	if (sdkp->device->type == TYPE_ZBC) {
-		/* Host-managed */
+		/*
+		 * Host-managed: Per ZBC and ZAC specifications, writes in
+		 * sequential write required zones of host-managed devices must
+		 * be aligned to the device physical block size.
+		 */
 		disk_set_zoned(sdkp->disk, BLK_ZONED_HM);
+		blk_queue_zone_write_granularity(q, sdkp->physical_block_size);
 	} else {
 		sdkp->zoned = zoned;
 		if (sdkp->zoned == 1) {
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 62abebbaf2e7..d33da6e1910f 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -963,14 +963,6 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
 	disk_set_max_active_zones(disk, 0);
 	nr_zones = round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_blocks);
 
-	/*
-	 * Per ZBC and ZAC specifications, writes in sequential write required
-	 * zones of host-managed devices must be aligned to the device physical
-	 * block size.
-	 */
-	if (blk_queue_zoned_model(q) == BLK_ZONED_HM)
-		blk_queue_zone_write_granularity(q, sdkp->physical_block_size);
-
 	sdkp->early_zone_info.nr_zones = nr_zones;
 	sdkp->early_zone_info.zone_blocks = zone_blocks;
 
-- 
2.38.1

