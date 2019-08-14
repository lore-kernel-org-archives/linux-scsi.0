Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2957C32753
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7B1D20866
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hp1uv/UJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728972AbfHNX5v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:51 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38181 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728336AbfHNX5t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:49 -0400
Received: by mail-pl1-f195.google.com with SMTP id m12so332398plt.5
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qqB5rSlaaGS7ixfaOz8OLkdBopigY9LzeqMViNKUx9M=;
        b=Hp1uv/UJdWlahtOcmmvVIvxHDKASxDdPKUNIkdigViOIOjays5ykbGObpYwHNJhK4t
         GII1D8n+8RO6iQpDNl5nALQIOtpS+9i0SwWGt2h95e/bQreJKOBtPwAhlEUeuarD29/t
         Hy/XWo61/b8+7H8IjWHqj9TbmFSH0+rXDfIDyITI3Uc10V1gn7sxThgshlBlt3NKuQpP
         GnkJhzds3g0nO0ffHANwzROZaY+/zcoF1+gx8hlYfAmv4a6SHmQFeCRXdEY61DS/Rs3u
         7w+W37Ja6Insf/241Jy+LY92wG9kHMmAv+YniY+UQZ6vdNrD1nEEMGsxb2Aeh8qv6f0D
         p+vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qqB5rSlaaGS7ixfaOz8OLkdBopigY9LzeqMViNKUx9M=;
        b=OzAICpyHFK9BRQzD6hnYaELAj5sZ6wkC2LkaPedncgbA3zOjPJihcZ8wTMrlrxMApz
         5CryLeKJL4ylZizrpz1RvIPUkfUggovacw/DZjv1ovMJynin0qx1tEzNnF1GTEBwVZTb
         OhVF3HNIqoXXk2zk87YEMcwnx3gADl+Dc/634TffngvGCj61oc74Wfbfa0WWmHMV8y1J
         OklgdT8VZf/4qVJOifinRHZQiUXaRVnh5Gnp2fpgasRtsbSzISPKhtV7oj1TOIF/06G2
         z84t6XIvexNnCHUYG5z+TWIsAW1y+miwAaL8VlpGT89j0+MrBoJGp+lRS8EwtkGRYnrW
         Bj/g==
X-Gm-Message-State: APjAAAUDsHVxs8YeCUzMGS+8hDt9yJOIoR/5lGzPV6PkF/CIIPlBHwMv
        keeTKgiaTiZiXzyIs/7OUQN8Q/vB
X-Google-Smtp-Source: APXvYqx27/rtaCZZ9/mClhdaQsOZZm9BG5Ar+Gt+P2vXwas8OJrDpdV0hcxtmKL7rdQ0DGN1ZDWDVQ==
X-Received: by 2002:a17:902:20e3:: with SMTP id v32mr1721963plg.142.1565827068995;
        Wed, 14 Aug 2019 16:57:48 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:48 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 34/42] lpfc: Fix coverity warnings
Date:   Wed, 14 Aug 2019 16:57:04 -0700
Message-Id: <20190814235712.4487-35-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Running on Coverity produced the following errors:
- coding style (indentation)
- memset size mismatch errors
  note: comment cases where it is purposely a mismatch

Fix the errors

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c   | 10 +++++-----
 drivers/scsi/lpfc/lpfc_nvme.c  |  5 +++--
 drivers/scsi/lpfc/lpfc_nvmet.c |  2 +-
 drivers/scsi/lpfc/lpfc_sli.c   |  2 +-
 4 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index d919f3161160..54ec7f0822e5 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5667,16 +5667,16 @@ lpfc_rdp_res_attach_port_names(struct fc_rdp_port_name_desc *desc,
 	desc->tag = cpu_to_be32(RDP_PORT_NAMES_DESC_TAG);
 	if (vport->fc_flag & FC_FABRIC) {
 		memcpy(desc->port_names.wwnn, &vport->fabric_nodename,
-				sizeof(desc->port_names.wwnn));
+		       sizeof(desc->port_names.wwnn));
 
 		memcpy(desc->port_names.wwpn, &vport->fabric_portname,
-				sizeof(desc->port_names.wwpn));
+		       sizeof(desc->port_names.wwpn));
 	} else {  /* Point to Point */
 		memcpy(desc->port_names.wwnn, &ndlp->nlp_nodename,
-				sizeof(desc->port_names.wwnn));
+		       sizeof(desc->port_names.wwnn));
 
-		memcpy(desc->port_names.wwnn, &ndlp->nlp_portname,
-				sizeof(desc->port_names.wwpn));
+		memcpy(desc->port_names.wwpn, &ndlp->nlp_portname,
+		       sizeof(desc->port_names.wwpn));
 	}
 
 	desc->length = cpu_to_be32(sizeof(desc->port_names));
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index c7f5b50c3820..41b124b69947 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -436,6 +436,7 @@ lpfc_nvme_gen_req(struct lpfc_vport *vport, struct lpfc_dmabuf *bmp,
 		return 1;
 
 	wqe = &genwqe->wqe;
+	/* Initialize only 64 bytes */
 	memset(wqe, 0, sizeof(union lpfc_wqe));
 
 	genwqe->context3 = (uint8_t *)bmp;
@@ -1855,7 +1856,7 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 	/* WQEs are reused.  Clear stale data and set key fields to
 	 * zero like ia, iaab, iaar, xri_tag, and ctxt_tag.
 	 */
-	memset(abts_wqe, 0, sizeof(union lpfc_wqe));
+	memset(abts_wqe, 0, sizeof(*abts_wqe));
 	bf_set(abort_cmd_criteria, &abts_wqe->abort_cmd, T_XRI_TAG);
 
 	/* word 7 */
@@ -1982,7 +1983,7 @@ lpfc_get_nvme_buf(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
 		sgl->word2 = cpu_to_le32(sgl->word2);
 		/* Fill in word 3 / sgl_len during cmd submission */
 
-		/* Initialize WQE */
+		/* Initialize 64 bytes only */
 		memset(wqe, 0, sizeof(union lpfc_wqe));
 
 		if (lpfc_ndlp_check_qdepth(phba, ndlp)) {
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index f0840e3182c0..f42cc3150c6f 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -3330,7 +3330,7 @@ lpfc_nvmet_sol_fcp_issue_abort(struct lpfc_hba *phba,
 	/* WQEs are reused.  Clear stale data and set key fields to
 	 * zero like ia, iaab, iaar, xri_tag, and ctxt_tag.
 	 */
-	memset(abts_wqe, 0, sizeof(union lpfc_wqe));
+	memset(abts_wqe, 0, sizeof(*abts_wqe));
 
 	/* word 3 */
 	bf_set(abort_cmd_criteria, &abts_wqe->abort_cmd, T_XRI_TAG);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 6ac6620aab00..0142545873a5 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -9815,7 +9815,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 		 * we re-construct this WQE here based on information in
 		 * iocbq from scratch.
 		 */
-		memset(wqe, 0, sizeof(union lpfc_wqe));
+		memset(wqe, 0, sizeof(*wqe));
 		/* OX_ID is invariable to who sent ABTS to CT exchange */
 		bf_set(xmit_bls_rsp64_oxid, &wqe->xmit_bls_rsp,
 		       bf_get(lpfc_abts_oxid, &iocbq->iocb.un.bls_rsp));
-- 
2.13.7

