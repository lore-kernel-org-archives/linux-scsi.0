Return-Path: <SRS0=3W2l=CX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29EEAC43461
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Sep 2020 00:35:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D78FE221F0
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Sep 2020 00:35:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="F2Sr9PqN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbgINAe5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Sep 2020 20:34:57 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:19485 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgINAew (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Sep 2020 20:34:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1600043691; x=1631579691;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ygpm7IRQfQLaFKbbiA4pC2Z0JlUnRkoy+qYbLfHnOE0=;
  b=F2Sr9PqNiZU17fT4BLpI8pNSGNTdV2ySMU51eMnUjK/CJgWc3nYKlwNM
   KlKxU+pg+d3YzlEsPuK2yxgrmXQVSJktPpueBYcNqx24fBFcnqSqijOU3
   eBekygTaK+NHuVTbz3HYCOQo/w+hjWflHjB22+3aYaVc2g4PCsnJyGCxc
   ja1kXB7yKoxfr+GO1V6e/PHaC7AJittfkoUnvH9PZRTilWmwteXfdXFqQ
   g7WIexhIas+3YJyTd6RndEh5Ck0vFJ9HrorCS//XBUhozMxl3O6rPGo9j
   46ZZ4VzRJ30QeHPC8D0/mjg0gHZJsYq/eMjPYJpCdD9LU62y5XeppNqdJ
   g==;
IronPort-SDR: NcvbNq3q90Gv6j96H1w+yZ4iOycr286LzKIXavALcPhYxeMFLU4NaGZwuQtrT8m+ILZEToTEbQ
 HduaVuoIbRDvKHAdRVEGEi/T3Mq5d+XNNySPEV+upC2dUfqUJmlw4S4SdHcEqyUQDRG/LHeudU
 HdJu8bZirl95VwaIkZcJ3g3q8vjdRWz7654Yo9oD7GzIGq2RV1Qgmn8CnTVEik77WiE8uL71hj
 j5WgYJCAlrTG0CFTZOrMzBTpHzHyjEX/0uqAryVAxZwVuXyrkAzZ01rlIbbEFz6Tr576hj/KkX
 OeE=
X-IronPort-AV: E=Sophos;i="5.76,424,1592841600"; 
   d="scan'208";a="256887864"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 14 Sep 2020 08:34:51 +0800
IronPort-SDR: OKAVY+eceRWDsurHYOnLseAT4KrTa6zh76Gui8bSd2s32UtIFvBBe6SFOR0GFTtX8MjNT0JOh4
 6BER6Cm8ccEA==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2020 17:21:10 -0700
IronPort-SDR: QWUpSZCdq2SeS1ZcjWJHgBJPaC+vRMARbtyUYuvbRn9O6R+kGQx/S1Gnt8LhaNzJ2Sn8luBR6V
 VfJpSd3pewog==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 13 Sep 2020 17:34:51 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Borislav Petkov <bp@suse.de>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 1/2] scsi: Fix handling of host-aware ZBC disks
Date:   Mon, 14 Sep 2020 09:34:47 +0900
Message-Id: <20200914003448.471624-2-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200914003448.471624-1-damien.lemoal@wdc.com>
References: <20200914003448.471624-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When CONFIG_BLK_DEV_ZONED is disabled, allow using host-aware ZBC
disks as regular disks. In this case, ensure that command completion
is correctly executed by changing sd_zbc_complete() to return good_bytes
instead of 0, causing a hang during device probe (endless retries).

When CONFIG_BLK_DEV_ZONED is enabled and a host-aware disk is detected
to have partitions, it will be used as a regular disk. In this case,
make sure to not do anything in sd_zbc_revalidate_zones() as that
triggers warnings.

Reported-by: Borislav Petkov <bp@alien8.de>
Fixes: b72053072c0b ("block: allow partitions on host aware zone devices")
Cc: <stable@vger.kernel.org>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Tested-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/scsi/sd.c     | 28 ++++++++++++++++++++++------
 drivers/scsi/sd.h     |  2 +-
 drivers/scsi/sd_zbc.c |  6 +++++-
 3 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 95018e650f2d..e99f57bfeff4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2968,22 +2968,38 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 	} else {
 		sdkp->zoned = (buffer[8] >> 4) & 3;
 		if (sdkp->zoned == 1 && !disk_has_partitions(sdkp->disk)) {
-			/* Host-aware */
-			q->limits.zoned = BLK_ZONED_HA;
+			/*
+			 * Host-aware disk without partition: use the disk as
+			 * such if support for zoned block devices is enabled.
+			 * Otherwise, use it as a regular disk.
+			 */
+			if (IS_ENABLED(CONFIG_BLK_DEV_ZONED))
+				q->limits.zoned = BLK_ZONED_HA;
+			else
+				q->limits.zoned = BLK_ZONED_NONE;
 		} else {
 			/*
 			 * Treat drive-managed devices and host-aware devices
 			 * with partitions as regular block devices.
 			 */
 			q->limits.zoned = BLK_ZONED_NONE;
-			if (sdkp->zoned == 2 && sdkp->first_scan)
-				sd_printk(KERN_NOTICE, sdkp,
-					  "Drive-managed SMR disk\n");
 		}
 	}
-	if (blk_queue_is_zoned(q) && sdkp->first_scan)
+
+	if (!sdkp->first_scan)
+		goto out;
+
+	if (blk_queue_is_zoned(q)) {
 		sd_printk(KERN_NOTICE, sdkp, "Host-%s zoned block device\n",
 		      q->limits.zoned == BLK_ZONED_HM ? "managed" : "aware");
+	} else {
+		if (sdkp->zoned == 1)
+			sd_printk(KERN_NOTICE, sdkp,
+				  "Host-aware SMR disk used as regular disk\n");
+		else if (sdkp->zoned == 2)
+			sd_printk(KERN_NOTICE, sdkp,
+				  "Drive-managed SMR disk\n");
+	}
 
  out:
 	kfree(buffer);
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 4933e7daf17d..7251434100e6 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -259,7 +259,7 @@ static inline blk_status_t sd_zbc_setup_zone_mgmt_cmnd(struct scsi_cmnd *cmd,
 static inline unsigned int sd_zbc_complete(struct scsi_cmnd *cmd,
 			unsigned int good_bytes, struct scsi_sense_hdr *sshdr)
 {
-	return 0;
+	return good_bytes;
 }
 
 static inline blk_status_t sd_zbc_prepare_zone_append(struct scsi_cmnd *cmd,
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 0e94ff056bff..a739456dea02 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -667,7 +667,11 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 	u32 max_append;
 	int ret = 0;
 
-	if (!sd_is_zoned(sdkp))
+	/*
+	 * There is nothing to do for regular disks, including host-aware disks
+	 * that have partitions.
+	 */
+	if (!blk_queue_is_zoned(q))
 		return 0;
 
 	/*
-- 
2.26.2

