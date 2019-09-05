Return-Path: <SRS0=/77Q=XA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8435AC3A5AC
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 09:51:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53B6F21743
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 09:51:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="o54BQ3W7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387613AbfIEJvx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Sep 2019 05:51:53 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:25315 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732595AbfIEJvw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Sep 2019 05:51:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567677113; x=1599213113;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PErFhJdbRHZCrM47arWeyOIBOCDRRRHkAOiFwGGBAlU=;
  b=o54BQ3W7VYrJ3RCAcZOMze7AbqtmACBP4Ec2f4Gpzj/yfI38xBnhELnx
   AMAdDN2AQAc2UaEObMB5zSDTGAotpbOJyPGAWyQd89AwNMLUWyoGHKzAP
   XsomAtSqvOyiNp/p47+fTTIXh5uCylIYf4CFbZLS79SIQL9pdswFkdcU0
   kppTZ69ie6VEO86xyG2eLBRi/rJU7wdSHEMBe0sfaul7JZb0VQvDlnq/8
   4pZmo+yjWpk2IcG5/6yHGVlRLjaXfvTVPi0cPyh+NX0y2n87SFHDt6Vgg
   /NoxT5L3ujgzVqH2BffE09peW4m2XL5VutvCABvz9riFnZxQJYqRE9dZG
   A==;
IronPort-SDR: VORp8KgBhVUf4CaQDt8+BsCxPR8qaE6Rb1J3YjLjBnvetyefg368Mtb9N7eOv64zAibWQ7S47A
 s1Y1Q9o1C0AwH1MuoRPQyTPKN5mx3J9kxhjOUNUBiOSuqFOUDeWKBGTWL/83n3IHEBVTSewVb8
 4desonFD7KCpyJFPrwFoWPhNl7l3ggu1dw++5tDS1CNYjV+VockUiP2owTWyBzT2hKmLHvBk96
 dkijyikRlFXZngWiEcz01+bpUTAFzicH+fS0cOq4wAXsvRgJLdIkO3zr670d5s2hZ0l36Inrbh
 zUw=
X-IronPort-AV: E=Sophos;i="5.64,470,1559491200"; 
   d="scan'208";a="119106271"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 05 Sep 2019 17:51:44 +0800
IronPort-SDR: 5kxLtwjt7oPvjOFujmrtL+RvvVYl9vOBE//8LtGRjH+nRtOWP2/9W5ILarabby0njSWLxS5ers
 V+6O/yFpVO+lrU3Kt+k4RWCeugjJi41gWweiA5/fC/3xJ15PH2ZCL18QzdmVkg5RzEOXB8et72
 zUtefc9CZo+e5a5khcuyzv+umxPUd+8FIbvejIuHusKAeMdstRUgZXHXDlk2cycg+88nOWZQEi
 YJTcaNZE8AKWJgCSEULPIpMBjJzYbJWpR6BwOJz/AdkoCtDJiMbs095CdFWQum/Y0CTaMwIiEx
 IJuA2+TJJT9RDpZ03ADinD/y
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 02:48:39 -0700
IronPort-SDR: W0iMItwJl+ZikypMnIqWii/vG5T4FLldmcZVG8h+aJmUfwZSH5seHXYPjySsjO8bbPIwhTCv8A
 jBPS2uYscziQRnY/8tUEr6LFBJOimsCeqXo38Vi6EvPWy1zMmMxPmU3ex8kS2IdK1tmGl3hEiF
 SF4vhznaXt90rqZhneKKcGV6S1lvHDY++qEYrDwgpKiyQLIu7fR5bF7E66myaA9iTYa+BkZo65
 Ve6wCjshlslQTpYuPDPGS70VniGp/DSlrfep05asPiF5JsY0hM2N96rkf4yRRRRzRqIgvHhcz5
 zKA=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 05 Sep 2019 02:51:43 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc:     Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v5 5/7] block: Delay default elevator initialization
