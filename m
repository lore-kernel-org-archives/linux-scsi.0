From: Tejun Heo <tj@kernel.org>
Subject: [PATCH block:for-3.3/core] cfq: merged request shouldn't jump to a
 different cfqq
Date: Thu, 5 Jan 2012 18:17:07 -0800
Message-ID: <20120106021707.GA6276@google.com>
References: <20111228211918.GA3516@google.com>
 <20120103173500.GB31746@google.com>
 <20120103175922.GC31746@google.com>
 <20120103200906.GG31746@google.com>
 <4F03631C.8080501@kernel.dk>
 <20120103221301.GH31746@google.com>
 <20120103223505.GI31746@google.com>
 <20120105012445.GP31746@google.com>
 <alpine.LSU.2.00.1201051026090.2009@eggly.anvils>
 <20120105183842.GF18486@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120105183842.GF18486@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shaohua.li@intel.com>, Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org

When two requests are merged, if the absorbed request is older than
the absorbing one, cfq_merged_requests() tries to reposition it in the
cfqq->fifo list by list_move()'ing the absorbing request to the
absorbed one before removing it.

This works if both requests are on the same cfqq but nothing
guarantees that and the code ends up moving the merged request to a
different cfqq's fifo list without adjusting the rest.  This leads to
the following failures.

* A request may be on the fifo list of a cfqq without holding
  reference to it and the cfqq can be freed before requst is finished.
  Among other things, this triggers list debug warning and slab debug
  use-after-free warning.

* As a request can be on the wrong fifo queue, it may be issued and
  completed before its cfqq is scheduled.  If the cfqq didn't have
  other requests on it, it would be empty by the time it's dispatched
  triggering BUG_ON() in cfq_dispatch_request().

Fix it by making cfq_merged_requests() scan the absorbing request's
fifo list for the correct slot and move there instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Hugh Dickins <hughd@google.com>
Cc: stable@vger.kernel.org
---
It survived my testing long enough and I'm relatively confident this
should fix the crash but I might have gotten the scanning wrong, so
please pay extra attention there.

I suspect we just didn't have enough backward request-request merges
before the recent plug merge updates to trigger this bug.

Thanks.

 block/cfq-iosched.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 163263d..a235cf3 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1663,8 +1663,15 @@ cfq_merged_requests(struct request_queue *q, struct request *rq,
 	 */
 	if (!list_empty(&rq->queuelist) && !list_empty(&next->queuelist) &&
 	    time_before(rq_fifo_time(next), rq_fifo_time(rq))) {
-		list_move(&rq->queuelist, &next->queuelist);
+		struct request *pos = rq;
+
 		rq_set_fifo_time(rq, rq_fifo_time(next));
+
+		list_for_each_entry_continue_reverse(pos, &cfqq->fifo, queuelist)
+			if (time_before_eq(rq_fifo_time(pos), rq_fifo_time(rq)))
+				break;
+		if (rq != pos)
+			list_move(&rq->queuelist, &pos->queuelist);
 	}
 
 	if (cfqq->next_rq == next)
