From: James Bottomley <James.Bottomley@suse.de>
Subject: [PATCH 1/2] block: add proper state guards to __elv_next_request
Date: Fri, 22 Apr 2011 10:38:51 -0500
Message-ID: <1303486731.2590.23.camel@mulgrave.site>
References: <1303486638.2590.21.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54314 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204Ab1DVPiz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Apr 2011 11:38:55 -0400
In-Reply-To: <1303486638.2590.21.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>

blk_cleanup_queue() calls elevator_exit() and after this, we can't
touch the elevator without oopsing.  __elv_next_request() must check
for this state because in the refcounted queue model, we can still
call it after blk_cleanup_queue() has been called.

This was reported as causing an oops attributable to scsi.

Signed-off-by: James Bottomley <James.Bottomley@suse.de>
---
 block/blk.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/block/blk.h b/block/blk.h
index 6126346..4df474d 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -62,7 +62,8 @@ static inline struct request *__elv_next_request(struct request_queue *q)
 			return rq;
 		}
 
-		if (!q->elevator->ops->elevator_dispatch_fn(q, 0))
+		if (test_bit(QUEUE_FLAG_DEAD, &q->queue_flags) ||
+		    !q->elevator->ops->elevator_dispatch_fn(q, 0))
 			return NULL;
 	}
 }
-- 
1.7.4.1



