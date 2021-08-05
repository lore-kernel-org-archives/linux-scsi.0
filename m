Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E0E4C4320A
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 270F161157
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242935AbhHETT5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:19:57 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:35343 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242914AbhHETTx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:19:53 -0400
Received: by mail-pj1-f46.google.com with SMTP id s22-20020a17090a1c16b0290177caeba067so17377963pjs.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:19:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PBomNPnl7STZls/aW5wCX5ThJyBjrSASUkls2nsP9Q0=;
        b=P+dwoZt2a9921djS9WsmgMR4SR0vWOph1rTbV+ISrTTL7QjJaT+z0k+Oad1zQaXukQ
         iWOESd5N05tzTp6Io1ApM99oFPiqQflSKHcU0hxVsDDRqDC37tjkwCAfBaUeKStsPirf
         +CMxRszN6aInTCzxCoYZxoRYaQard3zS+kVro2BP0okN6oe3kPLJvSqgEnYg4gT2Es+6
         BvFqrGU485BsLXiTT2TdImL78lJJtjj9yJFB5wJqLeipbxzJ4VQuFKFqCEVuPB9hU8lS
         HkRu6qNtDkcW8oyN3jtupVw98Je37ZDlGx68uNveYbCJrPX1/rgAH1H2EFt0W2r5yVJ7
         4bzg==
X-Gm-Message-State: AOAM532HgSjbTQxS539GbNUQbAnRtFaKHpfuJMbfI4gd7/C26Eq9vuNS
        SY0NRicA/8fuKdd3rCm9Kbg=
X-Google-Smtp-Source: ABdhPJztkDoBO2mVpEKQg/zhZ+gX61tBes9+VEaVnPPsX8/ZF4oQyZbGfHjH/nRKvXyoiQft5NQdkQ==
X-Received: by 2002:a17:902:6b02:b029:12c:1278:88 with SMTP id o2-20020a1709026b02b029012c12780088mr5311164plk.64.1628191179258;
        Thu, 05 Aug 2021 12:19:39 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:19:38 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 31/52] mvumi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:18:07 -0700
Message-Id: <20210805191828.3559897-32-bvanassche@acm.org>
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
 drivers/scsi/mvumi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 6bb03d7a254d..4d251bf630a3 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -702,7 +702,7 @@ static int mvumi_host_reset(struct scsi_cmnd *scmd)
 	mhba = (struct mvumi_hba *) scmd->device->host->hostdata;
 
 	scmd_printk(KERN_NOTICE, scmd, "RESET -%u cmd=%x retries=%x\n",
-			scmd->request->tag, scmd->cmnd[0], scmd->retries);
+			scsi_cmd_to_rq(scmd)->tag, scmd->cmnd[0], scmd->retries);
 
 	return mhba->instancet->reset_host(mhba);
 }
