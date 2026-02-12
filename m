Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0F525B2F4
	for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 20:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770929734; cv=none; b=fjByHJy7Pu9vmaJTZMmGPF1Jq5UWxzXg7YE+R8TsBBFRufmFk27ori43Wu7r8/AWIBqFULGK9dOpEVIekjqF2qsEb5/bhQOInaAtTyxrtKiP850Dl0+nBqe11hbSBIo50GmKBNgFKYy2AnnFymr9SZAgXAhRiUmNPFWW2DVWfE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770929734; c=relaxed/simple;
	bh=244JjcWdNdUS9elFXqZVZpllGe6NA/AabwWsRH/KdEE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=thmj4gL9P23u4BYF3OLUv5sOvx2/faJ4ZoYbBpEdT0PUhEJkVXVfSBzGfWIBVwsJwud0xnx4jbu8SKZOHLa0MOEaN112gBcqNlCW26cNDWcvH1A+74eEfwSJDhrdM+2kDVDFvM7d9SQzIMUft2YNRsZPopvUz5qsf+ZdI7IKgmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fcgrhqim; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fcgrhqim"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-895071c5527so3516576d6.1
        for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 12:55:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770929732; x=1771534532; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a/5NhTXtIx7RFEyRRsvaYVKDcSeBSIOO/dxwybXxgew=;
        b=Fcgrhqim69hvG7MYG0TxTonG6lnAWwvLrxmCFGKmfi5B6W4veQb8Zd3jPWbdguor/l
         SeqoLQQaiZUtX/5rDtGIryMSX1BOFb0rwi+3FIdw884hg2UWn6kn1ex4VyQD2Oh3Mbk0
         BdepbM7qE8MhS7/YNArwZsSPB+3YevNSkYiD4RAEOtYc9BDG1DhWOE5xtVhGyukBHQBc
         1CyicIx3pckJvaqfqTanohFdp39bGowK9Rhjhh+iL6lACoCCBWmkczkSZRTCcIFSTluq
         AY9qTb+xNxQoeMtecqZedo+GoFqgdjO6YaJcv8br78SFJDasrYW56cEymeJsDZ3ZjQ2W
         7k3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770929732; x=1771534532;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=a/5NhTXtIx7RFEyRRsvaYVKDcSeBSIOO/dxwybXxgew=;
        b=T0kUshf1zXP5kOzKOqb9d72jG1I8IuaCsjhyrpjDDGajpfJzxxd8lbEwW5Aqf6nXeu
         beIvinBnS+4dGXmatNaXCFuzwCMbQ9CpBcsMfSQ8dhw0IwcswmbIuC8eJvpzHAYGsUZd
         G5bpCWHMm2pcVuwatnpxcQLRoj50IrCc0juM59OpWZ7CKF1CK5GfDGdo9HRF6JsGyjdu
         dLpzLdcFLexLUc7z+Tf8jtT4p4N95+VqdeIrevyR5JXGYnTTY9u0mHDWBFl5qIr/C4S4
         LPb3uJ2BzPBWsYbz5xwuh0iDl8p4TvrDp7T+rweXph9IEdqkvzrWs4tL2UgCy7yLQNfC
         pBzA==
X-Gm-Message-State: AOJu0Yy/P7Q8caamHQVFep+rd23PF8qzkvl6ywyP1cVQ8wQG2muT0T5Z
	Ynh6Ckhjh9vYvp4SqsxJ0WRXKvB/oz4s9wqjB26rmTubfWR7/4Q5q9+qRxJMeIW9
X-Gm-Gg: AZuq6aI3BFtCSCWESJisz+VaKBx512rCsWSWk1S7eaEXe11gKASOKlxRmCrsLw6eU7G
	egk1gxX5ZeyTgx6RhGJyJ5tYZoxk8SV95Ah1W1OUJilP4LjPR3FAb5CctdbS0e0P9n+vt+336Xb
	U6FaD/t17EtHUcf3QPqybJ71610wWagPCZ8gAxEYS+vLOtt60ra6GAJfNk79/e2kUksYE6TSl9X
	QBf/DHte3I5A7SRppA8XVi8mYH3BTqFxnchZDrLN12y8LwGb5RMK4nQfdiwsUf4ybsidH4ko4l9
	8TcMhe2gYD8fRaMKYvamk68sKfTiCPjQNwS3+MYlPnxxXaY6E/4DQgMUGOmMoD8/dAwdS1w3vD2
	UnKCENTNEa6/TCudS10VNsMMzcD+FAQrJLjZMKbwLsKykmFtJT+aE5ZdTB41TOuHX7JijLs09FA
	u9Ud/q1+2HMXiuspiMRXDTuMfJ4ciazxW64MuDkYNz0fodbcVuDR+VCw+zm7uTzZ8DdvlPfCQCP
	9lXimpxN1A=
