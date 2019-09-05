Return-Path: <SRS0=/77Q=XA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DD79C3A5AC
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 04:29:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1325216F4
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 04:29:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="l8aH9mK5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731164AbfIEE3N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Sep 2019 00:29:13 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:62214 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731140AbfIEE3J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Sep 2019 00:29:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567657749; x=1599193749;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=65sWvjk5mPPhDUCeQo2jzp42YPYH5RvbY9fx3ldHQWY=;
  b=l8aH9mK5aPNCiTRc72gFbv7NMotqYGVCseRQ9f+hMFZHay5ob5glBKkZ
   +cqD6Xvn6MvyNEIODjX0rfL8MQ6VxI19HwTA9wbSZZIAGZN0cQJhc/QAd
   5TI7RJo7AcRNQOeNgTYEll+1KESovzWo91UDRhhc0tjvDsg4xOHWdNtxg
   z0xu1kNXfAvsidYuBDunTn9w8NQaoCOaJ4gOGOrgCKpx0lWhhQ51d0pUo
   h0c9ZGbPvoZA2yC5gFc8dX6p5LSIg9twr6YHxwCPzPU0sdOYBz6TWAn/y
   bczvU0rYXhyJ1ZMGqovw5Sr9Q2dRmJZMeCZf6rfS88cC9xKh+yAdURMWS
   g==;
IronPort-SDR: /EKyNmmf4atwxwTTgUA3YmP0VVAtNmxF6nuKJtMqhf30VnhQvGovWG6UILUtOEbnSN3f8dj8Fj
 3IH0KIIQ49QNAapT5NnrUdw00f6aU8RAznrWe2EtojRvaljPF2Nunh3mDfpRW/+Mu5O4syHrQv
 qtjGXjFjongqZzcE/VsIgC0u9Hzlnv0TFyRKnsEc9jgWqYWU06/Wux/rxcH+spxXoPcDs/EWhi
 x60Rd0GGQlpgvGtfkKmKjN+gIU0PZdTwI16oHahZQxseAiGXhZEt4KPNhPNV39RY1MHdFTQ8O8
 roA=
X-IronPort-AV: E=Sophos;i="5.64,469,1559491200"; 
   d="scan'208";a="224233093"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 05 Sep 2019 12:29:09 +0800
IronPort-SDR: MPu1iP1wkf/yMTm7JAI4whcE7h7odByJAJMXQQOOcApZpzK4VukS2xdy0rEJQ8FXYUj0+BYYkk
 pw8Qk2OEx1uUggQdyZd3CPSTupEUpUAvfT116FeClXZIx2ACTSeMnVRiYmZqaybhcqHjRcy1c1
 Dl4giJbNacnb95oNV6ovcHyELF4OzjLnf032EikhcuYyWslliWycBBW66652UgVaUQyE7C7psm
 FPFbg5L+iuNuJvweAjY6bkz+TQAVMctLx3a/76q7wZiZrDTnE025cx6G9zdS0+Bj+of67vsIVZ
 M6rlJc3gbKvtML6kVm3yuxsV
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2019 21:26:06 -0700
IronPort-SDR: 8jLHssMECvseYIfjnYTSMmWNsvyMmOBavRkz5cE4gaygANlGisDWyTDuWrqC/id8k+DIpYx1mi
 d+KzhDHmELmXjgGW4RRVV7OthK2AT+YAgx+h7N+z80kUnCRp+LzQj7Yn0VtKTteGK3Rz1nhzYu
 dfU0dPgDPiPooZ6diDBvo6NWOXfy+mn2ZmB0UvO3e3AVGnY8VMY5RLk3cY2Cw4DjeptQhZAU+o
 UDyCkZmcrkCySMrlThOMCugvk7B2AzKMO0ro73e3UidITI3vOSwXTomY1gvOsgq3WrY6TBx8u3
 /TA=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 04 Sep 2019 21:29:09 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v4 7/7] sd: Set ELEVATOR_F_ZBD_SEQ_WRITE for ZBC disks
Date:   Thu,  5 Sep 2019 13:29:01 +0900
Message-Id: <20190905042901.5830-8-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190905042901.5830-1-damien.lemoal@wdc.com>
References: <20190905042901.5830-1-damien.lemoal@wdc.com>
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

