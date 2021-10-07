Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C692C4332F
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:29:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAFBE61130
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:29:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241533AbhJGUbo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:31:44 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:45870 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241436AbhJGUbn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:31:43 -0400
Received: by mail-pj1-f48.google.com with SMTP id ls14-20020a17090b350e00b001a00e2251c8so6078720pjb.4
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:29:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xeOmReZtuzNnl2XVI/E6N4e2ToKJC5QB4CR0jT+r3Hc=;
        b=QVIDTp+amvxv7DUl7WFX7KzYfclaMjsb8Zee7mWVoeEigup55laN0YNBsb48VL0nhf
         wHkbXVIPi4xgBaVrBlEefR4/0cvCoAZ04fMSGSKy3PUOH92ojYGys5UrueLEI1vDlmfR
         vMjVwbdJSZigjIpczleX0o9ubSPWnlyLYWO3g0MXs0cNX5Gi8qppy6dEGhh/lxTO19ZC
         T8z6IlsXwVw0dlELeD8VoS2Ibxwp/uTZ6ySm/mr3vFAGIzZiz+CwFp4BkCtkOY+CTIQJ
         www6nV4P5ciebks6JNpr4aNT3bllYoR90BEAhrjUygLhI4QlLofS4j9yoxY7NC8kcBvb
         WHpg==
X-Gm-Message-State: AOAM530YBgPsTTg7IAWJQTemwjgEBTKr/nq5Z7Uo1fqy++Aoea50pIxn
        KZvEJrzYPb0VzrMfgxKtw2U=
X-Google-Smtp-Source: ABdhPJykkMgUwAyAdxlhs/eaO4i2qkjVZoV4GTKxCKzaU5rxzBGpZoMChSJudvcttab29ujPRmRGuw==
X-Received: by 2002:a17:90b:4a81:: with SMTP id lp1mr7218161pjb.124.1633638589039;
        Thu, 07 Oct 2021 13:29:49 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:29:48 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 10/88] 3w-xxxx: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:05 -0700
Message-Id: <20211007202923.2174984-11-bvanassche@acm.org>
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
