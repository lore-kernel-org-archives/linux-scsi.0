Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16DD0C43381
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 00:18:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E173E207AA
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 00:18:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbhACASQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Jan 2021 19:18:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbhACASP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Jan 2021 19:18:15 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A68C7C0617A0
        for <linux-scsi@vger.kernel.org>; Sat,  2 Jan 2021 16:17:12 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id c79so14153106pfc.2
        for <linux-scsi@vger.kernel.org>; Sat, 02 Jan 2021 16:17:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ChNI7Nh7LdTn+Mg7J4ELQadAqoqOXgUCYbQxrsAyz4Y=;
        b=BkRqOHBN5iWqR1wyh4wy74SwpxXRoA6R845hveEW/8CyUpo76d5w7k9NKyMnpWRioN
         2jtYglP21tmQHfyZoeUuygJBoOfYdwMqePBG1YYUx3EAWbIp/TP/8iUE5fBuXqztApWL
         JbziUgl5KYruWBduAMGneFV+kzyRPM1UGZMoN4W3Ukq0nAxRcB3MelXijyMWWE3xM7Gd
         01zslYQAizJpa9ld1RdXqfXz+uYvbliyg1R9f/7o+vmET2iJLcWovN71RQDHlsMmjijZ
         N00p3mjGdndomfaFLOY3/Xe7tKCFAj9/YjYW7cR3iiswEadpd4FJR9OU4Fpc3XC1ynHV
         eUgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ChNI7Nh7LdTn+Mg7J4ELQadAqoqOXgUCYbQxrsAyz4Y=;
        b=FXaEdmFjPMIwiwu5SbTqgyd93TJVaMGjy6csWCa4p5MQ77GP5u68KK3+w5wiVFRtah
         SAxyO9dE281XX1TnJXY6vv4CUSPLIFbkKxj3sFULIYCKFJqLy1bu2sqhdFbL1y5ZgY8j
         nqxiTPCVO9Rn6JmgNg7OIltpnG+WX04r0f7tbZOzq4oJRrS/GvpPAj+tmrgrGK92v+gJ
         lL3IyARtRd3loDehnFnlvjBsPa7I444fmRafX0hKG040k11ncgy/AbWFCQaZvtG4nl1D
         klTLNGp4Qmvc1gczKCLGD2KUoOPxSkARkcx/UtqYDbjwkHpMUXrHm/5lhTXmK/AebEGz
         yNzg==
X-Gm-Message-State: AOAM5311wMgmR7WJMTRm4RUl3wats6QnK8+b88yCT4KbWqFbIQVYOp6r
        L9K4QeojAlVG6YZj01wNPnQQOIlikkM=
X-Google-Smtp-Source: ABdhPJwixdnLaKym1ippJvtmHu+1PfkaVvwNcnePLuShA5EOoO7WmhmHEl0d+AKWg5pq5nFDCqoGKw==
X-Received: by 2002:a63:5805:: with SMTP id m5mr37815556pgb.352.1609633032162;
        Sat, 02 Jan 2021 16:17:12 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q12sm55671867pgj.24.2021.01.02.16.17.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jan 2021 16:17:11 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 09/15] lpfc: Fix target reset failing
Date:   Sat,  2 Jan 2021 16:16:33 -0800
Message-Id: <20210103001639.1995-10-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210103001639.1995-1-jsmart2021@gmail.com>
References: <20210103001639.1995-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Target reset is failed by the target as an invalid command.

The Target Reset TMF has been obsoleted in T10 for a while, but continues
to be used. On (newer) devices, the TMF is rejected causing the reset
handler to escalate to adapter resets.

