Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3E9BC433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:09:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD51B61164
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:09:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345044AbhIRAKk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:10:40 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:54013 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345129AbhIRAJr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:09:47 -0400
Received: by mail-pj1-f43.google.com with SMTP id j1so7998858pjv.3
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:08:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KCk1KbuFpkV7cq/guiqDKEKPoQ6wJbY/OnjdIU+o1lM=;
        b=G5vJ3el+BZ2ioEDANSpIhSJ89w/b62apRCtKLKr1ZdHutAVtih9vggq/GsyBXpibkq
         65BH8TRyR89ovtWYZ7gwQjbxcNAwOwLlirSm6Z2u0JhJ5g4YKZnxa9Qtp9d9BQnPNMZf
         W5E8UK++nreOgVYZEwaSTsYCVG3f4bhq0emxRVEjJYRTjH3/2AWeGMHgdm6ELsl9sXwK
         uYsRfK2WZDoJWk1FokjXqiba0AlMYqJH0strzNFiU3R6PnzoTRKEoJL+0tvOu0rFUEAT
         gxDFzonj6t8B7Y0rK2WE3ksx+FsxgZGZj2Sg+wbfE7UeWEsP+wj7OB3wNjxJMhTOGshh
         f4pg==
X-Gm-Message-State: AOAM530y8y/JdvEq2UOyVdagMuZPlrty29A9s1xRu4kdiQIrBSMOaZRF
        kXyQRdc+d4bGwgK7OGLSGq7sJFAX+os=
X-Google-Smtp-Source: ABdhPJwWZaK1t/ap9JRA+pMRWSWdUfQcgWf8pRK9ADk91ciIf5S/4fSguwafoZVq+DhoCN437WnqEg==
X-Received: by 2002:a17:90a:ef0b:: with SMTP id k11mr24292895pjz.209.1631923704803;
        Fri, 17 Sep 2021 17:08:24 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:08:24 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 77/84] wd33c93: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:06:00 -0700
Message-Id: <20210918000607.450448-78-bvanassche@acm.org>
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
 drivers/scsi/wd33c93.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
index 4468bc45aaa4..fe28d21c7e93 100644
--- a/drivers/scsi/wd33c93.c
+++ b/drivers/scsi/wd33c93.c
@@ -376,11 +376,9 @@ wd33c93_queuecommand_lck(struct scsi_cmnd *cmd,
 
 /* Set up a few fields in the scsi_cmnd structure for our own use:
  *  - host_scribble is the pointer to the next cmd in the input queue
- *  - scsi_done points to the routine we call when a cmd is finished
  *  - result is what you'd expect
  */
 	cmd->host_scribble = NULL;
-	cmd->scsi_done = done;
 	cmd->result = 0;
 
 /* We use the Scsi_Pointer structure that's included with each command
@@ -856,7 +854,7 @@ wd33c93_intr(struct Scsi_Host *instance)
 		cmd->result = DID_NO_CONNECT << 16;
 		hostdata->busy[cmd->device->id] &= ~(1 << (cmd->device->lun & 0xff));
 		hostdata->state = S_UNCONNECTED;
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 
 		/* From esp.c:
 		 * There is a window of time within the scsi_done() path
@@ -1183,7 +1181,7 @@ wd33c93_intr(struct Scsi_Host *instance)
 				scsi_msg_to_host_byte(cmd, cmd->SCp.Message);
 				set_status_byte(cmd, cmd->SCp.Status);
 			}
-			cmd->scsi_done(cmd);
+			scsi_done(cmd);
 
 /* We are no longer  connected to a target - check to see if
  * there are commands waiting to be executed.
@@ -1270,7 +1268,7 @@ wd33c93_intr(struct Scsi_Host *instance)
 			scsi_msg_to_host_byte(cmd, cmd->SCp.Message);
 			set_status_byte(cmd, cmd->SCp.Status);
 		}
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 
 /* We are no longer connected to a target - check to see if
  * there are commands waiting to be executed.
@@ -1306,7 +1304,7 @@ wd33c93_intr(struct Scsi_Host *instance)
 				scsi_msg_to_host_byte(cmd, cmd->SCp.Message);
 				set_status_byte(cmd, cmd->SCp.Status);
 			}
-			cmd->scsi_done(cmd);
+			scsi_done(cmd);
 			break;
 		case S_PRE_TMP_DISC:
 		case S_RUNNING_LEVEL2:
@@ -1636,7 +1634,7 @@ wd33c93_abort(struct scsi_cmnd * cmd)
 			    ("scsi%d: Abort - removing command from input_Q. ",
 			     instance->host_no);
 			enable_irq(cmd->device->host->irq);
-			cmd->scsi_done(cmd);
+			scsi_done(cmd);
 			return SUCCESS;
 		}
 		prev = tmp;
@@ -1711,7 +1709,7 @@ wd33c93_abort(struct scsi_cmnd * cmd)
 		wd33c93_execute(instance);
 
 		enable_irq(cmd->device->host->irq);
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 		return SUCCESS;
 	}
 
