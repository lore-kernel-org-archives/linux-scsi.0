From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 16/31] scsi: Make scsi_ioctl_reset() pass the request queue pointer to blk_rq_init()
Date: Tue, 23 May 2017 17:34:05 -0700
Message-ID: <20170524003420.5381-17-bart.vanassche@sandisk.com>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170524003420.5381-1-bart.vanassche@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

A later patch will add a call to a request initialization function
into blk_rq_init(). Hence make sure that all blk_rq_init() calls
specify the request queue pointer. Since TMF callback functions in
SCSI LLD drivers do not use request.q, this patch does not change
the behavior of any SCSI driver.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_error.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 7ba5f988426c..bbcc269f0ec1 100644
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
