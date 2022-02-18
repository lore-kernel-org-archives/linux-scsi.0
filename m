Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3857EC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 19:53:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238422AbiBRTxU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Feb 2022 14:53:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238354AbiBRTxO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Feb 2022 14:53:14 -0500
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05BFC293B4F
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:52:37 -0800 (PST)
Received: by mail-pg1-f180.google.com with SMTP id 27so3525260pgk.10
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:52:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RXFHg0yTOuB/QS7nUh7XRAJJPPSKx3N3iXfv6RVU628=;
        b=tMjuSE2SUCnUPxlNmzVn5dLMYE/JwaZDQKyXDkSNHiUjGefmRWwXmPovbSRFZMZGuT
         lOPQxfC+BWZ5ThE1w+1oFUafe8H84CR+iS4zOyAY7ofVxEISHoWsVbhQ8Rq53Fu2t0og
         PolX6CixKiNuRU4W3yu2QMGCEeiXJ4FRgVgK1A7ei3G2uT9YND21xFWG3kXRRNeGAwpE
         OdqV017HcYnYVIunm8lVXUovdLt8yLqagOdRtpX1LWa9HTE4bwTALwDlIG9Dnh/3ktuD
         Ng63VSIvsRhgHDln7lqacQW99w4gybjQ4GoI4BXwsfSbiTBk7vRhTGG0u+vIQVeEgW3t
         0Jog==
X-Gm-Message-State: AOAM5305tAhJX4EM3Wzs5ofMRGS3yTEIfGG4mCLP09Jwz4OZNMxt+ewI
        6iOxL8XYgfJljJmUXLEupGk=
X-Google-Smtp-Source: ABdhPJxT0rVKvIY1F5QMO5bMeAF+/gWKqHC+cOrEaQ/m0gCTL1nz/nVB1pdtGBYnCK19+5jAovT9ZQ==
X-Received: by 2002:a05:6a00:2296:b0:4e1:905f:46b6 with SMTP id f22-20020a056a00229600b004e1905f46b6mr9418813pfe.16.1645213956209;
        Fri, 18 Feb 2022 11:52:36 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id e15sm3930523pfv.104.2022.02.18.11.52.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 11:52:35 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 31/49] scsi: mac53c94: Move the SCSI pointer to private command data
Date:   Fri, 18 Feb 2022 11:50:59 -0800
Message-Id: <20220218195117.25689-32-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218195117.25689-1-bvanassche@acm.org>
References: <20220218195117.25689-1-bvanassche@acm.org>
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
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mac53c94.c | 24 +++++++++++++-----------
 drivers/scsi/mac53c94.h | 11 +++++++++++
 2 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
index afa08309de36..f3005b38931f 100644
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
