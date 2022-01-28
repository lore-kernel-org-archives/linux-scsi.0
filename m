Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D760C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 22:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351634AbiA1WWH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:22:07 -0500
Received: from mail-pj1-f53.google.com ([209.85.216.53]:33401 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349627AbiA1WV2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2022 17:21:28 -0500
Received: by mail-pj1-f53.google.com with SMTP id g11-20020a17090a7d0b00b001b2c12c7273so8060443pjl.0
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2022 14:21:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sUjzm+wBj9ocUJwsnh4MQ9EpQhUue3hY3dB9ZHXciA0=;
        b=GflQUZ9UA40j3pvE/OEAL6e+yD4GGm4fMucgWKWPWCuX9wo4Wnp8fa9TCoT+uFO7Di
         g7T0pE7erRWFLfXeJKDzf+BpLQfReNPYehck8ScZpC5zaD+UiU5dO9FD4lDHFQFJQ7pi
         oPtBmF8cLwGmcmOoN8x7XUX51QCPUvOsIKPBwk5vMz8xweH7R58vlvWzcnWAh2lbV7QU
         5MK44v2sWs/vMM0NANi0bUuFTIAFeU/wUQkApzg3afJcVyTTZEU9e7HXmaPXUyZAd6Gu
         EwYF58wTGP5LqX5FHACHO6p1vAvZ1tkjGq6WkJcUk10rX17kbiEahn3KD502Z8Vg4u1S
         PVCw==
X-Gm-Message-State: AOAM532NF+8rarYLuvsH92u0s+0Ub27PdHV+VheO04TaGq7awLHRBAdw
        cOwmzSTA0CKnTJ2aYuCyQ70=
X-Google-Smtp-Source: ABdhPJyB9pTSwi+wwhYpLo61OdXsuj+xgecy4vNMtkQSfFdp/XMu7lYBgx1n6xhg00vlHweF1giTPw==
X-Received: by 2002:a17:902:db0e:: with SMTP id m14mr10699230plx.65.1643408487937;
        Fri, 28 Jan 2022 14:21:27 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id t2sm7787931pfg.207.2022.01.28.14.21.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 14:21:27 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 26/44] mac53c94: Move the SCSI pointer to private command data
Date:   Fri, 28 Jan 2022 14:18:51 -0800
Message-Id: <20220128221909.8141-27-bvanassche@acm.org>
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
 drivers/scsi/mac53c94.c | 24 +++++++++++++-----------
 drivers/scsi/mac53c94.h | 11 +++++++++++
 2 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
index cf81cbb0043a..9d57628e3b25 100644
--- a/drivers/scsi/mac53c94.c
+++ b/drivers/scsi/mac53c94.c
@@ -193,7 +193,8 @@ static void mac53c94_interrupt(int irq, void *dev_id)
 	struct fsc_state *state = (struct fsc_state *) dev_id;
 	struct mac53c94_regs __iomem *regs = state->regs;
 	struct dbdma_regs __iomem *dma = state->dma;
-	struct scsi_cmnd *cmd = state->current_req;
+	struct scsi_cmnd *const cmd = state->current_req;
+	struct scsi_pointer *const scsi_pointer = mac53c94_scsi_pointer(cmd);
 	int nb, stat, seq, intr;
 	static int mac53c94_errors;
 
@@ -263,10 +264,10 @@ static void mac53c94_interrupt(int irq, void *dev_id)
 		/* set DMA controller going if any data to transfer */
 		if ((stat & (STAT_MSG|STAT_CD)) == 0
 		    && (scsi_sg_count(cmd) > 0 || scsi_bufflen(cmd))) {
-			nb = cmd->SCp.this_residual;
+			nb = scsi_pointer->this_residual;
 			if (nb > 0xfff0)
 				nb = 0xfff0;
-			cmd->SCp.this_residual -= nb;
+			scsi_pointer->this_residual -= nb;
 			writeb(nb, &regs->count_lo);
 			writeb(nb >> 8, &regs->count_mid);
 			writeb(CMD_DMA_MODE + CMD_NOP, &regs->command);
@@ -293,13 +294,13 @@ static void mac53c94_interrupt(int irq, void *dev_id)
 			cmd_done(state, DID_ERROR << 16);
 			return;
 		}
