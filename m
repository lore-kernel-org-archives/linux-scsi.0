Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49F00C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3475F613CE
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347094AbhI2WId (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:08:33 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:45877 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347078AbhI2WI0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:08:26 -0400
Received: by mail-pg1-f176.google.com with SMTP id n18so4110575pgm.12
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:06:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wte0rr/12tr1I1LwzqWVoRGtH/EjJ9NDxokW1M+2JS4=;
        b=4mcSeFApBtF+D9FdXwFCBVd3p/AKBAdtpDixt8Y/fP+FAy6U35XBAtXz3i9lh85FNZ
         C5tPjSPxqdexqt7hY0AqZtSWMG+YL1SgINbR9+duX0Nr7YZ6Tc0ybRaXZzzrw/F4Wj1p
         lN9Ru9Y1z53Lr2ykYT9EEDdd1KZ3QXNzERiqsP6c8zhHgVhsniyAaFkYmr3lmfp4XtTo
         O8MK8LvhgnAmtIqP2VPdkQuAIIhE6bucP0brVPgCKrDWEaBiBEIXilFxz1P6BdUSoxzx
         cu9udhWqHj1FAN0Dbq/Uec19gIRSviL18DpbFH3AsdvArGAMg5fffuU09fPBa/i1AjQs
         wONg==
X-Gm-Message-State: AOAM531JsNH7k4mm2xHZOi20uq7v2YfXBBWNc2Rlj70ipQgGLvObCt44
        wsjrJbRlDWyjKTNP8PNV/tU=
X-Google-Smtp-Source: ABdhPJz+/GAC0Ygzl2rzmUjA4zjNKgrMX3tUaG/9xY/72H4xu7WwQIOyNc944lt2TvV4STehh2bMKA==
X-Received: by 2002:a63:d709:: with SMTP id d9mr1872532pgg.377.1632953204575;
        Wed, 29 Sep 2021 15:06:44 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.06.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:06:43 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 20/84] aha1542: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:04:56 -0700
Message-Id: <20210929220600.3509089-21-bvanassche@acm.org>
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
