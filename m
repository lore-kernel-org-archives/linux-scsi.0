Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E321DE89B
	for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2024 23:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734045288; cv=none; b=PhuEa87+eyJQjWGj8eaATf1uvHD58Bvh9QGdVzrQprlyppc+SwJjLcfwo0aKzQhgwdiiByKvsVfbhugj66Q2K6xaRPN78URxWzSaBQywtd832OqX75lWoJmZRNO8ostSOntn03LLbrFc128NooOUvs15lzBSjfLLslC3NyvYx/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734045288; c=relaxed/simple;
	bh=s/NRhH7EcuHFvDmZYPPrOAxpo0Kj9bxVsFXAiJpaiPM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=R8FG6E+9QOwiohCZdiM85E8I12WeOsv85xNun7A7TDRmRXTW8vk3+OazHKmCJal6qXPZKYzcCGgjnxObOVgzHuX2DSHfnjVJ57DX8+7KbUemko4gHWIgaW+3jHnn8oVnGiOgA0MGBj0U9HHMQ0lyVPe7NaNdp8kcGlRtvjgyZU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KzcnBnY4; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KzcnBnY4"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2163bd70069so11966545ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2024 15:14:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734045286; x=1734650086; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=msb7H6YpNqhqS3i3C8VSQeTs1vnGuAB686qyJ7Ilrik=;
        b=KzcnBnY4FW7BiCRkbPYvdUmKV+G1TFobXVC3QvnB+Df7BAP7XD2Bor3G+0D0ZwMfw3
         xRrofhCiaQUo0bc4PQkcBkZK/evGtRxbnhiniOXlYX45BvqB8nYXEbSCUC2294suBD67
         Q1DViU1KwvtrNcwL2pG3C8++NsEVtC/GosQSvQppZVi4CYFZPyljXmWY2Nuo2IpalE0W
         ymYbZ7Zh14AOZbefnj9W/H+zKegb9YFnVMUbGXktQ0n4ccQLroFMwnioUqXyBMVDi7uo
         B9Ke9WgzQ34/UNwb3wwzifYuYN/Ncnkl4qiCXqGONvMOkOR8Jhc2MwuOErI6qE9ZLJWC
         /Uag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734045286; x=1734650086;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=msb7H6YpNqhqS3i3C8VSQeTs1vnGuAB686qyJ7Ilrik=;
        b=XWMgP7r4KMqd6VNZMOVbZ9xAxtww5fv3oR3DlZ/3tGLJ5Dr+jfscgBFtcoMvws+a/D
         /Wl69rsaqLLV3IRYZfPv3DEyjTqJpkVQQ5Ai+7LJtZ3fn1pgw7MKo76mu65MRrWSE0Hm
         eJN0Rja8TQ5+Z3Jb8OgbFJz6DfnJGlE7Sk/o66mfavp/hnCUl2sG4SRX/Kw+jeqRhuQy
         moyIcEMy6BYiI0eRCofoUoxFuOLb2IiUMtpQlGFX+KUxbmobYGH7QXHm6FrIndzCu5QN
         N/qkAQ9QQkaupMVcP/hndwnEu2E7OLc7Q5LzBNk49mgoKbCPkMJXPIXCiPJdT1WjVJbP
         aEug==
X-Gm-Message-State: AOJu0Yw61LsM6kCSZaiNw9k8JmfBEXKGeMHwW9rMKjFrPqA2xEhzt3RJ
	eFDnaNyfDk4fzwDjrohilkyPaGWR82OtThngItAEkt4mnFLLNH4XqGyXow==
X-Gm-Gg: ASbGncsungeN/jfO24kbpUNAwnkAHvq6qdKCFMrJhdZVu3lWN/RfD+4QDlXAUl2r4fa
	k/ARCkoKRsCe4sQ7ZgQmKKNpmAjYYSEnIsXPWdIciS1Bt8JbCcUrS2f5KS+VGuYUpPylsCfAzCT
	ncnQ9DcQ+uQxZkLMA/oh8Dd0SZl+eOARGU2nFh31q2EKiGBQw5n+cIUZVTYfWofFi65ocNjeBcq
	571NVucErnfmGpLgx3Ej8xDn0nKh1CMXRstj9hu4E+0lZvFKq8h9LV4Gq3G7RHskFBMgmoznDb7
	dI7T5+sdsFV2pe9hT1qy8RiD+lTlHmQKRwxvSAqwgw==
