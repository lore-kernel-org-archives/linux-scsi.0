Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44F0CC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 19:52:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238510AbiBRTwu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Feb 2022 14:52:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238444AbiBRTwl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Feb 2022 14:52:41 -0500
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510A7291F99
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:52:20 -0800 (PST)
Received: by mail-pf1-f178.google.com with SMTP id i6so3122743pfc.9
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:52:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yQ+qPRmpV+XDb0VWxemarBzaOzx41XEbKJUiDIXT3Aw=;
        b=Y6TT1ZMarD7+wEA0pCssOx92oKewXw1GP7oqcO5LP4mFrdK+OxidnePxaWVBGwJCJc
         04XMSWQlx4P2zCE4pE0abSQspyvlguzd+jMFdF5OMbVgRp/xLQG1rkglyVvHmL2bUIqP
         0CiS30XmJBHb3Omy1pJcTXH5SBoUuVnPyy2LM63QTrvcVXRxqoYCgsAse5lMCKPW4dV9
         v1u0cLgH8MlAnYiOnrIE7Or1HDWdTj4/8PSh0qxtAgPrRZ8ZZ5BejJ+Wb0/NdeH4NCXd
         38ZSy9Hy0hiG6xhRDYrjKkWyRwYM7WQTbZrCEYzS67f4PrLN6PNjz8PLXtHjRwkNyiYV
         txYg==
X-Gm-Message-State: AOAM531deADJ8tPSVPl9cfFgiHfHubCtUzPxa/muDpFGoTA3fOdjOrhw
        o32qhO6K7J7VpbV5PoKzRrs=
X-Google-Smtp-Source: ABdhPJwpmixE5k9+eLzkvpXV5NiynKFS94Ar1oL+fREpSa+IlRxMmxXtinOMLvmMl+EWauMbcdU6uA==
X-Received: by 2002:a05:6a00:130b:b0:4e0:e4cb:8a0e with SMTP id j11-20020a056a00130b00b004e0e4cb8a0emr9294375pfu.19.1645213939654;
        Fri, 18 Feb 2022 11:52:19 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id e15sm3930523pfv.104.2022.02.18.11.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 11:52:18 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 24/49] scsi: imm: Move the SCSI pointer to private command data
Date:   Fri, 18 Feb 2022 11:50:52 -0800
Message-Id: <20220218195117.25689-25-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218195117.25689-1-bvanassche@acm.org>
References: <20220218195117.25689-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template instead of using the SCSI pointer.
This patch prepares for removal of the SCSI pointer from struct scsi_cmnd.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/imm.c | 88 ++++++++++++++++++++++++----------------------
 drivers/scsi/imm.h |  5 +++
 2 files changed, 50 insertions(+), 43 deletions(-)

diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 8afdb4dba2be..7a499d621c25 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -66,7 +66,7 @@ static void got_it(imm_struct *dev)
 {
 	dev->base = dev->dev->port->base;
 	if (dev->cur_cmd)
-		dev->cur_cmd->SCp.phase = 1;
+		imm_scsi_pointer(dev->cur_cmd)->phase = 1;
 	else
 		wake_up(dev->waiting);
 }
@@ -618,13 +618,14 @@ static inline int imm_send_command(struct scsi_cmnd *cmd)
  * The driver appears to remain stable if we speed up the parallel port
  * i/o in this function, but not elsewhere.
  */
-static int imm_completion(struct scsi_cmnd *cmd)
+static int imm_completion(struct scsi_cmnd *const cmd)
 {
 	/* Return codes:
 	 * -1     Error
 	 *  0     Told to schedule
 	 *  1     Finished data transfer
 	 */
+	struct scsi_pointer *scsi_pointer = imm_scsi_pointer(cmd);
 	imm_struct *dev = imm_dev(cmd->device->host);
 	unsigned short ppb = dev->base;
 	unsigned long start_jiffies = jiffies;
@@ -660,44 +661,43 @@ static int imm_completion(struct scsi_cmnd *cmd)
 		 * a) Drive status is screwy (!ready && !present)
 		 * b) Drive is requesting/sending more data than expected
 		 */
