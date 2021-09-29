Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDF71C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:08:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBE3460FC2
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:08:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347208AbhI2WKJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:10:09 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:42545 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347197AbhI2WKD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:10:03 -0400
Received: by mail-pg1-f176.google.com with SMTP id 66so3743567pgc.9
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:08:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KCk1KbuFpkV7cq/guiqDKEKPoQ6wJbY/OnjdIU+o1lM=;
        b=pOQm71ZbGgZ8yaWKH2SRKoTyNg69fYGO0sQ/r2ncWLrNXlQaTaIbUe4n7VBHTdQgpQ
         HzwCNYmrfTZFXy0rJKeiIij9GHzIJiOVlSXJMCF00aoE2M2v3Clu6VxfOoWfgdei6+nc
         O+ndvmeXzYBGCmURGyRu8aaCGM0Tdig/9U2s55ILYJIUQsvwuEuKd+c8zpZyqCrFiMho
         ZmVMka1rSt94ffvnMBxGGnu8AvnH7wadR2tKzLVwckaVFo8Vw9jWLDoGDfJK6HAMBN0w
         Tnip+z5dpwnvvdZyplPP9J6VUrPNvVzC8/5PDuhFHz7EuA/xOicvGOSZPmtqf248d7Lo
         Wx3w==
X-Gm-Message-State: AOAM53105mTt0ziSnIw9WGBG7oZlFTXjUD6aSxMRg87z+36bOIIlJU4F
        jqvdF71ZUy5+3HCGMfuYPjbs3scfBxM=
X-Google-Smtp-Source: ABdhPJyLOueknvpT3eA6obTL4Bbgep++fEoAuLHiEecG7WeWyQTt0Rq2JQlBui1aubmSglTsV70G2A==
X-Received: by 2002:a62:1bc2:0:b0:44b:bd59:4b32 with SMTP id b185-20020a621bc2000000b0044bbd594b32mr2065785pfb.55.1632953300878;
        Wed, 29 Sep 2021 15:08:20 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.08.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:08:20 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 77/84] wd33c93: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:53 -0700
Message-Id: <20210929220600.3509089-78-bvanassche@acm.org>
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
 
