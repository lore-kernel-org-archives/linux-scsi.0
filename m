Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA554EB64DA
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 17:54:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbjGLRyD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 13:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232806AbjGLRxt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 13:53:49 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65F61FD2
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 10:53:42 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1b898cfa6a1so10687285ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 10:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689184422; x=1689789222;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HRCuaT4jsCLBUB5bQUQivklize9chHH8wdQ7qlVT8G4=;
        b=CYZxfMIQ5n6B71FT2CYbJVfcxEBvtdztB2QDCHCFG+k3MuFiSlPZS//ZyZzwtRRWyQ
         /h3n4RxL8TVSKu3gJi4l1Oq9yshpfYqzJ/4Utn2L8MWwPvvH+9yHg0J2zsQ2PReEEqLV
         xyOVEKJB74c5ZskrAW1d31CnH19824PbUaOK+SjSlO+DFoWmlik7lST2L34ey1LwE0vZ
         Pz7/9gWC98XOUk1ThR0mszglCrQumOFLEb1Q1DjdyQ0BlmjB4QU01rrEulqi0TnVeRfr
         1C6cwaJybJG/ZgBr7zVZWcfk6uyiy0H4yS4VjxSF0m0JQoxEbWPpr4k9iXh5kv5yx6ph
         AVOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689184422; x=1689789222;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HRCuaT4jsCLBUB5bQUQivklize9chHH8wdQ7qlVT8G4=;
        b=Eo3wawvEXRBAIsG98SPp+O2wuVaBdDjvGYEV7T3HMb4wBAwTZc4G0GqjZQ/uAP0zaO
         u3FuTFtFxHMAzi9ChEbtblNh3AAgsMGKAnRZD/W+mcbW0lgWTr5tnsj13CH/w3Usyfzr
         LHbpwdx2WrTRHz7j291QMeRa+YkCEiJUPo77e9zwTamE9wGLp0zoI0R/Eg3IB9Z4h//l
         Su293s41cvz9pyi7FRYjg9yHzYQYNde6YH8EmUprFrVmruA2G6DJmQQjgeilNaMbmjm2
         u/eeDunk3pN2cv46js72S283W36moDPe7KkidFHO+bMw48DeJOLk9ONNxULyQuObY2fN
         bR1A==
X-Gm-Message-State: ABy/qLaKdzzL66tI14P0G/8BUISgMFhbYRcgEc/J1gSMZy7jH9C+vk8w
        c6sKDPl7duSPmvEIozC33v+2nVF4y3I=
X-Google-Smtp-Source: APBJJlE2gWG8YU5CDLxwbpvFCnvguQq/qPhZpMWB4oYGTUKQiAlGHLhpmqjkykGjXNu5u9Rb+YEhQA==
X-Received: by 2002:a17:902:ec81:b0:1b3:d8ac:8db3 with SMTP id x1-20020a170902ec8100b001b3d8ac8db3mr67828plg.6.1689184421973;
        Wed, 12 Jul 2023 10:53:41 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d11-20020a170902b70b00b001b898595be7sm4218459pls.291.2023.07.12.10.53.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jul 2023 10:53:41 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 06/12] lpfc: Set Establish Image Pair service parameter only for Target Functions
Date:   Wed, 12 Jul 2023 11:05:16 -0700
Message-Id: <20230712180522.112722-7-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230712180522.112722-1-justintee8345@gmail.com>
References: <20230712180522.112722-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Previously, Establish Image Pair was set in all PRLI_ACC responses
regardless if the received PRLI was from an initiator or target function.
Specific target vendors that can operate in both initiator and target mode,
may view the PRLI_ACC with Establish Image Pair set as an invalid service
parameter when operating in initiator only mode.  This causes discovery
issues later when the target switches on its target mode function.

Revise logic that determines an rport's role as an initiator or target and
set the Establish Image Pair service parameter bit only if the Target
Function bit is set.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c       | 16 +++++++++++-
 drivers/scsi/lpfc/lpfc_hw.h        |  2 ++
 drivers/scsi/lpfc/lpfc_nportdisc.c | 39 +++++++++++++++++++-----------
 3 files changed, 42 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 9a7b62d18455..aa48153c3735 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -6165,11 +6165,25 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 			npr->TaskRetryIdReq = 1;
 		}
 		npr->acceptRspCode = PRLI_REQ_EXECUTED;
