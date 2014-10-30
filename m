From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/6] scsi: return EAGAIN when resetting a device under EH
Date: Thu, 30 Oct 2014 10:27:09 +0100
Message-ID: <1414661229-15199-7-git-send-email-hch@lst.de>
References: <1414661229-15199-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:50953 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758503AbaJ3J1B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2014 05:27:01 -0400
In-Reply-To: <1414661229-15199-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Douglas Gilbert <dgilbert@interlog.com>, Robert Elliott <Elliott@hp.com>

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 712f159..c4f7b56 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -278,7 +278,7 @@ int scsi_ioctl_block_when_processing_errors(struct scsi_device *sdev, int cmd,
 {
 	if (cmd == SG_SCSI_RESET && ndelay) {
 		if (scsi_host_in_recovery(sdev->host))
-			return -ENODEV;
+			return -EAGAIN;
 	} else {
 		if (!scsi_block_when_processing_errors(sdev))
 			return -ENODEV;
-- 
1.9.1

