Return-Path: <SRS0=OYiK=YU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D715DCA9EBE
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Oct 2019 14:06:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A84BC21850
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Oct 2019 14:06:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="BOxtuXXV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfJ0OGD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Oct 2019 10:06:03 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:11568 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbfJ0OGC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Oct 2019 10:06:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1572185238; x=1603721238;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uaP74axAC0WvTAoZiYMsg3QO52V240mSkQunz5Fl5+U=;
  b=BOxtuXXVSRbfExrNgsXdLSJwVc17ITNDaa+HVaq6v/g+ts4fOI4Pw/dF
   iSmO3inT2ctAruh29/2VOPVxUBq80KPL3vuZeZKgJbEFjTZw8w0JxTw4K
   9o03EJi4CpHz2b4s8BjeDRrzhjl/9PA6Cg/nil0J+1flMtqxDccDQO1Ys
   6a2KNJeaN8dyEhtC2Rti1YEgqa0czts4dwcM9RtEnfHDTlno0kjdXIhGI
   FRUzjGquztBlgIsc/uyHwLAS8vGMvFh+pS1iiCSUKn5kERrsh+FxWN8Wt
   URGEL3IDqWfUTpJupW1232MS+QTFAcba1hjt2D8e+kQGD6YO3OWlBO92k
   Q==;
IronPort-SDR: quo4fRDIG9fgFwBEaPb3fSmy5tHTYZpXmSFajyqZvVW4f7ER702aoOT6ZkYijkP8UUH+uS6RMO
 q8erDCde1E8OY5iG5RZC3lGRs9fOh+ScsqdM30Qhvh6522D7/Igkfb389fVjO0yQHQfBTqVqT8
 EgIDkj1x7abIViUnqnmchgCxTd47C1LcmG0JamhsZtROuRHWZ+PioqWjuMR3pyu4oKQtq48nLn
 Sr96hO3DQdRh7AV7Ege3pZ48VpLhmeNXjO33sV/NpGsxHL5zSrCw7jV7MPY90Sf62+Z0CfBytC
 ZUA=
X-IronPort-AV: E=Sophos;i="5.68,236,1569254400"; 
   d="scan'208";a="222578545"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2019 22:07:17 +0800
IronPort-SDR: xzqt+1ts5mAaJBJcifcy/6GEA7lu/Gz26omlnEw+Egwz4ZN7/5IfJSmbyIHziO1tV6QXGnLEGg
 yQa+bkpAQLIKYO1AB3oggDHAOUuB1vb/MnG0MkUs0x8PL5hYVl0f25VkRolPkZOhC5bwcyBTbK
 JS4wJtHzIh3tkcGmbJV9/Gtqj6dMRTbJgQLZAjZynTY0+WT1SOz8QogikeRybT9Tqkx0e4cMvL
 nBho1+nwq83BQVr/ddCOE5NoYmSZaA5GQ6dy69fvTUaGQuHZRf8+aQEfCQRe/uCJR2sOUaErrH
 HISOKNcaIpuWXtfhlRnXM/sN
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2019 07:01:25 -0700
IronPort-SDR: VlrH5BzpXOv60hD7d74hyOtYP8I+naDylREX8iUfHJ4qqvNN1TorTsWgyRaYO2l6ArJp09VyG2
 9bqOl+kY3iixVs645yUz24CN1z82z2gt74Wi/2FIW06rD/CzTnrVMPqJaHBW6Wn+zgzskjL+6U
 bibOLG2q8I8k9naWFoAqlL3uFQT6NeNBhJJZRDqUyGzNWOwi0SWTXg2vVGU1Lr2A0eoROodZcZ
 OziFzm7XjpmnTPO7q89pg5dkaD2zVCSvxtcoFYALk6V8jQhH1athHyTvKOX+fCCg5VCG+O+3FV
 i1Q=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Oct 2019 07:05:59 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc:     Ajay Joshi <ajay.joshi@wdc.com>,
        Matias Bjorling <matias.bjorling@wdc.com>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5/8] block: add zone open, close and finish ioctl support
Date:   Sun, 27 Oct 2019 23:05:46 +0900
Message-Id: <20191027140549.26272-6-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191027140549.26272-1-damien.lemoal@wdc.com>
References: <20191027140549.26272-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Ajay Joshi <ajay.joshi@wdc.com>

Introduce three new ioctl commands BLKOPENZONE, BLKCLOSEZONE and
BLKFINISHZONE to allow applications to control the condition of zones
on a zoned block device through the execution of the REQ_OP_ZONE_OPEN,
REQ_OP_ZONE_CLOSE and REQ_OP_ZONE_FINISH operations.

Contains contributions from Matias Bjorling, Hans Holmberg,
Dmitry Fomichev, Keith Busch, Damien Le Moal and Christoph Hellwig.

Signed-off-by: Ajay Joshi <ajay.joshi@wdc.com>
Signed-off-by: Matias Bjorling <matias.bjorling@wdc.com>
Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/blk-zoned.c             | 28 +++++++++++++++++++++++-----
 block/ioctl.c                 |  5 ++++-
 include/linux/blkdev.h        | 10 +++++-----
 include/uapi/linux/blkzoned.h | 17 ++++++++++++++---
 4 files changed, 46 insertions(+), 14 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index dab34dc48fb6..481eaf7d04d4 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -357,15 +357,16 @@ int blkdev_report_zones_ioctl(struct block_device *bdev, fmode_t mode,
 }
 
 /*
- * BLKRESETZONE ioctl processing.
+ * BLKRESETZONE, BLKOPENZONE, BLKCLOSEZONE and BLKFINISHZONE ioctl processing.
  * Called from blkdev_ioctl.
  */
