From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: bidi bsg is non-blocking
Date: Tue, 08 May 2007 16:23:26 +0900
Message-ID: <20070508162326Q.fujita.tomonori@lab.ntt.co.jp>
References: <OF8468A26D.D2DDFDA3-ON862572D4.004E5BE6-862572D4.005458FE@seagate.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:46955 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934402AbXEHH1L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 May 2007 03:27:11 -0400
In-Reply-To: <OF8468A26D.D2DDFDA3-ON862572D4.004E5BE6-862572D4.005458FE@seagate.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel.E.Messinger@seagate.com
Cc: jens.axboe@oracle.com, tomof@acm.org, linux-scsi@vger.kernel.org

From: Daniel.E.Messinger@seagate.com
Subject: bidi bsg is non-blocking
Date: Mon, 7 May 2007 10:21:18 -0500

> I'm attempting to use the bidi variant of bsg to talk to an OSD target
> device. I've run into an undesirable situation.
> 
> My application has a free-running receive loop (doing a read() on the bsg
> device) waiting for responses to commands sent to bsg by another thread.
> The problem is that the receive thread is getting ENODATA from the read()
> when there are no commands pending.  I have NOT set non-blocking.
> 
> Note that the old sg driver was quite willing to block until there was a
> response available. I find this scenario greatly preferable.
> 
> Could bsg be fixed so that read() blocks when there is nothing to return?

I think that this is a bug.

This patch is against the bsg branch in the Jens' git tree.

I guess that it would be nice to do more cleanups on these parts.


>From 52a9fcf0af72f212ddd93918b7f9f0f0e706c215 Mon Sep 17 00:00:00 2001
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Tue, 8 May 2007 15:57:43 +0900
Subject: [PATCH] fix read ENODATA bug

This patch fixes a bug that read() gives ENODATA even with a blocking
file descriptor when there are no commands pending.

This also includes some cleanups.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/bsg.c |   85 ++++++++++++++--------------------------------------------
 1 files changed, 21 insertions(+), 64 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index a333c93..7fcc77a 100644
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
@@ -407,11 +384,17 @@ static struct bsg_command *__bsg_get_don
 		if (bc)
 			break;
 
-		ret = bsg_io_schedule(bd, state);
-		if (ret) {
-			bc = ERR_PTR(ret);
+		if (!test_bit(BSG_F_BLOCK, &bd->flags)) {
+			bc = ERR_PTR(-EAGAIN);
 			break;
 		}
+
+		ret = wait_event_interruptible(bd->wq_done, bd->done_cmds);
+		if (ret) {
+			bc = ERR_PTR(-ERESTARTSYS);
+			break;
+		} else
+			continue;
 	} while (1);
 
 	dprintk("%s: returning done %p\n", bd->name, bc);
@@ -419,18 +402,6 @@ static struct bsg_command *__bsg_get_don
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
@@ -492,22 +463,13 @@ static int bsg_complete_all_commands(str
 	} while (ret != -ENODATA);
 
 	/*
-	 * discard done commands
+	 * discard done commands.
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
+		bc = bsg_get_done_cmd(bd);
+		if (IS_ERR(bc))
 			break;
-		}
 
 		tret = blk_complete_sgv4_hdr_rq(bc->rq, &bc->hdr, bc->bio);
 		if (!ret)
@@ -519,11 +481,9 @@ static int bsg_complete_all_commands(str
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
@@ -534,7 +494,7 @@ __bsg_read(char __user *buf, size_t coun
 	ret = 0;
 	nr_commands = count / sizeof(struct sg_io_v4);
 	while (nr_commands) {
-		bc = get_bc(bd, iov);
+		bc = bsg_get_done_cmd(bd);
 		if (IS_ERR(bc)) {
 			ret = PTR_ERR(bc);
 			break;
@@ -598,8 +558,7 @@ bsg_read(struct file *file, char __user
 
 	bsg_set_block(bd, file);
 	bytes_read = 0;
-	ret = __bsg_read(buf, count, bsg_get_done_cmd,
-			bd, NULL, &bytes_read);
+	ret = __bsg_read(buf, count, bd, NULL, &bytes_read);
 	*ppos = bytes_read;
 
 	if (!bytes_read || (bytes_read && err_block_err(ret)))
@@ -625,9 +584,7 @@ static ssize_t __bsg_write(struct bsg_de
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

