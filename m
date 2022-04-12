Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CF39C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 23:34:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbiDLXgQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbiDLXcz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 19:32:55 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A742CC625C
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:34 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id k14so3993pga.0
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ivbNd5AYk73hQwxmsnue/DMmKG7iG8zrLRkdqz5Ntxs=;
        b=Bze8/oDe3+doLIonAvZOY48tupceuWrs4m4i7CjGK+PhSWuG8oOX88aPwu3bO+6fBE
         +L1H8003x1Mcmz8Je0RZdQ3WpxMW9UHpqhDRnm9AhFVdoxCGRibMvyLvoEQAFqC/7GZD
         yVYStm8KtYFbLBPsScenIH1wTYYPLIwt/8oJrUYMu+aMiqMpHGtLPaD10qYP4CpDHV7V
         Ho24OmE1KrZ2xf7vHrU1KeUixhm+xwX+4DFodlcaoDQQqHPaXWlLcd3Z1UlD6AsZbn44
         dK5/FcP86xS+npvmyBHbUD1rZsj7TKEg/ovjAWWlDzQagksyhIq6F5hkr01dWbpamJ8N
         ziPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ivbNd5AYk73hQwxmsnue/DMmKG7iG8zrLRkdqz5Ntxs=;
        b=bTDTLkuVSRxrPStRfdD0dxhgOkMp8zZ43w8SUvVVTH2WyvuX7zOhnjJ/r8HpFrD335
         G105AzAX/Ml5NG27D/aIjOYpjDxRoG6nJZMRV6sbBl6VJiPwRiLvK8PGlM7Z4o1+PIE7
         gxoyxaP/EDhS5J31c+BKQ4lRViEeUeGmpZBpOXsgrV2nXlyGwx+8nDlNu9Wy8SWYBBCg
         W6ULrXmaXTU9QM2sonTTXhzUOThNSmmLvhHFXcc1eRdvYVpvBctQFWyQkOveNj2cjwJj
         sJaDBxJJnnGZmY8lLNhK/mGs1dQ5SIcplWLBWjoEZyRCY/d+TptlFHmw2WW+ruBA7yp4
         7Nxg==
X-Gm-Message-State: AOAM532/dzo9JnUIl7Z0WisssGLRI1RUqsUKY0N9LlY6UAEeNG6gETqP
        oDY4kYkhK2t3BpPR1AQglD9y4+qAe/Q=
X-Google-Smtp-Source: ABdhPJzV7KjmyKQRHDa2H3ZGkdol6XHOxKOZBbAxcc61lNuJCi/pYYUrVHOkmH0+l99ct4r7J9fbMg==
X-Received: by 2002:a63:b205:0:b0:381:31b6:a317 with SMTP id x5-20020a63b205000000b0038131b6a317mr32168809pge.356.1649802034115;
        Tue, 12 Apr 2022 15:20:34 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a000b8f00b004fa9dbf27desm40429824pfj.55.2022.04.12.15.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 15:20:33 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 24/26] lpfc: Expand setting ELS_ID field in ELS_REQUEST64_WQE
Date:   Tue, 12 Apr 2022 15:20:06 -0700
Message-Id: <20220412222008.126521-25-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220412222008.126521-1-jsmart2021@gmail.com>
References: <20220412222008.126521-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ELS_ID field for ELS_REQUEST64_WQE is not filled out when FIP is not
supported by the HBA.

Move setting ELS_ID logic into __lpfc_sli_prep_els_req_rsp_s4, and
remove ELS_ID FIP dependency logic from lpfc_sli_prep_wqe.

Introduce PLOGI ELS_ID and as a result update wqe_els_id_MASK because
PLOGI ELS_ID = 0x4 occupies up to 3 bits.

