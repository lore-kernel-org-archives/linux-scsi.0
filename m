Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A704721ADC5
	for <linux-scsi@vger.kernel.org>; Fri, 25 Apr 2025 19:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745609085; cv=none; b=RkKCPEnAWhOTxciRuttVe6HV8TTNJ+WKpLJQiFjDVXKadICMUwQeBGuZKbRBK0Xesp+e4QBj83VaCCZBDJicsfd2DVU39rENEWkdH1zyHXMA5/v9z86TRTQhqrcyknkjRTKrF/uKsztvOibr7sGtTL8BDkRI7+0i8PeIkX7bWNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745609085; c=relaxed/simple;
	bh=SKcQXw3TEpKg9fS4Jd5h/Yk5CCj25c6HT0/68V7s9mg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rgjkSRcRwoUFjEh2BDTctKO0p1jyFTLfa2MqWTvCWq0baNuXw4aM0Qwobf145mjyxc5qwAS7Sst+w2ZBMiDaCf0D6FCVScyvi3nruj0jUrLSyooV9+6T76/F55dBJiJ+wXnbCeoZFjFqQoliIODvDM3bSFthEXMliEyNfbA1Row=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tyf8RU+S; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tyf8RU+S"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-7fd581c2bf4so2264522a12.3
        for <linux-scsi@vger.kernel.org>; Fri, 25 Apr 2025 12:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745609083; x=1746213883; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=djBgvnc3DnRXFBZxSetoKim+sDd+gwp3LdwHt7uNBS8=;
        b=Tyf8RU+SzckETwb/dAsQ5Q1ydub8j/cNCPFW+MgmxkvyDVT354rpenAML08Jf39rzs
         sWqUiTiGlTuSddBnby/KA99WBcCfnkkrikKtcMI2dRnn+Gu7T0sbERgYbRoRzuEEl8Y9
         UnE5aOfPQJWfUr93HHi6aqehWoUwm9NDAXTEpKN5kjxEDGHSxxe75p0g3U/d7ZpdelE9
         gXZgOik91b5quXdvH2Htp2AygldNwiEMRacqb0pE3bd32Zr62YR0B2U/iIGtmalp0yTp
         S0zk2vsH3kLV1rElHH6cfzVSFk65WsATy6dGWt5si+HPpuxJfdZD4KyCZD5ZyqPx2eBQ
         sAOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745609083; x=1746213883;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=djBgvnc3DnRXFBZxSetoKim+sDd+gwp3LdwHt7uNBS8=;
        b=D8CDGI5xdrGPW6Q1Ju9PAhn27T3W2yI0GrkL+poihj970uE+FNS6DcoybjZvntp4xI
         aL8LIk+nt+Vqqr2+o2z+33h0N3lfNYwWOey6p7bT7DCjhbbx2XNGE+JUYPFV9UJa4KH0
         uNSDOW4ytYxAPmBIDo5DMw8ht8oV41dtS8pE0e1/N5qZgyDXywPh5rmPzyDZKdBXzKen
         V73Mc3MfRXCVnip2Sh4d3SPCHxSUONDD6wECvN/wrybaeLK3CEPBTqSQjaeY8dM5zcWG
         l8J9dY03J6L6AoenMIGcRAaD+vv9BcogFv09juLkEPVV47xoAhgmiqeVYa9sOjWTSjKM
         Bupw==
X-Gm-Message-State: AOJu0YyDfF65UPpZC58oQI9SFcPHcFxS5749wZzT0UrmBhNxRK4dISNM
	B6NFlxwmHthMlRvbfGwyIPl5YEbFahto31GOOJz2rybx3sXlumDPCXeDxA==
X-Gm-Gg: ASbGncsXj9gbil76Gwzu2hXrJFBIvA5Gyqn2YvVyh0WXYEKUKN7z9SPNnZQm/UTaHXZ
	M4Eyc17Ql3kqzZGiDPweUcaRaDv7O10+UD7/1ADzcLJX4XbX5wWHqvuMJ3nAUTE1llDY8rDMdT2
	DUIASsqd66tMBYzRhQQgUljVoz/jwAE5uVh7IBwWnZ2YNUpIU2nzSvewio3RCrxMZOJfs3/liDx
	KdOFEbaoUYPds0d0VE3BIbQ67NEjNoZ4eNAYDNIppyBQ3q0kzBZX0VEdERMIE1rMenthGCiFPod
	pwed/1jWa8IPzHKgcWNo2sbVHWFyE/XU0NMRJUNa8MP+G4UudUPwW5e2SEN0CcMJWL+BmZJoKPr
	QC2ajr4eks1AhorccvZvkO2aHsA==
