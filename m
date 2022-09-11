Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 304B9C6FA83
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Sep 2022 22:15:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiIKWPh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Sep 2022 18:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiIKWPU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Sep 2022 18:15:20 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB223167DB
        for <linux-scsi@vger.kernel.org>; Sun, 11 Sep 2022 15:15:18 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id g23so472874qtu.2
        for <linux-scsi@vger.kernel.org>; Sun, 11 Sep 2022 15:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=N0tEYEwPKI82r6FyaCNHdpFFImigi8inX9uBrnh8xFk=;
        b=Ea44oe20Yejub0aOEMeKn7f6mThNK5RN5EQKy75JWafj+gF2Uy5FlhG8uBhkl27nrz
         npXfEjlTEwglEBzJZOpTNX31d7cQ8i/eqAh3t7iOWRcAbj78dGptVLB2ZPJ7uPUaRe1C
         gLxXPvstkhsIL4fZIr+oQPPe/kqGzyfSbIOJT40vjdNN0H1d0DwkdmP02GdELMFC671N
         4Imfem0dkRAjP3uLyvCLptl8bHx4/o+44EvvAKkgbDXA5PxF1dPkhmclD1KL1ZauIjhx
         BrP/EE7v2/YUp9rDojK4ZahBxukKD53+Unmn7zDptjjdLo8GR3fdndGqgkuENNphu7Ja
         D9RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=N0tEYEwPKI82r6FyaCNHdpFFImigi8inX9uBrnh8xFk=;
        b=c8WbmwybNXcJdEIfj/keHrdVZIBgYHJTZ3GhecbmIOp3HYU7zIV0vYHFkIR/tmpktx
         51nrNbvvvZZSA5areW4tfLPlC2Yl+7yPSaVUFA17OL98CI50t3iNMT9sd365ObJwWpRa
         w7bGgCP/3AMfGelfB7dzAytlGxkCiTRYIthT0jFZTLphDM/MNP78L0fb/RxLs3gfrAJ/
         2dPC9EwTfSiUR2E6j4kvYUHIXFB5H8sFhzfy7SIP6gJm3o5cMNsvYkNqDmce19xqajcr
         75d2rBIuKCxaddO0soNTilzc7ovV/BYW93dhIZME/pEVwyUgAczOu8DYl4H4ndCKPwtY
         L4lQ==
X-Gm-Message-State: ACgBeo2cZGLFnTg9brgU6Ndn8ObsStD8bcXgWWbpoE9704jjq1ENAlSo
        8AVggSkCAx5LhIjU9trSEAe1VfXm/GM=
X-Google-Smtp-Source: AA6agR4wglRaSqQ0rZfRmICUiuplKNGmXqSVi8sS4SAeQY4t5V4S18wFlXUUm0KfegJ3JnMHgu6Fmg==
X-Received: by 2002:a05:622a:607:b0:35b:b660:1617 with SMTP id z7-20020a05622a060700b0035bb6601617mr466658qta.321.1662934517739;
        Sun, 11 Sep 2022 15:15:17 -0700 (PDT)
Received: from localhost.localdomain (ip98-164-255-77.oc.oc.cox.net. [98.164.255.77])
        by smtp.gmail.com with ESMTPSA id x8-20020a05622a000800b0035a70d82d7bsm5324305qtw.47.2022.09.11.15.15.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Sep 2022 15:15:17 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 08/13] lpfc: Rename mp/bmp dma buffers to rq/rsp in lpfc_fdmi_cmd
Date:   Sun, 11 Sep 2022 15:15:00 -0700
Message-Id: <20220911221505.117655-9-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220911221505.117655-1-jsmart2021@gmail.com>
References: <20220911221505.117655-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Clarify naming of the mp/bmp dma buffers:
- Rename mp to rq as it is the request buffer
- Rename bmp to rsp as it is the response buffer

