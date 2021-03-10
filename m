Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47C63C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 22:17:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D877164FD9
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 22:17:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbhCJWQh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 17:16:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbhCJWQH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2021 17:16:07 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99472C061760
        for <linux-scsi@vger.kernel.org>; Wed, 10 Mar 2021 14:16:06 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id mm21so41877161ejb.12
        for <linux-scsi@vger.kernel.org>; Wed, 10 Mar 2021 14:16:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=re8TUbsE0dO0c8tinrCkKpAasXzv2AM9ceRsQ1QF7n8=;
        b=hPQfozB12KC6qu+yv8shLRVXpJz7Xpjo/SCPBi3uQd0Ey/KRKrBdnU0WUX9A9PUjQU
         GZP9qfg2OCppE8tosQf8BQCtbVIFK0rj9a0kDOBRI8/6+vLNfEuFgUcg94qmHIgcCWtD
         VoTDjG1snTNU5DzGYySypXPbtYhLFMZi5anj4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=re8TUbsE0dO0c8tinrCkKpAasXzv2AM9ceRsQ1QF7n8=;
        b=YFZNHWm3o9mG8aJi9c42/VfCjQ8SwddgzogVEztKqv8oJ36LEiuroOcjj3X4T/ErGs
         Al7boUT2j1fnctYucGIs3X+cB2zhBK/uZinpIp9hV8LXZNJvmxKEG9UeHaGzCVWtOVCh
         iz7xh/tFdVcfuydQ7xt6bMGZYOXl5O7rcXexT4dnRwX15IWJ9hSlvj9cQrSpzIrf74aA
         iR7sqUyA8LwKpg3lkvyrWCN1Dlsf7nUSuU/O3A3NuY8CXvJKX0v07BDRRdei6ORj0+Gn
         iwnDfLHvorsNa1xR30/wSx+UBVIVwjGhL/CGm1pMXQ/MiyI4/GmxnRVl2sB6v1LrUX6J
         YqyQ==
X-Gm-Message-State: AOAM530wdOP/DlQfeRoztGMbwd7tv/8YPXCFcZBfYBGYuAVupzfjNo44
        JSiQd8bab4PyNTUybK7VsNxOWg==
X-Google-Smtp-Source: ABdhPJy7fJyPDrOoycZMA2cHillh2M2zKhNgHdYE/o5cj7n9CplbTPPYDPVV3dAW9mPZ9vn8Ymd7jQ==
X-Received: by 2002:a17:906:2804:: with SMTP id r4mr56347ejc.521.1615414565286;
        Wed, 10 Mar 2021 14:16:05 -0800 (PST)
Received: from prevas-ravi.prevas.se ([80.208.71.248])
        by smtp.gmail.com with ESMTPSA id b4sm281105edh.40.2021.03.10.14.16.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 14:16:04 -0800 (PST)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: bnx2i: make bnx2i_process_iscsi_error simpler and more robust
Date:   Wed, 10 Mar 2021 23:16:02 +0100
Message-Id: <20210310221602.2494422-1-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of strcpy'ing into a stack buffer, just let additional_notice
point to a string literal living in .rodata. This is better in a few
ways:

- Smaller .text - instead of gcc compiling the strcpys as a bunch of
  immediate stores (effectively encoding the string literal in the
  instruction stream), we only pay the price of storing the literal in
  .rodata.

- Faster, because there's no string copying.

- Smaller stack usage (with my compiler, 72 bytes instead of 176 for
  the sole caller, bnx2i_indicate_kcqe)

Moreover, it's currently possible for additional_notice[] to get used
uninitialized, so some random stack garbage would be passed to
printk() - in the worst case without any '\0' anywhere in those 64
bytes. That could be fixed by initializing additional_notice[0], but
the same is achieved here by initializing the new pointer variable to
"".

