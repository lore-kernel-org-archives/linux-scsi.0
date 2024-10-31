Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91471CCEE8
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 22:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730412939; cv=none; b=jWoFeVkyeKQoQ7K+DV5EaZDogEXhKe38qKRf2h0eP2MUdhzrO4ykq+Txa6MG6r1nI/M6GIDpJNRUGrgB0gcCtJ37y/gBeJfasvayCgtBKcmqG3T2D2qxlDCW5Nlzshp4uVs33JTiD/nFJz09MRVtlkTquZq/VDQgkXjQdhNZbH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730412939; c=relaxed/simple;
	bh=2AsZWRN4fljeMRtqn37iACDUWFHU8zkHZnzu/kDlIMI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RM0o79dtpUT9ui8WhfHFUcPg83TRJVBY1yXbsVDVgPQlltf5gDkPPfw4a+ETb43bB8kgaHjqbpIy59mBvTGRCXU7IWhITCZ+dF5dkEyXDnpHYD42At7w1izl+poXdZF4Tiy344YzQGt6fMt67Go7JJjbgE0O5iSVc9i/sGfdvyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IfYA3udE; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IfYA3udE"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2e2bd347124so1118120a91.1
        for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 15:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730412933; x=1731017733; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lX7BLqOduonkmSUPWdoS/+gYMLqg5OQMqcC3w9RR55w=;
        b=IfYA3udEZasHGym043wo+qEG6V2CSKwaBY1Wo0GspJU+jan4lL80qlojB1jm1d8tyJ
         /fgIJ8cz5WGK11EVGekfgjg/rn1A1ITymJw0xOM1wM+vTcpcFwrKdYHWlzbKadduKDjy
         VHkPUSPSbl8tTYQoB7L5lkaiEEbG9FrgDHFKyzpr/8jpwmZkZmvOQqqj103unSE75dba
         5/rbnCAujv61V9JIVuaIZAwnyBtAj3f8J5k9KVIJM5rYRvgN36zEPONdcwUBuhSfY5hb
         lMJrdTljj7Sd6CT5hfeAG3ft50Lfe8FjtOQ3+ESRDPZEwXLH+PMxFPA4oexi/KauZdXe
         RFRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730412933; x=1731017733;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lX7BLqOduonkmSUPWdoS/+gYMLqg5OQMqcC3w9RR55w=;
        b=guNK8+oofQt4TyfW0tnGd6BSdIWt/vNUALhms4yYrHtCZFPH2pUt0EXjVaBqB09pNZ
         FiculLEabsfQjn+cwiF7RQQRCGU93lIXBcbUyfSXRsbgwR4vI3Wg9Ia/HENDec3l6jsk
         UPHC8vkCF+fOr7nJUc34AVaG/0Ah1JQsQkML2+655EytIkeLJkauB6ZuXWWeq14LU3/g
         AXqytPENLyTQnZwGonNKUAZsYYewuUjmFZ4MO7RiZ4jKxgAcM4358osYHva1cpjPIOx9
         asPRCRXYmDsWkewnP5SeGDxU8Yh+8LegorsT+MX7Q0nMwooxJrdxzQmHxipOORjvHTiC
         SCeQ==
X-Gm-Message-State: AOJu0YxumCS8Tv0Sk7AUNOrjoObL4Bzfzgkgs40E42wD4L+4r+tgM2gG
	yM3zsCJT5Rxh4hklGuaPN9QiIwNOu401xss6bDup5CLyECa9kY11bBArkg==
X-Google-Smtp-Source: AGHT+IGNoDav0K3iC9cXXeh6kz9YXcJDeRvjrMhpViz80ZW4P/vaUcL56miZaImygvNv8pgDtvGwYw==
X-Received: by 2002:a17:90a:f185:b0:2e1:682b:361a with SMTP id 98e67ed59e1d1-2e8f11bad82mr22351218a91.28.1730412932934;
        Thu, 31 Oct 2024 15:15:32 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e92fa25742sm3916528a91.19.2024.10.31.15.15.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Oct 2024 15:15:32 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 06/11] lpfc: Add cleanup of nvmels_wq after HBA reset
Date: Thu, 31 Oct 2024 15:32:14 -0700
Message-Id: <20241031223219.152342-7-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20241031223219.152342-1-justintee8345@gmail.com>
References: <20241031223219.152342-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An HBA reset request that is executed when there are outstanding NVME-LS
commands can cause delays for the reset process to complete.  Fix by
introducing a new routine called lpfc_nvmels_flush_cmd that walks the
phba->nvmels_wq list and cancels outstanding submitted NVME-LS requests
speeding up the HBA reset process.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_crtn.h |  1 +
 drivers/scsi/lpfc/lpfc_init.c |  1 +
 drivers/scsi/lpfc/lpfc_nvme.c | 51 +++++++++++++++++++++++++++++++++--
 3 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index d4e46a08f94d..b1e26a5abe58 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -660,6 +660,7 @@ void lpfc_wqe_cmd_template(void);
 void lpfc_nvmet_cmd_template(void);
 void lpfc_nvme_cancel_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 			   uint32_t stat, uint32_t param);
