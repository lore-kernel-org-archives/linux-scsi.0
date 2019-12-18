Return-Path: <SRS0=fPmA=2I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D72CCC43603
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 23:58:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3DB021582
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 23:58:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O//oC6th"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbfLRX6X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Dec 2019 18:58:23 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40197 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbfLRX6X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Dec 2019 18:58:23 -0500
Received: by mail-wm1-f65.google.com with SMTP id t14so3779360wmi.5
        for <linux-scsi@vger.kernel.org>; Wed, 18 Dec 2019 15:58:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lrMO+X0pnVDmR5NsLnBgTuH6R3oc5OogPrLSBAvgVYA=;
        b=O//oC6thZJZzBefefDJ1pXqQjYDFdJri/LX/k38KeIFtEyVAxgf87plW8YAG4CxGm7
         9mA6aLCATiE4c55LqiXZNfpwAxooE8pwD13M+8wmclAtSItxG8zIeV4R8RQ2o9rFaj5O
         Vw+w9hyE/cS+tWIcGHhI2gsL87nwu+ca9iygZPadiBEbpxH109jUWKd1OQ9YaVmjvJLp
         6XCycCuGRuEP+/r8GaS8LqSLNYs7K38rJsfjFwidTfVxBmAtNKItItwzJjupqjOqVDN2
         QCh1d4OZdZhBQohWzNjEzvM78pxJWjvXkNudNa+AL7SNZ6JCBrlQS0S5XR6dtl+mq9LO
         2oMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lrMO+X0pnVDmR5NsLnBgTuH6R3oc5OogPrLSBAvgVYA=;
        b=tHc4ij1+R6MCcg3hXtMmmMNBSUVVAecOlKASUODt/pp7mVamteaPHKa3zM5WVpRxTT
         olgiOpEmIx2wP4gosV69/7mVe/kkYoGXT9JOVG0cxqzYsUi9SEK/o8mNt3ry362ftR1h
         tUEgn3dwhLEWI4DB/x4gqhbXK3OFN78y9Q0dmbzcIwSb78IxXDbghG3UPVoV3vs1FvNl
         iSmaqc+yvEVN/ViaVOYkWtimMwoyEWEb8/B8+atKl5M2vxWTTCb28YxVLZhYRWS9B3Cm
         aOu9XdcBbaeS1w3yy4d3+IKfDkGVytcfAM88xh8QJ6IzyZ0//1eK2+BQlsMUZFv1BY3g
         v4hA==
X-Gm-Message-State: APjAAAUoaGGchoqtcKjg2hrULd0wPT5pnea1+fe+RZ3p+jwSI/3X7aeb
        W/Ctba4Wt5ry2OD+/fMHAtLs4nZg
X-Google-Smtp-Source: APXvYqz+u7ezjXUx+aEX3sJNl2699VRpcPoZwEk931urL11UuCFGY7j+OOup/ddgMQWOgDPNkU3h4g==
X-Received: by 2002:a7b:cc97:: with SMTP id p23mr6642290wma.89.1576713499728;
        Wed, 18 Dec 2019 15:58:19 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x11sm4240731wmg.46.2019.12.18.15.58.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 18 Dec 2019 15:58:19 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 01/10] lpfc: Fix incomplete NVME discovery when target
Date:   Wed, 18 Dec 2019 15:57:59 -0800
Message-Id: <20191218235808.31922-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191218235808.31922-1-jsmart2021@gmail.com>
References: <20191218235808.31922-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

NVMe device re-discovery does not complete. Dev_loss_tmo messages seen
on initiator after recovery from a link disturbance.

The Failing case is the following:
When the driver (as a NVME target) receives a PLOGI, the driver
initiates an "unreg rpi" mailbox command. While the mailbox command
is in progress, the driver requests that an ACC be sent to the
initiator. The target's ACC is received by the initiator and the
initiator then transmits a PLOGI. The driver receives the PLOGI prior
to receiving the completion for the PLOGI response WQE that sent the
ACC. (Different delivery sources from the hw so the race is very
possible). Given the PLOGI is prior to the ACC completion (signifying
PLOGI exchange complete), the driver LS_RJT's the PRLI. The "unreg
rpi" mailbox then completes. Since PRLI has been received, the driver
transmits a PLOGI to restart discovery, which the initiator then ACC's.
If the driver processes the (re)PLOGI ACC prior to the completing the
handling for the earlier ACC it sent the intiators original PLOGI,
there is no state change for completion of the (re)PLOGI. The ndlp
remains in "PLOGI Sent" and the initiator continues sending PRLI's
which are rejected by the target until timeout or retry is reached.

Fix by: when in target mode, defer sending an ACC for the received
PLOGI until unreg RPI completes.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 108 +++++++++++++++++++++++++++++++++----
 1 file changed, 99 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index ae4359013846..1c46e3adbda2 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -308,7 +308,7 @@ lpfc_defer_pt2pt_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *link_mbox)
 				mb->mbxStatus);
 		mempool_free(login_mbox, phba->mbox_mem_pool);
 		mempool_free(link_mbox, phba->mbox_mem_pool);
-		lpfc_sli_release_iocbq(phba, save_iocb);
+		kfree(save_iocb);
 		return;
 	}
 
@@ -325,7 +325,61 @@ lpfc_defer_pt2pt_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *link_mbox)
 	}
 
 	mempool_free(link_mbox, phba->mbox_mem_pool);
