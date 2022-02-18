Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F131C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 19:53:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238702AbiBRTxf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Feb 2022 14:53:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238665AbiBRTxZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Feb 2022 14:53:25 -0500
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C55D7E
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:53:00 -0800 (PST)
Received: by mail-pj1-f42.google.com with SMTP id h14-20020a17090a130e00b001b88991a305so13261830pja.3
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:53:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KZRyurWwIUCUHUSCOl7sC1WUzmpUgrP0RhTAYS0PbCg=;
        b=HQkkoHHFlaQeg5TWFLMoN+VL4LbP7BBIYNN9tND46eTtBg1JhdOpaDNKe776TkaITD
         y2ksmpEMVCqd7dXOocNAdiyUusdXFqcQThNbxMHXGtnCkFU4mpxiBx9/33EBrpwT75PD
         HHbChsU7AAv8ludojgmWQZ+TWxNd5V8YFC4dIoIY9CzuDXs+7YImGniJUetcaIpVxSPP
         US+z7sWv5kffa5CVeXcgdh3/sG3vYNeEa9TI3HjUXjjEcdWrDsp6cMXJZonPsUd9T2ZG
         kiLWuPRx4rprvn0zsWWYGQFXMQtJdP8VJGQzJqsTbQQuzMG5c3H0ejfekxkGPR4DOVfc
         TnyA==
X-Gm-Message-State: AOAM532rQ32NZot+EpDYdUsdlTq+r+/AQMqoQs77U1jJ+EQGMxaAhxZP
        8lhUajAcJ+AOQof7FG9wvws=
X-Google-Smtp-Source: ABdhPJwT0pkh3oysZB3dkOTazVBaV9s1YOevt+LzYaZX3m8IOIp5+6tYlNGpJRTbMVB97T3Syp9AbA==
X-Received: by 2002:a17:90a:de15:b0:1b5:9208:58b5 with SMTP id m21-20020a17090ade1500b001b5920858b5mr10110348pjv.142.1645213979548;
        Fri, 18 Feb 2022 11:52:59 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id e15sm3930523pfv.104.2022.02.18.11.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 11:52:58 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 39/49] scsi: sym53c500_cs: Move the SCSI pointer to private command data
Date:   Fri, 18 Feb 2022 11:51:07 -0800
Message-Id: <20220218195117.25689-40-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218195117.25689-1-bvanassche@acm.org>
References: <20220218195117.25689-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
from struct scsi_cmnd.
This patch prepares for removal of the SCSI pointer from struct scsi_cmnd.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/pcmcia/sym53c500_cs.c | 47 ++++++++++++++++++------------
 1 file changed, 29 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index fc93d2a57e1e..c4a838635893 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -192,6 +192,11 @@ struct sym53c500_data {
 	int fast_pio;
 };
 
+static struct scsi_pointer *sym53c500_scsi_pointer(struct scsi_cmnd *cmd)
+{
+	return scsi_cmd_priv(cmd);
+}
+
 enum Phase {
     idle,
     data_out,
@@ -351,6 +356,7 @@ SYM53C500_intr(int irq, void *dev_id)
 	struct sym53c500_data *data =
 	    (struct sym53c500_data *)dev->hostdata;
 	struct scsi_cmnd *curSC = data->current_SC;
+	struct scsi_pointer *scsi_pointer = sym53c500_scsi_pointer(curSC);
 	int fast_pio = data->fast_pio;
 
 	spin_lock_irqsave(dev->host_lock, flags);
@@ -397,11 +403,12 @@ SYM53C500_intr(int irq, void *dev_id)
 
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
@@ -412,7 +419,7 @@ SYM53C500_intr(int irq, void *dev_id)
 			struct scatterlist *sg;
 			int i;
 
-			curSC->SCp.phase = data_out;
+			scsi_pointer->phase = data_out;
 			VDEB(printk("SYM53C500: Data-Out phase\n"));
 			outb(FLUSH_FIFO, port_base + CMD_REG);
 			LOAD_DMA_COUNT(port_base, scsi_bufflen(curSC));	/* Max transfer size */
@@ -431,7 +438,7 @@ SYM53C500_intr(int irq, void *dev_id)
 			struct scatterlist *sg;
 			int i;
 
-			curSC->SCp.phase = data_in;
+			scsi_pointer->phase = data_in;
 			VDEB(printk("SYM53C500: Data-In phase\n"));
 			outb(FLUSH_FIFO, port_base + CMD_REG);
 			LOAD_DMA_COUNT(port_base, scsi_bufflen(curSC));	/* Max transfer size */
@@ -446,12 +453,12 @@ SYM53C500_intr(int irq, void *dev_id)
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
@@ -464,22 +471,24 @@ SYM53C500_intr(int irq, void *dev_id)
 
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
@@ -491,7 +500,7 @@ SYM53C500_intr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 
 idle_out:
-	curSC->SCp.phase = idle;
+	scsi_pointer->phase = idle;
 	scsi_done(curSC);
 	goto out;
 }
@@ -539,6 +548,7 @@ SYM53C500_info(struct Scsi_Host *SChost)
 
 static int SYM53C500_queue_lck(struct scsi_cmnd *SCpnt)
 {
+	struct scsi_pointer *scsi_pointer = sym53c500_scsi_pointer(SCpnt);
 	int i;
 	int port_base = SCpnt->device->host->io_port;
 	struct sym53c500_data *data =
@@ -555,9 +565,9 @@ static int SYM53C500_queue_lck(struct scsi_cmnd *SCpnt)
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
@@ -671,7 +681,8 @@ static struct scsi_host_template sym53c500_driver_template = {
      .can_queue			= 1,
      .this_id			= 7,
      .sg_tablesize		= 32,
-     .shost_groups		= SYM53C500_shost_groups
+     .shost_groups		= SYM53C500_shost_groups,
+     .cmd_size			= sizeof(struct scsi_pointer),
 };
 
 static int SYM53C500_config_check(struct pcmcia_device *p_dev, void *priv_data)
