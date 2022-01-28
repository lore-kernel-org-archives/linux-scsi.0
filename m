Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E29C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 22:21:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348615AbiA1WVY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:21:24 -0500
Received: from mail-pg1-f178.google.com ([209.85.215.178]:33700 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349627AbiA1WVL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2022 17:21:11 -0500
Received: by mail-pg1-f178.google.com with SMTP id 133so6498495pgb.0
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2022 14:21:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZvFexR3TarlSi6QJgI5lSBM3tiPP3lErjiOjrJDnEWE=;
        b=qeJFYiC+SO4ESRnwo9RHgoGUuQHEo69Np/Ci7CebyscDfNV+QOsDSUCpv7bkcjpI+M
         /GKaJm/AqGH5+ygzNsv/snBGMUvndVhK7OzsXF1YkdPBpmMn0vne4OA/rFLm5ezDEquY
         tDF45cwn1MFWVBUOFS8YYs5LPWvPL8GPaQzJIe+JyLYapWP1o4bHYhW+XsPJrH7fEmzp
         rNW8DCTa0+q2y5KHCiaXEyfcVIPhW/5qxKFL9ivSRUURjSfcX3bh/CCA8cFPNG3Vk+MK
         oXWaaEo4h4Z1lHTgltY2QEcGsSekenRca0vSNhTf9l6SdYcrtKgwxSVRjmY8sj/AAQWF
         KAvA==
X-Gm-Message-State: AOAM530TgB+hRrrmAtWJl67hZbhBG7/K/RA1cVVg8wHTXUy/8AZuLXdp
        pbVqoC2WBkbLnhC8k4klEb8=
X-Google-Smtp-Source: ABdhPJwrPWMUFiUhyjxixVZcUuiVRY7/2lyLe6Q/mBxNfE42XN0irtxej9gmqaGJNq8so2rbqB4Eow==
X-Received: by 2002:a62:8fcb:: with SMTP id n194mr9988617pfd.29.1643408470702;
        Fri, 28 Jan 2022 14:21:10 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id t2sm7787931pfg.207.2022.01.28.14.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 14:21:10 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 17/44] fdomain: Move the SCSI pointer to private command data
Date:   Fri, 28 Jan 2022 14:18:42 -0800
Message-Id: <20220128221909.8141-18-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128221909.8141-1-bvanassche@acm.org>
References: <20220128221909.8141-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
from struct scsi_cmnd. This patch prepares for removal of the SCSI pointer
from struct scsi_cmnd.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/fdomain.c | 70 +++++++++++++++++++++++++-----------------
 1 file changed, 42 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index 9159b4057c5d..e24c1baf2d2a 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -115,6 +115,17 @@ struct fdomain {
 	struct work_struct work;
 };
 
