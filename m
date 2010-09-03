From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 41/41] block: remove the BH_Eopnotsupp flag
Date: Fri,  3 Sep 2010 12:29:56 +0200
Message-ID: <1283509796-1510-42-git-send-email-tj@kernel.org>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1283509796-1510-1-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>

This flag was only set for barrier buffers, which we don't submit
anymore.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/buffer.c                 |    7 +------
 fs/fat/misc.c               |    5 +----
 include/linux/buffer_head.h |    2 --
 3 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 3e7dca2..7f0b9b0 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -156,7 +156,7 @@ void end_buffer_write_sync(struct buffer_head *bh, int uptodate)
 	if (uptodate) {
 		set_buffer_uptodate(bh);
 	} else {
-		if (!buffer_eopnotsupp(bh) && !quiet_error(bh)) {
+		if (!quiet_error(bh)) {
 			buffer_io_error(bh);
 			printk(KERN_WARNING "lost page write due to "
 					"I/O error on %s\n",
@@ -2891,7 +2891,6 @@ static void end_bio_bh_io_sync(struct bio *bio, int err)
 
 	if (err == -EOPNOTSUPP) {
 		set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
-		set_bit(BH_Eopnotsupp, &bh->b_state);
 	}
 
 	if (unlikely (test_bit(BIO_QUIET,&bio->bi_flags)))
@@ -3031,10 +3030,6 @@ int __sync_dirty_buffer(struct buffer_head *bh, int rw)
 		bh->b_end_io = end_buffer_write_sync;
 		ret = submit_bh(rw, bh);
 		wait_on_buffer(bh);
-		if (buffer_eopnotsupp(bh)) {
-			clear_buffer_eopnotsupp(bh);
-			ret = -EOPNOTSUPP;
-		}
 		if (!ret && !buffer_uptodate(bh))
 			ret = -EIO;
 	} else {
diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index 1736f23..970e682 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -255,10 +255,7 @@ int fat_sync_bhs(struct buffer_head **bhs, int nr_bhs)
 
 	for (i = 0; i < nr_bhs; i++) {
 		wait_on_buffer(bhs[i]);
-		if (buffer_eopnotsupp(bhs[i])) {
-			clear_buffer_eopnotsupp(bhs[i]);
-			err = -EOPNOTSUPP;
-		} else if (!err && !buffer_uptodate(bhs[i]))
+		if (!err && !buffer_uptodate(bhs[i]))
 			err = -EIO;
 	}
 	return err;
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index fc999f5..dd1b25b 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -32,7 +32,6 @@ enum bh_state_bits {
 	BH_Delay,	/* Buffer is not yet allocated on disk */
 	BH_Boundary,	/* Block is followed by a discontiguity */
 	BH_Write_EIO,	/* I/O error on write */
-	BH_Eopnotsupp,	/* DEPRECATED: operation not supported (barrier) */
 	BH_Unwritten,	/* Buffer is allocated on disk but not written */
 	BH_Quiet,	/* Buffer Error Prinks to be quiet */
 
@@ -124,7 +123,6 @@ BUFFER_FNS(Async_Write, async_write)
 BUFFER_FNS(Delay, delay)
 BUFFER_FNS(Boundary, boundary)
 BUFFER_FNS(Write_EIO, write_io_error)
-BUFFER_FNS(Eopnotsupp, eopnotsupp)
 BUFFER_FNS(Unwritten, unwritten)
 
 #define bh_offset(bh)		((unsigned long)(bh)->b_data & ~PAGE_MASK)
-- 
1.7.1
