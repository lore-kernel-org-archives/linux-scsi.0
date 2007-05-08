From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] bsg: fix a blocking read bug
Date: Tue, 08 May 2007 22:21:19 +0900
Message-ID: <200705081321.l48DLJe4019439@mbox.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:59956 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934448AbXEHNWB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 May 2007 09:22:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, Daniel.E.Messinger@seagate.com

This patch fixes a bug that read() returns ENODATA even with a
blocking file descriptor when there are no commands pending.

This also includes some cleanups.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/bsg.c |   84 ++++++++++++++++------------------------------------------
 1 files changed, 23 insertions(+), 61 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index a333c93..2f78d7d 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -115,9 +115,9 @@ static void bsg_free_command(struct bsg_
 	wake_up(&bd->wq_free);
 }
 
-static struct bsg_command *__bsg_alloc_command(struct bsg_device *bd)
+static struct bsg_command *bsg_alloc_command(struct bsg_device *bd)
 {
-	struct bsg_command *bc = NULL;
+	struct bsg_command *bc = ERR_PTR(-EINVAL);
 
 	spin_lock_irq(&bd->lock);
 
@@ -131,6 +131,7 @@ static struct bsg_command *__bsg_alloc_c
 	if (unlikely(!bc)) {
 		spin_lock_irq(&bd->lock);
 		bd->queued_cmds--;
+		bc = ERR_PTR(-ENOMEM);
 		goto out;
 	}
 
@@ -198,30 +199,6 @@ unlock:
 	return ret;
 }
 
-/*
- * get a new free command, blocking if needed and specified
- */
-static struct bsg_command *bsg_get_command(struct bsg_device *bd)
-{
-	struct bsg_command *bc;
-	int ret;
-
-	do {
-		bc = __bsg_alloc_command(bd);
-		if (bc)
-			break;
-
-		ret = bsg_io_schedule(bd, TASK_INTERRUPTIBLE);
-		if (ret) {
-			bc = ERR_PTR(ret);
-			break;
-		}
-
-	} while (1);
-
-	return bc;
-}
-
 static int blk_fill_sgv4_hdr_rq(request_queue_t *q, struct request *rq,
 				struct sg_io_v4 *hdr, int has_write_perm)
 {
@@ -397,7 +374,7 @@ static inline struct bsg_command *bsg_ne
 /*
  * Get a finished command from the done list
  */
-static struct bsg_command *__bsg_get_done_cmd(struct bsg_device *bd, int state)
+static struct bsg_command *bsg_get_done_cmd(struct bsg_device *bd)
 {
 	struct bsg_command *bc;
 	int ret;
@@ -407,9 +384,14 @@ static struct bsg_command *__bsg_get_don
 		if (bc)
 			break;
 
-		ret = bsg_io_schedule(bd, state);
+		if (!test_bit(BSG_F_BLOCK, &bd->flags)) {
+			bc = ERR_PTR(-EAGAIN);
+			break;
+		}
+
+		ret = wait_event_interruptible(bd->wq_done, bd->done_cmds);
 		if (ret) {
-			bc = ERR_PTR(ret);
+			bc = ERR_PTR(-ERESTARTSYS);
 			break;
 		}
 	} while (1);
@@ -419,18 +401,6 @@ static struct bsg_command *__bsg_get_don
 	return bc;
 }
 
-static struct bsg_command *
-bsg_get_done_cmd(struct bsg_device *bd, const struct iovec *iov)
-{
-	return __bsg_get_done_cmd(bd, TASK_INTERRUPTIBLE);
-}
-
-static struct bsg_command *
-bsg_get_done_cmd_nosignals(struct bsg_device *bd)
-{
-	return __bsg_get_done_cmd(bd, TASK_UNINTERRUPTIBLE);
-}
-
 static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 				    struct bio *bio)
 {
@@ -496,19 +466,16 @@ static int bsg_complete_all_commands(str
 	 */
 	ret = 0;
 	do {
-		bc = bsg_get_done_cmd_nosignals(bd);
-
-		/*
-		 * we _must_ complete before restarting, because
-		 * bsg_release can't handle this failing.
-		 */
-		if (PTR_ERR(bc) == -ERESTARTSYS)
-			continue;
-		if (IS_ERR(bc)) {
-			ret = PTR_ERR(bc);
+		spin_lock_irq(&bd->lock);
+		if (!bd->queued_cmds) {
+			spin_unlock_irq(&bd->lock);
 			break;
 		}
 
+		bc = bsg_get_done_cmd(bd);
+		if (IS_ERR(bc))
+			break;
+
 		tret = blk_complete_sgv4_hdr_rq(bc->rq, &bc->hdr, bc->bio);
 		if (!ret)
 			ret = tret;
@@ -519,11 +486,9 @@ static int bsg_complete_all_commands(str
 	return ret;
 }
 
-typedef struct bsg_command *(*bsg_command_callback)(struct bsg_device *bd, const struct iovec *iov);
-
 static ssize_t
-__bsg_read(char __user *buf, size_t count, bsg_command_callback get_bc,
-	   struct bsg_device *bd, const struct iovec *iov, ssize_t *bytes_read)
+__bsg_read(char __user *buf, size_t count, struct bsg_device *bd,
+	   const struct iovec *iov, ssize_t *bytes_read)
 {
 	struct bsg_command *bc;
 	int nr_commands, ret;
@@ -534,7 +499,7 @@ __bsg_read(char __user *buf, size_t coun
 	ret = 0;
 	nr_commands = count / sizeof(struct sg_io_v4);
 	while (nr_commands) {
-		bc = get_bc(bd, iov);
+		bc = bsg_get_done_cmd(bd);
 		if (IS_ERR(bc)) {
 			ret = PTR_ERR(bc);
 			break;
@@ -598,8 +563,7 @@ bsg_read(struct file *file, char __user
 
 	bsg_set_block(bd, file);
 	bytes_read = 0;
-	ret = __bsg_read(buf, count, bsg_get_done_cmd,
-			bd, NULL, &bytes_read);
+	ret = __bsg_read(buf, count, bd, NULL, &bytes_read);
 	*ppos = bytes_read;
 
 	if (!bytes_read || (bytes_read && err_block_err(ret)))
@@ -625,9 +589,7 @@ static ssize_t __bsg_write(struct bsg_de
 	while (nr_commands) {
 		request_queue_t *q = bd->queue;
 
-		bc = bsg_get_command(bd);
-		if (!bc)
-			break;
+		bc = bsg_alloc_command(bd);
 		if (IS_ERR(bc)) {
 			ret = PTR_ERR(bc);
 			bc = NULL;
-- 
1.4.3.2

