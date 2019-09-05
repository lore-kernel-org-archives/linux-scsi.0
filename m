Return-Path: <SRS0=/77Q=XA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60369C3A5AB
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 09:51:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3934621743
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 09:51:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="IyE8U2Tn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387610AbfIEJv4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Sep 2019 05:51:56 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:25315 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387607AbfIEJvx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Sep 2019 05:51:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567677113; x=1599213113;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+BoXKBI8NPREtCwEN8cyWiTl5gToB5DcHyIz5CI6+dg=;
  b=IyE8U2TnHaj/SO182xF8jTnU6cllqZ4hzkd/J9M5mhTzXw0qRJzicyNm
   8iiUjVdbcKiMmn5lQ599UL875IF8IIEwsZ40GPpJvM/xrrvq2y1ii1h0r
   GjPRT8BAgC3pZbYiXjNk11T00oucDaKzsiC+Omi15uZmg/Tl07NxS8LbE
   Xlwdpy4iQ3z2IuAPl4giL00tW24fDLhJaYMyV4pukNY8T2pKe0d0O8Wmy
   A9x1LKnGLLjMvFCVDzEaNhBEoRRJ0ujhhX5VZxMPgOMsWM5lVQGVFGPei
   c4e77MMExRrK6vRNChIdHClgWJa2x4bE4Rq+KnNWXtg4SXPzE01VnbmR8
   Q==;
IronPort-SDR: ZBSUJ9PdxT5HhlFOZlLQtTzhRuCVA6744fzrJHazdbHyv+uphG8GOOso+LyjxCuSxPmifY96rK
 7GxjgciPofij9CeUnpM496Ul0yxbsf6pXvm5zdm93mpDaw5h5HKqSGp9rTghDOXNq7y/Cy6kpY
 USNVmSVWD5oHNKW6ciClquXXgJp+Qe7Fw+pZUIayahDWSR2sHkLwhb+n6R6erBj/5jxciQTog9
 1siD7SvXS/4R0CctccT+9k3tAgeyt7mUHHuw4NBUw6dH+LK4wCYCl86s29cMaOQSzCyh/wAMCY
 pxw=
X-IronPort-AV: E=Sophos;i="5.64,470,1559491200"; 
   d="scan'208";a="119106279"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 05 Sep 2019 17:51:45 +0800
IronPort-SDR: DBMZ8xCL01vkbdFnc3A27SMhxRcyWMwtRv+IGzJiQXP5Na+MXGEiww8Vwxa437GWwHNA3rjLo0
 11HKYvWIe/5SjmqHc8uttg3AI3tTGYaLPn3ScWr1gZQuyFyIsXqlwPrgb6DJSCqO1to0xZJX62
 /vFfylOoLdI1S2GLrRgK2uJ/ZOjYrLQSK1sG49I+paA8x4Qkmhrd9gy/MWlGB11F62Mdam6iuw
 epBbC+B8sPldPA0xcm4Q2/ufOcQ7SMkov4tVmInbrMaCGU0VR+fLBZwoLwMaynS2cAtnyj7wyr
 Tq2feeV/cNM+gaG5nYppJa1v
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 02:48:41 -0700
IronPort-SDR: Lfq6lKAztSB3r+9NM2ybsRXa847PgYMz1cpkVkbcK/5O6l3KjTn47sJkjX5sYzZqM87vEd1H6B
 sG9XxTFxstHIIo72pzsTUpcc6Fhx7YeajeAOQ5LKHGg/dFXkMzxS37QPdMEsu3t7TGfpLSo1DW
 wj2SxRsBLQmESwEevJYsqoPyBT1lpzoHfiV+OlSiIXWo+/k3kXIziEVFAacN61BY6o58Vuo+4R
 I8n4EuROm7l/RIY2WszBVXC0p6ySS4motlLqbWs+K95qbP1LvMlIGUPC4mcVGFhpzlf4aTPCXs
 Fis=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 05 Sep 2019 02:51:44 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc:     Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v5 6/7] block: Set ELEVATOR_F_ZBD_SEQ_WRITE for nullblk zoned disks
Date:   Thu,  5 Sep 2019 18:51:34 +0900
Message-Id: <20190905095135.26026-7-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190905095135.26026-1-damien.lemoal@wdc.com>
References: <20190905095135.26026-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Using the helper blk_queue_required_elevator_features(), set the
elevator feature ELEVATOR_F_ZBD_SEQ_WRITE as required for the request
queue of null_blk devices created with zoned mode enabled.

This feature requirement can always be satisfied as the mq-deadline
elevator is always selected for in-kernel compilation when
CONFIG_BLK_DEV_ZONED (zoned block device support) is enabled.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/block/null_blk_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.c
index b26a178d064d..b29b273690b0 100644
--- a/drivers/block/null_blk_main.c
+++ b/drivers/block/null_blk_main.c
@@ -1695,6 +1695,8 @@ static int null_add_dev(struct nullb_device *dev)
 		blk_queue_chunk_sectors(nullb->q, dev->zone_size_sects);
 		nullb->q->limits.zoned = BLK_ZONED_HM;
 		blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, nullb->q);
+		blk_queue_required_elevator_features(nullb->q,
+						ELEVATOR_F_ZBD_SEQ_WRITE);
 	}
 
 	nullb->q->queuedata = nullb;
-- 
2.21.0

