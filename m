Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 040F5CCA479
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Jul 2022 21:15:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbiGAVPO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Jul 2022 17:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbiGAVPL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2022 17:15:11 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3D843AE0
        for <linux-scsi@vger.kernel.org>; Fri,  1 Jul 2022 14:15:10 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id b125so2697849qkg.11
        for <linux-scsi@vger.kernel.org>; Fri, 01 Jul 2022 14:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bTctusDPUQ6dpOmwSeJoxHf3oZihoAR5MMEfys9sFmk=;
        b=e/A6YFHWmw5m6BVUOQO1V2bdm+yO1sZjM3zel4fek7sQycYe5/Kg4CCvVan4L2aV8M
         FAhKSNwKkk106sdKnTFqxhhbtSshqnLofjDL0AUJH7uJG9cLmC3M63f9v/EywAMDtJY3
         VvGVB27lAv9ElDo/1pr71YhgcFix7aOuVgHF/TNuYpW5PFeKFSljhc6DQTCVVrqE7Rv9
         jaQGRABK5xx096Qb3roLLOtvJZXM0wRAMNCQc7E76vwdB0tpEwXTc81eGhIJCGPTajXR
         hXz3CPKtymKYrLR+TRL7d7+B1b8NxkZQpVyKYyDrZzXNvCnfvUDgYUDv7rnqoXz3kWEf
         xCZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bTctusDPUQ6dpOmwSeJoxHf3oZihoAR5MMEfys9sFmk=;
        b=JQuD9quregOjfK13YCNPUltdXOmYZOyhvhUG2Cw+1ffVeetjH6Bm2yMg8Kxe1gzXwm
         glITUk2s/C1aiNGlXQMoRcM/vOw1V1aejYZoafK/U7n5gw1LVFHV9pDG5jkJbuPLvfvi
         F4Pz8WQJwbdh1/SsiXeR8f/cbkVLqHpPUsjLPvapAceFNeIShvUjbz1+hMo6XGrHPHiP
         W+BW5jYLVbMWZq6a9SIA3Og7U9QAIGElFpOlffdrlMkS/ukEaITK/9rcwo3OE9Eyv3lY
         h8mAYeEPwX1UqBawVDsaOXTgP8pZnfMFeqYuXOj6L3Cuy40fO4l4nmd8NIYVQXC8b6Mu
         nSCw==
X-Gm-Message-State: AJIora88G5/3yVlKSKKxEGtPaja1kG4dsG4btMDhhQL7sKxP68VYA5Cx
        mVDwP0TuyS0I0sKlU4eEgficDicNl9o=
X-Google-Smtp-Source: AGRyM1vrMTjNJSHVNe+5TmdXC5Eadp/N8R/giYYC6R9Nf6ULpj9ECEEDsDlBozYy3tRxzs6x+2645Q==
X-Received: by 2002:a05:620a:10a1:b0:6ae:fecd:758f with SMTP id h1-20020a05620a10a100b006aefecd758fmr12314838qkk.412.1656710109819;
        Fri, 01 Jul 2022 14:15:09 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g6-20020ac842c6000000b00317ccc66971sm14584509qtm.52.2022.07.01.14.15.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 14:15:08 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 08/12] lpfc: Revert RSCN_MEMENTO workaround for misbehaved configuration
Date:   Fri,  1 Jul 2022 14:14:21 -0700
Message-Id: <20220701211425.2708-9-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220701211425.2708-1-jsmart2021@gmail.com>
References: <20220701211425.2708-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The RSCN_MEMENTO logic was to workaround a target that does not
register both FCP and NVME FC4 types at the same time.  This caused
the configuration to not produce a second RSCN for the NVME FC4 type
registration in a timely manner.  The intention of the RSCN_MEMENTO
flag was to always signal to try NVME PRLI.

However, there are other FCP-only target arrays in correctly behaved
configurations that reject the NVME PRLI followed by a LOGO leading
to never rediscovering the target after an issue_lip (as LOGO causes
a repeat of PLOGI/PRLIs).

