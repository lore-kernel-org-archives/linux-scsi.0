Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A786B22097
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 22:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730412935; cv=none; b=F9hcJTM2EZIRVi0M+P3Ifs3jLOpI7v50h403UB07VkoiEQ9lH6c0/apcar8CWUUQsFVKx2p8drixCXJCBrNBvI3NNcRJaVyKkMUotsK05FEmgXkAGanvUiaYMf8vhn2mzFCrKrcKdMBzIRrAM0W1k/iohD8YMsKk9ShkCeh6o1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730412935; c=relaxed/simple;
	bh=fmyaqaWeOQ8iXIpdfyJ04g+Bqk08N9v1TDTHGb8HbqY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kemdxyAzs7oaxwhteDL1Y2EbaA9K0EkAl5tcgyOLHK2wyUdqQiYL8jAGXfFR0qov3FdwpRskUwrOiVienDCyaiCnbVpjw5m/GOZpBFIxnbT6yZHHaLJjE6kDWshODoIh3D1viLNQPGEPLcji+Sw+4tehKcwbpZsx2iw/1EvMPPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eAKXxtqH; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eAKXxtqH"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-71e8235f0b6so1196176b3a.3
        for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 15:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730412929; x=1731017729; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z6Ts453iB+9/9mIWeCrD2A2Di22ms9zTqI/LPGUfDfI=;
        b=eAKXxtqHs2unFo1kBFttmhzHqI9GSolkUQ9dNZYEyY7ixEO2WT3QD+BQoTUMFN1wT+
         09tGm2lTlRNq2VyTd2nJ3EhoA88NN8e/IS9GdSJn6pgJ68IzZrIfGMc1DV/PbBS2lyo0
         mTE+XgyVobGASH/uOO3btenNxFDK1h2cCDTAdk3EkWB/M/v/YPhQtdmOV1iTbUYGHHsh
         Qf0A/U51IXdvop25VzmyLCH6AfeMj4+jvUNFHHhQTXY23yNJt+VV+Yd9/J6Sn5dJyFtX
         SLZgItahzesy7C7bTJDimyDmWyTxNskhql1LeOxTdiNeG/SqPS+7TAOv0CpQE/u79hfa
         vECg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730412929; x=1731017729;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z6Ts453iB+9/9mIWeCrD2A2Di22ms9zTqI/LPGUfDfI=;
        b=I/q7QgJrdoLf37qZDil/xWsl0bahPoqL5WE2P+Z1wwmALm5oGwAGCVuDWoXF9wco9U
         neI6CJpxvu7nWDXSg68B7Le2DViXuAhnU3VKqX6qc80FE57j3BrjeZC5RJdw/vjqvKid
         dW52nXkYAUU1VhuEfKqmH7QcznoIzt7+LNj3RgTtNjZzvhojmdGC0usw4fK+bubyZy76
         ziD3GtLYOhUXTJmlKDRWyf3NQiUd/s9FcU4gsk3AJv1awP0fejLEgnkGRKUu8lY/iVEa
         T8FZ8Zds8Qv+5oRMU4mCLgyKDZVEHxDFmI3F1VtR9uLcJs/ddvcecqWdXAj4zixMBouD
         z+7A==
X-Gm-Message-State: AOJu0YzWGEyYaQBPsYV6RYYNVKnDTSN9ZpXutGi/6P7RFrsDk6etGyJF
	YZ3n1ZyrVOIVmg0uzc2aaJn5Z2nykZmSl1h6PH5geXncpjIg7ojDwnZXNQ==
X-Google-Smtp-Source: AGHT+IHn/5z0stEAN83Os2LTv9FHIfL8IQgJIkfwY5ebZEyA1KoCNUTX/YueiZyRPqetFcJ7guNUwA==
X-Received: by 2002:a17:90b:1a8e:b0:2e5:e43a:1413 with SMTP id 98e67ed59e1d1-2e93c182879mr6305352a91.9.1730412928576;
        Thu, 31 Oct 2024 15:15:28 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e92fa25742sm3916528a91.19.2024.10.31.15.15.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Oct 2024 15:15:28 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 03/11] lpfc: Call lpfc_sli4_queue_unset in restart and rmmod paths
Date: Thu, 31 Oct 2024 15:32:11 -0700
Message-Id: <20241031223219.152342-4-justintee8345@gmail.com>
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

During initialization, the driver allocates wq->pring in lpfc_wq_create
and lpfc_sli4_queue_unset is the only place where kfree(wq->pring) is
called.

There is a possible memory leak in lpfc_sli_brdrestart_s4 (restart) and
lpfc_pci_remove_one_s4 (rmmod) paths because there are no calls to
lpfc_sli4_queue_unset to kfree the wq->pring.

Fix by inserting a call to lpfc_sli4_queue_unset in lpfc_sli_brdrestart_s4
and lpfc_sli4_hba_unset routines.  Also, add a check for the SLI_ACTIVE
flag before issuing the Q_DESTROY mailbox command.  If not set, then the
mailbox command will obviously fail.  In such cases, skip issuing the
mailbox command and only execute the driver resource clean up portions of
the lpfc_*q_destroy routines.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_init.c |  2 ++
 drivers/scsi/lpfc/lpfc_sli.c  | 41 ++++++++++++++++++++++++++++++-----
 2 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 0dd451009b07..a3658ef1141b 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -13518,6 +13518,8 @@ lpfc_sli4_hba_unset(struct lpfc_hba *phba)
 	/* Disable FW logging to host memory */
 	lpfc_ras_stop_fwlog(phba);
 