-		if (((r & 0x88) != 0x88) || (cmd->SCp.this_residual <= 0)) {
+		if ((r & 0x88) != 0x88 || scsi_pointer->this_residual <= 0) {
 			imm_fail(dev, DID_ERROR);
 			return -1;	/* ERROR_RETURN */
 		}
 		/* determine if we should use burst I/O */
 		if (dev->rd == 0) {
-			fast = (bulk
-				&& (cmd->SCp.this_residual >=
-				    IMM_BURST_SIZE)) ? IMM_BURST_SIZE : 2;
-			status = imm_out(dev, cmd->SCp.ptr, fast);
+			fast = bulk && scsi_pointer->this_residual >=
+				IMM_BURST_SIZE ? IMM_BURST_SIZE : 2;
+			status = imm_out(dev, scsi_pointer->ptr, fast);
 		} else {
-			fast = (bulk
-				&& (cmd->SCp.this_residual >=
-				    IMM_BURST_SIZE)) ? IMM_BURST_SIZE : 1;
-			status = imm_in(dev, cmd->SCp.ptr, fast);
+			fast = bulk && scsi_pointer->this_residual >=
+				IMM_BURST_SIZE ? IMM_BURST_SIZE : 1;
+			status = imm_in(dev, scsi_pointer->ptr, fast);
 		}
 
-		cmd->SCp.ptr += fast;
-		cmd->SCp.this_residual -= fast;
+		scsi_pointer->ptr += fast;
+		scsi_pointer->this_residual -= fast;
 
 		if (!status) {
 			imm_fail(dev, DID_BUS_BUSY);
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
+				scsi_pointer->ptr = sg_virt(scsi_pointer->buffer);
 
 				/*
 				 * Make sure that we transfer even number of bytes
 				 * otherwise it makes imm_byte_out() messy.
 				 */
-				if (cmd->SCp.this_residual & 0x01)
-					cmd->SCp.this_residual++;
+				if (scsi_pointer->this_residual & 0x01)
+					scsi_pointer->this_residual++;
 			}
 		}
 		/* Now check to see if the drive is ready to comunicate */
@@ -762,7 +762,7 @@ static void imm_interrupt(struct work_struct *work)
 	}
 #endif
 
-	if (cmd->SCp.phase > 1)
+	if (imm_scsi_pointer(cmd)->phase > 1)
 		imm_disconnect(dev);
 
 	imm_pb_dismiss(dev);
@@ -774,8 +774,9 @@ static void imm_interrupt(struct work_struct *work)
 	return;
 }
 
