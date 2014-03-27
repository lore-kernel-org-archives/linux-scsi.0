From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/4] scsi: handle command allocation failure in scsi_reset_provider
Date: Thu, 27 Mar 2014 17:14:22 +0100
Message-ID: <1395936862-6938-5-git-send-email-hch@lst.de>
References: <1395936862-6938-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:45783 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756879AbaC0Qar (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Mar 2014 12:30:47 -0400
In-Reply-To: <1395936862-6938-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_error.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 771c16b..b989d31 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2294,6 +2294,12 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 	}
 
 	scmd = scsi_get_command(dev, GFP_KERNEL);
+	if (!scmd) {
+		rtn = FAILED;
+		put_device(&dev->sdev_gendev);
+		goto out_put_autopm_host;
+	}
+
 	blk_rq_init(NULL, &req);
 	scmd->request = &req;
 
-- 
1.7.10.4

