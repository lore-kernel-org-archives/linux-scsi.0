From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 1/2] block, dm-mpath: Introduce request flag
 REQ_FAIL_IF_NO_PATH
Date: Fri, 11 Nov 2016 16:39:46 -0800
Message-ID: <fe8da8de-84a2-7580-f5b8-aa0c0e884f5c@sandisk.com>
References: <a8f0ee8f-7b40-2375-47a4-52f78af29d8d@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0078.outbound.protection.outlook.com ([104.47.40.78]:39994
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934500AbcKLAjw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Nov 2016 19:39:52 -0500
In-Reply-To: <a8f0ee8f-7b40-2375-47a4-52f78af29d8d@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Let dm-mpath fail requests if queue_if_no_path is enabled and
request flag REQ_FAIL_IF_NO_PATH has been set. This facility will
be used in the next patch to fix a deadlock between SCSI device
removal and sd event checking.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
---
 drivers/md/dm-mpath.c     | 6 ++++--
 include/linux/blk_types.h | 4 ++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 1c97f0e..9348151 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -539,6 +539,7 @@ static int __multipath_map(struct dm_target *ti, struct request *clone,
 	struct multipath *m = ti->private;
 	int r = DM_MAPIO_REQUEUE;
 	size_t nr_bytes = clone ? blk_rq_bytes(clone) : blk_rq_bytes(rq);
+	bool fail_if_no_path = (clone ? : rq)->cmd_flags & REQ_FAIL_IF_NO_PATH;
 	struct pgpath *pgpath;
 	struct block_device *bdev;
 	struct dm_mpath_io *mpio;
@@ -549,7 +550,7 @@ static int __multipath_map(struct dm_target *ti, struct request *clone,
 		pgpath = choose_pgpath(m, nr_bytes);
 
 	if (!pgpath) {
-		if (must_push_back_rq(m))
+		if (!fail_if_no_path && must_push_back_rq(m))
 			return DM_MAPIO_DELAY_REQUEUE;
 		return -EIO;	/* Failed */
 	} else if (test_bit(MPATHF_QUEUE_IO, &m->flags) ||
@@ -1567,6 +1568,7 @@ static int do_end_io(struct multipath *m, struct request *clone,
 	 * clone bios for it and resubmit it later.
 	 */
 	int r = DM_ENDIO_REQUEUE;
+	bool fail_if_no_path = clone->cmd_flags & REQ_FAIL_IF_NO_PATH;
 
 	if (!error && !clone->errors)
 		return 0;	/* I/O complete */
@@ -1579,7 +1581,7 @@ static int do_end_io(struct multipath *m, struct request *clone,
 
 	if (!atomic_read(&m->nr_valid_paths)) {
 		if (!test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags)) {
-			if (!must_push_back_rq(m))
+			if (fail_if_no_path || !must_push_back_rq(m))
 				r = -EIO;
 		}
 	}
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index cd395ec..9b25728 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -189,6 +189,9 @@ enum rq_flag_bits {
 	__REQ_PM,		/* runtime pm request */
 	__REQ_HASHED,		/* on IO scheduler merge hash */
 	__REQ_MQ_INFLIGHT,	/* track inflight for MQ */
+
+	__REQ_FAIL_IF_NO_PATH,	/* fail if queued on dm-mpath with no paths */
+
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -235,6 +238,7 @@ enum rq_flag_bits {
 #define REQ_PM			(1ULL << __REQ_PM)
 #define REQ_HASHED		(1ULL << __REQ_HASHED)
 #define REQ_MQ_INFLIGHT		(1ULL << __REQ_MQ_INFLIGHT)
+#define REQ_FAIL_IF_NO_PATH	(1ULL << __REQ_FAIL_IF_NO_PATH)
 
 enum req_op {
 	REQ_OP_READ,
-- 
2.10.1

