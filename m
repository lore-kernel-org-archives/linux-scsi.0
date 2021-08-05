Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D54C4320A
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1AEE60BD3
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242938AbhHETUM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:20:12 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:44965 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242592AbhHETUH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:20:07 -0400
Received: by mail-pj1-f45.google.com with SMTP id e2-20020a17090a4a02b029016f3020d867so11976172pjh.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:19:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nOVo62aD3xBlvWPJJ5wlCyfpxi8Hex+qVuCS0WhbLxU=;
        b=Qd5AKWRZWKP29o5oRB0CWROb2VRoCXbkjH7cZbxcGlC38eN4Hgh5YSdRnzF12DNFsb
         ruHl+aFrfETDRzssRPIMAn2mJBIkvd6UzLhqgZBPvgoKGQ3Zjh/NC2CgL1Ehpvvc+ljE
         ziJxxM6jwYFUgEw6b1tmF4SP7Z98xb7mb+DLPIlfBncsPYQabyCP9Jo97Jgg/nU6RKrV
         Ich8W8oj4mZa/y1sa+e0RpaNIP3jBrfPnTHQ2cMXbKDocl6d7/I4/kQP17dzVDUgf77B
         JnHiAG5EAF3wLcYFUIjJ0or4eBqgKnWIRTHEKeGOe7yJGfmY2isbCMqS9RIPOkxE+7uo
         fNFg==
X-Gm-Message-State: AOAM530yDSWzo7MhZ/0GO2mzgyk3n0hdH3Ay4YggJ6Ju/HDZJeBdRfBe
        b4GV3nd+RuXcil6rZVgN900=
X-Google-Smtp-Source: ABdhPJxNamVfGAj1D8g3yOwGJdmL0n3jymx3072iSS50QAFfm8jhkh+xpgW0YoriUad0jYCeaOzHuw==
X-Received: by 2002:a63:5619:: with SMTP id k25mr671656pgb.92.1628191193000;
        Thu, 05 Aug 2021 12:19:53 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.19.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:19:52 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 40/52] qlogicpti: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:18:16 -0700
Message-Id: <20210805191828.3559897-41-bvanassche@acm.org>
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
 drivers/scsi/qlogicpti.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index d84e218d32cb..8e7e833a36cc 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -890,7 +890,7 @@ static inline void cmd_frob(struct Command_Entry *cmd, struct scsi_cmnd *Cmnd,
 		cmd->control_flags |= CFLAG_WRITE;
 	else
 		cmd->control_flags |= CFLAG_READ;
-	cmd->time_out = Cmnd->request->timeout/HZ;
+	cmd->time_out = scsi_cmd_to_rq(Cmnd)->timeout / HZ;
 	memcpy(cmd->cdb, Cmnd->cmnd, Cmnd->cmd_len);
 }
 
