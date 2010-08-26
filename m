From: Tejun Heo <teheo@suse.de>
Subject: [PATCH UPDATED 24.5/30] jbd2: Modify ASYNC_COMMIT code to not rely
 on queue draining on barrier
Date: Thu, 26 Aug 2010 11:37:00 +0200
Message-ID: <4C7635BC.10402@suse.de>
References: <1282751267-3530-1-git-send-email-tj@kernel.org> <4C762476.2020802@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4C762476.2020802@suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.
List-Id: linux-scsi@vger.kernel.org

Currently JBD2 relies blkdev_issue_flush() draining the queue when ASYNC_COMMIT
feature is set. This property is going away so make JBD2 wait for buffers it
needs on its own before submitting the cache flush.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Fixed overindentation noticed by Sergei.  git tree updated accordingly.

Thanks.

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

