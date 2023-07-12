Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14CA3EB64DA
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 17:53:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232441AbjGLRx4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 13:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbjGLRxp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 13:53:45 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46A52100
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 10:53:41 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1b9d9cbcc70so6559695ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 10:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689184421; x=1689789221;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e19eQPaQE2yvpbV9jflN87bZC5C/rFCgbTaQAV3M7c8=;
        b=YrAfI0BJlQWzmcOEmEv54PcHwISdKE9J1wwGV4GTRbkHSKSjZR942dSxaG9tMJaCON
         P0R2RPBXLTOg4+hBhvz3powvOqpwnUL1cEbnI+yP3X1eatUcsnLaNLx2G/eXNZYWVZh6
         FZ1trlVIrk+EyDNZ4zPiiwztLVC641P/9lTIlWkUZ9BYsSrklECBHm3O90DRBbaMKFdX
         /yNek0AlM9Q2GkAG+9rBibhRh0GsuqZt7uzCe6+/luy0gab/MgiIdobRqADZAzJPKETA
         svDfi0YehI2g05f1q36e42gIEQLeQntSPwrMKHpmjLvOdodDNJysF+MS5iU6dNAwLu7K
         isvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689184421; x=1689789221;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e19eQPaQE2yvpbV9jflN87bZC5C/rFCgbTaQAV3M7c8=;
        b=B7sUH7FQVnhJLj7I3fNjEMYHHAlYvo1qRjw2fQcDUiQGIlIRlp/jXMCYdlP0v8Kk4H
         2hemMCPCSq9VGtsoPkDU7tHNCC6cLWOdv4KV+fyIUCjgnYXV+HWQS2JLamp6JomjLmMn
         8hl9U8H/jj8xDkTkfqWmeuuebExFBuLyh5fAyRbELBgzUdyHkjyrH+q1O54LelLj3lqs
         zV7RfNq8Ponbl6KDMC3X+ImBtMHPSVdYscXTf+4kyEn+tmJvD1XoC0Lt6tD0G+CPy1K8
         +9NRYOq4polC/toJIwyyZmtqZ78cu5lkrJZ1TBTVqcgJYY6VUw8RITO1gwT71ifbFY/4
         KerQ==
X-Gm-Message-State: ABy/qLbEaOcCLanHfV534zPVGNn3lfm28QN2XDJz9S3bKAuQd0VpzNZq
        2Y6dvocdTAaDY2Bu9hO3xv7J9gq3ykw=
X-Google-Smtp-Source: APBJJlGjwWGH3M4JO0W6a2Dbl1Mb4IPuFt0mImBu28DrqtUBTKt9UlZ9nCvcKvDTMfWg2bmdnG/ZIA==
X-Received: by 2002:a17:903:22ca:b0:1b8:b0c4:2e3d with SMTP id y10-20020a17090322ca00b001b8b0c42e3dmr81095plg.4.1689184420441;
        Wed, 12 Jul 2023 10:53:40 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d11-20020a170902b70b00b001b898595be7sm4218459pls.291.2023.07.12.10.53.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jul 2023 10:53:40 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 05/12] lpfc: Revise ndlp kref handling for dev_loss_tmo_callbk and lpfc_drop_node
Date:   Wed, 12 Jul 2023 11:05:15 -0700
Message-Id: <20230712180522.112722-6-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230712180522.112722-1-justintee8345@gmail.com>
References: <20230712180522.112722-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The ndlp kref count implementation in lpfc_dev_loss_tmo_callbk removes the
initial node reference when a vport is unloading.  When lpfc_cleanup sends
a DEVICE_RM event and is in NPR state, the driver calls lpfc_drop_node.
Subsequently, lpfc_drop_node also removes an ndlp kref thinking it is the
initial reference.  This unintentionally introduces an extra kref decrement
on the ndlp object.

Fix by using the NLP_DROPPED node flag in lpfc_dev_loss_tmo_callbk and
lpfc_drop_node to coordinate the removal of the initial node reference.

In lpfc_dev_loss_tmo_callbk, remove the SCSI transport reference provided
the node is registered in the dev_loss context because the driver cannot
call the SCSI transport in dev_loss context or afterwards.  And, have
lpfc_drop_node not remove a reference if another thread is acting or has
already acted on it.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 70 +++++++++++++++++++++-----------
 drivers/scsi/lpfc/lpfc_nvme.c    |  5 ++-
 2 files changed, 50 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index b4303254744a..388a481c8118 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -169,29 +169,44 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 
 	lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_NODE,
 			 "3181 dev_loss_callbk x%06x, rport x%px flg x%x "
-			 "load_flag x%x refcnt %d state %d xpt x%x\n",
+			 "load_flag x%x refcnt %u state %d xpt x%x\n",
 			 ndlp->nlp_DID, ndlp->rport, ndlp->nlp_flag,
 			 vport->load_flag, kref_read(&ndlp->kref),
 			 ndlp->nlp_state, ndlp->fc4_xpt_flags);
 