Revert the RSCN_MEMENTO patch as it is causing correctly behaved
configs to fail while it exists only to succeed on a misbehaved
config.

Fixes: 1045592fc968 ("scsi: lpfc: Introduce FC_RSCN_MEMENTO flag for tracking post RSCN completion")
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h         | 1 -
 drivers/scsi/lpfc/lpfc_els.c     | 8 ++------
 drivers/scsi/lpfc/lpfc_hbadisc.c | 3 +--
 3 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index da9070cdad91..212f9b962187 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -604,7 +604,6 @@ struct lpfc_vport {
 #define FC_VFI_REGISTERED	0x800000 /* VFI is registered */
 #define FC_FDISC_COMPLETED	0x1000000/* FDISC completed */
 #define FC_DISC_DELAYED		0x2000000/* Delay NPort discovery */
-#define FC_RSCN_MEMENTO		0x4000000/* RSCN cmd processed */
 
 	uint32_t ct_flags;
 #define FC_CT_RFF_ID		0x1	 /* RFF_ID accepted by switch */
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 31fb2ee07bfa..9371829e11b2 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1887,7 +1887,6 @@ lpfc_end_rscn(struct lpfc_vport *vport)
 		else {
 			spin_lock_irq(shost->host_lock);
 			vport->fc_flag &= ~FC_RSCN_MODE;
-			vport->fc_flag |= FC_RSCN_MEMENTO;
 			spin_unlock_irq(shost->host_lock);
 		}
 	}
@@ -2435,14 +2434,13 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	u32 local_nlp_type, elscmd;
 
 	/*
-	 * If discovery was kicked off from RSCN mode,
-	 * the FC4 types supported from a
+	 * If we are in RSCN mode, the FC4 types supported from a
 	 * previous GFT_ID command may not be accurate. So, if we
 	 * are a NVME Initiator, always look for the possibility of
 	 * the remote NPort beng a NVME Target.
 	 */
 	if (phba->sli_rev == LPFC_SLI_REV4 &&
-	    vport->fc_flag & (FC_RSCN_MODE | FC_RSCN_MEMENTO) &&
+	    vport->fc_flag & FC_RSCN_MODE &&
 	    vport->nvmei_support)
 		ndlp->nlp_fc4_type |= NLP_FC4_NVME;
 	local_nlp_type = ndlp->nlp_fc4_type;
@@ -7916,7 +7914,6 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 		if ((rscn_cnt < FC_MAX_HOLD_RSCN) &&
 		    !(vport->fc_flag & FC_RSCN_DISCOVERY)) {
 			vport->fc_flag |= FC_RSCN_MODE;
-			vport->fc_flag &= ~FC_RSCN_MEMENTO;
 			spin_unlock_irq(shost->host_lock);
 			if (rscn_cnt) {
 				cmd = vport->fc_rscn_id_list[rscn_cnt-1]->virt;
@@ -7966,7 +7963,6 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 
 	spin_lock_irq(shost->host_lock);
 	vport->fc_flag |= FC_RSCN_MODE;
-	vport->fc_flag &= ~FC_RSCN_MEMENTO;
 	spin_unlock_irq(shost->host_lock);
 	vport->fc_rscn_id_list[vport->fc_rscn_id_cnt++] = pcmd;
 	/* Indicate we are done walking fc_rscn_id_list on this vport */
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index fb36f26170e4..5cd838eac455 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1354,8 +1354,7 @@ lpfc_linkup_port(struct lpfc_vport *vport)
 
 	spin_lock_irq(shost->host_lock);
 	vport->fc_flag &= ~(FC_PT2PT | FC_PT2PT_PLOGI | FC_ABORT_DISCOVERY |
-			    FC_RSCN_MEMENTO | FC_RSCN_MODE |
-			    FC_NLP_MORE | FC_RSCN_DISCOVERY);
+			    FC_RSCN_MODE | FC_NLP_MORE | FC_RSCN_DISCOVERY);
 	vport->fc_flag |= FC_NDISC_ACTIVE;
 	vport->fc_ns_retry = 0;
 	spin_unlock_irq(shost->host_lock);
-- 
2.26.2

