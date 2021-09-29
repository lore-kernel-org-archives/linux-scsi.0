Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D007C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85C716138F
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347090AbhI2WIW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:08:22 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:34319 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347096AbhI2WIP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:08:15 -0400
Received: by mail-pg1-f179.google.com with SMTP id 133so4172453pgb.1
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:06:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FTB59pMPuQhJHl5BS28nOuJXEUIlavD+Yi8w4LNUtqk=;
        b=VUkaG6bxl8lkiAR0lLDj9zaThmfZqr/CbCuESku6bg0HLUzJIzLiel+pbpboLGqGb2
         dxlrw4xi6gVJQxA2B9eNCCuFDTZDUnS+l7dw7X0pkl+xaN5DQ5VL4oitAonWEafa359Q
         AQCk3bopCJOs4rfkuKSMxNmru3C4bzTr/u4SBLk1pkH2jFAMa69Qi4zyr0ROGMlNZMa+
         NVJzHJV5bTwKlod9Vdwmca5GVa4oEteWGfrN6KuelC7xJ1Ld0x7g3nyv2fABh4dwFmcC
         bEDWr51TRc4OWpMSijxJxuMW9MjtnmBfbszWU6k15XVG2+YdraL60z5aBFygb+E8bf9t
         GnEg==
X-Gm-Message-State: AOAM5310QSgGPbG5OlRnsEDM1k4803TtAfwNaqN2uGOxletiXGak+jvU
        NroF91Bh4tODZ8EwRS9PfzI9IdgHpTg=
X-Google-Smtp-Source: ABdhPJzSxmJdQ4zAfA0HpvssU2OFXPjGFg2lF4xIJPU9/v5/E7KDC4A5+nguRXIJ4aMIEsO+XreaKw==
X-Received: by 2002:a62:1ec5:0:b0:446:40ec:73b2 with SMTP id e188-20020a621ec5000000b0044640ec73b2mr949618pfe.5.1632953193491;
        Wed, 29 Sep 2021 15:06:33 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.06.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:06:33 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 12/84] BusLogic: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:04:48 -0700
Message-Id: <20210929220600.3509089-13-bvanassche@acm.org>
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
 drivers/scsi/BusLogic.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 40088dcb98cd..7287a9081684 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -2624,7 +2624,7 @@ static void blogic_process_ccbs(struct blogic_adapter *adapter)
 					command->reset_chain;
 				command->reset_chain = NULL;
 				command->result = DID_RESET << 16;
-				command->scsi_done(command);
+				scsi_done(command);
 				command = nxt_cmd;
 			}
 #endif
@@ -2641,7 +2641,7 @@ static void blogic_process_ccbs(struct blogic_adapter *adapter)
 					blogic_dealloc_ccb(ccb, 1);
 					adapter->active_cmds[tgt_id]--;
 					command->result = DID_RESET << 16;
-					command->scsi_done(command);
+					scsi_done(command);
 				}
 			adapter->bdr_pend[tgt_id] = NULL;
 		} else {
@@ -2713,7 +2713,7 @@ static void blogic_process_ccbs(struct blogic_adapter *adapter)
 			/*
 			   Call the SCSI Command Completion Routine.
 			 */
-			command->scsi_done(command);
+			scsi_done(command);
 		}
 	}
 	adapter->processing_ccbs = false;
@@ -3038,7 +3038,6 @@ static int blogic_qcmd_lck(struct scsi_cmnd *command,
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 	ccb->sensedata = sense_buf;
-	command->scsi_done = comp_cb;
 	if (blogic_multimaster_type(adapter)) {
 		/*
 		   Place the CCB in an Outgoing Mailbox. The higher levels
@@ -3060,7 +3059,7 @@ static int blogic_qcmd_lck(struct scsi_cmnd *command,
 				blogic_warn("Still unable to write Outgoing Mailbox - Host Adapter Dead?\n", adapter);
 				blogic_dealloc_ccb(ccb, 1);
 				command->result = DID_ERROR << 16;
-				command->scsi_done(command);
+				scsi_done(command);
 			}
 		}
 	} else {