-		if (cmd->SCp.this_residual != 0
+		if (scsi_pointer->this_residual != 0
 		    && (stat & (STAT_MSG|STAT_CD)) == 0) {
 			/* Set up the count regs to transfer more */
-			nb = cmd->SCp.this_residual;
+			nb = scsi_pointer->this_residual;
 			if (nb > 0xfff0)
 				nb = 0xfff0;
-			cmd->SCp.this_residual -= nb;
+			scsi_pointer->this_residual -= nb;
 			writeb(nb, &regs->count_lo);
 			writeb(nb >> 8, &regs->count_mid);
 			writeb(CMD_DMA_MODE + CMD_NOP, &regs->command);
@@ -321,8 +322,8 @@ static void mac53c94_interrupt(int irq, void *dev_id)
 			cmd_done(state, DID_ERROR << 16);
 			return;
 		}
-		cmd->SCp.Status = readb(&regs->fifo);
-		cmd->SCp.Message = readb(&regs->fifo);
+		scsi_pointer->Status = readb(&regs->fifo);
+		scsi_pointer->Message = readb(&regs->fifo);
 		writeb(CMD_ACCEPT_MSG, &regs->command);
 		state->phase = busfreeing;
 		break;
@@ -330,8 +331,8 @@ static void mac53c94_interrupt(int irq, void *dev_id)
 		if (intr != INTR_DISCONNECT) {
 			printk(KERN_DEBUG "got intr %x when expected disconnect\n", intr);
 		}
-		cmd_done(state, (DID_OK << 16) + (cmd->SCp.Message << 8)
-			 + cmd->SCp.Status);
+		cmd_done(state, (DID_OK << 16) + (scsi_pointer->Message << 8)
+			 + scsi_pointer->Status);
 		break;
 	default:
 		printk(KERN_DEBUG "don't know about phase %d\n", state->phase);
@@ -389,7 +390,7 @@ static void set_dma_cmds(struct fsc_state *state, struct scsi_cmnd *cmd)
 	dma_cmd += OUTPUT_LAST - OUTPUT_MORE;
 	dcmds[-1].command = cpu_to_le16(dma_cmd);
 	dcmds->command = cpu_to_le16(DBDMA_STOP);
-	cmd->SCp.this_residual = total;
+	mac53c94_scsi_pointer(cmd)->this_residual = total;
 }
 
 static struct scsi_host_template mac53c94_template = {
@@ -401,6 +402,7 @@ static struct scsi_host_template mac53c94_template = {
 	.this_id	= 7,
 	.sg_tablesize	= SG_ALL,
 	.max_segment_size = 65535,
+	.cmd_size	= sizeof(struct mac53c94_cmd_priv),
 };
 
 static int mac53c94_probe(struct macio_dev *mdev, const struct of_device_id *match)
diff --git a/drivers/scsi/mac53c94.h b/drivers/scsi/mac53c94.h
index 5df6e81f78a8..37d7d30f42ef 100644
--- a/drivers/scsi/mac53c94.h
+++ b/drivers/scsi/mac53c94.h
@@ -212,4 +212,15 @@ struct mac53c94_regs {
 #define CF4_TEST	0x02
 #define CF4_BBTE	0x01
 
+struct mac53c94_cmd_priv {
+	struct scsi_pointer scsi_pointer;
+};
+
+static inline struct scsi_pointer *mac53c94_scsi_pointer(struct scsi_cmnd *cmd)
+{
+	struct mac53c94_cmd_priv *mcmd = scsi_cmd_priv(cmd);
+
+	return &mcmd->scsi_pointer;
+}
+
 #endif /* _MAC53C94_H */
