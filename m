Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830CA289E0B
	for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 17:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757957965; cv=none; b=N7zzGhhMPf0m89RVjE8XM5PeC9ZIAp7ZvuI553ystzh9hjs5wulC1EA2eK3pWrMT7qlyIIl7hwLOWyH4QVaJwbl7AHrw/04dBEDL4dOVkmVE0NOQebuoa5uzL43Gwlw0+f7Mb3sePY17GxSymVfqJXigZAXrxU2mXDWpEE5V6Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757957965; c=relaxed/simple;
	bh=my0VLD+q8a/T6KeK9RBNW0DO9PGCCgXbybXIYyaRgfE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FYrmpIQvRmcDati2nezkfMAet5rO4Ocv2FB49SPXTGZImIyPXxLtB8ZIHeO/BEFLVK56rwgaV6FytzN/P6q4iNv6DwhszdXFeiu6YyFDXmyzQuwjp8i2Oi4xsi3Z96TmGbRpQ/bOV/LguJWdi2vj5tmKFntDdG2Ye+u925PY87c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NS4+ztYM; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NS4+ztYM"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-82a334e379eso72597185a.3
        for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 10:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757957962; x=1758562762; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0rGpDa1iH/cPAXy/F0fsjliYFREHQyVySB7agCIXvUw=;
        b=NS4+ztYMaMBGCFDmN8CbRUAC5bWJCyU9PF54i7+bP63qfwDOGVHcwQowR0S6lXG3f9
         HdcWk/HXNPkwSZQeVTundcL2EtVOi/4r+MgWHUYNkW1pBQBEEi0z5uJ7+E5p53kq1RL1
         XVy4W5Q8C3PKSXjP2/f9hP6xssYBirADortYnHOC/W/WSbKx4gEOxkA1zbkZCE2nl6pw
         D+tiILvQX1O1bUCuICbxsT5gYaAm8Hp8OeBZ00qXmCheH/xzLF2ezn0lWLNQq85f7UxV
         WsSJo+a6aRDqwER1XItccyB25POga4e7afAJZs/7PTgKwY6l+w19J4570k1A2nuQFB0c
         RfkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757957962; x=1758562762;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0rGpDa1iH/cPAXy/F0fsjliYFREHQyVySB7agCIXvUw=;
        b=vfuYP1CrvB4+IyYxefIMuPrbs/7R0d9Ut/nlWhLoJkuXHJkoUoaQe8b6WwAXtxvriq
         C7m7sFkLNiAsmfCp/f9RMBVQ3r6vKsHix1eJx0ByeICwEerY5+nh58c1MJCBh5SI8FMt
         mjQQ+x5zOSzY1e8oo0b7anVWI87jWPSAA+5c1EzQafyVdpiGU0h2dq2+/4shv5T5gM+Y
         fDiLPYG5HBCMoMfNo0pgnGAKZK4E8q2MNqxeJxtvknW/iifUrq9zUyZehAMMKQ2VpKqB
         3mqFHYVLdwhJZEWBTTylNLdcjriW022rnfwRdtMA/1YFWdzteyjJowEY3aau4evbcv9q
         6MTg==
X-Gm-Message-State: AOJu0Yzo77S6A/jBTS2N5HSx/VnJ/2idq4/cHFnJrPqSTcsX1CvsprOX
	Fugiysqy1r8yHWngIdE8pKeDT+lcj1dlBb8EsJ4vd96ghnjA5da/svUiYivf8w==
X-Gm-Gg: ASbGncsM3CW8zCWhSFilsLO/NZtjotiXGpzK9Klm5OEI8UbncA3g1fsIS2XPDYIjVmC
	O0AHQXnMNsz/Rx6UK7A8slLjIKiZDcykomwaKdrHiuPZiC+AdjwCfBd9R3UOq2smtGGqqgxzSoZ
	1JbDxbAHXTry3rMg1T9r5JAlDGQuUgUtdJLvuscoIFdHtdKbKENy1yVBIrvj3RFipMmhwhJBCdf
	rbt1tFaFDvPkDL9DjXf6sMjHrKE8ToZ6Lt6yznX7Of/u9O7JXFF8IKJTG3i9FkuuAkZPF6dd5FP
	LWWEdPQa9YhSGUEfJppzNIdXdQhjPEcVZbXsi+fyTxINzuWW9T/5UN2d3LzAzsot+G1q2HKnYDI
	8q2ys2qVgyjKcP5iWW+OiZfICbYor2aR7pHvhlckvYW8Le4MXEOOt6HJAQbrrNS5mksUce7wJfS
	KF9ZnY7MNjPSnwzvPh0A==
