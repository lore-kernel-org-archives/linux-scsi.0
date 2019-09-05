Return-Path: <SRS0=/77Q=XA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 758AFC3A5AB
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 04:29:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AAAF2082E
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 04:29:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="oV/nwFGk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731158AbfIEE3K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Sep 2019 00:29:10 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:62210 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731138AbfIEE3J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Sep 2019 00:29:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567657748; x=1599193748;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=pKvixMi0uvmO9/2ZT4Cg0TZHXdkq6iCNQjN+mXlVvMo=;
  b=oV/nwFGk+U7z1U/Oa4URmDAhZrCi10/vRXW0JYS+1ov+DM5fXbI10zuu
   1AIndhXvy9HVh3X+9cgjUttj5T4KLrFyWG63a65oixsbhc3VuHOILNmPk
   XzzvUTksMXc4x6nEXyOAt5Xykb+g6bAoU3CIpv0qKt8Lac1x6tLVbjyKt
   3FM/vQKiX4chd2DixuMo+S/8YZchhpZRhFok7zxQTwaBqxCBuEBw7qs2G
   8+QxHgtnBzUt3Qx+/OCSoe6Eh5ZgJ7LIKFs6iPcgJejuNmaQ5s5Ajbn5D
   4M/lm1BFfO58h0+zpgWgRgJC7OmaBA1qutoANvkW7FCJglmqQmtyX8qrN
   A==;
IronPort-SDR: q3Fy13O6/y2ZU1Hr0CTNZeYtcmdUcfr3WmBVXZz6a9u01PDTjzPYh579ocRJOyxN+fD9JkEezE
 5+MoOx1zUjMXpiJh3DiHHTopTqLLaDGe50OOqlE84U3MquoOrYUzUf0aoexzru9flnVvFeMk3T
 tO1P/R1N1OTynqO+fgkjd0KQTObKjfV+LWnsSeyJcl4ZlXapiiY8fjALvdi6I/8LI6ZZnZOYoH
 YH6SafiedTkpuOlK/bfHBmkmuo4Q3zGhGWqeVSqOOF9kPNi3ckD9grus69NVrn44mHJ1MQ6DYC
 WPs=
X-IronPort-AV: E=Sophos;i="5.64,469,1559491200"; 
   d="scan'208";a="224233090"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 05 Sep 2019 12:29:08 +0800
IronPort-SDR: NtZF9dqfk+lWrQDAwOj1Q7s41q1CW9qtHWCCKnodqawwIGR9xy8wOCKf6nQp4Y0nMNecsNdqGv
 fK1sEWds2qWu2Qf4qMz+ed5H+IEvesDm2/UZO++V0nx/CdaQdXSYwAa56LDL/GqFe+oGr+Uu0l
 xudF9zy0t2vEbF8829GFfBVSt7X50M9l2k1p5hRrlt77esDq0YdF9tYX2XTCWCn+CXtip7ofB8
 3Itk2kG0dCmt6gKVdAUCOWj6FheZtMhmBh0jJYtD1S85S92lvPYZoTfEyeRAxhFs6yfXIQsA2p
 ic6v3PLxk2O6EWWcAomA5nTX
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2019 21:26:05 -0700
IronPort-SDR: hHSSPlULnQRM72jOMAx08NVRxVkQyw7SBLaY6+nL4AxzF0Nsru5Q0b22n66AcgxgTnI2fp4W+e
 dJlsu03W280H8e0PzZKVxnznLb+QFLPCl60+3H98AEBWLTUoCDwyLwqLMy0iLlOXr/tl4Mlbam
 EHIutRYTlw6JONO6quWeduQ/9KPglQCwP+Xpp0Q8jxhkQakZqYrtvAIRhbvZQcxEQ2oetcVoAn
 cH96TwmWD6QvjE63AH2gpFXuPNlKuaW8ehfrZ+7CGbOzoml1HTb+LP2Hl5BgcmUnzm6uM4t/PU
 7XM=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 04 Sep 2019 21:29:08 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v4 6/7] block: Set ELEVATOR_F_ZBD_SEQ_WRITE for nullblk zoned disks
Date:   Thu,  5 Sep 2019 13:29:00 +0900
Message-Id: <20190905042901.5830-7-damien.lemoal@wdc.com>
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
queue of null_blk devices created with zoned mode enabled.

This feature requirement can always be satisfied as the mq-deadline
elevator is always selected for in-kernel compilation when
CONFIG_BLK_DEV_ZONED (zoned block device support) is enabled.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