Fix by having Target Reset TMF rejections be translated into a LOGO and
re-PLOGI with the target device. This provides the same semantic action
(although, if the device also supports nvme traffic, it will terminate
nvme traffic as well - but it's still recoverable).

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_disc.h |  3 +++
 drivers/scsi/lpfc/lpfc_els.c  |  7 +++++++
 drivers/scsi/lpfc/lpfc_scsi.c | 38 +++++++++++++++++++++++++++++++++--
 3 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index ea07afcb750a..4cea61b63fdf 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -135,14 +135,17 @@ struct lpfc_nodelist {
 	struct lpfc_scsicmd_bkt *lat_data;	/* Latency data */
 	uint32_t fc4_prli_sent;
 	uint32_t fc4_xpt_flags;
+	uint32_t upcall_flags;
 #define NLP_WAIT_FOR_UNREG    0x1
 #define SCSI_XPT_REGD         0x2
 #define NVME_XPT_REGD         0x4
+#define NLP_WAIT_FOR_LOGO     0x2
 
 
 	uint32_t nvme_fb_size; /* NVME target's supported byte cnt */
 #define NVME_FB_BIT_SHIFT 9    /* PRLI Rsp first burst in 512B units. */
 	uint32_t nlp_defer_did;
+	wait_queue_head_t *logo_waitq;
 };
 
 struct lpfc_node_rrq {
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index e099caa04535..c944f220406e 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2817,6 +2817,7 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	IOCB_t *irsp;
 	unsigned long flags;
 	uint32_t skip_recovery = 0;
+	int wake_up_waiter = 0;
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
 	cmdiocb->context_un.rsp_iocb = rspiocb;
@@ -2824,6 +2825,10 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	irsp = &(rspiocb->iocb);
 	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag &= ~NLP_LOGO_SND;
+	if (ndlp->upcall_flags & NLP_WAIT_FOR_LOGO) {
+		wake_up_waiter = 1;
+		ndlp->upcall_flags &= ~NLP_WAIT_FOR_LOGO;
+	}
 	spin_unlock_irq(&ndlp->lock);
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
@@ -2889,6 +2894,8 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	 * Initiator, we are assuming the NPortID is not going to change.
 	 */
 
+	if (wake_up_waiter && ndlp->logo_waitq)
+		wake_up(ndlp->logo_waitq);
 	/*
 	 * If the node is a target, the handling attempts to recover the port.
 	 * For any other port type, the rpi is unregistered as an implicit
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 78f34b1af980..4ee890de556b 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5924,6 +5924,8 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 	struct lpfc_scsi_event_header scsi_event;
 	int status;
 	u32 logit = LOG_FCP;
+	unsigned long flags;
+	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(waitq);
 
 	rdata = lpfc_rport_data_from_scsi_device(cmnd->device);
 	if (!rdata || !rdata->pnode) {
@@ -5942,10 +5944,10 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 			"0722 Target Reset rport failure: rdata x%px\n", rdata);
 		if (pnode) {
-			spin_lock_irq(&pnode->lock);
+			spin_lock_irqsave(&pnode->lock, flags);
 			pnode->nlp_flag &= ~NLP_NPR_ADISC;
 			pnode->nlp_fcp_info &= ~NLP_FCP_2_DEVICE;
-			spin_unlock_irq(&pnode->lock);
+			spin_unlock_irqrestore(&pnode->lock, flags);
 		}
 		lpfc_reset_flush_io_context(vport, tgt_id, lun_id,
 					  LPFC_CTX_TGT);
@@ -5965,6 +5967,38 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 					FCP_TARGET_RESET);
 	if (status != SUCCESS)
 		logit =  LOG_TRACE_EVENT;
+	spin_lock_irqsave(&pnode->lock, flags);
+	if (status != SUCCESS &&
+	    (!(pnode->upcall_flags & NLP_WAIT_FOR_LOGO)) &&
+	     !pnode->logo_waitq) {
+		pnode->logo_waitq = &waitq;
+		pnode->nlp_fcp_info &= ~NLP_FCP_2_DEVICE;
+		pnode->nlp_flag |= NLP_ISSUE_LOGO;
+		pnode->upcall_flags |= NLP_WAIT_FOR_LOGO;
+		spin_unlock_irqrestore(&pnode->lock, flags);
+		lpfc_unreg_rpi(vport, pnode);
+		wait_event_timeout(waitq,
+				   (!(pnode->upcall_flags & NLP_WAIT_FOR_LOGO)),
+				    msecs_to_jiffies(vport->cfg_devloss_tmo *
+				    1000));
+
+		if (pnode->upcall_flags & NLP_WAIT_FOR_LOGO) {
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
+				"0725 SCSI layer TGTRST failed & LOGO TMO "
+				" (%d, %llu) return x%x\n", tgt_id,
+				 lun_id, status);
+			spin_lock_irqsave(&pnode->lock, flags);
+			pnode->upcall_flags &= ~NLP_WAIT_FOR_LOGO;
+		} else {
+			spin_lock_irqsave(&pnode->lock, flags);
+		}
+		pnode->logo_waitq = NULL;
+		spin_unlock_irqrestore(&pnode->lock, flags);
+		status = SUCCESS;
+	} else {
+		status = FAILED;
+		spin_unlock_irqrestore(&pnode->lock, flags);
+	}
 
 	lpfc_printf_vlog(vport, KERN_ERR, logit,
 			 "0723 SCSI layer issued Target Reset (%d, %llu) "
-- 
2.26.2

