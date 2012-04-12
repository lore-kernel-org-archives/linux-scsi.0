From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: [PATCH 03/10] sg: remove while (1) non-loop
Date: Thu, 12 Apr 2012 17:33:10 -0400
Message-ID: <20120412213310.GC17388@logfs.org>
References: <20120412213217.GA17388@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:37801 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934972Ab2DLX3p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Apr 2012 19:29:45 -0400
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
 drivers/scsi/sg.c |   22 +++++++++-------------
 1 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index f9e89b2..be812e0 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -398,19 +398,15 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 			retval = -EAGAIN;
 			goto free_old_hdr;
 		}
-		while (1) {
-			retval = 0; /* following macro beats race condition */
-			__wait_event_interruptible(sfp->read_wait,
-				(sdp->detached ||
-				(srp = sg_get_rq_mark(sfp, req_pack_id))), 
-				retval);
-			if (sdp->detached) {
-				retval = -ENODEV;
-				goto free_old_hdr;
-			}
-			if (0 == retval)
-				break;
-
+		retval = 0; /* following macro beats race condition */
+		__wait_event_interruptible(sfp->read_wait,
+			(sdp->detached ||
+			(srp = sg_get_rq_mark(sfp, req_pack_id))), retval);
+		if (sdp->detached) {
+			retval = -ENODEV;
+			goto free_old_hdr;
+		}
+		if (retval) {
 			/* -ERESTARTSYS as signal hit process */
 			goto free_old_hdr;
 		}
-- 
1.7.9.1

