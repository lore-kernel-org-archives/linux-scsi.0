Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E61A6C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 22:22:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351683AbiA1WWX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:22:23 -0500
Received: from mail-pj1-f54.google.com ([209.85.216.54]:39530 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351661AbiA1WV5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2022 17:21:57 -0500
Received: by mail-pj1-f54.google.com with SMTP id s61-20020a17090a69c300b001b4d0427ea2so12186145pjj.4
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2022 14:21:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AdHU4dX96HBqO4fojQ0ibYdJowkXtCdVxoEJIXS0QV4=;
        b=cW5Ub3w+Lq4VN9zf1FfpuuicxnBospuMreqdMuh7xgASRuhwbudkNECbzmG+9Z6ooT
         FT2QMrFtNZi237x6njsYNw9HuiYqR/NXPMfg7MQjEhlUY0vZqWSw5qntcYF/LxT0YFby
         uzBhsLUSSen8KDq3JZPAMlmJmhKSZpi2Hr93gzXzxW2xYe88DcGVWn4dNbqBXY1IbtGI
         +hv6mK15OGtVKMggJWUQgJQ7lntyQK4iJVq41HxTIjzdS3JqniSJ+i6PCtd8q6PCyzBy
         Q/X2NtlLCT/8jvILHaPsmEGGBuu+PdrLoKOd1Wdh0/ehPIgXOMhy0ZJNHgeiVkrMiujv
         MmTg==
X-Gm-Message-State: AOAM532wYxvv5c6ZkDNkdOp3O5oH5wKIpfO7zoBxRhZcvhxEg0ugg2nD
        4xYrehSVf/fgciEVdUIqr/5pWFvfOjYbZg==
X-Google-Smtp-Source: ABdhPJy7/h4/J0M6JP2cOmL7QuYx2AeLMaz3Y4nkPKvKctU8Jz5lzR1Lujce2PCVVbQ2HMMMWObFMQ==
X-Received: by 2002:a17:902:e88b:: with SMTP id w11mr10080409plg.153.1643408506201;
        Fri, 28 Jan 2022 14:21:46 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id t2sm7787931pfg.207.2022.01.28.14.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 14:21:45 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 35/44] ppa: Move the SCSI pointer to private command data
