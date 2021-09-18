Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1773C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4B0960F23
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243089AbhIRAIA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:08:00 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:37681 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243765AbhIRAH5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:07:57 -0400
Received: by mail-pg1-f178.google.com with SMTP id 17so11120226pgp.4
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:06:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qbZbc9f4j8TXb5hX7TExS4uqebNwB8amX4dndndB4zE=;
        b=g3UEVeLHTVyAYEH8VhxrKMbvC5UzGP1GEEzMIS83GeN/fy3w3CdrP0jpXA1S5KqZLb
         8FXyN6Gt66yDrILQ72gBzeumwtqh0qkPbsVuH1SyaJkWIQFoRWH2pkkbv6+TW0rOg4uu
         ATvI0p6M8MRZ2L6A4brwPriqr5c/aVnQJmrihQCLQUVZUoNgQ7T768iuqYm1IKF3mutS
         xy6It9x4f9ONjTufuA3FQqGtUaEb7wuhnFOam5RFR3CS39nqOQ/egVS6ZK9+sot8ZVgZ
         BT/e3pHRTn32J4K3AN9PGDi2egoqBV2ZayzTYHaSaBJX0pSMkc41Ohynlk9kqh8w7kZr
         hDkw==
X-Gm-Message-State: AOAM531H1srupyImPai1dbO5mFhqzmdrTyi4W5CgDbOdOiyWJc6Zlt8E
        GmjyvfypdpZvVZ2GE3SqygocFutSEeo=
X-Google-Smtp-Source: ABdhPJxho/0RTZCYKy1J+ZIo5O8zOowQW0iy5cla/HLCJVrhFric1l4Z6YZMM64EQYVeXsopnLN4iQ==
X-Received: by 2002:a62:e70c:0:b0:43e:2de6:b09d with SMTP id s12-20020a62e70c000000b0043e2de6b09dmr13454682pfh.9.1631923594272;
        Fri, 17 Sep 2021 17:06:34 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:06:33 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Finn Thain <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 14/84] NCR5380: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:04:57 -0700
Message-Id: <20210918000607.450448-15-bvanassche@acm.org>
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
 drivers/scsi/NCR5380.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index a85589a2a8af..55af3e245a92 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -547,7 +547,7 @@ static void complete_cmd(struct Scsi_Host *instance,
 		hostdata->sensing = NULL;
 	}
 
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 }
 
 /**
@@ -573,7 +573,7 @@ static int NCR5380_queue_command(struct Scsi_Host *instance,
 	case WRITE_10:
 		shost_printk(KERN_DEBUG, instance, "WRITE attempted with NDEBUG_NO_WRITE set\n");
 		cmd->result = (DID_ERROR << 16);
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 		return 0;
 	}
 #endif /* (NDEBUG & NDEBUG_NO_WRITE) */
@@ -960,7 +960,7 @@ static irqreturn_t __maybe_unused NCR5380_intr(int irq, void *dev_id)
  * hostdata->connected will be set to cmd.
  * SELECT interrupt will be disabled.
  *
- * If failed (no target) : cmd->scsi_done() will be called, and the
+ * If failed (no target) : scsi_done() will be called, and the
  * cmd->result host byte set to DID_BAD_TARGET.
  */
 
@@ -2262,7 +2262,7 @@ static int NCR5380_abort(struct scsi_cmnd *cmd)
 		dsprintk(NDEBUG_ABORT, instance,
 		         "abort: removed %p from issue queue\n", cmd);
 		cmd->result = DID_ABORT << 16;
-		cmd->scsi_done(cmd); /* No tag or busy flag to worry about */
+		scsi_done(cmd); /* No tag or busy flag to worry about */
 		goto out;
 	}
 
@@ -2357,7 +2357,7 @@ static void bus_reset_cleanup(struct Scsi_Host *instance)
 	list_for_each_entry(ncmd, &hostdata->autosense, list) {
 		struct scsi_cmnd *cmd = NCR5380_to_scmd(ncmd);
 
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 	}
 	INIT_LIST_HEAD(&hostdata->autosense);
 
@@ -2400,7 +2400,7 @@ static int NCR5380_host_reset(struct scsi_cmnd *cmd)
 		struct scsi_cmnd *scmd = NCR5380_to_scmd(ncmd);
 
 		scmd->result = DID_RESET << 16;
-		scmd->scsi_done(scmd);
+		scsi_done(scmd);
 	}
 	INIT_LIST_HEAD(&hostdata->unissued);
 
