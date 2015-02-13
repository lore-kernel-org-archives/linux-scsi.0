From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH v2 2/2] [SCSI] sg: fix EWOULDBLOCK errors with scsi-mq
Date: Fri, 13 Feb 2015 12:10:58 -0500
Message-ID: <54DE3022.7070803@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

With scsi-mq enabled, userspace programs can get unexpected EWOULDBLOCK
(a.k.a. EAGAIN) errors when submitting commands to the SCSI generic
driver.  Fix by calling blk_get_request() with GFP_KERNEL instead of
GFP_ATOMIC.

Note: to avoid introducing a potential deadlock, this patch should be
applied after the patch titled "sg: fix unkillable I/O wait deadlock
with scsi-mq".

Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: <stable@vger.kernel.org> # 3.17+
Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---

For inclusion in kernel 3.20.

The difference in behavior is due to bt_get() in block/blk-mq-tag.c
checking for __GFP_WAIT.

The bsg driver already calls blk_get_request() with GFP_KERNEL, so there
is no need for a change there.

--- linux-3.19.0/drivers/scsi/sg.c.orig	2015-02-13 11:04:40.000000000 -0500
+++ linux-3.19.0/drivers/scsi/sg.c	2015-02-13 11:05:14.000000000 -0500
@@ -1695,7 +1695,22 @@ sg_start_req(Sg_request *srp, unsigned c
 			return -ENOMEM;
 	}
 
+	/*
+	 * NOTE
+	 *
+	 * With scsi-mq enabled, there are a fixed number of preallocated
+	 * requests equal in number to shost->can_queue.  If all of the
+	 * preallocated requests are already in use, then using GFP_ATOMIC with
+	 * blk_get_request() will return -EWOULDBLOCK, whereas using GFP_KERNEL
+	 * will cause blk_get_request() to sleep until an active command
+	 * completes, freeing up a request.  Neither option is ideal, but
+	 * GFP_KERNEL is the better choice to prevent userspace from getting an
+	 * unexpected EWOULDBLOCK.
+	 *
+	 * With scsi-mq disabled, blk_get_request() with GFP_KERNEL usually
+	 * does not sleep except under memory pressure.
+	 */
+	rq = blk_get_request(q, rw, GFP_KERNEL);
-	rq = blk_get_request(q, rw, GFP_ATOMIC);
 	if (IS_ERR(rq)) {
 		kfree(long_cmdp);
 		return PTR_ERR(rq);
