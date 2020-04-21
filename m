Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FFBAC54FC9
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 20:34:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B13320724
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 20:34:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B6gZ0zqQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgDUUeF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 16:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbgDUUeF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2020 16:34:05 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F520C0610D5
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2020 13:34:03 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id t63so4848720wmt.3
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2020 13:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=dMhy4XhiaOE9F6l2AbqQKjFrndmPnIE3rO6F1lB/E6g=;
        b=B6gZ0zqQeraknsdm1bJ2y+IK0QjLXmUpJblAxn2FisGa3ca2aO4ZRLYthD7xL9tLr7
         /alBIiqd66Gpz7f5A6dH8UVxcYtbwAYrU2FJG7UthfCtBK54S1EGzj5I3+zJ2roMEhsY
         J0eQikvQx3DFPQMM6lf/TxUAuLp/Bvr73Qra8AWvL2S2j/uGkZV5vCH0YJG8v5uMUyj4
         vvnMUXqwW5hiK8X2JzLhX4b5JA2P16N8yEc/BqCB7itC5M8k9s23yX5U1rj1iiAnHp9D
         YHFn469QN0fKgJmpXsSynOe7JsLZT465sIu2YGUstQA3VaBgEATqYx3/Bx34QRWzVXqk
         n0fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dMhy4XhiaOE9F6l2AbqQKjFrndmPnIE3rO6F1lB/E6g=;
        b=N3U1VzXcGLgJsq5XFW71GrmmhIHFl1IBshqDCw4XYCh+mAH3GnV7SwIoj9Lx+CXwSC
         B1pyAMccvH2TM0Cu1lZLm8cCv7cs0qJgC6mFr4y6X42NyAkH5KFmiGwMUJhdjt3w2er6
         6KoG9hSyB497s66vFKazpAOVaRf6fVYV6Vv8se2UZVeeMg4FsifJ0LcQCNJHPqsoWYb8
         S7tG7NpmLSQ/Y0Di/h2gnjxQ8akNHN8IsN2seWmJZfWW2Pp2cVg95iEcMEPRu2p0YnqV
         VCE0Ggi5Si7sWs3Ea+/AUw7KHzANrLOB4gWGFprItNT0XayBD3+UltWjnxPJ8I7Ssu1k
         HEXA==
X-Gm-Message-State: AGi0PuYsZ4ftLbgqQJb5lMN9R1vCgkDtlGQsYNl/6dAxXdqghnsrCohd
        33fZw63BgepJka4dHG7J8JKn5Pi+
X-Google-Smtp-Source: APiQypKZuhyRuIJ6jpjVGMoqKX4jIsuUwByhJdIk2mC4Rr9u7fe6pErdnUVFoDbg2luKX83Zn+tzVw==
X-Received: by 2002:a1c:bb08:: with SMTP id l8mr7315015wmf.168.1587501241937;
        Tue, 21 Apr 2020 13:34:01 -0700 (PDT)
Received: from localhost.localdomain.localdomain (ip68-5-146-102.oc.oc.cox.net. [68.5.146.102])
        by smtp.gmail.com with ESMTPSA id m1sm5194205wro.64.2020.04.21.13.33.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Apr 2020 13:34:01 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2] lpfc: remove duplicate unloading checks
Date:   Tue, 21 Apr 2020 13:33:54 -0700
Message-Id: <20200421203354.49420-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During code reviews several instances of duplicate module unloading checks
were found.

Remove the duplicate checks.

Signed-off-by: James Smart <jsmart2021@gmail.com>

---
v2: reworked lpfc_els.c mod to keep check prior to locks
---
 drivers/scsi/lpfc/lpfc_els.c   | 10 ++--------
 drivers/scsi/lpfc/lpfc_nvme.c  |  5 -----
 drivers/scsi/lpfc/lpfc_nvmet.c | 11 -----------
 3 files changed, 2 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 80d1e661b0d4..565a21401660 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -7936,19 +7936,13 @@ lpfc_els_timeout_handler(struct lpfc_vport *vport)
 	if (unlikely(!pring))
 		return;
 
-	if ((phba->pport->load_flag & FC_UNLOADING))
+	if (phba->pport->load_flag & FC_UNLOADING)
 		return;
+
 	spin_lock_irq(&phba->hbalock);
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		spin_lock(&pring->ring_lock);
 
-	if ((phba->pport->load_flag & FC_UNLOADING)) {
-		if (phba->sli_rev == LPFC_SLI_REV4)
-			spin_unlock(&pring->ring_lock);
-		spin_unlock_irq(&phba->hbalock);
-		return;
-	}
-
 	list_for_each_entry_safe(piocb, tmp_iocb, &pring->txcmplq, list) {
 		cmd = &piocb->iocb;
 
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index a45936e08031..12d2b2775773 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1491,11 +1491,6 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
 
 	phba = vport->phba;
 
-	if (vport->load_flag & FC_UNLOADING) {
-		ret = -ENODEV;
-		goto out_fail;
-	}
-
 	if (unlikely(vport->load_flag & FC_UNLOADING)) {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_IOERR,
 				 "6124 Fail IO, Driver unload\n");
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 565419bf8d74..5f5aecea5b55 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -841,9 +841,6 @@ lpfc_nvmet_xmt_ls_rsp(struct nvmet_fc_target_port *tgtport,
 	struct ulp_bde64 bpl;
 	int rc;
 
-	if (phba->pport->load_flag & FC_UNLOADING)
-		return -ENODEV;
-
 	if (phba->pport->load_flag & FC_UNLOADING)
 		return -ENODEV;
 
@@ -938,11 +935,6 @@ lpfc_nvmet_xmt_fcp_op(struct nvmet_fc_target_port *tgtport,
 		goto aerr;
 	}
 
-	if (phba->pport->load_flag & FC_UNLOADING) {
-		rc = -ENODEV;
-		goto aerr;
-	}
-
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	if (ctxp->ts_cmd_nvme) {
 		if (rsp->op == NVMET_FCOP_RSP)
@@ -1062,9 +1054,6 @@ lpfc_nvmet_xmt_fcp_abort(struct nvmet_fc_target_port *tgtport,
 	struct lpfc_queue *wq;
 	unsigned long flags;
 
-	if (phba->pport->load_flag & FC_UNLOADING)
-		return;
-
 	if (phba->pport->load_flag & FC_UNLOADING)
 		return;
 
-- 
2.16.4

