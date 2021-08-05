Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABB9FC4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:20:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9061160BD3
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242816AbhHETUn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:20:43 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:52827 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242746AbhHETUl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:20:41 -0400
Received: by mail-pj1-f44.google.com with SMTP id nh14so11326285pjb.2
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:20:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pe/i7NHwGLMp09YGkFixTOKu2VqoRlITK4RnDEIHQlU=;
        b=Ig3MUK93OHGHtMpxVkkU+Qv/h5FIBQfwMX6e15vUnvjzSMr/G9UOm3jaKd043PVlpm
         jCGzBdlQbxHfnamgvBEpPLGBciKy/1UpLUQroypDNRpKLExy84/9fhCLdwqoVh/j8jk/
         i6d1g7Jj1ShxK6IZ4Wli3daeEicSCrFw5gaq32fXTGe3TMLR3nDy+6WA1HhTWKuC06gV
         uFVs334BuKJfeP7OxhXoKcWJr5IQk8z5bgIxvozgDmDjxYaaNMTZ7oCh4P6BKkdOXm3s
         2xyTVTCxec6XHcwPXpqIazbZV1LuYhZso2DU0QzuWOAs8CdE7ym21nSa7buVVMO81z3d
         lGoA==
X-Gm-Message-State: AOAM532mboyNYtpRHBpnAkZgaY6n5yANFg9vPgsvz4oYeTz5x742ruXw
        QZt6DfNSHZZynYYZYmoWjF4=
X-Google-Smtp-Source: ABdhPJxZrlWMJXGY2ekiI/byDVxnEVFzJNNcgV6upTzVMoPqWPMScHGH7HdHKqv4te4d3XAXJZ+lQw==
X-Received: by 2002:a63:a01:: with SMTP id 1mr181428pgk.360.1628191225743;
        Thu, 05 Aug 2021 12:20:25 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:20:25 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 52/52] core: Remove the request member from struct scsi_cmnd
Date:   Thu,  5 Aug 2021 12:18:28 -0700
Message-Id: <20210805191828.3559897-53-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
In-Reply-To: <20210805191828.3559897-1-bvanassche@acm.org>
References: <20210805191828.3559897-1-bvanassche@acm.org>
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
index d85d308a0683..b6c86cce57bf 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2377,7 +2377,6 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 
 	scmd = (struct scsi_cmnd *)(rq + 1);
 	scsi_init_command(dev, scmd);
-	scmd->request = rq;
 	scmd->cmnd = scsi_req(rq)->cmd;
 
 	scmd->scsi_done		= scsi_reset_provider_done_command;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 909a422ec8f4..9ba1aa7530a9 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1540,7 +1540,6 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
 
 	scsi_init_command(sdev, cmd);
 
-	cmd->request = req;
 	cmd->tag = req->tag;
 	cmd->prot_op = SCSI_PROT_NORMAL;
 	if (blk_rq_bytes(req))
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index b9265b15d37a..ddc9671b325b 100644
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
