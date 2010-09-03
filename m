From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 33/41] jbd: replace barriers with explicit flush
	/ FUA usage
Date: Fri,  3 Sep 2010 12:29:48 +0200
Message-ID: <1283509796-1510-34-git-send-email-tj@kernel.org>
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
 fs/jbd/commit.c |   30 +++---------------------------
 1 files changed, 3 insertions(+), 27 deletions(-)

diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 95d8c11..484c5e5 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -137,34 +137,10 @@ static int journal_write_commit_record(journal_t *journal,
 	JBUFFER_TRACE(descriptor, "write commit block");
 	set_buffer_dirty(bh);
 
-	if (journal->j_flags & JFS_BARRIER) {
-		ret = __sync_dirty_buffer(bh, WRITE_SYNC | WRITE_BARRIER);
-
-		/*
-		 * Is it possible for another commit to fail at roughly
-		 * the same time as this one?  If so, we don't want to
-		 * trust the barrier flag in the super, but instead want
-		 * to remember if we sent a barrier request
-		 */
-		if (ret == -EOPNOTSUPP) {
-			char b[BDEVNAME_SIZE];
-
-			printk(KERN_WARNING
-				"JBD: barrier-based sync failed on %s - "
-				"disabling barriers\n",
-				bdevname(journal->j_dev, b));
-			spin_lock(&journal->j_state_lock);
-			journal->j_flags &= ~JFS_BARRIER;
-			spin_unlock(&journal->j_state_lock);
-
-			/* And try again, without the barrier */
-			set_buffer_uptodate(bh);
-			set_buffer_dirty(bh);
-			ret = sync_dirty_buffer(bh);
-		}
-	} else {
+	if (journal->j_flags & JFS_BARRIER)
+		ret = __sync_dirty_buffer(bh, WRITE_SYNC | WRITE_FLUSH_FUA);
+	else
 		ret = sync_dirty_buffer(bh);
-	}
 
 	put_bh(bh);		/* One for getblk() */
 	journal_put_journal_head(descriptor);
-- 
1.7.1
