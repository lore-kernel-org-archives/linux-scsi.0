Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A442C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3488860F4A
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242535AbhJGUdj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:33:39 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:41915 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242355AbhJGUd1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:33:27 -0400
Received: by mail-pg1-f182.google.com with SMTP id v11so909469pgb.8
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:31:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N3kwkp9RPpQX5SuOt71gSstEbEO312gWBI1qgz1y1kw=;
        b=syInZ952E9KmE353FRJLrwVse21mBV2fnwqmt36iaf3xJHxFuzwS0Np5GI0xphGE+A
         ax/tEMUF7HWgmFU9otdstyWt2zv04I8WIFYBL+RZiPhbjsbPqczv0MoeueDM2IBXthd7
         qH1/7xioQr/3tk+JYX8HG5lEEKFEmKCj7K0nBXuxiyq68tyfQ6hOIagvP5MpkTztnrp3
         p3n+qQeOdsmoFxdCWO7iqk4VAtz548OzfljbN0+GGQ2PERoZEMsktZ8KOYp6w8puCfU4
         eSuKG9Ba8+YidNU1Rc8JK7Mlf1fAFPWe6wYX+5dGY+CkZNXKCgcAg3Y16N8m+RhAv+VZ
         xkZg==
X-Gm-Message-State: AOAM531hg5yuRQ0IbBl4LhRIKGU/OPy+C2aulPJ6TMUGNHH+z6HO7eBd
        fvTE5l99qhcPQBZ9yb0U5JLIJcFIKP4=
X-Google-Smtp-Source: ABdhPJwPt12am1AUAVw5aLDvxkIPny4QTE68sYOO+lsVAuWtHx0kjAmpJp4VSuW+vCReiBAVEjc8lw==
X-Received: by 2002:a05:6a00:2284:b0:43d:fc72:e565 with SMTP id f4-20020a056a00228400b0043dfc72e565mr6402920pfe.84.1633638692796;
        Thu, 07 Oct 2021 13:31:32 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:31:32 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 72/88] stex: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:29:07 -0700
Message-Id: <20211007202923.2174984-73-bvanassche@acm.org>
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
 drivers/scsi/stex.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index f1ba7f5b52a8..2f96a2fdaa40 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -574,7 +574,7 @@ static void return_abnormal_state(struct st_hba *hba, int status)
 		if (ccb->cmd) {
 			scsi_dma_unmap(ccb->cmd);
 			ccb->cmd->result = status << 16;
-			ccb->cmd->scsi_done(ccb->cmd);
+			scsi_done(ccb->cmd);
 			ccb->cmd = NULL;
 		}
 	}
@@ -688,8 +688,6 @@ stex_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 		break;
 	}
 
-	cmd->scsi_done = done;
-
 	tag = scsi_cmd_to_rq(cmd)->tag;
 
 	if (unlikely(tag >= host->can_queue))
@@ -764,7 +762,7 @@ static void stex_scsi_done(struct st_ccb *ccb)
 	}
 
 	cmd->result = result;
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 }
 
 static void stex_copy_data(struct st_ccb *ccb,
