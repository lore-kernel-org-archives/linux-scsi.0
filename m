Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9700F1514EF
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jul 2024 23:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722034806; cv=none; b=TUJ23t3Jxtx/nzJWWZ8jgQnhoEwjUr17SnQFDSnlNt9QCtuF8J7zOE+cLZDe5y/iu7fMp89Fp2XD19oSMh4LVakCs3IltvnStmwvYf6zut5VUuWyHeZPKQYzS36uY9pSDNwVTsquwk+LlEgmWD+HSBps6jvKpQ3AD0ejfk7IHMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722034806; c=relaxed/simple;
	bh=lAiUL8ce01UJECO5BUALuMocYkyyrqLycbdb74oLkDU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=F4FVXc3kBuol0kr1nCJgCPphszBQBxGTuLxbsuRXOzrIyBSjRm9fZyV1FRWwe6NCwbIAxmS6mskdvMc0oFnrs4J4ksw24etdsQZZOYoqzNJlj/BS4k/IYj8q4FHJSt5PkBttjfGE2Krec9JX8BhX/LzWdoR3Q8B2T2SGCcNVELI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mfjEnyGE; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mfjEnyGE"
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-81f82478b70so11787639f.0
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jul 2024 16:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722034803; x=1722639603; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+O6rIP5ddPDwYqH7AORHrX49Sj0oJNOV55RUSW14M9o=;
        b=mfjEnyGEKibSA7jLv6rAmI0uGy/gjR0eC6nJwcsMGiVAs3y/f4wFtOLAM4q415VqIE
         Iyp5cZsY3ZThrPR2mawfw1333KY0mEay70qF+6QoChJMVeQI/3qXzQe1A4b4kerbf5jh
         8HasbHGj2NKSsZ+J7LMEYGQ8IQqK9bGo9S1dCyd7vBnvRVTvgUjmWuNdNljqseDKJOvS
         F2oVmTFyjqYhFtU0dAfErji3l5b66BRDuAWW7KNsBbimUwAvx+3KcAMouwxSp9Buw54/
         ICTzVOQ4TWjZCU/BNn2aNNXeBihhBisJ/wKvJEenZaEgXGCA21YacCH/o1Hm4pZeuJUO
         a19w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722034803; x=1722639603;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+O6rIP5ddPDwYqH7AORHrX49Sj0oJNOV55RUSW14M9o=;
        b=ngPKhl0Jqm5J5hnBVOWUyi2zPIz65qvV8TopX8hsR7ZNvki0CAPFOLUAmRm2Sd5/B3
         41YJAD3k1BCxfABBji72c4oSMRK2KVUYh5nVkIpsl/CzVMf2TGkumIV6vFNs3Dslg4q4
         bJ0Y5p8RnHFzb4Odf0jZTluba4xbXbLUEJ2XvG+AWEj19+bMKxgWJYHyYztcHMkfFGE4
         yOFGWs9MoDy7irt/BKO/iWY1U4XHJEUhodZ7VZYVYibxWxEBhdpXJNRbZvxI3gJgvXkj
         L2sOiyylsBdDI/nGZ/YT65AiNYEuSzrMRzwbxwkRXYbS8S/GxpxuFeAL/6PpgUYmsVJd
         WnhA==
X-Gm-Message-State: AOJu0YwN/8yll2Aw/+yWrGcgukKqCl8E+4PVL0dcM51WswVoNpN83PEA
	9KaTudwa585FazizptY2IYmQ2VhYv/4U+nUMlEGKJsblVhf0ugbMhekiZw==
X-Google-Smtp-Source: AGHT+IGrl0H883ybNatSc+zsQi5gREFyhf370651VwyixprBx/KrSf7w+72/F4GeWhCgKJa6gGjX8Q==
X-Received: by 2002:a05:6e02:12c7:b0:39a:eba6:6a07 with SMTP id e9e14a558f8ab-39aeba69492mr9196925ab.3.1722034803518;
        Fri, 26 Jul 2024 16:00:03 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70ead8834b1sm3308540b3a.178.2024.07.26.16.00.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2024 16:00:03 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 3/8] lpfc: Validate hdwq pointers before dereferencing in reset/errata paths
Date: Fri, 26 Jul 2024 16:15:07 -0700
Message-Id: <20240726231512.92867-4-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240726231512.92867-1-justintee8345@gmail.com>
References: <20240726231512.92867-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the HBA is undergoing a reset or is handling an errata event, NULL ptr
dereference crashes may occur in routines such as lpfc_sli_flush_io_rings,
lpfc_dev_loss_tmo_callbk, or lpfc_abort_handler.

Add NULL ptr checks before dereferencing hdwq pointers that may have been
freed due to operations colliding with a reset or errata event handler.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c |  3 ++-
 drivers/scsi/lpfc/lpfc_scsi.c    | 13 +++++++++++--
 drivers/scsi/lpfc/lpfc_sli.c     | 11 +++++++++++
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 6943f6c6395c..f21c5993e8d7 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -175,7 +175,8 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 			 ndlp->nlp_state, ndlp->fc4_xpt_flags);
 
 	/* Don't schedule a worker thread event if the vport is going down. */
-	if (test_bit(FC_UNLOADING, &vport->load_flag)) {
+	if (test_bit(FC_UNLOADING, &vport->load_flag) ||
+	    !test_bit(HBA_SETUP, &phba->hba_flag)) {
 		spin_lock_irqsave(&ndlp->lock, iflags);
 		ndlp->rport = NULL;
 
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 98ce9d97a225..60cd60ebff38 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5555,11 +5555,20 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 
 	iocb = &lpfc_cmd->cur_iocbq;
 	if (phba->sli_rev == LPFC_SLI_REV4) {
-		pring_s4 = phba->sli4_hba.hdwq[iocb->hba_wqidx].io_wq->pring;
-		if (!pring_s4) {
+		/* if the io_wq & pring are gone, the port was reset. */
+		if (!phba->sli4_hba.hdwq[iocb->hba_wqidx].io_wq ||
+		    !phba->sli4_hba.hdwq[iocb->hba_wqidx].io_wq->pring) {
+			lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
+					 "2877 SCSI Layer I/O Abort Request "
+					 "IO CMPL Status x%x ID %d LUN %llu "
+					 "HBA_SETUP %d\n", FAILED,
+					 cmnd->device->id,
+					 (u64)cmnd->device->lun,
+					 test_bit(HBA_SETUP, &phba->hba_flag));
 			ret = FAILED;
 			goto out_unlock_hba;
 		}
+		pring_s4 = phba->sli4_hba.hdwq[iocb->hba_wqidx].io_wq->pring;
 		spin_lock(&pring_s4->ring_lock);
 	}
 	/* the command is in process of being cancelled */
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index d240bbded4c8..332b8d2348e9 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4687,6 +4687,17 @@ lpfc_sli_flush_io_rings(struct lpfc_hba *phba)
 	/* Look on all the FCP Rings for the iotag */
 	if (phba->sli_rev >= LPFC_SLI_REV4) {
 		for (i = 0; i < phba->cfg_hdw_queue; i++) {
+			if (!phba->sli4_hba.hdwq ||
+			    !phba->sli4_hba.hdwq[i].io_wq) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+						"7777 hdwq's deleted %lx "
+						"%lx %x %x\n",
+						phba->pport->load_flag,
+						phba->hba_flag,
+						phba->link_state,
+						phba->sli.sli_flag);
+				return;
+			}
 			pring = phba->sli4_hba.hdwq[i].io_wq->pring;
 
 			spin_lock_irq(&pring->ring_lock);
-- 
2.38.0