-	/* Don't schedule a worker thread event if the vport is going down.
-	 * The teardown process cleans up the node via lpfc_drop_node.
-	 */
+	/* Don't schedule a worker thread event if the vport is going down. */
 	if (vport->load_flag & FC_UNLOADING) {
-		((struct lpfc_rport_data *)rport->dd_data)->pnode = NULL;
+		spin_lock_irqsave(&ndlp->lock, iflags);
 		ndlp->rport = NULL;
 
-		ndlp->fc4_xpt_flags &= ~SCSI_XPT_REGD;
-		/* clear the NLP_XPT_REGD if the node is not registered
-		 * with nvme-fc
+		/* The scsi_transport is done with the rport so lpfc cannot
+		 * call to unregister. Remove the scsi transport reference
+		 * and clean up the SCSI transport node details.
 		 */
-		if (ndlp->fc4_xpt_flags == NLP_XPT_REGD)
-			ndlp->fc4_xpt_flags &= ~NLP_XPT_REGD;
+		if (ndlp->fc4_xpt_flags & (NLP_XPT_REGD | SCSI_XPT_REGD)) {
+			ndlp->fc4_xpt_flags &= ~SCSI_XPT_REGD;
 
-		/* Remove the node reference from remote_port_add now.
-		 * The driver will not call remote_port_delete.
+			/* NVME transport-registered rports need the
+			 * NLP_XPT_REGD flag to complete an unregister.
+			 */
+			if (!(ndlp->fc4_xpt_flags & NVME_XPT_REGD))
+				ndlp->fc4_xpt_flags &= ~NLP_XPT_REGD;
+			spin_unlock_irqrestore(&ndlp->lock, iflags);
+			lpfc_nlp_put(ndlp);
+			spin_lock_irqsave(&ndlp->lock, iflags);
+		}
+
+		/* Only 1 thread can drop the initial node reference.  If
+		 * another thread has set NLP_DROPPED, this thread is done.
 		 */
-		lpfc_nlp_put(ndlp);
+		if (!(ndlp->nlp_flag & NLP_DROPPED)) {
+			ndlp->nlp_flag |= NLP_DROPPED;
+			spin_unlock_irqrestore(&ndlp->lock, iflags);
+			lpfc_nlp_put(ndlp);
+			spin_lock_irqsave(&ndlp->lock, iflags);
+		}
+
+		spin_unlock_irqrestore(&ndlp->lock, iflags);
 		return;
 	}
 
@@ -4686,7 +4701,8 @@ lpfc_nlp_unreg_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	spin_lock_irqsave(&ndlp->lock, iflags);
 	if (!(ndlp->fc4_xpt_flags & NLP_XPT_REGD)) {
 		spin_unlock_irqrestore(&ndlp->lock, iflags);
-		lpfc_printf_vlog(vport, KERN_INFO, LOG_SLI,
+		lpfc_printf_vlog(vport, KERN_INFO,
+				 LOG_ELS | LOG_NODE | LOG_DISCOVERY,
 				 "0999 %s Not regd: ndlp x%px rport x%px DID "
 				 "x%x FLG x%x XPT x%x\n",
 				  __func__, ndlp, ndlp->rport, ndlp->nlp_DID,
@@ -4702,9 +4718,10 @@ lpfc_nlp_unreg_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		vport->phba->nport_event_cnt++;
 		lpfc_unregister_remote_port(ndlp);
 	} else if (!ndlp->rport) {
-		lpfc_printf_vlog(vport, KERN_INFO, LOG_SLI,
+		lpfc_printf_vlog(vport, KERN_INFO,
+				 LOG_ELS | LOG_NODE | LOG_DISCOVERY,
 				 "1999 %s NDLP in devloss x%px DID x%x FLG x%x"
-				 " XPT x%x refcnt %d\n",
+				 " XPT x%x refcnt %u\n",
 				 __func__, ndlp, ndlp->nlp_DID, ndlp->nlp_flag,
 				 ndlp->fc4_xpt_flags,
 				 kref_read(&ndlp->kref));
@@ -4954,22 +4971,29 @@ lpfc_drop_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 {
 	/*
 	 * Use of lpfc_drop_node and UNUSED list: lpfc_drop_node should
-	 * be used if we wish to issue the "last" lpfc_nlp_put() to remove
-	 * the ndlp from the vport. The ndlp marked as UNUSED on the list
-	 * until ALL other outstanding threads have completed. We check
-	 * that the ndlp not already in the UNUSED state before we proceed.
+	 * be used when lpfc wants to remove the "last" lpfc_nlp_put() to
+	 * release the ndlp from the vport when conditions are correct.
 	 */
 	if (ndlp->nlp_state == NLP_STE_UNUSED_NODE)
 		return;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNUSED_NODE);
-	ndlp->nlp_flag |= NLP_DROPPED;
 	if (vport->phba->sli_rev == LPFC_SLI_REV4) {
 		lpfc_cleanup_vports_rrqs(vport, ndlp);
 		lpfc_unreg_rpi(vport, ndlp);
 	}
 
-	lpfc_nlp_put(ndlp);
-	return;
+	/* NLP_DROPPED means another thread already removed the initial
+	 * reference from lpfc_nlp_init.  If set, don't drop it again and
+	 * introduce an imbalance.
+	 */
+	spin_lock_irq(&ndlp->lock);
+	if (!(ndlp->nlp_flag & NLP_DROPPED)) {
+		ndlp->nlp_flag |= NLP_DROPPED;
+		spin_unlock_irq(&ndlp->lock);
+		lpfc_nlp_put(ndlp);
+		return;
+	}
+	spin_unlock_irq(&ndlp->lock);
 }
 
 /*
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 3ee5cde481f3..39acbcb7ec66 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2503,8 +2503,9 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		lpfc_printf_vlog(vport, KERN_ERR,
 				 LOG_TRACE_EVENT,
 				 "6031 RemotePort Registration failed "
-				 "err: %d, DID x%06x\n",
-				 ret, ndlp->nlp_DID);
+				 "err: %d, DID x%06x ref %u\n",
+				 ret, ndlp->nlp_DID, kref_read(&ndlp->kref));
+		lpfc_nlp_put(ndlp);
 	}
 
 	return ret;
-- 
2.38.0

