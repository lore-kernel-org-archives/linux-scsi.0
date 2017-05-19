From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 06/18] scsi: Make scsi_ioctl_reset() pass the request queue pointer to blk_rq_init()
Date: Fri, 19 May 2017 11:30:04 -0700
Message-ID: <20170519183016.12646-7-bart.vanassche@sandisk.com>
References: <20170519183016.12646-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:34979 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755986AbdESSa1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 May 2017 14:30:27 -0400
In-Reply-To: <20170519183016.12646-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>

A later patch will add a call to a request initialization function
into blk_rq_init(). Hence make sure that all blk_rq_init() calls
specify the request queue pointer. Since TMF callback functions in
SCSI LLD drivers do not use request.q, this patch does not change
the behavior of any SCSI driver.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_error.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index ce654e35b060..23d6f225c671 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2286,7 +2286,12 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 			shost->hostt->cmd_size, GFP_KERNEL);
 	if (!rq)
 		goto out_put_autopm_host;
-	blk_rq_init(NULL, rq);
+	/*
+	 * Although blk_rq_init() is intended for single queue block
+	 * drivers, this code path even uses blk_rq_init() when @dev is
+	 * a scsi-mq device.
+	 */
+	blk_rq_init(dev->request_queue, rq);
 
 	scmd = (struct scsi_cmnd *)(rq + 1);
 	scsi_init_command(dev, scmd);
-- 
2.12.2