X-Google-Smtp-Source: AGHT+IE6ggYd0BY/hFHuOTGSfX0+RkFBzmMB3cLih/6bSlmTvvuJHCw/7zD7IAA2VT1uBT2cnvWimQ==
X-Received: by 2002:a05:6a20:d490:b0:1f5:7ba7:69d7 with SMTP id adf61e73a8af0-2045b69735fmr4733394637.3.1745609082870;
        Fri, 25 Apr 2025 12:24:42 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73e25a6a649sm3667513b3a.109.2025.04.25.12.24.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Apr 2025 12:24:42 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH 5/8] lpfc: Avoid potential ndlp use-after-free in dev_loss_tmo_callbk
Date: Fri, 25 Apr 2025 12:48:03 -0700
Message-Id: <20250425194806.3585-6-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20250425194806.3585-1-justintee8345@gmail.com>
References: <20250425194806.3585-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Smatch detected a potential use-after-free of an ndlp oject in
dev_loss_tmo_callbk during driver unload or fatal error handling.

Fix by reordering code to avoid potential use-after-free if initial
nodelist reference has been previously removed.

Fixes: 4281f44ea8bf ("scsi: lpfc: Prevent NDLP reference count underflow in dev_loss_tmo callback")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/linux-scsi/41c1d855-9eb5-416f-ac12-8b61929201a3@stanley.mountain/
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 9e585af05bec..3d15a964f5c9 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -161,7 +161,7 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 	struct lpfc_hba   *phba;
 	struct lpfc_work_evt *evtp;
 	unsigned long iflags;
-	bool nvme_reg = false;
+	bool drop_initial_node_ref = false;
 
 	ndlp = ((struct lpfc_rport_data *)rport->dd_data)->pnode;
 	if (!ndlp)
@@ -188,8 +188,13 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 		spin_lock_irqsave(&ndlp->lock, iflags);
 		ndlp->rport = NULL;
 
-		if (ndlp->fc4_xpt_flags & NVME_XPT_REGD)
-			nvme_reg = true;
+		/* Only 1 thread can drop the initial node reference.
+		 * If not registered for NVME and NLP_DROPPED flag is
+		 * clear, remove the initial reference.
+		 */
+		if (!(ndlp->fc4_xpt_flags & NVME_XPT_REGD))
+			if (!test_and_set_bit(NLP_DROPPED, &ndlp->nlp_flag))
+				drop_initial_node_ref = true;
 
 		/* The scsi_transport is done with the rport so lpfc cannot
 		 * call to unregister.
@@ -200,13 +205,16 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 			/* If NLP_XPT_REGD was cleared in lpfc_nlp_unreg_node,
 			 * unregister calls were made to the scsi and nvme
 			 * transports and refcnt was already decremented. Clear
-			 * the NLP_XPT_REGD flag only if the NVME Rport is
+			 * the NLP_XPT_REGD flag only if the NVME nrport is
 			 * confirmed unregistered.
 			 */
-			if (!nvme_reg && ndlp->fc4_xpt_flags & NLP_XPT_REGD) {
-				ndlp->fc4_xpt_flags &= ~NLP_XPT_REGD;
+			if (ndlp->fc4_xpt_flags & NLP_XPT_REGD) {
+				if (!(ndlp->fc4_xpt_flags & NVME_XPT_REGD))
+					ndlp->fc4_xpt_flags &= ~NLP_XPT_REGD;
 				spin_unlock_irqrestore(&ndlp->lock, iflags);
-				lpfc_nlp_put(ndlp); /* may free ndlp */
+
+				/* Release scsi transport reference */
+				lpfc_nlp_put(ndlp);
 			} else {
 				spin_unlock_irqrestore(&ndlp->lock, iflags);
 			}
@@ -214,14 +222,8 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 			spin_unlock_irqrestore(&ndlp->lock, iflags);
 		}
 
-		/* Only 1 thread can drop the initial node reference.  If
-		 * another thread has set NLP_DROPPED, this thread is done.
-		 */
-		if (nvme_reg || test_bit(NLP_DROPPED, &ndlp->nlp_flag))
-			return;
-
-		set_bit(NLP_DROPPED, &ndlp->nlp_flag);
-		lpfc_nlp_put(ndlp);
+		if (drop_initial_node_ref)
+			lpfc_nlp_put(ndlp);
 		return;
 	}
 
-- 
2.38.0

