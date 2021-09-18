Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C654C433FE
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2578A60F23
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243791AbhIRAH5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:07:57 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:41591 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243449AbhIRAHz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:07:55 -0400
Received: by mail-pf1-f181.google.com with SMTP id x7so10590629pfa.8
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:06:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FTB59pMPuQhJHl5BS28nOuJXEUIlavD+Yi8w4LNUtqk=;
        b=hhFmVJRso3PUE8t01GVm0SsRHMb7Vb3FYfjExcnWPkXiJyPHfEyY3OHzgdsGo13RoL
         lGuxQDs058NjXnPxYg6eUK/oEJsf0E218gWMogUGxAvVRuoLwwdIhCOm8TMatv2l5OBz
         Bf8fv0pta1EfW9Iy3OiOFQklxRrhYIvj7uX53AB6zNX1sIzJwf+jQ74hF78d+d/23aA/
         DAp+5P9wt6HbcQxEZIzfMi0NrEYIh9822RIlnueopgyH9VKNWPGAx4UlZs7/u21MTHrq
         e66XQqj55zYmGxdto2yEdyODTdNgAymu5d5ApjExfaCDTAHjWhIkOOBW41vK2dYuK8pn
         nwGw==
X-Gm-Message-State: AOAM533wQ9P9bTon9xzfFvbxtx5ZJ/lIiZ2gkl1uCSOIeRiq8teW5+2u
        6CC4+ou2KRExRkRl7shbidU=
X-Google-Smtp-Source: ABdhPJzZtvCr6EnmFUgVpF3mYo8w7zt68VDt0lHZmgMwVOBH/TyFi2PVhsGV47mp7rLn0ab9GAVPZA==
X-Received: by 2002:a62:6103:0:b0:405:2c7a:9ee9 with SMTP id v3-20020a626103000000b004052c7a9ee9mr13376659pfb.71.1631923592827;
        Fri, 17 Sep 2021 17:06:32 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.06.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:06:32 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 13/84] BusLogic: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:04:56 -0700
Message-Id: <20210918000607.450448-14-bvanassche@acm.org>
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
