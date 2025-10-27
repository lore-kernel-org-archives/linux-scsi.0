Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AA932F742
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 23:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761607460; cv=none; b=qrJxYj1KbJY5t6gsuZEo7sHqTzsiTSPKjjjgIjGIOv31+6bJJM6Zc3il5it1xbfRGxqFrF+720nkRd42IF7aWnvTCb9NKA197b1LOhRW4s+T1bxrPMEkDCU0kLtDyv7Ogj0QbWDoFtbLAXdupFyJ0EG303dAFBC3AlMi1bYYAU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761607460; c=relaxed/simple;
	bh=nUiE7RFtkGVntDN15qB25zR3dKB00X7Pe/mlA+Waub0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gefgJOmzdQ4aghdY6iETB+GwzgyFmISomPHzMqve27Qr3JfVnuIK6qGYS1OnH0ebWpc1OVuC5rT0QzgUFfhGqVs+bgl6ShFUf8UUqP8YT+TrMUxM+3yM7p9bzKF8zrrQH+u2Cx2fDie8GBLt+KUISa81187gt/ggpXCQPL84AOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iWKfyAI7; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iWKfyAI7"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2698384978dso34595175ad.0
        for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 16:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761607458; x=1762212258; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UeClSh3kZWYi8xAwR7JirN2pPzvjSDlG5n7mQ/Xc4bM=;
        b=iWKfyAI730LAB8TDplRppHpE20ZmQw2w2+fEIsWaiQRIGLCdUotMKrmNnpUei/QW+O
         zvmU/tojVlPJnoSQnYWz8N2ixb9nysi5kLoPT+vTvEhu6/4+v8D2MJUOhR96hhKga9md
         ML7LNUFu0xZa8jKLkltxz/ElN3FgXCBKU9663/uSJ4Fu/Oreop0wtWeNu03axAIpxZ9O
         QnEFTSOBeJkhnvNl81zCm5EXzluUU72RkM8dF/DUXUKneHA5Oo8rcx2PDQIRU4EpHlvT
         Ymx66W8fAwW0uo2JM2svCrScZJo44ssijDXXxvNRCg37Sfbe9Yo6vLm+enbZRncxiuQ3
         ofwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761607458; x=1762212258;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UeClSh3kZWYi8xAwR7JirN2pPzvjSDlG5n7mQ/Xc4bM=;
        b=A8d2oM+5n4ogG4M7z7rb46mKoRh3fIZJu96gSvyNdOqttOXPFuDfzAnFjTV0OjaE1p
         hua6b+oml+NaM7SSzjq34MVKmuGrQ6NCBp5E0bp6DRXELAHFhufcHxEJ//nC2bcl28hd
         5Yuqu1btTlgskmyUKQlWo/9P5kYfwmWqA7LT6PqRfXAELboZyie9pj+zTyAjMOSuTU63
         9rI58Lp4rGWJ6lX4FA38hE2XZU8huxRPKWpmITChdQhHGcy1kiFwdk99aJCvHaZxp/7L
         pasYn0GmyOIAAR/yJaynFbl52LRJYPCJfD8PyHcAR0U5L1qZAgZq9PbcqyQ8ElUGGNE3
         lzzA==
X-Gm-Message-State: AOJu0YxXc+AMRHLdMUrX6o+aAtd26CuSziPmyjR9B1v7hFnbjFPrTnvB
	7kDxvi3mYC9tGXebmAtAve8HRJluoJYRxRaamycBnoWzhBDBfu2TUXuBvmfslw==
X-Gm-Gg: ASbGnctTJTZw6/HwGtvv7HiObUSh9rsTKjQTrBo574ehwJ2y2lkMg2S2fNMgUT4Gs8c
	CcDsJYmBowsBF4Iey9RLGo4TQXYW37SPCVVJ5EQcapmTYE9LNngX7hIoYr1v4yv4/usxKN3G9uI
	xvafZs72Bi1vfOfTzM7q3sBzgBrtQyp4/MekK0QIEtHxbiNt1DJzKZ0NDICYjN7q1rxuNytLKkr
	3dy6O4K1s3S4Cu+pE9SGTLB15by+UJS2WgCD5K5lA89b6VnDHciwiwKoRMLU6ztUl1Bjn4BzfIF
	vEHLwwyPVh9LnZ0BpMcxHOLTzlwLG9hhOS+09ekZf9i6QeQxjUuPwbgniPCrJX+wkIdZjdAfb8P
	WG+xss+AgyIjCbhGX5pyOtJVzPwzrLhXeFunkGL5Ee5DxpcOD4dxNDr1Tu3IJvB9jOqFkOBo7Nu
	iW+o+ZFNXxN5uCd1GmCf1Ej3HMEri5RYnd5cH/WF8OrcCrVGF3gPhQmqIdskJT2DGRgtI4kR0=
