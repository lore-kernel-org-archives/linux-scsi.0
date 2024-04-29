Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92ED11836E9
	for <linux-scsi@vger.kernel.org>; Mon, 29 Apr 2024 21:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714427889; cv=none; b=hqjSuqfhtpG4ZTIqsbsBiEASA3u1mCSAJ3j4N+Cyo+92yTnJmpCp8EpL6QEVMQz847r1f9RCnPDo+/SsLaX8aEXMus8D/MeclRDuHGisBclEBDjFh2WRXxOiJRiW9BQHQGBccEoscHbKMRTg7i+KJxCgOETRsOPcUOSlOLl990c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714427889; c=relaxed/simple;
	bh=zl+ZORvBwF5eHU6oIpiK3BUMiV5TV4Edby+2y2q92Gk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=joPgnhOALL4YhEbkpt0AD4ETz8zHmyl+Jpx7BHMDjlsEW7s2ELoymg1tz/Tqpa4vQIE2K710Uj2iCp0lSZGzpiW5HUkRGhLxp2a5GnC7MdSdYY/GcP7epWDqgfwhkf8lzV2F4BnL1S89+tebmelkiK+fqd+lB7SVEijC3XNl+yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kTFYUlCi; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kTFYUlCi"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-6a08073fe48so3704356d6.3
        for <linux-scsi@vger.kernel.org>; Mon, 29 Apr 2024 14:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714427886; x=1715032686; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mjr3SQDwJjoq/v6W4UMtUnCKmFawSA6FDgYeeVZooLU=;
        b=kTFYUlCix3NiU12qBntmtfRVGAckehWYUsdcBZ0zyowTyaZVfkOsSM2Uc69YclAe/0
         sSyfUzi5kgQeri3BTwUnDHaAq1wPyw0JtPRuDUOSTi786fNY1a1RcIkASyUU8ePIAF53
         B+TcLR52gVZ+kJuI4rCPdC8O74MjJXIaP6BkzFIDZw2m6evG75TgmRIJFLA/AAx+87Mc
         cHGXXarLLKkYhUnayBRY81eZdXj7+KpKEynWZPVXPwcNEcT+V58UW6C11Sr1il7ywnGY
         gnh8c5yJJXyZCU1ISel74xZUppUE7J/n/IQO7eXJDy1if6E88CprfpaIli/aYYc11NOF
         bAmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714427886; x=1715032686;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mjr3SQDwJjoq/v6W4UMtUnCKmFawSA6FDgYeeVZooLU=;
        b=SOzrSTPlE2eNHWJvCCWnKn/rJrsl1jxdcsjE069ENaOQt72nLwXD+XqENvabUSjZEu
         MY32tI/qGVPpSm4iQUG6HeVRZuNrYs1DFhmS/ta4bg1l4jyd9nSTtqSM3erBd1yVPSCZ
         +Z0S3kJOooCgGktKJ7kzhxJ5/dUDzHAfi/aKX2GJjZQjM+h7MNjHOGJxZMrZPf9dUKUU
         p6llrycQlWkFOYUNKpobc6228U93nPcoFnw8A9MJ61CVBPJbJHXos4Xx8jDnxPRjZm0w
         PsaxgsL4i1IdUPmG+QGazsOvOqIU7doFrPIhYuPYbloqwHzXHexusPNL+/H0byQa3WjF
         +ntg==
X-Gm-Message-State: AOJu0YzUUQainbJdPrVlunv3xoIty+aBCXngqo9mYiQ5McepSBWD6uCN
	kaJVTsB8KbYy5YCr1gyiklZ2CYWagike1d9KGPfuynkVk1xViFmnNE0JcA==