-int blkdev_reset_zones_ioctl(struct block_device *bdev, fmode_t mode,
-			     unsigned int cmd, unsigned long arg)
+int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mode,
+			   unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	struct request_queue *q;
 	struct blk_zone_range zrange;
+	enum req_opf op;
 
 	if (!argp)
 		return -EINVAL;
@@ -386,8 +387,25 @@ int blkdev_reset_zones_ioctl(struct block_device *bdev, fmode_t mode,
 	if (copy_from_user(&zrange, argp, sizeof(struct blk_zone_range)))
 		return -EFAULT;
 
-	return blkdev_zone_mgmt(bdev, REQ_OP_ZONE_RESET,
-				zrange.sector, zrange.nr_sectors, GFP_KERNEL);
+	switch (cmd) {
+	case BLKRESETZONE:
+		op = REQ_OP_ZONE_RESET;
+		break;
+	case BLKOPENZONE:
+		op = REQ_OP_ZONE_OPEN;
+		break;
+	case BLKCLOSEZONE:
+		op = REQ_OP_ZONE_CLOSE;
+		break;
+	case BLKFINISHZONE:
+		op = REQ_OP_ZONE_FINISH;
+		break;
+	default:
+		return -ENOTTY;
+	}
+
+	return blkdev_zone_mgmt(bdev, op, zrange.sector, zrange.nr_sectors,
+				GFP_KERNEL);
 }
 
 static inline unsigned long *blk_alloc_zone_bitmap(int node,
diff --git a/block/ioctl.c b/block/ioctl.c
index 15a0eb80ada9..8756efb1419e 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -532,7 +532,10 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	case BLKREPORTZONE:
 		return blkdev_report_zones_ioctl(bdev, mode, cmd, arg);
 	case BLKRESETZONE:
-		return blkdev_reset_zones_ioctl(bdev, mode, cmd, arg);
+	case BLKOPENZONE:
+	case BLKCLOSEZONE:
+	case BLKFINISHZONE:
+		return blkdev_zone_mgmt_ioctl(bdev, mode, cmd, arg);
 	case BLKGETZONESZ:
 		return put_uint(arg, bdev_zone_sectors(bdev));
 	case BLKGETNRZONES:
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index bf797a63388c..dbef541c2530 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -367,8 +367,8 @@ extern int blk_revalidate_disk_zones(struct gendisk *disk);
 
 extern int blkdev_report_zones_ioctl(struct block_device *bdev, fmode_t mode,
 				     unsigned int cmd, unsigned long arg);
-extern int blkdev_reset_zones_ioctl(struct block_device *bdev, fmode_t mode,
-				    unsigned int cmd, unsigned long arg);
+extern int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mode,
+				  unsigned int cmd, unsigned long arg);
 
 #else /* CONFIG_BLK_DEV_ZONED */
 
@@ -389,9 +389,9 @@ static inline int blkdev_report_zones_ioctl(struct block_device *bdev,
 	return -ENOTTY;
 }
 
-static inline int blkdev_reset_zones_ioctl(struct block_device *bdev,
-					   fmode_t mode, unsigned int cmd,
-					   unsigned long arg)
+static inline int blkdev_zone_mgmt_ioctl(struct block_device *bdev,
+					 fmode_t mode, unsigned int cmd,
+					 unsigned long arg)
 {
 	return -ENOTTY;
 }
diff --git a/include/uapi/linux/blkzoned.h b/include/uapi/linux/blkzoned.h
index 498eec813494..0cdef67135f0 100644
--- a/include/uapi/linux/blkzoned.h
+++ b/include/uapi/linux/blkzoned.h
@@ -120,9 +120,11 @@ struct blk_zone_report {
 };
 
 /**
- * struct blk_zone_range - BLKRESETZONE ioctl request
- * @sector: starting sector of the first zone to issue reset write pointer
- * @nr_sectors: Total number of sectors of 1 or more zones to reset
+ * struct blk_zone_range - BLKRESETZONE/BLKOPENZONE/
+ *                         BLKCLOSEZONE/BLKFINISHZONE ioctl
+ *                         requests
+ * @sector: Starting sector of the first zone to operate on.
+ * @nr_sectors: Total number of sectors of all zones to operate on.
  */
 struct blk_zone_range {
 	__u64		sector;
@@ -139,10 +141,19 @@ struct blk_zone_range {
  *                sector range. The sector range must be zone aligned.
  * @BLKGETZONESZ: Get the device zone size in number of 512 B sectors.
  * @BLKGETNRZONES: Get the total number of zones of the device.
+ * @BLKOPENZONE: Open the zones in the specified sector range.
+ *               The 512 B sector range must be zone aligned.
+ * @BLKCLOSEZONE: Close the zones in the specified sector range.
+ *                The 512 B sector range must be zone aligned.
+ * @BLKFINISHZONE: Mark the zones as full in the specified sector range.
+ *                 The 512 B sector range must be zone aligned.
  */
 #define BLKREPORTZONE	_IOWR(0x12, 130, struct blk_zone_report)
 #define BLKRESETZONE	_IOW(0x12, 131, struct blk_zone_range)
 #define BLKGETZONESZ	_IOR(0x12, 132, __u32)
 #define BLKGETNRZONES	_IOR(0x12, 133, __u32)
+#define BLKOPENZONE	_IOW(0x12, 134, struct blk_zone_range)
+#define BLKCLOSEZONE	_IOW(0x12, 135, struct blk_zone_range)
+#define BLKFINISHZONE	_IOW(0x12, 136, struct blk_zone_range)
 
 #endif /* _UAPI_BLKZONED_H */
-- 
2.21.0

