Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23C1BECAAD3
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Sep 2022 22:15:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiIKWPj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Sep 2022 18:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiIKWPV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Sep 2022 18:15:21 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B74A17050
        for <linux-scsi@vger.kernel.org>; Sun, 11 Sep 2022 15:15:19 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id f26so2506854qto.11
        for <linux-scsi@vger.kernel.org>; Sun, 11 Sep 2022 15:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=eo6zonUoTelyaPHuaJ1ASNTkjntY3q8LMwf0+xEI+Dg=;
        b=pU8TdWYxr5WuXsbhDXftQJy6clvKh+vfwz74YCgoBAnB4wj+bxI6waQrEnP9+T+Od0
         Zwavhf90d9x4B1k3RZp3+8TaqUJ6O3LouqhX4OE3WzU24imROvxJZ9WUDtkvrMblIEr9
         BJGJl4d8tjkgS5CzMIDNYEwUif+eHVZCo7/u49vfWz3BhEKDhHK4Qnj9Sr6eyqlnRUJQ
         gwq/uoZ053oaSM5f7UI8C92ZRn5F7fEQF/hDDTaI0k8uIrOYuE9CI7oChdZ2t4nUpxd0
         elGC72RXFJr7IY+TgIwAz97n0nEiOYIFDvjqw8U81PQWpBr9Fx+0A5BIJxQJYrswsD1q
         n6iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=eo6zonUoTelyaPHuaJ1ASNTkjntY3q8LMwf0+xEI+Dg=;
        b=VhnSiR9f5mE+yfTYP8CAOuVZTnmvHkkW2a4uRwqCVD5OqFuO+y8DYboUc+Bim7J9Dj
         PlYiHovD3MDLHMl9D3lXAuk/MXgqqEhf8mlkvGFB4aK13dTkuCFlYFZGweyuuYhpLki/
         WnxQkrZgnYoEGRnvVYmm+bOPqCutF7ERKsRsRFVYnxr2Iujy/8po+YP4qMS4xHowICdB
         3Rb/w/u4WvRd821SafcpMVZE82pwvdnY1t8T1dhxW4fi8KcDgN9k49x5dQYI2EE2doVL
         R+4n8dZDOURv5UsrUNplBcTAQs3G4Rr0hh1Dlq793c8kUiiq52Ew9vCxhvBNHmXSYEUv
         Rnzg==
X-Gm-Message-State: ACgBeo2FcGXi2DEbdyE02ghXVOAO3uanMvoeKc8rfkLPDeZGRKK3gQZj
        mNuqyuwreFkjKPbGAiofxDvPGbtUHZw=
X-Google-Smtp-Source: AA6agR7d5swXCvq8lSQrj+F1K2fgT52FtKtuzegbA+S7YYRIUKE9msJSH2HtWuhhvPeRoN1QM3ruiw==
X-Received: by 2002:a05:622a:1047:b0:344:5631:3856 with SMTP id f7-20020a05622a104700b0034456313856mr21361783qte.160.1662934518675;
        Sun, 11 Sep 2022 15:15:18 -0700 (PDT)
Received: from localhost.localdomain (ip98-164-255-77.oc.oc.cox.net. [98.164.255.77])
        by smtp.gmail.com with ESMTPSA id x8-20020a05622a000800b0035a70d82d7bsm5324305qtw.47.2022.09.11.15.15.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Sep 2022 15:15:18 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 09/13] lpfc: Rework lpfc_fdmi_cmd routine for cleanup and consistency
Date:   Sun, 11 Sep 2022 15:15:01 -0700
Message-Id: <20220911221505.117655-10-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220911221505.117655-1-jsmart2021@gmail.com>
References: <20220911221505.117655-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Switch case logics are reworked so they appear more similar and
consistent. This eliminates compiler errors indicating unaligned
pointer values and packed members.

Added comments to explain previous size offset accumulations.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_ct.c | 53 +++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 44c2ec543845..8979e0e164b3 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -3533,7 +3533,7 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	uint32_t mask;
 	struct lpfc_fdmi_reg_hba *rh;
 	struct lpfc_fdmi_port_entry *pe;
