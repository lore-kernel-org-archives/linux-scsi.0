Return-Path: <SRS0=Uzsj=6E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9941FC3A5A0
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 20:04:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74B4F208FE
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 20:04:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M6wp0K9c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgDTUER (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Apr 2020 16:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbgDTUEQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2020 16:04:16 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964D1C061A0C
        for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2020 13:04:16 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id s10so4618782wrr.0
        for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2020 13:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=pMBlZYFaliBaHAoUz8J7o8fDC/CnxJNPrWS+EmZajkU=;
        b=M6wp0K9cIWrxxpjHR8BjMToDmlbrn4brgTFoRcxJh3LBr6yscNX8tIvy+5lstIhWUN
         r1C8l2SNdhl4xXcd5edZEkL/coSKv22q6Ae4BP8z1/0DeEi1gYqAYLGIAiYdsUMsC/Qd
         IFZoKZ4u6phILtIEaAiWc3p1+hyXRUgbKgZmsHeEXzlb7ScBPrsDbb2Zs4ioHDzoxFto
         0pV+Kj8OR6CC7Oy63Urx6iqodZOwT/Ae/LauRtyKzH5BST/rlLGGYSvMicW6Bg8HfKOA
         jHkTwY9HOYtkRytg4ayu3aXote0y60WKSX5lTBNJPmTofGvWr4rmiFYoR07kbaqBvfv2
         tjeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=pMBlZYFaliBaHAoUz8J7o8fDC/CnxJNPrWS+EmZajkU=;
        b=RegLuFWCPxfJN8g1cdt9YgYkWli1F60+NSyumgEMlGBMhPCeMQVa2sbsFgMNch+ENz
         jJFAbJWTcp/vBtgUJLAygqakLNg8X+W971m/iceC0HvPPsc+ukdgR3wLEr8IApZb2A1w
         ihNcOo1WgLF/qZ7ZGs4JltUwPg3WwhIQPwDFcRTGBCSYhoSJbKAELNrlKj5sWF1m5vgD
         ibOBK19vn/HHzdOH/xNJc29LfzF/uDrawRYyU3K36+bam+E71L4ejWBwCYXE+cBdKUnJ
         jyJ2pAcTnPfy8K8rRYuw//XyTGdOPxg4Nz/4jIm2+Xgg2P3NJkmvlhwBh+y4Tbuf0QWR
         S8+A==
X-Gm-Message-State: AGi0PuYZWBb5DYEbwGTSJsHh3GySJncu4iF7ZZGf81wWrRTAW67j+/NJ
        Uxg5Y+kmu/Rr7nubr1dphLmkluJL
X-Google-Smtp-Source: APiQypJhkgOf9lriHjLbc1gW4oAcy25AjGnSMpKH8UQpsrnAQJXbbpyFz20zrpBT8KjnWPEjqQ0TGQ==
X-Received: by 2002:adf:afc6:: with SMTP id y6mr19705624wrd.74.1587413055056;
        Mon, 20 Apr 2020 13:04:15 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h16sm783701wrw.36.2020.04.20.13.04.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Apr 2020 13:04:14 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH] lpfc: remove duplicate unloading checks
Date:   Mon, 20 Apr 2020 13:04:07 -0700
Message-Id: <20200420200407.34039-1-jsmart2021@gmail.com>
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
 drivers/scsi/lpfc/lpfc_els.c   |  2 --
 drivers/scsi/lpfc/lpfc_nvme.c  |  5 -----
 drivers/scsi/lpfc/lpfc_nvmet.c | 11 -----------
 3 files changed, 18 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 80d1e661b0d4..da3a72aeedfe 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -7936,8 +7936,6 @@ lpfc_els_timeout_handler(struct lpfc_vport *vport)
 	if (unlikely(!pring))
 		return;
 
-	if ((phba->pport->load_flag & FC_UNLOADING))
-		return;
 	spin_lock_irq(&phba->hbalock);
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		spin_lock(&pring->ring_lock);
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