X-Google-Smtp-Source: AGHT+IHzcnBTPB0PAXhu2RJ0Ta0t3PoXuf8DFz3VShKgOeDSLcstBDKMhzn3o0HoSuyh8C3rvejCKA==
X-Received: by 2002:a17:903:3845:b0:290:a3b9:d4c6 with SMTP id d9443c01a7336-294cb4f2e2emr18647275ad.36.1761607457599;
        Mon, 27 Oct 2025 16:24:17 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498e41159sm93805855ad.91.2025.10.27.16.24.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Oct 2025 16:24:17 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 05/11] lpfc: Fix leaked ndlp krefs when in point-to-point topology
Date: Mon, 27 Oct 2025 16:54:40 -0700
Message-Id: <20251027235446.77200-6-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20251027235446.77200-1-justintee8345@gmail.com>
References: <20251027235446.77200-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In point-to-point topology, the driver sometimes defers the unsolicited
FLOGI LS_ACC until it sends its FLOGI to the remote port.  When
this happens, lpfc neglects to release the ndlp allocated for
the unsolicited FLOGI.  This patch adds code to release the
ndlp for the deferred unsolicited FLOGI LS_ACC.

An NLP_FLOGI_DFR_ACC flag is introduced to facilitate identifying an ndlp
with an expected deferred FLOGI LS_ACC completion.  When lpfc_cmpl_els_rsp
detects the correct qualifiers, it releases the initial reference on the
ndlp object.  And when lpfc_cmpl_els_rsp exits, the remaining put for the
deferred action is executed and the ndlp is released.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h      |  1 -
 drivers/scsi/lpfc/lpfc_disc.h |  1 +
 drivers/scsi/lpfc/lpfc_els.c  | 65 +++++++++++++++++++++++++----------
 3 files changed, 48 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 224edacf2d8e..8459cf568c12 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -311,7 +311,6 @@ struct lpfc_defer_flogi_acc {
 	u16 rx_id;
 	u16 ox_id;
 	struct lpfc_nodelist *ndlp;
-
 };
 
 #define LPFC_VMID_TIMER   300	/* timer interval in seconds */
diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index 3d47dc7458d1..511aae481b77 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -208,6 +208,7 @@ enum lpfc_nlp_flag {
 					   NPR list */
 	NLP_RM_DFLT_RPI    = 26,        /* need to remove leftover dflt RPI */
 	NLP_NODEV_REMOVE   = 27,        /* Defer removal till discovery ends */
+	NLP_FLOGI_DFR_ACC  = 28,        /* FLOGI LS_ACC was Deferred */
 	NLP_SC_REQ         = 29,        /* Target requires authentication */
 	NLP_FIRSTBURST     = 30,        /* Target supports FirstBurst */
 	NLP_RPI_REGISTERED = 31         /* nlp_rpi is valid */
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 8552b24b45a1..b6ce7e0f8a9b 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1413,11 +1413,12 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 				phba->defer_flogi_acc.ox_id;
 		}
 
-		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
-				 "3354 Xmit deferred FLOGI ACC: rx_id: x%x,"
-				 " ox_id: x%x, hba_flag x%lx\n",
-				 phba->defer_flogi_acc.rx_id,
-				 phba->defer_flogi_acc.ox_id, phba->hba_flag);
+		/* The LS_ACC completion needs to drop the initial reference.
+		 * This is a special case for Pt2Pt because both FLOGIs need
+		 * to complete and lpfc defers the LS_ACC when the remote
+		 * FLOGI arrives before the driver's FLOGI.
+		 */
+		set_bit(NLP_FLOGI_DFR_ACC, &ndlp->nlp_flag);
 
 		/* Send deferred FLOGI ACC */
 		lpfc_els_rsp_acc(vport, ELS_CMD_FLOGI, &defer_flogi_acc,
@@ -1433,6 +1434,14 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			phba->defer_flogi_acc.ndlp = NULL;
 		}
 
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
+				 "3354 Xmit deferred FLOGI ACC: rx_id: x%x,"
+				 " ox_id: x%x, ndlp x%px hba_flag x%lx\n",
+				 phba->defer_flogi_acc.rx_id,
+				 phba->defer_flogi_acc.ox_id,
+				 phba->defer_flogi_acc.ndlp,
+				 phba->hba_flag);
+
 		vport->fc_myDID = did;
 	}
 
