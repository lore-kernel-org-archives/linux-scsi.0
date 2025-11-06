Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3E5222594
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2025 22:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762467349; cv=none; b=Y15kBvbLswoVLRdDESM2o+tId6BST2OHeccgWcuE3mnFNAtLKKjNbs9teHjp0wCkERPNtAb3f74yp7r6jMf60pxHSRexF7ljwj6sax1v2RMYynKm3aEUHI/UZgfNFHiGYxdwK28yR27ubzLsjjt9Dm31kZGmF4V2EbmGrs0rNMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762467349; c=relaxed/simple;
	bh=d1itu0bs6JoVU+dz/eGbUqfFd43uG7Y6ldExprzjs8U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FSWsUMEeM3GLGs5Z8qBst4mJG3fbI6IOdfWjJ48RLIZJToVAlX4XR+p+DHGdSTZDWacD1GQKhOmaX+SnLikZXfHipDy9loRWCcH2FegqJVkaldHpUZFaf6FLEgWxPR75Ctm7+lrVnZRHpKE1yFit8+SZvAhtIt1fGWFWcN/+1kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PO8FKjpZ; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PO8FKjpZ"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7aab061e7cbso186349b3a.1
        for <linux-scsi@vger.kernel.org>; Thu, 06 Nov 2025 14:15:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762467347; x=1763072147; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OGhmkh6U7xJAVQi4Am2ZXFkV/cpQszf/uu5ndkAmW5U=;
        b=PO8FKjpZEZmxniHrtbBa250cjHWrnl2koKugK3qmeU79DS/OArPAkKAJoOoN70sONH
         fruHGENmtnwr5lUOFSOoX426mMwD/McYUDdMUHitFB6EgeNn4pE3S/dhSXeBOaCxLCny
         ognU7+I1X3zj1DsEDcOnI90pnnUvaxzytQ5jGfrzfmvNZ2ouWEfHtJWrjKwAcDbby6/l
         pvpoN0LgprkUnYwZQucyFeSuh63ntP+Yan8waROt6mxGasviGqlomySkWW9/z8pmq32D
         YG1CHPPMIwctNUEBVHJl8PlavIdcrNOqcABtXMZOmAQCDGRlOlrb+3koRKWOslKZRQ6a
         z7QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762467347; x=1763072147;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OGhmkh6U7xJAVQi4Am2ZXFkV/cpQszf/uu5ndkAmW5U=;
        b=VSQVVmIrD0HYz7F6oRY+jn7VF6gqkplgVvaR9V1r6EyBFZNqgCtertXObux54nVLR0
         dFhUh/Vf6aAH+zxI1mfXDwr9+XSqwBBe18RU9YAte/Y4hCJs1AqyfVMVidlXNkvcsfTX
         8jEDviNYug74z49Hl/cWFWSselbbyzIXvqFp8Jxtykp2+1wY5JPvPc1xct59vBpn4Yuy
         5j61la+MGQ8x1EDHMEx8GbGom0N5VrrVGuZXrZD+M8gIkSTOP02DJ2b5EWgV8zJjMXa6
         lW1HTsw8EUURxASYCLhRU9sFbz79BHI+6Da22aSM5qiIm/gA95ytTz+3camrPBp5JzNW
         /1zQ==
X-Gm-Message-State: AOJu0YwDu8dbCW92pJ6KtnNB8YGIv/NK0FQRrVdhwz1BuPktgMwcug7W
	Kgckkqlsfuu+PU/IxAsQllOmcDSiWXXw60ePyN5hEv8OfplBJ4qfjWWBT5HNAZap
X-Gm-Gg: ASbGncv2ZSeHBZ96HE43WAcSfiIaU/OZ1M/KS8GrQeqFZBeWUBnTzcF7yQdNK0GSBVw
	gKQZN5CbWg5BMjFe35qEswzhuFVJF0QNtWqwBMdxiczpjaJ0Cc6R9bCapj58//TRDY7vpyP4WMr
	Tf/5xnDqQoRkVDXj/5LU5rfnTTdrEuRFCpToy3wkXze5sR1hcmwicQe76R5YZWRG2dkTT7DReoH
	CaaS2orZ54JtBPVPkGi1BqIwKbZbX9hlfnBF/VlICfSfIo+RDzVlfU2KgVJpnt/CTpJpLjS2J8E
	HsgjNTP7Xwronw9AbZgbVXKfvUTBK8Glf+Ol78GwOENWjAR3ge62ltOunjjcP98L+d5H1M9AMYF
	0xgPKbb9oh3cj60M6mrdM2EUzW0lXZBjJ3AU5UEn42/DT64OqU4yW3T7598gdnFJ64bnGaHk8H/
	rk2qOD6tbkKRsevYfOgyJvFyLvQPqZLcqBJ6SLk+6NGI2ZeLY1ri1ruWQbo020onUxvNwmr+o=
X-Google-Smtp-Source: AGHT+IHuqjEJidq5FlJVSMyq0yYAsLo3Nj1anO6fLJPhjvpXi8xIB3L4TA7C//O+6M7oEOq6LbSDVw==
X-Received: by 2002:a05:6a00:cc6:b0:7aa:d9e2:8175 with SMTP id d2e1a72fcca58-7b0bb53805dmr1647039b3a.2.1762467347210;
        Thu, 06 Nov 2025 14:15:47 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0ccc59de7sm568901b3a.65.2025.11.06.14.15.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Nov 2025 14:15:46 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 05/10] lpfc: Fix leaked ndlp krefs when in point-to-point topology
Date: Thu,  6 Nov 2025 14:46:34 -0800
Message-Id: <20251106224639.139176-6-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20251106224639.139176-1-justintee8345@gmail.com>
References: <20251106224639.139176-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h      |  1 -
 drivers/scsi/lpfc/lpfc_disc.h |  3 +-
 drivers/scsi/lpfc/lpfc_els.c  | 65 +++++++++++++++++++++++++----------
 3 files changed, 49 insertions(+), 20 deletions(-)

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
index 3d47dc7458d1..51cb8571c049 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2025 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2013 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
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

