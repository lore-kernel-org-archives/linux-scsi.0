From: Tejun Heo <teheo@suse.de>
Subject: [PATCH 24.5/30] jbd2: Modify ASYNC_COMMIT code to not rely on queue
 draining on barrier
Date: Thu, 26 Aug 2010 10:23:18 +0200
Message-ID: <4C762476.2020802@suse.de>
References: <1282751267-3530-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1282751267-3530-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.
List-Id: linux-scsi@vger.kernel.org

>From 49f4cef00a1bd3c79fb2fe1f982c5157f0792867 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>

Currently JBD2 relies blkdev_issue_flush() draining the queue when ASYNC_COMMIT
feature is set. This property is going away so make JBD2 wait for buffers it
needs on its own before submitting the cache flush.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
This patch is necessary before enabling flush/fua support in jbd2.
The flush-fua git tree has been udpated to included this between patch
24 and 25.

Thanks.

 fs/jbd2/commit.c |   29 ++++++++++++++++-------------
 1 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 7c068c1..8797fd1 100644
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
+			blkdev_issue_flush(journal->j_dev, GFP_KERNEL, NULL,
+				BLKDEV_IFL_WAIT);
+	}

 	if (err)
 		jbd2_journal_abort(journal, err);
-- 
1.7.1

