From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH 2/2] sg: fix races with ioctl(SG_IO)
Date: Mon, 05 Jan 2009 14:11:23 -0500
Message-ID: <49625B5B.6090802@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([98.174.209.230]:1257 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934AbZAETLo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jan 2009 14:11:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James.Bottomley@HansenPartnership.com
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

sg_io_owned needs to be set before the command is sent to the midlevel;
otherwise, a quickly-completing command may cause a different CPU
to see "srp->done == 1 && !srp->sg_io_owned", which would lead to
incorrect behavior.

Check srp->done and set srp->orphan while holding rq_list_lock to
prevent races with sg_rq_end_io().

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---
 sg.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)
--- linux-2.6.28/drivers/scsi/sg.c.orig	2009-01-05 11:08:09.000000000 -0500
+++ linux-2.6.28/drivers/scsi/sg.c	2009-01-05 11:10:46.000000000 -0500
@@ -197,7 +197,7 @@ static ssize_t sg_new_read(Sg_fd * sfp, 
 			   Sg_request * srp);
 static ssize_t sg_new_write(Sg_fd *sfp, struct file *file,
 			const char __user *buf, size_t count, int blocking,
-			int read_only, Sg_request **o_srp);
+			int read_only, int sg_io_owned, Sg_request **o_srp);
 static int sg_common_write(Sg_fd * sfp, Sg_request * srp,
 			   unsigned char *cmnd, int timeout, int blocking);
 static int sg_read_oxfer(Sg_request * srp, char __user *outp, int num_read_xfer);
@@ -607,7 +607,8 @@ sg_write(struct file *filp, const char _
 		return -EFAULT;
 	blocking = !(filp->f_flags & O_NONBLOCK);
 	if (old_hdr.reply_len < 0)
-		return sg_new_write(sfp, filp, buf, count, blocking, 0, NULL);
+		return sg_new_write(sfp, filp, buf, count,
+				    blocking, 0, 0, NULL);
 	if (count < (SZ_SG_HEADER + 6))
 		return -EIO;	/* The minimum scsi command length is 6 bytes. */
 
@@ -688,7 +689,7 @@ sg_write(struct file *filp, const char _
 
 static ssize_t
 sg_new_write(Sg_fd *sfp, struct file *file, const char __user *buf,
-		 size_t count, int blocking, int read_only,
+		 size_t count, int blocking, int read_only, int sg_io_owned,
 		 Sg_request **o_srp)
 {
 	int k;
@@ -708,6 +709,7 @@ sg_new_write(Sg_fd *sfp, struct file *fi
 		SCSI_LOG_TIMEOUT(1, printk("sg_new_write: queue full\n"));
 		return -EDOM;
 	}
+	srp->sg_io_owned = sg_io_owned;
 	hp = &srp->header;
 	if (__copy_from_user(hp, buf, SZ_SG_IO_HDR)) {
 		sg_remove_request(sfp, srp);
@@ -854,10 +856,9 @@ sg_ioctl(struct inode *inode, struct fil
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
@@ -867,14 +868,16 @@ sg_ioctl(struct inode *inode, struct fil
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


