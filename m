Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80020C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 22:22:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236526AbiA1WWN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:22:13 -0500
Received: from mail-pg1-f181.google.com ([209.85.215.181]:43707 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351677AbiA1WV6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2022 17:21:58 -0500
Received: by mail-pg1-f181.google.com with SMTP id g20so6429327pgn.10
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2022 14:21:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nQ1L2wXLILnkkrX5BNdMXNA9ZomwHg5ohZ3kGqHOpG0=;
        b=lOfJ2umzh2bPHPf6SjWZNtUEkAcEW4hvyIh6vkYREU63bkm1p/JWIKzeT6nLz7Qyrc
         upm1YEV6rO9aOyLEIEaFraOPCqMYQi1ApK0Hj/zqBNHbJrTqnqOMFoB5mfxEsG3MS1HS
         O7gKqQn6JXyGavq2OR5H8Bf66ou6JzMRMr755U/66bBzyNjxjGfEurGCt4F5atBc/4cJ
         1Wby0kSeArxVko24Zylw4Vl4XikBvQtIVGy1qRTBPknG55crcBHpiwo7OTnKpEI4e4kK
         QU3xyMDQIBsOYUF/6eXid1BNsUod8xMimpRqPMU4Ws0yGR0f5z3RUtk9THkBa9PnLG2s
         aldw==
X-Gm-Message-State: AOAM532Azdz9J5jUXEGRKdFc2SyD2MkVWEkOludkwaZNGT8YgaChvoVX
        jTuLbykjGIztzzaSLGHQuHQ=
X-Google-Smtp-Source: ABdhPJynyIR4XO1Daauc6/3q4vrjt8MIJN4rTkNqry38fHsh6MRjP2h3NY06Aap0nOIEp+D603EzEQ==
X-Received: by 2002:a62:1dcc:: with SMTP id d195mr10425614pfd.4.1643408504630;
        Fri, 28 Jan 2022 14:21:44 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id t2sm7787931pfg.207.2022.01.28.14.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 14:21:43 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 34/44] sym53c500_cs: Move the SCSI pointer to private command data
Date:   Fri, 28 Jan 2022 14:18:59 -0800
Message-Id: <20220128221909.8141-35-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128221909.8141-1-bvanassche@acm.org>
References: <20220128221909.8141-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
from struct scsi_cmnd.
This patch prepares for removal of the SCSI pointer from struct scsi_cmnd.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/pcmcia/sym53c500_cs.c | 53 ++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index fc93d2a57e1e..298df2180bc7 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -192,6 +192,17 @@ struct sym53c500_data {
 	int fast_pio;
 };
 
