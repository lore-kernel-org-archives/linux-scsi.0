Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7FFE839FD
	for <linux-scsi@vger.kernel.org>; Mon, 29 Apr 2024 21:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714427887; cv=none; b=IoYhQIuf46/TU6DwsT7gXmoAHC+N9gaep+CR3msi9nypbEBIjS+s7wHQbn6II8IFJpAW8OAmlc4B2aA9iMbNkC7mVR1Yq4niw0ifNaRqLBNB1lHWy0cLxvFjl5E3t3CTIyTNJh+jc2A/PKm4zgW6FEIrte+EMfIthjKRzySgz1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714427887; c=relaxed/simple;
	bh=ITJ77Hu1sRyNpq5Wkv54awrrUMIbRJE9UiHEEa9WOeQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lk0oBqmig2H0WEMP4Lp9KyOiNZXDIH0dbI1nJh3K90sCjjnKAoXw3lTI+bpAV31sNa1vH1NIEhv3HcPQAFTbndNn5Fbeo1ffJfouJBJHFBpfbz3IbSO7xAi4MP0lvuhos02SwP+fAsvZvz1fekSvtHOhvOfPPdvxg1v4Qfu4AGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FrD4zVzS; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FrD4zVzS"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-69b51bfef23so7539736d6.0
        for <linux-scsi@vger.kernel.org>; Mon, 29 Apr 2024 14:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714427885; x=1715032685; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GNTsgF4t3dmsx/G3RdTMiUCvZgRhe/S2CvQl2VQi4CI=;
        b=FrD4zVzS6nm1bjMg1i59V95ln1ORAnP2YJi3h0SiVXNh6eeyQ6z7xWN8n0531L22r9
         R9JnPSkRPazoIm7GLsv4Cbs7S/Nnm73o9zmwLqEjy6D84me17w4Ec21AVFhFkeHUj+ir
         ESluooAQIQm8CAvLAT7l9HQ9F2rc5HJ3pwg868rjgjB5VaZ0u61Q89AU/ZBOlgS+wQth
         m84Uymh4LA3rg7kVxUmqVfmbTMxA1HwRPocZobhvc4F2WW8KkmbDMnHH9TEITLFWru3Q
         Ks12CiXdftkpSJ9NrhuwZaAw88ePuDnP9YQ13H6d/dyCMjMC0hfqBfuRsuyp1hTJ1xFN
         f+Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714427885; x=1715032685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GNTsgF4t3dmsx/G3RdTMiUCvZgRhe/S2CvQl2VQi4CI=;
        b=ltR6+40ClAYXfispbhE70z1ufqc8/ufpGtHgX8qtBuzIzCmlx9eiCCNIHglfgqWQnw
         6uZWLKPs7YTxzNfKv19SfrwRt+gmvTN/WqDlEXWAd6udRWEh86bJ2wPpPNXjdlVs6gmE
         QS9kQw0J28xgoNVLtj+NhEQ7b8oYnQjd66fNnW4i90P4VXAIGZvwULzXo0kU6NmoGuG3
         uJY5rTFSDr4GEkXUDPzwWNTd9OVVOQwBb75UtHScTJdZelZzVXo2YOSQuvSFNHcckTQJ
         bNq4Pwf/YYBYvdkcq3qp+bhOeuqtTZxI2uumqP93CcD3hj4Z4v1mv/FbIgNAJu9Ng52V
         wMBw==
X-Gm-Message-State: AOJu0Yz7RmZm9sf3TZWZjTvnBE0VqsRojeaEJk4DH8xKXu2IwQZSMrGV
	Uy32p3z73/Cz7bb0Zx3DkRR0NHdMDofj1S8L7KS97sFnSBiCHQEcsKyH8A==
X-Google-Smtp-Source: AGHT+IGUaIXlxPN8bLb0vRwQH6NaWP/fPxoayGznJnMVzNbOXEF0lVKJJmrRkBMGhUCV1nSpe5Sf6g==
X-Received: by 2002:ad4:5b83:0:b0:6a0:b818:bf74 with SMTP id 3-20020ad45b83000000b006a0b818bf74mr9469251qvp.0.1714427884593;
        Mon, 29 Apr 2024 14:58:04 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id mh12-20020a056214564c00b006a0cc9ef675sm1528280qvb.16.2024.04.29.14.58.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2024 14:58:04 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 3/8] lpfc: Clear deferred RSCN processing flag when driver is unloading
