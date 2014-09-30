From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] sg: fix sparse __user annotation warning
Date: Tue, 30 Sep 2014 17:20:04 +0200
Message-ID: <1412090405-24436-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:45021 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbaI3PRl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2014 11:17:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Douglas Gilbert <dgilbert@interlog.com>

blk_trace_setup takes a __user pointer, so use the local void __user *
pointer instead of casting the argument to char * for it in the sg
ioctl handler.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 01cf888..b94435b 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1138,7 +1138,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 				       sdp->disk->disk_name,
 				       MKDEV(SCSI_GENERIC_MAJOR, sdp->index),
 				       NULL,
-				       (char *)arg);
+				       p);
 	case BLKTRACESTART:
 		return blk_trace_startstop(sdp->device->request_queue, 1);
 	case BLKTRACESTOP:
-- 
1.9.1

