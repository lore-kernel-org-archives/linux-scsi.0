Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72B1FC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 567216124D
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346531AbhI2WIQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:08:16 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:47083 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347077AbhI2WIM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:08:12 -0400
Received: by mail-pj1-f45.google.com with SMTP id me3-20020a17090b17c300b0019f44d2e401so1050731pjb.5
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:06:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xeOmReZtuzNnl2XVI/E6N4e2ToKJC5QB4CR0jT+r3Hc=;
        b=QRTsyd/Rmfccsy/j6IjXR2cYjpMh920IWKDEU+CbiDUM3yJqKbhKT1VE2Qa3m9uF49
         OgQCk62pfAQUdWKOxgP1J7Y9SbSUJx71YmCgEgy/Ogd4RBZ+AS8deg5KU5D9Aoh64gRu
         IzyuP08H9axAH1RCab694msVdIBzE3BHNhMJ+Yfkhvg8RqtZqoqehfkw4dpGBLlR7N78
         d8PSALrSKmOBkWlBNsSut4ZBIWO+RnKLVe7uBBzc1bZBlK14b3sjqlDH0bDTLBCAcLSq
         BlxlyH8z89syvF7ib9Q5IlRSQdwK7IeUKaALh0KmMzto9Xt8/zGt3BoiIpObjMch68wX
         Ukiw==
X-Gm-Message-State: AOAM533u+/FnASbTebLo9ZNjCl10D2ny/DeI9uwEPfWqX0Xl9gmnqAOZ
        2sYfp9N7QzVlTpoM6q9ngjg=
X-Google-Smtp-Source: ABdhPJwnHmEZytOcidkOUXTom5R2ENCbzyO7VgtKVmqJG2ijZ8nyn/fDdXaEhKK02NbhH3Tm6SgaJQ==
X-Received: by 2002:a17:90a:b105:: with SMTP id z5mr8804656pjq.64.1632953190869;
        Wed, 29 Sep 2021 15:06:30 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.06.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:06:30 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 10/84] 3w-xxxx: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:04:46 -0700
Message-Id: <20210929220600.3509089-11-bvanassche@acm.org>
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