+struct sym53c500_cmd_priv {
+	struct scsi_pointer scsi_pointer;
+};
+
+static struct scsi_pointer *sym53c500_scsi_pointer(struct scsi_cmnd *cmd)
+{
+	struct sym53c500_cmd_priv *scmd = scsi_cmd_priv(cmd);
+
+	return &scmd->scsi_pointer;
+}
+
 enum Phase {
     idle,
     data_out,
@@ -351,6 +362,7 @@ SYM53C500_intr(int irq, void *dev_id)
 	struct sym53c500_data *data =
 	    (struct sym53c500_data *)dev->hostdata;
 	struct scsi_cmnd *curSC = data->current_SC;
+	struct scsi_pointer *scsi_pointer = sym53c500_scsi_pointer(curSC);
 	int fast_pio = data->fast_pio;
 
 	spin_lock_irqsave(dev->host_lock, flags);
@@ -397,11 +409,12 @@ SYM53C500_intr(int irq, void *dev_id)
 
 	if (int_reg & 0x20) {		/* Disconnect */
 		DEB(printk("SYM53C500: disconnect intr received\n"));
-		if (curSC->SCp.phase != message_in) {	/* Unexpected disconnect */
+		if (scsi_pointer->phase != message_in) {	/* Unexpected disconnect */
 			curSC->result = DID_NO_CONNECT << 16;
 		} else {	/* Command complete, return status and message */
-			curSC->result = (curSC->SCp.Status & 0xff)
-			    | ((curSC->SCp.Message & 0xff) << 8) | (DID_OK << 16);
+			curSC->result = (scsi_pointer->Status & 0xff) |
+				((scsi_pointer->Message & 0xff) << 8) |
+				(DID_OK << 16);
 		}
 		goto idle_out;
 	}
@@ -412,7 +425,7 @@ SYM53C500_intr(int irq, void *dev_id)
 			struct scatterlist *sg;
 			int i;
 
-			curSC->SCp.phase = data_out;
+			scsi_pointer->phase = data_out;
 			VDEB(printk("SYM53C500: Data-Out phase\n"));
 			outb(FLUSH_FIFO, port_base + CMD_REG);
 			LOAD_DMA_COUNT(port_base, scsi_bufflen(curSC));	/* Max transfer size */
@@ -431,7 +444,7 @@ SYM53C500_intr(int irq, void *dev_id)
 			struct scatterlist *sg;
 			int i;
 
-			curSC->SCp.phase = data_in;
+			scsi_pointer->phase = data_in;
 			VDEB(printk("SYM53C500: Data-In phase\n"));
 			outb(FLUSH_FIFO, port_base + CMD_REG);
 			LOAD_DMA_COUNT(port_base, scsi_bufflen(curSC));	/* Max transfer size */
@@ -446,12 +459,12 @@ SYM53C500_intr(int irq, void *dev_id)
 		break;
 
 	case 0x02:		/* COMMAND */
-		curSC->SCp.phase = command_ph;
+		scsi_pointer->phase = command_ph;
 		printk("SYM53C500: Warning: Unknown interrupt occurred in command phase!\n");
 		break;
 
 	case 0x03:		/* STATUS */
-		curSC->SCp.phase = status_ph;
+		scsi_pointer->phase = status_ph;
 		VDEB(printk("SYM53C500: Status phase\n"));
 		outb(FLUSH_FIFO, port_base + CMD_REG);
 		outb(INIT_CMD_COMPLETE, port_base + CMD_REG);
@@ -464,22 +477,24 @@ SYM53C500_intr(int irq, void *dev_id)
 
 	case 0x06:		/* MESSAGE-OUT */
 		DEB(printk("SYM53C500: Message-Out phase\n"));
-		curSC->SCp.phase = message_out;
+		scsi_pointer->phase = message_out;
 		outb(SET_ATN, port_base + CMD_REG);	/* Reject the message */
 		outb(MSG_ACCEPT, port_base + CMD_REG);
 		break;
 
 	case 0x07:		/* MESSAGE-IN */
 		VDEB(printk("SYM53C500: Message-In phase\n"));
-		curSC->SCp.phase = message_in;
+		scsi_pointer->phase = message_in;
 
-		curSC->SCp.Status = inb(port_base + SCSI_FIFO);
-		curSC->SCp.Message = inb(port_base + SCSI_FIFO);
+		scsi_pointer->Status = inb(port_base + SCSI_FIFO);
+		scsi_pointer->Message = inb(port_base + SCSI_FIFO);
 
 		VDEB(printk("SCSI FIFO size=%d\n", inb(port_base + FIFO_FLAGS) & 0x1f));
-		DEB(printk("Status = %02x  Message = %02x\n", curSC->SCp.Status, curSC->SCp.Message));
+		DEB(printk("Status = %02x  Message = %02x\n",
+			   scsi_pointer->Status, scsi_pointer->Message));
 
-		if (curSC->SCp.Message == SAVE_POINTERS || curSC->SCp.Message == DISCONNECT) {
+		if (scsi_pointer->Message == SAVE_POINTERS ||
+		    scsi_pointer->Message == DISCONNECT) {
 			outb(SET_ATN, port_base + CMD_REG);	/* Reject message */
 			DEB(printk("Discarding SAVE_POINTERS message\n"));
 		}
@@ -491,7 +506,7 @@ SYM53C500_intr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 
 idle_out:
-	curSC->SCp.phase = idle;
+	scsi_pointer->phase = idle;
 	scsi_done(curSC);
 	goto out;
 }
@@ -539,6 +554,7 @@ SYM53C500_info(struct Scsi_Host *SChost)
 
 static int SYM53C500_queue_lck(struct scsi_cmnd *SCpnt)
 {
+	struct scsi_pointer *scsi_pointer = sym53c500_scsi_pointer(SCpnt);
 	int i;
 	int port_base = SCpnt->device->host->io_port;
 	struct sym53c500_data *data =
@@ -555,9 +571,9 @@ static int SYM53C500_queue_lck(struct scsi_cmnd *SCpnt)
 	VDEB(printk("\n"));
 
 	data->current_SC = SCpnt;
-	data->current_SC->SCp.phase = command_ph;
-	data->current_SC->SCp.Status = 0;
-	data->current_SC->SCp.Message = 0;
+	scsi_pointer->phase = command_ph;
+	scsi_pointer->Status = 0;
+	scsi_pointer->Message = 0;
 
 	/* We are locked here already by the mid layer */
 	REG0(port_base);
@@ -671,7 +687,8 @@ static struct scsi_host_template sym53c500_driver_template = {
      .can_queue			= 1,
      .this_id			= 7,
      .sg_tablesize		= 32,
-     .shost_groups		= SYM53C500_shost_groups
+     .shost_groups		= SYM53C500_shost_groups,
+     .cmd_size			= sizeof(struct sym53c500_cmd_priv),
 };
 
 static int SYM53C500_config_check(struct pcmcia_device *p_dev, void *priv_data)
