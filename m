Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59036C678D4
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Mar 2023 06:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjCFGa3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 01:30:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjCFGa1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 01:30:27 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E890F166E0
        for <linux-scsi@vger.kernel.org>; Sun,  5 Mar 2023 22:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1678084226; x=1709620226;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=E4iV4xvahTmHMQD7BKoNYpecUduq8BHTEgT5FNxM38w=;
  b=GtxqUQsdJAdS8k1aygykgoEAIXpQB/3ZLlS/FdljvAlXJnGCIOD3jxnE
   4PUIdfDLwx1oQ4e1ObC1zL5dykPIYiF5n1EPKHBcRmXz1UURPowfehR2F
   +enZu9a+UZ0Z69GDvvoc/pWjgaJR25oHSbfWeCZByI8/ZS9Odw1eAMK2d
   mDnz3rtTBMf3CHvwvfQLBZPZPhiHRCBkXSHGfUoCiPvXeAUM/FeMEvq3z
   ac5e9ahQLoHgSOLQwhAAa9S//paks5tr4tcryHFVqdtMX1H2ImjzmP4Op
   XOzJCS0r0uFxLbAbGoMXcH2O31cURQ85yUgAqYiNox9ak9KgqA/t2qqxt
   A==;
X-IronPort-AV: E=Sophos;i="5.98,236,1673884800"; 
   d="scan'208";a="224875380"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Mar 2023 14:30:25 +0800
IronPort-SDR: ugjzdZoHTcvdZ3GpJAa35Y7gts2Hx7HFaeBD6eyMsO3RUmSTnu+cBg/IMiQ9EIpRa2qz3U5xWC
 mW38QKy1IuUPAk8ownSVI2Hzwh3geZsZnf96dYSfy0fOFuzF0Ti3mYsCiI9V5rAaDI+AUVcjwh
 f08lUDrE9bq5UCC2PkaokfU/A+hlOyNMmKi0GwAU1mK2h20ixvGnsHohthqwde8cSuZeIDG0NS
 8izf6xhJiYgQcLPI8xO3hx+QFwbCUI/bK/Zt8bma2COpG1MVYMeoJYX6YqSBQMJm9gzKRtVdw0
 q9Y=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Mar 2023 21:41:26 -0800
IronPort-SDR: AaJDnmgyGwNlt2nEtaTPLSxljYeuT3k4071tOKW0t66YcG7nLp4+otTwwTC+dV0750TIh0CA7g
 yloDryvxTFNY6sjPoWlzVBDU2WfahGXOaukiWOgN0UG9z81SuGgr4a55VcAXR/iPm74rSuxEgv
 UUo/EFJHfXALub9oh7a+PSnxuXTczndtDyXrbiZ90b4WRGvgqc4cOomjLkFvGAK/1kYJxRYGSt
 Zi0OmHGfk1i8lz/muYWhljVLbJhbbiepdfEe+IQmNMl7dev0BiyVabNwZ2PEiIWfqRtJasaylY
 4fo=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 05 Mar 2023 22:30:25 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH REPOST] scsi: sd: Fix wrong zone_write_granularity value at revalidate
Date:   Mon,  6 Mar 2023 15:30:24 +0900
Message-Id: <20230306063024.3376959-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
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
This patch is a repost of the second patch of another series [1]. Reviews
and comments will be welcomed.

[1] https://lore.kernel.org/linux-scsi/20230303014422.2466103-1-shinichiro.kawasaki@wdc.com/

 drivers/scsi/sd.c     | 7 ++++++-
 drivers/scsi/sd_zbc.c | 8 --------
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4f28dd617eca..4bb87043e6db 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2988,8 +2988,13 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
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
index 6b3a02d4406c..22801c24ea19 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -965,14 +965,6 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
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

