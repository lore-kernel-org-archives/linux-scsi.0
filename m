Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72569C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Nov 2021 15:13:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355965AbhKYPQO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Nov 2021 10:16:14 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:47054 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344236AbhKYPOO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Nov 2021 10:14:14 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 0FE051FD37;
        Thu, 25 Nov 2021 15:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637853062; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pky+DWOH7WZ6MkRRYN3MwgJeBBcpWYNHc6dTY2N9m3M=;
        b=r6PK1ey/y1sZdcOURyjkZ1ll2xmhgQ5x8p0cWNwNah/lGSngN5DB9g8SKEp71aFZf58TrQ
        kXXOYc1jUdVQTHIr9OxzFnkgjJJNyitwYTGWczGY3M6hDhDTa2jIhGBAULIiwA46VRp+Ft
        3P03pjJYBUcLIiFYMgqyZ5J14q2ZTI8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637853062;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pky+DWOH7WZ6MkRRYN3MwgJeBBcpWYNHc6dTY2N9m3M=;
        b=yIu44yPQg1y95KqFT9iE0apOsca6Nrq2bYkxcWZAYZeu+uPGI7HgZqOxaQAGc6+mYOs0eZ
        QXFi0wiizAgGebBA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id A81FDA3B88;
        Thu, 25 Nov 2021 15:11:01 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 965ED51919F0; Thu, 25 Nov 2021 16:11:01 +0100 (CET)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Bart van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/15] scsi: add scsi_{get,put}_internal_cmd() helper
Date:   Thu, 25 Nov 2021 16:10:35 +0100
Message-Id: <20211125151048.103910-3-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211125151048.103910-1-hare@suse.de>
References: <20211125151048.103910-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add helper functions to allow LLDDs to allocate and free
internal commands.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_lib.c    | 44 ++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h |  3 +++
 2 files changed, 47 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 621d841d819a..6fbd36c9c416 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1957,6 +1957,50 @@ void scsi_mq_destroy_tags(struct Scsi_Host *shost)
 	blk_mq_free_tag_set(&shost->tag_set);
 }
 
+/**
+ * scsi_get_internal_cmd - allocate an internal SCSI command
+ * @sdev: SCSI device from which to allocate the command
+ * @data_direction: Data direction for the allocated command
+ * @nowait: do not wait for command allocation to succeed.
+ *
+ * Allocates a SCSI command for internal LLDD use.
+ */
+struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
+	int data_direction, bool nowait)
+{
+	struct request *rq;
+	struct scsi_cmnd *scmd;
+	blk_mq_req_flags_t flags = 0;
+	int op;
+
+	if (nowait)
+		flags |= BLK_MQ_REQ_NOWAIT;
+	op = (data_direction == DMA_TO_DEVICE) ?
+		REQ_OP_DRV_OUT : REQ_OP_DRV_IN;
+	rq = blk_mq_alloc_request(sdev->request_queue, op, flags);
+	if (IS_ERR(rq))
+		return NULL;
+	scmd = blk_mq_rq_to_pdu(rq);
+	scmd->device = sdev;
+	return scmd;
+}
+EXPORT_SYMBOL_GPL(scsi_get_internal_cmd);
+
+/**
+ * scsi_put_internal_cmd - free an internal SCSI command
+ * @scmd: SCSI command to be freed
+ *
+ * Check if @scmd is an internal command, and call
+ * blk_mq_free_request() if true.
+ */
+void scsi_put_internal_cmd(struct scsi_cmnd *scmd)
+{
+	struct request *rq = blk_mq_rq_from_pdu(scmd);
+
+	blk_mq_free_request(rq);
+}
+EXPORT_SYMBOL_GPL(scsi_put_internal_cmd);
+
 /**
  * scsi_device_from_queue - return sdev associated with a request_queue
  * @q: The request queue to return the sdev from
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 5d7204186831..218b541515bf 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -470,6 +470,9 @@ static inline int scsi_execute_req(struct scsi_device *sdev,
 	return scsi_execute(sdev, cmd, data_direction, buffer,
 		bufflen, NULL, sshdr, timeout, retries,  0, 0, resid);
 }
+struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
+	int data_direction, bool nowait);
+void scsi_put_internal_cmd(struct scsi_cmnd *scmd);
 extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
 extern int scsi_vpd_lun_id(struct scsi_device *, char *, size_t);
-- 
2.29.2