X-Google-Smtp-Source: AGHT+IEzHTVhAZ8VIsmHWzFu8KAfIv5qX6eow4TvXoxkAknACoFb+PJV8qj1/ikwInDKom3bW1OTRQ==
X-Received: by 2002:a05:6214:5192:b0:775:1d3:d07f with SMTP id 6a1803df08f44-77501d3d241mr80664216d6.11.1757957961961;
        Mon, 15 Sep 2025 10:39:21 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-77ef70bcc4esm29710976d6.41.2025.09.15.10.39.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Sep 2025 10:39:21 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 07/14] lpfc: Ensure PLOGI_ACC is sent prior to PRLI in Point to Point topology
Date: Mon, 15 Sep 2025 11:08:04 -0700
Message-Id: <20250915180811.137530-8-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20250915180811.137530-1-justintee8345@gmail.com>
References: <20250915180811.137530-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a timing race condition when a PRLI may be sent on the wire before
PLOGI_ACC in Point to Point topology.  Fix by deferring REG_RPI mbox
completion handling to after PLOGI_ACC's CQE completion.  Because the
discovery state machine only sends PRLI after REG_RPI mbox completion, PRLI
is now guaranteed to be sent after PLOGI_ACC.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c       | 10 +++++++---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 23 ++++++++++++++++++-----
 2 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 5ac2d5f9151c..b71db7d7d747 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5339,12 +5339,12 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		ulp_status, ulp_word4, did);
 	/* ELS response tag <ulpIoTag> completes */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
-			 "0110 ELS response tag x%x completes "
+			 "0110 ELS response tag x%x completes fc_flag x%lx"
 			 "Data: x%x x%x x%x x%x x%lx x%x x%x x%x %p %p\n",
-			 iotag, ulp_status, ulp_word4, tmo,
+			 iotag, vport->fc_flag, ulp_status, ulp_word4, tmo,
 			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
 			 ndlp->nlp_rpi, kref_read(&ndlp->kref), mbox, ndlp);
-	if (mbox) {
+	if (mbox && !test_bit(FC_PT2PT, &vport->fc_flag)) {
 		if (ulp_status == 0 &&
 		    test_bit(NLP_ACC_REGLOGIN, &ndlp->nlp_flag)) {
 			if (!lpfc_unreg_rpi(vport, ndlp) &&
@@ -5403,6 +5403,10 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		}
 out_free_mbox:
 		lpfc_mbox_rsrc_cleanup(phba, mbox, MBOX_THD_UNLOCKED);
+	} else if (mbox && test_bit(FC_PT2PT, &vport->fc_flag) &&
+		   test_bit(NLP_ACC_REGLOGIN, &ndlp->nlp_flag)) {
+		lpfc_mbx_cmpl_reg_login(phba, mbox);
+		clear_bit(NLP_ACC_REGLOGIN, &ndlp->nlp_flag);
 	}
 out:
 	if (ndlp && shost) {
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index a596b80d03d4..3799bdf2f1b8 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -326,8 +326,14 @@ lpfc_defer_plogi_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *login_mbox)
 		/* Now that REG_RPI completed successfully,
 		 * we can now proceed with sending the PLOGI ACC.
 		 */
-		rc = lpfc_els_rsp_acc(login_mbox->vport, ELS_CMD_PLOGI,
-				      save_iocb, ndlp, NULL);
+		if (test_bit(FC_PT2PT, &ndlp->vport->fc_flag)) {
+			rc = lpfc_els_rsp_acc(login_mbox->vport, ELS_CMD_PLOGI,
+					      save_iocb, ndlp, login_mbox);
+		} else {
+			rc = lpfc_els_rsp_acc(login_mbox->vport, ELS_CMD_PLOGI,
+					      save_iocb, ndlp, NULL);
+		}
+
 		if (rc) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 					"4576 PLOGI ACC fails pt2pt discovery: "
@@ -335,9 +341,16 @@ lpfc_defer_plogi_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *login_mbox)
 		}
 	}
 
-	/* Now process the REG_RPI cmpl */
-	lpfc_mbx_cmpl_reg_login(phba, login_mbox);
-	clear_bit(NLP_ACC_REGLOGIN, &ndlp->nlp_flag);
+	/* If this is a fabric topology, complete the reg_rpi and prli now.
+	 * For Pt2Pt, the reg_rpi and PRLI are deferred until after the LS_ACC
+	 * completes.  This ensures, in Pt2Pt, that the PLOGI LS_ACC is sent
+	 * before the PRLI.
+	 */
+	if (!test_bit(FC_PT2PT, &ndlp->vport->fc_flag)) {
+		/* Now process the REG_RPI cmpl */
+		lpfc_mbx_cmpl_reg_login(phba, login_mbox);
+		clear_bit(NLP_ACC_REGLOGIN, &ndlp->nlp_flag);
+	}
 	kfree(save_iocb);
 }
 
-- 
2.38.0

