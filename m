Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1918116DC28
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 00:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783989475; cv=none; b=FqfOZ6NiGbWZy9RL9k2SJYrYEW6dq3D+TVpzykUmpMYgTWy/G9qrr71y5s+BLG10/nOFcouqUl/aiYjKrszHvoihogQcf4vqcH919g3rg46UVbnWtVS0wDXx2y3MVl1f//o6vk+1SHffzqVEaVj1VESBSIl/aXW/wBMs4ihl4+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783989475; c=relaxed/simple;
	bh=q0+8YHlx1gmvq5HcrXIhCjJqaBHEwmV6akU73pqeJiw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZvM3SYZvY9m0JrOrYOUxpJsBUopceVKy5Yjfb8KMJIWFf27aUfTyJXwWhBa2D/2/g46PJFCKcdo1oSVzEqzDSG1b2NdlUpJtttqrqF7qf+jcwGK6xoY2TUMWBGmxX4aMYB3VBqPMJObQ/ahGGPEIokNeHvs4V74c0pgPdGwgxLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HW2oQN3O; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HW2oQN3O"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-92eafc94c9cso262854085a.0
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2026 17:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783989473; x=1784594273; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=r1iNrDsYdbcMIC1Em2SIhXtTzBM0b9+uKHP/dYMjZSw=;
        b=HW2oQN3OFqC2sHGOaYsRmPpdJ6sl8HDWF99S9jbNuDYcx6BG/aXceyUaoyVRlUWB7I
         53uZFTiceUTty9oLBN5Q01LNxRLM8RMMkt5iAdszUoHD4tua1NTt8La6+NvAAvGIKTLR
         KwHiqOq1UDQ3i8mWCgl5fhaP2lU+fKdtQoKUgylL8LNaNnBomb6Mln+OC9wBoYI4/4Fp
         MOdkRnINWzSwcukTIgpkhbu527vbGq1ciF9QAAMpQhOrFVg30nidq6H8EAvAiult9U+p
         +76uRVjBSEZ2uujPpnpaQB3ShVJhmjo82R3XjECR2VQ5nA0B/znhKIOwZOAFEWPwWPlb
         KAKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783989473; x=1784594273;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r1iNrDsYdbcMIC1Em2SIhXtTzBM0b9+uKHP/dYMjZSw=;
        b=BLzXb5rZQ/fJDW1cDfdfoOWDIQ0YefdFT4ExueYgtqrJ7kaodaUo+p8m2a87sn4yk4
         P52+3RMgV25F3zlsQNuOjC67xbobekDjjVmoKXTprGLwEZ7mavzygruUUWEbgxMiV0/b
         adXxBd+oJomN4fUBAEIgPPrD+4nM+rjNv4nMXjzH7EiuYF2LpMr1NPBAtk6tL022ieQ7
         YaQXntyh21t/3n1GHC9LDQieYltGFDFLHEepOoUeDtvPUcbSgyxu5kqEWldkXc7soHnW
         jZ++vcflAEtPYhWLOs2NV64fKiLms08MZ49IAfYGt1amXRsOwi20T9P0GAlkwdviSVN2
         wGZw==
X-Gm-Message-State: AOJu0Yzt8Ge+K7HteOQAryADbWPs8VWmGJQSoXkPN3lvZlVjad4yMBK3
	IpfYAIhBo/nvNXroz0vgtIhwkGjtUjuh4u1VOE4x/x/eoJX/wuqseGZGHjH1bCnBWRg=
