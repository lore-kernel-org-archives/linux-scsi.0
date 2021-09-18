Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CE8CC433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA64E60F48
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344207AbhIRAI3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:08:29 -0400
Received: from mail-pl1-f182.google.com ([209.85.214.182]:39425 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344048AbhIRAI0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:08:26 -0400
Received: by mail-pl1-f182.google.com with SMTP id c4so7223328pls.6
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:07:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=df/ZAk1SJ9QNwYW5YEHMi+oUFwgkNLfClQdX/ies+ks=;
        b=HmvR6d9kkn+XqCh7q7okfrzkhqz0OkgIIuU0RowwGsl4l7jVl+FEVIor8v0RBW5GfW
         /ombJMAobAm1cyZGTkskqQLPrs0oAV1NtgxLRztV3tMNzA3k9A92mOibd3/bPV0G/HgD
         qffDCQrXHlsagPEeaHl1J6V+eeABpL/Gdxx6OuNfG8Y+GjcbqkQw8DihyWdKFhQrhFaw
         t7qcGMpPKG3q2K1/upV3VieFm3b39yHeKjyV3W3Z3c+I4RpNVrxZrBOtQ3IObhiaoteH
         QC44yU3rNdQX5GASz7VrM3SqKBSveQibC1qKNeTf3/ipIsGu1P3DCb9Wnn++c+azcua1
         YCfQ==
X-Gm-Message-State: AOAM530kUiibIcbY8K2m8Ou8lTXWKZbfyAKsuVGLCEjg+ltuiY1HF9Et
        xPjl08bfHz7q6e9cplI9p+E=
X-Google-Smtp-Source: ABdhPJx3hCtaAwPHSnHHrL1Veae+c/PU9ZceaILyZBZqnHS5IJ410aLU4ySMXY6512jy5OtVoijU8w==
X-Received: by 2002:a17:90b:46cd:: with SMTP id jx13mr15291470pjb.122.1631923623862;
        Fri, 17 Sep 2021 17:07:03 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:07:03 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "Matthew R. Ochs" <mrochs@linux.ibm.com>,
        Uma Krishnan <ukrishn@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 28/84] cxlflash: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:11 -0700
Message-Id: <20210918000607.450448-29-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210918000607.450448-1-bvanassche@acm.org>
References: <20210918000607.450448-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/cxlflash/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index b2730e859df8..2943cdd83614 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -171,7 +171,7 @@ static void cmd_complete(struct afu_cmd *cmd)
 
 		dev_dbg_ratelimited(dev, "%s:scp=%p result=%08x ioasc=%08x\n",
 				    __func__, scp, scp->result, cmd->sa.ioasc);
-		scp->scsi_done(scp);
+		scsi_done(scp);
 	} else if (cmd->cmd_tmf) {
 		spin_lock_irqsave(&cfg->tmf_slock, lock_flags);
 		cfg->tmf_active = false;
@@ -205,7 +205,7 @@ static void flush_pending_cmds(struct hwq *hwq)
 		if (cmd->scp) {
 			scp = cmd->scp;
 			scp->result = (DID_IMM_RETRY << 16);
-			scp->scsi_done(scp);
+			scsi_done(scp);
 		} else {
 			cmd->cmd_aborted = true;
 
@@ -601,7 +601,7 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 	case STATE_FAILTERM:
 		dev_dbg_ratelimited(dev, "%s: device has failed\n", __func__);
 		scp->result = (DID_NO_CONNECT << 16);
-		scp->scsi_done(scp);
+		scsi_done(scp);
 		rc = 0;
 		goto out;
 	default:
