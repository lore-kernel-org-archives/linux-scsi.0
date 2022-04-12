Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3E07C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 23:34:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbiDLXg5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbiDLXct (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 19:32:49 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DF9C559A
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:21 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id k14so3527pga.0
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dpJwyubmEEG4q6uBrYJoCQzzFk49i1eY4Z47w3D6rPQ=;
        b=dDSHNAbz5K0fqBG5jatye8OSA+KVSM2JXxg6pjrvD5NGcEOEqrj34BDIQSfy5eCDhl
         VTvo/sJRWsGWraVSSj884TEH5AMLjcOeQThLeBUwNHVMtgveNNrm6aA//a5Yj5Mq2G7B
         lLpHq0fIJNRX0cbF+fope5SB9D95ND4e7CjO+ZBGJbNVzs92PS36dXC3rpC4wEv+3kcW
         ssttPrjmdbS/1J7JrOCgMdkbjxlJcTDrKHd+fRIr1SVe/SuZq2J97iAB03p9GuqGZBPB
         qm6dhgCENev/T9BSVzmZuYCA+2eKCappLCnbeOV7DGhPuEQjfuz7HBOx/4EQl11Cy8h+
         bWQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dpJwyubmEEG4q6uBrYJoCQzzFk49i1eY4Z47w3D6rPQ=;
        b=KZ5xJKBi7wQ4iGRn3WPBEn/dB42wC5Fmmh/I+RjZsmOG5fugUpZ3V7y822hOBpaRAH
         keOq0HTXYWEFXAFdCy2qnx1CiueMWu4Aq6qgB/cxD5ZG6qm7hXGslTmQorISL5XfUcgw
         DKGaH7hlw+Go8IR87iGlc1A3BikB2duO1FtNrjMOj+cT6/OVVTH6oowuVEP3TiKPr3kD
         +UKJyNtLHh01xZLrc1KlUtPHinlZu+TlB52ix8Ab8KbkA5i6uQ5YkB0Mt4XIZMCvUnTu
         so0PLkZD3/21Je6DfUM99WGRBLY4JJfLbjhivgZsMNuUACu+LYMJ0lOC/ehho3syQnYq
         H4xg==
X-Gm-Message-State: AOAM5302ZYzDK0AEuusrxGUR23rkWTiddlMX0ZDfsGhEEaWccfIDkfjg
        67DO6+hJk0sTsjqYRssO52qYzrIC6Ow=
X-Google-Smtp-Source: ABdhPJw+mxyfRT5KklzNNZ8J44tWJ1LFZWOFsPTx0AvyTKl/Z2nBXQ2CU/WcYhshnfwVzPAAHmT6Hw==
X-Received: by 2002:aa7:90d4:0:b0:4fd:acb9:8eac with SMTP id k20-20020aa790d4000000b004fdacb98eacmr39852709pfk.24.1649802021329;
        Tue, 12 Apr 2022 15:20:21 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a000b8f00b004fa9dbf27desm40429824pfj.55.2022.04.12.15.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 15:20:21 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 08/26] lpfc: Fix null pointer dereference after failing to issue FLOGI and PLOGI
Date:   Tue, 12 Apr 2022 15:19:50 -0700
Message-Id: <20220412222008.126521-9-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220412222008.126521-1-jsmart2021@gmail.com>
References: <20220412222008.126521-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If lpfc_issue_els_flogi() fails and returns non-zero status, the
node reference count is decremented to trigger the release of the
nodelist structure. However, if there is a prior registration or
dev-loss-evt work pending, the node may be released prematurely.
When dev-loss-evt completes, the released node is referenced causing
a use-after-free null pointer dereference.

Similarly, when processing non-zero ELS PLOGI completion status in
lpfc_cmpl_els_plogi(), the ndlp flags are checked for a transport
registration before triggering node removal.  If dev-loss-evt work is
pending, the node may be released prematurely and a subsequent call to
lpfc_dev_loss_tmo_handler() results in a use after free ndlp dereference.

Add test for pending dev-loss before decrementing the node reference
count for FLOGI, PLOGI, PRLI, and ADISC handling.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 51 +++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 863251322715..10e534d63508 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1533,10 +1533,13 @@ lpfc_initial_flogi(struct lpfc_vport *vport)
 	/* Reset the Fabric flag, topology change may have happened */
 	vport->fc_flag &= ~FC_FABRIC;
 	if (lpfc_issue_els_flogi(vport, ndlp, 0)) {
-		/* This decrement of reference count to node shall kick off
-		 * the release of the node.
+		/* A node reference should be retained while registered with a
+		 * transport or dev-loss-evt work is pending.
+		 * Otherwise, decrement node reference to trigger release.
 		 */
-		lpfc_nlp_put(ndlp);
+		if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD)) &&
+		    !(ndlp->nlp_flag & NLP_IN_DEV_LOSS))
+			lpfc_nlp_put(ndlp);
 		return 0;
 	}
 	return 1;
@@ -1579,10 +1582,13 @@ lpfc_initial_fdisc(struct lpfc_vport *vport)
 	}
 
 	if (lpfc_issue_els_fdisc(vport, ndlp, 0)) {
-		/* decrement node reference count to trigger the release of
-		 * the node.
+		/* A node reference should be retained while registered with a
+		 * transport or dev-loss-evt work is pending.
+		 * Otherwise, decrement node reference to trigger release.
 		 */
-		lpfc_nlp_put(ndlp);
+		if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD)) &&
+		    !(ndlp->nlp_flag & NLP_IN_DEV_LOSS))
+			lpfc_nlp_put(ndlp);
 		return 0;
 	}
 	return 1;
@@ -1984,6 +1990,7 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	int disc;
 	struct serv_parm *sp = NULL;
 	u32 ulp_status, ulp_word4, did, iotag;
+	bool release_node = false;
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
 	cmdiocb->context_un.rsp_iocb = rspiocb;
@@ -2072,19 +2079,21 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			spin_unlock_irq(&ndlp->lock);
 			goto out;
 		}
-		spin_unlock_irq(&ndlp->lock);
 
 		/* No PLOGI collision and the node is not registered with the
 		 * scsi or nvme transport. It is no longer an active node. Just
 		 * start the device remove process.
 		 */
 		if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD))) {
-			spin_lock_irq(&ndlp->lock);
 			ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
-			spin_unlock_irq(&ndlp->lock);
+			if (!(ndlp->nlp_flag & NLP_IN_DEV_LOSS))
+				release_node = true;
+		}
+		spin_unlock_irq(&ndlp->lock);
+
+		if (release_node)
 			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 						NLP_EVT_DEVICE_RM);
-		}
 	} else {
 		/* Good status, call state machine */
 		prsp = list_entry(((struct lpfc_dmabuf *)
@@ -2295,6 +2304,7 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	u32 loglevel;
 	u32 ulp_status;
 	u32 ulp_word4;
+	bool release_node = false;
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
 	cmdiocb->context_un.rsp_iocb = rspiocb;
@@ -2371,14 +2381,18 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		 * it is no longer an active node.  Otherwise devloss
 		 * handles the final cleanup.
 		 */
+		spin_lock_irq(&ndlp->lock);
 		if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD)) &&
 		    !ndlp->fc4_prli_sent) {
-			spin_lock_irq(&ndlp->lock);
 			ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
-			spin_unlock_irq(&ndlp->lock);
+			if (!(ndlp->nlp_flag & NLP_IN_DEV_LOSS))
+				release_node = true;
+		}
+		spin_unlock_irq(&ndlp->lock);
+
+		if (release_node)
 			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 						NLP_EVT_DEVICE_RM);
-		}
 	} else {
 		/* Good status, call state machine.  However, if another
 		 * PRLI is outstanding, don't call the state machine
@@ -2750,6 +2764,7 @@ lpfc_cmpl_els_adisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	struct lpfc_nodelist *ndlp;
 	int  disc;
 	u32 ulp_status, ulp_word4, tmo;
+	bool release_node = false;
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
 	cmdiocb->context_un.rsp_iocb = rspiocb;
@@ -2816,13 +2831,17 @@ lpfc_cmpl_els_adisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		 * transport, it is no longer an active node. Otherwise
 		 * devloss handles the final cleanup.
 		 */
+		spin_lock_irq(&ndlp->lock);
 		if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD))) {
-			spin_lock_irq(&ndlp->lock);
 			ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
-			spin_unlock_irq(&ndlp->lock);
+			if (!(ndlp->nlp_flag & NLP_IN_DEV_LOSS))
+				release_node = true;
+		}
+		spin_unlock_irq(&ndlp->lock);
+
+		if (release_node)
 			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 						NLP_EVT_DEVICE_RM);
-		}
 	} else
 		/* Good status, call state machine */
 		lpfc_disc_state_machine(vport, ndlp, cmdiocb,
-- 
2.26.2

