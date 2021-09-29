Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AE4AC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 624C26140F
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347077AbhI2WIq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:08:46 -0400
Received: from mail-pf1-f179.google.com ([209.85.210.179]:41896 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347104AbhI2WIo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:08:44 -0400
Received: by mail-pf1-f179.google.com with SMTP id k17so3150079pff.8
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:07:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=df/ZAk1SJ9QNwYW5YEHMi+oUFwgkNLfClQdX/ies+ks=;
        b=CQm4yojiiQB9+NUG8l4UlIOWvv4R/JcmAEDESxggNQW07rRVhXTk5jvLDnPu50wxvo
         bCqwdGt1X66f27ZKcIq7CnpbvsjM3HnCO8lM7Shrbri5HKhBynwirjTpsyc3Yg8Uzh6h
         /Ny7Mny+QxvOPgAxRELRx9/DW6H2YKgMnGZZow8lOD0Tn/9dbQGaTWxIfRl2jQaAAG4w
         KBL8M2+O4QzI3sSatealO6RtcrM2pgdO5jMLChG3C/sbifaPQQfM4ANHBs3OMMb1RUZZ
         Xk0Wbi0B1HIeJWYU68ebLo9v7X8d916DLmXj6sHzvjJoC2pN6ueYG1DU2M3ura7+oXLR
         j4pQ==
X-Gm-Message-State: AOAM5308+6lRO/n5h08qyUw3SbDvhKvv/0KgdsVh9r+OLnaxRz0+r+Dj
        tiYk9tfnvrgRvBfsGodlKzg=
X-Google-Smtp-Source: ABdhPJxX03t9bdAoJOunr/tiCe4MMNMCd6q31na3m0c5gmRf2+WTNjgAQ5+cOX7TtXO2RNa3K4py8Q==
X-Received: by 2002:a63:1f5b:: with SMTP id q27mr1918462pgm.214.1632953222420;
        Wed, 29 Sep 2021 15:07:02 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:01 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "Manoj N. Kumar" <manoj@linux.ibm.com>,
        "Matthew R. Ochs" <mrochs@linux.ibm.com>,
        Uma Krishnan <ukrishn@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 27/84] cxlflash: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:03 -0700
Message-Id: <20210929220600.3509089-28-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
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
