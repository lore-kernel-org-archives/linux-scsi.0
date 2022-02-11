Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9BE3C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 22:34:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354148AbiBKWej (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 17:34:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345288AbiBKWeY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 17:34:24 -0500
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213F9D52
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:34:23 -0800 (PST)
Received: by mail-pf1-f176.google.com with SMTP id y8so15934760pfa.11
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:34:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M626oeIUbG2zGaulksUEFkg9FXBl3IKSZyVT8/qb9YY=;
        b=MXznd7Aocd5f1WTbEIwPLwaTWf4VBgtSc+SuNpJo6maTvPqWO/C48Hsqo1sMTSUGFY
         suaYb2EZBr8H0pz0S3WmgUjRLRipBWsRTnOPZdYxEO9uHKKVSsEJ4lrHW0WIMcyHqEAa
         WG5ValbAuWwrrlCFvep/1b8v6xpaz0yXmQZzTKcpjIUlhJ/5ETXHuepasu9/awupQM5B
         gbXB4pkgNpAqso/rrAD2kxDHPLhlQFN1ZkqTRvJJ9uFHBbiqnbjXFgo3eHZYzjlR0uv9
         pmAiDMDfvptlj+nA65qY8xbOh6gGm77OHXReDYOT9HZ5gIarMRF6E8MpN3GYYwxTD++P
         fhfw==
X-Gm-Message-State: AOAM531MJOaXdTWI4nN0bjBMHBKNv0Qvf4MKAbAX7cubuPMKM9OfkOX7
        HehaZpt8timOwsWo86kk+E4=
X-Google-Smtp-Source: ABdhPJx6xEGwHhKNIJZGaI14JmDV7mPXX1ba4CdkSFwWmt60rtpZyCpt0k5Oc0xNTBeNtqdtj+Ht6w==
X-Received: by 2002:a62:4e44:: with SMTP id c65mr3765564pfb.1.1644618862459;
        Fri, 11 Feb 2022 14:34:22 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id n13sm6296733pjq.13.2022.02.11.14.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 14:34:21 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        GOTO Masanori <gotom@debian.or.jp>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 36/48] scsi: nsp32: Stop using the SCSI pointer
Date:   Fri, 11 Feb 2022 14:32:35 -0800
Message-Id: <20220211223247.14369-37-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220211223247.14369-1-bvanassche@acm.org>
References: <20220211223247.14369-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the SCSI status field to private data. Stop setting the .ptr,
.this_residual, .buffer and .buffer_residual SCSI pointer members
since no code in this driver reads these members.

This patch prepares for removal of the SCSI pointer from struct scsi_cmnd.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
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
