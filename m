Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45186C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 21:50:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20DFA2074D
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 21:50:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qZ/qF2H/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729330AbgF3VuP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 17:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728319AbgF3VuO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 17:50:14 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3216C03E979
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2020 14:50:13 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id f7so18626803wrw.1
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2020 14:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D6MUeD1PzeY4fvf01iH1b8neHvAhW5yfagMAf7FXFNs=;
        b=qZ/qF2H/xMy7oibsv+dqf3CMHAQZMEiZt4N4xMWuV9XkXwf3WMBBE5cISd46YyKRnj
         hMYoCkE6+VTWlvAg9+xYPHKY6HUtzMDI1GKecTErHlWyIK3UTrYxOf8igPuQbxI0nbAu
         VT3OszXl+Jb2bzP3tlH8g/+eCZmVyhrkOMbxLuaSuBrHtHrKb4CwYW3/Jd/zxk5dyOTJ
         Pdv9B48+YgOvs2yyyAlgBqcbqXAjba22HBWNFggcr5WJ1H4pGLaHCPQrd0OxI60ha62l
         pXU6U17GQoqDfnDBtZKydotT5HAE4DJ5HdM/H6TVQV//meQXxWJkbxEb2uUKPVULp6J3
         O4eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D6MUeD1PzeY4fvf01iH1b8neHvAhW5yfagMAf7FXFNs=;
        b=ZAfwCmpM/kVEI+a98Q80qUsrRfGFuF0B5ssPgwpyTSOuwQLzCjyDbhEZARfSF8su0H
         0lrXYDYAbns6X7kfCGBptBYWUtfYZ2yIblqHgAtuBQMhInyQZ4i22tc09EYjBN1sCMEy
         z8dZLdkF0z3Y8o1IhzFE+CGHoffP4j4nmRGn5RQykMfvj3sAkR3PII3xboTFqiC1Q9Fn
         EO6ccq7vHsY18QMfnloynU2MwcOYmJnKHjKpgz2nzBshPNCgUaOuRfixK6njVEmvAXOF
         EpPMSK2Lm2XA6ZwVTjqNaFvnIDS4ed0aNFNsiwIIP77Wx9hw+FD0c/Fh+we/DfPK1Rr4
         yKCw==
X-Gm-Message-State: AOAM533zfsi28WmZQJPR+KCw1HqeNh826txlZ502IfDLfoRrCXZkUdcx
        WdAjYUFKDZ47kcR/LSH7cDgWtuU5
X-Google-Smtp-Source: ABdhPJyp/KdkTpD6nTzGtxFJRAv37WiCbKAmGOiByWtqBxoQvXqmPTEfkXa35C6oFLxuN0dE/jWQ8w==
X-Received: by 2002:a5d:6748:: with SMTP id l8mr26167079wrw.347.1593553812249;
        Tue, 30 Jun 2020 14:50:12 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f14sm5518551wro.90.2020.06.30.14.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 14:50:11 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 01/14] lpfc: Fix unused assignment in lpfc_sli4_bsg_link_diag_test
Date:   Tue, 30 Jun 2020 14:49:48 -0700
Message-Id: <20200630215001.70793-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200630215001.70793-1-jsmart2021@gmail.com>
References: <20200630215001.70793-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Coverity reported the following error:
  Assigned value that is never used may represent unnecessary
  computation.

The rc variable was initially assigned a value but in several cases,
when an error case is detected, it is reassigned a new value. The initial
value had little use.

In code-reviewing this routine, it could use some cleanup:
- Setting the initialization value to -ENODEV is a much better choice and
  lessens code in the routine.
- The wasn't tracking logic errors vs no error and mailbox failure.
  Better to resolve by adding a status to track the mailbox failure
  and merge it with the logic error when the routine returns.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 0ea03ae93d91..e91466aa1673 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -2404,33 +2404,27 @@ lpfc_sli4_bsg_link_diag_test(struct bsg_job *job)
 	union lpfc_sli4_cfg_shdr *shdr;
 	uint32_t shdr_status, shdr_add_status;
 	struct diag_status *diag_status_reply;
-	int mbxstatus, rc = 0;
+	int mbxstatus, rc = -ENODEV, rc1 = 0;
 
 	shost = fc_bsg_to_shost(job);
-	if (!shost) {
-		rc = -ENODEV;
+	if (!shost)
 		goto job_error;
-	}
+
 	vport = shost_priv(shost);
-	if (!vport) {
-		rc = -ENODEV;
+	if (!vport)
 		goto job_error;
-	}
+
 	phba = vport->phba;
-	if (!phba) {
-		rc = -ENODEV;
+	if (!phba)
 		goto job_error;
-	}
 
-	if (phba->sli_rev < LPFC_SLI_REV4) {
-		rc = -ENODEV;
+
+	if (phba->sli_rev < LPFC_SLI_REV4)
 		goto job_error;
-	}
+
 	if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) <
-	    LPFC_SLI_INTF_IF_TYPE_2) {
-		rc = -ENODEV;
+	    LPFC_SLI_INTF_IF_TYPE_2)
 		goto job_error;
-	}
 
 	if (job->request_len < sizeof(struct fc_bsg_request) +
 	    sizeof(struct sli4_link_diag)) {
@@ -2465,8 +2459,10 @@ lpfc_sli4_bsg_link_diag_test(struct bsg_job *job)
 	alloc_len = lpfc_sli4_config(phba, pmboxq, LPFC_MBOX_SUBSYSTEM_FCOE,
 				     LPFC_MBOX_OPCODE_FCOE_LINK_DIAG_STATE,
 				     req_len, LPFC_SLI4_MBX_EMBED);
-	if (alloc_len != req_len)
+	if (alloc_len != req_len) {
+		rc = -ENOMEM;
 		goto link_diag_test_exit;
+	}
 
 	run_link_diag_test = &pmboxq->u.mqe.un.link_diag_test;
 	bf_set(lpfc_mbx_run_diag_test_link_num, &run_link_diag_test->u.req,
@@ -2515,7 +2511,7 @@ lpfc_sli4_bsg_link_diag_test(struct bsg_job *job)
 	diag_status_reply->shdr_add_status = shdr_add_status;
 
 link_diag_test_exit:
-	rc = lpfc_sli4_bsg_set_link_diag_state(phba, 0);
+	rc1 = lpfc_sli4_bsg_set_link_diag_state(phba, 0);
 
 	if (pmboxq)
 		mempool_free(pmboxq, phba->mbox_mem_pool);
@@ -2524,6 +2520,8 @@ lpfc_sli4_bsg_link_diag_test(struct bsg_job *job)
 
 job_error:
 	/* make error code available to userspace */
+	if (rc1 && !rc)
+		rc = rc1;
 	bsg_reply->result = rc;
 	/* complete the job back to userspace if no error */
 	if (rc == 0)
-- 
2.25.0