-	lpfc_sli_release_iocbq(phba, save_iocb);
+	kfree(save_iocb);
+}
+
+/**
+ * lpfc_defer_tgt_acc - Progress SLI4 target rcv PLOGI handler
+ * @phba: Pointer to HBA context object.
+ * @pmb: Pointer to mailbox object.
+ *
+ * This function provides the unreg rpi mailbox completion handler for a tgt.
+ * The routine frees the memory resources associated with the completed
+ * mailbox command and transmits the ELS ACC.
+ *
+ * This routine is only called if we are SLI4, acting in target
+ * mode and the remote NPort issues the PLOGI after link up.
+ **/
+void
+lpfc_defer_acc_rsp(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
+{
+	struct lpfc_vport *vport = pmb->vport;
+	struct lpfc_nodelist *ndlp = pmb->ctx_ndlp;
+	LPFC_MBOXQ_t *mbox = pmb->context3;
+	struct lpfc_iocbq *piocb = NULL;
+	int rc;
+
+	if (mbox) {
+		pmb->context3 = NULL;
+		piocb = mbox->context3;
+		mbox->context3 = NULL;
+	}
+
+	/*
+	 * Complete the unreg rpi mbx request, and update flags.
+	 * This will also restart any deferred events.
+	 */
+	lpfc_nlp_get(ndlp);
+	lpfc_sli4_unreg_rpi_cmpl_clr(phba, pmb);
+
+	if (!piocb) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY | LOG_ELS,
+				 "4578 PLOGI ACC fail\n");
+		if (mbox)
+			mempool_free(mbox, phba->mbox_mem_pool);
+		goto out;
+	}
+
+	rc = lpfc_els_rsp_acc(vport, ELS_CMD_PLOGI, piocb, ndlp, mbox);
+	if (rc) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY | LOG_ELS,
+				 "4579 PLOGI ACC fail %x\n", rc);
+		if (mbox)
+			mempool_free(mbox, phba->mbox_mem_pool);
+	}
+	kfree(piocb);
+out:
+	lpfc_nlp_put(ndlp);
 }
 
 static int
@@ -345,6 +399,7 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	struct lpfc_iocbq *save_iocb;
 	struct ls_rjt stat;
 	uint32_t vid, flag;
+	u16 rpi;
 	int rc, defer_acc;
 
 	memset(&stat, 0, sizeof (struct ls_rjt));
@@ -488,7 +543,7 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			link_mbox->vport = vport;
 			link_mbox->ctx_ndlp = ndlp;
 
-			save_iocb = lpfc_sli_get_iocbq(phba);
+			save_iocb = kzalloc(sizeof(*save_iocb), GFP_KERNEL);
 			if (!save_iocb)
 				goto out;
 			/* Save info from cmd IOCB used in rsp */
@@ -513,7 +568,36 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		goto out;
 
 	/* Registering an existing RPI behaves differently for SLI3 vs SLI4 */
-	if (phba->sli_rev == LPFC_SLI_REV4)
+	if (phba->nvmet_support && !defer_acc) {
+		link_mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+		if (!link_mbox)
+			goto out;
+
+		/* As unique identifiers such as iotag would be overwritten
+		 * with those from the cmdiocb, allocate separate temporary
+		 * storage for the copy.
+		 */
+		save_iocb = kzalloc(sizeof(*save_iocb), GFP_KERNEL);
+		if (!save_iocb)
+			goto out;
+
+		/* Unreg RPI is required for SLI4. */
+		rpi = phba->sli4_hba.rpi_ids[ndlp->nlp_rpi];
+		lpfc_unreg_login(phba, vport->vpi, rpi, link_mbox);
+		link_mbox->vport = vport;
+		link_mbox->ctx_ndlp = ndlp;
+		link_mbox->mbox_cmpl = lpfc_defer_acc_rsp;
+
+		if (((ndlp->nlp_DID & Fabric_DID_MASK) != Fabric_DID_MASK) &&
+		    (!(vport->fc_flag & FC_OFFLINE_MODE)))
+			ndlp->nlp_flag |= NLP_UNREG_INP;
+
+		/* Save info from cmd IOCB used in rsp */
+		memcpy(save_iocb, cmdiocb, sizeof(*save_iocb));
+
+		/* Delay sending ACC till unreg RPI completes. */
+		defer_acc = 1;
+	} else if (phba->sli_rev == LPFC_SLI_REV4)
 		lpfc_unreg_rpi(vport, ndlp);
 
 	rc = lpfc_reg_rpi(phba, vport->vpi, icmd->un.rcvels.remoteID,
@@ -553,6 +637,9 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	if ((vport->port_type == LPFC_NPIV_PORT &&
 	     vport->cfg_restrict_login)) {
 
+		/* no deferred ACC */
+		kfree(save_iocb);
+
 		/* In order to preserve RPIs, we want to cleanup
 		 * the default RPI the firmware created to rcv
 		 * this ELS request. The only way to do this is
@@ -571,8 +658,12 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	}
 	if (defer_acc) {
 		/* So the order here should be:
-		 * Issue CONFIG_LINK mbox
-		 * CONFIG_LINK cmpl
+		 * SLI3 pt2pt
+		 *   Issue CONFIG_LINK mbox
+		 *   CONFIG_LINK cmpl
+		 * SLI4 tgt
+		 *   Issue UNREG RPI mbx
+		 *   UNREG RPI cmpl
 		 * Issue PLOGI ACC
 		 * PLOGI ACC cmpl
 		 * Issue REG_LOGIN mbox
@@ -596,10 +687,9 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 out:
 	if (defer_acc)
 		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
-				"4577 pt2pt discovery failure: %p %p %p\n",
+				"4577 discovery failure: %p %p %p\n",
 				save_iocb, link_mbox, login_mbox);
-	if (save_iocb)
-		lpfc_sli_release_iocbq(phba, save_iocb);
+	kfree(save_iocb);
 	if (link_mbox)
 		mempool_free(link_mbox, phba->mbox_mem_pool);
 	if (login_mbox)
-- 
2.13.7

