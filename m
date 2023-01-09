Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB516C5479D
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Jan 2023 23:23:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237841AbjAIXXH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Jan 2023 18:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237745AbjAIXW5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2023 18:22:57 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D94959C
        for <linux-scsi@vger.kernel.org>; Mon,  9 Jan 2023 15:22:56 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id d3so11277159plr.10
        for <linux-scsi@vger.kernel.org>; Mon, 09 Jan 2023 15:22:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xNjnenLgmHscIgh8ZHvPtXCMJHVu7Vx+kT9mf5z0Hco=;
        b=TM9D3MvkgIfQGqR0OZ4qqrgYGLUVgKMVyA49nJQnUBLR4xl9kg3WXm667CYrG/132y
         ZHYNUVt0JoB9b/+Z/tmjSEuedsK69Cy+iTUlLojpy3Led3jB6lhsRjm72MAjUVq8pxFg
         F87BiwSydveGiGJ21Kd471pEQiwrA0TbcmPVGBtxncg0rCJhthP6Cmj6YDLmC+ikZ8sh
         ojSIjsHlnIPT6jg3SbLR5Zv/iSWPhXoSMtBx8viPUyZ4jjEoTZoSBsuV5Vfab8QTLGKP
         T0bhEtKLTuAQhBSljMFIVgyUl08JX8rqLF7OzHD99SdPe3+ytgRnQv/lbpkKd9dAQkaH
         Aq5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xNjnenLgmHscIgh8ZHvPtXCMJHVu7Vx+kT9mf5z0Hco=;
        b=A9WUhUgEQ4SfoCjjO1cn9gnvQQ8RAcYw+QPZ5NHYBLm3BDG7jSJfYCRrm0KnZVAUFL
         FzzffyjPdZYgQtEOqnRn2LC4a7Vy4OvoENvWSPk4YILMjTZKPErdrEhZqLoIT1BkqF25
         iMq7QQYwtqBMuPznhHWhHxwbSTo95oNqB5lfTJuAeqj4Vq33ZxlziIl1swACI2uVAt9Y
         1gDq9pPNmIDAIByivbe6/nmfnQhS45YaoOpQqgybwHY1NH7CyrQh5JkRF6uKe9UOcD4Z
         QfM8HlSiFdOxCLgotXkLq49P3kcKcrZACoDNkFm16T/utIKeN7p3jJu5ffsR8/6HyPu/
         SeQA==
X-Gm-Message-State: AFqh2kqGBjvlXBpnpBF1cmumF1Ex68lOQhCqb83bElhSkPhzCK+ewKGt
        JwDuta6SGNcErkOshDH4tAk9WKc+gp4=
X-Google-Smtp-Source: AMrXdXuY0TYB+1BJUI6rfd2mMR6WepxFWNVxVYjYkRBJqqxZdYOf28fIwzDej1XHeLYlTYMO/49sOA==
X-Received: by 2002:a17:902:edc3:b0:189:e577:c83d with SMTP id q3-20020a170902edc300b00189e577c83dmr59695846plk.66.1673306575638;
        Mon, 09 Jan 2023 15:22:55 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d22-20020a170902aa9600b001871461688esm6628572plr.175.2023.01.09.15.22.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Jan 2023 15:22:55 -0800 (PST)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 10/12] lpfc: Introduce new attention types for lpfc_sli4_async_fc_evt hdlr
Date:   Mon,  9 Jan 2023 15:33:15 -0800
Message-Id: <20230109233317.54737-11-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230109233317.54737-1-justintee8345@gmail.com>
References: <20230109233317.54737-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Define new FC Link ACQE with new attention types 0x8 (Link Activation
Failure) and 0x9 (Link Reset Protocol Event).

Both attention types are meant to be informational-only type ACQEs with
no action required.

0x8 is reported for diagnostic purposes, while 0x9 is posted during a
normal link up transition when activating BB Credit Recovery feature.

