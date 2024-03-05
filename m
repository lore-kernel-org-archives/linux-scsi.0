Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D0986659
	for <linux-scsi@vger.kernel.org>; Tue,  5 Mar 2024 19:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709668160; cv=none; b=tMUH0LGvkLlfEbrqJbq7NfBMF+5WFiQPeNweYcxrXd2X1UxP7GUJfe42KAL9+Ysx+9VNFlOyTwX0uz1z6BjZ1ow4ovNiYQMrHV4aAJqI8LGHqkhvEGlILWwEWoHfUowslG828lN5S87i9dncZg3/fbMnysWxcWTonwx/id34NS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709668160; c=relaxed/simple;
	bh=nWCPK9j68QUS5rAaPjR0a0qOHdGvj2oAyYPoJ1Z8LgM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZKA/uxXCbHmoQiqNfJX3DyaTwjVHPbkbUxKBa+Wj1nWMfxnN77U5J2kiuZLAux3f3KXbHhrsHBsNmRpYOZ5MrnpDz+6GJaCgrzi9yoRy1xX0skFwP2GHVJQyi3BQ5dmztCRgn5RSJ/ppXuJNVfXHNyMM8kNQIxeE1DE6eucEdFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eNWZeHCS; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eNWZeHCS"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-69069235a0eso4485356d6.0
        for <linux-scsi@vger.kernel.org>; Tue, 05 Mar 2024 11:49:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709668157; x=1710272957; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b3J0zbqv98a1aRLu4y3DHX6FmT5cBFVpbFUdAJb/thg=;
        b=eNWZeHCSdINqsgo2pywdIWS/1T9lFUkk5AYKmbamOoqSa52OgLZ2j+vQcDtWbS1xmr
         +J2gD+qEPaCMOLp/Z9laIl27Ef93pOGlaXlrmj9N6Tu2fA5dCM0ZzzVelmogl11GrCN4
         UYWnFABir1ACGyKllVLJFmNXsVAYntHIjKzCiIpPHxJmfgUJWe7gkD9kPdV8U32A40G/
         50NrfPhCOJC6lBlOecOXoK+nYAREBtGmoa3tCM6R4+EarAhbpazCbI5MRJ/meq5Ur/Oe
         6ALYsfe/UjKJhtY6rqKdGsupDW6OZqSAslktA5oW6sbM0Qm824aGjLvVJb+8ZppLydQl
         eJSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709668157; x=1710272957;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b3J0zbqv98a1aRLu4y3DHX6FmT5cBFVpbFUdAJb/thg=;
        b=jDxxXFibcqALRQ75PWRkviOe1b2UjBI8PiSCxm23USsI+SMMdVDAcg1d/NsoE+tAUL
         nzpr8HXW8gIjO8Leu0vzjs19/pbtV0vHUUI4IKJJRu2nYzi6+qC3JA6ytPBc1eZAzMi2
         gG3Fg6/9e22sZvzCvb5tRosXvSPDwQRh6Vqr07kovPOSOlbaz9EEoQxZpm0ZLLeSWAru
         GnsweRkt2iu3h62XX2W7WHCQArB0WRrgyM369Ggfarfp0R3W03Lt0HvjZbEGnTsfjVxm
         in3EcWvvIMFda4W8vvulovybLJXhm8ww8aWq4/6tdt5j1fRRXuU5X6Nk8f0M1TelYkxh
         Aeaw==
X-Gm-Message-State: AOJu0Yw51oAjhj3bfyKDuw405OfHCNIh61HHF41HLNYZhHMUUFkGfoze
	IKk54/OZEX3cXWVkIRaMkp3Hmu7DakmkO5teXqydLM0SgUoU2fm3YTUSF0gI
X-Google-Smtp-Source: AGHT+IF0D557VzfvGcKRHKMXxHPOyEqoIT30pKsb4hqmPK25YeNisF6VaAzBYLpfCz2BkCwqub5DDw==
X-Received: by 2002:a05:620a:24c6:b0:788:24c0:3a36 with SMTP id m6-20020a05620a24c600b0078824c03a36mr768442qkn.3.1709668157307;
        Tue, 05 Mar 2024 11:49:17 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bj13-20020a05620a190d00b007877f52a6b9sm5706050qkb.136.2024.03.05.11.49.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Mar 2024 11:49:16 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 07/12] lpfc: Use a dedicated lock for ras_fwlog state
