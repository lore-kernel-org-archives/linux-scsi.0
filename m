Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46577C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A7A160F51
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242938AbhIRAH4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:07:56 -0400
Received: from mail-pf1-f172.google.com ([209.85.210.172]:41580 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243654AbhIRAHx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:07:53 -0400
Received: by mail-pf1-f172.google.com with SMTP id x7so10590541pfa.8
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:06:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xeOmReZtuzNnl2XVI/E6N4e2ToKJC5QB4CR0jT+r3Hc=;
        b=DZl344ILG3pnkwnLAr6udqfa7E/G0gQafq3owOsLpgBmDmJfBadCrkF3LNl6w964eu
         1OQogmIIpl03AX/JtqIGgGDCM2cF5SLhsq69OvbdlTxLjpqyzBD18z50Qr8pNNgT31o6
         L+6wd+jQSKFETf3o/HCxBBuyuTcTumggQYZENk/TdcU5uvHsUr2fbCzCVQiKtSRPF7X2
         mGDqFY/aXaXtxcrAY9NyWSOcjYBrJtyAq0nUg4KBVPulU6cOxyd1jE5yEhTpFui6mBw6
         WT4QTGeg9l7o8tas+Ljtw/EWZX9syMx9eXXQFR/zL2zJIjlc8X+N+FW5cxHWyjct5VEx
         22Mg==
X-Gm-Message-State: AOAM532JYL/GnELIvtpbvdEX288PV/OCYrOT9Wqo0lgLdde31y7On3IG
        qe2VfgFbJtW8juT/PrWy2vk=
X-Google-Smtp-Source: ABdhPJyZ9cGgM7E3//ZBC68E4CaZw1tZCkSwIYtHSzA+TyNEazH3BfgzpZQ+dd7brpJO/0SjL2qq7g==
X-Received: by 2002:a62:403:0:b0:433:9582:d449 with SMTP id 3-20020a620403000000b004339582d449mr13108267pfe.15.1631923590065;
        Fri, 17 Sep 2021 17:06:30 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.06.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:06:29 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 11/84] 3w-xxxx: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:04:54 -0700
Message-Id: <20210918000607.450448-12-bvanassche@acm.org>
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
 drivers/scsi/3w-xxxx.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 4ee485ab2714..bdd3ab8875e2 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1160,7 +1160,7 @@ static int tw_setfeature(TW_Device_Extension *tw_dev, int parm, int param_size,
 		tw_dev->state[request_id] = TW_S_COMPLETED;
 		tw_state_request_finish(tw_dev, request_id);
 		tw_dev->srb[request_id]->result = (DID_OK << 16);
-		tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
+		scsi_done(tw_dev->srb[request_id]);
 	}
 	command_packet->byte8.param.sgl[0].address = param_value;
 	command_packet->byte8.param.sgl[0].length = sizeof(TW_Sector);
@@ -1305,7 +1305,7 @@ static int tw_reset_device_extension(TW_Device_Extension *tw_dev)
 			if (srb != NULL) {
 				srb->result = (DID_RESET << 16);
 				scsi_dma_unmap(srb);
-				srb->scsi_done(srb);
+				scsi_done(srb);
 			}
 		}
 	}
@@ -1505,7 +1505,7 @@ static int tw_scsiop_mode_sense(TW_Device_Extension *tw_dev, int request_id)
 		tw_dev->state[request_id] = TW_S_COMPLETED;
 		tw_state_request_finish(tw_dev, request_id);
 		tw_dev->srb[request_id]->result = (DID_OK << 16);
-		tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
+		scsi_done(tw_dev->srb[request_id]);
 		return 0;
 	}
 
@@ -1796,7 +1796,7 @@ static int tw_scsiop_request_sense(TW_Device_Extension *tw_dev, int request_id)
 
 	/* If we got a request_sense, we probably want a reset, return error */
 	tw_dev->srb[request_id]->result = (DID_ERROR << 16);
-	tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
+	scsi_done(tw_dev->srb[request_id]);
 
 	return 0;
 } /* End tw_scsiop_request_sense() */
@@ -1929,9 +1929,6 @@ static int tw_scsi_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_c
 	if (test_bit(TW_IN_RESET, &tw_dev->flags))
 		return SCSI_MLQUEUE_HOST_BUSY;
 
-	/* Save done function into struct scsi_cmnd */
-	SCpnt->scsi_done = done;
-
 	/* Queue the command and get a request id */
 	tw_state_request_start(tw_dev, &request_id);
 
@@ -2165,7 +2162,7 @@ static irqreturn_t tw_interrupt(int irq, void *dev_instance)
 				/* Now complete the io */
 				if ((error != TW_ISR_DONT_COMPLETE)) {
 					scsi_dma_unmap(tw_dev->srb[request_id]);
-					tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
+					scsi_done(tw_dev->srb[request_id]);
 					tw_dev->state[request_id] = TW_S_COMPLETED;
 					tw_state_request_finish(tw_dev, request_id);
 					tw_dev->posted_request_count--;
