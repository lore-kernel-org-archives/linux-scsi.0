Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15D52C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  6 May 2022 03:56:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388890AbiEFD7j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 May 2022 23:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388852AbiEFD7W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 May 2022 23:59:22 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE153E015
        for <linux-scsi@vger.kernel.org>; Thu,  5 May 2022 20:55:34 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id y41so442225pfw.12
        for <linux-scsi@vger.kernel.org>; Thu, 05 May 2022 20:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8G7FCdKjQW8GboICwBoCIFipNJHwbjaqY6MmWWoXJXo=;
        b=ffpAwD0MDFxZJQEXPzELmQvupBgMl8ovk8NQlXzyGTKs60zY2LzvfDx/XA3NU8jHSR
         pF5ZaUmyCYHTvKu9jFv91AhdLkGF4/MHRxhun26PUET3+xvj6kBw9QLyLa50y3fmcOnQ
         7o09VYlLqz7NtfVIzCElEQQgQh4xBI0ktV5Y5JvNYAIF2ZOkjks/+etKjEZtkAtufFi8
         ZXWdOZImxySPecQbo6qcdBrOA5xhR2gvhcJSDeBua+rMBSd1kEJ1IxIXQ8MpYicB6fkt
         P9vPJ2CIL5ZohtS0Zx4ffLhpWlFiaLxAdl99gqpoYd5Z6dpn61kvIln+tndJsjXoDyG1
         4hNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8G7FCdKjQW8GboICwBoCIFipNJHwbjaqY6MmWWoXJXo=;
        b=uMj/a7Ukk1QDWebBpD8zllhuw/AD9XvlBuGGETHcxg2MT9TxfryFzkI2zrDlFxZpea
         O2+DSKQedJ3k1d5Kr+MxHjBHPzE37LWghwZqisA0OrRg73s53gka/KuzytYZHPEZTH3C
         3nZJ6gD6pmOjo0VYt178CFXl9fckEBztTE5E/wsSM25MArja9OCGGKvzsmIhr2ZkYWdt
         0i7zygXyvEgSj5YX85i01neIL+f6z1lNNBW2imAPwf25ZWDGY2giGSmZ5sfkK2f/EylK
         EKNzM9Isa/CfIROuHHTUZq3hKRvj9RgwoOjJ6plZhRFB2LUArc/QVI8VDq6uFiZ+xu2K
         LmNQ==
X-Gm-Message-State: AOAM532KMKYaxDbTZZ06tI6PGhskRKkJw5VyZFBjXq+YKkDb1UduW50a
        R9/QS76GOLsgg4oJ2X7lJNQ1rEEPq9U=
X-Google-Smtp-Source: ABdhPJxGDMfMv7MTQwXQtW46V6yBXsir6iOTV1s5s4fmHoMOv03Rl9XchUshYgExsHDvnYRJ8/8Etw==
X-Received: by 2002:a05:6a00:1353:b0:50e:982:6a4f with SMTP id k19-20020a056a00135300b0050e09826a4fmr1649375pfu.50.1651809334273;
        Thu, 05 May 2022 20:55:34 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id ck3-20020a17090afe0300b001cd4989feebsm6065187pjb.55.2022.05.05.20.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 20:55:34 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 08/12] lpfc: Change VMID registration to be based on fabric parameters
Date:   Thu,  5 May 2022 20:55:15 -0700
Message-Id: <20220506035519.50908-9-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220506035519.50908-1-jsmart2021@gmail.com>
References: <20220506035519.50908-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently, VMID registration is configured via module parameters.  This
could lead to VMID compatibility issues if two ports are connected to
different brands of switches, as the two brands implement VMID
differently.

Make logical changes so that VMID registration is based on common service
parameters from FLOGI_ACC with fabric rather than module parameters.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h      |  1 +
 drivers/scsi/lpfc/lpfc_els.c  |  3 ++-
 drivers/scsi/lpfc/lpfc_scsi.c | 17 +++++++++--------
 drivers/scsi/lpfc/lpfc_sli.c  |  4 ++--
 4 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 405c8a8dd795..f8f5b4a2d523 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -714,6 +714,7 @@ struct lpfc_vport {
 #define LPFC_VMID_QFPA_CMPL		0x4
 #define LPFC_VMID_QOS_ENABLED		0x8
 #define LPFC_VMID_TIMER_ENBLD		0x10
+#define LPFC_VMID_TYPE_PRIO		0x20
 	struct fc_qfpa_res *qfpa_res;
 
 	struct fc_vport *fc_vport;
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 3671e0f8e041..33fac4401e8f 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1105,7 +1105,8 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			 sp->cmn.priority_tagging, kref_read(&ndlp->kref));
 
 	if (sp->cmn.priority_tagging)
