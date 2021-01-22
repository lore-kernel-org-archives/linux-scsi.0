Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43625C433E9
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 02:36:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0976F23899
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 02:36:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbhAVCgE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Jan 2021 21:36:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44454 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726736AbhAVCgC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Jan 2021 21:36:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611282875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KkYBbKplqfo7oIrfyFhsPXiLEOrJSYaa7anlc/YinxY=;
        b=RaawY483IFzHEJ5IwliJ4B/wmSKKORfxds+pE63xqfA74DuVMktQL03TmuOE82uAe8zB07
        mD6EM5t2L0QHAFz+oBZzcaTc4/owymxDxg/g9dvlS5+dmNE65wcuEuIwkE32mp0clI5XqT
        rz0tAUagkTVb3KrGbcmZPI8+AcJloNA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-sF8TYCImPcixUYxCkE9pXw-1; Thu, 21 Jan 2021 21:34:31 -0500
X-MC-Unique: sF8TYCImPcixUYxCkE9pXw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C51CFAFA80;
        Fri, 22 Jan 2021 02:34:29 +0000 (UTC)
Received: from localhost (ovpn-13-11.pek2.redhat.com [10.72.13.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E9EB35F9D7;
        Fri, 22 Jan 2021 02:34:25 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH V7 07/13] blk-mq: add callbacks for storing & retrieving budget token
Date:   Fri, 22 Jan 2021 10:33:11 +0800
Message-Id: <20210122023317.687987-8-ming.lei@redhat.com>
In-Reply-To: <20210122023317.687987-1-ming.lei@redhat.com>
References: <20210122023317.687987-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SCSI is the only driver which requires dispatch budget, and it isn't
fair to add one field into 'struct request' for storing budget token
which will be used in the following patches for improving scsi's device
busy scalability.

Cc: Omar Sandoval <osandov@fb.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi_lib.c  | 18 ++++++++++++++++++
 include/linux/blk-mq.h   |  9 +++++++++
 include/scsi/scsi_cmnd.h |  2 ++
 3 files changed, 29 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b3f14f05340a..eeaae47fee8a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1641,6 +1641,20 @@ static bool scsi_mq_get_budget(struct request_queue *q)
 	return false;
 }
 
+static void scsi_mq_set_rq_budget_token(struct request *req, int token)
+{
+	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
+
+	cmd->budget_token = token;
+}
+
+static int scsi_mq_get_rq_budget_token(struct request *req)
+{
+	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
+
+	return cmd->budget_token;
+}
+
 static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 			 const struct blk_mq_queue_data *bd)
 {
@@ -1855,6 +1869,8 @@ static const struct blk_mq_ops scsi_mq_ops_no_commit = {
 	.cleanup_rq	= scsi_cleanup_rq,
 	.busy		= scsi_mq_lld_busy,
 	.map_queues	= scsi_map_queues,
+	.set_rq_budget_token = scsi_mq_set_rq_budget_token,
+	.get_rq_budget_token = scsi_mq_get_rq_budget_token,
 };
 
 
@@ -1883,6 +1899,8 @@ static const struct blk_mq_ops scsi_mq_ops = {
 	.cleanup_rq	= scsi_cleanup_rq,
 	.busy		= scsi_mq_lld_busy,
 	.map_queues	= scsi_map_queues,
+	.set_rq_budget_token = scsi_mq_set_rq_budget_token,
+	.get_rq_budget_token = scsi_mq_get_rq_budget_token,
 };
 
 struct request_queue *scsi_mq_alloc_queue(struct scsi_device *sdev)
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index d705b174d346..1f84d47b72f6 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -317,6 +317,15 @@ struct blk_mq_ops {
 	 */
 	void (*put_budget)(struct request_queue *);
 
+	/*
+	 * @set_rq_budget_toekn: store rq's budget token
+	 */
+	void (*set_rq_budget_token)(struct request *, int);
+	/*
+	 * @get_rq_budget_toekn: retrieve rq's budget token
+	 */
+	int (*get_rq_budget_token)(struct request *);
+
 	/**
 	 * @timeout: Called on request timeout.
 	 */
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 69ade4fb71aa..4884f300c896 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -75,6 +75,8 @@ struct scsi_cmnd {
 
 	int eh_eflags;		/* Used by error handlr */
 
+	int budget_token;
+
 	/*
 	 * This is set to jiffies as it was when the command was first
 	 * allocated.  It is used to time how long the command has
-- 
2.28.0