X-Gm-Gg: AfdE7ck2J3kSFSoljErPVkTUpGjdi+Vhkvs26pp9qZZJFdyRguDWJ33/Evj76QqQPxr
	rfJwUUCig8qHszJQ/njhaW+btRR4jFNVVdd8NWiyANnEc00w9/pHyKzceQwssYuu1nX1qUPeoa5
	e3hxZdWsTNtn/3nL9RMWd3xiaxagZU7TddQXW76Iv8tDapTBtAvem91y2yH5C4ttm3xGHHP7R6r
	pxRbe/3ZECeKMPfBGXF8WYrlMMbOiTzEL2phA3F5Nmbs3v43lwO+D88+5RYq7PdHC1lKdXTYiU5
	7zUtwIun5oyCeB/nLM0LghoYQ32OQTxgWlMdh54BUDG3L4xYjmAd7JzNI1Q8JnljusZSA/9x9vC
	ktKmBJXILElVdWqYiYTyD/j0lIaowS1xHh9XUYQT3rf3lpZZjQ063xceJWx03aHS6ZBVlFGnQO8
	QuCdv6O276V5+EAqz4V73K7USBN8JgOXOfl7K+Jzkm/yC+IW92dmegeZLaHppNahZ0qPgQQoP6a
	+64EbMn7B6bovq9XBrR7EqSh4cQHGYv
X-Received: by 2002:a05:620a:2b4a:b0:915:688b:aba with SMTP id af79cd13be357-93086a62b36mr32699685a.35.1783989473017;
        Mon, 13 Jul 2026 17:37:53 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d6c28bsm1289899185a.46.2026.07.13.17.37.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Jul 2026 17:37:52 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v3 09/14] lpfc: Send inhibited ABORT_WQE when PLOGI CQE SEQUENCE_TMO is received
Date: Mon, 13 Jul 2026 18:18:07 -0700
Message-Id: <20260714011812.106753-10-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260714011812.106753-1-justintee8345@gmail.com>
References: <20260714011812.106753-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

It is unlikely that an BA_ACC will be received for a sent ABTS knowing
that a previously sent PLOGI E_D_TOV timed out.

By sending an ABORT_WQE with IA=1, the XRI_ABORTED CQE for the PLOGI CQE
SEQUENCE_TIMEOUT with XB=1 will return immediately compared to waiting
E_D_TOV for a BA_ACC.

Add a new bool ia argument variable to lpfc_sli_issue_abort_iotag, to
explicitly set the IA bit when filling out ABORT_WQE.  When the ia argument
is false, we fall back to the old logic of implicitly setting the IA bit
under previous conditions.  Setting the ia argument to true, is currently
only used for PLOGI CQE LOCAL_REJECT/SEQUENCE_TIMEOUT.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c       |  5 ++--
 drivers/scsi/lpfc/lpfc_crtn.h      |  5 ++--
 drivers/scsi/lpfc/lpfc_els.c       | 48 ++++++++++++++++++++++++++----
 drivers/scsi/lpfc/lpfc_hbadisc.c   |  3 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c |  3 +-
 drivers/scsi/lpfc/lpfc_nvme.c      |  2 +-
 drivers/scsi/lpfc/lpfc_scsi.c      |  2 +-
 drivers/scsi/lpfc/lpfc_sli.c       | 17 ++++++-----
 8 files changed, 63 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index c95165905483..56f55f818cce 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2026 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2009-2015 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
@@ -5857,7 +5857,8 @@ lpfc_bsg_timeout(struct bsg_job *job)
 			}
 		}
 		if (list_empty(&completions))