X-Google-Smtp-Source: AGHT+IG7xJY3FoV2RYVDPtLfbI4ZeJv0nD+a4wsFVPBkSSYe5qebNAPZ4FtD8uCOzfxrcN5YLQUkoQ==
X-Received: by 2002:a05:6214:300a:b0:6a0:cd65:599a with SMTP id ke10-20020a056214300a00b006a0cd65599amr5167072qvb.2.1714427886390;
        Mon, 29 Apr 2024 14:58:06 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id mh12-20020a056214564c00b006a0cc9ef675sm1528280qvb.16.2024.04.29.14.58.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2024 14:58:06 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 4/8] lpfc: Introduce rrq_list_lock to protect active_rrq_list
Date: Mon, 29 Apr 2024 15:15:43 -0700
Message-Id: <20240429221547.6842-5-justintee8345@gmail.com>
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

Instead of using the generic object wide phba->hbalock, an explicit lock
should be used to synchronize mutations to the phba->active_rrq_list.

Update all accesses to the phba->active_rrq_list with a new
phba->rrq_list_lock.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h       |  1 +
 drivers/scsi/lpfc/lpfc_init.c  |  1 +
 drivers/scsi/lpfc/lpfc_nvmet.c |  2 ++
 drivers/scsi/lpfc/lpfc_scsi.c  |  4 +++-
 drivers/scsi/lpfc/lpfc_sli.c   | 22 +++++++++++++++-------
 5 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 98ca7df003ef..44a7155daf61 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1284,6 +1284,7 @@ struct lpfc_hba {
 	uint32_t total_scsi_bufs;
 	struct list_head lpfc_iocb_list;
 	uint32_t total_iocbq_bufs;
+	spinlock_t rrq_list_lock;       /* lock for active_rrq_list */
 	struct list_head active_rrq_list;
 	spinlock_t hbalock;
 	struct work_struct  unblock_request_work; /* SCSI layer unblock IOs */
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index f7a0aa3625f4..bd8f97cab2c6 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -14812,6 +14812,7 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 		goto out_unset_pci_mem_s4;
 	}
 
