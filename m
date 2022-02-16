Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D58BC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 21:04:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234409AbiBPVFA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 16:05:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234536AbiBPVEc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 16:04:32 -0500
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8002B0B08
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:04:09 -0800 (PST)
Received: by mail-pj1-f42.google.com with SMTP id h14-20020a17090a130e00b001b88991a305so7549003pja.3
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:04:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B/rU5Uug+wbiRRO+qJny3vIUPXj+4jiEJ1epi+oHgJs=;
        b=0h5a4SIQnTwFhvh/7/9I6poFgSALx3JF2qOU2cbSijVsfpfn5qFR9RNNZk3V9jcQOF
         1MgQAie4YVzoH2b3VN7XLlos4ZGP1TdX66HNpk7kFMEXX5z7M17yrLaeeOgQfjOPkJv+
         53OuVqPGyksdjpSPn0m4syWDYqPN+9qlGJl7jZtlc46VrSv7f/jsvjX1nI/79QSsPn6X
         npB/j2wWnfFnjdLrckoZ93xH+YSDxd3WxloXmk+WYVu7wqwmPZDQEYFEoLi683b96D/I
         PQPKOfoO6bihs3DDDWaQ1QofXkipzfL25g6R5UcwFQu5uilJEicFnjTLql8pao5e7M/m
         FfSA==
X-Gm-Message-State: AOAM531Oz24UOiCRzMeslfX+xx3aP4/lmrmI4cveKkMy+/S/XU/Mt0vJ
        m9yus/aQT0VVHKLzZuZAriU=
X-Google-Smtp-Source: ABdhPJwEe1PJMNi1G42J9t7bbPb7FHoKv/y3NpskW/odGO5sg1SXWBtLGxy90nSon2nHGka6/OuK0A==
X-Received: by 2002:a17:90a:ac1:b0:1b9:7dd3:ba5f with SMTP id r1-20020a17090a0ac100b001b97dd3ba5fmr3875372pje.178.1645045448408;
        Wed, 16 Feb 2022 13:04:08 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c8sm46591222pfv.57.2022.02.16.13.04.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 13:04:07 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 41/50] scsi: ppa: Move the SCSI pointer to private command data