-			lpfc_sli_issue_abort_iotag(phba, pring, cmdiocb, NULL);
+			lpfc_sli_issue_abort_iotag(phba, pring, cmdiocb, false,
+						   NULL);
 		spin_unlock_irqrestore(&phba->hbalock, flags);
 		if (!list_empty(&completions)) {
 			lpfc_sli_cancel_iocbs(phba, &completions,
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 8a5b76bdea06..2ca5f0229ca1 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -402,8 +402,9 @@ int lpfc_sli_hbq_count(void);
 int lpfc_sli_hbqbuf_add_hbqs(struct lpfc_hba *, uint32_t);
 void lpfc_sli_hbqbuf_free_all(struct lpfc_hba *);
 int lpfc_sli_hbq_size(void);
-int lpfc_sli_issue_abort_iotag(struct lpfc_hba *, struct lpfc_sli_ring *,
-			       struct lpfc_iocbq *, void *);
+int lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba,
+			       struct lpfc_sli_ring *pring,
+			       struct lpfc_iocbq *cmdiocb, bool ia, void *cmpl);
 int lpfc_sli_sum_iocb(struct lpfc_vport *, uint16_t, uint64_t, lpfc_ctx_cmd);
 int lpfc_sli_abort_iocb(struct lpfc_vport *vport, u16 tgt_id, u64 lun_id,
 			lpfc_ctx_cmd abort_cmd);
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 16b10377a095..11c36968a2be 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1556,7 +1556,7 @@ lpfc_els_abort_flogi(struct lpfc_hba *phba)
 					iocb->fabric_cmd_cmpl =
 						lpfc_ignore_els_cmpl;
 				lpfc_sli_issue_abort_iotag(phba, pring, iocb,
-							   NULL);
+							   false, NULL);
 			}
 		}
 	}
@@ -2129,7 +2129,7 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	struct lpfc_dmabuf *prsp;
 	bool disc;
 	struct serv_parm *sp = NULL;
-	u32 ulp_status, ulp_word4, did, iotag;
+	u32 ulp_status, ulp_word4, did, iotag, word3;
 	bool release_node = false;
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
@@ -2141,9 +2141,11 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	if (phba->sli_rev == LPFC_SLI_REV4) {
 		iotag = get_wqe_reqtag(cmdiocb);
+		word3 = rspiocb->wcqe_cmpl.word3;
 	} else {
 		irsp = &rspiocb->iocb;
 		iotag = irsp->ulpIoTag;
+		word3 = 0;
 	}
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
@@ -2169,10 +2171,10 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	/* PLOGI completes to NPort <nlp_DID> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0102 PLOGI completes to NPort x%06x "
-			 "IoTag x%x Data: x%x x%x x%x x%x x%x\n",
+			 "IoTag x%x Data: x%x x%x x%x x%x x%x x%x\n",
 			 ndlp->nlp_DID, iotag,
 			 ndlp->nlp_fc4_type,
-			 ulp_status, ulp_word4,
+			 ulp_status, ulp_word4, word3,
 			 disc, vport->num_disc_nodes);
 
 	/* Check to see if link went down during discovery */
@@ -4785,6 +4787,7 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	union lpfc_wqe128 *irsp = &rspiocb->wqe;
 	struct lpfc_nodelist *ndlp = cmdiocb->ndlp;
 	struct lpfc_dmabuf *pcmd = cmdiocb->cmd_dmabuf;
+	struct lpfc_sli_ring *pring;
 	uint32_t *elscmd;
 	struct ls_rjt stat;
 	int retry = 0, maxretry = lpfc_max_els_tries, delay = 0;
@@ -4792,6 +4795,7 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	uint32_t cmd = 0;
 	uint32_t did;
 	int link_reset = 0, rc;
+	unsigned long iflags;
 	u32 ulp_status = get_job_ulpstatus(phba, rspiocb);
 	u32 ulp_word4 = get_job_word4(phba, rspiocb);
 	u8 rsn_code_exp = 0;
@@ -4893,7 +4897,38 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				/* Reset the Link */
 				link_reset = 1;
 				break;
