Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48EEFC43461
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 184B96109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234426AbhDTALL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:11:11 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:45908 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234128AbhDTAKu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:50 -0400
Received: by mail-pf1-f181.google.com with SMTP id i190so24305678pfc.12
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:10:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lnGbC8HFYYcjJuMW2JM/BXCB9um32UPD7emZkdAW4wE=;
        b=GHi699RwWmEE2py1bIVzPEIumu+wiVPPnErmXuN2HzwQHnMea/MrIwYBNranY/Urll
         /0UeUBPwFhrDPi/8jd/HC4u/05FUHLviIyrZ5kEOD6Ksx4u84YXlbLVhz8f2yBitYXax
         YxQ9n9UL6FYyV1vTmnHChtNqwJavqOQa7fg92gYuDeda1DGIU3mRC7W44cr8xPrW/KY1
         w1N5XLb9OvV2OBg9vGVCTj9pda1N8Mi3sZFXZKLlfALFT6Hga7BDyPZlqL2cI3ubuxZs
         GwpJiUDE6pyvRDEXkNMLxw7bRp6YkmVxwoUhPYGewMNbEQr+Dl67z6dwxf3I+C892Bwd
         ns6w==
X-Gm-Message-State: AOAM5316dDVFSOz/GZPxKnPakpjIpNPVwDipNNI8YUL1KQXOi4qoc9N6
        wWODX9dK7sbzM5M/aCfAFmE=
X-Google-Smtp-Source: ABdhPJw4HyWBVKBUTMBiAkLN3Wqhwms792/bJDPRR3Z9iqcJkcNqRW0B0mpCu/FltihJffQ6AJQBEw==
X-Received: by 2002:a62:2b03:0:b029:241:d147:2a79 with SMTP id r3-20020a622b030000b0290241d1472a79mr21937224pfr.53.1618877419545;
        Mon, 19 Apr 2021 17:10:19 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.10.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:10:19 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        GOTO Masanori <gotom@debian.or.jp>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Subject: [PATCH 076/117] nsp32: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:08:04 -0700
Message-Id: <20210420000845.25873-77-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An explanation of the purpose of this patch is available in the patch
"scsi: Introduce the scsi_status union".

Cc: GOTO Masanori <gotom@debian.or.jp>
Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/nsp32.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 134bbd2d8b66..d084d7cd7e08 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -461,7 +461,7 @@ static int nsp32_selection_autopara(struct scsi_cmnd *SCpnt)
 	if (phase != BUSMON_BUS_FREE) {
 		nsp32_msg(KERN_WARNING, "bus busy");
 		show_busphase(phase & BUSMON_PHASE_MASK);
-		SCpnt->result = DID_BUS_BUSY << 16;
+		SCpnt->status.combined = DID_BUS_BUSY << 16;
 		return FALSE;
 	}
 
