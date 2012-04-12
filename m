From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: [PATCH 02/10] sg: remove while (1) non-loop
Date: Thu, 12 Apr 2012 17:32:48 -0400
Message-ID: <20120412213248.GB17388@logfs.org>
References: <20120412213217.GA17388@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:37798 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934972Ab2DLX3X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Apr 2012 19:29:23 -0400
Content-Disposition: inline
In-Reply-To: <20120412213217.GA17388@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Gilbert <dgilbert@interlog.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

The while (1) construct isn't actually a loop at all.  So let's not
pretent and obfuscate the code.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/scsi/sg.c |   30 +++++++++++++-----------------
 1 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 14de843..f9e89b2 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -801,25 +801,21 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 				 1, read_only, 1, &srp);
 		if (result < 0)
 			return result;
-		while (1) {
-			result = 0;	/* following macro to beat race condition */
-			__wait_event_interruptible(sfp->read_wait,
-				(srp->done || sdp->detached),
-				result);
-			if (sdp->detached)
-				return -ENODEV;
-			write_lock_irq(&sfp->rq_list_lock);
-			if (srp->done) {
-				srp->done = 2;
-				write_unlock_irq(&sfp->rq_list_lock);
-				break;
-			}
-			srp->orphan = 1;
+		result = 0;	/* following macro to beat race condition */
+		__wait_event_interruptible(sfp->read_wait,
+			(srp->done || sdp->detached), result);
+		if (sdp->detached)
+			return -ENODEV;
+		write_lock_irq(&sfp->rq_list_lock);
+		if (srp->done) {
+			srp->done = 2;
 			write_unlock_irq(&sfp->rq_list_lock);
-			return result;	/* -ERESTARTSYS because signal hit process */
+			result = sg_new_read(sfp, p, SZ_SG_IO_HDR, srp);
+			return (result < 0) ? result : 0;
 		}
-		result = sg_new_read(sfp, p, SZ_SG_IO_HDR, srp);
-		return (result < 0) ? result : 0;
+		srp->orphan = 1;
+		write_unlock_irq(&sfp->rq_list_lock);
+		return result;	/* -ERESTARTSYS because signal hit process */
 	case SG_SET_TIMEOUT:
 		result = get_user(val, ip);
 		if (result)
-- 
1.7.9.1

