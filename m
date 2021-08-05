Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CAB7C4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3549260BD3
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242863AbhHETT0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:19:26 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:35691 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242910AbhHETTU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:19:20 -0400
Received: by mail-pj1-f41.google.com with SMTP id s22-20020a17090a1c16b0290177caeba067so17373334pjs.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:18:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eKg6z51wFV7biatzkNM4Hts6TkZNBCWvFreLQRIkp/I=;
        b=cXj1MWbKXH4MxvwhQ80K4O++lFYOQfgAq3+GRrpSepDAW5kkcuXqFjyMOmdCZEfNLZ
         A+mB6sNw1AcY/jpQx0HHL/x85snK3F/qxVLfKCYpZlzC/UE2At7fPr6wPufDU07x1Wm5
         5zvbiktdMiV90FQqmz+HE2UnfHuGHIiFlheKLLNv/7fzajXpuap3xRJhV62fWQ2j9Ced
         bvnp5ekdKvnTmGlNwWHSihFj9acfVe+5HzEKc729rgsKCWYCs7dAIAfpFuEZIKH3+DKB
         1okxT1vr0vReRuKRByT743WZLuiJrP0Nx8wnkQxaGwbkYPoDpjy6vTujnPaZaNMdVf7p
         29Pw==
X-Gm-Message-State: AOAM530HrDR1kQ7sdee1PMT6RDh/IEyPuJHHCPR8+lKVMUBxhGCaSB7d
        cbntBCoSJhudKAeAgwA6eRw=
X-Google-Smtp-Source: ABdhPJxIsVpLPw47WBMpwMTgq84/yHgAIcoOCU4lKIYCjpcVMS7JQnKqKsfW0zmylaVKq3VOmTkJUg==
X-Received: by 2002:a17:90b:3d8:: with SMTP id go24mr16880616pjb.235.1628191139503;
        Thu, 05 Aug 2021 12:18:59 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:18:58 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 13/52] aacraid: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:17:49 -0700
Message-Id: <20210805191828.3559897-14-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
In-Reply-To: <20210805191828.3559897-1-bvanassche@acm.org>
References: <20210805191828.3559897-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/aacraid/aachba.c  | 2 +-
 drivers/scsi/aacraid/commsup.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 267934d2f14b..c2d6f0a9e0b1 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1504,7 +1504,7 @@ static struct aac_srb * aac_scsi_common(struct fib * fib, struct scsi_cmnd * cmd
 	srbcmd->id       = cpu_to_le32(scmd_id(cmd));
 	srbcmd->lun      = cpu_to_le32(cmd->device->lun);
 	srbcmd->flags    = cpu_to_le32(flag);
-	timeout = cmd->request->timeout/HZ;
+	timeout = scsi_cmd_to_rq(cmd)->timeout / HZ;
 	if (timeout == 0)
 		timeout = (dev->sa_firmware ? AAC_SA_TIMEOUT : AAC_ARC_TIMEOUT);
 	srbcmd->timeout  = cpu_to_le32(timeout);  // timeout in seconds
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 54eb4d41bc2c..deb32c9f4b3e 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -224,7 +224,7 @@ struct fib *aac_fib_alloc_tag(struct aac_dev *dev, struct scsi_cmnd *scmd)
 {
 	struct fib *fibptr;
 
-	fibptr = &dev->fibs[scmd->request->tag];
+	fibptr = &dev->fibs[scsi_cmd_to_rq(scmd)->tag];
 	/*
 	 *	Null out fields that depend on being zero at the start of
 	 *	each I/O
