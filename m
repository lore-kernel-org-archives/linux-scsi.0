Return-Path: <SRS0=LwoI=W7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BDC6C3A5AD
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 08:43:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3434E22CEA
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 08:43:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="YHJn0MQx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729255AbfIDInD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Sep 2019 04:43:03 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:39226 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727929AbfIDInC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Sep 2019 04:43:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567586582; x=1599122582;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=65sWvjk5mPPhDUCeQo2jzp42YPYH5RvbY9fx3ldHQWY=;
  b=YHJn0MQxDs/v4stNLENfO0q5iEVwdgY3nFKdfjQ9jMEHyJOFKpvY2URh
   aFhOdGRy1ABIqLShfmJQp8J9WE3vOt/X2F5PaySC78FtwnpYV2t8+xFM5
   uaaCp2pub06JGINrLuDEPsfBKH/n+qtBpeVDw/BCOBhBKn3ubR/l3KCqm
   XEq/fzf7NQBvYivBD9Cni7aD/kOFMlta+ZIWBf1UAUalVYMczNZR4Ma/R
   C9dcoIQOo8d2+UwKzzjggz016D1EXZvrkyqD9uYZrOmyn0TGVXs12u8iJ
   h2px0Tq1HrMv6er41BnXZTJQ4wMHe/pFMwXUfWFeWmxSdlbezsOSjpp81
   g==;
IronPort-SDR: fW2ClYUlOf5U/4T+uwYAGTZc17TbPMqvpvGs+9o5wUjAirlUSXXUodoxkOcIUd7PhNh3ZuAGOd
 JeJUABggq7XyNlFFNfcxA3HNlHdkBL6ICrmk0JSCkh3qm1zcC0ttodYPqrHOcaBJl14/7aIFEr
 02chGCP26UP6P2KODNxz8y9FLvLxAvpFYtkiBMH4dqeerczoXR0pzd0o2CkDHdblZ7k1hd/EHD
 VMp+va54AJoOJxSu6p1URdJK9ae2VJehS1Wxb4KAnNo06sPmDdB2KJq7ceoMK90CdWrb5OsjhC
 3xg=
X-IronPort-AV: E=Sophos;i="5.64,465,1559491200"; 
   d="scan'208";a="117374689"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 04 Sep 2019 16:42:56 +0800
IronPort-SDR: D76xAKBuOxsMiJKEnJs9r+66lSxkXGRLhPT7aQPS4T1p90cnnZAbVlhFPUzYL1n76DfjewX7Eh
 t+bheACs51qxVrjAcbFa/4AlbHTMc4Fq0Mht1y7au2xOTb+/0bk3UJTNJi1BfvotDOFZGq8M4B
 zLtKcpCtcgfCkyV7VWJn0htFMJt75prqPZSZESRkEByfJ3uVgK1w75VmcD3ueclxfBgHPpcot8
 +PbyxZQxYSd3Z6/u56dIdTJ4Vkd4sbmTfNgnR8sV/ClPawuBqktpHgtBjTkFWr0sa6nrKtWxKU
 YRAOU786riM4FN5TkHSf2owj
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2019 01:39:54 -0700
IronPort-SDR: gF/tvgc9dPWmXlj5N6N9a7caqNGW332k+/U/Yrz/Nvuoe7JK35iVWpBqGdtdHtOAvSjhpTY6Jm
 XZ4GfaX0L8d0C0GQ5UQ0iO68x4OUq6RR63SXxFZAWzv2AH+5S39oaqcYmWREMdF5Gj0FJOPgUw
 FHrl+3VGKobfXZBMFyd1mY56Lejzmxr7TCyo7CgrhMG3a7AiDUsNvafA3+x8MHYb9AZHeI38wq
 h+OJ0r6Yh+Gjq/SOzzwe9iPbqkdILIskJUk5K4/q5WR8pUZ/TftNVZjI0PQuQxgSUkI1Y0V85N
 vDw=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 04 Sep 2019 01:42:55 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v3 7/7] sd: Set ELEVATOR_F_ZBD_SEQ_WRITE for ZBC disks
Date:   Wed,  4 Sep 2019 17:42:47 +0900
Message-Id: <20190904084247.23338-8-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190904084247.23338-1-damien.lemoal@wdc.com>
References: <20190904084247.23338-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Using the helper blk_queue_required_elevator_features(), set the
elevator feature ELEVATOR_F_ZBD_SEQ_WRITE as required for the request
queue of SCSI ZBC disks.

This feature requirement can always be satisfied as the mq-deadline
elevator is always selected for in-kernel compilation when
CONFIG_BLK_DEV_ZONED (zoned block device support) is enabled.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd_zbc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 367614f0e34f..de4019dc0f0b 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -493,6 +493,8 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 	blk_queue_chunk_sectors(sdkp->disk->queue,
 			logical_to_sectors(sdkp->device, zone_blocks));
 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, sdkp->disk->queue);
+	blk_queue_required_elevator_features(sdkp->disk->queue,
+					     ELEVATOR_F_ZBD_SEQ_WRITE);
 	nr_zones = round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_blocks);
 
 	/* READ16/WRITE16 is mandatory for ZBC disks */
-- 
2.21.0