Date:   Wed, 16 Feb 2022 13:02:24 -0800
Message-Id: <20220216210233.28774-42-bvanassche@acm.org>
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
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ppa.c | 75 ++++++++++++++++++++++++++--------------------
 1 file changed, 43 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index 003043de23a5..00a68037e0e4 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -45,6 +45,11 @@ typedef struct {
 
 #include  "ppa.h"
 
+static struct scsi_pointer *ppa_scsi_pointer(struct scsi_cmnd *cmd)
+{
+	return scsi_cmd_priv(cmd);
+}
+	
 static inline ppa_struct *ppa_dev(struct Scsi_Host *host)
 {
 	return *(ppa_struct **)&host->hostdata;
@@ -56,7 +61,7 @@ static void got_it(ppa_struct *dev)
 {
 	dev->base = dev->dev->port->base;
 	if (dev->cur_cmd)
-		dev->cur_cmd->SCp.phase = 1;
+		ppa_scsi_pointer(dev->cur_cmd)->phase = 1;
 	else
 		wake_up(dev->waiting);
 }
@@ -511,13 +516,14 @@ static inline int ppa_send_command(struct scsi_cmnd *cmd)
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
@@ -543,7 +549,7 @@ static int ppa_completion(struct scsi_cmnd *cmd)
 		if (time_after(jiffies, start_jiffies + 1))
 			return 0;
 
-		if ((cmd->SCp.this_residual <= 0)) {
+		if (scsi_pointer->this_residual <= 0) {
 			ppa_fail(dev, DID_ERROR);
 			return -1;	/* ERROR_RETURN */
 		}
@@ -572,28 +578,30 @@ static int ppa_completion(struct scsi_cmnd *cmd)
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
@@ -658,7 +666,7 @@ static void ppa_interrupt(struct work_struct *work)
 	}
 #endif
 
-	if (cmd->SCp.phase > 1)
+	if (ppa_scsi_pointer(cmd)->phase > 1)
 		ppa_disconnect(dev);
 
 	ppa_pb_dismiss(dev);
@@ -670,6 +678,7 @@ static void ppa_interrupt(struct work_struct *work)
 
 static int ppa_engine(ppa_struct *dev, struct scsi_cmnd *cmd)
 {
+	struct scsi_pointer *scsi_pointer = ppa_scsi_pointer(cmd);
 	unsigned short ppb = dev->base;
 	unsigned char l = 0, h = 0;
 	int retv;
@@ -680,7 +689,7 @@ static int ppa_engine(ppa_struct *dev, struct scsi_cmnd *cmd)
 	if (dev->failed)
 		return 0;
 
-	switch (cmd->SCp.phase) {
+	switch (scsi_pointer->phase) {
 	case 0:		/* Phase 0 - Waiting for parport */
 		if (time_after(jiffies, dev->jstart + HZ)) {
 			/*
@@ -715,7 +724,7 @@ static int ppa_engine(ppa_struct *dev, struct scsi_cmnd *cmd)
 					return 1;	/* Try again in a jiffy */
 				}
 			}
-			cmd->SCp.phase++;
+			scsi_pointer->phase++;
 		}
 		fallthrough;
 
@@ -724,7 +733,7 @@ static int ppa_engine(ppa_struct *dev, struct scsi_cmnd *cmd)
 			ppa_fail(dev, DID_NO_CONNECT);
 			return 0;
 		}
-		cmd->SCp.phase++;
+		scsi_pointer->phase++;
 		fallthrough;
 
 	case 3:		/* Phase 3 - Ready to accept a command */
@@ -734,21 +743,22 @@ static int ppa_engine(ppa_struct *dev, struct scsi_cmnd *cmd)
 
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
@@ -761,7 +771,7 @@ static int ppa_engine(ppa_struct *dev, struct scsi_cmnd *cmd)
 			return 0;
 		if (retv == 0)
 			return 1;
-		cmd->SCp.phase++;
+		scsi_pointer->phase++;
 		fallthrough;
 
 	case 6:		/* Phase 6 - Read status/message */
@@ -798,7 +808,7 @@ static int ppa_queuecommand_lck(struct scsi_cmnd *cmd)
 	dev->jstart = jiffies;
 	dev->cur_cmd = cmd;
 	cmd->result = DID_ERROR << 16;	/* default return code */
-	cmd->SCp.phase = 0;	/* bus free */
+	ppa_scsi_pointer(cmd)->phase = 0;	/* bus free */
 
 	schedule_delayed_work(&dev->ppa_tq, 0);
 
@@ -839,7 +849,7 @@ static int ppa_abort(struct scsi_cmnd *cmd)
 	 * have tied the SCSI_MESSAGE line high in the interface
 	 */
 
-	switch (cmd->SCp.phase) {
+	switch (ppa_scsi_pointer(cmd)->phase) {
 	case 0:		/* Do not have access to parport */
 	case 1:		/* Have not connected to interface */
 		dev->cur_cmd = NULL;	/* Forget the problem */
@@ -861,7 +871,7 @@ static int ppa_reset(struct scsi_cmnd *cmd)
 {
 	ppa_struct *dev = ppa_dev(cmd->device->host);
 
-	if (cmd->SCp.phase)
+	if (ppa_scsi_pointer(cmd)->phase)
 		ppa_disconnect(dev);
 	dev->cur_cmd = NULL;	/* Forget the problem */
 
@@ -976,6 +986,7 @@ static struct scsi_host_template ppa_template = {
 	.sg_tablesize		= SG_ALL,
 	.can_queue		= 1,
 	.slave_alloc		= ppa_adjust_queue,
+	.cmd_size		= sizeof(struct scsi_pointer),
 };
 
 /***************************************************************************