Date:   Thu,  5 Sep 2019 18:51:33 +0900
Message-Id: <20190905095135.26026-6-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190905095135.26026-1-damien.lemoal@wdc.com>
References: <20190905095135.26026-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When elevator_init_mq() is called from blk_mq_init_allocated_queue(),
the only information known about the device is the number of hardware
queues as the block device scan by the device driver is not completed
yet for most drivers. The device type and elevator required features
are not set yet, preventing to correctly select the default elevator
most suitable for the device.

This currently affects all multi-queue zoned block devices which default
to the "none" elevator instead of the required "mq-deadline" elevator.
These drives currently include host-managed SMR disks connected to a
smartpqi HBA and null_blk block devices with zoned mode enabled.
Upcoming NVMe Zoned Namespace devices will also be affected.

Fix this by adding the boolean elevator_init argument to
blk_mq_init_allocated_queue() to control the execution of
elevator_init_mq(). Two cases exist:
1) elevator_init = false is used for calls to
   blk_mq_init_allocated_queue() within blk_mq_init_queue(). In this
   case, a call to elevator_init_mq() is added to __device_add_disk(),
   resulting in the delayed initialization of the queue elevator
   after the device driver finished probing the device information. This
   effectively allows elevator_init_mq() access to more information
   about the device.
2) elevator_init = true preserves the current behavior of initializing
   the elevator directly from blk_mq_init_allocated_queue(). This case
   is used for the special request based DM devices where the device
   gendisk is created before the queue initialization and device
   information (e.g. queue limits) is already known when the queue
   initialization is executed.

Additionally, to make sure that the elevator initialization is never
done while requests are in-flight (there should be none when the device
driver calls device_add_disk()), freeze and quiesce the device request
queue before calling blk_mq_init_sched() in elevator_init_mq().

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/blk-mq.c         | 12 +++++++++---
 block/elevator.c       |  7 +++++++
 block/genhd.c          |  9 +++++++++
 drivers/md/dm-rq.c     |  2 +-
 include/linux/blk-mq.h |  3 ++-
 5 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index ee4caf0c0807..240416057f28 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2689,7 +2689,11 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 	if (!uninit_q)
 		return ERR_PTR(-ENOMEM);
 
-	q = blk_mq_init_allocated_queue(set, uninit_q);
+	/*
+	 * Initialize the queue without an elevator. device_add_disk() will do
+	 * the initialization.
+	 */
+	q = blk_mq_init_allocated_queue(set, uninit_q, false);
 	if (IS_ERR(q))
 		blk_cleanup_queue(uninit_q);
 
@@ -2840,7 +2844,8 @@ static unsigned int nr_hw_queues(struct blk_mq_tag_set *set)
 }
 
 struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
-						  struct request_queue *q)
+						  struct request_queue *q,
+						  bool elevator_init)
 {
 	/* mark the queue as mq asap */
 	q->mq_ops = set->ops;
@@ -2902,7 +2907,8 @@ struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 	blk_mq_add_queue_tag_set(set, q);
 	blk_mq_map_swqueue(q);
 
-	elevator_init_mq(q);
+	if (elevator_init)
+		elevator_init_mq(q);
 
 	return q;
 
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
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 21d5c1784d0c..3f8577e2c13b 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -563,7 +563,7 @@ int dm_mq_init_request_queue(struct mapped_device *md, struct dm_table *t)
 	if (err)
 		goto out_kfree_tag_set;
 
-	q = blk_mq_init_allocated_queue(md->tag_set, md->queue);
+	q = blk_mq_init_allocated_queue(md->tag_set, md->queue, true);
 	if (IS_ERR(q)) {
 		err = PTR_ERR(q);
 		goto out_tag_set;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 62a3bb715899..0bf056de5cc3 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -248,7 +248,8 @@ enum {
 
 struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *);
 struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
-						  struct request_queue *q);
+						  struct request_queue *q,
+						  bool elevator_init);
 struct request_queue *blk_mq_init_sq_queue(struct blk_mq_tag_set *set,
 						const struct blk_mq_ops *ops,
 						unsigned int queue_depth,
-- 
2.21.0

