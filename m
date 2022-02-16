Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 295E6C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 21:03:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233654AbiBPVDs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 16:03:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233619AbiBPVDm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 16:03:42 -0500
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A34B222193
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:03:29 -0800 (PST)
Received: by mail-pj1-f42.google.com with SMTP id v5-20020a17090a4ec500b001b8b702df57so7571348pjl.2
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:03:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cpcKWeF4eOeGIU7dsXHWDuSosdfxHXKOqrJDc3sWxnM=;
        b=w6nZLYZdE0aHpZP5mJJkjLCPAjM/ZOHl2w7UmoUaMSL8Nw3mqvqHdunE7FYCe5QQq7
         Qehx2TjUivOw5d3tUsicbEqfYjOBwiKh9EaPRLkvPGf0ySce01motljvZdGDoh6LCl8V
         MEvxtVB5OWNf0nA7Clmlsic419V7lRoGwXpANWXYj3kZDQD4Z6zwXG0z9/pzOOst9qEr
         W3i2YXy90AGfufzhs3GASLNE0GOzD7e0nqkS7vXDgNmx1JFiWOhDxiVOQMWeFXt5f0cE
         5oS0vFgZfbhqFe10fQ7fUM/bVBaKmXN7pMQ+Rveq+O3a0+bwMROilC3LpFkQtW7BWOYT
         BEMA==
X-Gm-Message-State: AOAM532R8uUaMlNMew9ZT9tIAsORyILJ2eJGAxsL89dcG/vFPZOK8602
        JBQg/twouGOCzX322vhXeac=
X-Google-Smtp-Source: ABdhPJw0LBY4SOy7/F2i2BDodtUp0fGXqf3nPHaG5/5cUVKqIhXYwcK7ldJATRpK4aAGoEZnS4bLdQ==
X-Received: by 2002:a17:903:120b:b0:14f:14b:3485 with SMTP id l11-20020a170903120b00b0014f014b3485mr4276320plh.18.1645045408717;
        Wed, 16 Feb 2022 13:03:28 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c8sm46591222pfv.57.2022.02.16.13.03.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 13:03:28 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 21/50] scsi: fdomain: Move the SCSI pointer to private command data
Date:   Wed, 16 Feb 2022 13:02:04 -0800
Message-Id: <20220216210233.28774-22-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220216210233.28774-1-bvanassche@acm.org>
References: <20220216210233.28774-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
from struct scsi_cmnd. This patch prepares for removal of the SCSI pointer
from struct scsi_cmnd.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/fdomain.c | 64 ++++++++++++++++++++++++------------------
 1 file changed, 36 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index 9159b4057c5d..444eac9b2466 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -115,6 +115,11 @@ struct fdomain {
 	struct work_struct work;
 };
 
+static struct scsi_pointer *fdomain_scsi_pointer(struct scsi_cmnd *cmd)
+{
+	return scsi_cmd_priv(cmd);
+}
+
 static inline void fdomain_make_bus_idle(struct fdomain *fd)
 {
 	outb(0, fd->base + REG_BCTL);
@@ -263,20 +268,21 @@ static void fdomain_work(struct work_struct *work)
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
@@ -285,7 +291,7 @@ static void fdomain_work(struct work_struct *work)
 		/* Stop arbitration and enable parity */
 		outb(ACTL_IRQEN | PARITY_MASK, fd->base + REG_ACTL);
 		goto out;
-	} else if (cmd->SCp.phase & in_selection) {
+	} else if (scsi_pointer->phase & in_selection) {
 		status = inb(fd->base + REG_BSTAT);
 		if (!(status & BSTAT_BSY)) {
 			/* Try again, for slow devices */
@@ -297,75 +303,75 @@ static void fdomain_work(struct work_struct *work)
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
@@ -398,14 +404,15 @@ static irqreturn_t fdomain_irq(int irq, void *dev_id)
 
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
@@ -440,7 +447,7 @@ static int fdomain_abort(struct scsi_cmnd *cmd)
 	spin_lock_irqsave(sh->host_lock, flags);
 
 	fdomain_make_bus_idle(fd);
-	fd->cur_cmd->SCp.phase |= aborted;
+	fdomain_scsi_pointer(fd->cur_cmd)->phase |= aborted;
 
 	/* Aborts are not done well. . . */
 	set_host_byte(fd->cur_cmd, DID_ABORT);
@@ -501,6 +508,7 @@ static struct scsi_host_template fdomain_template = {
 	.this_id		= 7,
 	.sg_tablesize		= 64,
 	.dma_boundary		= PAGE_SIZE - 1,
+	.cmd_size		= sizeof(struct scsi_pointer),
 };
 
 struct Scsi_Host *fdomain_create(int base, int irq, int this_id,
