Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DCB4C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 17:26:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384253AbiBHRZ6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 12:25:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384221AbiBHRZ5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 12:25:57 -0500
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5811DC0613C9
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 09:25:51 -0800 (PST)
Received: by mail-pf1-f176.google.com with SMTP id y5so19114297pfe.4
        for <linux-scsi@vger.kernel.org>; Tue, 08 Feb 2022 09:25:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lp5Wcht60ELjRSZs7xDRNfNDDamBsCpFkhL2r7O/g8I=;
        b=w1wpgUkw9aTjrSxPT9/MSZK14bh13mtmL0JghuqqqVlrFJIeMO4+u+mPHB4gNi6Zkz
         VYgXpkbczNHmB9camGYkkuH+FrKgBzsg9JnI1NejaTVVF3Cxzx5+3yafsmD1nlcCV2hL
         ZVdutV2748h4m2UJqO8a74bgWvS48mlxudhnon4Ltxgmrz0TiOPDM4BFXMYKwKNVVeuX
         SljhcyoUY5Th+lK6urQNuDnjy0lmk47WNsxYbr5G7b89ttK+i2DrCjJLPH/jPBjnhEUO
         x+vh8xh0UuzEHXirgLyHPtLkkM/9LeX/kRv/am65tk7xVF9rVp0IyVfokIYRJSwfr4LP
         BR0A==
X-Gm-Message-State: AOAM5314tp/zqTbQM/wumziPjNkhSI5ZA//LP+zjLv06e6gm99SL53yC
        xHablnPQhcRdjym+e7dHQfQ=
X-Google-Smtp-Source: ABdhPJwX0LA/xjTMZEoZ3vouuLq3F+3In2PsFep+q4cpJ8DKZ4mdJkbyCnOH7fCbAKMSCL+anRkZ3A==
X-Received: by 2002:a63:a1d:: with SMTP id 29mr4366660pgk.104.1644341150657;
        Tue, 08 Feb 2022 09:25:50 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q1sm335116pfs.112.2022.02.08.09.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 09:25:49 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Russell King <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 07/44] scsi: arm: Move the SCSI pointer to private command data
Date:   Tue,  8 Feb 2022 09:24:37 -0800
Message-Id: <20220208172514.3481-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220208172514.3481-1-bvanassche@acm.org>
References: <20220208172514.3481-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
from struct scsi_cmnd. This patch prepares for removal of the SCSI pointer
from struct scsi_cmnd.

Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/arm/acornscsi.c | 20 ++++++++++++--------
 drivers/scsi/arm/arm_scsi.h  | 33 +++++++++++++++++++++++----------
 drivers/scsi/arm/fas216.c    | 28 +++++++++++++++++-----------
 drivers/scsi/arm/fas216.h    |  1 +
 4 files changed, 53 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index 38aa9333631b..7602639da9b3 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -729,7 +729,7 @@ intr_ret_t acornscsi_kick(AS_Host *host)
      */
     host->scsi.phase = PHASE_CONNECTING;
     host->SCpnt = SCpnt;
-    host->scsi.SCp = SCpnt->SCp;
+    host->scsi.SCp = *arm_scsi_pointer(SCpnt);
     host->dma.xfer_setup = 0;
     host->dma.xfer_required = 0;
     host->dma.xfer_done = 0;