-		vport->vmid_flag |= LPFC_VMID_ISSUE_QFPA;
+		vport->phba->pport->vmid_flag |= (LPFC_VMID_ISSUE_QFPA |
+						  LPFC_VMID_TYPE_PRIO);
 
 	if (vport->port_state == LPFC_FLOGI) {
 		/*
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 1959c58d22f8..1d134a01ff3e 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5344,9 +5344,9 @@ static void lpfc_vmid_update_entry(struct lpfc_vport *vport, struct scsi_cmnd
 {
 	u64 *lta;
 
-	if (vport->vmid_priority_tagging)
+	if (vport->phba->pport->vmid_flag & LPFC_VMID_TYPE_PRIO)
 		tag->cs_ctl_vmid = vmp->un.cs_ctl_vmid;
-	else
+	else if (vport->phba->cfg_vmid_app_header)
 		tag->app_id = vmp->un.app_id;
 
 	if (cmd->sc_data_direction == DMA_TO_DEVICE)
@@ -5391,11 +5391,12 @@ static int lpfc_vmid_get_appid(struct lpfc_vport *vport, char *uuid, struct
 			       scsi_cmnd * cmd, union lpfc_vmid_io_tag *tag)
 {
 	struct lpfc_vmid *vmp = NULL;
-	int hash, len, rc, i;
+	int hash, len, rc = -EPERM, i;
 
 	/* check if QFPA is complete */
-	if (lpfc_vmid_is_type_priority_tag(vport) && !(vport->vmid_flag &
-	      LPFC_VMID_QFPA_CMPL)) {
+	if (lpfc_vmid_is_type_priority_tag(vport) &&
+	    !(vport->vmid_flag & LPFC_VMID_QFPA_CMPL) &&
+	    (vport->vmid_flag & LPFC_VMID_ISSUE_QFPA)) {
 		vport->work_port_events |= WORKER_CHECK_VMID_ISSUE_QFPA;
 		return -EAGAIN;
 	}
@@ -5469,7 +5470,7 @@ static int lpfc_vmid_get_appid(struct lpfc_vport *vport, char *uuid, struct
 			vport->vmid_inactivity_timeout ? 1 : 0;
 
 		/* if type priority tag, get next available VMID */
-		if (lpfc_vmid_is_type_priority_tag(vport))
+		if (vport->phba->pport->vmid_flag & LPFC_VMID_TYPE_PRIO)
 			lpfc_vmid_assign_cs_ctl(vport, vmp);
 
 		/* allocate the per cpu variable for holding */
@@ -5488,9 +5489,9 @@ static int lpfc_vmid_get_appid(struct lpfc_vport *vport, char *uuid, struct
 		write_unlock(&vport->vmid_lock);
 
 		/* complete transaction with switch */
-		if (lpfc_vmid_is_type_priority_tag(vport))
+		if (vport->phba->pport->vmid_flag & LPFC_VMID_TYPE_PRIO)
 			rc = lpfc_vmid_uvem(vport, vmp, true);
-		else
+		else if (vport->phba->cfg_vmid_app_header)
 			rc = lpfc_vmid_cmd(vport, SLI_CTAS_RAPP_IDENT, vmp);
 		if (!rc) {
 			write_lock(&vport->vmid_lock);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 573526f08baf..79d2ef5f0f05 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -10377,11 +10377,11 @@ lpfc_prep_embed_io(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 
 	/* add the VMID tags as per switch response */
 	if (unlikely(piocb->cmd_flag & LPFC_IO_VMID)) {
-		if (phba->pport->vmid_priority_tagging) {
+		if (phba->pport->vmid_flag & LPFC_VMID_TYPE_PRIO) {
 			bf_set(wqe_ccpe, &wqe->fcp_iwrite.wqe_com, 1);
 			bf_set(wqe_ccp, &wqe->fcp_iwrite.wqe_com,
 					(piocb->vmid_tag.cs_ctl_vmid));
-		} else {
+		} else if (phba->cfg_vmid_app_header) {
 			bf_set(wqe_appid, &wqe->fcp_iwrite.wqe_com, 1);
 			bf_set(wqe_wqes, &wqe->fcp_iwrite.wqe_com, 1);
 			wqe->words[31] = piocb->vmid_tag.app_id;
-- 
2.26.2

