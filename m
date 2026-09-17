Received: from mail-pj2-f42.google.com (mail-pj2-f42.google.com [74.125.227.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E814B45198C
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 21:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789682266; cv=none; b=lclKHbmKYsvpBNVgblqUOxUdqi7fFtfwy+qQc3mS5TPhh+XMBykwgxhIB2xtQ30dmLHabaNABXJGADVZB//jw0WbUv+OFdyPVA5H4yvjF2HD3E3Qi/wRvS0zNW3guYVmnuwtBwYR6GF9P+ksd0wMG4Z9+omZTf8OAcfxpTOpmPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789682266; c=relaxed/simple;
	bh=Lhkr0ipgfeVtcoLymrSrVI3q0BWs78QU3VUDgIUMMbI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pO+1OJEa/+NZVFa8JHQ2AWFMYqXlQWXM7k6J8uH1u+TDoe3VaKUoEfMwNBZVbv9ozpZ6yeGpk7CA08VCopig43axwgayn0xpch3V3BmhF11+2AwLnV85r89Mm3vuNBnpXzBaGVSFcOylKkwwcJ8VczWVySyrTkmtCLXmRx/yNFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SlLZmVvt; arc=none smtp.client-ip=74.125.227.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SlLZmVvt"
Received: by mail-pj2-f42.google.com with SMTP id d9443c01a7336-2ddb44ad1c1so89235ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 14:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789682261; x=1790287061; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DE5xXbXnAOMCNqS0/QLMjurox9Z67Xc+vLOgjvIhkds=;
        b=SlLZmVvtm3tGs+pew4LI96i3uaXtm2NpF6GadM4z9t9LeXWm3lRNn5ZM31iYQbsWJ9
         jFaB/fhbH7YnFrv0A2uyigqyRCt4nPi+06KKd1PVGwaGIwY68bQvH6+nOpISjOO3pZK/
         miW20llacSTMGLGlUiDdzzi8KgIfJzGoUqm9aKUMW+juwQtNWikDqT9XvitSph838qkJ
         z/lmseqodCC6NY6EFgly790gxbwmC+Ub1J0Pi6ZANVmR2J+eBv2duw4Fp/CNBTUTj18T
         DwhmhliM4o5EpXn+kqkgdMaUT04kX7H8gjg7jDvyrlIL1Kea3z5V9Md1B5dwimxEDl/j
         exag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789682261; x=1790287061;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DE5xXbXnAOMCNqS0/QLMjurox9Z67Xc+vLOgjvIhkds=;
        b=Rj0Na8ioHX7Lnq8mPMKEijunGgn5S/jOguh3kcxTxocCU2HkK2TFujF+xWY/+xy9td
         Fc0vPBMk0TRekM3MsuKDaiHLll2H3GzhpyMClymsJIWGCt1+gF6UGG7suPQlanW7LB42
         1bZE+0jyDJBF0iGRhqABjCcXu/UR4lFwmgNiz1QwtUX1nEgOBCnqwY9j5Vg5UFae7A4y
         X6J+m92vZ20Y4zJ0PNSxgPYeZkO+DVjbAYgl+WnjnI5v5rAjhI/uGP18d+9kuJXoHIMn
         L5SDFeSJQtijylom9p2ERpmm2WjYfczo1ZVK07RseXgDhBP0KmBAUsY+Qs+50hjVl15J
         75OA==
X-Gm-Message-State: AFuF++l1HxY73pDvMJ6QtMEe1ieUIOqicUmYIK1YiP+B/fLfvRDP162X
	8H1mtKQZWeteitGd6aC/4jrf89IKWjie2Cs4iGrEaWFfyn3mr2Dg63Cd/MOZl9lC
X-Gm-Gg: AYBFou3gfUUsArRsydTQ36AEwXrbNEdIBZIo0tPv584r+xAcXLnQkRNOzhdgaYr+A6S
	MSKvGlWiYmW1/f8ScTjPWpmNtAV2FaJwOYl4ok1J9EuJrzjmJRcxnRxhg9ssQMV1BjYCpxqFQQN
	Epn0ZC1YQZ2fufA4uZqzOu85d+aZ7vY6951R9+z5uJEORH5Uw6Y05ts8bO1v1k3jvHjWvbx9gQU
	epk2vIZL718iteSvGX6C4ywMYO6cKzGznLJKlLIEQZ5SNXtMjNUWN++FDdc0b7Qf8FP+A4qufrJ
	6goQOJYWNXbQlkJxHi5WmPRNoY1DNDXzL7XKdHNARP1MUcW4lceUSCWOQuOR6LyW7acwFUajLtX
	LHL5RU8AZDy1gKqT2gAAcLAU5AZ9pfZnq+uC3hE75SEycPsuKBvg2pnFwovi3j7k38FeFV96MFG
	4RsLAGdrn3Wx7XBA88nWgEQTlgqTwl8qvDjuwVec67zvQakY6JS1HlwbgsLumw9j/Sqh+PsigWZ
	k+EoTLQhmjNlQ+I9zsV7wxEXtrTUmW9qhxddBSTxDuW3ZWaaoMdcXODGnk=
X-Received: by 2002:a17:902:c945:b0:2db:8c12:6b03 with SMTP id d9443c01a7336-2ddb1ac976emr9056285ad.8.1789682261407;
        Thu, 17 Sep 2026 14:57:41 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bfb19f8cesm24166254eec.2.2026.09.17.14.57.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2026 14:57:40 -0700 (PDT)
From: Nigel Kirkland <nkirkland2304@gmail.com>
To: linux-scsi@vger.kernel.org,
	nigel.kirkland@broadcom.com
Cc: paul.ely@broadcom.com,
	nkirkland2304@gmail.com
Subject: [PATCH v4 09/14] lpfc: Send inhibited ABORT_WQE when PLOGI CQE SEQUENCE_TMO is received
Date: Thu, 17 Sep 2026 15:20:10 -0700
Message-Id: <20260917222015.61053-10-nkirkland2304@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260917222015.61053-1-nkirkland2304@gmail.com>
References: <20260917222015.61053-1-nkirkland2304@gmail.com>
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

Signed-off-by: Nigel Kirkland <nkirkland2304@gmail.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c       |  5 ++--
 drivers/scsi/lpfc/lpfc_crtn.h      |  5 ++--
 drivers/scsi/lpfc/lpfc_els.c       | 48 ++++++++++++++++++++++++++----
 drivers/scsi/lpfc/lpfc_hbadisc.c   |  3 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c |  3 +-
 drivers/scsi/lpfc/lpfc_nvme.c      |  2 +-
 drivers/scsi/lpfc/lpfc_scsi.c      |  2 +-
 drivers/scsi/lpfc/lpfc_sli.c       | 28 ++++++++++-------
 8 files changed, 72 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 7354ae9ba8e5..63b6839230df 100644
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
@@ -5855,7 +5855,8 @@ lpfc_bsg_timeout(struct bsg_job *job)
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
index 3e26654a8286..7309fb948bea 100644
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
@@ -4813,6 +4815,7 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	union lpfc_wqe128 *irsp = &rspiocb->wqe;
 	struct lpfc_nodelist *ndlp = cmdiocb->ndlp;
 	struct lpfc_dmabuf *pcmd = cmdiocb->cmd_dmabuf;
+	struct lpfc_sli_ring *pring;
 	uint32_t *elscmd;
 	struct ls_rjt stat;
 	int retry = 0, maxretry = lpfc_max_els_tries, delay = 0;
@@ -4820,6 +4823,7 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	uint32_t cmd = 0;
 	uint32_t did;
 	int link_reset = 0, rc;
+	unsigned long iflags;
 	u32 ulp_status = get_job_ulpstatus(phba, rspiocb);
 	u32 ulp_word4 = get_job_word4(phba, rspiocb);
 	u8 rsn_code_exp = 0;
@@ -4921,7 +4925,38 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
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
@@ -9791,7 +9826,7 @@ lpfc_els_timeout_handler(struct lpfc_vport *vport)
 
 		spin_lock_irq(&phba->hbalock);
 		list_del_init(&piocb->dlist);
-		lpfc_sli_issue_abort_iotag(phba, pring, piocb, NULL);
+		lpfc_sli_issue_abort_iotag(phba, pring, piocb, false, NULL);
 		spin_unlock_irq(&phba->hbalock);
 	}
 
@@ -9909,7 +9944,8 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 		if (mbx_tmo_err || !(phba->sli.sli_flag & LPFC_SLI_ACTIVE))
 			list_move_tail(&piocb->list, &cancel_list);
 		else
-			lpfc_sli_issue_abort_iotag(phba, pring, piocb, NULL);
+			lpfc_sli_issue_abort_iotag(phba, pring, piocb, false,
+						   NULL);
 
 		spin_unlock_irqrestore(&phba->hbalock, iflags);
 	}
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index b4a5c7d5c2a0..c100c8c50682 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -6009,7 +6009,8 @@ lpfc_free_tx(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 
 		if (ulp_command == CMD_ELS_REQUEST64_CR ||
 		    ulp_command == CMD_XMIT_ELS_RSP64_CX) {
-			lpfc_sli_issue_abort_iotag(phba, pring, iocb, NULL);
+			lpfc_sli_issue_abort_iotag(phba, pring, iocb, false,
+						   NULL);
 		}
 	}
 	spin_unlock_irq(&phba->hbalock);
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index b0af279480fb..27a891f7fcf4 100644
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
index 50616b05488a..58d08476e586 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5603,7 +5603,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 						      lpfc_sli_abort_fcp_cmpl);
 	} else {
 		pring = &phba->sli.sli3_ring[LPFC_FCP_RING];
-		ret_val = lpfc_sli_issue_abort_iotag(phba, pring, iocb,
+		ret_val = lpfc_sli_issue_abort_iotag(phba, pring, iocb, false,
 						     lpfc_sli_abort_fcp_cmpl);
 	}
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index dab5411f876d..10d9030a1e88 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4598,6 +4598,7 @@ lpfc_sli_abort_iocb_ring(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 	spinlock_t *plock;		/* for transmit queue access */
 	struct lpfc_iocbq *iocb, *next_iocb;
 	int offline;
+	unsigned long iflag;
 
 	if (phba->sli_rev >= LPFC_SLI_REV4)
 		plock = &pring->ring_lock;
@@ -4610,7 +4611,7 @@ lpfc_sli_abort_iocb_ring(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 	offline = pci_channel_offline(phba->pcidev);
 
 	/* Cancel everything on txq */
-	spin_lock_irq(plock);
+	spin_lock_irqsave(plock, iflag);
 	list_splice_init(&pring->txq, &tx_completions);
 	pring->txq_cnt = 0;
 
@@ -4620,12 +4621,19 @@ lpfc_sli_abort_iocb_ring(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 			iocb->cmd_flag &= ~LPFC_IO_ON_TXCMPLQ;
 		list_splice_init(&pring->txcmplq, &tx_completions);
 		pring->txcmplq_cnt = 0;
+		spin_unlock_irqrestore(plock, iflag);
 	} else {
+		/* lpfc_sli_issue_abort_iotag expects the hba_lock held, but not
+		 * the ring_lock.
+		 */
+		spin_unlock_irqrestore(plock, iflag);
+		spin_lock_irqsave(&phba->hbalock, iflag);
 		/* Issue ABTS for everything on the txcmplq */
 		list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list)
-			lpfc_sli_issue_abort_iotag(phba, pring, iocb, NULL);
+			lpfc_sli_issue_abort_iotag(phba, pring, iocb, false,
+						   NULL);
+		spin_unlock_irqrestore(&phba->hbalock, iflag);
 	}
-	spin_unlock_irq(plock);
 
 	if (!offline)
 		lpfc_issue_hb_tmo(phba);
@@ -12017,7 +12025,7 @@ lpfc_sli_host_down(struct lpfc_vport *vport)
 				if (iocb->vport != vport)
 					continue;
 				lpfc_sli_issue_abort_iotag(phba, pring, iocb,
-							   NULL);
+							   false, NULL);
 			}
 			pring->flag = prev_pring_flag;
 		}