Date: Mon, 29 Apr 2024 15:15:42 -0700
Message-Id: <20240429221547.6842-4-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240429221547.6842-1-justintee8345@gmail.com>
References: <20240429221547.6842-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Device recovery logic is skipped when the RSCN processing flag is set.
However during rmmod, the flag is not cleared leading to unnecessary
delays in waiting for completions on a link that is being offlined.

Move clearing of the RSCN deferred flag to a refactored routine when called
from device recovery, and set the IA flag when issuing an abort during
unload.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 61 ++++++++++++++++++------------
 drivers/scsi/lpfc/lpfc_sli.c       | 14 ++++---
 2 files changed, 45 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index c4172791c267..b24fabbf20c4 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -47,6 +47,18 @@
 #include "lpfc_debugfs.h"
 
 
+/* Called to clear RSCN discovery flags when driver is unloading. */
+static bool
+lpfc_check_unload_and_clr_rscn(unsigned long *fc_flag)
+{
+	/* If unloading, then clear the FC_RSCN_DEFERRED flag */
+	if (test_bit(FC_UNLOADING, fc_flag)) {
+		clear_bit(FC_RSCN_DEFERRED, fc_flag);
+		return false;
+	}
+	return test_bit(FC_RSCN_DEFERRED, fc_flag);
+}
+
 /* Called to verify a rcv'ed ADISC was intended for us. */
 static int
 lpfc_check_adisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
