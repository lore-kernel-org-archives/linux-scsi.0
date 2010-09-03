From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 28/41] xfs: replace barriers with explicit flush / FUA usage
Date: Fri,  3 Sep 2010 12:29:43 +0200
Message-ID: <1283509796-1510-29-git-send-email-tj@kernel.org>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1283509796-1510-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.co
Cc: Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>

Switch to the WRITE_FLUSH_FUA flag for log writes and remove the EOPNOTSUPP
detection for barriers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/xfs/linux-2.6/xfs_buf.c   |   16 ++--------------
 fs/xfs/linux-2.6/xfs_buf.h   |   11 +----------
 fs/xfs/linux-2.6/xfs_trace.h |    1 -
 fs/xfs/xfs_log.c             |   13 -------------
 4 files changed, 3 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index ea79072..b93ea33 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -929,19 +929,7 @@ xfs_buf_iodone_work(
 	xfs_buf_t		*bp =
 		container_of(work, xfs_buf_t, b_iodone_work);
 
-	/*
-	 * We can get an EOPNOTSUPP to ordered writes.  Here we clear the
-	 * ordered flag and reissue them.  Because we can't tell the higher
-	 * layers directly that they should not issue ordered I/O anymore, they
-	 * need to check if the _XFS_BARRIER_FAILED flag was set during I/O completion.
-	 */
-	if ((bp->b_error == EOPNOTSUPP) &&
-	    (bp->b_flags & (XBF_ORDERED|XBF_ASYNC)) == (XBF_ORDERED|XBF_ASYNC)) {
-		trace_xfs_buf_ordered_retry(bp, _RET_IP_);
-		bp->b_flags &= ~XBF_ORDERED;
-		bp->b_flags |= _XFS_BARRIER_FAILED;
-		xfs_buf_iorequest(bp);
-	} else if (bp->b_iodone)
+	if (bp->b_iodone)
 		(*(bp->b_iodone))(bp);
 	else if (bp->b_flags & XBF_ASYNC)
 		xfs_buf_relse(bp);
@@ -1200,7 +1188,7 @@ _xfs_buf_ioapply(
 
 	if (bp->b_flags & XBF_ORDERED) {
 		ASSERT(!(bp->b_flags & XBF_READ));
-		rw = WRITE_BARRIER;
+		rw = WRITE_FLUSH_FUA;
 	} else if (bp->b_flags & XBF_LOG_BUFFER) {
 		ASSERT(!(bp->b_flags & XBF_READ_AHEAD));
 		bp->b_flags &= ~_XBF_RUN_QUEUES;
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index d072e5f..d533d64 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -86,14 +86,6 @@ typedef enum {
  */
 #define _XBF_PAGE_LOCKED	(1 << 22)
 
-/*
- * If we try a barrier write, but it fails we have to communicate
- * this to the upper layers.  Unfortunately b_error gets overwritten
- * when the buffer is re-issued so we have to add another flag to
- * keep this information.
- */
-#define _XFS_BARRIER_FAILED	(1 << 23)
-
 typedef unsigned int xfs_buf_flags_t;
 
 #define XFS_BUF_FLAGS \
@@ -114,8 +106,7 @@ typedef unsigned int xfs_buf_flags_t;
 	{ _XBF_PAGES,		"PAGES" }, \
 	{ _XBF_RUN_QUEUES,	"RUN_QUEUES" }, \
 	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
-	{ _XBF_PAGE_LOCKED,	"PAGE_LOCKED" }, \
-	{ _XFS_BARRIER_FAILED,	"BARRIER_FAILED" }
+	{ _XBF_PAGE_LOCKED,	"PAGE_LOCKED" }
 
 
 typedef enum {
diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index be5dffd..8fe311a 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -325,7 +325,6 @@ DEFINE_BUF_EVENT(xfs_buf_lock);
 DEFINE_BUF_EVENT(xfs_buf_lock_done);
 DEFINE_BUF_EVENT(xfs_buf_cond_lock);
 DEFINE_BUF_EVENT(xfs_buf_unlock);
-DEFINE_BUF_EVENT(xfs_buf_ordered_retry);
 DEFINE_BUF_EVENT(xfs_buf_iowait);
 DEFINE_BUF_EVENT(xfs_buf_iowait_done);
 DEFINE_BUF_EVENT(xfs_buf_delwri_queue);
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 33f718f..ba8e36e 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -917,19 +917,6 @@ xlog_iodone(xfs_buf_t *bp)
 	l = iclog->ic_log;
 
 	/*
-	 * If the _XFS_BARRIER_FAILED flag was set by a lower
-	 * layer, it means the underlying device no longer supports
-	 * barrier I/O. Warn loudly and turn off barriers.
-	 */
-	if (bp->b_flags & _XFS_BARRIER_FAILED) {
-		bp->b_flags &= ~_XFS_BARRIER_FAILED;
-		l->l_mp->m_flags &= ~XFS_MOUNT_BARRIER;
-		xfs_fs_cmn_err(CE_WARN, l->l_mp,
-				"xlog_iodone: Barriers are no longer supported"
-				" by device. Disabling barriers\n");
-	}
-
-	/*
 	 * Race to shutdown the filesystem if we see an error.
 	 */
 	if (XFS_TEST_ERROR((XFS_BUF_GETERROR(bp)), l->l_mp,
-- 
1.7.1