+struct fdomain_priv {
+	struct scsi_pointer scsi_pointer;
+};
+
+static struct scsi_pointer *fdomain_scsi_pointer(struct scsi_cmnd *cmd)
+{
+	struct fdomain_priv *fcmd = scsi_cmd_priv(cmd);
+
+	return &fcmd->scsi_pointer;
+}
+
 static inline void fdomain_make_bus_idle(struct fdomain *fd)
 {
 	outb(0, fd->base + REG_BCTL);
@@ -263,20 +274,21 @@ static void fdomain_work(struct work_struct *work)
 	struct Scsi_Host *sh = container_of((void *)fd, struct Scsi_Host,
 					    hostdata);
 	struct scsi_cmnd *cmd = fd->cur_cmd;
+	struct scsi_pointer *scsi_pointer = fdomain_scsi_pointer(cmd);
 	unsigned long flags;
 	int status;
 	int done = 0;
 
 	spin_lock_irqsave(sh->host_lock, flags);
 
-	if (cmd->SCp.phase & in_arbitration) {
+	if (scsi_pointer->phase & in_arbitration) {
 		status = inb(fd->base + REG_ASTAT);
 		if (!(status & ASTAT_ARB)) {
 			set_host_byte(cmd, DID_BUS_BUSY);
 			fdomain_finish_cmd(fd);
 			goto out;
 		}
-		cmd->SCp.phase = in_selection;
+		scsi_pointer->phase = in_selection;
 
 		outb(ICTL_SEL | FIFO_COUNT, fd->base + REG_ICTL);
 		outb(BCTL_BUSEN | BCTL_SEL, fd->base + REG_BCTL);
@@ -285,7 +297,7 @@ static void fdomain_work(struct work_struct *work)
 		/* Stop arbitration and enable parity */
 		outb(ACTL_IRQEN | PARITY_MASK, fd->base + REG_ACTL);
 		goto out;
-	} else if (cmd->SCp.phase & in_selection) {
+	} else if (scsi_pointer->phase & in_selection) {
 		status = inb(fd->base + REG_BSTAT);
 		if (!(status & BSTAT_BSY)) {
 			/* Try again, for slow devices */
@@ -297,75 +309,75 @@ static void fdomain_work(struct work_struct *work)
 			/* Stop arbitration and enable parity */
 			outb(ACTL_IRQEN | PARITY_MASK, fd->base + REG_ACTL);
 		}
-		cmd->SCp.phase = in_other;
+		scsi_pointer->phase = in_other;
 		outb(ICTL_FIFO | ICTL_REQ | FIFO_COUNT, fd->base + REG_ICTL);
 		outb(BCTL_BUSEN, fd->base + REG_BCTL);
 		goto out;
 	}
 
-	/* cur_cmd->SCp.phase == in_other: this is the body of the routine */
+	/* fdomain_scsi_pointer(cur_cmd)->phase == in_other: this is the body of the routine */
 	status = inb(fd->base + REG_BSTAT);
 
 	if (status & BSTAT_REQ) {
 		switch (status & (BSTAT_MSG | BSTAT_CMD | BSTAT_IO)) {
 		case BSTAT_CMD:	/* COMMAND OUT */
-			outb(cmd->cmnd[cmd->SCp.sent_command++],
+			outb(cmd->cmnd[scsi_pointer->sent_command++],
 			     fd->base + REG_SCSI_DATA);
 			break;
 		case 0:	/* DATA OUT -- tmc18c50/tmc18c30 only */
-			if (fd->chip != tmc1800 && !cmd->SCp.have_data_in) {
-				cmd->SCp.have_data_in = -1;
+			if (fd->chip != tmc1800 && !scsi_pointer->have_data_in) {
+				scsi_pointer->have_data_in = -1;
 				outb(ACTL_IRQEN | ACTL_FIFOWR | ACTL_FIFOEN |
 				     PARITY_MASK, fd->base + REG_ACTL);
 			}
 			break;
 		case BSTAT_IO:	/* DATA IN -- tmc18c50/tmc18c30 only */
-			if (fd->chip != tmc1800 && !cmd->SCp.have_data_in) {
-				cmd->SCp.have_data_in = 1;
+			if (fd->chip != tmc1800 && !scsi_pointer->have_data_in) {
+				scsi_pointer->have_data_in = 1;
 				outb(ACTL_IRQEN | ACTL_FIFOEN | PARITY_MASK,
 				     fd->base + REG_ACTL);
 			}
 			break;
 		case BSTAT_CMD | BSTAT_IO:	/* STATUS IN */
-			cmd->SCp.Status = inb(fd->base + REG_SCSI_DATA);
+			scsi_pointer->Status = inb(fd->base + REG_SCSI_DATA);
 			break;
 		case BSTAT_MSG | BSTAT_CMD:	/* MESSAGE OUT */
 			outb(MESSAGE_REJECT, fd->base + REG_SCSI_DATA);
 			break;
 		case BSTAT_MSG | BSTAT_CMD | BSTAT_IO:	/* MESSAGE IN */
-			cmd->SCp.Message = inb(fd->base + REG_SCSI_DATA);
-			if (cmd->SCp.Message == COMMAND_COMPLETE)
+			scsi_pointer->Message = inb(fd->base + REG_SCSI_DATA);
+			if (scsi_pointer->Message == COMMAND_COMPLETE)
 				++done;
 			break;
 		}
 	}
 
-	if (fd->chip == tmc1800 && !cmd->SCp.have_data_in &&
-	    cmd->SCp.sent_command >= cmd->cmd_len) {
+	if (fd->chip == tmc1800 && !scsi_pointer->have_data_in &&
+	    scsi_pointer->sent_command >= cmd->cmd_len) {
 		if (cmd->sc_data_direction == DMA_TO_DEVICE) {
-			cmd->SCp.have_data_in = -1;
+			scsi_pointer->have_data_in = -1;
 			outb(ACTL_IRQEN | ACTL_FIFOWR | ACTL_FIFOEN |
 			     PARITY_MASK, fd->base + REG_ACTL);
 		} else {
-			cmd->SCp.have_data_in = 1;
+			scsi_pointer->have_data_in = 1;
 			outb(ACTL_IRQEN | ACTL_FIFOEN | PARITY_MASK,
 			     fd->base + REG_ACTL);
 		}
 	}
 
-	if (cmd->SCp.have_data_in == -1) /* DATA OUT */
+	if (scsi_pointer->have_data_in == -1) /* DATA OUT */
 		fdomain_write_data(cmd);
 
-	if (cmd->SCp.have_data_in == 1) /* DATA IN */
+	if (scsi_pointer->have_data_in == 1) /* DATA IN */
 		fdomain_read_data(cmd);
 
 	if (done) {
-		set_status_byte(cmd, cmd->SCp.Status);
+		set_status_byte(cmd, scsi_pointer->Status);
 		set_host_byte(cmd, DID_OK);
-		scsi_msg_to_host_byte(cmd, cmd->SCp.Message);
+		scsi_msg_to_host_byte(cmd, scsi_pointer->Message);
 		fdomain_finish_cmd(fd);
 	} else {
-		if (cmd->SCp.phase & disconnect) {
+		if (scsi_pointer->phase & disconnect) {
 			outb(ICTL_FIFO | ICTL_SEL | ICTL_REQ | FIFO_COUNT,
 			     fd->base + REG_ICTL);
 			outb(0, fd->base + REG_BCTL);
@@ -398,14 +410,15 @@ static irqreturn_t fdomain_irq(int irq, void *dev_id)
 
 static int fdomain_queue(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 {
+	struct scsi_pointer *scsi_pointer = fdomain_scsi_pointer(cmd);
 	struct fdomain *fd = shost_priv(cmd->device->host);
 	unsigned long flags;
 
-	cmd->SCp.Status		= 0;
-	cmd->SCp.Message	= 0;
-	cmd->SCp.have_data_in	= 0;
-	cmd->SCp.sent_command	= 0;
-	cmd->SCp.phase		= in_arbitration;
+	scsi_pointer->Status		= 0;
+	scsi_pointer->Message		= 0;
+	scsi_pointer->have_data_in	= 0;
+	scsi_pointer->sent_command	= 0;
+	scsi_pointer->phase		= in_arbitration;
 	scsi_set_resid(cmd, scsi_bufflen(cmd));
 
 	spin_lock_irqsave(sh->host_lock, flags);
@@ -440,7 +453,7 @@ static int fdomain_abort(struct scsi_cmnd *cmd)
 	spin_lock_irqsave(sh->host_lock, flags);
 
 	fdomain_make_bus_idle(fd);
-	fd->cur_cmd->SCp.phase |= aborted;
+	fdomain_scsi_pointer(fd->cur_cmd)->phase |= aborted;
 
 	/* Aborts are not done well. . . */
 	set_host_byte(fd->cur_cmd, DID_ABORT);
@@ -501,6 +514,7 @@ static struct scsi_host_template fdomain_template = {
 	.this_id		= 7,
 	.sg_tablesize		= 64,
 	.dma_boundary		= PAGE_SIZE - 1,
+	.cmd_size		= sizeof(struct fdomain_priv),
 };
 
 struct Scsi_Host *fdomain_create(int base, int irq, int this_id,
