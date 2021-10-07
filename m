Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F11DDC433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:29:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB1B360E9B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:29:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241398AbhJGUbl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:31:41 -0400
Received: from mail-pf1-f170.google.com ([209.85.210.170]:46707 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbhJGUbk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:31:40 -0400
Received: by mail-pf1-f170.google.com with SMTP id u7so6272334pfg.13
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:29:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eIOMgr4RgNn4c34AWPObS5b7BbWiXFclO6pTLpBw3g0=;
        b=a8Erv82+c1v23aKt4a2pBXLDDyRhmJjXyAWLIrTS8iSxaflTqU4Rp2/cZYZIy8FnEX
         7UQ4LzDUm1QmiggMvLv4xzKtR6P/utQe1Vq9YSofS8vmsG2MbY2ASDumODafqj/b+/L1
         UbyCrkJGuiX67+74HLyBI9RVaPVRX7FVYPNUm53c5Yycsi6c63aBd4fiZt4Esjn0WDMy
         6IVQM0Qu5nY9/q93jD5lAJd+bG6uJBz3LlQAgAPk8WQsjZyjdjpvAFMyb6PvuruezHpA
         zgpfPGrcvqiQbdWx28jUgApJm8/8AWGC6Kkr8gADPpyWiMBaawgduoXS9XFzR1mAa6Hv
         vrSg==
X-Gm-Message-State: AOAM530u8vzrvgqT5CKo0pt8ezbBCPKmRkIkrKJFPpHDv+Ym1mwWLvZP
        FSWaNASW3wH/B3pWaJn7i/c=
X-Google-Smtp-Source: ABdhPJyYf6lJfMotEdNOY0ilvHgXRtSBKl8ptcCm5n31C/lVZTWQipugg3PDDytaRdkfJ0GqSYLDUA==
X-Received: by 2002:aa7:8882:0:b0:44c:9270:1cba with SMTP id z2-20020aa78882000000b0044c92701cbamr6143733pfe.26.1633638586346;
        Thu, 07 Oct 2021 13:29:46 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:29:45 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 08/88] 3w-9xxx: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:03 -0700
Message-Id: <20211007202923.2174984-9-bvanassche@acm.org>
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
 drivers/scsi/3w-9xxx.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index e41cc354cc8a..4ebc2c79f45f 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1352,7 +1352,7 @@ static irqreturn_t twa_interrupt(int irq, void *dev_instance)
 				/* Now complete the io */
 				if (twa_command_mapped(cmd))
 					scsi_dma_unmap(cmd);
-				cmd->scsi_done(cmd);
+				scsi_done(cmd);
 				tw_dev->state[request_id] = TW_S_COMPLETED;
 				twa_free_request_id(tw_dev, request_id);
 				tw_dev->posted_request_count--;
@@ -1596,7 +1596,7 @@ static int twa_reset_device_extension(TW_Device_Extension *tw_dev)
 				cmd->result = (DID_RESET << 16);
 				if (twa_command_mapped(cmd))
 					scsi_dma_unmap(cmd);
-				cmd->scsi_done(cmd);
+				scsi_done(cmd);
 			}
 		}
 	}
@@ -1763,9 +1763,6 @@ static int twa_scsi_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_
 		goto out;
 	}
 
-	/* Save done function into scsi_cmnd struct */
-	SCpnt->scsi_done = done;
-
 	/* Get a free request id */
 	twa_get_request_id(tw_dev, &request_id);
 