Date: Tue,  5 Mar 2024 12:04:58 -0800
Message-Id: <20240305200503.57317-8-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240305200503.57317-1-justintee8345@gmail.com>
References: <20240305200503.57317-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To reduce usage of and contention for hbalock, a separate dedicated lock
is used to protect ras_fwlog state.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h         |  1 +
 drivers/scsi/lpfc/lpfc_attr.c    |  4 ++--
 drivers/scsi/lpfc/lpfc_bsg.c     | 20 ++++++++++----------
 drivers/scsi/lpfc/lpfc_debugfs.c | 12 ++++++------
 drivers/scsi/lpfc/lpfc_init.c    |  3 +++
 drivers/scsi/lpfc/lpfc_sli.c     | 20 ++++++++++----------
 6 files changed, 32 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 18cbfd371ccc..98ca7df003ef 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1437,6 +1437,7 @@ struct lpfc_hba {
 	struct timer_list inactive_vmid_poll;
 
 	/* RAS Support */
+	spinlock_t ras_fwlog_lock; /* do not take while holding another lock */
 	struct lpfc_ras_fwlog ras_fwlog;
 
 	uint32_t iocb_cnt;
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 365c7e96070b..3c534b3cfe91 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -5865,9 +5865,9 @@ lpfc_ras_fwlog_buffsize_set(struct lpfc_hba  *phba, uint val)
 	if (phba->cfg_ras_fwlog_func != PCI_FUNC(phba->pcidev->devfn))
 		return -EINVAL;
 
-	spin_lock_irq(&phba->hbalock);
+	spin_lock_irq(&phba->ras_fwlog_lock);
 	state = phba->ras_fwlog.state;
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irq(&phba->ras_fwlog_lock);
 
 	if (state == REG_INPROGRESS) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI, "6147 RAS Logging "
diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index d80e6e81053b..fee485e47041 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -5070,12 +5070,12 @@ lpfc_bsg_get_ras_config(struct bsg_job *job)
 		bsg_reply->reply_data.vendor_reply.vendor_rsp;
 
 	/* Current logging state */
-	spin_lock_irq(&phba->hbalock);
+	spin_lock_irq(&phba->ras_fwlog_lock);
 	if (ras_fwlog->state == ACTIVE)
 		ras_reply->state = LPFC_RASLOG_STATE_RUNNING;
 	else
 		ras_reply->state = LPFC_RASLOG_STATE_STOPPED;
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irq(&phba->ras_fwlog_lock);
 
 	ras_reply->log_level = phba->ras_fwlog.fw_loglevel;
 	ras_reply->log_buff_sz = phba->cfg_ras_fwlog_buffsize;
@@ -5132,13 +5132,13 @@ lpfc_bsg_set_ras_config(struct bsg_job *job)
 
 	if (action == LPFC_RASACTION_STOP_LOGGING) {
 		/* Check if already disabled */
-		spin_lock_irq(&phba->hbalock);
+		spin_lock_irq(&phba->ras_fwlog_lock);
 		if (ras_fwlog->state != ACTIVE) {
-			spin_unlock_irq(&phba->hbalock);
+			spin_unlock_irq(&phba->ras_fwlog_lock);
 			rc = -ESRCH;
 			goto ras_job_error;
 		}
-		spin_unlock_irq(&phba->hbalock);
+		spin_unlock_irq(&phba->ras_fwlog_lock);
 
 		/* Disable logging */
 		lpfc_ras_stop_fwlog(phba);
@@ -5149,10 +5149,10 @@ lpfc_bsg_set_ras_config(struct bsg_job *job)
 		 * FW-logging with new log-level. Return status
 		 * "Logging already Running" to caller.
 		 **/
-		spin_lock_irq(&phba->hbalock);
+		spin_lock_irq(&phba->ras_fwlog_lock);
 		if (ras_fwlog->state != INACTIVE)
 			action_status = -EINPROGRESS;
-		spin_unlock_irq(&phba->hbalock);
+		spin_unlock_irq(&phba->ras_fwlog_lock);
 
 		/* Enable logging */
 		rc = lpfc_sli4_ras_fwlog_init(phba, log_level,
@@ -5268,13 +5268,13 @@ lpfc_bsg_get_ras_fwlog(struct bsg_job *job)
 		goto ras_job_error;
 
 	/* Logging to be stopped before reading */
-	spin_lock_irq(&phba->hbalock);
+	spin_lock_irq(&phba->ras_fwlog_lock);
 	if (ras_fwlog->state == ACTIVE) {
-		spin_unlock_irq(&phba->hbalock);
+		spin_unlock_irq(&phba->ras_fwlog_lock);
 		rc = -EINPROGRESS;
 		goto ras_job_error;
 	}
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irq(&phba->ras_fwlog_lock);
 
 	if (job->request_len <
 	    sizeof(struct fc_bsg_request) +
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index ab5af10c8a16..a2d2b02b3418 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -2194,12 +2194,12 @@ static int lpfc_debugfs_ras_log_data(struct lpfc_hba *phba,
 
 	memset(buffer, 0, size);
 
-	spin_lock_irq(&phba->hbalock);
+	spin_lock_irq(&phba->ras_fwlog_lock);
 	if (phba->ras_fwlog.state != ACTIVE) {
-		spin_unlock_irq(&phba->hbalock);
+		spin_unlock_irq(&phba->ras_fwlog_lock);
 		return -EINVAL;
 	}
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irq(&phba->ras_fwlog_lock);
 
 	list_for_each_entry_safe(dmabuf, next,
 				 &phba->ras_fwlog.fwlog_buff_list, list) {
@@ -2250,13 +2250,13 @@ lpfc_debugfs_ras_log_open(struct inode *inode, struct file *file)
 	int size;
 	int rc = -ENOMEM;
 
-	spin_lock_irq(&phba->hbalock);
+	spin_lock_irq(&phba->ras_fwlog_lock);
 	if (phba->ras_fwlog.state != ACTIVE) {
-		spin_unlock_irq(&phba->hbalock);
+		spin_unlock_irq(&phba->ras_fwlog_lock);
 		rc = -EINVAL;
 		goto out;
 	}
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irq(&phba->ras_fwlog_lock);
 
 	if (check_mul_overflow(LPFC_RAS_MIN_BUFF_POST_SIZE,
 			       phba->cfg_ras_fwlog_buffsize, &size))
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 3363b0db65ae..c4c305472285 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7705,6 +7705,9 @@ lpfc_setup_driver_resource_phase1(struct lpfc_hba *phba)
 				"NVME" : " "),
 			(phba->nvmet_support ? "NVMET" : " "));
 
+	/* ras_fwlog state */
+	spin_lock_init(&phba->ras_fwlog_lock);
+
 	/* Initialize the IO buffer list used by driver for SLI3 SCSI */
 	spin_lock_init(&phba->scsi_buf_list_get_lock);
 	INIT_LIST_HEAD(&phba->lpfc_scsi_buf_list_get);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 030d7084e412..7f87046e64b7 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -6849,9 +6849,9 @@ lpfc_ras_stop_fwlog(struct lpfc_hba *phba)
 {
 	struct lpfc_ras_fwlog *ras_fwlog = &phba->ras_fwlog;
 
-	spin_lock_irq(&phba->hbalock);
+	spin_lock_irq(&phba->ras_fwlog_lock);
 	ras_fwlog->state = INACTIVE;
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irq(&phba->ras_fwlog_lock);
 
 	/* Disable FW logging to host memory */
 	writel(LPFC_CTL_PDEV_CTL_DDL_RAS,
@@ -6894,9 +6894,9 @@ lpfc_sli4_ras_dma_free(struct lpfc_hba *phba)
 		ras_fwlog->lwpd.virt = NULL;
 	}
 
-	spin_lock_irq(&phba->hbalock);
+	spin_lock_irq(&phba->ras_fwlog_lock);
 	ras_fwlog->state = INACTIVE;
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irq(&phba->ras_fwlog_lock);
 }
 
 /**
@@ -6998,9 +6998,9 @@ lpfc_sli4_ras_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 		goto disable_ras;
 	}
 
-	spin_lock_irq(&phba->hbalock);
+	spin_lock_irq(&phba->ras_fwlog_lock);
 	ras_fwlog->state = ACTIVE;
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irq(&phba->ras_fwlog_lock);
 	mempool_free(pmb, phba->mbox_mem_pool);
 
 	return;
@@ -7032,9 +7032,9 @@ lpfc_sli4_ras_fwlog_init(struct lpfc_hba *phba,
 	uint32_t len = 0, fwlog_buffsize, fwlog_entry_count;
 	int rc = 0;
 
-	spin_lock_irq(&phba->hbalock);
+	spin_lock_irq(&phba->ras_fwlog_lock);
 	ras_fwlog->state = INACTIVE;
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irq(&phba->ras_fwlog_lock);
 
 	fwlog_buffsize = (LPFC_RAS_MIN_BUFF_POST_SIZE *
 			  phba->cfg_ras_fwlog_buffsize);
@@ -7095,9 +7095,9 @@ lpfc_sli4_ras_fwlog_init(struct lpfc_hba *phba,
 	mbx_fwlog->u.request.lwpd.addr_lo = putPaddrLow(ras_fwlog->lwpd.phys);
 	mbx_fwlog->u.request.lwpd.addr_hi = putPaddrHigh(ras_fwlog->lwpd.phys);
 
-	spin_lock_irq(&phba->hbalock);
+	spin_lock_irq(&phba->ras_fwlog_lock);
 	ras_fwlog->state = REG_INPROGRESS;
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irq(&phba->ras_fwlog_lock);
 	mbox->vport = phba->pport;
 	mbox->mbox_cmpl = lpfc_sli4_ras_mbox_cmpl;
 
-- 
2.38.0

