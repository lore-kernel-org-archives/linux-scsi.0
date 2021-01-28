Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27654C433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 04:51:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C699964DD6
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 04:51:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbhA1EvL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 23:51:11 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:22074 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbhA1EvK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 23:51:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611809470; x=1643345470;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=To8ibe4IoXLbKNtSVr85Y+rPsQgn0MZHdGIA9grMAlY=;
  b=V6Ghz+9Axl9/yxaIYG7lGwYPUcczyjlkCd12ZDmFkD36LLfHCWWFUl8H
   IHq4ZAfggWMquiwyqVtPu7tdkb8dHEYjY6za36o8NM1Z1XKc+Y0Xw3ZSh
   AeRdeB4+xd1wgnCX6jP6RW/UagwkgNBZYiEl3nih0m2jaOTDPERL4j8i4
   FsqIv6RS+KYIyK1rg+wiQtAT0AksM2QNh0cggUaPB2D0wBZ0g/GTYvp+4
   I2wJnY74OpSa2MQjCGohy8PnL/TaZe3A38ypQoh4hf4t4XS3YS5I4WWxd
   iRTjnIOTsbpoEvJSpb3wysrufZrGJqxrKiF6OnsnDo0rKt4ruo7rwOJNe
   w==;
IronPort-SDR: ZzXf/Kormxb38aYW+flfF650NDqrl6HT4+FXHdT3upBqeQFI15Y7+7ojlsHEk73B9845KJ7t2I
 9jAgoqMAN3TOpI04bcIe94r/1nrNJkMdcqf/qVqqxqXZJv6s+kZLuH4rJVRkfYT9pE4S3TpBvK
 RvVNAlqG1zT4mxVEV7gA+L+jZnhqrWS7NaHIG1+oGVpXbK4YzEYPKE7h1QG/b54bI7ybnfJi1A
 i2vuBgxu6cLXpNR1Mx7cTsK8Vc5wtKLEJrWVxwXE6TtxN/y/Zli6tarQHRHxq6pVGUWcwuETu+
 bgY=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; 
   d="scan'208";a="158509145"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 12:47:47 +0800
IronPort-SDR: wh8YZcCoSyyWdWR0VSoWJ15PVnbFMMJBF8ne4V7ZDqHNXlH2n7XITa4uC9ogPBFksc1FgWWzzy
 etep7vdPiGTaUzrTLdz3QnM4idi2ERDtuLzgpUoUAcrFi9c9Oyawg0UiEorC0UjMmOR6oxKSX9
 ETcAFEOX47PvHxOfIGwMM1i/3MBaCilLB6BilCrtgV3liAwNMQEkerKjO2yeibGOLlcYn8oDXu
 w/nzmekLtD/QVO+wn4c8Yz1a5om0uugSJyd01U0d9gsIB0mK7HR5JmvP16iE61XoDsP52+qe6y
 5mXFPiaN4DGRlpGgDTCjFOFU
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2021 20:30:05 -0800
IronPort-SDR: kgqL13pGkC8QABIy4e6bYHJfwv9FlTi5e0mJkrgoRIiurS/qlobH/8gLRvVFaW2WqnXxqAx0Zk
 X1xIeQcLXveAeTMlasw9QF9po0Xl1/JmRVWjPqXx/LMqeXisQUsKKLWvTzwXJoeHpQ/4EL6KW0
 FwVwB5RH6c8vow0S5BXbHszwhzUvco0p2cKlowbRu58yxbUvzTwJIFzkJwTI1MwQdqmntJeFZY
 7/OH+3s/0PkTZM79M+d9+Oc3Oz586aak3QVemcPXkEKBJlwuBrhpp6S9b2bPVlR7/Cjl79oxwc
 bMg=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Jan 2021 20:47:45 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@wdc.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH v4 7/8] block: introduce blk_queue_clear_zone_settings()
Date:   Thu, 28 Jan 2021 13:47:32 +0900
Message-Id: <20210128044733.503606-8-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210128044733.503606-1-damien.lemoal@wdc.com>
References: <20210128044733.503606-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Introduce the internal function blk_queue_clear_zone_settings() to
cleanup all limits and resources related to zoned block devices. This
new function is called from blk_queue_set_zoned() when a disk zoned
model is set to BLK_ZONED_NONE. This particular case can happens when a
partition is created on a host-aware scsi disk.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/blk-settings.c |  2 ++
 block/blk-zoned.c    | 17 +++++++++++++++++
 block/blk.h          |  2 ++
 3 files changed, 21 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index a1e66165adcf..7dd8be314ac6 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -910,6 +910,8 @@ void blk_queue_set_zoned(struct gendisk *disk, enum blk_zoned_model model)
 		 */
 		blk_queue_zone_write_granularity(q,
 						queue_logical_block_size(q));
+	} else {
+		blk_queue_clear_zone_settings(q);
 	}
 }
 EXPORT_SYMBOL_GPL(blk_queue_set_zoned);
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 7a68b6e4300c..833978c02e60 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -549,3 +549,20 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
 	return ret;
 }
 EXPORT_SYMBOL_GPL(blk_revalidate_disk_zones);
+
+void blk_queue_clear_zone_settings(struct request_queue *q)
+{
+	blk_mq_freeze_queue(q);
+
+	blk_queue_free_zone_bitmaps(q);
+	blk_queue_flag_clear(QUEUE_FLAG_ZONE_RESETALL, q);
+	q->required_elevator_features &= ~ELEVATOR_F_ZBD_SEQ_WRITE;
+	q->nr_zones = 0;
+	q->max_open_zones = 0;
+	q->max_active_zones = 0;
+	q->limits.chunk_sectors = 0;
+	q->limits.zone_write_granularity = 0;
+	q->limits.max_zone_append_sectors = 0;
+
+	blk_mq_unfreeze_queue(q);
+}
diff --git a/block/blk.h b/block/blk.h
index 0198335c5838..977d79a0d99a 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -333,8 +333,10 @@ struct bio *blk_next_bio(struct bio *bio, unsigned int nr_pages, gfp_t gfp);
 
 #ifdef CONFIG_BLK_DEV_ZONED
 void blk_queue_free_zone_bitmaps(struct request_queue *q);
+void blk_queue_clear_zone_settings(struct request_queue *q);
 #else
 static inline void blk_queue_free_zone_bitmaps(struct request_queue *q) {}
+static inline void blk_queue_clear_zone_settings(struct request_queue *q) {}
 #endif
 
 int blk_alloc_devt(struct block_device *part, dev_t *devt);
-- 
2.29.2