While in __lpfc_sli_prep_els_req_rsp_s4 routine, remove SLI3-isms.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hw4.h | 14 ++++++++-----
 drivers/scsi/lpfc/lpfc_sli.c | 38 ++++++++++++++++++++++++++----------
 2 files changed, 37 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 6d20c97762e9..8511369d2cf8 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -4476,12 +4476,8 @@ struct wqe_common {
 #define wqe_cmd_type_MASK     0x0000000f
 #define wqe_cmd_type_WORD     word11
 #define wqe_els_id_SHIFT      4
-#define wqe_els_id_MASK       0x00000003
+#define wqe_els_id_MASK       0x00000007
 #define wqe_els_id_WORD       word11
-#define LPFC_ELS_ID_FLOGI	3
-#define LPFC_ELS_ID_FDISC	2
-#define LPFC_ELS_ID_LOGO	1
-#define LPFC_ELS_ID_DEFAULT	0
 #define wqe_irsp_SHIFT        4
 #define wqe_irsp_MASK         0x00000001
 #define wqe_irsp_WORD         word11
@@ -4528,6 +4524,14 @@ struct lpfc_wqe_generic{
 	uint32_t payload[4];
 };
 
+enum els_request64_wqe_word11 {
+	LPFC_ELS_ID_DEFAULT,
+	LPFC_ELS_ID_LOGO,
+	LPFC_ELS_ID_FDISC,
+	LPFC_ELS_ID_FLOGI,
+	LPFC_ELS_ID_PLOGI,
+};
+
 struct els_request64_wqe {
 	struct ulp_bde64 bde;
 	uint32_t payload_len;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 22fe7de63fb6..8bf62697317a 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -10583,6 +10583,7 @@ __lpfc_sli_prep_els_req_rsp_s4(struct lpfc_iocbq *cmdiocbq,
 	struct lpfc_hba  *phba = vport->phba;
 	union lpfc_wqe128 *wqe;
 	struct ulp_bde64_le *bde;
+	u8 els_id;
 
 	wqe = &cmdiocbq->wqe;
 	memset(wqe, 0, sizeof(*wqe));
@@ -10595,7 +10596,7 @@ __lpfc_sli_prep_els_req_rsp_s4(struct lpfc_iocbq *cmdiocbq,
 	bde->type_size |= cpu_to_le32(ULP_BDE64_TYPE_BDE_64);
 
 	if (expect_rsp) {
-		bf_set(wqe_cmnd, &wqe->els_req.wqe_com, CMD_ELS_REQUEST64_CR);
+		bf_set(wqe_cmnd, &wqe->els_req.wqe_com, CMD_ELS_REQUEST64_WQE);
 
 		/* Transfer length */
 		wqe->els_req.payload_len = cmd_size;
@@ -10603,6 +10604,30 @@ __lpfc_sli_prep_els_req_rsp_s4(struct lpfc_iocbq *cmdiocbq,
 
 		/* DID */
 		bf_set(wqe_els_did, &wqe->els_req.wqe_dest, did);
+
+		/* Word 11 - ELS_ID */
+		switch (elscmd) {
+		case ELS_CMD_PLOGI:
+			els_id = LPFC_ELS_ID_PLOGI;
+			break;
+		case ELS_CMD_FLOGI:
+			els_id = LPFC_ELS_ID_FLOGI;
+			break;
+		case ELS_CMD_LOGO:
+			els_id = LPFC_ELS_ID_LOGO;
+			break;
+		case ELS_CMD_FDISC:
+			if (!vport->fc_myDID) {
+				els_id = LPFC_ELS_ID_FDISC;
+				break;
+			}
+			fallthrough;
+		default:
+			els_id = LPFC_ELS_ID_DEFAULT;
+			break;
+		}
+
+		bf_set(wqe_els_id, &wqe->els_req.wqe_com, els_id);
 	} else {
 		/* DID */
 		bf_set(wqe_els_did, &wqe->xmit_els_rsp.wqe_dest, did);
@@ -10611,7 +10636,7 @@ __lpfc_sli_prep_els_req_rsp_s4(struct lpfc_iocbq *cmdiocbq,
 		wqe->xmit_els_rsp.response_payload_len = cmd_size;
 
 		bf_set(wqe_cmnd, &wqe->xmit_els_rsp.wqe_com,
-		       CMD_XMIT_ELS_RSP64_CX);
+		       CMD_XMIT_ELS_RSP64_WQE);
 	}
 
 	bf_set(wqe_tmo, &wqe->generic.wqe_com, tmo);
@@ -10627,7 +10652,7 @@ __lpfc_sli_prep_els_req_rsp_s4(struct lpfc_iocbq *cmdiocbq,
 		if (expect_rsp) {
 			bf_set(els_req64_sid, &wqe->els_req, vport->fc_myDID);
 
-			/* For ELS_REQUEST64_CR, use the VPI by default */
+			/* For ELS_REQUEST64_WQE, use the VPI by default */
 			bf_set(wqe_ctxt_tag, &wqe->els_req.wqe_com,
 			       phba->vpi_ids[vport->vpi]);
 		}
@@ -22215,7 +22240,6 @@ lpfc_sli_prep_wqe(struct lpfc_hba *phba, struct lpfc_iocbq *job)
 	u32 fip, abort_tag;
 	struct lpfc_nodelist *ndlp = NULL;
 	union lpfc_wqe128 *wqe = &job->wqe;
-	u32 els_id = LPFC_ELS_ID_DEFAULT;
 	u8 command_type = ELS_COMMAND_NON_FIP;
 
 	fip = phba->hba_flag & HBA_FIP_SUPPORT;
@@ -22234,11 +22258,6 @@ lpfc_sli_prep_wqe(struct lpfc_hba *phba, struct lpfc_iocbq *job)
 	case CMD_ELS_REQUEST64_WQE:
 		ndlp = job->ndlp;
 
-		/* CCP CCPE PV PRI in word10 were set in the memcpy */
-		if (command_type == ELS_COMMAND_FIP)
-			els_id = ((job->cmd_flag & LPFC_FIP_ELS_ID_MASK)
-				  >> LPFC_FIP_ELS_ID_SHIFT);
-
 		if_type = bf_get(lpfc_sli_intf_if_type,
 				 &phba->sli4_hba.sli_intf);
 		if (if_type >= LPFC_SLI_INTF_IF_TYPE_2) {
@@ -22275,7 +22294,6 @@ lpfc_sli_prep_wqe(struct lpfc_hba *phba, struct lpfc_iocbq *job)
 		bf_set(wqe_temp_rpi, &wqe->els_req.wqe_com,
 		       phba->sli4_hba.rpi_ids[ndlp->nlp_rpi]);
 
-		bf_set(wqe_els_id, &wqe->els_req.wqe_com, els_id);
 		bf_set(wqe_dbde, &wqe->els_req.wqe_com, 1);
 		bf_set(wqe_iod, &wqe->els_req.wqe_com, LPFC_WQE_IOD_READ);
 		bf_set(wqe_qosd, &wqe->els_req.wqe_com, 1);
-- 
2.26.2

