From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: [PATCH 05/10] sg: remove closed flag
Date: Thu, 12 Apr 2012 17:33:39 -0400
Message-ID: <20120412213339.GE17388@logfs.org>
References: <20120412213217.GA17388@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:37807 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935033Ab2DLXaP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Apr 2012 19:30:15 -0400
Content-Disposition: inline
In-Reply-To: <20120412213217.GA17388@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Gilbert <dgilbert@interlog.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

After sg_release() has been called, noone should be able to actually use
that filedescriptor anymore.  So if closed ever made a difference in the
past five years or so, it would have meant a bug.  Remove it.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/scsi/sg.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 1a0be4f..ba657a9 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -157,7 +157,6 @@ typedef struct sg_fd {		/* holds the state of a file descriptor */
 	Sg_request req_arr[SG_MAX_QUEUE];	/* used as singly-linked list */
 	char low_dma;		/* as in parent but possibly overridden to 1 */
 	char force_packid;	/* 1 -> pack_id input to read(), 0 -> ignored */
-	volatile char closed;	/* 1 -> fd closed but request(s) outstanding */
 	char cmd_q;		/* 1 -> allow command queuing, 0 -> don't */
 	char next_cmd_len;	/* 0 -> automatic (def), >0 -> use on next write() */
 	char keep_orphan;	/* 0 -> drop orphan (def), 1 -> keep for read() */
@@ -329,8 +328,6 @@ sg_release(struct inode *inode, struct file *filp)
 		return -ENXIO;
 	SCSI_LOG_TIMEOUT(3, printk("sg_release: %s\n", sdp->disk->disk_name));
 
-	sfp->closed = 1;
-
 	sdp->exclude = 0;
 	wake_up_interruptible(&sdp->o_excl_wait);
 
@@ -1118,8 +1115,7 @@ sg_poll(struct file *filp, poll_table * wait)
 	int count = 0;
 	unsigned long iflags;
 
-	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp))
-	    || sfp->closed)
+	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return POLLERR;
 	poll_wait(filp, &sfp->read_wait, wait);
 	read_lock_irqsave(&sfp->rq_list_lock, iflags);
@@ -2515,9 +2511,9 @@ static void sg_proc_debug_helper(struct seq_file *s, Sg_device * sdp)
 			   fp->reserve.bufflen,
 			   (int) fp->reserve.k_use_sg,
 			   (int) fp->low_dma);
-		seq_printf(s, "   cmd_q=%d f_packid=%d k_orphan=%d closed=%d\n",
+		seq_printf(s, "   cmd_q=%d f_packid=%d k_orphan=%d closed=0\n",
 			   (int) fp->cmd_q, (int) fp->force_packid,
-			   (int) fp->keep_orphan, (int) fp->closed);
+			   (int) fp->keep_orphan);
 		for (m = 0, srp = fp->headrp;
 				srp != NULL;
 				++m, srp = srp->nextrp) {
-- 
1.7.9.1

