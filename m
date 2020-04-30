Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41D5BC8300C
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B04E2076D
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgD3NUE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 09:20:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:60578 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726743AbgD3NUE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 09:20:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BAD9AAF01;
        Thu, 30 Apr 2020 13:20:01 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH RFC v3 02/41] scsi: add scsi_{get,put}_reserved_cmd()
Date:   Thu, 30 Apr 2020 15:18:25 +0200
Message-Id: <20200430131904.5847-3-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200430131904.5847-1-hare@suse.de>
References: <20200430131904.5847-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add helper functions to retrieve SCSI commands from the reserved
tag pool.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_lib.c    | 35 +++++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h |  3 +++
 2 files changed, 38 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5358f553f526..d0972744ea7f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1901,6 +1901,41 @@ void scsi_mq_destroy_tags(struct Scsi_Host *shost)
 	blk_mq_free_tag_set(&shost->tag_set);
 }
 
+/**
+ * scsi_get_reserved_cmd - allocate a SCSI command from reserved tags
+ * @sdev: SCSI device from which to allocate the command
+ * @data_direction: Data direction for the allocated command
+ */
+struct scsi_cmnd *scsi_get_reserved_cmd(struct scsi_device *sdev,
+					int data_direction)
+{
+	struct request *rq;
+	struct scsi_cmnd *scmd;
+
+	rq = blk_mq_alloc_request(sdev->request_queue,
+				  data_direction == DMA_TO_DEVICE ?
+				  REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN | REQ_NOWAIT,
+				  BLK_MQ_REQ_RESERVED);
+	if (IS_ERR(rq))
+		return NULL;
+	scmd = blk_mq_rq_to_pdu(rq);
+	scmd->request = rq;
+	return scmd;
+}
+EXPORT_SYMBOL_GPL(scsi_get_reserved_cmd);
+
+/**
+ * scsi_put_reserved_cmd - free a SCSI command allocated from reserved tags
+ * @scmd: SCSI command to be freed
+ */
+void scsi_put_reserved_cmd(struct scsi_cmnd *scmd)
+{
+	struct request *rq = blk_mq_rq_from_pdu(scmd);
+
+	blk_mq_free_request(rq);
+}
+EXPORT_SYMBOL_GPL(scsi_put_reserved_cmd);
+
 /**
  * scsi_device_from_queue - return sdev associated with a request_queue
  * @q: The request queue to return the sdev from
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index c3cba2aaf934..e74c7e671aa0 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -457,6 +457,9 @@ static inline int scsi_execute_req(struct scsi_device *sdev,
 	return scsi_execute(sdev, cmd, data_direction, buffer,
 		bufflen, NULL, sshdr, timeout, retries,  0, 0, resid);
 }
+struct scsi_cmnd *scsi_get_reserved_cmd(struct scsi_device *sdev,
+					int data_direction);
+void scsi_put_reserved_cmd(struct scsi_cmnd *scmd);
 extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
 extern int scsi_vpd_lun_id(struct scsi_device *, char *, size_t);
-- 
2.16.4

