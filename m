From: Matthew Wilcox <matthew@wil.cx>
Subject: Sparse fix for scsi_request_fn
Date: Mon, 22 Oct 2007 19:48:45 -0600
Message-ID: <20071023014845.GN27248@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:37348 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbXJWBsr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Oct 2007 21:48:47 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, Al Viro <viro@ftp.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Introduce new __holds() macro to tell sparse it's OK to drop and then
reacquire a lock within a function.  Use it in scsi_request_fn.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 207f1aa..5e0583a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1374,6 +1372,7 @@ static void scsi_softirq_done(struct request *rq)
  * Lock status: IO request lock assumed to be held when called.
  */
 static void scsi_request_fn(struct request_queue *q)
+		__holds(q->queue_lock)
 {
 	struct scsi_device *sdev = q->queuedata;
 	struct Scsi_Host *shost;
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 86f9a3a..1611ac6 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -12,6 +12,7 @@
 # define __iomem	__attribute__((noderef, address_space(2)))
 # define __acquires(x)	__attribute__((context(x,0,1)))
 # define __releases(x)	__attribute__((context(x,1,0)))
+# define __holds(x)	__attribute__((context(x,1,1)))
 # define __acquire(x)	__context__(x,1)
 # define __release(x)	__context__(x,-1)
 # define __cond_lock(x,c)	((c) ? ({ __acquire(x); 1; }) : 0)
@@ -29,6 +30,7 @@ extern void __chk_io_ptr(const volatile void __iomem *);
 # define __builtin_warning(x, y...) (1)
 # define __acquires(x)
 # define __releases(x)
+# define __holds(x)
 # define __acquire(x) (void)0
 # define __release(x) (void)0
 # define __cond_lock(x,c) (c)

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
