Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8E39C43460
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 767A56109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234128AbhDTALM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:11:12 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:40835 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232986AbhDTAKv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:51 -0400
Received: by mail-pj1-f52.google.com with SMTP id g1-20020a17090adac1b0290150d07f9402so792299pjx.5
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:10:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CO3cYPeHIOlh/nyDG0GmXcKCokYOcCzUhMQaLcm5MIM=;
        b=IJ6VG2k8cJXsxoR0veoPEh56+zS+Ku9vP1d4+QV1QKyvhf2LjEKRQ6fhVvvsidGm17
         a2clr67I7FyZmC/f/7ekaGncHXplZLMDVzLKcVFIwgBPKTE6eP5mu74pYCqhAb0YaPFB
         QleDaNI44+CPdQ3gFf1lkVBG1Ml7ML20kPbhfkMEpr0sAwAKaSal6tdGwVmnm/K8Awpu
         kwTZN5x/dYJUgeC+PaNl5tq2MQBG5uwj1zWVz5hQW6qBTof6z6LcpWeYsIt4qxwQuOzK
         63ZhnFRG6yMf1yp6c1EgQ3Y8ohEmIc1rXpSp72QLSx4adb16Wu3FMAWP0EGjJppoVTPD
         Na1Q==
X-Gm-Message-State: AOAM532PC9mLHYLFzKcSyFRcalt7KmLn6qQVWAcVV/Tuv4WAWWYmFcvS
        UZe9VjRLcwQacveyRFQr/as=
X-Google-Smtp-Source: ABdhPJysP9tIi98NcqbZx5Y67RjVYhjcvPmowfHBOYIkGacPmc2ndEhnrHU0v2Sxmiurr2k1ZzY98Q==
X-Received: by 2002:a17:902:ea0c:b029:eb:7b6:13ba with SMTP id s12-20020a170902ea0cb02900eb07b613bamr25550934plg.25.1618877420729;
        Mon, 19 Apr 2021 17:10:20 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.10.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:10:20 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [PATCH 077/117] pcmcia: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:08:05 -0700
