Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02886167A
	for <linux-scsi@vger.kernel.org>; Tue,  5 Mar 2024 19:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709668158; cv=none; b=gRMRc50qiI6yAMBf2ERejZwHOFDow1U7qNCYVUBeOg//50iMs6DQwMZmGwMnVA52Uc10SHft6dIVdir5wUQgaCVmuXT1RPc91Vsk5OXv2w9FNQsYmn+e7gANL/Tq5cvKDxYWk76DxxUQzKvggWwAmUieKgorRAGyyVOQwLplsgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709668158; c=relaxed/simple;
	bh=AfN5QbEBeqvmDY+2mBdAE6ZASpjRrWBwgPPsdfLvXBA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iCH7AJ6LaQOcJ266Tc4WHSx9252sHlQuuB22j25GngObQkbuw3e14d+dDMh5y4piMI/bBcvslEykMfO4MdpQS8OrR2YcFbLr/sSi5mKGtTe+x7HqrvnjZOMIU+xmFs6poioTN+nn/HQqMi0N8Rb2scoSsUoQJ4AHORSSsc5ZDLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SjR2IpUM; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SjR2IpUM"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-68fcd9d336bso9336616d6.1
        for <linux-scsi@vger.kernel.org>; Tue, 05 Mar 2024 11:49:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709668155; x=1710272955; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xEzLi8BIN57DkelYQfY/4ZqdVXOwxA9iYIklXp//HFo=;
        b=SjR2IpUMxNy+/lhmvWFv09R/eVxbUnzrcDCZm0EYR0VGEYbIcdOWhe4hZyGmfJ4wZH
         qyatJPP78gpN27UqgWQPJxWk+WzJa4VGZqDGF8mdBhrtNXFMOGwAACAkVtZeID100gaw
         YDgXBInql2MdDs3rl/PuFG+su13r4NMHB2Q3i0qMmowmnwN0v9ThohRr8yCzHlqT0PQW
         2NDSk9mlhex9N3J9qEQFsVLiboN3LoPcCfr0KiDzKM1UaYg0PGvOarWS93RWp9fdPQn4
         VeR19eXO/nVuxefACjmqnKdO8OBZoHML4Wt3K0xQpcuZRSQvf50hxEvDMCSKsiFPoskj
         5Gpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709668155; x=1710272955;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xEzLi8BIN57DkelYQfY/4ZqdVXOwxA9iYIklXp//HFo=;
        b=MrFlpVV0+irAB6yrn2A7JcRFK4Bx4ohCtdJuWdEKOElDv/XtE1gD9o0PvhTZUJRudL
         gkXdTACQJckBPfwqCWEt50GK2k7ZARzrqNPya6eDYHf20DMQTANMaNECN9stbFtEdcvI
         6/kug0lsGRjXVzAeVcVJ7mYpTLNN/+uUJIRgSoJCAACqW8uRkmN6u/FEUWGSzRclP3Yz
         UE3FoGpA4hooQeQQduQfDAcvHBaMBYVnmciSD8x1stTF+DQZe+mHUxrWyyB3UFp3AMIu
         +8nPd8XjvAD8hbAw30257uQa5q/aFqNCO8BhR9NHC8VFKFaRU95RcI6/EIM9LKSpEmRV
         ZsVw==
X-Gm-Message-State: AOJu0Yz2vGf+oeL1HkagcLNAzCe/uk/FQ+WejFEqE2EEzvoL5j4WNZKC
	5DZDeHASX0w8xjGpgBmivDzllk0cVjY5l2fVhPeyphNTHBW4rpaeMtnufhxX
X-Google-Smtp-Source: AGHT+IHhsAmlFynP/AiPJtKyepj9fobN7UQb5DR6vPHily8hMLMoMQ4Dfve1V2bF3ttz+sJrpTnRaQ==
X-Received: by 2002:a05:620a:4150:b0:787:f4bf:507e with SMTP id k16-20020a05620a415000b00787f4bf507emr1378144qko.4.1709668155553;
        Tue, 05 Mar 2024 11:49:15 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bj13-20020a05620a190d00b007877f52a6b9sm5706050qkb.136.2024.03.05.11.49.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Mar 2024 11:49:15 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 06/12] lpfc: Release hbalock before calling lpfc_worker_wake_up