+			} else if (cmd == ELS_CMD_PLOGI) {
+
+				/* if invalid ndlp, do not retry */
+				if (unlikely(!ndlp)) {
+					retry = 0;
+					break;
+				}
+
+				lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
+						 "0159 PLOGI Sequence TMO for "
+						 "ndlp x%px x%lx x%x x%x x%x "
+						 "x%x x%x %u x%x\n",
+						 ndlp, ndlp->nlp_flag,
+						 ndlp->nlp_DID, ndlp->nlp_type,
+						 ndlp->nlp_fc4_type,
+						 ndlp->nlp_rpi, ndlp->nlp_state,
+						 kref_read(&ndlp->kref),
+						 ndlp->fc4_xpt_flags);
+
+				/* Abort all outstanding ELS and auto-ABTS.  If
+				 * no response for E_D_TOV, then it is unlikely
+				 * auto-ABTS would receive a response too.  So,
+				 * inhibit the abort for faster XRI release.
+				 * However, still proceed with delayed retry.
+				 */
+				pring = lpfc_phba_elsring(phba);
+				spin_lock_irqsave(&phba->hbalock, iflags);
+				lpfc_sli_issue_abort_iotag(phba, pring, cmdiocb,
+							   true, NULL);
+				spin_unlock_irqrestore(&phba->hbalock, iflags);
 			}
+
 			retry = 1;
 			delay = 100;
 			break;
@@ -9763,7 +9798,7 @@ lpfc_els_timeout_handler(struct lpfc_vport *vport)
 
 		spin_lock_irq(&phba->hbalock);
 		list_del_init(&piocb->dlist);
-		lpfc_sli_issue_abort_iotag(phba, pring, piocb, NULL);
+		lpfc_sli_issue_abort_iotag(phba, pring, piocb, false, NULL);
 		spin_unlock_irq(&phba->hbalock);
 	}
 
@@ -9881,7 +9916,8 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 		if (mbx_tmo_err || !(phba->sli.sli_flag & LPFC_SLI_ACTIVE))
 			list_move_tail(&piocb->list, &cancel_list);
 		else
-			lpfc_sli_issue_abort_iotag(phba, pring, piocb, NULL);
+			lpfc_sli_issue_abort_iotag(phba, pring, piocb, false,
+						   NULL);
 
 		spin_unlock_irqrestore(&phba->hbalock, iflags);
 	}
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 6337dae4f1cd..6669932e77c8 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5993,7 +5993,8 @@ lpfc_free_tx(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 
 		if (ulp_command == CMD_ELS_REQUEST64_CR ||
 		    ulp_command == CMD_XMIT_ELS_RSP64_CX) {
-			lpfc_sli_issue_abort_iotag(phba, pring, iocb, NULL);
+			lpfc_sli_issue_abort_iotag(phba, pring, iocb, false,
+						   NULL);
 		}
 	}
 	spin_unlock_irq(&phba->hbalock);
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 0270ab7e602f..e7ade735a97c 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -269,7 +269,8 @@ lpfc_els_abort(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 	list_for_each_entry_safe(iocb, next_iocb, &abort_list, dlist) {
 		spin_lock_irq(&phba->hbalock);
 		list_del_init(&iocb->dlist);
-		retval = lpfc_sli_issue_abort_iotag(phba, pring, iocb, NULL);
+		retval = lpfc_sli_issue_abort_iotag(phba, pring, iocb, false,
+						    NULL);
 		spin_unlock_irq(&phba->hbalock);
 
 		/* An abort that fails here is just cancelled when the driver is
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 71714ea390d9..45b5966d9e6b 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -743,7 +743,7 @@ __lpfc_nvme_ls_abort(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	spin_unlock(&pring->ring_lock);
 
 	if (foundit)
-		lpfc_sli_issue_abort_iotag(phba, pring, wqe, NULL);
+		lpfc_sli_issue_abort_iotag(phba, pring, wqe, false, NULL);
 	spin_unlock_irq(&phba->hbalock);
 
 	if (foundit)
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index f2cab134af7f..ce9d7de21590 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5622,7 +5622,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 						      lpfc_sli_abort_fcp_cmpl);
 	} else {
 		pring = &phba->sli.sli3_ring[LPFC_FCP_RING];
-		ret_val = lpfc_sli_issue_abort_iotag(phba, pring, iocb,
+		ret_val = lpfc_sli_issue_abort_iotag(phba, pring, iocb, false,
 						     lpfc_sli_abort_fcp_cmpl);
 	}
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 54bc5d8984fc..0a300efc9240 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4608,7 +4608,8 @@ lpfc_sli_abort_iocb_ring(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 	} else {
 		/* Issue ABTS for everything on the txcmplq */
 		list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list)
-			lpfc_sli_issue_abort_iotag(phba, pring, iocb, NULL);
+			lpfc_sli_issue_abort_iotag(phba, pring, iocb, false,
+						   NULL);
 	}
 	spin_unlock_irq(plock);
 
