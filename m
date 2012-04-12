From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: [PATCH 01/10] sg: remove unnecessary indentation
Date: Thu, 12 Apr 2012 17:32:17 -0400
Message-ID: <20120412213217.GA17388@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:37795 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934959Ab2DLX2x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Apr 2012 19:28:53 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Gilbert <dgilbert@interlog.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

blocking is de-facto a constant and the now-removed comment wasn't all
that useful either.  Without them and the resulting indentation the code
is a bit nicer to read.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/scsi/sg.c |   53 ++++++++++++++++++++++++-----------------------------
 1 files changed, 24 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index eacd46b..14de843 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -791,40 +791,35 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 
 	switch (cmd_in) {
 	case SG_IO:
-		{
-			int blocking = 1;	/* ignore O_NONBLOCK flag */
-
+		if (sdp->detached)
+			return -ENODEV;
+		if (!scsi_block_when_processing_errors(sdp->device))
+			return -ENXIO;
+		if (!access_ok(VERIFY_WRITE, p, SZ_SG_IO_HDR))
+			return -EFAULT;
+		result = sg_new_write(sfp, filp, p, SZ_SG_IO_HDR,
+				 1, read_only, 1, &srp);
+		if (result < 0)
+			return result;
+		while (1) {
+			result = 0;	/* following macro to beat race condition */
+			__wait_event_interruptible(sfp->read_wait,
+				(srp->done || sdp->detached),
+				result);
 			if (sdp->detached)
 				return -ENODEV;
-			if (!scsi_block_when_processing_errors(sdp->device))
-				return -ENXIO;
-			if (!access_ok(VERIFY_WRITE, p, SZ_SG_IO_HDR))
-				return -EFAULT;
-			result =
-			    sg_new_write(sfp, filp, p, SZ_SG_IO_HDR,
-					 blocking, read_only, 1, &srp);
-			if (result < 0)
-				return result;
-			while (1) {
-				result = 0;	/* following macro to beat race condition */
-				__wait_event_interruptible(sfp->read_wait,
-					(srp->done || sdp->detached),
-					result);
-				if (sdp->detached)
-					return -ENODEV;
-				write_lock_irq(&sfp->rq_list_lock);
-				if (srp->done) {
-					srp->done = 2;
-					write_unlock_irq(&sfp->rq_list_lock);
-					break;
-				}
-				srp->orphan = 1;
+			write_lock_irq(&sfp->rq_list_lock);
+			if (srp->done) {
+				srp->done = 2;
 				write_unlock_irq(&sfp->rq_list_lock);
-				return result;	/* -ERESTARTSYS because signal hit process */
+				break;
 			}
-			result = sg_new_read(sfp, p, SZ_SG_IO_HDR, srp);
-			return (result < 0) ? result : 0;
+			srp->orphan = 1;
+			write_unlock_irq(&sfp->rq_list_lock);
+			return result;	/* -ERESTARTSYS because signal hit process */
 		}
+		result = sg_new_read(sfp, p, SZ_SG_IO_HDR, srp);
+		return (result < 0) ? result : 0;
 	case SG_SET_TIMEOUT:
 		result = get_user(val, ip);
 		if (result)
-- 
1.7.9.1

