Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AEC4C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:46:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1242261074
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344873AbhERRr2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:47:28 -0400
Received: from mail-pg1-f175.google.com ([209.85.215.175]:40560 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351352AbhERRrR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:47:17 -0400
Received: by mail-pg1-f175.google.com with SMTP id j12so7533691pgh.7
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G7u7yOIHrMaairO+Op3MCSa1DYBCAhMTLm0X2oUr+iM=;
        b=BW7cvQGwMz6B/KyGkkQ8q0GXm6DCf4md9ZlSwxY3WAwxFEfbvnPOmgHaNxZuUeH54v
         a3RlSR3JsEssHKAFF8Cc4I+8FlFAfs9D35CUgaWfRVDMC/9+PI3RgMxAyZdd3aaLP3Me
         iwqYCpP0OjI0A5TY/Dv91SALiGb9ZaTLOtuUuJo4AV4DWlVeZPeTqSjVgpea6BPQiP64
         f+8l/e+4Lng+6VxZpZkOekyYl6sax2hZGwKnm12yMm+gqTp6/o5Trrdj3hYxUAI8dqxW
         sRsykyQ5BpbUYVz+OtITYRnQ5f/tpGdj/AIY5r8B0HEuAzlaq3tpXIdY6/uiN4P7vwUj
         399Q==
X-Gm-Message-State: AOAM530oa/Lk5v1xbbjyMmwzpKKS38QQZ3SaYiPQJ7EeBEt9TSpGJfTm
        CqhfvkInvv6k/373V9tQTII=
X-Google-Smtp-Source: ABdhPJz4UXJkaM1cjGg8wpTu9eVDPGH0nG5QSNONFCGFCN9+Y18I87oBbACguJaae0uyc9VpYZvw5Q==
X-Received: by 2002:a05:6a00:d4f:b029:2dd:3ce4:9c69 with SMTP id n15-20020a056a000d4fb02902dd3ce49c69mr6236095pfv.65.1621359959254;
        Tue, 18 May 2021 10:45:59 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:58 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 50/50] core: Remove the request member from struct scsi_cmnd
Date:   Tue, 18 May 2021 10:44:50 -0700
Message-Id: <20210518174450.20664-51-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210518174450.20664-1-bvanassche@acm.org>
References: <20210518174450.20664-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since all scsi_cmnd.request users are gone, remove the request pointer
from struct scsi_cmnd.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_error.c | 1 -
 drivers/scsi/scsi_lib.c   | 1 -
 include/scsi/scsi_cmnd.h  | 3 ---
 3 files changed, 5 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 5af6d87e83aa..3c83e892284b 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2390,7 +2390,6 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 
 	scmd = (struct scsi_cmnd *)(rq + 1);
 	scsi_init_command(dev, scmd);
-	scmd->request = rq;
 	scmd->cmnd = scsi_req(rq)->cmd;
 
 	scmd->scsi_done		= scsi_reset_provider_done_command;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 2e9598c91cee..b5df3f94156e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1536,7 +1536,6 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
 
 	scsi_init_command(sdev, cmd);
 
-	cmd->request = req;
 	cmd->tag = req->tag;
 	cmd->prot_op = SCSI_PROT_NORMAL;
 	if (blk_rq_bytes(req))
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index bd7f73f035be..984bfa5deab8 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -111,9 +111,6 @@ struct scsi_cmnd {
 				   reconnects.   Probably == sector
 				   size */
 
-	struct request *request;	/* The command we are
-				   	   working on */
-
 	unsigned char *sense_buffer;
 				/* obtained by REQUEST SENSE when
 				 * CHECK CONDITION is received on original
