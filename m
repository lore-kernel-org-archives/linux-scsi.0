Return-Path: <SRS0=/77Q=XA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9135CC3A5AC
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 04:29:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 695B72080C
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 04:29:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="CyuS7hRY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731161AbfIEE3L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Sep 2019 00:29:11 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:62199 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731142AbfIEE3I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Sep 2019 00:29:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567657748; x=1599193748;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=m7BXKq5qJgd2utBtdvuTCMatxO46P3Fit6BBOXMySa0=;
  b=CyuS7hRYtfc8IQKJMFsA8vhxsZxwcut9NrrZMm5UlPeslxOpK+3Af8S7
   QN5tvttcM+HGuJ7Yn9GD18weFnC7Wfi2V3lyHcy05dNILhWxFWLBhOW0z
   XtFsDQuiBq3gezccVNNoVl3g4NS8dG/v6U+UV67Yy3Spj0+8Dhcw9UlOu
   jWTSRjzv1jfb28X+0R+h4INDURjREWcAeGN2ViG5eH1E+50lVBvkK4ne6
   ofomvGWxH0CKL+OJhxaByKRCoqtwRThKOAckdRIbIhEqPuZCOnRYbnMw8
   4qe8w69d/XPIo8UIpS4Yi+a70XWCxGHDRL3l710+qnTWqsMQmJ72fkIE7
   Q==;
IronPort-SDR: MIV7beewDcJCycWTj2hpK6ZYq7JpV68NMfWCW4BGnJe54vuaKX8VJmAHi7I/ugkzfbDWTwa7tk
 RTlV3/7ybTcfMWfkZunnRRKFJLI3yfaUyaG7W2KVdm2Tj84wQjDecz6+Ckqcee1AmotGfAToB1
 VEdRfnep/jSydSKy8onNRMaOwqaNWUAlxhHfwRkMx37chuLe/UOJFwY73JDNO6iUgLTu4AtYa4
 S4kMXzU2qEV6MV+4rHf5lmFix/2VRdnSrAJwmHDbVm5k6v4UAgybJBoWejx1Hku8H/NrGebN91
 KO4=
X-IronPort-AV: E=Sophos;i="5.64,469,1559491200"; 
   d="scan'208";a="224233084"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 05 Sep 2019 12:29:07 +0800
IronPort-SDR: rYabwfTwrHH6BEp1xwq6rfxd5R5aTR4MkYzTxPFs+v36CZd3zm/TIkjQux7QI4lsXAYNAIGGQ4
 YfaQQ0GU1td57OFcJE+vZ5yXkNKAHt74m2gM1iAvsyCbo88/KMUotTHInJR+c/aUQ8dOXj9+NN
 tX4aFZkfp8JkvB+Svsz1G2e/5SH/bmZmtWnXnFo4PJSJhhw4zUtuC4Ncvo5vU/4qMzaEqBzm59
 brazt0GTc353K2/PL6fW1eCGXx/68SK+2mvAOcCWewdrQ0/J6zk/Kz5wlTJ/GbkikpgWSCLoXK
 5eTz2FK8VdCvUe4vODS8QBil
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2019 21:26:04 -0700
IronPort-SDR: rY6+jREtwBTCpnoRJhzOZIGXMJrBOm5iSLoBh8AAluZScqasr4qZSfiW9k2QM4Az956jzXakfv
 fRBGZB1OUVPT4y1a6x710ouR3iwPJSEvwv7392yMVkshjSjAXHDcY2hdqy9cxUg02AL8lG6hp5
 JQfT7qE6U0J50FY3vSOaUuRdayfB0F/W9H91sLjx8ZlTW9tKe1Yw4of2YKqf756+cOivfFTmwq
 wu/FtjrLzXJoVpGby5bmZrXaOmZE+KE1xDeXSbGv4s/zrVsPWuO7xgg+a6AFukGjRypWAUBawe
 IVc=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 04 Sep 2019 21:29:07 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v4 5/7] block: Delay default elevator initialization
Date:   Thu,  5 Sep 2019 13:28:59 +0900
Message-Id: <20190905042901.5830-6-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190905042901.5830-1-damien.lemoal@wdc.com>
References: <20190905042901.5830-1-damien.lemoal@wdc.com>
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
of the device request queue prior to the elevator initialization. This
initialization is skipped for DM devices using
device_add_disk_no_queue_reg() as this also skips the queue
registration.

Additionally, to make sure that the elevator initialization is never
done while requests are in-flight (there should be none when the device
driver calls device_add_disk()), freeze and quiesce the device request
queue before calling blk_mq_init_sched() in elevator_init_mq().

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/blk-mq.c   | 2 --
 block/elevator.c | 7 +++++++
 block/genhd.c    | 9 +++++++++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index ee4caf0c0807..a37503984206 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2902,8 +2902,6 @@ struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 	blk_mq_add_queue_tag_set(set, q);
 	blk_mq_map_swqueue(q);
 
-	elevator_init_mq(q);
-
 	return q;
 
 err_hctxs:
diff --git a/block/elevator.c b/block/elevator.c
index 520d6b224b74..096a670d22d7 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -712,7 +712,14 @@ void elevator_init_mq(struct request_queue *q)
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
index 54f1f0d381f4..26b31fcae217 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -695,6 +695,15 @@ static void __device_add_disk(struct device *parent, struct gendisk *disk,
 	dev_t devt;
 	int retval;
 
+	/*
+	 * The disk queue should now be all set with enough information about
+	 * the device for the elevator code to pick an adequate default
+	 * elevator if one is needed, that is, for devices requesting queue
+	 * registration.
+	 */
+	if (register_queue)
+		elevator_init_mq(disk->queue);
+
 	/* minors == 0 indicates to use ext devt from part0 and should
 	 * be accompanied with EXT_DEVT flag.  Make sure all
 	 * parameters make sense.
-- 
2.21.0