Date:   Fri, 28 Jan 2022 14:19:00 -0800
Message-Id: <20220128221909.8141-36-bvanassche@acm.org>
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
 drivers/scsi/ppa.c | 81 ++++++++++++++++++++++++++++------------------
 1 file changed, 49 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index 003043de23a5..ac948768eba4 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -45,6 +45,17 @@ typedef struct {
 
 #include  "ppa.h"
 
+struct ppa_cmd_priv {
+	struct scsi_pointer scsi_pointer;
+};
+
+static struct scsi_pointer *ppa_scsi_pointer(struct scsi_cmnd *cmd)
+{
+	struct ppa_cmd_priv *pcmd = scsi_cmd_priv(cmd);
+
+	return &pcmd->scsi_pointer;
+}
+	
 static inline ppa_struct *ppa_dev(struct Scsi_Host *host)
 {
 	return *(ppa_struct **)&host->hostdata;
@@ -56,7 +67,7 @@ static void got_it(ppa_struct *dev)
 {
 	dev->base = dev->dev->port->base;
 	if (dev->cur_cmd)
-		dev->cur_cmd->SCp.phase = 1;
+		ppa_scsi_pointer(dev->cur_cmd)->phase = 1;
 	else
 		wake_up(dev->waiting);
 }
@@ -511,13 +522,14 @@ static inline int ppa_send_command(struct scsi_cmnd *cmd)
  * The driver appears to remain stable if we speed up the parallel port
  * i/o in this function, but not elsewhere.
  */
-static int ppa_completion(struct scsi_cmnd *cmd)
+static int ppa_completion(struct scsi_cmnd *const cmd)
 {
 	/* Return codes:
 	 * -1     Error
 	 *  0     Told to schedule
 	 *  1     Finished data transfer
 	 */
+	struct scsi_pointer *scsi_pointer = ppa_scsi_pointer(cmd);
 	ppa_struct *dev = ppa_dev(cmd->device->host);
 	unsigned short ppb = dev->base;
 	unsigned long start_jiffies = jiffies;
@@ -543,7 +555,7 @@ static int ppa_completion(struct scsi_cmnd *cmd)
 		if (time_after(jiffies, start_jiffies + 1))
 			return 0;
 
-		if ((cmd->SCp.this_residual <= 0)) {
+		if (scsi_pointer->this_residual <= 0) {
 			ppa_fail(dev, DID_ERROR);
 			return -1;	/* ERROR_RETURN */
 		}
@@ -572,28 +584,30 @@ static int ppa_completion(struct scsi_cmnd *cmd)
 		}
 
 		/* determine if we should use burst I/O */
-		fast = (bulk && (cmd->SCp.this_residual >= PPA_BURST_SIZE))
-		    ? PPA_BURST_SIZE : 1;
+		fast = bulk && scsi_pointer->this_residual >= PPA_BURST_SIZE ?
+			PPA_BURST_SIZE : 1;
 
 		if (r == (unsigned char) 0xc0)
-			status = ppa_out(dev, cmd->SCp.ptr, fast);
+			status = ppa_out(dev, scsi_pointer->ptr, fast);
 		else
-			status = ppa_in(dev, cmd->SCp.ptr, fast);
+			status = ppa_in(dev, scsi_pointer->ptr, fast);
 
-		cmd->SCp.ptr += fast;
-		cmd->SCp.this_residual -= fast;
+		scsi_pointer->ptr += fast;
+		scsi_pointer->this_residual -= fast;
 
 		if (!status) {
 			ppa_fail(dev, DID_BUS_BUSY);
 			return -1;	/* ERROR_RETURN */
 		}
-		if (cmd->SCp.buffer && !cmd->SCp.this_residual) {
+		if (scsi_pointer->buffer && !scsi_pointer->this_residual) {
 			/* if scatter/gather, advance to the next segment */
-			if (cmd->SCp.buffers_residual--) {
-				cmd->SCp.buffer = sg_next(cmd->SCp.buffer);
-				cmd->SCp.this_residual =
-				    cmd->SCp.buffer->length;
-				cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
+			if (scsi_pointer->buffers_residual--) {
+				scsi_pointer->buffer =
+					sg_next(scsi_pointer->buffer);
+				scsi_pointer->this_residual =
+				    scsi_pointer->buffer->length;
+				scsi_pointer->ptr =
+					sg_virt(scsi_pointer->buffer);
 			}
 		}
 		/* Now check to see if the drive is ready to comunicate */
@@ -658,7 +672,7 @@ static void ppa_interrupt(struct work_struct *work)
 	}
 #endif
 
-	if (cmd->SCp.phase > 1)
+	if (ppa_scsi_pointer(cmd)->phase > 1)
 		ppa_disconnect(dev);
 
 	ppa_pb_dismiss(dev);
@@ -670,6 +684,7 @@ static void ppa_interrupt(struct work_struct *work)
 
 static int ppa_engine(ppa_struct *dev, struct scsi_cmnd *cmd)
 {
+	struct scsi_pointer *scsi_pointer = ppa_scsi_pointer(cmd);
 	unsigned short ppb = dev->base;
 	unsigned char l = 0, h = 0;
 	int retv;
@@ -680,7 +695,7 @@ static int ppa_engine(ppa_struct *dev, struct scsi_cmnd *cmd)
 	if (dev->failed)
 		return 0;
 
-	switch (cmd->SCp.phase) {
+	switch (scsi_pointer->phase) {
 	case 0:		/* Phase 0 - Waiting for parport */
 		if (time_after(jiffies, dev->jstart + HZ)) {
 			/*
@@ -715,7 +730,7 @@ static int ppa_engine(ppa_struct *dev, struct scsi_cmnd *cmd)
 					return 1;	/* Try again in a jiffy */
 				}
 			}
-			cmd->SCp.phase++;
+			scsi_pointer->phase++;
 		}
 		fallthrough;
 
@@ -724,7 +739,7 @@ static int ppa_engine(ppa_struct *dev, struct scsi_cmnd *cmd)
 			ppa_fail(dev, DID_NO_CONNECT);
 			return 0;
 		}
-		cmd->SCp.phase++;
+		scsi_pointer->phase++;
 		fallthrough;
 
 	case 3:		/* Phase 3 - Ready to accept a command */
@@ -734,21 +749,22 @@ static int ppa_engine(ppa_struct *dev, struct scsi_cmnd *cmd)
 
 		if (!ppa_send_command(cmd))
 			return 0;
-		cmd->SCp.phase++;
+		scsi_pointer->phase++;
 		fallthrough;
 
 	case 4:		/* Phase 4 - Setup scatter/gather buffers */
 		if (scsi_bufflen(cmd)) {
-			cmd->SCp.buffer = scsi_sglist(cmd);
-			cmd->SCp.this_residual = cmd->SCp.buffer->length;
-			cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
+			scsi_pointer->buffer = scsi_sglist(cmd);
+			scsi_pointer->this_residual =
+				scsi_pointer->buffer->length;
+			scsi_pointer->ptr = sg_virt(scsi_pointer->buffer);
 		} else {
-			cmd->SCp.buffer = NULL;
-			cmd->SCp.this_residual = 0;
-			cmd->SCp.ptr = NULL;
+			scsi_pointer->buffer = NULL;
+			scsi_pointer->this_residual = 0;
+			scsi_pointer->ptr = NULL;
 		}
-		cmd->SCp.buffers_residual = scsi_sg_count(cmd) - 1;
-		cmd->SCp.phase++;
+		scsi_pointer->buffers_residual = scsi_sg_count(cmd) - 1;
+		scsi_pointer->phase++;
 		fallthrough;
 
 	case 5:		/* Phase 5 - Data transfer stage */
@@ -761,7 +777,7 @@ static int ppa_engine(ppa_struct *dev, struct scsi_cmnd *cmd)
 			return 0;
 		if (retv == 0)
 			return 1;
-		cmd->SCp.phase++;
+		scsi_pointer->phase++;
 		fallthrough;
 
 	case 6:		/* Phase 6 - Read status/message */
@@ -798,7 +814,7 @@ static int ppa_queuecommand_lck(struct scsi_cmnd *cmd)
 	dev->jstart = jiffies;
 	dev->cur_cmd = cmd;
 	cmd->result = DID_ERROR << 16;	/* default return code */
-	cmd->SCp.phase = 0;	/* bus free */
+	ppa_scsi_pointer(cmd)->phase = 0;	/* bus free */
 
 	schedule_delayed_work(&dev->ppa_tq, 0);
 
@@ -839,7 +855,7 @@ static int ppa_abort(struct scsi_cmnd *cmd)
 	 * have tied the SCSI_MESSAGE line high in the interface
 	 */
 
-	switch (cmd->SCp.phase) {
+	switch (ppa_scsi_pointer(cmd)->phase) {
 	case 0:		/* Do not have access to parport */
 	case 1:		/* Have not connected to interface */
 		dev->cur_cmd = NULL;	/* Forget the problem */
@@ -861,7 +877,7 @@ static int ppa_reset(struct scsi_cmnd *cmd)
 {
 	ppa_struct *dev = ppa_dev(cmd->device->host);
 
-	if (cmd->SCp.phase)
+	if (ppa_scsi_pointer(cmd)->phase)
 		ppa_disconnect(dev);
 	dev->cur_cmd = NULL;	/* Forget the problem */
 
@@ -976,6 +992,7 @@ static struct scsi_host_template ppa_template = {
 	.sg_tablesize		= SG_ALL,
 	.can_queue		= 1,
 	.slave_alloc		= ppa_adjust_queue,
+	.cmd_size		= sizeof(struct ppa_cmd_priv),
 };
 
 /***************************************************************************
