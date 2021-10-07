Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5AE5C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:46:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88916610A1
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241336AbhJGUs2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:48:28 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:38614 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241391AbhJGUs0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:48:26 -0400
Received: by mail-pf1-f173.google.com with SMTP id k26so6350418pfi.5
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:46:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KCk1KbuFpkV7cq/guiqDKEKPoQ6wJbY/OnjdIU+o1lM=;
        b=QvpRDdVXkhQp2IpAa+sZFjpQJmAfk7kAWe0Y1d2rFPbNXH6veWTHOc+M0fpdGv6pud
         pGnFQuvSiI0o6vuJF4VirvofS4/NCWDXtno1BXEqWPOev7Ohj1qnv7AstNRu0g/KrcJY
         RP9RChfwWS1xGK/Wtm7u9yVQxccMvz9hDx1O722y/an3oYa/VKkhaAgcu6ycLOEIrpIa
         2bZp14Gq2Xitbi/Ez6Ck7rlPH+vKtz7yanHNCwzNvyEbZIRO3Y44sPKOLW4+KBhzJSNv
         OMauIe42iSLk41+WiADasKfV8W0qDEMheOfSXcuw9RKl4xYOtBVxRLfEm3fdnogo561o
         rOuA==
X-Gm-Message-State: AOAM533jtcICPG/lUlDT/fHW0E5ZZolp4KT7Dcuj09flHlk/aUf2eSfS
        KzqcRyT8ToEMhL5oBz6ErG8=
X-Google-Smtp-Source: ABdhPJycLXIpiBQjGpIPfYYIru+qJ1YiV8C8yMMxqQ8BlwdOWUvnTOmLxsKuvoAbZtJQA1xhepfz5w==
X-Received: by 2002:a63:bf07:: with SMTP id v7mr1347975pgf.475.1633639592403;
        Thu, 07 Oct 2021 13:46:32 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id 17sm280831pfh.216.2021.10.07.13.46.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:46:31 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v3 78/88] wd33c93: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:46:04 -0700
Message-Id: <20211007204618.2196847-4-bvanassche@acm.org>
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
 
