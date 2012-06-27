From: Cong Meng <mc@linux.vnet.ibm.com>
Subject: [PATCH] SCSI: Fix BLKSECTGET ioctl of sg device caculation mistake.
Date: Wed, 27 Jun 2012 15:29:19 +0800
Message-ID: <1340782159-1587-1-git-send-email-mc@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:55354 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab2F0HbZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jun 2012 03:31:25 -0400
Received: from /spool/local
	by e06smtp10.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mc@linux.vnet.ibm.com>;
	Wed, 27 Jun 2012 08:31:23 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: stefanha@linux.vnet.ibm.com, linuxram@us.ibm.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Cong Meng <mc@linux.vnet.ibm.com>

Fix BLKSECTGET ioctl of sg device caculation mistake.

Signed-off-by: Cong Meng <mc@linux.vnet.ibm.com>
---
 drivers/scsi/sg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index eacd46b..c424602 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1070,7 +1070,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 			return -ENODEV;
 		return scsi_ioctl(sdp->device, cmd_in, p);
 	case BLKSECTGET:
-		return put_user(queue_max_sectors(sdp->device->request_queue) * 512,
+		return put_user(queue_max_sectors(sdp->device->request_queue),
 				ip);
 	case BLKTRACESETUP:
 		return blk_trace_setup(sdp->device->request_queue,
-- 
1.7.7.6

