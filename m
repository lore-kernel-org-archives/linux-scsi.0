From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH 2/2] sg: fix races with ioctl(SG_IO)
Date: Mon, 19 Jan 2009 18:06:23 -0500
Message-ID: <4975076F.2040509@cybernetics.com>
References: <49625A67.3000304@cybernetics.com>	<20090111022525I.fujita.tomonori@lab.ntt.co.jp>	<496E4B93.4000507@cybernetics.com> <20090119155509Y.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([98.174.209.230]:2223 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbZASXGY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Jan 2009 18:06:24 -0500
In-Reply-To: <20090119155509Y.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, dgilbert@interlog.com, hch@infradead.org, linux-scsi@vger.kernel.org

sg_io_owned needs to be set before the command is sent to the midlevel;
otherwise, a quickly-completing command may cause a different CPU
to see "srp->done == 1 && !srp->sg_io_owned", which would lead to
incorrect behavior.

Check srp->done and set srp->orphan while holding rq_list_lock to
prevent races with sg_rq_end_io().

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---

Same as before, just rediffed against v4 of the previous patch.

 sg.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- linux-2.6.29-rc2/drivers/scsi/sg.c.orig	2009-01-19 16:26:21.000000000 -0500
+++ linux-2.6.29-rc2/drivers/scsi/sg.c	2009-01-19 17:53:28.000000000 -0500
@@ -208,7 +208,7 @@ static ssize_t sg_new_read(Sg_fd * sfp, 
 			   Sg_request * srp);
 static ssize_t sg_new_write(Sg_fd *sfp, struct file *file,
 			const char __user *buf, size_t count, int blocking,
-			int read_only, Sg_request **o_srp);
+			int read_only, int sg_io_owned, Sg_request **o_srp);
 static int sg_common_write(Sg_fd * sfp, Sg_request * srp,
 			   unsigned char *cmnd, int timeout, int blocking);
 static int sg_read_oxfer(Sg_request * srp, char __user *outp, int num_read_xfer);
@@ -590,7 +590,8 @@ sg_write(struct file *filp, const char _
 		return -EFAULT;
 	blocking = !(filp->f_flags & O_NONBLOCK);
 	if (old_hdr.reply_len < 0)
-		return sg_new_write(sfp, filp, buf, count, blocking, 0, NULL);
+		return sg_new_write(sfp, filp, buf, count,
+				    blocking, 0, 0, NULL);
 	if (count < (SZ_SG_HEADER + 6))
 		return -EIO;	/* The minimum scsi command length is 6 bytes. */
 
@@ -671,7 +672,7 @@ sg_write(struct file *filp, const char _
 
 static ssize_t
 sg_new_write(Sg_fd *sfp, struct file *file, const char __user *buf,
-		 size_t count, int blocking, int read_only,
+		 size_t count, int blocking, int read_only, int sg_io_owned,
 		 Sg_request **o_srp)
 {
 	int k;
@@ -691,6 +692,7 @@ sg_new_write(Sg_fd *sfp, struct file *fi
 		SCSI_LOG_TIMEOUT(1, printk("sg_new_write: queue full\n"));
 		return -EDOM;
 	}
+	srp->sg_io_owned = sg_io_owned;
 	hp = &srp->header;
 	if (__copy_from_user(hp, buf, SZ_SG_IO_HDR)) {
 		sg_remove_request(sfp, srp);
@@ -838,10 +840,9 @@ sg_ioctl(struct inode *inode, struct fil
 				return -EFAULT;
 			result =
 			    sg_new_write(sfp, filp, p, SZ_SG_IO_HDR,
-					 blocking, read_only, &srp);
+					 blocking, read_only, 1, &srp);
 			if (result < 0)
 				return result;
-			srp->sg_io_owned = 1;
 			while (1) {
 				result = 0;	/* following macro to beat race condition */
 				__wait_event_interruptible(sfp->read_wait,
@@ -851,14 +852,16 @@ sg_ioctl(struct inode *inode, struct fil
 					return -ENODEV;
 				if (sfp->closed)
 					return 0;	/* request packet dropped already */
-				if (0 == result)
+				write_lock_irq(&sfp->rq_list_lock);
+				if (srp->done) {
+					srp->done = 2;
+					write_unlock_irq(&sfp->rq_list_lock);
 					break;
+				}
 				srp->orphan = 1;
+				write_unlock_irq(&sfp->rq_list_lock);
 				return result;	/* -ERESTARTSYS because signal hit process */
 			}
-			write_lock_irqsave(&sfp->rq_list_lock, iflags);
-			srp->done = 2;
-			write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 			result = sg_new_read(sfp, p, SZ_SG_IO_HDR, srp);
 			return (result < 0) ? result : 0;
 		}