X-Google-Smtp-Source: AGHT+IHTjH6jXGgzNP5BxRAxPs5iUgXkRhMN7KmLk4Hm3Y6yOTYnogh7Dp5/AQi6tn77zC7FSDKLCg==
X-Received: by 2002:a17:902:d492:b0:216:50c6:6b47 with SMTP id d9443c01a7336-21892a510d5mr7581015ad.46.1734045286257;
        Thu, 12 Dec 2024 15:14:46 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-216325f51d6sm92727875ad.197.2024.12.12.15.14.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Dec 2024 15:14:45 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 03/10] lpfc: Delete NLP_TARGET_REMOVE flag due to obsolete usage
Date: Thu, 12 Dec 2024 15:33:02 -0800
Message-Id: <20241212233309.71356-4-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20241212233309.71356-1-justintee8345@gmail.com>
References: <20241212233309.71356-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the NLP_TARGET_REMOVE flag as its usage is obsolete.  The current
framework is to rely on the lpfc_dev_loss_tmo_callbk from upper layer to
notify final ndlp kref release.  There's no need to specifically set
NLP_EVT_DEVICE_RM when a LOGO completes.  The dev_loss_tmo_callbk is
responsible for the final kref put.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_disc.h      |  1 -
 drivers/scsi/lpfc/lpfc_els.c       | 17 +----------------
 drivers/scsi/lpfc/lpfc_nportdisc.c | 10 ++++++----
 3 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index 3e173b5d00e0..81cfa35dab98 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -208,7 +208,6 @@ enum lpfc_nlp_flag {
 					   NPR list */
 	NLP_RM_DFLT_RPI    = 26,        /* need to remove leftover dflt RPI */
 	NLP_NODEV_REMOVE   = 27,        /* Defer removal till discovery ends */
-	NLP_TARGET_REMOVE  = 28,        /* Target remove in process */
 	NLP_SC_REQ         = 29,        /* Target requires authentication */
 	NLP_FIRSTBURST     = 30,        /* Target supports FirstBurst */
 	NLP_RPI_REGISTERED = 31         /* nlp_rpi is valid */
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 37f0a930d469..842b67e37f10 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3035,19 +3035,6 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	/* Call state machine. This will unregister the rpi if needed. */
 	lpfc_disc_state_machine(vport, ndlp, cmdiocb, NLP_EVT_CMPL_LOGO);
 
-	if (skip_recovery)
-		goto out;
-
-	/* The driver sets this flag for an NPIV instance that doesn't want to
-	 * log into the remote port.
-	 */
-	if (test_bit(NLP_TARGET_REMOVE, &ndlp->nlp_flag)) {
-		clear_bit(NLP_NPR_2B_DISC, &ndlp->nlp_flag);
-		lpfc_disc_state_machine(vport, ndlp, cmdiocb,
-					NLP_EVT_DEVICE_RM);
-		goto out_rsrc_free;
-	}
-
 out:
 	/* At this point, the LOGO processing is complete. NOTE: For a
 	 * pt2pt topology, we are assuming the NPortID will only change
@@ -3091,7 +3078,7 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 					NLP_EVT_DEVICE_RM);
 	}
-out_rsrc_free:
+
 	/* Driver is done with the I/O. */
 	lpfc_els_free_iocb(phba, cmdiocb);
 	lpfc_nlp_put(ndlp);
@@ -10411,8 +10398,6 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			}
 		}
 
-		clear_bit(NLP_TARGET_REMOVE, &ndlp->nlp_flag);
-
 		lpfc_disc_state_machine(vport, ndlp, elsiocb,
 					NLP_EVT_RCV_PLOGI);
 
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 4d88cfe71cae..71c76d90e8e7 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -2255,11 +2255,13 @@ lpfc_cmpl_prli_prli_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	    (vport->port_type == LPFC_NPIV_PORT) &&
 	     vport->cfg_restrict_login) {
 out:
-		set_bit(NLP_TARGET_REMOVE, &ndlp->nlp_flag);
+		lpfc_printf_vlog(vport, KERN_INFO,
+				 LOG_ELS | LOG_DISCOVERY | LOG_NODE,
+				 "6228 Sending LOGO, determined nlp_type "
+				 "0x%x nlp_flag x%lx refcnt %u\n",
+				 ndlp->nlp_type, ndlp->nlp_flag,
+				 kref_read(&ndlp->kref));
 		lpfc_issue_els_logo(vport, ndlp, 0);
-
-		ndlp->nlp_prev_state = NLP_STE_PRLI_ISSUE;
-		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 		return ndlp->nlp_state;
 	}
 
-- 
2.38.0

