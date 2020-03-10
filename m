Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04435C18E5B
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:31:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA877222C3
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:31:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbgCJQbm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 12:31:42 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:35778 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727092AbgCJQap (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Mar 2020 12:30:45 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 00CF6BD5A10424B2E4AA;
        Wed, 11 Mar 2020 00:30:34 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Wed, 11 Mar 2020 00:30:25 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <hare@suse.de>,
        <ming.lei@redhat.com>, <bvanassche@acm.org>, <hch@infradead.org>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH RFC v2 04/24] scsi: Add scsi_{get, put}_reserved_cmd()
Date:   Wed, 11 Mar 2020 00:25:30 +0800
Message-ID: <1583857550-12049-5-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1583857550-12049-1-git-send-email-john.garry@huawei.com>
References: <1583857550-12049-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.com>

Implement a function to allocate a SCSI command from the reserved
tag pool using the host-wide reserved command queue.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_lib.c  | 30 ++++++++++++++++++++++++++++++
 include/scsi/scsi_cmnd.h |  3 +++
 2 files changed, 33 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e809b0e30a11..af4f56cd0093 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1927,6 +1927,36 @@ void scsi_mq_destroy_tags(struct Scsi_Host *shost)
 	blk_mq_free_tag_set(&shost->tag_set);
 }
 
+struct scsi_cmnd *scsi_get_reserved_cmd(struct Scsi_Host *shost)
+{
+	struct scsi_cmnd *scmd;
+	struct request *rq;
+
+	if (WARN_ON(!shost->reserved_cmd_q))
+		return NULL;
+
+	rq = blk_mq_alloc_request(shost->reserved_cmd_q,
+				  REQ_OP_DRV_OUT | REQ_NOWAIT,
+				  BLK_MQ_REQ_RESERVED);
+	if (IS_ERR(rq))
+		return NULL;
+	WARN_ON(rq->tag == -1);
+	scmd = blk_mq_rq_to_pdu(rq);
+	scmd->request = rq;
+
+	return scmd;
+}
+EXPORT_SYMBOL_GPL(scsi_get_reserved_cmd);
+
+void scsi_put_reserved_cmd(struct scsi_cmnd *scmd)
+{
+	struct request *rq = blk_mq_rq_from_pdu(scmd);
+
+	if (blk_mq_rq_is_reserved(rq))
+		blk_mq_free_request(rq);
+}
+EXPORT_SYMBOL_GPL(scsi_put_reserved_cmd);
+
 /**
  * scsi_device_from_queue - return sdev associated with a request_queue
  * @q: The request queue to return the sdev from
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index a2849bb9cd19..82a4499539b3 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -159,6 +159,9 @@ static inline struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
 	return *(struct scsi_driver **)cmd->request->rq_disk->private_data;
 }
 
+struct scsi_cmnd *scsi_get_reserved_cmd(struct Scsi_Host *shost);
+void scsi_put_reserved_cmd(struct scsi_cmnd *);
+
 extern void scsi_put_command(struct scsi_cmnd *);
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
 
-- 
2.17.1

