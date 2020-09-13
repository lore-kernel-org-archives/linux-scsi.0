Return-Path: <SRS0=npVx=CW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14FBEC433E2
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Sep 2020 06:03:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C392721655
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Sep 2020 06:03:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="jqElMUUC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725920AbgIMGDQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Sep 2020 02:03:16 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:60244 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbgIMGDK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Sep 2020 02:03:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1599976990; x=1631512990;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZUbVqWuuZoA0ZQHXbwKVfA8exH/uMbHKkSc99fRXoEA=;
  b=jqElMUUC4q6dKTSym0/vnl30G4VaYlxZ4AxOM6ym2vx4MHA5PjQ1G5/b
   XS+AoiFd4iigFoQkB4RzHP6Ug5WpxpibTIkpsHRS9wUbxV3yvmeYmUMvQ
   EhoyI4cuZTHuZrXfh6VGQ6xiwkTuYEs4Cme3nd2/oEA2+OzwZDkRfSijO
   tJHKSnCktXRxTVhDlM+QOiB9A17L0AZFEDG7BYwtijD/EyUoLXM28tKPf
   lN3ZpP8Rxwm63UZZRNoWWo2DPm/i1AEo60GpKawuwleA+YSnShxE9F/eL
   KQJ0zD0xHSMIO+EmmqUM3yczNXOJSvq+OPb7hdoe3Bmj3vB+dJkrBL0NG
   Q==;
IronPort-SDR: KY6xSL4u3/ommgeA+S6SYfMPVWa569W8+4OH7AyNqEcnaBrkcE3Ti9LFCFgGIGy5Q4N3v3/1uw
 5HBJLeC3U120lgyQxQVlHgO/k+RLxNpyNeiZOTJYGdikQMAu+QTXNygf3m99li8fuSNmkevDTV
 /Lh0eyToNmuO/wpLuAFEHz48+M/U559eUM6ljKo84bMwPYM+J0YMW5NrmdLv41kKG8irW8ll7i
 Y051Qej8E/dI6K0+fBHGG6KAps51d6w0vho009wYM0mhcM/SZ10luH1PJw9JC0mBNURlhtkSBA
 A8Y=
X-IronPort-AV: E=Sophos;i="5.76,421,1592841600"; 
   d="scan'208";a="148458732"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 13 Sep 2020 14:03:10 +0800
IronPort-SDR: dPQMEvcbtEUyo3PB4O8Im7EFyfMOO8U4U+FHRQrCR8iUOA3JD6UbBOczM5yzbpr5pgd0R5AdPr
 jDy597nQuHbQ==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2020 22:49:28 -0700
IronPort-SDR: 2ZAfHddjima2jQnl1LuWCagNDioY5z44T8WYMlb9Dg/YER2tebNEqCEK7GbMNstI8DnJceAEp2
 s5wTewPKLjSA==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 12 Sep 2020 23:03:09 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Borislav Petkov <bp@alien8.de>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 1/2] scsi: Fix handling of host-aware ZBC disks
Date:   Sun, 13 Sep 2020 15:03:03 +0900
Message-Id: <20200913060304.294898-2-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200913060304.294898-1-damien.lemoal@wdc.com>
References: <20200913060304.294898-1-damien.lemoal@wdc.com>
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
---
 drivers/scsi/sd.c     | 22 ++++++++++++++++++----
 drivers/scsi/sd.h     |  2 +-
 drivers/scsi/sd_zbc.c |  6 +++++-
 3 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 95018e650f2d..7f0371185a45 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2968,22 +2968,36 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 	} else {
 		sdkp->zoned = (buffer[8] >> 4) & 3;
 		if (sdkp->zoned == 1 && !disk_has_partitions(sdkp->disk)) {
+#ifdef CONFIG_BLK_DEV_ZONED
 			/* Host-aware */
 			q->limits.zoned = BLK_ZONED_HA;
+#else
+			/* Host-aware drive is treated as a regular disk */
+			q->limits.zoned = BLK_ZONED_NONE;
+#endif
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