Date: Tue,  5 Mar 2024 12:04:57 -0800
Message-Id: <20240305200503.57317-7-justintee8345@gmail.com>
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

lpfc_worker_wake_up calls the lpfc_work_done routine, which takes the
hbalock.  Thus, lpfc_worker_wake_up should not be called while holding the
hbalock to avoid potential deadlock.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c     | 20 ++++++++++----------
 drivers/scsi/lpfc/lpfc_hbadisc.c |  5 ++---
 drivers/scsi/lpfc/lpfc_sli.c     | 14 +++++++-------
 3 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 28e56542e072..157a910666db 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4437,23 +4437,23 @@ lpfc_els_retry_delay(struct timer_list *t)
 	unsigned long flags;
 	struct lpfc_work_evt  *evtp = &ndlp->els_retry_evt;
 
+	/* Hold a node reference for outstanding queued work */
+	if (!lpfc_nlp_get(ndlp))
+		return;
+
 	spin_lock_irqsave(&phba->hbalock, flags);
 	if (!list_empty(&evtp->evt_listp)) {
 		spin_unlock_irqrestore(&phba->hbalock, flags);
+		lpfc_nlp_put(ndlp);
 		return;
 	}
 
-	/* We need to hold the node by incrementing the reference
-	 * count until the queued work is done
-	 */
-	evtp->evt_arg1  = lpfc_nlp_get(ndlp);
-	if (evtp->evt_arg1) {
-		evtp->evt = LPFC_EVT_ELS_RETRY;
-		list_add_tail(&evtp->evt_listp, &phba->work_list);
-		lpfc_worker_wake_up(phba);
-	}
+	evtp->evt_arg1 = ndlp;
+	evtp->evt = LPFC_EVT_ELS_RETRY;
+	list_add_tail(&evtp->evt_listp, &phba->work_list);
 	spin_unlock_irqrestore(&phba->hbalock, flags);
-	return;
+
+	lpfc_worker_wake_up(phba);
 }
 
 /**
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index a7a2309a629f..2ab51397f4a6 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -257,7 +257,9 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 		if (evtp->evt_arg1) {
 			evtp->evt = LPFC_EVT_DEV_LOSS;
 			list_add_tail(&evtp->evt_listp, &phba->work_list);
+			spin_unlock_irqrestore(&phba->hbalock, iflags);
 			lpfc_worker_wake_up(phba);
+			return;
 		}
 		spin_unlock_irqrestore(&phba->hbalock, iflags);
 	} else {
@@ -275,10 +277,7 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 			lpfc_disc_state_machine(vport, ndlp, NULL,
 						NLP_EVT_DEVICE_RM);
 		}
-
 	}
-
-	return;
 }
 
 /**
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 1f8a9b5945cb..030d7084e412 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1217,9 +1217,9 @@ lpfc_set_rrq_active(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
 	empty = list_empty(&phba->active_rrq_list);
 	list_add_tail(&rrq->list, &phba->active_rrq_list);
 	phba->hba_flag |= HBA_RRQ_ACTIVE;
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
 	if (empty)
 		lpfc_worker_wake_up(phba);
-	spin_unlock_irqrestore(&phba->hbalock, iflags);
 	return 0;
 out:
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
@@ -11373,18 +11373,18 @@ lpfc_sli_post_recovery_event(struct lpfc_hba *phba,
 	unsigned long iflags;
 	struct lpfc_work_evt  *evtp = &ndlp->recovery_evt;
 
+	/* Hold a node reference for outstanding queued work */
+	if (!lpfc_nlp_get(ndlp))
+		return;
+
 	spin_lock_irqsave(&phba->hbalock, iflags);
 	if (!list_empty(&evtp->evt_listp)) {
 		spin_unlock_irqrestore(&phba->hbalock, iflags);
+		lpfc_nlp_put(ndlp);
 		return;
 	}
 
-	/* Incrementing the reference count until the queued work is done. */
-	evtp->evt_arg1  = lpfc_nlp_get(ndlp);
-	if (!evtp->evt_arg1) {
-		spin_unlock_irqrestore(&phba->hbalock, iflags);
-		return;
-	}
+	evtp->evt_arg1 = ndlp;
 	evtp->evt = LPFC_EVT_RECOVER_PORT;
 	list_add_tail(&evtp->evt_listp, &phba->work_list);
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
-- 
2.38.0

