Return-Path: <SRS0=d3SH=WY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DFE8C3A5A4
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 02:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07034214DA
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 02:29:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="p1pZcsW0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfH1C34 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Aug 2019 22:29:56 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:27210 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbfH1C3z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Aug 2019 22:29:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1566959395; x=1598495395;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=zuaGrHzLFfFwh6t8l98WhH8u3qcFJURYB3rVEoJTqok=;
  b=p1pZcsW0GGbtKf4vyHBoSGbHwLOUexXnY54pBqZaQndI2erz18BGQRyU
   BmWVFWDbfpu6EAcW5zAjW5t6u5JAviQ7KJOYPelsEQAtlEvNE1UkKwGhz
   bZ2xIPfYC6hh8fCQIEsCZ9FJvj67TzA8eLFYzuTMNWwg/n/4JcpiBbuor
   b4P5+utSkDjOrF1COa2OfCF8TEsBZI0I+iEABPijoWhgGRCrN9AgJx/Pk
   tT0jO7MdAQfZlSTN/fmr+LwPsUUPRkklgeG5Jq6zXFa67cFi6sCFGQQ0g
   A3ogbHti8zXDmIen/AoyFbHFYGS0ie3qI/z1QzMx+ixGWlA/EpsCK+X6i
   w==;
IronPort-SDR: UL702fvGIcFMDinc0pXsQwirr3DbOu8D03yvVVGrN+DYxcsCvRODfDoAME0S3a26Z4KNkIDPfa
 HuRSh4bOph/Vi0miCPJwYb0SIUqQl1fNw0v/Az78sNFiETcz5OCnlC0fFMF3DrjOA53MF7M+wc
 gL/gnGB5OjTn0Uw6akvu7FNkBDe9ofsRUACiXmB/gKoUZmt0L+G0eCGujqJPYVjSofbL52BPEi
 6b1UvSfC3Rto4VSRH2v59Pb/umZeHZ/uAEFYEoanDghLdNiBjh61ww5vo3j9dQJZuDYme8euAo
 B1k=
X-IronPort-AV: E=Sophos;i="5.64,439,1559491200"; 
   d="scan'208";a="223475488"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 28 Aug 2019 10:29:53 +0800
IronPort-SDR: GyvU8HWSfoAPEZODSXxZ2fWRD8d5p7Qm4UAAO8YPvk7H6HZf/d6CBKKVyOWzhWPqFEGK0ZxRAc
 LXWL5eQmWALXxfFMQFAhrfR6aaEsLsnEAI8wL1ONfhJSXEafuaxn/qBRcYFN8IBkv6KPtwCfon
 FmzCSfomvLgSHTtUmhAjnnEkLxUUiqS3BAp/FTF98luf+77EFEOOhnKUHx3WB6vkrNDZAxQ+U0
 zoDmNWcTXq6K2G40tujKoMbG526L8ziLBoA9jurJQ8y0zpbqbXUVFyTXL9910CB9sHzSANk+Tt
 sj/XtBqfzt58G7jy39SFV9xc
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 19:27:04 -0700
IronPort-SDR: HXII3iPkzyRKsxh7C2BU010VdYUSsC+2z3LjCXKCp7b8fHT/jKA/FU1y3KDUmm1yYGHOKlzNlX
 6L2vlwEc8bG3P94I2f0yvRRXeGdDQdE9P4ZCKvaa86h2/r31TQsnfH0bgKXCEPPmIHUt0ojsca
 oOHkmJXao0m8LvizhFtgz66W94WvYNyE9v/dsLy6CTAa3L9Ff6Ca+7geSPCPi8A4/wMs3hEO0c
 xAUBEyblKTx/g3lsnhohIb16oYvgBkmEp0ngEdYSvK86564LceQgPnvPUgEtrqWzcjKcCKLQLO
 AT8=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Aug 2019 19:29:53 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 5/7] block: Delay default elevator initialization
Date:   Wed, 28 Aug 2019 11:29:45 +0900
Message-Id: <20190828022947.23364-6-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190828022947.23364-1-damien.lemoal@wdc.com>
References: <20190828022947.23364-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When elevator_init_mq() is called from blk_mq_init_allocated_queue(),
the only information known about the device is the number of hardware
queues as the block device scan by the device driver is not completed
yet. The device type and the device required features are not set yet,
preventing to correctly choose the default elevator most suitable for
the device.

This currently affects all multi-queue zoned block devices which default
to the "none" elevator instead of the required "mq-deadline" elevator.
These drives currently include host-managed SMR disks connected to a
smartpqi HBA and null_blk block devices with zoned mode enabled.
Upcoming NVMe Zoned Namespace devices will also be affected.

Fix this by moving the execution of elevator_init_mq() from
blk_mq_init_allocated_queue() into __device_add_disk() to allow for the
device driver to probe the device characteristics and set attributes
of the device request queue prior to the elevator initialization.

Also to make sure that the elevator initialization is never done while
requests are in-flight (there should be none when the device driver
calls device_add_disk()), freeze and quiesce the device request queue
before executing blk_mq_init_sched().

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/blk-mq.c   | 2 --
 block/elevator.c | 7 +++++++
 block/genhd.c    | 3 +++
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 0c9b1f403db8..baf0c9cd8237 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2893,8 +2893,6 @@ struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 	blk_mq_add_queue_tag_set(set, q);
 	blk_mq_map_swqueue(q);
 
-	elevator_init_mq(q);
-
 	return q;
 
 err_hctxs:
diff --git a/block/elevator.c b/block/elevator.c
index 81d0877dbc34..433ce722cf0a 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -729,7 +729,14 @@ void elevator_init_mq(struct request_queue *q)
 	if (!e)
 		return;
 
+	blk_mq_freeze_queue(q);
+	blk_mq_quiesce_queue(q);
+
 	err = blk_mq_init_sched(q, e);
+
+	blk_mq_unquiesce_queue(q);
+	blk_mq_unfreeze_queue(q);
+
 	if (err) {
 		pr_warn("\"%s\" elevator initialization failed, "
 			"falling back to \"none\"\n", e->elevator_name);
diff --git a/block/genhd.c b/block/genhd.c
index 54f1f0d381f4..d2114c25dccd 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -734,6 +734,9 @@ static void __device_add_disk(struct device *parent, struct gendisk *disk,
 				    exact_match, exact_lock, disk);
 	}
 	register_disk(parent, disk, groups);
+
+	elevator_init_mq(disk->queue);
+
 	if (register_queue)
 		blk_register_queue(disk);
 
-- 
2.21.0

