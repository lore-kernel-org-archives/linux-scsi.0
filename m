From: Tejun Heo <tj@kernel.org>
Subject: [PATCH block:for-3.3/core] block: disable
 ELEVATOR_INSERT_SORT_MERGE
Date: Thu, 5 Jan 2012 19:52:47 -0800
Message-ID: <20120106035247.GF6276@google.com>
References: <20120103221301.GH31746@google.com>
 <20120103223505.GI31746@google.com>
 <20120105012445.GP31746@google.com>
 <alpine.LSU.2.00.1201051026090.2009@eggly.anvils>
 <20120105183842.GF18486@google.com>
 <20120106021707.GA6276@google.com>
 <20120106023638.GC6276@google.com>
 <1325819655.22361.513.camel@sli10-conroe>
 <20120106030406.GD6276@google.com>
 <20120106033012.GE6276@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120106033012.GE6276@google.com>
Sender: linux-next-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Hugh Dickins <hughd@google.com>, Shaohua Li <shaohua.li@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org

5e84ea3a9c "block: attempt to merge with existing requests on plug
flush" added support for merging requests on plug flush and 274193224c
"block: recursive merge requests" added recursive merging.

Because these mergings happen before the request is inserted on the
elevator, the usual elv_latter/former_request() can't be used to
locate merge candidates.  It instead used bio merging mechanism -
last_merge hint and rqhash; unfortunately, this means that the
elevator doesn't have a say in which are allowed to merge and which
aren't.

For cfq, this resulted in merges across different cfqq's which led to
crashes as requests jump between different cfqq's unexpectedly.

Proper solution would be improving merge mechanism such that we can
always query elevator to find out merge candidates and remove rqhash;
however, the merge window is already upon us.  Disable
INSERT_SORT_MERGE for now.

For detailed discussion of the bug:

 http://thread.gmane.org/gmane.linux.kernel.next/20064/focus=20159

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Hugh Dickins <hughd@google.com>
Cc: stable@vger.kernel.org
---
 block/blk-core.c |    5 ++++-
 block/elevator.c |    5 +++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 8fbdac7..7db6afa 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2859,11 +2859,14 @@ void blk_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 
 		/*
 		 * rq is already accounted, so use raw insert
+		 *
+		 * FIXME: We want INSERT_SORT_MERGE for non-FLUSH/FUA
+		 * requests but it's currently broken.
 		 */
 		if (rq->cmd_flags & (REQ_FLUSH | REQ_FUA))
 			__elv_add_request(q, rq, ELEVATOR_INSERT_FLUSH);
 		else
-			__elv_add_request(q, rq, ELEVATOR_INSERT_SORT_MERGE);
+			__elv_add_request(q, rq, ELEVATOR_INSERT_SORT);
 
 		depth++;
 	}
diff --git a/block/elevator.c b/block/elevator.c
index 99838f4..c32f5bc 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -644,6 +644,11 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
 
 	rq->q = q;
 
+	/*
+	 * FIXME: INSERT_SORT_MERGE is broken and blk_flush_plug_list(),
+	 * the only user, is updated to use INSERT_SORT for now.
+	 */
+
 	if (rq->cmd_flags & REQ_SOFTBARRIER) {
 		/* barriers are scheduling boundary, update end_sector */
 		if (rq->cmd_type == REQ_TYPE_FS ||