@@ -1424,6 +1424,7 @@ unsigned char acornscsi_readmessagebyte(AS_Host *host)
 static
 void acornscsi_message(AS_Host *host)
 {
+    struct scsi_pointer *scsi_pointer;
     unsigned char message[16];
     unsigned int msgidx = 0, msglen = 1;
 
@@ -1493,8 +1494,9 @@ void acornscsi_message(AS_Host *host)
 	 *  the saved data pointer for the current I/O process.
 	 */
 	acornscsi_dma_cleanup(host);
-	host->SCpnt->SCp = host->scsi.SCp;
-	host->SCpnt->SCp.sent_command = 0;
+	scsi_pointer = arm_scsi_pointer(host->SCpnt);
+	*scsi_pointer = host->scsi.SCp;
+	scsi_pointer->sent_command = 0;
 	host->scsi.phase = PHASE_MSGIN;
 	break;
 
@@ -1509,7 +1511,7 @@ void acornscsi_message(AS_Host *host)
 	 *  the present command and status areas.'
 	 */
 	acornscsi_dma_cleanup(host);
-	host->scsi.SCp = host->SCpnt->SCp;
+	host->scsi.SCp = *arm_scsi_pointer(host->SCpnt);
 	host->scsi.phase = PHASE_MSGIN;
 	break;
 
@@ -1809,7 +1811,7 @@ int acornscsi_reconnect_finish(AS_Host *host)
 	/*
 	 * Restore data pointer from SAVED pointers.
 	 */
-	host->scsi.SCp = host->SCpnt->SCp;
+	host->scsi.SCp = *arm_scsi_pointer(host->SCpnt);
 #if (DEBUG & (DEBUG_QUEUES|DEBUG_DISCON))
 	printk(", data pointers: [%p, %X]",
 		host->scsi.SCp.ptr, host->scsi.SCp.this_residual);
@@ -2408,6 +2410,7 @@ acornscsi_intr(int irq, void *dev_id)
  */
 static int acornscsi_queuecmd_lck(struct scsi_cmnd *SCpnt)
 {
+    struct scsi_pointer *scsi_pointer = arm_scsi_pointer(SCpnt);
     void (*done)(struct scsi_cmnd *) = scsi_done;
     AS_Host *host = (AS_Host *)SCpnt->device->host->hostdata;
 
@@ -2423,9 +2426,9 @@ static int acornscsi_queuecmd_lck(struct scsi_cmnd *SCpnt)
 
     SCpnt->host_scribble = NULL;
     SCpnt->result = 0;
-    SCpnt->SCp.phase = (int)acornscsi_datadirection(SCpnt->cmnd[0]);
-    SCpnt->SCp.sent_command = 0;
-    SCpnt->SCp.scsi_xferred = 0;
+    scsi_pointer->phase = (int)acornscsi_datadirection(SCpnt->cmnd[0]);
+    scsi_pointer->sent_command = 0;
+    scsi_pointer->scsi_xferred = 0;
 
     init_SCp(SCpnt);
 
@@ -2791,6 +2794,7 @@ static struct scsi_host_template acornscsi_template = {
 	.cmd_per_lun		= 2,
 	.dma_boundary		= PAGE_SIZE - 1,
 	.proc_name		= "acornscsi",
+	.cmd_size		= sizeof(struct arm_cmd_priv),
 };
 
 static int acornscsi_probe(struct expansion_card *ec, const struct ecard_id *id)
diff --git a/drivers/scsi/arm/arm_scsi.h b/drivers/scsi/arm/arm_scsi.h
index 3eb5c6aa93c9..ea9fcd92c6de 100644
--- a/drivers/scsi/arm/arm_scsi.h
+++ b/drivers/scsi/arm/arm_scsi.h
@@ -9,6 +9,17 @@
 
 #define BELT_AND_BRACES
 
+struct arm_cmd_priv {
+	struct scsi_pointer scsi_pointer;
+};
+
+static inline struct scsi_pointer *arm_scsi_pointer(struct scsi_cmnd *cmd)
+{
+	struct arm_cmd_priv *acmd = scsi_cmd_priv(cmd);
+
+	return &acmd->scsi_pointer;
+}
+
 /*
  * The scatter-gather list handling.  This contains all
  * the yucky stuff that needs to be fixed properly.
@@ -76,16 +87,18 @@ static inline void put_next_SCp_byte(struct scsi_pointer *SCp, unsigned char c)
 
 static inline void init_SCp(struct scsi_cmnd *SCpnt)
 {
-	memset(&SCpnt->SCp, 0, sizeof(struct scsi_pointer));
+	struct scsi_pointer *scsi_pointer = arm_scsi_pointer(SCpnt);
+
+	memset(scsi_pointer, 0, sizeof(struct scsi_pointer));
 
 	if (scsi_bufflen(SCpnt)) {
 		unsigned long len = 0;
 
-		SCpnt->SCp.buffer = scsi_sglist(SCpnt);
-		SCpnt->SCp.buffers_residual = scsi_sg_count(SCpnt) - 1;
-		SCpnt->SCp.ptr = sg_virt(SCpnt->SCp.buffer);
-		SCpnt->SCp.this_residual = SCpnt->SCp.buffer->length;
-		SCpnt->SCp.phase = scsi_bufflen(SCpnt);
+		scsi_pointer->buffer = scsi_sglist(SCpnt);
+		scsi_pointer->buffers_residual = scsi_sg_count(SCpnt) - 1;
+		scsi_pointer->ptr = sg_virt(scsi_pointer->buffer);
+		scsi_pointer->this_residual = scsi_pointer->buffer->length;
+		scsi_pointer->phase = scsi_bufflen(SCpnt);
 
 #ifdef BELT_AND_BRACES
 		{	/*
@@ -109,15 +122,15 @@ static inline void init_SCp(struct scsi_cmnd *SCpnt)
 				 * FIXME: Totaly naive fixup. We should abort
 				 * with error
 				 */
-				SCpnt->SCp.phase =
+				scsi_pointer->phase =
 					min_t(unsigned long, len,
 					      scsi_bufflen(SCpnt));
 			}
 		}
 #endif
 	} else {
-		SCpnt->SCp.ptr = NULL;
-		SCpnt->SCp.this_residual = 0;
-		SCpnt->SCp.phase = 0;
+		scsi_pointer->ptr = NULL;
+		scsi_pointer->this_residual = 0;
+		scsi_pointer->phase = 0;
 	}
 }
diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index a23e34c9f7de..4ce0b2d73614 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -761,7 +761,7 @@ static void fas216_transfer(FAS216_Info *info)
 		fas216_log(info, LOG_ERROR, "null buffer passed to "
 			   "fas216_starttransfer");
 		print_SCp(&info->scsi.SCp, "SCp: ", "\n");
-		print_SCp(&info->SCpnt->SCp, "Cmnd SCp: ", "\n");
+		print_SCp(arm_scsi_pointer(info->SCpnt), "Cmnd SCp: ", "\n");
 		return;
 	}
 
@@ -1011,7 +1011,7 @@ fas216_reselected_intr(FAS216_Info *info)
 		/*
 		 * Restore data pointer from SAVED data pointer
 		 */
-		info->scsi.SCp = info->SCpnt->SCp;
+		info->scsi.SCp = *arm_scsi_pointer(info->SCpnt);
 
 		fas216_log(info, LOG_CONNECT, "data pointers: [%p, %X]",
 			info->scsi.SCp.ptr, info->scsi.SCp.this_residual);
@@ -1054,6 +1054,7 @@ fas216_reselected_intr(FAS216_Info *info)
 
 static void fas216_parse_message(FAS216_Info *info, unsigned char *message, int msglen)
 {
+	struct scsi_pointer *scsi_pointer;
 	int i;
 
 	switch (message[0]) {
@@ -1078,8 +1079,9 @@ static void fas216_parse_message(FAS216_Info *info, unsigned char *message, int
 		 * as required by the SCSI II standard.  These always
 		 * point to the start of their respective areas.
 		 */
-		info->SCpnt->SCp = info->scsi.SCp;
-		info->SCpnt->SCp.sent_command = 0;
+		scsi_pointer = arm_scsi_pointer(info->SCpnt);
+		*scsi_pointer = info->scsi.SCp;
+		scsi_pointer->sent_command = 0;
 		fas216_log(info, LOG_CONNECT | LOG_MESSAGES | LOG_BUFFER,
 			"save data pointers: [%p, %X]",
 			info->scsi.SCp.ptr, info->scsi.SCp.this_residual);
@@ -1092,7 +1094,7 @@ static void fas216_parse_message(FAS216_Info *info, unsigned char *message, int
 		/*
 		 * Restore current data pointer from SAVED data pointer
 		 */
-		info->scsi.SCp = info->SCpnt->SCp;
+		info->scsi.SCp = *arm_scsi_pointer(info->SCpnt);
 		fas216_log(info, LOG_CONNECT | LOG_MESSAGES | LOG_BUFFER,
 			"restore data pointers: [%p, 0x%x]",
 			info->scsi.SCp.ptr, info->scsi.SCp.this_residual);
@@ -1770,7 +1772,7 @@ static void fas216_start_command(FAS216_Info *info, struct scsi_cmnd *SCpnt)
 	 * claim host busy
 	 */
 	info->scsi.phase = PHASE_SELECTION;
-	info->scsi.SCp = SCpnt->SCp;
+	info->scsi.SCp = *arm_scsi_pointer(SCpnt);
 	info->SCpnt = SCpnt;
 	info->dma.transfer_type = fasdma_none;
 
@@ -1849,7 +1851,7 @@ static void fas216_do_bus_device_reset(FAS216_Info *info,
 	 * claim host busy
 	 */
 	info->scsi.phase = PHASE_SELECTION;
-	info->scsi.SCp = SCpnt->SCp;
+	info->scsi.SCp = *arm_scsi_pointer(SCpnt);
 	info->SCpnt = SCpnt;
 	info->dma.transfer_type = fasdma_none;
 
@@ -1999,11 +2001,13 @@ static void fas216_devicereset_done(FAS216_Info *info, struct scsi_cmnd *SCpnt,
 static void fas216_rq_sns_done(FAS216_Info *info, struct scsi_cmnd *SCpnt,
 			       unsigned int result)
 {
+	struct scsi_pointer *scsi_pointer = arm_scsi_pointer(SCpnt);
+
 	fas216_log_target(info, LOG_CONNECT, SCpnt->device->id,
 		   "request sense complete, result=0x%04x%02x%02x",
-		   result, SCpnt->SCp.Message, SCpnt->SCp.Status);
+		   result, scsi_pointer->Message, scsi_pointer->Status);
 
-	if (result != DID_OK || SCpnt->SCp.Status != SAM_STAT_GOOD)
+	if (result != DID_OK || scsi_pointer->Status != SAM_STAT_GOOD)
 		/*
 		 * Something went wrong.  Make sure that we don't
 		 * have valid data in the sense buffer that could
@@ -2033,6 +2037,8 @@ static void fas216_rq_sns_done(FAS216_Info *info, struct scsi_cmnd *SCpnt,
 static void
 fas216_std_done(FAS216_Info *info, struct scsi_cmnd *SCpnt, unsigned int result)
 {
+	struct scsi_pointer *scsi_pointer = arm_scsi_pointer(SCpnt);
+
 	info->stats.fins += 1;
 
 	set_host_byte(SCpnt, result);
@@ -2107,8 +2113,8 @@ fas216_std_done(FAS216_Info *info, struct scsi_cmnd *SCpnt, unsigned int result)
 	fas216_log_target(info, LOG_CONNECT, SCpnt->device->id,
 			  "requesting sense");
 	init_SCp(SCpnt);
-	SCpnt->SCp.Message = 0;
-	SCpnt->SCp.Status = 0;
+	scsi_pointer->Message = 0;
+	scsi_pointer->Status = 0;
 	SCpnt->host_scribble = (void *)fas216_rq_sns_done;
 
 	/*
diff --git a/drivers/scsi/arm/fas216.h b/drivers/scsi/arm/fas216.h
index abf960487314..d2e7478aad12 100644
--- a/drivers/scsi/arm/fas216.h
+++ b/drivers/scsi/arm/fas216.h
@@ -312,6 +312,7 @@ typedef struct {
 
 /* driver-private data per SCSI command. */
 struct fas216_cmd_priv {
+	struct scsi_pointer scsi_pointer; /* must be the first member */
 	void (*scsi_done)(struct scsi_cmnd *cmd);
 };
 
