From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 01/17] scsi: handle command allocation failure in scsi_reset_provider
Date: Wed, 05 Feb 2014 04:39:31 -0800
Message-ID: <20140205124018.988173562@bombadil.infradead.org>
References: <20140205123930.150608699@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53185 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaBEMkY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2014 07:40:24 -0500
Content-Disposition: inline; filename=0001-scsi-handle-command-allocation-failure-in-scsi_reset.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_error.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 78b004d..f8b54c1 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2289,6 +2289,11 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 		return FAILED;
 
 	scmd = scsi_get_command(dev, GFP_KERNEL);
+	if (!scmd) {
+		rtn = FAILED;
+		goto out_put_autopm_host;
+	}
+
 	blk_rq_init(NULL, &req);
 	scmd->request = &req;
 
@@ -2345,6 +2350,7 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 	scsi_run_host_queues(shost);
 
 	scsi_next_command(scmd);
+out_put_autopm_host:
 	scsi_autopm_put_host(shost);
 	return rtn;
 }
-- 
1.7.10.4


