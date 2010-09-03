From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 35/41] jbd2: replace barriers with explicit flush
	/ FUA usage
Date: Fri,  3 Sep 2010 12:29:50 +0200
Message-ID: <1283509796-1510-36-git-send-email-tj@kernel.org>
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

Switch to the WRITE_FLUSH_FUA flag for journal commits and remove the
EOPNOTSUPP detection for barriers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/jbd2/commit.c |   43 ++++---------------------------------------
 1 files changed, 4 insertions(+), 39 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index d6aeb1f..f204e27 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -134,25 +134,11 @@ static int journal_submit_commit_record(journal_t *journal,
 
 	if (journal->j_flags & JBD2_BARRIER &&
 	    !JBD2_HAS_INCOMPAT_FEATURE(journal,
-				       JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT)) {
-		ret = submit_bh(WRITE_SYNC_PLUG | WRITE_BARRIER, bh);
-		if (ret == -EOPNOTSUPP) {
-			printk(KERN_WARNING
-			       "JBD2: Disabling barriers on %s, "
-			       "not supported by device\n", journal->j_devname);
-			write_lock(&journal->j_state_lock);
-			journal->j_flags &= ~JBD2_BARRIER;
-			write_unlock(&journal->j_state_lock);
-
-			/* And try again, without the barrier */
-			lock_buffer(bh);
-			set_buffer_uptodate(bh);
-			clear_buffer_dirty(bh);
-			ret = submit_bh(WRITE_SYNC_PLUG, bh);
-		}
-	} else {
+				       JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT))
+		ret = submit_bh(WRITE_SYNC_PLUG | WRITE_FLUSH_FUA, bh);
+	else
 		ret = submit_bh(WRITE_SYNC_PLUG, bh);
-	}
+
 	*cbh = bh;
 	return ret;
 }
@@ -166,29 +152,8 @@ static int journal_wait_on_commit_record(journal_t *journal,
 {
 	int ret = 0;
 
-retry:
 	clear_buffer_dirty(bh);
 	wait_on_buffer(bh);
-	if (buffer_eopnotsupp(bh) && (journal->j_flags & JBD2_BARRIER)) {
-		printk(KERN_WARNING
-		       "JBD2: %s: disabling barries on %s - not supported "
-		       "by device\n", __func__, journal->j_devname);
-		write_lock(&journal->j_state_lock);
-		journal->j_flags &= ~JBD2_BARRIER;
-		write_unlock(&journal->j_state_lock);
-
-		lock_buffer(bh);
-		clear_buffer_dirty(bh);
-		set_buffer_uptodate(bh);
-		bh->b_end_io = journal_end_buffer_io_sync;
-
-		ret = submit_bh(WRITE_SYNC_PLUG, bh);
-		if (ret) {
-			unlock_buffer(bh);
-			return ret;
-		}
-		goto retry;
-	}
 
 	if (unlikely(!buffer_uptodate(bh)))
 		ret = -EIO;
-- 
1.7.1
