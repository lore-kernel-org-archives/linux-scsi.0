Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2693C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 22:34:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354074AbiBKWeX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 17:34:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354147AbiBKWeM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 17:34:12 -0500
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1C0D54
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:34:10 -0800 (PST)
Received: by mail-pj1-f48.google.com with SMTP id t4-20020a17090a510400b001b8c4a6cd5dso10098906pjh.5
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:34:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RXFHg0yTOuB/QS7nUh7XRAJJPPSKx3N3iXfv6RVU628=;
        b=OdYpDsabQrdMjywwQm7XJDbqfMY2iGH2cU7tO0dzUfDtPWL5NNftcfl+US/sm8/VEC
         9Pq16ioranaljzf9AWsZv5HJAxlM29iwbbpEbsPWcrs9NBFBEQpeayT7u2u6q0ZpuFPi
         ksdKN2jD+QwVnuAhAjeE5u7DM7pAt4lM7bMzfHwiWYPdelqkd4h7Knj1d5psZ2sIhwia
         OWjqRx25SyCGMNfnf0JDw0wl0Izd6HeMBeUjyT4LZAhvhrt6u9QcrpbOcHrHIHnIzOCQ
         97OiOGImMqkjkWyGYbYKC80cro9gO6ist5eYJZ7hcvG/8nsvDwxPQ8OPPVu3lrM2D2LG
         ZYZg==
X-Gm-Message-State: AOAM5325L8uHUgBHjYhaWrcRse7dKI4C5NblJmRVRD5qdZpfkSfE2Lfr
        c/CaYkwXOHPhkKlZ99t73qrhPMuGEOJRwaVE
X-Google-Smtp-Source: ABdhPJxC3fPd/zlVWOkh1p0WIbDkvOGNqMb7tlR6QOqlxw/lLos4xNz5UOrauAmgMRITJDv8zikpNg==
X-Received: by 2002:a17:902:758d:: with SMTP id j13mr3597067pll.85.1644618850226;
        Fri, 11 Feb 2022 14:34:10 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id n13sm6296733pjq.13.2022.02.11.14.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 14:34:09 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 30/48] scsi: mac53c94: Move the SCSI pointer to private command data
Date:   Fri, 11 Feb 2022 14:32:29 -0800
Message-Id: <20220211223247.14369-31-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220211223247.14369-1-bvanassche@acm.org>
References: <20220211223247.14369-1-bvanassche@acm.org>
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
