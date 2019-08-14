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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 374A6C433FF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 092E620866
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uw/OnyEs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729797AbfHNX5v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:51 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36133 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729820AbfHNX5u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:50 -0400
Received: by mail-pl1-f193.google.com with SMTP id g4so339080plo.3
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zEAl2+ETJTgicDpnrNxTGXwF5aIIRSkOgSGbRMcCpLk=;
        b=uw/OnyEsKojc6PgTnv+71I8mB7+QCeVGoo0d1me3BEGUITrou3Vc4OUyv9hMU/FHAG
         A+c5yVnz0RGy9i176vBzkvTV0kKDNsQ63VtY9E24LYrM8Gq5hYTEW3n7bK3hdNO3aUI9
         +rMCrDjjUFlbue581R4hMNuzCic9oDfCfSBxdlGBaXuNdqUwDg6131hkV3znV0ENx79T
         qJ6LFpT1+n4+6s/W3263ghy4akqrzmg01B90gyeeeZEzH6cVa6Nk6pNzrFvXQEeH8VCW
         hTgIFoKW0NtTUUNhe0/55MtX+OIRLHMUZa7no/z36fMFhHm9yZGgC0q+JT9kHgTVRtQb
         KvsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zEAl2+ETJTgicDpnrNxTGXwF5aIIRSkOgSGbRMcCpLk=;
        b=rL3W6qKdiPHGr94NzzvOnS07YAX2Qrm5aeT9jDfWvrekIGFiSCsuKRY/xJe/N3apbs
         5cYTfC7KP6NqSf/823ho0jCMYJQ9x2POHDnJxSD5uq3yJsw6hoxKKNyCjqqWeeoCYEB/
         WA/Sbvr2W85hpHFsESM3cH0aNg8offyiaAdR0uR6AGmgiClzexdfz3AuQCWeWcUIHejX
         n3c6MNBb+HIDfhyfsZYlmqFMau+hGYVK0+kZ4mck+A1jkS+GaC1sgfzI/03pt1NMVCxj
         D2V2YWc3MUh13DxbG9yF91owK5m5BLCBZCtrHB6ej4pqbZp2267iNax6HwZvbib4E+Sr
         QtyA==
X-Gm-Message-State: APjAAAVoSoBT4Ik09LcxP37xrQ2TMvw9wbejHtOnrVmnE5BVnH3l/4DX
        nJjH+DHKjuU/2ttqKnn5DF3ry0ye
X-Google-Smtp-Source: APXvYqw/AflNqGJd5MVBVWE2BsHttGE4V7kihSgDmn1IVcyFmyVZIX87ggb0ndz9x8rBTFnG36b7Ug==
X-Received: by 2002:a17:902:7686:: with SMTP id m6mr1774454pll.239.1565827069789;
        Wed, 14 Aug 2019 16:57:49 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:49 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 35/42] lpfc: Add simple unlikely optimizations to reduce NVME latency
Date:   Wed, 14 Aug 2019 16:57:05 -0700
Message-Id: <20190814235712.4487-36-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

While performing code review, several relatively simple optimizations
can be done in the fast path.

Add these optimizations (unlikely designators).

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 41b124b69947..106aef82620d 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -999,9 +999,9 @@ lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 	idx = lpfc_ncmd->cur_iocbq.hba_wqidx;
 	phba->sli4_hba.hdwq[idx].nvme_cstat.io_cmpls++;
 
-	if (vport->localport) {
+	if (unlikely(status && vport->localport)) {
 		lport = (struct lpfc_nvme_lport *)vport->localport->private;
-		if (lport && status) {
+		if (lport) {
 			if (bf_get(lpfc_wcqe_c_xb, wcqe))
 				atomic_inc(&lport->cmpl_fcp_xb);
 			atomic_inc(&lport->cmpl_fcp_err);
@@ -1141,7 +1141,7 @@ lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 		phba->ktime_last_cmd = lpfc_ncmd->ts_data_nvme;
 		lpfc_nvme_ktime(phba, lpfc_ncmd);
 	}
-	if (phba->cpucheck_on & LPFC_CHECK_NVME_IO) {
+	if (unlikely(phba->cpucheck_on & LPFC_CHECK_NVME_IO)) {
 		uint32_t cpu;
 		idx = lpfc_ncmd->cur_iocbq.hba_wqidx;
 		cpu = raw_smp_processor_id();
@@ -1475,7 +1475,7 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
 		goto out_fail;
 	}
 
-	if (vport->load_flag & FC_UNLOADING) {
+	if (unlikely(vport->load_flag & FC_UNLOADING)) {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_IOERR,
 				 "6124 Fail IO, Driver unload\n");
 		atomic_inc(&lport->xmt_fcp_err);
-- 
2.13.7