@@ -12045,7 +12053,7 @@ lpfc_sli_host_down(struct lpfc_vport *vport)
 				if (iocb->vport != vport)
 					continue;
 				lpfc_sli_issue_abort_iotag(phba, pring, iocb,
-							   NULL);
+							   false, NULL);
 			}
 			pring->flag = prev_pring_flag;
 		}
@@ -12462,6 +12470,7 @@ lpfc_ignore_els_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @cmdiocb: Pointer to driver command iocb object.
+ * @ia: Flag to explicitly or implicitly inhibit abort.
  * @cmpl: completion function.
  *
  * This function issues an abort iocb for the provided command iocb. In case
@@ -12474,7 +12483,7 @@ lpfc_ignore_els_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
  **/
 int
 lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
-			   struct lpfc_iocbq *cmdiocb, void *cmpl)
+			   struct lpfc_iocbq *cmdiocb, bool ia, void *cmpl)
 {
 	struct lpfc_vport *vport = cmdiocb->vport;
 	struct lpfc_iocbq *abtsiocbp;
@@ -12483,7 +12492,6 @@ lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	struct lpfc_nodelist *ndlp = NULL;
 	u32 ulp_command = get_job_cmnd(phba, cmdiocb);
 	u16 ulp_context, iotag;
-	bool ia;
 
 	/*
 	 * There are certain command types we don't want to abort.  And we
@@ -12533,7 +12541,7 @@ lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	}
 
 	/* Just close the exchange under certain conditions. */
-	if (test_bit(FC_UNLOADING, &vport->load_flag) ||
+	if (ia || test_bit(FC_UNLOADING, &vport->load_flag) ||
 	    phba->link_state < LPFC_LINK_UP ||
 	    (phba->sli_rev == LPFC_SLI_REV4 &&
 	     phba->sli4_hba.link_state.status == LPFC_FC_LA_TYPE_LINK_DOWN) ||
@@ -12576,7 +12584,7 @@ lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 
 abort_iotag_exit:
 
-	lpfc_printf_vlog(vport, KERN_INFO, LOG_SLI,
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS | LOG_SLI,
 			 "0339 Abort IO XRI x%x, Original iotag x%x, "
 			 "abort tag x%x Cmdjob : x%px Abortjob : x%px "
 			 "retval x%x : IA %d cmd_cmpl %ps\n",
@@ -12870,7 +12878,7 @@ lpfc_sli_abort_iocb(struct lpfc_vport *vport, u16 tgt_id, u64 lun_id,
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

