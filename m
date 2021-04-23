Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A67FFC43470
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 11:40:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E9BF61139
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 11:40:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242389AbhDWLlA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Apr 2021 07:41:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:46954 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242267AbhDWLkl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Apr 2021 07:40:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 83DB8B1D2;
        Fri, 23 Apr 2021 11:39:55 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Bart van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 19/39] qlogicfas408: make ql_pcmd() a void function
Date:   Fri, 23 Apr 2021 13:39:24 +0200
Message-Id: <20210423113944.42672-20-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210423113944.42672-1-hare@suse.de>
References: <20210423113944.42672-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make ql_pcmd() a void function and set the SCSI result directly.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/qlogicfas408.c | 75 ++++++++++++++++++++++++-------------
 1 file changed, 49 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/qlogicfas408.c
index 136681ad18a5..a1eabdc7db09 100644
--- a/drivers/scsi/qlogicfas408.c
+++ b/drivers/scsi/qlogicfas408.c
@@ -256,7 +256,7 @@ static void ql_icmd(struct scsi_cmnd *cmd)
  *	Process scsi command - usually after interrupt 
  */
 
-static unsigned int ql_pcmd(struct scsi_cmnd *cmd)
+static void ql_pcmd(struct scsi_cmnd *cmd)
 {
 	unsigned int i, j;
 	unsigned long k;
@@ -274,13 +274,15 @@ static unsigned int ql_pcmd(struct scsi_cmnd *cmd)
 	j = inb(qbase + 6);
 	i = inb(qbase + 5);
 	if (i == 0x20) {
-		return (DID_NO_CONNECT << 16);
+		set_host_byte(cmd, DID_NO_CONNECT);
+		return;
 	}
 	i |= inb(qbase + 5);	/* the 0x10 bit can be set after the 0x08 */
 	if (i != 0x18) {
 		printk(KERN_ERR "Ql:Bad Interrupt status:%02x\n", i);
 		ql_zap(priv);
-		return (DID_BAD_INTR << 16);
+		set_host_byte(cmd, DID_BAD_INTR);
+		return;
 	}
 	j &= 7;			/* j = inb( qbase + 7 ) >> 5; */
 
@@ -293,9 +295,10 @@ static unsigned int ql_pcmd(struct scsi_cmnd *cmd)
 		printk(KERN_ERR "Ql:Bad sequence for command %d, int %02X, cmdleft = %d\n",
 		     j, i, inb(qbase + 7) & 0x1f);
 		ql_zap(priv);
-		return (DID_ERROR << 16);
+		set_host_byte (cmd, DID_ERROR);
+		return;
 	}
-	result = DID_OK;
+
 	if (inb(qbase + 7) & 0x1f)	/* if some bytes in fifo */
 		outb(1, qbase + 3);	/* clear fifo */
 	/* note that request_bufflen is the total xfer size when sg is used */
@@ -314,21 +317,24 @@ static unsigned int ql_pcmd(struct scsi_cmnd *cmd)
 		scsi_for_each_sg(cmd, sg, scsi_sg_count(cmd), i) {
 			if (priv->qabort) {
 				REG0;
-				return ((priv->qabort == 1 ?
-					 DID_ABORT : DID_RESET) << 16);
+				set_host_byte(cmd,
+					      priv->qabort == 1 ?
+					      DID_ABORT : DID_RESET);
 			}
 			buf = sg_virt(sg);
 			if (ql_pdma(priv, phase, buf, sg->length))
 				break;
 		}
 		REG0;
-		rtrc(2)
+		rtrc(2);
 		/*
 		 *	Wait for irq (split into second state of irq handler
 		 *	if this can take time) 
 		 */
-		if ((k = ql_wai(priv)))
-			return (k << 16);
+		if ((k = ql_wai(priv))) {
+			set_host_byte(cmd, k);
+			return;
+		}
 		k = inb(qbase + 5);	/* should be 0x10, bus service */
 	}
 
