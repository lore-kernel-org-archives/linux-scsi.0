From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH] tmscsim: implement change_queue_depth
Date: Wed, 22 Dec 2004 13:15:35 +0100 (CET)
Message-ID: <Pine.LNX.4.60.0412221305140.2636@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.gmx.net ([213.165.64.20]:60851 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261970AbULVMTh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Dec 2004 07:19:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

Hi

Further to my recent doubts wrt change_queue_depth semantics, I decided to 
just implement this function for tmscsim following comments in 
scsi_host.h. If this gets accepted in this form (returning -EIO if depth 
!= sdev->queue_depth after scsi_adjust_depth_queue), I'll submit patches 
to 53c700.c and a comment-modification to scsi_host.h.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

--- a/drivers/scsi/tmscsim.c	Tue Dec 14 23:20:52 2004
+++ b/drivers/scsi/tmscsim.c	Tue Dec 14 22:59:55 2004
@@ -2274,6 +2274,18 @@
 	return 0;
 }
 
+static int dc390_change_queue_depth(struct scsi_device *sdev, int depth)
+{
+	struct dc390_acb *acb = (struct dc390_acb *)sdev->host->hostdata;
+
+	if (depth > acb->TagMaxNum)
+		depth = acb->TagMaxNum;
+
+	scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, depth);
+
+	return depth == sdev->queue_depth ? depth : -EIO;
+}
+
 static struct scsi_host_template driver_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= "tmscsim", 
@@ -2284,6 +2296,7 @@
 	.queuecommand		= DC390_queuecommand,
 	.eh_abort_handler	= DC390_abort,
 	.eh_bus_reset_handler	= DC390_bus_reset,
+	.change_queue_depth	= dc390_change_queue_depth,
 	.can_queue		= 1,
 	.this_id		= 7,
 	.sg_tablesize		= SG_ALL,

Thanks
Guennadi
---
Guennadi Liakhovetski

