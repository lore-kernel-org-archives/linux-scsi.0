Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45135C43217
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:29:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F57A60E9B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:29:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241736AbhJGUbs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:31:48 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:46732 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241670AbhJGUbr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:31:47 -0400
Received: by mail-pg1-f169.google.com with SMTP id m21so888112pgu.13
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:29:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qbZbc9f4j8TXb5hX7TExS4uqebNwB8amX4dndndB4zE=;
        b=FIukZxFFcZL6bqTvLMIAoAzd0wpFhcaaONfrGVO0iXePjDrqPnGiqC3RrPnfH37Q1f
         wUa93WlNB/QG3CSLA3n/K1PpV60YbXGAVKpgW3bhHOPzwUzm+RnSjzJY9RyTd+bSdksN
         EntYp/aiE2ZhCs8gx5azY6bPgDfBa2uN4CiLzXTAZTivPsPqegaU7syqz8O13TX9kISA
         aZOVSE3lROjmG6dxKiufsEaUk7PWzbF5Sh0IqOOL5DJF6vn+obCIgNqvzFk0ZRgRAYI8
         5Ikz/yPWwLwqArLu5s8gcY5Gkw9xihLREAfR7CNFxj2gXUbqgSKSsXSNFWfkFwRk00Np
         DElQ==
X-Gm-Message-State: AOAM530tot5odVVBe2m6l472dUk9dooUo7TC9FmbtEsxTEnDOPJNWPCJ
        c9pRRmWOlWGnbbnuvRwkenvrsj/BfZg=
X-Google-Smtp-Source: ABdhPJz6QOABlA/6OZHUZee7HmRhkT8lb900zgZHs9xZvxUC9CRSZMy/4IZYIY5y+nQq2qyGXV2wbg==
X-Received: by 2002:a05:6a00:2d0:b0:446:d18c:9aac with SMTP id b16-20020a056a0002d000b00446d18c9aacmr6523363pft.16.1633638593068;
        Thu, 07 Oct 2021 13:29:53 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:29:52 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Finn Thain <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 13/88] NCR5380: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:08 -0700
Message-Id: <20211007202923.2174984-14-bvanassche@acm.org>
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
 