@@ -344,19 +350,25 @@ static unsigned int ql_pcmd(struct scsi_cmnd *cmd)
 
 	if (time_after_eq(jiffies, k)) {
 		ql_zap(priv);
-		return (DID_TIME_OUT << 16);
+		set_host_byte(cmd, DID_TIME_OUT);
+		return;
 	}
 
 	/* FIXME: timeout ?? */
 	while (inb(qbase + 5))
 		cpu_relax();	/* clear pending ints */
 
-	if (priv->qabort)
-		return ((priv->qabort == 1 ? DID_ABORT : DID_RESET) << 16);
+	if (priv->qabort) {
+		set_host_byte(cmd,
+			      priv->qabort == 1 ? DID_ABORT : DID_RESET);
+		return;
+	}
 
 	outb(0x11, qbase + 3);	/* get status and message */
-	if ((k = ql_wai(priv)))
-		return (k << 16);
+	if ((k = ql_wai(priv))) {
+		set_host_byte(cmd, k);
+		return;
+	}
 	i = inb(qbase + 5);	/* get chip irq stat */
 	j = inb(qbase + 7) & 0x1f;	/* and bytes rec'd */
 	status = inb(qbase + 2);
@@ -368,12 +380,14 @@ static unsigned int ql_pcmd(struct scsi_cmnd *cmd)
 	 */
 	if (!((i == 8 && j == 2) || (i == 0x10 && j == 1))) {
 		printk(KERN_ERR "Ql:Error during status phase, int=%02X, %d bytes recd\n", i, j);
-		result = DID_ERROR;
+		set_host_byte(cmd, DID_ERROR);
 	}
 	outb(0x12, qbase + 3);	/* done, disconnect */
-	rtrc(1)
-	if ((k = ql_wai(priv)))
-		return (k << 16);
+	rtrc(1);
+	if ((k = ql_wai(priv))) {
+		set_host_byte(cmd, k);
+		return;
+	}
 
 	/*
 	 *	Should get bus service interrupt and disconnect interrupt 
@@ -385,12 +399,18 @@ static unsigned int ql_pcmd(struct scsi_cmnd *cmd)
 		cpu_relax();
 		i |= inb(qbase + 5);
 	}
-	rtrc(0)
+	rtrc(0);
 
-	if (priv->qabort)
-		return ((priv->qabort == 1 ? DID_ABORT : DID_RESET) << 16);
-		
-	return (result << 16) | (message << 8) | (status & STATUS_MASK);
+	if (priv->qabort) {
+		set_host_byte(cmd,
+			      priv->qabort == 1 ? DID_ABORT : DID_RESET);
+		return;
+	}
+
+	set_host_byte(cmd, result);
+	set_msg_byte(cmd, message);
+	set_status_byte(cmd, status);
+	return;
 }
 
 /*
@@ -415,7 +435,7 @@ static void ql_ihandl(void *dev_id)
 		return;
 	}
 	icmd = priv->qlcmd;
-	icmd->result = ql_pcmd(icmd);
+	ql_pcmd(icmd);
 	priv->qlcmd = NULL;
 	/*
 	 *	If result is CHECK CONDITION done calls qcommand to request 
@@ -443,8 +463,11 @@ static int qlogicfas408_queuecommand_lck(struct scsi_cmnd *cmd,
 			      void (*done) (struct scsi_cmnd *))
 {
 	struct qlogicfas408_priv *priv = get_priv_by_cmd(cmd);
+
+	set_host_byte(cmd, DID_OK);
+	set_status_byte(cmd, SAM_STAT_GOOD);
 	if (scmd_id(cmd) == priv->qinitid) {
-		cmd->result = DID_BAD_TARGET << 16;
+		set_host_byte(cmd, DID_BAD_TARGET);
 		done(cmd);
 		return 0;
 	}
-- 
2.29.2

