From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 34/41] jbd2: Modify ASYNC_COMMIT code to not rely
	on queue draining on barrier
Date: Fri,  3 Sep 2010 12:29:49 +0200
Message-ID: <1283509796-1510-35-git-send-email-tj@kernel.org>
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
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Jan Kara <jack@suse.cz>

Currently JBD2 relies blkdev_issue_flush() draining the queue when ASYNC_COMMIT
feature is set. This property is going away so make JBD2 wait for buffers it
needs on its own before submitting the cache flush.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/jbd2/commit.c |   29 ++++++++++++++++-------------
 1 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 7c068c1..d6aeb1f 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -701,6 +701,16 @@ start_journal_io:
 		}
 	}
 
+	err = journal_finish_inode_data_buffers(journal, commit_transaction);
+	if (err) {
+		printk(KERN_WARNING
+			"JBD2: Detected IO errors while flushing file data "
+		       "on %s\n", journal->j_devname);
+		if (journal->j_flags & JBD2_ABORT_ON_SYNCDATA_ERR)
+			jbd2_journal_abort(journal, err);
+		err = 0;
+	}
+
 	/* 
 	 * If the journal is not located on the file system device,
 	 * then we must flush the file system device before we issue
@@ -719,19 +729,6 @@ start_journal_io:
 						 &cbh, crc32_sum);
 		if (err)
 			__jbd2_journal_abort_hard(journal);
-		if (journal->j_flags & JBD2_BARRIER)
-			blkdev_issue_flush(journal->j_dev, GFP_KERNEL, NULL,
-				BLKDEV_IFL_WAIT);
-	}
-
-	err = journal_finish_inode_data_buffers(journal, commit_transaction);
-	if (err) {
-		printk(KERN_WARNING
-			"JBD2: Detected IO errors while flushing file data "
-		       "on %s\n", journal->j_devname);
-		if (journal->j_flags & JBD2_ABORT_ON_SYNCDATA_ERR)
-			jbd2_journal_abort(journal, err);
-		err = 0;
 	}
 
 	/* Lo and behold: we have just managed to send a transaction to
@@ -845,6 +842,12 @@ wait_for_iobuf:
 	}
 	if (!err && !is_journal_aborted(journal))
 		err = journal_wait_on_commit_record(journal, cbh);
+	if (JBD2_HAS_INCOMPAT_FEATURE(journal,
+				      JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT) &&
+	    journal->j_flags & JBD2_BARRIER) {
+		blkdev_issue_flush(journal->j_dev, GFP_KERNEL, NULL,
+				   BLKDEV_IFL_WAIT);
+	}
 
 	if (err)
 		jbd2_journal_abort(journal, err);
-- 
1.7.1
