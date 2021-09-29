Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0714C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5D1F60FC2
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347067AbhI2WIX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:08:23 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:43543 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347066AbhI2WIQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:08:16 -0400
Received: by mail-pj1-f53.google.com with SMTP id k23-20020a17090a591700b001976d2db364so3149325pji.2
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:06:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qbZbc9f4j8TXb5hX7TExS4uqebNwB8amX4dndndB4zE=;
        b=sFODm7uBY0P4sWPugPrwDseYD6NpcPBzOdHWU0jU5UNXiga2Fn+Gsv6WTVmx4GdPZ8
         SS2HU01UcG8k7ROlxsecgyqo0sZBeLg9Exhw55Dm7TxU5LhanHlrzI8bDhcEWhJouFpO
         ZGoM8pcRBYrgpcVI8SnX/hcZwiiJyZYLxHf0c73EEwcgekf7nZxK3VdpAbEYv9aXf8SW
         19YVsvDIJuP7eNDKATypaieabVDVv+saUT+FKxOxz0K+CPwu7e/oW+TBL4MQoPCMpBvp
         2hF63uCS7GbRXeYLmuqEC6CokwOhTpC0B4bIfybFU6sgfflWYtccqbOhfm5gtKcBmUYm
         HglQ==
X-Gm-Message-State: AOAM532aJG6J7Sas4pTuSSuHYWvFXbu8l0g7UKxxUXzXgGh/4sCl5aV1
        AExG2084G1qHSK6sPyJvgXM=
X-Google-Smtp-Source: ABdhPJynLXalVf2x7yBGXkE1EluOFEdTxm8jUE74GnHK76OtCtPCJSi8fTgc+wVtDeqZBuYKzcpXDQ==
X-Received: by 2002:a17:902:7843:b0:13d:c728:69c9 with SMTP id e3-20020a170902784300b0013dc72869c9mr2058547pln.55.1632953195041;
        Wed, 29 Sep 2021 15:06:35 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:06:34 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Finn Thain <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 13/84] NCR5380: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:04:49 -0700
Message-Id: <20210929220600.3509089-14-bvanassche@acm.org>
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
 