Message-Id: <20210420000845.25873-78-bvanassche@acm.org>
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

Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/pcmcia/nsp_cs.c       | 18 ++++++++++--------
 drivers/scsi/pcmcia/sym53c500_cs.c | 12 ++++++------
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index 5d5f50d6a02d..8c3642b6a02e 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -202,7 +202,7 @@ static int nsp_queuecommand_lck(struct scsi_cmnd *SCpnt,
 
 	if (data->CurrentSC != NULL) {
 		nsp_msg(KERN_DEBUG, "CurrentSC!=NULL this can't be happen");
-		SCpnt->result   = DID_BAD_TARGET << 16;
+		SCpnt->status.combined = DID_BAD_TARGET << 16;
 		nsp_scsi_done(SCpnt);
 		return 0;
 	}
@@ -249,7 +249,7 @@ static int nsp_queuecommand_lck(struct scsi_cmnd *SCpnt,
 
 	if (nsphw_start_selection(SCpnt) == FALSE) {
 		nsp_dbg(NSP_DEBUG_QUEUECOMMAND, "selection fail");
-		SCpnt->result   = DID_BUS_BUSY << 16;
+		SCpnt->status.combined = DID_BUS_BUSY << 16;
 		nsp_scsi_done(SCpnt);
 		return 0;
 	}
@@ -1034,7 +1034,8 @@ static irqreturn_t nspintr(int irq, void *dev_id)
 
 		if(data->CurrentSC != NULL) {
 			tmpSC = data->CurrentSC;
-			tmpSC->result  = (DID_RESET                   << 16) |
+			tmpSC->status.combined =
+					 (DID_RESET                   << 16) |
 				         ((tmpSC->SCp.Message & 0xff) <<  8) |
 				         ((tmpSC->SCp.Status  & 0xff) <<  0);
 			nsp_scsi_done(tmpSC);
@@ -1083,7 +1084,7 @@ static irqreturn_t nspintr(int irq, void *dev_id)
 				data->SelectionTimeOut = 0;
 				nsp_index_write(base, SCSIBUSCTRL, 0);
 
-				tmpSC->result   = DID_TIME_OUT << 16;
+				tmpSC->status.combined = DID_TIME_OUT << 16;
 				nsp_scsi_done(tmpSC);
 
 				return IRQ_HANDLED;
@@ -1107,7 +1108,7 @@ static irqreturn_t nspintr(int irq, void *dev_id)
 		// *sync_neg = SYNC_NOT_YET;
 		if ((phase & BUSMON_PHASE_MASK) != BUSPHASE_MESSAGE_IN) {
 
-			tmpSC->result	= DID_ABORT << 16;
+			tmpSC->status.combined = DID_ABORT << 16;
 			nsp_scsi_done(tmpSC);
 			return IRQ_HANDLED;
 		}
@@ -1133,10 +1134,11 @@ static irqreturn_t nspintr(int irq, void *dev_id)
 
 		/* all command complete and return status */
 		if (tmpSC->SCp.Message == COMMAND_COMPLETE) {
-			tmpSC->result = (DID_OK		             << 16) |
+			tmpSC->status.combined =
+					(DID_OK		             << 16) |
 					((tmpSC->SCp.Message & 0xff) <<  8) |
 					((tmpSC->SCp.Status  & 0xff) <<  0);
-			nsp_dbg(NSP_DEBUG_INTR, "command complete result=0x%x", tmpSC->result);
+			nsp_dbg(NSP_DEBUG_INTR, "command complete result=0x%x", tmpSC->status.combined);
 			nsp_scsi_done(tmpSC);
 
 			return IRQ_HANDLED;
@@ -1151,7 +1153,7 @@ static irqreturn_t nspintr(int irq, void *dev_id)
 		nsp_msg(KERN_DEBUG, "unexpected bus free. irq_status=0x%x, phase=0x%x, irq_phase=0x%x", irq_status, phase, irq_phase);
 
 		*sync_neg       = SYNC_NG;
-		tmpSC->result   = DID_ERROR << 16;
+		tmpSC->status.combined = DID_ERROR << 16;
 		nsp_scsi_done(tmpSC);
 		return IRQ_HANDLED;
 	}
diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index a366ff1a3959..2f115b51669a 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -373,34 +373,34 @@ SYM53C500_intr(int irq, void *dev_id)
 
 	if (int_reg & 0x80) {	/* SCSI reset intr */
 		DEB(printk("SYM53C500: reset intr received\n"));
-		curSC->result = DID_RESET << 16;
+		curSC->status.combined = DID_RESET << 16;
 		goto idle_out;
 	}
 
 	if (pio_status & 0x80) {
 		printk("SYM53C500: Warning: PIO error!\n");
-		curSC->result = DID_ERROR << 16;
+		curSC->status.combined = DID_ERROR << 16;
 		goto idle_out;
 	}
 
 	if (status & 0x20) {		/* Parity error */
 		printk("SYM53C500: Warning: parity error!\n");
-		curSC->result = DID_PARITY << 16;
+		curSC->status.combined = DID_PARITY << 16;
 		goto idle_out;
 	}
 
 	if (status & 0x40) {		/* Gross error */
 		printk("SYM53C500: Warning: gross error!\n");
-		curSC->result = DID_ERROR << 16;
+		curSC->status.combined = DID_ERROR << 16;
 		goto idle_out;
 	}
 
 	if (int_reg & 0x20) {		/* Disconnect */
 		DEB(printk("SYM53C500: disconnect intr received\n"));
 		if (curSC->SCp.phase != message_in) {	/* Unexpected disconnect */
-			curSC->result = DID_NO_CONNECT << 16;
+			curSC->status.combined = DID_NO_CONNECT << 16;
 		} else {	/* Command complete, return status and message */
-			curSC->result = (curSC->SCp.Status & 0xff)
+			curSC->status.combined = (curSC->SCp.Status & 0xff)
 			    | ((curSC->SCp.Message & 0xff) << 8) | (DID_OK << 16);
 		}
 		goto idle_out;