X-Received: by 2002:a05:6214:2a8c:b0:897:30b:e1f4 with SMTP id 6a1803df08f44-89734707398mr7523016d6.13.1770929732159;
        Thu, 12 Feb 2026 12:55:32 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8971cc823a4sm44446646d6.8.2026.02.12.12.55.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Feb 2026 12:55:31 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 03/13] lpfc: Add log messages to fabric login error labels
Date: Thu, 12 Feb 2026 13:29:58 -0800
Message-Id: <20260212213008.149873-4-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260212213008.149873-1-justintee8345@gmail.com>
References: <20260212213008.149873-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Should fabric login or related initialization mailbox commands fail,
there are no log messages to notify which step encountered an issue.
Update error label paths to log when unexpected fabric login issues occur.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c     | 24 ++++++++++++++++--------
 drivers/scsi/lpfc/lpfc_hbadisc.c | 16 +++++++++++++---
 2 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 32da3c23c7f4..019851da8766 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2025 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2026 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
@@ -1303,8 +1303,12 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	elsiocb = lpfc_prep_els_iocb(vport, 1, cmdsize, retry, ndlp,
 				     ndlp->nlp_DID, ELS_CMD_FLOGI);
 
-	if (!elsiocb)
+	if (!elsiocb) {
+		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
+		lpfc_printf_vlog(vport, KERN_WARNING, LOG_ELS | LOG_DISCOVERY,
+				 "4296 Unable to prepare FLOGI iocb\n");
 		return 1;
+	}
 
 	wqe = &elsiocb->wqe;
 	pcmd = (uint8_t *)elsiocb->cmd_dmabuf->virt;
@@ -1394,10 +1398,8 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		phba->sli3_options, 0, 0);
 
 	elsiocb->ndlp = lpfc_nlp_get(ndlp);
-	if (!elsiocb->ndlp) {
-		lpfc_els_free_iocb(phba, elsiocb);
-		return 1;
-	}
+	if (!elsiocb->ndlp)
+		goto err_out;
 
 	/* Avoid race with FLOGI completion and hba_flags. */
 	set_bit(HBA_FLOGI_ISSUED, &phba->hba_flag);
@@ -1407,9 +1409,8 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	if (rc == IOCB_ERROR) {
 		clear_bit(HBA_FLOGI_ISSUED, &phba->hba_flag);
 		clear_bit(HBA_FLOGI_OUTSTANDING, &phba->hba_flag);
-		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
-		return 1;
+		goto err_out;
 	}
 
 	/* Clear external loopback plug detected flag */
@@ -1474,6 +1475,13 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	}
 
 	return 0;
+
+ err_out:
+	lpfc_els_free_iocb(phba, elsiocb);
+	lpfc_vport_set_state(vport, FC_VPORT_FAILED);
+	lpfc_printf_vlog(vport, KERN_WARNING, LOG_ELS | LOG_DISCOVERY,
+			 "4297 Issue FLOGI: Cannot send IOCB\n");
+	return 1;
 }
 
 /**
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index eb1ad45dad4b..210aa88f9df9 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -3175,7 +3175,11 @@ lpfc_init_vfi_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 		return;
 	}
 
-	lpfc_initial_flogi(vport);
+	if (!lpfc_initial_flogi(vport)) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX | LOG_ELS,
+				 "2345 Can't issue initial FLOGI\n");
+		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
+	}
 	mempool_free(mboxq, phba->mbox_mem_pool);
 	return;
 }
@@ -3248,8 +3252,14 @@ lpfc_init_vpi_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 			return;
 	}
 
-	if (phba->link_flag & LS_NPIV_FAB_SUPPORTED)
-		lpfc_initial_fdisc(vport);
+	if (phba->link_flag & LS_NPIV_FAB_SUPPORTED) {
+		if (!lpfc_initial_fdisc(vport)) {
+			lpfc_printf_vlog(vport, KERN_WARNING,
+					 LOG_MBOX | LOG_ELS,
+					 "2346 Can't issue initial FDISC\n");
+			lpfc_vport_set_state(vport, FC_VPORT_FAILED);
+		}
+	}
 	else {
 		lpfc_vport_set_state(vport, FC_VPORT_NO_FABRIC_SUPP);
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-- 
2.38.0