@@ -473,7 +473,7 @@ static int nsp32_selection_autopara(struct scsi_cmnd *SCpnt)
 	 */
 	if (data->msgout_len == 0) {
 		nsp32_msg(KERN_ERR, "SCSI MsgOut without any message!");
-		SCpnt->result = DID_ERROR << 16;
+		SCpnt->status.combined = DID_ERROR << 16;
 		return FALSE;
 	} else if (data->msgout_len > 0 && data->msgout_len <= 3) {
 		msgout = 0;
@@ -596,7 +596,7 @@ static int nsp32_selection_autoscsi(struct scsi_cmnd *SCpnt)
 	phase = nsp32_read1(base, SCSI_BUS_MONITOR);
 	if ((phase & BUSMON_BSY) || (phase & BUSMON_SEL)) {
 		nsp32_msg(KERN_WARNING, "bus busy");
-		SCpnt->result = DID_BUS_BUSY << 16;
+		SCpnt->status.combined = DID_BUS_BUSY << 16;
 		status = 1;
 		goto out;
         }
@@ -632,7 +632,7 @@ static int nsp32_selection_autoscsi(struct scsi_cmnd *SCpnt)
 	 */
 	if (data->msgout_len == 0) {
 		nsp32_msg(KERN_ERR, "SCSI MsgOut without any message!");
-		SCpnt->result = DID_ERROR << 16;
+		SCpnt->status.combined = DID_ERROR << 16;
 		status = 1;
 		goto out;
 	} else if (data->msgout_len > 0 && data->msgout_len <= 3) {
@@ -762,11 +762,11 @@ static int nsp32_arbitration(struct scsi_cmnd *SCpnt, unsigned int base)
 
 	if (arbit & ARBIT_WIN) {
 		/* Arbitration succeeded */
-		SCpnt->result = DID_OK << 16;
+		SCpnt->status.combined = DID_OK << 16;
 		nsp32_index_write1(base, EXT_PORT, LED_ON); /* PCI LED on */
 	} else if (arbit & ARBIT_FAIL) {
 		/* Arbitration failed */
-		SCpnt->result = DID_BUS_BUSY << 16;
+		SCpnt->status.combined = DID_BUS_BUSY << 16;
 		status = FALSE;
 	} else {
 		/*
@@ -774,7 +774,7 @@ static int nsp32_arbitration(struct scsi_cmnd *SCpnt, unsigned int base)
 		 * something lock up! guess no connection.
 		 */
 		nsp32_dbg(NSP32_DEBUG_AUTOSCSI, "arbit timeout");
-		SCpnt->result = DID_NO_CONNECT << 16;
+		SCpnt->status.combined = DID_NO_CONNECT << 16;
 		status = FALSE;
         }
 
@@ -910,7 +910,7 @@ static int nsp32_queuecommand_lck(struct scsi_cmnd *SCpnt, void (*done)(struct s
 	if (data->CurrentSC != NULL) {
 		nsp32_msg(KERN_ERR, "Currentsc != NULL. Cancel this command request");
 		data->CurrentSC = NULL;
-		SCpnt->result   = DID_NO_CONNECT << 16;
+		SCpnt->status.combined   = DID_NO_CONNECT << 16;
 		done(SCpnt);
 		return 0;
 	}
@@ -918,7 +918,7 @@ static int nsp32_queuecommand_lck(struct scsi_cmnd *SCpnt, void (*done)(struct s
 	/* check target ID is not same as this initiator ID */
 	if (scmd_id(SCpnt) == SCpnt->device->host->this_id) {
 		nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND, "target==host???");
-		SCpnt->result = DID_BAD_TARGET << 16;
+		SCpnt->status.combined = DID_BAD_TARGET << 16;
 		done(SCpnt);
 		return 0;
 	}
@@ -926,7 +926,7 @@ static int nsp32_queuecommand_lck(struct scsi_cmnd *SCpnt, void (*done)(struct s
 	/* check target LUN is allowable value */
 	if (SCpnt->device->lun >= MAX_LUN) {
 		nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND, "no more lun");
-		SCpnt->result = DID_BAD_TARGET << 16;
+		SCpnt->status.combined = DID_BAD_TARGET << 16;
 		done(SCpnt);
 		return 0;
 	}
@@ -958,7 +958,7 @@ static int nsp32_queuecommand_lck(struct scsi_cmnd *SCpnt, void (*done)(struct s
 	ret = nsp32_setup_sg_table(SCpnt);
 	if (ret == FALSE) {
 		nsp32_msg(KERN_ERR, "SGT fail");
-		SCpnt->result = DID_ERROR << 16;
+		SCpnt->status.combined = DID_ERROR << 16;
 		nsp32_scsi_done(SCpnt);
 		return 0;
 	}
@@ -1181,7 +1181,7 @@ static irqreturn_t do_nsp32_isr(int irq, void *dev_id)
 		nsp32_msg(KERN_INFO, "card disconnect");
 		if (data->CurrentSC != NULL) {
 			nsp32_msg(KERN_INFO, "clean up current SCSI command");
-			SCpnt->result = DID_BAD_TARGET << 16;
+			SCpnt->status.combined = DID_BAD_TARGET << 16;
 			nsp32_scsi_done(SCpnt);
 		}
 		goto out;
@@ -1199,7 +1199,7 @@ static irqreturn_t do_nsp32_isr(int irq, void *dev_id)
 		nsp32_msg(KERN_INFO, "detected someone do bus reset");
 		nsp32_do_bus_reset(data);
 		if (SCpnt != NULL) {
-			SCpnt->result = DID_RESET << 16;
+			SCpnt->status.combined = DID_RESET << 16;
 			nsp32_scsi_done(SCpnt);
 		}
 		goto out;
@@ -1227,7 +1227,7 @@ static irqreturn_t do_nsp32_isr(int irq, void *dev_id)
 			nsp32_dbg(NSP32_DEBUG_INTR,
 				  "selection timeout occurred");
 
-			SCpnt->result = DID_TIME_OUT << 16;
+			SCpnt->status.combined = DID_TIME_OUT << 16;
 			nsp32_scsi_done(SCpnt);
 			goto out;
 		}
@@ -1309,7 +1309,7 @@ static irqreturn_t do_nsp32_isr(int irq, void *dev_id)
 			 * low level driver to indicate status), then checks 
 			 * status_byte (SCSI status byte).
 			 */
-			SCpnt->result =	(int)nsp32_read1(base, SCSI_CSB_IN);
+			SCpnt->status.combined = (int)nsp32_read1(base, SCSI_CSB_IN);
 		}
 
 		if (auto_stat & ILLEGAL_PHASE) {
@@ -1504,8 +1504,8 @@ static int nsp32_show_info(struct seq_file *m, struct Scsi_Host *host)
 
 
 /*
- * Reset parameters and call scsi_done for data->cur_lunt.
- * Be careful setting SCpnt->result = DID_* before calling this function.
+ * Reset parameters and call scsi_done for data->cur_lunt. Be careful setting
+ * SCpnt->status.combined = DID_* before calling this function.
  */
 static void nsp32_scsi_done(struct scsi_cmnd *SCpnt)
 {
@@ -1670,7 +1670,7 @@ static int nsp32_busfree_occur(struct scsi_cmnd *SCpnt, unsigned short execph)
 		nsp32_dbg(NSP32_DEBUG_BUSFREE, 
 			  "normal end stat=0x%x resid=0x%x\n",
 			  SCpnt->SCp.Status, scsi_get_resid(SCpnt));
-		SCpnt->result = (DID_OK             << 16) |
+		SCpnt->status.combined = (DID_OK    << 16) |
 			        (SCpnt->SCp.Message <<  8) |
 			        (SCpnt->SCp.Status  <<  0);
 		nsp32_scsi_done(SCpnt);
@@ -1689,7 +1689,7 @@ static int nsp32_busfree_occur(struct scsi_cmnd *SCpnt, unsigned short execph)
 
 		/* DID_ERROR? */
 		//SCpnt->result   = (DID_OK << 16) | (SCpnt->SCp.Message << 8) | (SCpnt->SCp.Status << 0);
-		SCpnt->result = DID_ERROR << 16;
+		SCpnt->status.combined = DID_ERROR << 16;
 		nsp32_scsi_done(SCpnt);
 		return TRUE;
 	}
@@ -2812,7 +2812,7 @@ static int nsp32_eh_abort(struct scsi_cmnd *SCpnt)
 	nsp32_write2(base, TRANSFER_CONTROL, 0);
 	nsp32_write2(base, BM_CNT,           0);
 
-	SCpnt->result = DID_ABORT << 16;
+	SCpnt->status.combined = DID_ABORT << 16;
 	nsp32_scsi_done(SCpnt);
 
 	nsp32_dbg(NSP32_DEBUG_BUSRESET, "abort success");
