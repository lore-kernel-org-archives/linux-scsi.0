Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49785C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 22:22:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351631AbiA1WWF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:22:05 -0500
Received: from mail-pj1-f46.google.com ([209.85.216.46]:52796 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241043AbiA1WVw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2022 17:21:52 -0500
Received: by mail-pj1-f46.google.com with SMTP id o64so7812127pjo.2
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2022 14:21:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PrJy5/lZoyUOkXEIVsRRnsz+60fKwc+VkpgaXfHDCWo=;
        b=CugdXnrm1cOlLGNEiP7YmB4VSY9PLWgZ1ODVrxiXchhkI3UcxU1ZyP0ylXGjgsdi6R
         0PVL6McuseqQ7Qc+OQeAeRig/YuILdInRlzNUn9mV0zgR/1410TuaLehFXCTTmlBAwU+
         ujsB5EQwnB3y8N5waHu+jXSNYNQlKPuq75SJACO5hMI4r19s18acPZaZkSJ9X2da+za4
         XU+gwxTnM9yittm9Cpv6L687+zluzyN1ncYNXTHjlhsJw7E1THJPa5UkmO3yVNAWJrVj
         RWzqV1RkkdBZFOz9UjqPwyy/KFlE1VIisd/xDEaBrwt2XMERjb7bAn6JKQ8HTHpNOU0q
         6zdQ==
X-Gm-Message-State: AOAM532I1fa3uI91TQVQ/5Ez8PSKfgh7yucLZGPf3s/A3wuLZQoRW2eT
        3Gx+Z/kM7PNo3R1EDp7s834=
X-Google-Smtp-Source: ABdhPJyuJzj23mzk9J4G5y2u4pKgJsE7bI/VrzEx1e+QwKyHu88s6gZ0L5mka8/MZvDiPxRd0vTaZw==
X-Received: by 2002:a17:902:e74a:: with SMTP id p10mr10559320plf.16.1643408499847;
        Fri, 28 Jan 2022 14:21:39 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id t2sm7787931pfg.207.2022.01.28.14.21.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 14:21:39 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        GOTO Masanori <gotom@debian.or.jp>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 32/44] nsp32: Stop using the SCSI pointer
Date:   Fri, 28 Jan 2022 14:18:57 -0800
Message-Id: <20220128221909.8141-33-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128221909.8141-1-bvanassche@acm.org>
References: <20220128221909.8141-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the SCSI status field to private data. Stop setting the .ptr,
.this_residual, .buffer and .buffer_residual SCSI pointer members
since no code in this driver reads these members.

This patch prepares for removal of the SCSI pointer from struct scsi_cmnd.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/nsp32.c | 21 +++++++--------------
 drivers/scsi/nsp32.h |  9 +++++++++
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index bd3ee3bf08ee..6ae394b39121 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -273,6 +273,7 @@ static struct scsi_host_template nsp32_template = {
 	.eh_abort_handler		= nsp32_eh_abort,
 	.eh_host_reset_handler		= nsp32_eh_host_reset,
 /*	.highmem_io			= 1, */
+	.cmd_size			= sizeof(struct nsp32_cmd_priv),
 };
 
 #include "nsp32_io.h"
@@ -946,14 +947,9 @@ static int nsp32_queuecommand_lck(struct scsi_cmnd *SCpnt)
 	show_command(SCpnt);
 
 	data->CurrentSC      = SCpnt;
-	SCpnt->SCp.Status    = SAM_STAT_CHECK_CONDITION;
+	nsp32_priv(SCpnt)->status = SAM_STAT_CHECK_CONDITION;
 	scsi_set_resid(SCpnt, scsi_bufflen(SCpnt));
 
-	SCpnt->SCp.ptr		    = (char *)scsi_sglist(SCpnt);
-	SCpnt->SCp.this_residual    = scsi_bufflen(SCpnt);
-	SCpnt->SCp.buffer	    = NULL;
-	SCpnt->SCp.buffers_residual = 0;
-
 	/* initialize data */
 	data->msgout_len	= 0;
 	data->msgin_len		= 0;
@@ -1376,7 +1372,7 @@ static irqreturn_t do_nsp32_isr(int irq, void *dev_id)
 		case BUSPHASE_STATUS:
 			nsp32_dbg(NSP32_DEBUG_INTR, "fifo/status");
 
-			SCpnt->SCp.Status = nsp32_read1(base, SCSI_CSB_IN);
+			nsp32_priv(SCpnt)->status = nsp32_read1(base, SCSI_CSB_IN);
 
 			break;
 		default:
@@ -1687,18 +1683,17 @@ static int nsp32_busfree_occur(struct scsi_cmnd *SCpnt, unsigned short execph)
 		/* MsgIn 00: Command Complete */
 		nsp32_dbg(NSP32_DEBUG_BUSFREE, "command complete");
 
-		SCpnt->SCp.Status  = nsp32_read1(base, SCSI_CSB_IN);
+		nsp32_priv(SCpnt)->status  = nsp32_read1(base, SCSI_CSB_IN);
 		nsp32_dbg(NSP32_DEBUG_BUSFREE,
 			  "normal end stat=0x%x resid=0x%x\n",
-			  SCpnt->SCp.Status, scsi_get_resid(SCpnt));
-		SCpnt->result = (DID_OK << 16) |
-			(SCpnt->SCp.Status << 0);
+			  nsp32_priv(SCpnt)->status, scsi_get_resid(SCpnt));
+		SCpnt->result = nsp32_priv(SCpnt)->status;
 		nsp32_scsi_done(SCpnt);
 		/* All operation is done */
 		return TRUE;
 	} else if (execph & MSGIN_04_VALID) {
 		/* MsgIn 04: Disconnect */
-		SCpnt->SCp.Status  = nsp32_read1(base, SCSI_CSB_IN);
+		nsp32_priv(SCpnt)->status = nsp32_read1(base, SCSI_CSB_IN);
 
 		nsp32_dbg(NSP32_DEBUG_BUSFREE, "disconnect");
 		return TRUE;
@@ -1706,8 +1701,6 @@ static int nsp32_busfree_occur(struct scsi_cmnd *SCpnt, unsigned short execph)
 		/* Unexpected bus free */
 		nsp32_msg(KERN_WARNING, "unexpected bus free occurred");
 
-		/* DID_ERROR? */
-		//SCpnt->result   = (DID_OK << 16) | (SCpnt->SCp.Status << 0);
 		SCpnt->result = DID_ERROR << 16;
 		nsp32_scsi_done(SCpnt);
 		return TRUE;
diff --git a/drivers/scsi/nsp32.h b/drivers/scsi/nsp32.h
index ab0726c070f7..924889f8bd37 100644
--- a/drivers/scsi/nsp32.h
+++ b/drivers/scsi/nsp32.h
@@ -534,6 +534,15 @@ typedef struct _nsp32_sync_table {
       ---PERIOD-- ---OFFSET--   */
 #define TO_SYNCREG(period, offset) (((period) & 0x0f) << 4 | ((offset) & 0x0f))
 
+struct nsp32_cmd_priv {
+	enum sam_status status;
+};
+
+static inline struct nsp32_cmd_priv *nsp32_priv(struct scsi_cmnd *cmd)
+{
+	return scsi_cmd_priv(cmd);
+}
+
 typedef struct _nsp32_target {
 	unsigned char	syncreg;	/* value for SYNCREG   */
 	unsigned char	ackwidth;	/* value for ACKWIDTH  */
