From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V4 16/16] block: mq-deadline: Update documentation
Date: Sun, 24 Sep 2017 16:02:47 +0900
Message-ID: <20170924070247.25560-17-damien.lemoal@wdc.com>
References: <20170924070247.25560-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:35286 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751847AbdIXHDK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Sep 2017 03:03:10 -0400
In-Reply-To: <20170924070247.25560-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

Added description of the zones_wlock tunable attribute.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 Documentation/block/deadline-iosched.txt | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/block/deadline-iosched.txt b/Documentation/block/deadline-iosched.txt
index 2d82c80322cb..b532304d2bf4 100644
--- a/Documentation/block/deadline-iosched.txt
+++ b/Documentation/block/deadline-iosched.txt
@@ -69,6 +69,23 @@ Front merges may still occur due to the cached last_merge hint, but since
 that comes at basically 0 cost we leave that on. We simply disable the
 rbtree front sector lookup when the io scheduler merge function is called.
 
+zones_wlock	(bool)
+-----------
+
+(mq-deadlines only)
+The blk-mq version of the deadline I/O scheduler, mq-deadline, introduced
+support for zoned block devices. This added support prevents dispatching of more
+than one write command per zone of the device to avoid write sequence reordering
+due to the possible concurrent execution of many blk-mq operations, in
+particular request dispatching. This is achieved using a per zone lock
+implemented as a bitmap. When a write request is dispatched, the target zone of
+the  request is locked, preventing further dispatch of write requests to it
+(there are no limitations on read commands). The zones_wlock tunable allows
+disabling zone write locking for host aware zoned block devices as these drive
+can handle random writes to zones in firmware. This tunable default setting
+cannot be changed for host managed disks (always enabled) and regular disks
+(always disabled).
+
 
 Nov 11 2002, Jens Axboe <jens.axboe@oracle.com>
 
-- 
2.13.5
