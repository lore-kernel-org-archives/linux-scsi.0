Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52A57C4332F
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F13960E9B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242239AbhJGUcT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:32:19 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:52934 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242304AbhJGUcR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:32:17 -0400
Received: by mail-pj1-f52.google.com with SMTP id oa4so5094424pjb.2
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:30:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=df/ZAk1SJ9QNwYW5YEHMi+oUFwgkNLfClQdX/ies+ks=;
        b=6TAgsnyJEV+cSxn7JN00GPkg/hFwfc9HV90K/uCUlc9tqtD+ELSND4jXFfsYhjLAOB
         ghwe+egFLIOLbwGX+T79Uc4ODqtoUrC9CYxHdlYHS9660PZQYZKmWl3SsnP5J4ohqR0f
         klN0kXL+uIcQUN8kpFFBeUZaEVXIoS4A1bQvozdmazjl4YaQnpMhg60c4GosuZOU2Odw
         sPvw+I4ZP3z/BR4lnk0lDiaPkSlvYThtZag2gWCIxSWGJAt18b4C+ifu/welNoKr7F2f
         QYKVeqJhxEnR76oHmSadTflXOfpqY7icxTUKZzsl3dALTe4yGuc/JO1iuy2BfBVWTv7z
         TKSQ==
X-Gm-Message-State: AOAM530ai0mJWN7kSVG32xyWDyt7BoBvJ6bHN38Gob7yhykAU3lJtXF6
        ZfiUArdWvpHyDS3QCTtc7Xs=
X-Google-Smtp-Source: ABdhPJwwqJlaVyOZQi3WiOMpE38s2HbuiZr8IWHeUeYQD+RWwqPIcL29uL8CKxIPdQjns/RKYwZqwA==
X-Received: by 2002:a17:90a:a60e:: with SMTP id c14mr7887470pjq.70.1633638623420;
        Thu, 07 Oct 2021 13:30:23 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.30.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:30:22 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "Matthew R. Ochs" <mrochs@linux.ibm.com>,
        Uma Krishnan <ukrishn@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 27/88] cxlflash: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:22 -0700
Message-Id: <20211007202923.2174984-28-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
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
