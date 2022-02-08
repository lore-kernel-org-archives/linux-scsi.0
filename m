Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67178C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 17:27:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352745AbiBHR1F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 12:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384336AbiBHR0w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 12:26:52 -0500
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077AFC0612BB
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 09:26:47 -0800 (PST)
Received: by mail-pj1-f49.google.com with SMTP id y15-20020a17090a474f00b001b88562650aso1987794pjg.0
        for <linux-scsi@vger.kernel.org>; Tue, 08 Feb 2022 09:26:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qaoXDEZKx9bCyY0KCzfjRftCMBs3KuwbbUIBct9+aHo=;
        b=d26cG8KOydhZnbHa1h9ZnpkSopKZQr6TcZzxH/Y3RC5fiE9KpNsM5o3LaGcjvacHJ6
         aafNwGzao8qeicgLaWTbMiX0CY7vjQYB2iYYUrumfiaav0n3vz6SqLM+87LlvdFs7d2g
         FkKOtdk18XYWIuMnuFhTdFcbLN/2ZyvOGJWiljvj2tz3YvRCF90ZjhFwnmZARiYqGa2v
         bN7GIOymkglwjUmMYLdsVN63ijKKSbbTvu4nWL5vWGjKCLUQEBEdhSI5EWoC1Af73OIW
         TXIMbfGv4CZgSbv5cBOsuw7BiEtR58NGuF7KuD+SFZpGiKMEtP0YoJxLg97LEDiztOwq
         VcTA==
X-Gm-Message-State: AOAM531k/vZk1Mea7wjWLNgTNlySHq/oCty743+gUhXuKaL/oYg5bbLq
        dWgJlh970Gu4F5IQ1AiR2jCkAs4CXIq48pN2
X-Google-Smtp-Source: ABdhPJzvFmUWWoOUrmPho0otJJPyVEk1j/nCAqQclKtJDvJ4O6tmblnnkye2oKhU4S/e3W4OhJY3RA==
X-Received: by 2002:a17:902:6902:: with SMTP id j2mr5648929plk.141.1644341206367;
        Tue, 08 Feb 2022 09:26:46 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q1sm335116pfs.112.2022.02.08.09.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 09:26:45 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 34/44] sym53c500_cs: Move the SCSI pointer to private command data
Date:   Tue,  8 Feb 2022 09:25:04 -0800
Message-Id: <20220208172514.3481-35-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220208172514.3481-1-bvanassche@acm.org>
References: <20220208172514.3481-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
from struct scsi_cmnd.
This patch prepares for removal of the SCSI pointer from struct scsi_cmnd.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
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
