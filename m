Return-Path: <SRS0=LwoI=W7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0A71C3A5AA
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 08:43:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 998842339D
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 08:43:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="l/Lo/jwO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729253AbfIDInC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Sep 2019 04:43:02 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:39238 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728448AbfIDInB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Sep 2019 04:43:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567586581; x=1599122581;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=fh2X6sgqVyA/YgEaWwJn5yd67V2WgvSpchuXNuvnbp4=;
  b=l/Lo/jwOWc/bmQprdXHUO4rYmeEhpaex930AZiykMZduq3oDKfJp5Soz
   nWOSh9Guq+UyP3rEVzwlSTUnTuGeEaA/OLGQcEjQ3jS3SQ3j2GA82KTER
   UICp0yX+X7+O71/r4EUnr662LsUu55FD+vvFjj4Yf8pBJgaCPvz4TO5Ch
   LMyr1OwrDZiORxAhhaYhkQ3Wrt8FFXZZ6Kuh+O5lS8fSqk7rY1V1t/kcg
   AU/P5baI/g6Eg/b0pVyVGRKopDdvGLARrRDWqk75MAa5XKcP4rJt+u68y
   ME8ksp5ZXpom5RNImIr/yzYUL4RlgykVoW3mPfoNkG6t6umaHmCBBhsHA
   A==;
IronPort-SDR: q7rl7ihhzsAm9pnM3iKXUdaDMTieZvohZMRD6tKesqHxRPVkfDSAXy9+WNWyccp9MyaIOenGNK
 rTJ09TaGgxdOUUDFR5FXSyY8VqccVuWHduBCAY0HlInhAtASBtzd/1uKiYDUpsOhFGQBrgc5pd
 BNb0oXANl5IMaymaIreVWr5jwNgJY+6JlNmsv/ZFIt/eK7c/2pPqAZIKxyC7gkhHrn17zWntKz
 pOb39zCdNfc+HxJC8Bi/kc3AYkqLqTddSlDc0nHRZ1bcx2/JPeg7xahAs8bJiBpgto2rmQI4J1
 rw4=
X-IronPort-AV: E=Sophos;i="5.64,465,1559491200"; 
   d="scan'208";a="117374685"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 04 Sep 2019 16:42:54 +0800
IronPort-SDR: 3DAFxzdsO3kNmYow1Dxy+bCLVK4L2MQtafUsBJtYBes1ihiXrbIacFzGU6++cNC/IrsMBqAiHB
 R4MgJZzLbUAvd8D3+RTt/0gKvWmU/imIBgO1Qh+Ujb50O2iZe/DpFjkqTNeEKGEr1e+AU8QRcL
 diqUgimM4OIDeVuOffmqzRac4U3EhTtt9u1ctc1oI233NzW2Y5B6NL4kN4uzdFnoEC4vSJ69LB
 7Grk2C9jFyhQryfxSK5l+gyZU/6WV2PCTXEuIVMlecxgWYu0TmSZCLPKNeBsnE+gIQcZ3XoQdp
 xpSPV4T7Yzsy/LSMfgCgQyFv
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2019 01:39:52 -0700
IronPort-SDR: blnx04rCNK6PSIJNFSPMdCGTO2BygABGR9ZMqg7LFcOSekPqR7JdvT0W0iNCbXOWoZ3hkO9pbw
 NJbKXx6AJ5OGRO8jAebtR4J3PMnvWU2yYd7WEI0XyG/ClP858COeqnuq3VKv0pdwztbYB5olg/
 2BBTt5KkEmSbeET/8a7/rdIAqm5Y1cxXOnC//FvHjLJf6mSE0+oNWNeFbJQ+KxG7+u0ulAUzkY
 pv9B13F62+U+YyiB+73K0fBZG84b3COPybZ+vpGn2CUAPm0nN7m0qbtuYnFBZUfAGGMmG08UZH
 m+c=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 04 Sep 2019 01:42:53 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v3 5/7] block: Delay default elevator initialization
Date:   Wed,  4 Sep 2019 17:42:45 +0900
Message-Id: <20190904084247.23338-6-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190904084247.23338-1-damien.lemoal@wdc.com>
References: <20190904084247.23338-1-damien.lemoal@wdc.com>
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
 block/genhd.c    | 8 ++++++++
 3 files changed, 15 insertions(+), 2 deletions(-)

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
index 54f1f0d381f4..7380dd7b2257 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -695,6 +695,13 @@ static void __device_add_disk(struct device *parent, struct gendisk *disk,
 	dev_t devt;
 	int retval;
 
+	/*
+	 * The disk queue should now be all set with enough information about
+	 * the device for the elevator code to pick an adequate default
+	 * elevator.
+	 */
+	elevator_init_mq(disk->queue);
+
 	/* minors == 0 indicates to use ext devt from part0 and should
 	 * be accompanied with EXT_DEVT flag.  Make sure all
 	 * parameters make sense.
@@ -734,6 +741,7 @@ static void __device_add_disk(struct device *parent, struct gendisk *disk,
 				    exact_match, exact_lock, disk);
 	}
 	register_disk(parent, disk, groups);
+
 	if (register_queue)
 		blk_register_queue(disk);
 
-- 
2.21.0

