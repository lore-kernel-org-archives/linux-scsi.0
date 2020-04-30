Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B255C8300B
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 093FD2076D
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgD3NUg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 09:20:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:60850 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726926AbgD3NUI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 09:20:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 41DF3AF2C;
        Thu, 30 Apr 2020 13:20:02 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH RFC v3 23/41] scsi: add a 'persistent' argument to scsi_get_reserved_cmd()
Date:   Thu, 30 Apr 2020 15:18:46 +0200
Message-Id: <20200430131904.5847-24-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200430131904.5847-1-hare@suse.de>
References: <20200430131904.5847-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To correctly handle AENs the corresponding command needs to be
marked as 'persistent', so add an additional flag to
scsi_get_reserved_cmd().

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/aacraid/commsup.c    |  2 +-
 drivers/scsi/csiostor/csio_scsi.c |  2 +-
 drivers/scsi/fnic/fnic_scsi.c     |  2 +-
 drivers/scsi/hpsa.c               |  2 +-
 drivers/scsi/scsi_lib.c           | 20 +++++++++++++++-----
 drivers/scsi/virtio_scsi.c        |  4 ++--
 include/scsi/scsi_device.h        |  2 +-
 7 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 8c6da75188a6..dc9b5613b89f 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -244,7 +244,7 @@ struct fib *aac_fib_alloc(struct aac_dev *dev, int direction)
 	unsigned long flags;
 
 	spin_lock_irqsave(&dev->fib_lock, flags);
-	scmd = scsi_get_reserved_cmd(dev->scsi_host_dev, direction);
+	scmd = scsi_get_reserved_cmd(dev->scsi_host_dev, direction, false);
 	if (scmd)
 		fibptr = aac_fib_alloc_tag(dev, scmd);
 	spin_unlock_irqrestore(&dev->fib_lock, flags);
diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 273a8b952e69..69597fd15740 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -2105,7 +2105,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 		goto fail;
 	}
 
-	reset_cmnd = scsi_get_reserved_cmd(sdev, DMA_NONE);
+	reset_cmnd = scsi_get_reserved_cmd(sdev, DMA_NONE, false);
 	if (!reset_cmnd) {
 		csio_err(hw, "No free TMF request\n");
 		goto fail;
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 94d0db99d4ec..454f8c1c9e75 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -2237,7 +2237,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 		goto fnic_device_reset_end;
 	}
 
-	reset_sc = scsi_get_reserved_cmd(sdev, DMA_NONE);
+	reset_sc = scsi_get_reserved_cmd(sdev, DMA_NONE, false);
 	if (unlikely(!reset_sc))
 		goto fnic_device_reset_end;
 
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 6f66cec0e2cc..628752909cd3 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6148,7 +6148,7 @@ static struct CommandList *cmd_alloc(struct ctlr_info *h, u8 direction)
 	int idx;
 
 	scmd = scsi_get_reserved_cmd(h->raid_ctrl_sdev, direction & XFER_WRITE ?
-				     DMA_TO_DEVICE : DMA_FROM_DEVICE);
+				     DMA_TO_DEVICE : DMA_FROM_DEVICE, false);
 	if (!scmd) {
 		dev_warn(&h->pdev->dev, "failed to allocate reserved cmd\n");
 		return NULL;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ce9f1d83aaee..8befa6b63fe5 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1929,17 +1929,27 @@ void scsi_mq_destroy_tags(struct Scsi_Host *shost)
  * scsi_get_reserved_cmd - allocate a SCSI command from reserved tags
  * @sdev: SCSI device from which to allocate the command
  * @data_direction: Data direction for the allocated command
+ * @persistent: Allocate a persistent command
  */
 struct scsi_cmnd *scsi_get_reserved_cmd(struct scsi_device *sdev,
-					int data_direction)
+					int data_direction, bool persistent)
 {
 	struct request *rq;
 	struct scsi_cmnd *scmd;
+	blk_mq_req_flags_t flags = 0;
+	int op = REQ_NOWAIT;
 
-	rq = blk_mq_alloc_request(sdev->request_queue,
-				  data_direction == DMA_TO_DEVICE ?
-				  REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN | REQ_NOWAIT,
-				  BLK_MQ_REQ_RESERVED);
+	if (sdev->host->nr_reserved_cmds) {
+		flags |= BLK_MQ_REQ_RESERVED;
+		if (persistent)
+			flags |= BLK_MQ_REQ_PERSISTENT;
+	}
+	if (data_direction == DMA_TO_DEVICE)
+		op |= REQ_OP_SCSI_OUT;
+	else
+		op |= REQ_OP_SCSI_IN;
+
+	rq = blk_mq_alloc_request(sdev->request_queue, op, flags);
 	if (IS_ERR(rq))
 		return NULL;
 	scmd = blk_mq_rq_to_pdu(rq);
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 26054c29d897..4024588d22e0 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -620,7 +620,7 @@ static int virtscsi_device_reset(struct scsi_cmnd *sc)
 	int rc;
 
 	sdev_printk(KERN_INFO, sdev, "device reset\n");
-	reset_sc = scsi_get_reserved_cmd(sdev, DMA_NONE);
+	reset_sc = scsi_get_reserved_cmd(sdev, DMA_NONE, false);
 	if (!reset_sc)
 		return FAILED;
 	cmd = scsi_cmd_priv(reset_sc);
@@ -684,7 +684,7 @@ static int virtscsi_abort(struct scsi_cmnd *sc)
 	int rc;
 
 	scmd_printk(KERN_INFO, sc, "abort\n");
-	reset_sc = scsi_get_reserved_cmd(sdev, DMA_NONE);
+	reset_sc = scsi_get_reserved_cmd(sdev, DMA_NONE, false);
 	if (!reset_sc)
 		return FAILED;
 	cmd = scsi_cmd_priv(reset_sc);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 6039ce7d09d7..f4112de78045 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -459,7 +459,7 @@ static inline int scsi_execute_req(struct scsi_device *sdev,
 		bufflen, NULL, sshdr, timeout, retries,  0, 0, resid);
 }
 struct scsi_cmnd *scsi_get_reserved_cmd(struct scsi_device *sdev,
-					int data_direction);
+					int data_direction, bool persistent);
 void scsi_put_reserved_cmd(struct scsi_cmnd *scmd);
 extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
-- 
2.16.4