+	lpfc_sli4_queue_unset(phba);
+
 	/* Reset SLI4 HBA FCoE function */
 	lpfc_pci_function_reset(phba);
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 80a43fd40af2..5ad5ff10256b 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -5293,6 +5293,8 @@ lpfc_sli_brdrestart_s4(struct lpfc_hba *phba)
 			"0296 Restart HBA Data: x%x x%x\n",
 			phba->pport->port_state, psli->sli_flag);
 
+	lpfc_sli4_queue_unset(phba);
+
 	rc = lpfc_sli4_brdreset(phba);
 	if (rc) {
 		phba->link_state = LPFC_HBA_ERROR;
@@ -17627,6 +17629,9 @@ lpfc_eq_destroy(struct lpfc_hba *phba, struct lpfc_queue *eq)
 	if (!eq)
 		return -ENODEV;
 
+	if (!(phba->sli.sli_flag & LPFC_SLI_ACTIVE))
+		goto list_remove;
+
 	mbox = mempool_alloc(eq->phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox)
 		return -ENOMEM;
@@ -17653,10 +17658,12 @@ lpfc_eq_destroy(struct lpfc_hba *phba, struct lpfc_queue *eq)
 				shdr_status, shdr_add_status, rc);
 		status = -ENXIO;
 	}
+	mempool_free(mbox, eq->phba->mbox_mem_pool);
 
+list_remove:
 	/* Remove eq from any list */
 	list_del_init(&eq->list);
-	mempool_free(mbox, eq->phba->mbox_mem_pool);
+
 	return status;
 }
 
@@ -17684,6 +17691,10 @@ lpfc_cq_destroy(struct lpfc_hba *phba, struct lpfc_queue *cq)
 	/* sanity check on queue memory */
 	if (!cq)
 		return -ENODEV;
+
+	if (!(phba->sli.sli_flag & LPFC_SLI_ACTIVE))
+		goto list_remove;
+
 	mbox = mempool_alloc(cq->phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox)
 		return -ENOMEM;
@@ -17709,9 +17720,11 @@ lpfc_cq_destroy(struct lpfc_hba *phba, struct lpfc_queue *cq)
 				shdr_status, shdr_add_status, rc);
 		status = -ENXIO;
 	}
+	mempool_free(mbox, cq->phba->mbox_mem_pool);
+
+list_remove:
 	/* Remove cq from any list */
 	list_del_init(&cq->list);
-	mempool_free(mbox, cq->phba->mbox_mem_pool);
 	return status;
 }
 
@@ -17739,6 +17752,10 @@ lpfc_mq_destroy(struct lpfc_hba *phba, struct lpfc_queue *mq)
 	/* sanity check on queue memory */
 	if (!mq)
 		return -ENODEV;
+
+	if (!(phba->sli.sli_flag & LPFC_SLI_ACTIVE))
+		goto list_remove;
+
 	mbox = mempool_alloc(mq->phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox)
 		return -ENOMEM;
@@ -17764,9 +17781,11 @@ lpfc_mq_destroy(struct lpfc_hba *phba, struct lpfc_queue *mq)
 				shdr_status, shdr_add_status, rc);
 		status = -ENXIO;
 	}
+	mempool_free(mbox, mq->phba->mbox_mem_pool);
+
+list_remove:
 	/* Remove mq from any list */
 	list_del_init(&mq->list);
-	mempool_free(mbox, mq->phba->mbox_mem_pool);
 	return status;
 }
 
@@ -17794,6 +17813,10 @@ lpfc_wq_destroy(struct lpfc_hba *phba, struct lpfc_queue *wq)
 	/* sanity check on queue memory */
 	if (!wq)
 		return -ENODEV;
+
+	if (!(phba->sli.sli_flag & LPFC_SLI_ACTIVE))
+		goto list_remove;
+
 	mbox = mempool_alloc(wq->phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox)
 		return -ENOMEM;
@@ -17818,11 +17841,13 @@ lpfc_wq_destroy(struct lpfc_hba *phba, struct lpfc_queue *wq)
 				shdr_status, shdr_add_status, rc);
 		status = -ENXIO;
 	}
+	mempool_free(mbox, wq->phba->mbox_mem_pool);
+
+list_remove:
 	/* Remove wq from any list */
 	list_del_init(&wq->list);
 	kfree(wq->pring);
 	wq->pring = NULL;
-	mempool_free(mbox, wq->phba->mbox_mem_pool);
 	return status;
 }
 
@@ -17852,6 +17877,10 @@ lpfc_rq_destroy(struct lpfc_hba *phba, struct lpfc_queue *hrq,
 	/* sanity check on queue memory */
 	if (!hrq || !drq)
 		return -ENODEV;
+
+	if (!(phba->sli.sli_flag & LPFC_SLI_ACTIVE))
+		goto list_remove;
+
 	mbox = mempool_alloc(hrq->phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox)
 		return -ENOMEM;
@@ -17892,9 +17921,11 @@ lpfc_rq_destroy(struct lpfc_hba *phba, struct lpfc_queue *hrq,
 				shdr_status, shdr_add_status, rc);
 		status = -ENXIO;
 	}
+	mempool_free(mbox, hrq->phba->mbox_mem_pool);
+
+list_remove:
 	list_del_init(&hrq->list);
 	list_del_init(&drq->list);
-	mempool_free(mbox, hrq->phba->mbox_mem_pool);
 	return status;
 }
 
-- 
2.38.0