@@ -5302,11 +5311,12 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	IOCB_t  *irsp;
 	LPFC_MBOXQ_t *mbox = NULL;
 	u32 ulp_status, ulp_word4, tmo, did, iotag;
+	u32 cmd;
 
 	if (!vport) {
 		lpfc_printf_log(phba, KERN_WARNING, LOG_ELS,
 				"3177 null vport in ELS rsp\n");
-		goto out;
+		goto release;
 	}
 	if (cmdiocb->context_un.mbox)
 		mbox = cmdiocb->context_un.mbox;
@@ -5416,7 +5426,7 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	 * these conditions because it doesn't need the login.
 	 */
 	if (phba->sli_rev == LPFC_SLI_REV4 &&
-	    vport && vport->port_type == LPFC_NPIV_PORT &&
+	    vport->port_type == LPFC_NPIV_PORT &&
 	    !(ndlp->fc4_xpt_flags & SCSI_XPT_REGD)) {
 		if (ndlp->nlp_state != NLP_STE_PLOGI_ISSUE &&
 		    ndlp->nlp_state != NLP_STE_REG_LOGIN_ISSUE &&
@@ -5432,6 +5442,27 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		}
 	}
 
+	/* The driver's unsolicited deferred FLOGI ACC in Pt2Pt needs to
+	 * release the initial reference because the put after the free_iocb
+	 * call removes only the reference from the defer logic. This FLOGI
+	 * is never registered with the SCSI transport.
+	 */
+	if (test_bit(FC_PT2PT, &vport->fc_flag) &&
+	    test_and_clear_bit(NLP_FLOGI_DFR_ACC, &ndlp->nlp_flag)) {
+		lpfc_printf_vlog(vport, KERN_INFO,
+				 LOG_ELS | LOG_NODE | LOG_DISCOVERY,
+				 "3357 Pt2Pt Defer FLOGI ACC ndlp x%px, "
+				 "nflags x%lx, fc_flag x%lx\n",
+				 ndlp, ndlp->nlp_flag,
+				 vport->fc_flag);
+		cmd = *((u32 *)cmdiocb->cmd_dmabuf->virt);
+		if (cmd == ELS_CMD_ACC) {
+			if (!test_and_set_bit(NLP_DROPPED, &ndlp->nlp_flag))
+				lpfc_nlp_put(ndlp);
+		}
+	}
+
+release:
 	/* Release the originating I/O reference. */
 	lpfc_els_free_iocb(phba, cmdiocb);
 	lpfc_nlp_put(ndlp);
@@ -8399,13 +8430,6 @@ lpfc_els_rcv_flogi(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 						     &wqe->xmit_els_rsp.wqe_com);
 
 		vport->fc_myDID = did;
-
-		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
-				 "3344 Deferring FLOGI ACC: rx_id: x%x,"
-				 " ox_id: x%x, hba_flag x%lx\n",
-				 phba->defer_flogi_acc.rx_id,
-				 phba->defer_flogi_acc.ox_id, phba->hba_flag);
-
 		phba->defer_flogi_acc.flag = true;
 
 		/* This nlp_get is paired with nlp_puts that reset the
@@ -8414,6 +8438,14 @@ lpfc_els_rcv_flogi(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 		 * processed or cancelled.
 		 */
 		phba->defer_flogi_acc.ndlp = lpfc_nlp_get(ndlp);
+
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
+				 "3344 Deferring FLOGI ACC: rx_id: x%x,"
+				 " ox_id: x%x, ndlp x%px, hba_flag x%lx\n",
+				 phba->defer_flogi_acc.rx_id,
+				 phba->defer_flogi_acc.ox_id,
+				 phba->defer_flogi_acc.ndlp,
+				 phba->hba_flag);
 		return 0;
 	}
 
@@ -10354,11 +10386,8 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	 * Do not process any unsolicited ELS commands
 	 * if the ndlp is in DEV_LOSS
 	 */
-	if (test_bit(NLP_IN_DEV_LOSS, &ndlp->nlp_flag)) {
-		if (newnode)
-			lpfc_nlp_put(ndlp);
+	if (test_bit(NLP_IN_DEV_LOSS, &ndlp->nlp_flag))
 		goto dropit;
-	}
 
 	elsiocb->ndlp = lpfc_nlp_get(ndlp);
 	if (!elsiocb->ndlp)
-- 
2.38.0

