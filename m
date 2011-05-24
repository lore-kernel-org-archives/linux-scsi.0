From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] block: fix oops in blk_run_queue()
Date: Tue, 24 May 2011 13:18:51 -0400
Message-ID: <1306257531.10201.20.camel@mulgrave.site>
References: <bug-35282-11613@https.bugzilla.kernel.org/>
	 <201105191944.p4JJiVVm029690@demeter1.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36757 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757560Ab1EXVce (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2011 17:32:34 -0400
In-Reply-To: <201105191944.p4JJiVVm029690@demeter1.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-scsi@vger.kernel.org

Bugzilla report is here:

https://bugzilla.kernel.org/show_bug.cgi?id=35682

The problem occurs if blk_run_queue() or its variants is called after
blk_cleanup_queue() is called.  The run checks should have a state guard
for QUEUE_FLAG_DEAD.  Since a DEAD queue is always STOPPED, just fold it
into the blk_queue_stopped() test.

Signed-off-by: James Bottomley <jbottomley@parallels.com>

---

Jens, can you look at this, please ... would you prefer a separate DEAD
test instead?  Incidentally, this is in addition to the other DEAD test
you still haven't applied ...

James



diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2ad95fa..8166845 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -473,7 +473,9 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 }
 
 #define blk_queue_tagged(q)	test_bit(QUEUE_FLAG_QUEUED, &(q)->queue_flags)
-#define blk_queue_stopped(q)	test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags)
+#define blk_queue_stopped(q)	\
+		(test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags) || \
+		 test_bit(QUEUE_FLAG_DEAD, &(q)->queue_flags))
 #define blk_queue_nomerges(q)	test_bit(QUEUE_FLAG_NOMERGES, &(q)->queue_flags)
 #define blk_queue_noxmerges(q)	\
 	test_bit(QUEUE_FLAG_NOXMERGES, &(q)->queue_flags)


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