@@ -213,8 +225,10 @@ void
 lpfc_els_abort(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 {
 	LIST_HEAD(abort_list);
+	LIST_HEAD(drv_cmpl_list);
 	struct lpfc_sli_ring *pring;
 	struct lpfc_iocbq *iocb, *next_iocb;
+	int retval = 0;
 
 	pring = lpfc_phba_elsring(phba);
 
@@ -250,11 +264,20 @@ lpfc_els_abort(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 
 	/* Abort the targeted IOs and remove them from the abort list. */
 	list_for_each_entry_safe(iocb, next_iocb, &abort_list, dlist) {
-			spin_lock_irq(&phba->hbalock);
-			list_del_init(&iocb->dlist);
-			lpfc_sli_issue_abort_iotag(phba, pring, iocb, NULL);
-			spin_unlock_irq(&phba->hbalock);
+		spin_lock_irq(&phba->hbalock);
+		list_del_init(&iocb->dlist);
+		retval = lpfc_sli_issue_abort_iotag(phba, pring, iocb, NULL);
+		spin_unlock_irq(&phba->hbalock);
+
+		if (retval && test_bit(FC_UNLOADING, &phba->pport->load_flag)) {
+			list_del_init(&iocb->list);
+			list_add_tail(&iocb->list, &drv_cmpl_list);
+		}
 	}
+
+	lpfc_sli_cancel_iocbs(phba, &drv_cmpl_list, IOSTAT_LOCAL_REJECT,
+			      IOERR_SLI_ABORTED);
+
 	/* Make sure HBA is alive */
 	lpfc_issue_hb_tmo(phba);
 
@@ -1604,10 +1627,8 @@ lpfc_device_recov_plogi_issue(struct lpfc_vport *vport,
 {
 	struct lpfc_hba  *phba = vport->phba;
 
-	/* Don't do anything that will mess up processing of the
-	 * previous RSCN.
-	 */
-	if (test_bit(FC_RSCN_DEFERRED, &vport->fc_flag))
+	/* Don't do anything that disrupts the RSCN unless lpfc is unloading. */
+	if (lpfc_check_unload_and_clr_rscn(&vport->fc_flag))
 		return ndlp->nlp_state;
 
 	/* software abort outstanding PLOGI */
@@ -1790,10 +1811,8 @@ lpfc_device_recov_adisc_issue(struct lpfc_vport *vport,
 {
 	struct lpfc_hba  *phba = vport->phba;
 
-	/* Don't do anything that will mess up processing of the
-	 * previous RSCN.
-	 */
-	if (test_bit(FC_RSCN_DEFERRED, &vport->fc_flag))
+	/* Don't do anything that disrupts the RSCN unless lpfc is unloading. */
+	if (lpfc_check_unload_and_clr_rscn(&vport->fc_flag))
 		return ndlp->nlp_state;
 
 	/* software abort outstanding ADISC */
@@ -2059,10 +2078,8 @@ lpfc_device_recov_reglogin_issue(struct lpfc_vport *vport,
 				 void *arg,
 				 uint32_t evt)
 {
-	/* Don't do anything that will mess up processing of the
-	 * previous RSCN.
-	 */
-	if (test_bit(FC_RSCN_DEFERRED, &vport->fc_flag))
+	/* Don't do anything that disrupts the RSCN unless lpfc is unloading. */
+	if (lpfc_check_unload_and_clr_rscn(&vport->fc_flag))
 		return ndlp->nlp_state;
 
 	ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
@@ -2375,10 +2392,8 @@ lpfc_device_recov_prli_issue(struct lpfc_vport *vport,
 {
 	struct lpfc_hba  *phba = vport->phba;
 
-	/* Don't do anything that will mess up processing of the
-	 * previous RSCN.
-	 */
-	if (test_bit(FC_RSCN_DEFERRED, &vport->fc_flag))
+	/* Don't do anything that disrupts the RSCN unless lpfc is unloading. */
+	if (lpfc_check_unload_and_clr_rscn(&vport->fc_flag))
 		return ndlp->nlp_state;
 
 	/* software abort outstanding PRLI */
@@ -2894,10 +2909,8 @@ static uint32_t
 lpfc_device_recov_npr_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			   void *arg, uint32_t evt)
 {
-	/* Don't do anything that will mess up processing of the
-	 * previous RSCN.
-	 */
-	if (test_bit(FC_RSCN_DEFERRED, &vport->fc_flag))
+	/* Don't do anything that disrupts the RSCN unless lpfc is unloading. */
+	if (lpfc_check_unload_and_clr_rscn(&vport->fc_flag))
 		return ndlp->nlp_state;
 
 	lpfc_cancel_retry_delay_tmo(vport, ndlp);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index a028e008dd1e..fa3d458af193 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -12361,10 +12361,10 @@ lpfc_ignore_els_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	/* ELS cmd tag <ulpIoTag> completes */
 	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
-			"0139 Ignoring ELS cmd code x%x completion Data: "
+			"0139 Ignoring ELS cmd code x%x ref cnt x%x Data: "
 			"x%x x%x x%x x%px\n",
-			ulp_command, ulp_status, ulp_word4, iotag,
-			cmdiocb->ndlp);
+			ulp_command, kref_read(&cmdiocb->ndlp->kref),
+			ulp_status, ulp_word4, iotag, cmdiocb->ndlp);
 	/*
 	 * Deref the ndlp after free_iocb. sli_release_iocb will access the ndlp
 	 * if exchange is busy.
@@ -12460,7 +12460,9 @@ lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		}
 	}
 
-	if (phba->link_state < LPFC_LINK_UP ||
+	/* Just close the exchange under certain conditions. */
+	if (test_bit(FC_UNLOADING, &vport->load_flag) ||
+	    phba->link_state < LPFC_LINK_UP ||
 	    (phba->sli_rev == LPFC_SLI_REV4 &&
 	     phba->sli4_hba.link_state.status == LPFC_FC_LA_TYPE_LINK_DOWN) ||
 	    (phba->link_flag & LS_EXTERNAL_LOOPBACK))
@@ -12507,10 +12509,10 @@ lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_SLI,
 			 "0339 Abort IO XRI x%x, Original iotag x%x, "
 			 "abort tag x%x Cmdjob : x%px Abortjob : x%px "
-			 "retval x%x\n",
+			 "retval x%x : IA %d\n",
 			 ulp_context, (phba->sli_rev == LPFC_SLI_REV4) ?
 			 cmdiocb->iotag : iotag, iotag, cmdiocb, abtsiocbp,
-			 retval);
+			 retval, ia);
 	if (retval) {
 		cmdiocb->cmd_flag &= ~LPFC_DRIVER_ABORTED;
 		__lpfc_sli_release_iocbq(phba, abtsiocbp);
-- 
2.38.0

