Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02A73C4332F
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E177C61245
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242220AbhJGUb6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:31:58 -0400
Received: from mail-pf1-f179.google.com ([209.85.210.179]:38408 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242143AbhJGUb5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:31:57 -0400
Received: by mail-pf1-f179.google.com with SMTP id k26so6315658pfi.5
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:30:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wte0rr/12tr1I1LwzqWVoRGtH/EjJ9NDxokW1M+2JS4=;
        b=YEfNgHgkQzoA6N1uiKjdZREyiU62/0zH0QgiGw8oYvEsnEA95EulNh3bKbRFWXySDF
         053DvYsPmWgVz8K8dXrkk2o/Q313c1ZLW5k7XSkqdxXEWbSiMNrrRHiSinebyg505Wxv
         9gSO9C1WnIaJ/JRIik4ZZRMZjp1ftOTLV7TYIeOummtuXEYk3l1UwhI6LETCIPCysgN5
         A7/tcI9F4sJbsMkdwxKGU7OX4T6eFbi7SMGm7SNmXoIWTlx54YvfTtBwp983WbWw5nBL
         vYM1PaZJhEWcZ4o1F5wNjijqbzrflBykcO7c9aYGRYhZUvlwSpLsZOGGX4LcwRRs4i7Y
         ez1A==
X-Gm-Message-State: AOAM530iFNbTHpfVidT+84+5wOs14VmbWSMjb+NBW6NVTvCmjYzSspgd
        CVmRw8TpbGnMGf0aDvyhVZOfVC6RXeo=
X-Google-Smtp-Source: ABdhPJx6vSqrJQbEgwj0lyqJfm3fHhXLh6sbZZgT1Xd8w0tsTMmHHDZJn8itr3e7EGqpfKZ9AlXIoA==
X-Received: by 2002:a63:f62:: with SMTP id 34mr1319997pgp.159.1633638602672;
        Thu, 07 Oct 2021 13:30:02 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:30:02 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 20/88] aha1542: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:15 -0700
Message-Id: <20211007202923.2174984-21-bvanassche@acm.org>
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