Also give the message pointer a similar treatment - there's no point
making temporary copies on the stack of those two strings.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/scsi/bnx2i/bnx2i_hwi.c | 85 ++++++++++++++++------------------
 1 file changed, 41 insertions(+), 44 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index bad396e5c601..43e8a1dafec0 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -2206,10 +2206,8 @@ static void bnx2i_process_iscsi_error(struct bnx2i_hba *hba,
 {
 	struct bnx2i_conn *bnx2i_conn;
 	u32 iscsi_cid;
-	char warn_notice[] = "iscsi_warning";
-	char error_notice[] = "iscsi_error";
-	char additional_notice[64];
-	char *message;
+	const char *additional_notice = "";
+	const char *message;
 	int need_recovery;
 	u64 err_mask64;
 
@@ -2224,133 +2222,132 @@ static void bnx2i_process_iscsi_error(struct bnx2i_hba *hba,
 
 	if (err_mask64 & iscsi_error_mask) {
 		need_recovery = 0;
-		message = warn_notice;
+		message = "iscsi_warning";
 	} else {
 		need_recovery = 1;
-		message = error_notice;
+		message = "iscsi_error";
 	}
 
 	switch (iscsi_err->completion_status) {
 	case ISCSI_KCQE_COMPLETION_STATUS_HDR_DIG_ERR:
-		strcpy(additional_notice, "hdr digest err");
+		additional_notice = "hdr digest err";
 		break;
 	case ISCSI_KCQE_COMPLETION_STATUS_DATA_DIG_ERR:
-		strcpy(additional_notice, "data digest err");
+		additional_notice = "data digest err";
 		break;
 	case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_OPCODE:
-		strcpy(additional_notice, "wrong opcode rcvd");
+		additional_notice = "wrong opcode rcvd";
 		break;
 	case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_AHS_LEN:
-		strcpy(additional_notice, "AHS len > 0 rcvd");
+		additional_notice = "AHS len > 0 rcvd";
 		break;
 	case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_ITT:
-		strcpy(additional_notice, "invalid ITT rcvd");
+		additional_notice = "invalid ITT rcvd";
 		break;
 	case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_STATSN:
-		strcpy(additional_notice, "wrong StatSN rcvd");
+		additional_notice = "wrong StatSN rcvd";
 		break;
 	case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_EXP_DATASN:
-		strcpy(additional_notice, "wrong DataSN rcvd");
+		additional_notice = "wrong DataSN rcvd";
 		break;
 	case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_PEND_R2T:
-		strcpy(additional_notice, "pend R2T violation");
+		additional_notice = "pend R2T violation";
 		break;
 	case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_O_U_0:
-		strcpy(additional_notice, "ERL0, UO");
+		additional_notice = "ERL0, UO";
 		break;
 	case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_O_U_1:
-		strcpy(additional_notice, "ERL0, U1");
+		additional_notice = "ERL0, U1";
 		break;
 	case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_O_U_2:
-		strcpy(additional_notice, "ERL0, U2");
+		additional_notice = "ERL0, U2";
 		break;
 	case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_O_U_3:
-		strcpy(additional_notice, "ERL0, U3");
+		additional_notice = "ERL0, U3";
 		break;
 	case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_O_U_4:
-		strcpy(additional_notice, "ERL0, U4");
+		additional_notice = "ERL0, U4";
 		break;
 	case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_O_U_5:
-		strcpy(additional_notice, "ERL0, U5");
+		additional_notice = "ERL0, U5";
 		break;
 	case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_O_U_6:
-		strcpy(additional_notice, "ERL0, U6");
+		additional_notice = "ERL0, U6";
 		break;
 	case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_REMAIN_RCV_LEN:
-		strcpy(additional_notice, "invalid resi len");
+		additional_notice = "invalid resi len";
 		break;
 	case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_MAX_RCV_PDU_LEN:
-		strcpy(additional_notice, "MRDSL violation");
+		additional_notice = "MRDSL violation";
 		break;
 	case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_F_BIT_ZERO:
-		strcpy(additional_notice, "F-bit not set");
+		additional_notice = "F-bit not set";
 		break;
 	case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_TTT_NOT_RSRV:
-		strcpy(additional_notice, "invalid TTT");
+		additional_notice = "invalid TTT";
 		break;
 	case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_DATASN:
-		strcpy(additional_notice, "invalid DataSN");
+		additional_notice = "invalid DataSN";
 		break;
 	case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_REMAIN_BURST_LEN:
-		strcpy(additional_notice, "burst len violation");
+		additional_notice = "burst len violation";
 		break;
 	case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_BUFFER_OFF:
-		strcpy(additional_notice, "buf offset violation");
+		additional_notice = "buf offset violation";
 		break;
 	case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_LUN:
-		strcpy(additional_notice, "invalid LUN field");
+		additional_notice = "invalid LUN field";
 		break;
 	case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_R2TSN:
-		strcpy(additional_notice, "invalid R2TSN field");
+		additional_notice = "invalid R2TSN field";
 		break;
 #define BNX2I_ERR_DESIRED_DATA_TRNS_LEN_0 	\
 	ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_DESIRED_DATA_TRNS_LEN_0
 	case BNX2I_ERR_DESIRED_DATA_TRNS_LEN_0:
-		strcpy(additional_notice, "invalid cmd len1");
+		additional_notice = "invalid cmd len1";
 		break;
 #define BNX2I_ERR_DESIRED_DATA_TRNS_LEN_1 	\
 	ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_DESIRED_DATA_TRNS_LEN_1
 	case BNX2I_ERR_DESIRED_DATA_TRNS_LEN_1:
-		strcpy(additional_notice, "invalid cmd len2");
+		additional_notice = "invalid cmd len2";
 		break;
 	case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_PEND_R2T_EXCEED:
-		strcpy(additional_notice,
-		       "pend r2t exceeds MaxOutstandingR2T value");
+		additional_notice = "pend r2t exceeds MaxOutstandingR2T value";
 		break;
 	case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_TTT_IS_RSRV:
-		strcpy(additional_notice, "TTT is rsvd");
+		additional_notice = "TTT is rsvd";
 		break;
 	case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_MAX_BURST_LEN:
-		strcpy(additional_notice, "MBL violation");
+		additional_notice = "MBL violation";
 		break;
 #define BNX2I_ERR_DATA_SEG_LEN_NOT_ZERO 	\
 	ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_DATA_SEG_LEN_NOT_ZERO
 	case BNX2I_ERR_DATA_SEG_LEN_NOT_ZERO:
-		strcpy(additional_notice, "data seg len != 0");
+		additional_notice = "data seg len != 0";
 		break;
 	case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_REJECT_PDU_LEN:
-		strcpy(additional_notice, "reject pdu len error");
+		additional_notice = "reject pdu len error";
 		break;
 	case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_ASYNC_PDU_LEN:
-		strcpy(additional_notice, "async pdu len error");
+		additional_notice = "async pdu len error";
 		break;
 	case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_NOPIN_PDU_LEN:
-		strcpy(additional_notice, "nopin pdu len error");
+		additional_notice = "nopin pdu len error";
 		break;
 #define BNX2_ERR_PEND_R2T_IN_CLEANUP			\
 	ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_PEND_R2T_IN_CLEANUP
 	case BNX2_ERR_PEND_R2T_IN_CLEANUP:
-		strcpy(additional_notice, "pend r2t in cleanup");
+		additional_notice = "pend r2t in cleanup";
 		break;
 
 	case ISCI_KCQE_COMPLETION_STATUS_TCP_ERROR_IP_FRAGMENT:
-		strcpy(additional_notice, "IP fragments rcvd");
+		additional_notice = "IP fragments rcvd";
 		break;
 	case ISCI_KCQE_COMPLETION_STATUS_TCP_ERROR_IP_OPTIONS:
-		strcpy(additional_notice, "IP options error");
+		additional_notice = "IP options error";
 		break;
 	case ISCI_KCQE_COMPLETION_STATUS_TCP_ERROR_URGENT_FLAG:
-		strcpy(additional_notice, "urgent flag error");
+		additional_notice = "urgent flag error";
 		break;
 	default:
 		printk(KERN_ALERT "iscsi_err - unknown err %x\n",
-- 
2.29.2

