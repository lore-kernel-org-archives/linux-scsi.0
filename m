From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 31/41] reiserfs: replace barriers with explicit flush / FUA usage
Date: Fri,  3 Sep 2010 12:29:46 +0200
Message-ID: <1283509796-1510-32-git-send-email-tj@kernel.org>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1283509796-1510-1-git-send-email-tj@kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.co
Cc: Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>

Switch to the WRITE_FLUSH_FUA flag for log writes and remove the EOPNOTSUPP
detection for barriers.  Note that reiserfs had a fairly different code
path for barriers before as it wa the only filesystem actually making use
of them.  The new code always uses the old non-barrier codepath and just
sets the WRITE_FLUSH_FUA explicitly for the journal commits.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jan Kara <jack@suse.cz>
Acked-by: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/reiserfs/journal.c |  106 +++++++++---------------------------------------
 1 files changed, 20 insertions(+), 86 deletions(-)

diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index 812e2c0..076c8b1 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -138,13 +138,6 @@ static int reiserfs_clean_and_file_buffer(struct buffer_head *bh)
 	return 0;
 }
 
-static void disable_barrier(struct super_block *s)
-{
-	REISERFS_SB(s)->s_mount_opt &= ~(1 << REISERFS_BARRIER_FLUSH);
-	printk("reiserfs: disabling flush barriers on %s\n",
-	       reiserfs_bdevname(s));
-}
-
 static struct reiserfs_bitmap_node *allocate_bitmap_node(struct super_block
 							 *sb)
 {
@@ -677,30 +670,6 @@ static void submit_ordered_buffer(struct buffer_head *bh)
 	submit_bh(WRITE, bh);
 }
 
-static int submit_barrier_buffer(struct buffer_head *bh)
-{
-	get_bh(bh);
-	bh->b_end_io = reiserfs_end_ordered_io;
-	clear_buffer_dirty(bh);
-	if (!buffer_uptodate(bh))
-		BUG();
-	return submit_bh(WRITE_BARRIER, bh);
-}
-
-static void check_barrier_completion(struct super_block *s,
-				     struct buffer_head *bh)
-{
-	if (buffer_eopnotsupp(bh)) {
-		clear_buffer_eopnotsupp(bh);
-		disable_barrier(s);
-		set_buffer_uptodate(bh);
-		set_buffer_dirty(bh);
-		reiserfs_write_unlock(s);
-		sync_dirty_buffer(bh);
-		reiserfs_write_lock(s);
-	}
-}
-
 #define CHUNK_SIZE 32
 struct buffer_chunk {
 	struct buffer_head *bh[CHUNK_SIZE];
@@ -1009,7 +978,6 @@ static int flush_commit_list(struct super_block *s,
 	struct buffer_head *tbh = NULL;
 	unsigned int trans_id = jl->j_trans_id;
 	struct reiserfs_journal *journal = SB_JOURNAL(s);
-	int barrier = 0;
 	int retval = 0;
 	int write_len;
 
@@ -1094,24 +1062,6 @@ static int flush_commit_list(struct super_block *s,
 	}
 	atomic_dec(&journal->j_async_throttle);
 
-	/* We're skipping the commit if there's an error */
-	if (retval || reiserfs_is_journal_aborted(journal))
-		barrier = 0;
-
-	/* wait on everything written so far before writing the commit
-	 * if we are in barrier mode, send the commit down now
-	 */
-	barrier = reiserfs_barrier_flush(s);
-	if (barrier) {
-		int ret;
-		lock_buffer(jl->j_commit_bh);
-		ret = submit_barrier_buffer(jl->j_commit_bh);
-		if (ret == -EOPNOTSUPP) {
-			set_buffer_uptodate(jl->j_commit_bh);
-			disable_barrier(s);
-			barrier = 0;
-		}
-	}
 	for (i = 0; i < (jl->j_len + 1); i++) {
 		bn = SB_ONDISK_JOURNAL_1st_BLOCK(s) +
 		    (jl->j_start + i) % SB_ONDISK_JOURNAL_SIZE(s);
@@ -1143,27 +1093,22 @@ static int flush_commit_list(struct super_block *s,
 
 	BUG_ON(atomic_read(&(jl->j_commit_left)) != 1);
 
-	if (!barrier) {
-		/* If there was a write error in the journal - we can't commit
-		 * this transaction - it will be invalid and, if successful,
-		 * will just end up propagating the write error out to
-		 * the file system. */
-		if (likely(!retval && !reiserfs_is_journal_aborted (journal))) {
-			if (buffer_dirty(jl->j_commit_bh))
-				BUG();
-			mark_buffer_dirty(jl->j_commit_bh) ;
-			reiserfs_write_unlock(s);
-			sync_dirty_buffer(jl->j_commit_bh) ;
-			reiserfs_write_lock(s);
-		}
-	} else {
+	/* If there was a write error in the journal - we can't commit
+	 * this transaction - it will be invalid and, if successful,
+	 * will just end up propagating the write error out to
+	 * the file system. */
+	if (likely(!retval && !reiserfs_is_journal_aborted (journal))) {
+		if (buffer_dirty(jl->j_commit_bh))
+			BUG();
+		mark_buffer_dirty(jl->j_commit_bh) ;
 		reiserfs_write_unlock(s);
-		wait_on_buffer(jl->j_commit_bh);
+		if (reiserfs_barrier_flush(s))
+			__sync_dirty_buffer(jl->j_commit_bh, WRITE_FLUSH_FUA);
+		else
+			sync_dirty_buffer(jl->j_commit_bh);
 		reiserfs_write_lock(s);
 	}
 
-	check_barrier_completion(s, jl->j_commit_bh);
-
 	/* If there was a write error in the journal - we can't commit this
 	 * transaction - it will be invalid and, if successful, will just end
 	 * up propagating the write error out to the filesystem. */
@@ -1319,26 +1264,15 @@ static int _update_journal_header_block(struct super_block *sb,
 		jh->j_first_unflushed_offset = cpu_to_le32(offset);
 		jh->j_mount_id = cpu_to_le32(journal->j_mount_id);
 
-		if (reiserfs_barrier_flush(sb)) {
-			int ret;
-			lock_buffer(journal->j_header_bh);
-			ret = submit_barrier_buffer(journal->j_header_bh);
-			if (ret == -EOPNOTSUPP) {
-				set_buffer_uptodate(journal->j_header_bh);
-				disable_barrier(sb);
-				goto sync;
-			}
-			reiserfs_write_unlock(sb);
-			wait_on_buffer(journal->j_header_bh);
-			reiserfs_write_lock(sb);
-			check_barrier_completion(sb, journal->j_header_bh);
-		} else {
-		      sync:
-			set_buffer_dirty(journal->j_header_bh);
-			reiserfs_write_unlock(sb);
+		set_buffer_dirty(journal->j_header_bh);
+		reiserfs_write_unlock(sb);
+
+		if (reiserfs_barrier_flush(sb))
+			__sync_dirty_buffer(journal->j_header_bh, WRITE_FLUSH_FUA);
+		else
 			sync_dirty_buffer(journal->j_header_bh);
-			reiserfs_write_lock(sb);
-		}
+
+		reiserfs_write_lock(sb);
 		if (!buffer_uptodate(journal->j_header_bh)) {
 			reiserfs_warning(sb, "journal-837",
 					 "IO error during journal replay");
-- 
1.7.1

