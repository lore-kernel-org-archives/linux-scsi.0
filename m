Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 755BECA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 21:19:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46D69222C3
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 21:19:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gy1ZvywL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503021AbfJRVTI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 17:19:08 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43719 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503005AbfJRVTH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Oct 2019 17:19:07 -0400
Received: by mail-pg1-f195.google.com with SMTP id i32so4009374pgl.10
        for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2019 14:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MC3id9VDkN0a+Joo7IfNm8wAVZYVGFWjBnLKUXgEyUw=;
        b=gy1ZvywL/BEVawHUb9hV/HIxFpMCFoR5WC9gTP4AvQ3KXIEZ1MnqwZUuvnSVqEN31d
         J4O+JKUzkqpKhc9wnGlAntx6bF3IjQrsMP78FK0uNbQP68U0xzbUU0qwJSz02Or7J9iV
         Q7Rgon0xH/3pxAVvam63/ORKJ4xsvbZrfAFUl0pZjXdsg2WeteHipnVXpSPG4hFhWTLa
         Z3LuyuwCSFdZu+DAxHNqtkz+9gOnw/A1J4q3xrF23TnQAYp0ry+SciEmo5hWzblOsPHw
         y0Dy3/A8VcKS06o7n+YAWg4yIoaMkD3Xk85IyRDrRI11yaWUvcR6P1dwjKeO3AnnLyfd
         uz4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MC3id9VDkN0a+Joo7IfNm8wAVZYVGFWjBnLKUXgEyUw=;
        b=qHSe7LbYR7yNH6nukT4MjCfayd+QkuE5ZlPl2RrGEd7pwet5WRmC4iXBlrs303syXe
         hJ2eF1cQmsncTL7IakHT1lAWENrbYgUI1U/wIK2WJy4No8tqBtMv9E+ZAPHm0LustmBF
         3scSIkjhhBdRnqVaGp8QNPa6pHYr63xuSmKE0Hk34XNElfj/tuJed7vPxyS4t7x3UFri
         ElpCjbV+62jLYXuiCX90DrqytXq3PpmG42U6MriVdYvsbbe9ggBytrSSI7wGeg+lVIBf
         ur4fUTFfpw48VBdWAIR9tL+J/TPmWd4al/kMwcHKaU/tiTjGmcVlqTV+d2eIid7fc8aa
         73bA==
X-Gm-Message-State: APjAAAUDwmCB1KdW3V5JXM4CCFfgrk4hrP7aM4cDuaCDfRUPIlvnu62I
        ediHgsXj2C6ujesk8HxZiCpI21pK
X-Google-Smtp-Source: APXvYqy2bjSFsw8hVqhzKCV8r96RvPfQXdWLSlMLOQwYGExOrupgYxti3VF8AD97ZWla+6YF01Yn8A==
X-Received: by 2002:aa7:9ec5:: with SMTP id r5mr8831684pfq.230.1571433546831;
        Fri, 18 Oct 2019 14:19:06 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 22sm7538878pfo.131.2019.10.18.14.19.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 18 Oct 2019 14:19:06 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 08/16] lpfc: Slight fast-path Performance optimizations
Date:   Fri, 18 Oct 2019 14:18:24 -0700
Message-Id: <20191018211832.7917-9-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191018211832.7917-1-jsmart2021@gmail.com>
References: <20191018211832.7917-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Slightly rework some error check code paths for better streamlining.

Added compiler unlikely hints to allow slightly better
optimization of the fast-path.

Removed a few pointer checks that were obviously already valid.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c |  2 +-
 drivers/scsi/lpfc/lpfc_scsi.c | 17 +++++++++--------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 5af944b97c4c..328ddce87f12 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2093,7 +2093,7 @@ lpfc_release_nvme_buf(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_ncmd)
 	lpfc_ncmd->flags &= ~LPFC_SBUF_BUMP_QDEPTH;
 
 	qp = lpfc_ncmd->hdwq;
-	if (lpfc_ncmd->flags & LPFC_SBUF_XBUSY) {
+	if (unlikely(lpfc_ncmd->flags & LPFC_SBUF_XBUSY)) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
 				"6310 XB release deferred for "
 				"ox_id x%x on reqtag x%x\n",
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index e4ec2b99b583..959ef471d758 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -611,7 +611,7 @@ lpfc_get_scsi_buf_s3(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
 	}
 	spin_unlock_irqrestore(&phba->scsi_buf_list_get_lock, iflag);
 
-	if (lpfc_ndlp_check_qdepth(phba, ndlp) && lpfc_cmd) {
+	if (lpfc_ndlp_check_qdepth(phba, ndlp)) {
 		atomic_inc(&ndlp->cmd_pending);
 		lpfc_cmd->flags |= LPFC_SBUF_BUMP_QDEPTH;
 	}
@@ -3826,7 +3826,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 		phba->sli4_hba.hdwq[idx].scsi_cstat.io_cmpls++;
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
-	if (phba->cpucheck_on & LPFC_CHECK_SCSI_IO) {
+	if (unlikely(phba->cpucheck_on & LPFC_CHECK_SCSI_IO)) {
 		cpu = raw_smp_processor_id();
 		if (cpu < LPFC_CHECK_CPU_CNT && phba->sli4_hba.hdwq)
 			phba->sli4_hba.hdwq[idx].cpucheck_cmpl_io[cpu]++;
@@ -3874,7 +3874,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 	}
 #endif
 
-	if (lpfc_cmd->status) {
+	if (unlikely(lpfc_cmd->status)) {
 		if (lpfc_cmd->status == IOSTAT_LOCAL_REJECT &&
 		    (lpfc_cmd->result & IOERR_DRVR_MASK))
 			lpfc_cmd->status = IOSTAT_DRIVER_REJECT;
@@ -4615,17 +4615,18 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 		err = lpfc_scsi_prep_dma_buf(phba, lpfc_cmd);
 	}
 
-	if (err == 2) {
-		cmnd->result = DID_ERROR << 16;
-		goto out_fail_command_release_buf;
-	} else if (err) {
+	if (unlikely(err)) {
+		if (err == 2) {
+			cmnd->result = DID_ERROR << 16;
+			goto out_fail_command_release_buf;
+		}
 		goto out_host_busy_free_buf;
 	}
 
 	lpfc_scsi_prep_cmnd(vport, lpfc_cmd, ndlp);
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
-	if (phba->cpucheck_on & LPFC_CHECK_SCSI_IO) {
+	if (unlikely(phba->cpucheck_on & LPFC_CHECK_SCSI_IO)) {
 		cpu = raw_smp_processor_id();
 		if (cpu < LPFC_CHECK_CPU_CNT) {
 			struct lpfc_sli4_hdw_queue *hdwq =
-- 
2.13.7

