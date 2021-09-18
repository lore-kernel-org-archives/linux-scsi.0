Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48690C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30AA460F51
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343694AbhIRAIM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:08:12 -0400
Received: from mail-pf1-f171.google.com ([209.85.210.171]:41593 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244946AbhIRAIH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:08:07 -0400
Received: by mail-pf1-f171.google.com with SMTP id x7so10590939pfa.8
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:06:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wte0rr/12tr1I1LwzqWVoRGtH/EjJ9NDxokW1M+2JS4=;
        b=LEZPGssYFPkVT9ikM6Q2kCZI/ORYxNS6IGFZIL23l1BCLL+igawkU/DR6C6MoaJoMH
         QBv1qs9T33E966yO9DjnLN4tpaLWFkMPaUF/pbc3DDJUvKtxun8+iNvmIBxTICplTTPf
         oqK9uGb4236NhhF3Db1QTQ3UMfmk9NJ79nSvS7rfhLPFfR2tJxdnEQxSTge+oldAN1xp
         n8s2Mc0sQbrX4cE/F/ptiYmwmaKcrn93KRAT4BVChU6SDDoRsWwDvvvsXIn1FMpiroXu
         4iFOtxrIf2Vd7pGdi5SBXrzvY6O1kXx1XYCroKN1zOK++gdGRScI54Lzel73M4DItWZ1
         LJJg==
X-Gm-Message-State: AOAM531flY/o9p4Kh5OTbpJv+efKrwWX2LYJ/tqWd6VQ1WQNWqp3Bg4T
        ya0t1cf8G88ULYsYfGxm8x2dlAsnCiE=
X-Google-Smtp-Source: ABdhPJyZiRSM6j/OW08YOqDQHqMCUl7OaeEipDqoFA0G1eRZqHL49c0tMQBkJQLKnbvXts/7g9PvEQ==
X-Received: by 2002:aa7:9ac2:0:b0:443:a477:6684 with SMTP id x2-20020aa79ac2000000b00443a4776684mr9619556pfp.25.1631923603988;
        Fri, 17 Sep 2021 17:06:43 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.06.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:06:43 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 21/84] aha1542: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:04 -0700
Message-Id: <20210918000607.450448-22-bvanassche@acm.org>
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
 drivers/scsi/aha1542.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 584a59522038..8697f4720946 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -281,7 +281,6 @@ static irqreturn_t aha1542_interrupt(int irq, void *dev_id)
 {
 	struct Scsi_Host *sh = dev_id;
 	struct aha1542_hostdata *aha1542 = shost_priv(sh);
-	void (*my_done)(struct scsi_cmnd *) = NULL;
 	int errstatus, mbi, mbo, mbistatus;
 	int number_serviced;
 	unsigned long flags;
@@ -369,14 +368,13 @@ static irqreturn_t aha1542_interrupt(int irq, void *dev_id)
 
 		tmp_cmd = aha1542->int_cmds[mbo];
 
-		if (!tmp_cmd || !tmp_cmd->scsi_done) {
+		if (!tmp_cmd) {
 			spin_unlock_irqrestore(sh->host_lock, flags);
 			shost_printk(KERN_WARNING, sh, "Unexpected interrupt\n");
 			shost_printk(KERN_WARNING, sh, "tarstat=%x, hastat=%x idlun=%x ccb#=%d\n", ccb[mbo].tarstat,
 			       ccb[mbo].hastat, ccb[mbo].idlun, mbo);
 			return IRQ_HANDLED;
 		}
-		my_done = tmp_cmd->scsi_done;
 		aha1542_free_cmd(tmp_cmd);
 		/*
 		 * Fetch the sense data, and tuck it away, in the required slot.  The
@@ -410,7 +408,7 @@ static irqreturn_t aha1542_interrupt(int irq, void *dev_id)
 		aha1542->int_cmds[mbo] = NULL;	/* This effectively frees up the mailbox slot, as
 						 * far as queuecommand is concerned
 						 */
-		my_done(tmp_cmd);
+		scsi_done(tmp_cmd);
 		number_serviced++;
 	};
 }
@@ -431,7 +429,7 @@ static int aha1542_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 	if (*cmd->cmnd == REQUEST_SENSE) {
 		/* Don't do the command - we have the sense data already */
 		cmd->result = 0;
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 		return 0;
 	}
 #ifdef DEBUG
@@ -488,7 +486,7 @@ static int aha1542_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 	aha1542->aha1542_last_mbo_used = mbo;
 
 #ifdef DEBUG
-	shost_printk(KERN_DEBUG, sh, "Sending command (%d %p)...", mbo, cmd->scsi_done);
+	shost_printk(KERN_DEBUG, sh, "Sending command (%d)...", mbo);
 #endif
 
 	/* This gets trashed for some reason */