As such, modify lpfc_sli4_async_fc_evt logic to log the attention types
according to its severity and early return when informational-only
attention types are encountered.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hw4.h  |  5 +++
 drivers/scsi/lpfc/lpfc_init.c | 85 ++++++++++++++++++++++++++++-------
 drivers/scsi/lpfc/lpfc_sli4.h |  3 +-
 3 files changed, 77 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index fb3504dbb899..58589eb1a358 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -4201,6 +4201,8 @@ struct lpfc_acqe_fc_la {
 #define LPFC_FC_LA_TYPE_MDS_LOOPBACK	0x5
 #define LPFC_FC_LA_TYPE_UNEXP_WWPN	0x6
 #define LPFC_FC_LA_TYPE_TRUNKING_EVENT  0x7
+#define LPFC_FC_LA_TYPE_ACTIVATE_FAIL		0x8
+#define LPFC_FC_LA_TYPE_LINK_RESET_PRTCL_EVT	0x9
 #define lpfc_acqe_fc_la_port_type_SHIFT		6
 #define lpfc_acqe_fc_la_port_type_MASK		0x00000003
 #define lpfc_acqe_fc_la_port_type_WORD		word0
@@ -4242,6 +4244,9 @@ struct lpfc_acqe_fc_la {
 #define lpfc_acqe_fc_la_fault_SHIFT		0
 #define lpfc_acqe_fc_la_fault_MASK		0x000000FF
 #define lpfc_acqe_fc_la_fault_WORD		word1
+#define lpfc_acqe_fc_la_link_status_SHIFT	8
+#define lpfc_acqe_fc_la_link_status_MASK	0x0000007F
+#define lpfc_acqe_fc_la_link_status_WORD	word1
 #define lpfc_acqe_fc_la_trunk_fault_SHIFT		0
 #define lpfc_acqe_fc_la_trunk_fault_MASK		0x0000000F
 #define lpfc_acqe_fc_la_trunk_fault_WORD		word1
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 4d58373f6ab6..0fef8cd38ecf 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5189,16 +5189,25 @@ static void
 lpfc_sli4_parse_latt_fault(struct lpfc_hba *phba,
 			   struct lpfc_acqe_link *acqe_link)
 {
-	switch (bf_get(lpfc_acqe_link_fault, acqe_link)) {
-	case LPFC_ASYNC_LINK_FAULT_NONE:
-	case LPFC_ASYNC_LINK_FAULT_LOCAL:
-	case LPFC_ASYNC_LINK_FAULT_REMOTE:
-	case LPFC_ASYNC_LINK_FAULT_LR_LRR:
+	switch (bf_get(lpfc_acqe_fc_la_att_type, acqe_link)) {
+	case LPFC_FC_LA_TYPE_LINK_DOWN:
+	case LPFC_FC_LA_TYPE_TRUNKING_EVENT:
+	case LPFC_FC_LA_TYPE_ACTIVATE_FAIL:
+	case LPFC_FC_LA_TYPE_LINK_RESET_PRTCL_EVT:
 		break;
 	default:
-		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
-				"0398 Unknown link fault code: x%x\n",
-				bf_get(lpfc_acqe_link_fault, acqe_link));
+		switch (bf_get(lpfc_acqe_link_fault, acqe_link)) {
+		case LPFC_ASYNC_LINK_FAULT_NONE:
+		case LPFC_ASYNC_LINK_FAULT_LOCAL:
+		case LPFC_ASYNC_LINK_FAULT_REMOTE:
+		case LPFC_ASYNC_LINK_FAULT_LR_LRR:
+			break;
+		default:
+			lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
+					"0398 Unknown link fault code: x%x\n",
+					bf_get(lpfc_acqe_link_fault, acqe_link));
+			break;
+		}
 		break;
 	}
 }
@@ -6281,6 +6290,7 @@ lpfc_sli4_async_fc_evt(struct lpfc_hba *phba, struct lpfc_acqe_fc_la *acqe_fc)
 	LPFC_MBOXQ_t *pmb;
 	MAILBOX_t *mb;
 	struct lpfc_mbx_read_top *la;
+	char *log_level;
 	int rc;
 
 	if (bf_get(lpfc_trailer_type, acqe_fc) !=
@@ -6312,25 +6322,70 @@ lpfc_sli4_async_fc_evt(struct lpfc_hba *phba, struct lpfc_acqe_fc_la *acqe_fc)
 				bf_get(lpfc_acqe_fc_la_port_number, acqe_fc);
 	phba->sli4_hba.link_state.fault =
 				bf_get(lpfc_acqe_link_fault, acqe_fc);
+	phba->sli4_hba.link_state.link_status =
+				bf_get(lpfc_acqe_fc_la_link_status, acqe_fc);
 
-	if (bf_get(lpfc_acqe_fc_la_att_type, acqe_fc) ==
-	    LPFC_FC_LA_TYPE_LINK_DOWN)
-		phba->sli4_hba.link_state.logical_speed = 0;
-	else if (!phba->sli4_hba.conf_trunk)
-		phba->sli4_hba.link_state.logical_speed =
+	/*
+	 * Only select attention types need logical speed modification to what
+	 * was previously set.
+	 */
+	if (phba->sli4_hba.link_state.status >= LPFC_FC_LA_TYPE_LINK_UP &&
+	    phba->sli4_hba.link_state.status < LPFC_FC_LA_TYPE_ACTIVATE_FAIL) {
+		if (bf_get(lpfc_acqe_fc_la_att_type, acqe_fc) ==
+		    LPFC_FC_LA_TYPE_LINK_DOWN)
+			phba->sli4_hba.link_state.logical_speed = 0;
+		else if (!phba->sli4_hba.conf_trunk)
+			phba->sli4_hba.link_state.logical_speed =
 				bf_get(lpfc_acqe_fc_la_llink_spd, acqe_fc) * 10;
+	}
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
 			"2896 Async FC event - Speed:%dGBaud Topology:x%x "
 			"LA Type:x%x Port Type:%d Port Number:%d Logical speed:"
-			"%dMbps Fault:%d\n",
+			"%dMbps Fault:x%x Link Status:x%x\n",
 			phba->sli4_hba.link_state.speed,
 			phba->sli4_hba.link_state.topology,
 			phba->sli4_hba.link_state.status,
 			phba->sli4_hba.link_state.type,
 			phba->sli4_hba.link_state.number,
 			phba->sli4_hba.link_state.logical_speed,
-			phba->sli4_hba.link_state.fault);
+			phba->sli4_hba.link_state.fault,
+			phba->sli4_hba.link_state.link_status);
+
+	/*
+	 * The following attention types are informational only, providing
+	 * further details about link status.  Overwrite the value of
+	 * link_state.status appropriately.  No further action is required.
+	 */
+	if (phba->sli4_hba.link_state.status >= LPFC_FC_LA_TYPE_ACTIVATE_FAIL) {
+		switch (phba->sli4_hba.link_state.status) {
+		case LPFC_FC_LA_TYPE_ACTIVATE_FAIL:
+			log_level = KERN_WARNING;
+			phba->sli4_hba.link_state.status =
+					LPFC_FC_LA_TYPE_LINK_DOWN;
+			break;
+		case LPFC_FC_LA_TYPE_LINK_RESET_PRTCL_EVT:
+			/*
+			 * During bb credit recovery establishment, receiving
+			 * this attention type is normal.  Link Up attention
+			 * type is expected to occur before this informational
+			 * attention type so keep the Link Up status.
+			 */
+			log_level = KERN_INFO;
+			phba->sli4_hba.link_state.status =
+					LPFC_FC_LA_TYPE_LINK_UP;
+			break;
+		default:
+			log_level = KERN_INFO;
+			break;
+		}
+		lpfc_log_msg(phba, log_level, LOG_SLI,
+			     "2992 Async FC event - Informational Link "
+			     "Attention Type x%x\n",
+			     bf_get(lpfc_acqe_fc_la_att_type, acqe_fc));
+		return;
+	}
+
 	pmb = (LPFC_MBOXQ_t *)mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!pmb) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index f927c2a25d54..babdf29245d4 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -291,8 +291,9 @@ struct lpfc_sli4_link {
 	uint8_t type;
 	uint8_t number;
 	uint8_t fault;
-	uint32_t logical_speed;
+	uint8_t link_status;
 	uint16_t topology;
+	uint32_t logical_speed;
 };
 
 struct lpfc_fcf_rec {
-- 
2.38.0

