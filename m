Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42330C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jun 2022 17:47:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235330AbiFCRrQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jun 2022 13:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345338AbiFCRqh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2022 13:46:37 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F58113
        for <linux-scsi@vger.kernel.org>; Fri,  3 Jun 2022 10:43:41 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id y196so7674259pfb.6
        for <linux-scsi@vger.kernel.org>; Fri, 03 Jun 2022 10:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H3fGv6f6ahm7AUtf7HLsl1aw/0UhET0VMaciuYsywx8=;
        b=PGzqV/4ZHA2UsJwvSzgmLgKLBZMNNx1WuS/mfNTrcpPTLXJQitqtEdrbpS5l/SjeVB
         ckLS/SxQbBTE8J7dVzFSb8kA6kpV6MWRo3tdtT4kFNIaMUyAbRkYxE9UUn0cDzEIUYIU
         rj6AlWchUwEqHgYRW5ueCbcK/kzMIrA36rZWE8Mm975Da5fzeo9pGhr0PvoWKVzk1yo7
         V9aMb9/pSl07mtd8fxEGJj6wJACS1BqdD2u9LX45tmhF8XkIPKAdtKaDAQYgGx7p93iS
         259SMFAuWqcVgT06CJy72LZ/jLXsVcHk0+V2UdiBgMJBHHpWaAzGLasiTRDqdCk89EXa
         mksA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H3fGv6f6ahm7AUtf7HLsl1aw/0UhET0VMaciuYsywx8=;
        b=p86E9WHBvHPzrwwSZJrGHQKlFMnCqnr7l5yZEkowVohlLhlu8WzgWD3erCevetnRZi
         jqBpiuQps1JorK3PUvIMJ/zPRUVnS9Yo2XewEQliqEf2hsWVQI8AGAtc4dEiOOJdOIT5
         TDwZnPAlC+J6uTo7kNVBq9ZjS4fgOuMrb7frHZekMrPaOtxd2jYQ5mUvnHHzvatc6gch
         EqKTAnN/ZVtvWSjF0uhHdKDpcTYdxCJWNNAbcMCEPocJgJ+6xMNwoo/jtoO1DJWDObmN
         g2G4YAX1p9d04m2GrefEwbcVRbV6FFa0JGjKwCs/2RsqQkgOXW2mTWMFf+NCAwol2yth
         rlRg==
X-Gm-Message-State: AOAM532i5tmSRf4w56yOWG2TUff4YEBH5mMWxgBTgjfleb3TxF/UdfDL
        I0u6cgO11iSQ13ys4J30DAhip6h10XE=
X-Google-Smtp-Source: ABdhPJwpg+1gIKOa4hZt+OW95ELQft/5Y6GaPcOZzrprlKejQYo5zTZ5GQh9vamiT1rN2SG9MnBF8g==
X-Received: by 2002:a62:868c:0:b0:51b:bd62:4c87 with SMTP id x134-20020a62868c000000b0051bbd624c87mr11243505pfd.83.1654278221183;
        Fri, 03 Jun 2022 10:43:41 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id a13-20020a170902710d00b0015e8d4eb1d2sm5705047pll.28.2022.06.03.10.43.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 10:43:40 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 7/9] lpfc: Add more logging of cmd and cqe information for aborted NVME cmds
Date:   Fri,  3 Jun 2022 10:43:27 -0700
Message-Id: <20220603174329.63777-8-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220603174329.63777-1-jsmart2021@gmail.com>
References: <20220603174329.63777-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When an NVME command is aborted or completes with an ERSP, log the opcode
and command id fields to help provide more detail on the failed command.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 88fa630ab93a..9cc22cefcb37 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1065,25 +1065,37 @@ lpfc_nvme_io_cmd_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 			nCmd->rcv_rsplen = wcqe->parameter;
 			nCmd->status = 0;
 
+			/* Get the NVME cmd details for this unique error. */
+			cp = (struct nvme_fc_cmd_iu *)nCmd->cmdaddr;
+			ep = (struct nvme_fc_ersp_iu *)nCmd->rspaddr;
+
 			/* Check if this is really an ERSP */
 			if (nCmd->rcv_rsplen == LPFC_NVME_ERSP_LEN) {
 				lpfc_ncmd->status = IOSTAT_SUCCESS;
 				lpfc_ncmd->result = 0;
 
 				lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME,
-					 "6084 NVME Completion ERSP: "
-					 "xri %x placed x%x\n",
-					 lpfc_ncmd->cur_iocbq.sli4_xritag,
-					 wcqe->total_data_placed);
+					"6084 NVME FCP_ERR ERSP: "
+					"xri %x placed x%x opcode x%x cmd_id "
+					"x%x cqe_status x%x\n",
+					lpfc_ncmd->cur_iocbq.sli4_xritag,
+					wcqe->total_data_placed,
+					cp->sqe.common.opcode,
+					cp->sqe.common.command_id,
+					ep->cqe.status);
 				break;
 			}
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 					 "6081 NVME Completion Protocol Error: "
 					 "xri %x status x%x result x%x "
-					 "placed x%x\n",
+					 "placed x%x opcode x%x cmd_id x%x, "
+					 "cqe_status x%x\n",
 					 lpfc_ncmd->cur_iocbq.sli4_xritag,
 					 lpfc_ncmd->status, lpfc_ncmd->result,
-					 wcqe->total_data_placed);
+					 wcqe->total_data_placed,
+					 cp->sqe.common.opcode,
+					 cp->sqe.common.command_id,
+					 ep->cqe.status);
 			break;
 		case IOSTAT_LOCAL_REJECT:
 			/* Let fall through to set command final state. */
@@ -1842,6 +1854,7 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 	struct lpfc_nvme_fcpreq_priv *freqpriv;
 	unsigned long flags;
 	int ret_val;
+	struct nvme_fc_cmd_iu *cp;
 
 	/* Validate pointers. LLDD fault handling with transport does
 	 * have timing races.
@@ -1965,10 +1978,16 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 		return;
 	}
 
+	/*
+	 * Get Command Id from cmd to plug into response. This
+	 * code is not needed in the next NVME Transport drop.
+	 */
+	cp = (struct nvme_fc_cmd_iu *)lpfc_nbuf->nvmeCmd->cmdaddr;
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_ABTS,
 			 "6138 Transport Abort NVME Request Issued for "
-			 "ox_id x%x\n",
-			 nvmereq_wqe->sli4_xritag);
+			 "ox_id x%x nvme opcode x%x nvme cmd_id x%x\n",
+			 nvmereq_wqe->sli4_xritag, cp->sqe.common.opcode,
+			 cp->sqe.common.command_id);
 	return;
 
 out_unlock:
-- 
2.26.2