This reduces confusion about what the buffer content is based
on their name.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_ct.c | 63 +++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index aad63adfc9ce..44c2ec543845 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -3524,9 +3524,9 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	      int cmdcode, uint32_t new_mask)
 {
 	struct lpfc_hba *phba = vport->phba;
-	struct lpfc_dmabuf *mp, *bmp;
+	struct lpfc_dmabuf *rq, *rsp;
 	struct lpfc_sli_ct_request *CtReq;
-	struct ulp_bde64 *bpl;
+	struct ulp_bde64_le *bde;
 	uint32_t bit_pos;
 	uint32_t size;
 	uint32_t rsp_size;
@@ -3546,25 +3546,25 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
 	/* fill in BDEs for command */
 	/* Allocate buffer for command payload */
-	mp = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
-	if (!mp)
+	rq = kmalloc(sizeof(*rq), GFP_KERNEL);
+	if (!rq)
 		goto fdmi_cmd_exit;
 
-	mp->virt = lpfc_mbuf_alloc(phba, 0, &(mp->phys));
-	if (!mp->virt)
-		goto fdmi_cmd_free_mp;
+	rq->virt = lpfc_mbuf_alloc(phba, 0, &rq->phys);
+	if (!rq->virt)
+		goto fdmi_cmd_free_rq;
 
 	/* Allocate buffer for Buffer ptr list */
-	bmp = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
-	if (!bmp)
-		goto fdmi_cmd_free_mpvirt;
+	rsp = kmalloc(sizeof(*rsp), GFP_KERNEL);
+	if (!rsp)
+		goto fdmi_cmd_free_rqvirt;
 
-	bmp->virt = lpfc_mbuf_alloc(phba, 0, &(bmp->phys));
-	if (!bmp->virt)
-		goto fdmi_cmd_free_bmp;
+	rsp->virt = lpfc_mbuf_alloc(phba, 0, &rsp->phys);
+	if (!rsp->virt)
+		goto fdmi_cmd_free_rsp;
 
-	INIT_LIST_HEAD(&mp->list);
-	INIT_LIST_HEAD(&bmp->list);
+	INIT_LIST_HEAD(&rq->list);
+	INIT_LIST_HEAD(&rsp->list);
 
 	/* FDMI request */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
@@ -3572,7 +3572,7 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			 cmdcode, new_mask, vport->fdmi_port_mask,
 			 vport->fc_flag, vport->port_state);
 
-	CtReq = (struct lpfc_sli_ct_request *)mp->virt;
+	CtReq = (struct lpfc_sli_ct_request *)rq->virt;
 
 	/* First populate the CT_IU preamble */
 	memset(CtReq, 0, sizeof(struct lpfc_sli_ct_request));
@@ -3730,31 +3730,32 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_DISCOVERY,
 				 "0298 FDMI cmdcode x%x not supported\n",
 				 cmdcode);
-		goto fdmi_cmd_free_bmpvirt;
+		goto fdmi_cmd_free_rspvirt;
 	}
 	CtReq->CommandResponse.bits.Size = cpu_to_be16(rsp_size);
 
-	bpl = (struct ulp_bde64 *)bmp->virt;
-	bpl->addrHigh = le32_to_cpu(putPaddrHigh(mp->phys));
-	bpl->addrLow = le32_to_cpu(putPaddrLow(mp->phys));
-	bpl->tus.f.bdeFlags = 0;
-	bpl->tus.f.bdeSize = size;
+	bde = (struct ulp_bde64_le *)rsp->virt;
+	bde->addr_high = cpu_to_le32(putPaddrHigh(rq->phys));
+	bde->addr_low = cpu_to_le32(putPaddrLow(rq->phys));
+	bde->type_size = cpu_to_le32(ULP_BDE64_TYPE_BDE_64 <<
+				     ULP_BDE64_TYPE_SHIFT);
+	bde->type_size |= cpu_to_le32(size);
 
 	/*
 	 * The lpfc_ct_cmd/lpfc_get_req shall increment ndlp reference count
 	 * to hold ndlp reference for the corresponding callback function.
 	 */
-	if (!lpfc_ct_cmd(vport, mp, bmp, ndlp, cmpl, rsp_size, 0))
+	if (!lpfc_ct_cmd(vport, rq, rsp, ndlp, cmpl, rsp_size, 0))
 		return 0;
 
-fdmi_cmd_free_bmpvirt:
-	lpfc_mbuf_free(phba, bmp->virt, bmp->phys);
-fdmi_cmd_free_bmp:
-	kfree(bmp);
-fdmi_cmd_free_mpvirt:
-	lpfc_mbuf_free(phba, mp->virt, mp->phys);
-fdmi_cmd_free_mp:
-	kfree(mp);
+fdmi_cmd_free_rspvirt:
+	lpfc_mbuf_free(phba, rsp->virt, rsp->phys);
+fdmi_cmd_free_rsp:
+	kfree(rsp);
+fdmi_cmd_free_rqvirt:
+	lpfc_mbuf_free(phba, rq->virt, rq->phys);
+fdmi_cmd_free_rq:
+	kfree(rq);
 fdmi_cmd_exit:
 	/* Issue FDMI request failed */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
-- 
2.35.3

