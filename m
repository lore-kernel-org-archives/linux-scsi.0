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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD55C32753
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69FC620866
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HCv/hwHM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729362AbfHNX5k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:40 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41288 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729297AbfHNX5i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:38 -0400
Received: by mail-pf1-f194.google.com with SMTP id 196so329353pfz.8
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+7UHFqd2L0PrVtLEMrG6E04WzCjKj5Eg5RhplSzKcSU=;
        b=HCv/hwHMjyga4uH7aOj5MrmaVvGdN0rTha/RVLzM5Wpy+yCvyPweFBujrnh9X1YcqS
         0RV9m0Xva2XXAcJsM6Ky3N/d6i+j2LIKBi0Qwi5DWzXBhvSriGbrkD0jtuuEDzLNmNNK
         NhOZ8B6aoWzx9/KGQHXtpcE3SFK2fAFjYYnMKFxvYS13C5SZUXH8GwM/kuWOBrVmIUyh
         YfYTVpBS1E+2b9VrVGy9Y6Y9JtOIR96SJo5v7DfPvG0ob9PylwCl27K0yvJDpYxNaYwI
         p2GGMs1HiuSR8U/xV4REb4VFis13xA/agS72XKjlAHkSvKUWZkpplGQaTpICsWsWZmOb
         i6ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+7UHFqd2L0PrVtLEMrG6E04WzCjKj5Eg5RhplSzKcSU=;
        b=B9cn0a/RAMzxBw3t1K+dZymVkMlAAtVIb67y4k1sIwBYQvuEluY2/dh/4JvHkziOaP
         osYCh8Ax8ZlGnxTBp9KatB/WKD76q0UY4U/1s4NuzzEu/9MpRPq42cElIgfqnAyAYjC2
         bslQjq3y28y+ZaDcmvsonkCDm42YEhkIeEfkyIe3A7WIZLIuRfm/kaVWqqzcvVUAJUVf
         wMA6HcbFJaA+h3bvU+DuxaiajAFgSik9Y6TArneCAIehK0gBWRZYPRsathXmopvgRoNL
         Wtb+4dlLdE6p6e3pTY3nQoXBELx5fyKpNLOV0aBWxapjEc/klg+5t8yJMx9LZXrpwtwi
         KGrQ==
X-Gm-Message-State: APjAAAUoQxmMaveJi2+3gM3jeKPpaMG+FdF9vbCcHlv4/0BNbSRVyBdC
        EtJVsSoWLs8SRC39SGSI4it4LVZg
X-Google-Smtp-Source: APXvYqwkeXVLGYAAMuSxAlvZueOpYYAPd+TdPxms8h7ejpc79ElCCbSCW9ISWQPsTPddBglmxZucng==
X-Received: by 2002:a63:5648:: with SMTP id g8mr1339151pgm.81.1565827058047;
        Wed, 14 Aug 2019 16:57:38 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:37 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 20/42] lpfc: Fix driver nvme rescan logging
Date:   Wed, 14 Aug 2019 16:56:50 -0700
Message-Id: <20190814235712.4487-21-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In situations where zoning is not being used, thus NVMe initiators
see other NVMe initiators as well as NVMe targets, a link bounce
on an initiator will cause the NVMe initiators to spew "6169" State
Error messages.

The driver is not qualifying whether the remote port is a NVMe
targer or not before calling the lpfc_nvme_rescan_port(), which
validates the role and prints the message if its only an NVMe
initiator.

Fix by the following:
- before calling lpfc_nvme_rescan_port() ensure that the node is a
  NVMe storage target or a NVMe discovery controller.
- Clean up implementation of lpfc_nvme_rescan_port. remoteport pointer
  will always be NULL if a NVMe initiator only. But, grabbing of
  remoteport pointer should be done under lock to coincide with
  the registering of the remote port with the fc transport.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c  | 12 ++++++++++--
 drivers/scsi/lpfc/lpfc_nvme.c | 31 +++++++++++++++++--------------
 2 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 8103635adc38..d919f3161160 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -6360,7 +6360,11 @@ lpfc_rscn_recovery_check(struct lpfc_vport *vport)
 			continue;
 		}
 
-		if (ndlp->nlp_fc4_type & NLP_FC4_NVME)
+		/* Check to see if we need to NVME rescan this target
+		 * remoteport.
+		 */
+		if (ndlp->nlp_fc4_type & NLP_FC4_NVME &&
+		    ndlp->nlp_type & (NLP_NVME_TARGET | NLP_NVME_DISCOVERY))
 			lpfc_nvme_rescan_port(vport, ndlp);
 
 		lpfc_disc_state_machine(vport, ndlp, NULL,
@@ -6474,7 +6478,11 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 				 *lp, vport->fc_flag, payload_len);
 		lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
 
-		if (ndlp->nlp_fc4_type & NLP_FC4_NVME)
+		/* Check to see if we need to NVME rescan this target
+		 * remoteport.
+		 */
+		if (ndlp->nlp_fc4_type & NLP_FC4_NVME &&
+		    ndlp->nlp_type & (NLP_NVME_TARGET | NLP_NVME_DISCOVERY))
 			lpfc_nvme_rescan_port(vport, ndlp);
 		return 0;
 	}
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 9746808cf94f..e8924e90c4eb 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2426,20 +2426,23 @@ void
 lpfc_nvme_rescan_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 {
 #if (IS_ENABLED(CONFIG_NVME_FC))
-	struct lpfc_nvme_rport *rport;
-	struct nvme_fc_remote_port *remoteport;
+	struct lpfc_nvme_rport *nrport;
+	struct nvme_fc_remote_port *remoteport = NULL;
 
-	rport = ndlp->nrport;
+	spin_lock_irq(&vport->phba->hbalock);
+	nrport = lpfc_ndlp_get_nrport(ndlp);
+	if (nrport)
+		remoteport = nrport->remoteport;
+	spin_unlock_irq(&vport->phba->hbalock);
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_DISC,
 			 "6170 Rescan NPort DID x%06x type x%x "
-			 "state x%x rport %p\n",
-			 ndlp->nlp_DID, ndlp->nlp_type, ndlp->nlp_state, rport);
-	if (!rport)
-		goto input_err;
-	remoteport = rport->remoteport;
-	if (!remoteport)
-		goto input_err;
+			 "state x%x nrport x%px remoteport x%px\n",
+			 ndlp->nlp_DID, ndlp->nlp_type, ndlp->nlp_state,
+			 nrport, remoteport);
+
+	if (!nrport || !remoteport)
+		goto rescan_exit;
 
 	/* Only rescan if we are an NVME target in the MAPPED state */
 	if (remoteport->port_role & FC_PORT_ROLE_NVME_DISCOVERY &&
@@ -2452,10 +2455,10 @@ lpfc_nvme_rescan_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 				 ndlp->nlp_DID, remoteport->port_state);
 	}
 	return;
-input_err:
-	lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_DISC,
-			 "6169 State error: lport %p, rport%p FCID x%06x\n",
-			 vport->localport, ndlp->rport, ndlp->nlp_DID);
+ rescan_exit:
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_DISC,
+			 "6169 Skip NVME Rport Rescan, NVME remoteport "
+			 "unregistered\n");
 #endif
 }
 
-- 
2.13.7