-static int imm_engine(imm_struct *dev, struct scsi_cmnd *cmd)
+static int imm_engine(imm_struct *dev, struct scsi_cmnd *const cmd)
 {
+	struct scsi_pointer *scsi_pointer = imm_scsi_pointer(cmd);
 	unsigned short ppb = dev->base;
 	unsigned char l = 0, h = 0;
 	int retv, x;
@@ -786,7 +787,7 @@ static int imm_engine(imm_struct *dev, struct scsi_cmnd *cmd)
 	if (dev->failed)
 		return 0;
 
-	switch (cmd->SCp.phase) {
+	switch (scsi_pointer->phase) {
 	case 0:		/* Phase 0 - Waiting for parport */
 		if (time_after(jiffies, dev->jstart + HZ)) {
 			/*
@@ -800,7 +801,7 @@ static int imm_engine(imm_struct *dev, struct scsi_cmnd *cmd)
 
 	case 1:		/* Phase 1 - Connected */
 		imm_connect(dev, CONNECT_EPP_MAYBE);
-		cmd->SCp.phase++;
+		scsi_pointer->phase++;
 		fallthrough;
 
 	case 2:		/* Phase 2 - We are now talking to the scsi bus */
@@ -808,7 +809,7 @@ static int imm_engine(imm_struct *dev, struct scsi_cmnd *cmd)
 			imm_fail(dev, DID_NO_CONNECT);
 			return 0;
 		}
-		cmd->SCp.phase++;
+		scsi_pointer->phase++;
 		fallthrough;
 
 	case 3:		/* Phase 3 - Ready to accept a command */
@@ -818,23 +819,23 @@ static int imm_engine(imm_struct *dev, struct scsi_cmnd *cmd)
 
 		if (!imm_send_command(cmd))
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
+			scsi_pointer->this_residual = scsi_pointer->buffer->length;
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
-		if (cmd->SCp.this_residual & 0x01)
-			cmd->SCp.this_residual++;
+		scsi_pointer->buffers_residual = scsi_sg_count(cmd) - 1;
+		scsi_pointer->phase++;
+		if (scsi_pointer->this_residual & 0x01)
+			scsi_pointer->this_residual++;
 		fallthrough;
 
 	case 5:		/* Phase 5 - Pre-Data transfer stage */
@@ -851,7 +852,7 @@ static int imm_engine(imm_struct *dev, struct scsi_cmnd *cmd)
 		if ((dev->dp) && (dev->rd))
 			if (imm_negotiate(dev))
 				return 0;
-		cmd->SCp.phase++;
+		scsi_pointer->phase++;
 		fallthrough;
 
 	case 6:		/* Phase 6 - Data transfer stage */
@@ -867,7 +868,7 @@ static int imm_engine(imm_struct *dev, struct scsi_cmnd *cmd)
 			if (retv == 0)
 				return 1;
 		}
-		cmd->SCp.phase++;
+		scsi_pointer->phase++;
 		fallthrough;
 
 	case 7:		/* Phase 7 - Post data transfer stage */
@@ -879,7 +880,7 @@ static int imm_engine(imm_struct *dev, struct scsi_cmnd *cmd)
 				w_ctr(ppb, 0x4);
 			}
 		}
-		cmd->SCp.phase++;
+		scsi_pointer->phase++;
 		fallthrough;
 
 	case 8:		/* Phase 8 - Read status/message */
@@ -922,7 +923,7 @@ static int imm_queuecommand_lck(struct scsi_cmnd *cmd)
 	dev->jstart = jiffies;
 	dev->cur_cmd = cmd;
 	cmd->result = DID_ERROR << 16;	/* default return code */
-	cmd->SCp.phase = 0;	/* bus free */
+	imm_scsi_pointer(cmd)->phase = 0;	/* bus free */
 
 	schedule_delayed_work(&dev->imm_tq, 0);
 
@@ -961,7 +962,7 @@ static int imm_abort(struct scsi_cmnd *cmd)
 	 * have tied the SCSI_MESSAGE line high in the interface
 	 */
 
-	switch (cmd->SCp.phase) {
+	switch (imm_scsi_pointer(cmd)->phase) {
 	case 0:		/* Do not have access to parport */
 	case 1:		/* Have not connected to interface */
 		dev->cur_cmd = NULL;	/* Forget the problem */
@@ -987,7 +988,7 @@ static int imm_reset(struct scsi_cmnd *cmd)
 {
 	imm_struct *dev = imm_dev(cmd->device->host);
 
-	if (cmd->SCp.phase)
+	if (imm_scsi_pointer(cmd)->phase)
 		imm_disconnect(dev);
 	dev->cur_cmd = NULL;	/* Forget the problem */
 
@@ -1109,6 +1110,7 @@ static struct scsi_host_template imm_template = {
 	.sg_tablesize		= SG_ALL,
 	.can_queue		= 1,
 	.slave_alloc		= imm_adjust_queue,
+	.cmd_size		= sizeof(struct scsi_pointer),
 };
 
 /***************************************************************************
diff --git a/drivers/scsi/imm.h b/drivers/scsi/imm.h
index 7f2bb35b1b87..411cf94af5b0 100644
--- a/drivers/scsi/imm.h
+++ b/drivers/scsi/imm.h
@@ -139,6 +139,11 @@ static char *IMM_MODE_STRING[] =
 #define w_ctr(x,y)      outb(y, (x)+2)
 #endif
 
+static inline struct scsi_pointer *imm_scsi_pointer(struct scsi_cmnd *cmd)
+{
+	return scsi_cmd_priv(cmd);
+}
+
 static int imm_engine(imm_struct *, struct scsi_cmnd *);
 
 #endif				/* _IMM_H */