+	spin_lock_init(&phba->rrq_list_lock);
 	INIT_LIST_HEAD(&phba->active_rrq_list);
 	INIT_LIST_HEAD(&phba->fcf.fcf_pri_list);
 
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 561ced5503c6..0b91de86d845 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1811,7 +1811,9 @@ lpfc_sli4_nvmet_xri_aborted(struct lpfc_hba *phba,
 		ctxp->flag &= ~LPFC_NVME_XBUSY;
 		spin_unlock_irqrestore(&ctxp->ctxlock, iflag);
 
+		spin_lock_irqsave(&phba->rrq_list_lock, iflag);
 		rrq_empty = list_empty(&phba->active_rrq_list);
+		spin_unlock_irqrestore(&phba->rrq_list_lock, iflag);
 		ndlp = lpfc_findnode_did(phba->pport, ctxp->sid);
 		if (ndlp &&
 		    (ndlp->nlp_state == NLP_STE_UNMAPPED_NODE ||
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 89a622e3053e..8ff39cd9c7e2 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -474,9 +474,11 @@ lpfc_sli4_io_xri_aborted(struct lpfc_hba *phba,
 				ndlp = psb->rdata->pnode;
 			else
 				ndlp = NULL;
+			spin_unlock_irqrestore(&phba->hbalock, iflag);
 
+			spin_lock_irqsave(&phba->rrq_list_lock, iflag);
 			rrq_empty = list_empty(&phba->active_rrq_list);
-			spin_unlock_irqrestore(&phba->hbalock, iflag);
+			spin_unlock_irqrestore(&phba->rrq_list_lock, iflag);
 			if (ndlp && !offline) {
 				lpfc_set_rrq_active(phba, ndlp,
 					psb->cur_iocbq.sli4_lxritag, rxid, 1);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index fa3d458af193..c64151cd205e 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1026,7 +1026,10 @@ lpfc_handle_rrq_active(struct lpfc_hba *phba)
 
 	spin_lock_irqsave(&phba->hbalock, iflags);
 	phba->hba_flag &= ~HBA_RRQ_ACTIVE;
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+
 	next_time = jiffies + msecs_to_jiffies(1000 * (phba->fc_ratov + 1));
+	spin_lock_irqsave(&phba->rrq_list_lock, iflags);
 	list_for_each_entry_safe(rrq, nextrrq,
 				 &phba->active_rrq_list, list) {
 		if (time_after(jiffies, rrq->rrq_stop_time))
@@ -1034,7 +1037,7 @@ lpfc_handle_rrq_active(struct lpfc_hba *phba)
 		else if (time_before(rrq->rrq_stop_time, next_time))
 			next_time = rrq->rrq_stop_time;
 	}
-	spin_unlock_irqrestore(&phba->hbalock, iflags);
+	spin_unlock_irqrestore(&phba->rrq_list_lock, iflags);
 	if ((!list_empty(&phba->active_rrq_list)) &&
 	    (!test_bit(FC_UNLOADING, &phba->pport->load_flag)))
 		mod_timer(&phba->rrq_tmr, next_time);
@@ -1072,16 +1075,16 @@ lpfc_get_active_rrq(struct lpfc_vport *vport, uint16_t xri, uint32_t did)
 
 	if (phba->sli_rev != LPFC_SLI_REV4)
 		return NULL;
-	spin_lock_irqsave(&phba->hbalock, iflags);
+	spin_lock_irqsave(&phba->rrq_list_lock, iflags);
 	list_for_each_entry_safe(rrq, nextrrq, &phba->active_rrq_list, list) {
 		if (rrq->vport == vport && rrq->xritag == xri &&
 				rrq->nlp_DID == did){
 			list_del(&rrq->list);
-			spin_unlock_irqrestore(&phba->hbalock, iflags);
+			spin_unlock_irqrestore(&phba->rrq_list_lock, iflags);
 			return rrq;
 		}
 	}
-	spin_unlock_irqrestore(&phba->hbalock, iflags);
+	spin_unlock_irqrestore(&phba->rrq_list_lock, iflags);
 	return NULL;
 }
 
@@ -1109,7 +1112,7 @@ lpfc_cleanup_vports_rrqs(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		lpfc_sli4_vport_delete_els_xri_aborted(vport);
 		lpfc_sli4_vport_delete_fcp_xri_aborted(vport);
 	}
-	spin_lock_irqsave(&phba->hbalock, iflags);
+	spin_lock_irqsave(&phba->rrq_list_lock, iflags);
 	list_for_each_entry_safe(rrq, nextrrq, &phba->active_rrq_list, list) {
 		if (rrq->vport != vport)
 			continue;
@@ -1118,7 +1121,7 @@ lpfc_cleanup_vports_rrqs(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 			list_move(&rrq->list, &rrq_list);
 
 	}
-	spin_unlock_irqrestore(&phba->hbalock, iflags);
+	spin_unlock_irqrestore(&phba->rrq_list_lock, iflags);
 
 	list_for_each_entry_safe(rrq, nextrrq, &rrq_list, list) {
 		list_del(&rrq->list);
@@ -1213,11 +1216,16 @@ lpfc_set_rrq_active(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
 	rrq->nlp_DID = ndlp->nlp_DID;
 	rrq->vport = ndlp->vport;
 	rrq->rxid = rxid;
-	spin_lock_irqsave(&phba->hbalock, iflags);
+
+	spin_lock_irqsave(&phba->rrq_list_lock, iflags);
 	empty = list_empty(&phba->active_rrq_list);
 	list_add_tail(&rrq->list, &phba->active_rrq_list);
+	spin_unlock_irqrestore(&phba->rrq_list_lock, iflags);
+
+	spin_lock_irqsave(&phba->hbalock, iflags);
 	phba->hba_flag |= HBA_RRQ_ACTIVE;
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
+
 	if (empty)
 		lpfc_worker_wake_up(phba);
 	return 0;
-- 
2.38.0