-	struct lpfc_fdmi_reg_portattr *pab = NULL;
+	struct lpfc_fdmi_reg_portattr *pab = NULL, *base = NULL;
 	struct lpfc_fdmi_attr_block *ab = NULL;
 	int  (*func)(struct lpfc_vport *vport, struct lpfc_fdmi_attr_def *ad);
 	void (*cmpl)(struct lpfc_hba *, struct lpfc_iocbq *,
@@ -3566,6 +3566,10 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	INIT_LIST_HEAD(&rq->list);
 	INIT_LIST_HEAD(&rsp->list);
 
+	/* mbuf buffers are 1K in length - aka LPFC_BPL_SIZE */
+	memset(rq->virt, 0, LPFC_BPL_SIZE);
+	rsp_size = LPFC_BPL_SIZE;
+
 	/* FDMI request */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 			 "0218 FDMI Request x%x mask x%x Data: x%x x%x x%x\n",
@@ -3575,7 +3579,6 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	CtReq = (struct lpfc_sli_ct_request *)rq->virt;
 
 	/* First populate the CT_IU preamble */
-	memset(CtReq, 0, sizeof(struct lpfc_sli_ct_request));
 	CtReq->RevisionId.bits.Revision = SLI_CT_REVISION;
 	CtReq->RevisionId.bits.InId = 0;
 
@@ -3583,17 +3586,18 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	CtReq->FsSubType = SLI_CT_FDMI_Subtypes;
 
 	CtReq->CommandResponse.bits.CmdRsp = cpu_to_be16(cmdcode);
-	rsp_size = LPFC_BPL_SIZE;
+
 	size = 0;
 
 	/* Next fill in the specific FDMI cmd information */
 	switch (cmdcode) {
 	case SLI_MGMT_RHAT:
 	case SLI_MGMT_RHBA:
-		rh = (struct lpfc_fdmi_reg_hba *)&CtReq->un.PortID;
+		rh = (struct lpfc_fdmi_reg_hba *)&CtReq->un;
 		/* HBA Identifier */
 		memcpy(&rh->hi.PortName, &phba->pport->fc_sparam.portName,
 		       sizeof(struct lpfc_name));
+		size += sizeof(struct lpfc_fdmi_hba_ident);
 
 		if (cmdcode == SLI_MGMT_RHBA) {
 			/* Registered Port List */
@@ -3602,16 +3606,13 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			memcpy(&rh->rpl.pe.PortName,
 			       &phba->pport->fc_sparam.portName,
 			       sizeof(struct lpfc_name));
-
-			/* point to the HBA attribute block */
-			size = 2 * sizeof(struct lpfc_name) +
-				FOURBYTES;
-		} else {
-			size = sizeof(struct lpfc_name);
+			size += sizeof(struct lpfc_fdmi_reg_port_list);
 		}
+
 		ab = (struct lpfc_fdmi_attr_block *)((uint8_t *)rh + size);
 		ab->EntryCnt = 0;
-		size += FOURBYTES;
+		size += FOURBYTES;	/* add length of EntryCnt field */
+
 		bit_pos = 0;
 		if (new_mask)
 			mask = new_mask;
@@ -3626,6 +3627,7 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 					     (struct lpfc_fdmi_attr_def *)
 					     ((uint8_t *)rh + size));
 				ab->EntryCnt++;
+				/* check if another attribute fits */
 				if ((size + 256) >
 				    (LPFC_BPL_SIZE - LPFC_CT_PREAMBLE))
 					goto hba_out;
@@ -3636,7 +3638,7 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 hba_out:
 		ab->EntryCnt = cpu_to_be32(ab->EntryCnt);
 		/* Total size */
-		size = GID_REQUEST_SZ - 4 + size;
+		size += GID_REQUEST_SZ - 4;
 		break;
 
 	case SLI_MGMT_RPRT:
@@ -3647,22 +3649,29 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		}
 		fallthrough;
 	case SLI_MGMT_RPA:
-		pab = (struct lpfc_fdmi_reg_portattr *)&CtReq->un.PortID;
+		/* Store base ptr right after preamble */
+		base = (struct lpfc_fdmi_reg_portattr *)&CtReq->un;
+
 		if (cmdcode == SLI_MGMT_RPRT) {
-			rh = (struct lpfc_fdmi_reg_hba *)pab;
+			rh = (struct lpfc_fdmi_reg_hba *)base;
 			/* HBA Identifier */
 			memcpy(&rh->hi.PortName,
 			       &phba->pport->fc_sparam.portName,
 			       sizeof(struct lpfc_name));
 			pab = (struct lpfc_fdmi_reg_portattr *)
-				((uint8_t *)pab +  sizeof(struct lpfc_name));
+				((uint8_t *)base + sizeof(struct lpfc_name));
+			size += sizeof(struct lpfc_name);
+		} else {
+			pab = base;
 		}
 
 		memcpy((uint8_t *)&pab->PortName,
 		       (uint8_t *)&vport->fc_sparam.portName,
 		       sizeof(struct lpfc_name));
-		size += sizeof(struct lpfc_name) + FOURBYTES;
 		pab->ab.EntryCnt = 0;
+		/* add length of name and EntryCnt field */
+		size += sizeof(struct lpfc_name) + FOURBYTES;
+
 		bit_pos = 0;
 		if (new_mask)
 			mask = new_mask;
@@ -3675,8 +3684,9 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 				func = lpfc_fdmi_port_action[bit_pos];
 				size += func(vport,
 					     (struct lpfc_fdmi_attr_def *)
-					     ((uint8_t *)pab + size));
+					     ((uint8_t *)base + size));
 				pab->ab.EntryCnt++;
+				/* check if another attribute fits */
 				if ((size + 256) >
 				    (LPFC_BPL_SIZE - LPFC_CT_PREAMBLE))
 					goto port_out;
@@ -3686,10 +3696,7 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		}
 port_out:
 		pab->ab.EntryCnt = cpu_to_be32(pab->ab.EntryCnt);
-		/* Total size */
-		if (cmdcode == SLI_MGMT_RPRT)
-			size += sizeof(struct lpfc_name);
-		size = GID_REQUEST_SZ - 4 + size;
+		size += GID_REQUEST_SZ - 4;
 		break;
 
 	case SLI_MGMT_GHAT:
@@ -3698,7 +3705,7 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		fallthrough;
 	case SLI_MGMT_DHBA:
 	case SLI_MGMT_DHAT:
-		pe = (struct lpfc_fdmi_port_entry *)&CtReq->un.PortID;
+		pe = (struct lpfc_fdmi_port_entry *)&CtReq->un;
 		memcpy((uint8_t *)&pe->PortName,
 		       (uint8_t *)&vport->fc_sparam.portName,
 		       sizeof(struct lpfc_name));
@@ -3717,7 +3724,7 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		}
 		fallthrough;
 	case SLI_MGMT_DPA:
-		pe = (struct lpfc_fdmi_port_entry *)&CtReq->un.PortID;
+		pe = (struct lpfc_fdmi_port_entry *)&CtReq->un;
 		memcpy((uint8_t *)&pe->PortName,
 		       (uint8_t *)&vport->fc_sparam.portName,
 		       sizeof(struct lpfc_name));
-- 
2.35.3