@@ -11998,7 +11999,7 @@ lpfc_sli_host_down(struct lpfc_vport *vport)
 				if (iocb->vport != vport)
 					continue;
 				lpfc_sli_issue_abort_iotag(phba, pring, iocb,
-							   NULL);
+							   false, NULL);
 			}
 			pring->flag = prev_pring_flag;
 		}
@@ -12026,7 +12027,7 @@ lpfc_sli_host_down(struct lpfc_vport *vport)
 				if (iocb->vport != vport)
 					continue;
 				lpfc_sli_issue_abort_iotag(phba, pring, iocb,
-							   NULL);
+							   false, NULL);
 			}
 			pring->flag = prev_pring_flag;
 		}
@@ -12443,6 +12444,7 @@ lpfc_ignore_els_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @cmdiocb: Pointer to driver command iocb object.
+ * @ia: Flag to explicitly or implicitly inhibit abort.
  * @cmpl: completion function.
  *
  * This function issues an abort iocb for the provided command iocb. In case
@@ -12455,7 +12457,7 @@ lpfc_ignore_els_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
  **/
 int
 lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
-			   struct lpfc_iocbq *cmdiocb, void *cmpl)
+			   struct lpfc_iocbq *cmdiocb, bool ia, void *cmpl)
 {
 	struct lpfc_vport *vport = cmdiocb->vport;
 	struct lpfc_iocbq *abtsiocbp;
@@ -12464,7 +12466,6 @@ lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	struct lpfc_nodelist *ndlp = NULL;
 	u32 ulp_command = get_job_cmnd(phba, cmdiocb);
 	u16 ulp_context, iotag;
-	bool ia;
 
 	/*
 	 * There are certain command types we don't want to abort.  And we
@@ -12514,7 +12515,7 @@ lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	}
 
 	/* Just close the exchange under certain conditions. */
-	if (test_bit(FC_UNLOADING, &vport->load_flag) ||
+	if (ia || test_bit(FC_UNLOADING, &vport->load_flag) ||
 	    phba->link_state < LPFC_LINK_UP ||
 	    (phba->sli_rev == LPFC_SLI_REV4 &&
 	     phba->sli4_hba.link_state.status == LPFC_FC_LA_TYPE_LINK_DOWN) ||
@@ -12557,7 +12558,7 @@ lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 
 abort_iotag_exit:
 
-	lpfc_printf_vlog(vport, KERN_INFO, LOG_SLI,
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS | LOG_SLI,
 			 "0339 Abort IO XRI x%x, Original iotag x%x, "
 			 "abort tag x%x Cmdjob : x%px Abortjob : x%px "
 			 "retval x%x : IA %d cmd_cmpl %ps\n",
@@ -12851,7 +12852,7 @@ lpfc_sli_abort_iocb(struct lpfc_vport *vport, u16 tgt_id, u64 lun_id,
 		} else if (phba->sli_rev == LPFC_SLI_REV4) {
 			pring = lpfc_sli4_calc_ring(phba, iocbq);
 		}
-		ret_val = lpfc_sli_issue_abort_iotag(phba, pring, iocbq,
+		ret_val = lpfc_sli_issue_abort_iotag(phba, pring, iocbq, false,
 						     lpfc_sli_abort_fcp_cmpl);
 		spin_unlock_irqrestore(&phba->hbalock, iflags);
 		if (ret_val != IOCB_SUCCESS)
-- 
2.38.0

