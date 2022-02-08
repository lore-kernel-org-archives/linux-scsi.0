Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E831BC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 17:27:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384338AbiBHR1B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 12:27:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384272AbiBHR0w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 12:26:52 -0500
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BFF0C0613CA
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 09:26:42 -0800 (PST)
Received: by mail-pl1-f169.google.com with SMTP id y17so14405194plg.7
        for <linux-scsi@vger.kernel.org>; Tue, 08 Feb 2022 09:26:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/5EdyuTNVg6sZ157Rtveqt3McwZbam1y5igdSu8x4L8=;
        b=gdXynD5nE4v5W94SIH1eaSfWFIiideSxxxpHzS525eqzLT+B5aNbgLCKzJ4ZUcMxKL
         2l7DFJSVIFpXfm0sW2m22hmCRT/mLAP7cB1XFtRgWeh2SBwWjWEDQ26fzryyoQWPFBTX
         yEYBlZURPYJLRednqJXmFQ+fJbpdYl8SYXe72GJoNA1sFdYzwXTDQQ8H5cu3oAYkPo7U
         BItGPaeXXQRpJamj0sVptOl8DWknEnGy2zAdMXbHVKdmAAsyKXOerom74xrC5lAa3qgj
         naluNz4QRH3Ixadxk+FCi23aZcWTXeXPn6vV3KHHMADmqhmIiwdEjTEK0rydD+qNgcdS
         R1XA==
X-Gm-Message-State: AOAM531LzXiLi5rJvSir+DnaGcLCv4duzOzQEmTXkysjeiRA9GWwJFOR
        k7LaQ/lZmrfnZc26o353Fd4=
X-Google-Smtp-Source: ABdhPJzkO4An21Z9U4AoXlDRKWHMF2DzOsRspxwe0GnJdF56Y4TjwNU+dK+DHYz1A2+nwTrOG8A+9g==
X-Received: by 2002:a17:90a:6585:: with SMTP id k5mr2501211pjj.94.1644341201547;
        Tue, 08 Feb 2022 09:26:41 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q1sm335116pfs.112.2022.02.08.09.26.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 09:26:40 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        GOTO Masanori <gotom@debian.or.jp>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 32/44] nsp32: Stop using the SCSI pointer
Date:   Tue,  8 Feb 2022 09:25:02 -0800
Message-Id: <20220208172514.3481-33-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220208172514.3481-1-bvanassche@acm.org>
References: <20220208172514.3481-1-bvanassche@acm.org>
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
 drivers/scsi/nsp32.c | 20 +++++++-------------
 drivers/scsi/nsp32.h |  9 +++++++++
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index bd3ee3bf08ee..75bb0028ed74 100644
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
@@ -1687,18 +1683,18 @@ static int nsp32_busfree_occur(struct scsi_cmnd *SCpnt, unsigned short execph)
 		/* MsgIn 00: Command Complete */
 		nsp32_dbg(NSP32_DEBUG_BUSFREE, "command complete");
 
-		SCpnt->SCp.Status  = nsp32_read1(base, SCSI_CSB_IN);
+		nsp32_priv(SCpnt)->status  = nsp32_read1(base, SCSI_CSB_IN);
 		nsp32_dbg(NSP32_DEBUG_BUSFREE,
 			  "normal end stat=0x%x resid=0x%x\n",
-			  SCpnt->SCp.Status, scsi_get_resid(SCpnt));
+			  nsp32_priv(SCpnt)->status, scsi_get_resid(SCpnt));
 		SCpnt->result = (DID_OK << 16) |
-			(SCpnt->SCp.Status << 0);
+			(nsp32_priv(SCpnt)->status << 0);
 		nsp32_scsi_done(SCpnt);
 		/* All operation is done */
 		return TRUE;
 	} else if (execph & MSGIN_04_VALID) {
 		/* MsgIn 04: Disconnect */
-		SCpnt->SCp.Status  = nsp32_read1(base, SCSI_CSB_IN);
+		nsp32_priv(SCpnt)->status = nsp32_read1(base, SCSI_CSB_IN);
 
 		nsp32_dbg(NSP32_DEBUG_BUSFREE, "disconnect");
 		return TRUE;
@@ -1706,8 +1702,6 @@ static int nsp32_busfree_occur(struct scsi_cmnd *SCpnt, unsigned short execph)
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
