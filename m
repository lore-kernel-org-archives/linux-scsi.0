Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30782C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 23:33:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiDLXgK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbiDLXcy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 19:32:54 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD65C624F
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:30 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id bx5so72014pjb.3
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6mmV0JW08Uv5oVDrL+mWCkquVp5lL9j2n8D7zkUd/zg=;
        b=P2mDutHuZHaGSN3/VXCRtN+CxhRs4Zl9ESyzVu4bhGHAT9q5cvwS5NdkGkrKN27jRl
         VAybXuQkLLn8WjsuYDEG/Sk/HMWJcDpl+3rcNCYCnA3Ldk1mECCcB9jlzEGJBtWBQj56
         HomuDSyP4lAQeE12cdHXeYGfjoAYrSnYWyzGk6HlwCJc9N62p8Gs9gSV9EYxJiDd3GG/
         470wOlyGxgNXkmwv/ibOJFIuy/cb1PfJScm3+nT+bIWhOQFGahk0oU+hYoLyErZqQzvP
         0u835yjrO/MRL6dZuwsFmO10nihiWH694Cc89/E7VwAw1/zfGF92ISBMVbELZ4/vEWdo
         mVPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6mmV0JW08Uv5oVDrL+mWCkquVp5lL9j2n8D7zkUd/zg=;
        b=1gDjVlz1QqYPk8GT9tUGNxj9ZlRUSx32QTgPjS5eY/bk6F/JTTv+F3Y6SvpBnVZxIE
         8ms/aepCgyBrdU5RAAam9knTDFEENfKyK/NUSsLoN8U+/hLEdXxgGvVwlC4nMDNb2onF
         3MApejxkd5fGOPfwbkWG7iJw81U+VQK88883mnUHiA2HtjCHeN4bQCWl+14NxlZJbThX
         6N4B5Ifiw7fLBGflXPJggrN3Hm3ENvcsDiPXFmY800++Aj/hWEo4R8aT810i1+3M0qYS
         kDKUB2fxE1o2cHi3e+ICdbKs3/J3YR6mFU0t3UQzJBT6TwLC1JG35Mz8LSyxVhm0iQk9
         i5jQ==
X-Gm-Message-State: AOAM532t+TWPcan1tUH9SSNg37GuuXbN/ZJ/0XXGehsJe2HPlUeKNzVA
        LTeBhrufo8x1E/xstcQ3VcvXPKBY4is=
X-Google-Smtp-Source: ABdhPJwzmN6ciqb98be8eH9Eibe4/s0ejrbG/bizJWkpJsLUwxU30ck4sEyRY0BgYcFSjuIgl0qG6g==
X-Received: by 2002:a17:90a:6c64:b0:1cb:93b2:b6a9 with SMTP id x91-20020a17090a6c6400b001cb93b2b6a9mr7424666pjj.144.1649802029650;
        Tue, 12 Apr 2022 15:20:29 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a000b8f00b004fa9dbf27desm40429824pfj.55.2022.04.12.15.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 15:20:29 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 19/26] lpfc: Introduce FC_RSCN_MEMENTO flag for tracking post RSCN completion
Date:   Tue, 12 Apr 2022 15:20:01 -0700
Message-Id: <20220412222008.126521-20-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220412222008.126521-1-jsmart2021@gmail.com>
References: <20220412222008.126521-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During an NVME target reboot, the target may initialize itself as FCP only
during the first RSCN and shortly after trigger a second RSCN claiming NVME
support.  The timing of these RSCNs occur before FCP-PRLI for the first
RSCN completes leading discovery issues over NVME.

Change RSCN and NVME-PRLI send logic based on a new FC_RSCN_MEMENTO flag
that signals when lpfc_end_rscn is completed and serves as a memento that
discovery was started from RSCN.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h         | 1 +
 drivers/scsi/lpfc/lpfc_els.c     | 8 ++++++--
 drivers/scsi/lpfc/lpfc_hbadisc.c | 3 ++-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 8405fd0bbc59..96602a88b8ed 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -603,6 +603,7 @@ struct lpfc_vport {
 #define FC_VFI_REGISTERED	0x800000 /* VFI is registered */
 #define FC_FDISC_COMPLETED	0x1000000/* FDISC completed */
 #define FC_DISC_DELAYED		0x2000000/* Delay NPort discovery */
+#define FC_RSCN_MEMENTO		0x4000000/* RSCN cmd processed */
 
 	uint32_t ct_flags;
 #define FC_CT_RFF_ID		0x1	 /* RFF_ID accepted by switch */
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 3bcc0243bf42..3801c39b62d4 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1895,6 +1895,7 @@ lpfc_end_rscn(struct lpfc_vport *vport)
 		else {
 			spin_lock_irq(shost->host_lock);
 			vport->fc_flag &= ~FC_RSCN_MODE;
+			vport->fc_flag |= FC_RSCN_MEMENTO;
 			spin_unlock_irq(shost->host_lock);
 		}
 	}
@@ -2443,13 +2444,14 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	u32 local_nlp_type, elscmd;
 
 	/*
-	 * If we are in RSCN mode, the FC4 types supported from a
+	 * If discovery was kicked off from RSCN mode,
+	 * the FC4 types supported from a
 	 * previous GFT_ID command may not be accurate. So, if we
 	 * are a NVME Initiator, always look for the possibility of
 	 * the remote NPort beng a NVME Target.
 	 */
 	if (phba->sli_rev == LPFC_SLI_REV4 &&
-	    vport->fc_flag & FC_RSCN_MODE &&
+	    vport->fc_flag & (FC_RSCN_MODE | FC_RSCN_MEMENTO) &&
 	    vport->nvmei_support)
 		ndlp->nlp_fc4_type |= NLP_FC4_NVME;
 	local_nlp_type = ndlp->nlp_fc4_type;
@@ -7970,6 +7972,7 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 		if ((rscn_cnt < FC_MAX_HOLD_RSCN) &&
 		    !(vport->fc_flag & FC_RSCN_DISCOVERY)) {
 			vport->fc_flag |= FC_RSCN_MODE;
+			vport->fc_flag &= ~FC_RSCN_MEMENTO;
 			spin_unlock_irq(shost->host_lock);
 			if (rscn_cnt) {
 				cmd = vport->fc_rscn_id_list[rscn_cnt-1]->virt;
@@ -8019,6 +8022,7 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 
 	spin_lock_irq(shost->host_lock);
 	vport->fc_flag |= FC_RSCN_MODE;
+	vport->fc_flag &= ~FC_RSCN_MEMENTO;
 	spin_unlock_irq(shost->host_lock);
 	vport->fc_rscn_id_list[vport->fc_rscn_id_cnt++] = pcmd;
 	/* Indicate we are done walking fc_rscn_id_list on this vport */
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 2b877dff5ed4..d6ff864b132b 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1343,7 +1343,8 @@ lpfc_linkup_port(struct lpfc_vport *vport)
 
 	spin_lock_irq(shost->host_lock);
 	vport->fc_flag &= ~(FC_PT2PT | FC_PT2PT_PLOGI | FC_ABORT_DISCOVERY |
-			    FC_RSCN_MODE | FC_NLP_MORE | FC_RSCN_DISCOVERY);
+			    FC_RSCN_MEMENTO | FC_RSCN_MODE |
+			    FC_NLP_MORE | FC_RSCN_DISCOVERY);
 	vport->fc_flag |= FC_NDISC_ACTIVE;
 	vport->fc_ns_retry = 0;
 	spin_unlock_irq(shost->host_lock);
-- 
2.26.2