-		npr->estabImagePair = 1;
+
+		/* Set image pair for complementary pairs only. */
+		if (ndlp->nlp_type & NLP_FCP_TARGET)
+			npr->estabImagePair = 1;
+		else
+			npr->estabImagePair = 0;
 		npr->readXferRdyDis = 1;
 		npr->ConfmComplAllowed = 1;
 		npr->prliType = PRLI_FCP_TYPE;
 		npr->initiatorFunc = 1;
+
+		/* Xmit PRLI ACC response tag <ulpIoTag> */
+		lpfc_printf_vlog(vport, KERN_INFO,
+				 LOG_ELS | LOG_NODE | LOG_DISCOVERY,
+				 "6014 FCP issue PRLI ACC imgpair %d "
+				 "retry %d task %d\n",
+				 npr->estabImagePair,
+				 npr->Retry, npr->TaskRetryIdReq);
+
 	} else if (prli_fc4_req == PRLI_NVME_TYPE) {
 		/* Respond with an NVME PRLI Type */
 		npr_nvme = (struct lpfc_nvme_prli *) pcmd;
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index aaea3e31944d..2108b4cb7815 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -764,6 +764,8 @@ typedef struct _PRLI {		/* Structure is in Big Endian format */
 #define PRLI_PREDEF_CONFIG    0x5
 #define PRLI_PARTIAL_SUCCESS  0x6
 #define PRLI_INVALID_PAGE_CNT 0x7
+#define PRLI_INV_SRV_PARM     0x8
+
 	uint8_t word0Reserved3;	/* FC Parm Word 0, bit 0:7 */
 
 	uint32_t origProcAssoc;	/* FC Parm Word 1, bit 0:31 */
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index b86ff9fcdf0c..6261560eb512 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -2148,6 +2148,7 @@ lpfc_cmpl_prli_prli_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	struct lpfc_nvme_prli *nvpr;
 	void *temp_ptr;
 	u32 ulp_status;
+	bool acc_imode_sps = false;
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
 	rspiocb = cmdiocb->rsp_iocb;
@@ -2182,22 +2183,32 @@ lpfc_cmpl_prli_prli_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		goto out_err;
 	}
 
-	if (npr && (npr->acceptRspCode == PRLI_REQ_EXECUTED) &&
-	    (npr->prliType == PRLI_FCP_TYPE)) {
-		lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_DISC,
-				 "6028 FCP NPR PRLI Cmpl Init %d Target %d\n",
-				 npr->initiatorFunc,
-				 npr->targetFunc);
-		if (npr->initiatorFunc)
-			ndlp->nlp_type |= NLP_FCP_INITIATOR;
-		if (npr->targetFunc) {
-			ndlp->nlp_type |= NLP_FCP_TARGET;
-			if (npr->writeXferRdyDis)
-				ndlp->nlp_flag |= NLP_FIRSTBURST;
+	if (npr && npr->prliType == PRLI_FCP_TYPE) {
+		lpfc_printf_vlog(vport, KERN_INFO,
+				 LOG_ELS | LOG_NODE | LOG_DISCOVERY,
+				 "6028 FCP NPR PRLI Cmpl Init %d Target %d "
+				 "EIP %d AccCode x%x\n",
+				 npr->initiatorFunc, npr->targetFunc,
+				 npr->estabImagePair, npr->acceptRspCode);
+
+		if (npr->acceptRspCode == PRLI_INV_SRV_PARM) {
+			/* Strict initiators don't establish an image pair. */
+			if (npr->initiatorFunc && !npr->targetFunc &&
+			    !npr->estabImagePair)
+				acc_imode_sps = true;
 		}
-		if (npr->Retry)
-			ndlp->nlp_fcp_info |= NLP_FCP_2_DEVICE;
 
+		if (npr->acceptRspCode == PRLI_REQ_EXECUTED || acc_imode_sps) {
+			if (npr->initiatorFunc)
+				ndlp->nlp_type |= NLP_FCP_INITIATOR;
+			if (npr->targetFunc) {
+				ndlp->nlp_type |= NLP_FCP_TARGET;
+				if (npr->writeXferRdyDis)
+					ndlp->nlp_flag |= NLP_FIRSTBURST;
+			}
+			if (npr->Retry)
+				ndlp->nlp_fcp_info |= NLP_FCP_2_DEVICE;
+		}
 	} else if (nvpr &&
 		   (bf_get_be32(prli_acc_rsp_code, nvpr) ==
 		    PRLI_REQ_EXECUTED) &&
-- 
2.38.0

