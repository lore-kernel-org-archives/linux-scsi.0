From: Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH][RESEND] Move some REQ flags to the common bio/request area
Date: Thu, 2 Jun 2011 16:54:23 -0400
Message-ID: <20110602205423.GE4061@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


REQ_SECURE, REQ_FLUSH and REQ_FUA may all be set on a bio as well as 
on a request, so relocate them to the shared part of the enum.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 2a7cea5..86dabf7 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -125,7 +125,11 @@ enum rq_flag_bits {
 	__REQ_SYNC,		/* request is sync (sync write or read) */
 	__REQ_META,		/* metadata io request */
 	__REQ_DISCARD,		/* request to discard sectors */
+	__REQ_SECURE,		/* secure discard (used with __REQ_DISCARD) */
+
 	__REQ_NOIDLE,		/* don't anticipate more IO after this one */
+	__REQ_FUA,		/* forced unit access */
+	__REQ_FLUSH,		/* request for cache flush */
 
 	/* bio only flags */
 	__REQ_RAHEAD,		/* read ahead, can fail anytime */
@@ -135,7 +139,6 @@ enum rq_flag_bits {
 	/* request only flags */
 	__REQ_SORTED,		/* elevator knows about this request */
 	__REQ_SOFTBARRIER,	/* may not be passed by ioscheduler */
-	__REQ_FUA,		/* forced unit access */
 	__REQ_NOMERGE,		/* don't touch this for merging */
 	__REQ_STARTED,		/* drive already may have started this one */
 	__REQ_DONTPREP,		/* don't call prep for this one */
@@ -146,11 +149,9 @@ enum rq_flag_bits {
 	__REQ_PREEMPT,		/* set for "ide_preempt" requests */
 	__REQ_ALLOCED,		/* request came from our alloc pool */
 	__REQ_COPY_USER,	/* contains copies of user pages */
-	__REQ_FLUSH,		/* request for cache flush */
 	__REQ_FLUSH_SEQ,	/* request for flush sequence */
 	__REQ_IO_STAT,		/* account I/O stat */
 	__REQ_MIXED_MERGE,	/* merge of different types, fail separately */
-	__REQ_SECURE,		/* secure discard (used with __REQ_DISCARD) */
 	__REQ_NR_BITS,		/* stops here */
 };
 