+void lpfc_nvmels_flush_cmd(struct lpfc_hba *phba);
 extern int lpfc_enable_nvmet_cnt;
 extern unsigned long long lpfc_enable_nvmet[];
 extern int lpfc_no_hba_reset_cnt;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index a3658ef1141b..c16a321404c5 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1943,6 +1943,7 @@ lpfc_sli4_port_sta_fn_reset(struct lpfc_hba *phba, int mbx_action,
 
 	lpfc_offline_prep(phba, mbx_action);
 	lpfc_sli_flush_io_rings(phba);
+	lpfc_nvmels_flush_cmd(phba);
 	lpfc_offline(phba);
 	/* release interrupt for possible resource change */
 	lpfc_sli4_disable_intr(phba);
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index d70da2736c94..4f628e00d1c1 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2231,6 +2231,7 @@ lpfc_nvme_lport_unreg_wait(struct lpfc_vport *vport,
 	struct lpfc_hba  *phba = vport->phba;
 	struct lpfc_sli4_hdw_queue *qp;
 	int abts_scsi, abts_nvme;
+	u16 nvmels_cnt;
 
 	/* Host transport has to clean up and confirm requiring an indefinite
 	 * wait. Print a message if a 10 second wait expires and renew the
@@ -2243,6 +2244,7 @@ lpfc_nvme_lport_unreg_wait(struct lpfc_vport *vport,
 			pending = 0;
 			abts_scsi = 0;
 			abts_nvme = 0;
+			nvmels_cnt = 0;
 			for (i = 0; i < phba->cfg_hdw_queue; i++) {
 				qp = &phba->sli4_hba.hdwq[i];
 				if (!vport->localport || !qp || !qp->io_wq)
@@ -2255,6 +2257,11 @@ lpfc_nvme_lport_unreg_wait(struct lpfc_vport *vport,
 				abts_scsi += qp->abts_scsi_io_bufs;
 				abts_nvme += qp->abts_nvme_io_bufs;
 			}
+			if (phba->sli4_hba.nvmels_wq) {
+				pring = phba->sli4_hba.nvmels_wq->pring;
+				if (pring)
+					nvmels_cnt = pring->txcmplq_cnt;
+			}
 			if (!vport->localport ||
 			    test_bit(HBA_PCI_ERR, &vport->phba->bit_flags) ||
 			    phba->link_state == LPFC_HBA_ERROR ||
@@ -2263,10 +2270,10 @@ lpfc_nvme_lport_unreg_wait(struct lpfc_vport *vport,
 
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 					 "6176 Lport x%px Localport x%px wait "
-					 "timed out. Pending %d [%d:%d]. "
+					 "timed out. Pending %d [%d:%d:%d]. "
 					 "Renewing.\n",
 					 lport, vport->localport, pending,
-					 abts_scsi, abts_nvme);
+					 abts_scsi, abts_nvme, nvmels_cnt);
 			continue;
 		}
 		break;
@@ -2841,3 +2848,43 @@ lpfc_nvme_cancel_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 	(pwqeIn->cmd_cmpl)(phba, pwqeIn, pwqeIn);
 #endif
 }
+
+/**
+ * lpfc_nvmels_flush_cmd - Clean up outstanding nvmels commands for a port
+ * @phba: Pointer to HBA context object.
+ *
+ **/
+void
+lpfc_nvmels_flush_cmd(struct lpfc_hba *phba)
+{
+#if (IS_ENABLED(CONFIG_NVME_FC))
+	LIST_HEAD(cancel_list);
+	struct lpfc_sli_ring *pring = NULL;
+	struct lpfc_iocbq *piocb, *tmp_iocb;
+	unsigned long iflags;
+
+	if (phba->sli4_hba.nvmels_wq)
+		pring = phba->sli4_hba.nvmels_wq->pring;
+
+	if (unlikely(!pring))
+		return;
+
+	spin_lock_irqsave(&phba->hbalock, iflags);
+	spin_lock(&pring->ring_lock);
+	list_splice_init(&pring->txq, &cancel_list);
+	pring->txq_cnt = 0;
+	list_for_each_entry_safe(piocb, tmp_iocb, &pring->txcmplq, list) {
+		if (piocb->cmd_flag & LPFC_IO_NVME_LS) {
+			list_move_tail(&piocb->list, &cancel_list);
+			pring->txcmplq_cnt--;
+			piocb->cmd_flag &= ~LPFC_IO_ON_TXCMPLQ;
+		}
+	}
+	spin_unlock(&pring->ring_lock);
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+
+	if (!list_empty(&cancel_list))
+		lpfc_sli_cancel_iocbs(phba, &cancel_list, IOSTAT_LOCAL_REJECT,
+				      IOERR_SLI_DOWN);
+#endif
+}
-- 
2.38.0

