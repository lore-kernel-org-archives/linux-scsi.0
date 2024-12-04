Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497552049F3;
	Wed,  4 Dec 2024 17:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733331620; cv=none; b=f17kkdtIAhBpc+v1NYCMOKrUHAQmzgbNiHC+9Z7n5m1wRP1/nfXU2oaGv+T4PVU29R2U6IPGcvdZdINXq9pOykGF2HZlgpVjQvFK20MByzwLBMe2+YKZKLFkqnVV6Juktb+PBgx6qX45vs43CQrZ9LR148Mk5f3415c7ARvxbfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733331620; c=relaxed/simple;
	bh=O8Y4Qg2Qmm+muZh74LMkyROia8RxFztdwBLcV0m+0rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DFrWeD55Kmq4prOmNLa9TLUn6zu7mPSWdudyWf6AJtT/T85ELSeaEHGwpuNw77MxL1lizym31YQsUiQOZ5t1Lkq5mmbp7jLo8UJz62Xcv0IM2VRZvp2WseIG+byCyZWEyPhyoFccwhIik4ibg2nGovFE9i7wNt0/uhSk0JXL31I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FugTz9O6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FugTz9O6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255BAC4CECD;
	Wed,  4 Dec 2024 17:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733331620;
	bh=O8Y4Qg2Qmm+muZh74LMkyROia8RxFztdwBLcV0m+0rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FugTz9O6gnmz//ixjhQngALWKZykhGPGOC9TwiWs5mf+7kkvQMtI/Z8V3AmpBT9MP
	 uIVi/nvA9Rlgu5eeXc5/j62utGGs8K4BNqVIMJwRen+8eHhHIJuXHlL5OBO1CAyAyy
	 4u6+rQNvvle4W68fTHhvh336Rw+rFx+9sof7ctboXs+pa3iJCg3nNc2XmcpBvhl6a2
	 6cHpqbYAJBg0PffJcW/5hf70mMJkUbshzgh0T65UUBO+Ws842w9iqhvX4Tuq+qWcT9
	 UpnfiWuciQbYmB9LqhUyL7BU7+MGv9bzawB2DZfvBstutZyuCwHugkLup4nKLEhZay
	 ICX8tj/HgnycQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Justin Tee <justin.tee@broadcom.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	james.smart@broadcom.com,
	dick.kennedy@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.11 16/33] scsi: lpfc: Call lpfc_sli4_queue_unset() in restart and rmmod paths
Date: Wed,  4 Dec 2024 10:47:29 -0500
Message-ID: <20241204154817.2212455-16-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241204154817.2212455-1-sashal@kernel.org>
References: <20241204154817.2212455-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.11.10
Content-Transfer-Encoding: 8bit

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit d35f7672715d1ff3e3ad9bb4ae6ac6cb484200fe ]

During initialization, the driver allocates wq->pring in lpfc_wq_create
and lpfc_sli4_queue_unset() is the only place where kfree(wq->pring) is
called.

There is a possible memory leak in lpfc_sli_brdrestart_s4() (restart)
and lpfc_pci_remove_one_s4() (rmmod) paths because there are no calls to
lpfc_sli4_queue_unset() to kfree() the wq->pring.

Fix by inserting a call to lpfc_sli4_queue_unset() in
lpfc_sli_brdrestart_s4() and lpfc_sli4_hba_unset() routines.  Also, add
a check for the SLI_ACTIVE flag before issuing the Q_DESTROY mailbox
command.  If not set, then the mailbox command will obviously fail.  In
such cases, skip issuing the mailbox command and only execute the driver
resource clean up portions of the lpfc_*q_destroy routines.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20241031223219.152342-4-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_init.c |  2 ++
 drivers/scsi/lpfc/lpfc_sli.c  | 41 ++++++++++++++++++++++++++++++-----
 2 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 0c1404dc5f3bd..01f0f1f2a294f 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -13511,6 +13511,8 @@ lpfc_sli4_hba_unset(struct lpfc_hba *phba)
 	/* Disable FW logging to host memory */
 	lpfc_ras_stop_fwlog(phba);
 
+	lpfc_sli4_queue_unset(phba);
+
 	/* Reset SLI4 HBA FCoE function */
 	lpfc_pci_function_reset(phba);
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 7dc34c71eb78c..6f79e0cf6a753 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -5288,6 +5288,8 @@ lpfc_sli_brdrestart_s4(struct lpfc_hba *phba)
 			"0296 Restart HBA Data: x%x x%x\n",
 			phba->pport->port_state, psli->sli_flag);
 
+	lpfc_sli4_queue_unset(phba);
+
 	rc = lpfc_sli4_brdreset(phba);
 	if (rc) {
 		phba->link_state = LPFC_HBA_ERROR;
@@ -17616,6 +17618,9 @@ lpfc_eq_destroy(struct lpfc_hba *phba, struct lpfc_queue *eq)
 	if (!eq)
 		return -ENODEV;
 
+	if (!(phba->sli.sli_flag & LPFC_SLI_ACTIVE))
+		goto list_remove;
+
 	mbox = mempool_alloc(eq->phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox)
 		return -ENOMEM;
@@ -17642,10 +17647,12 @@ lpfc_eq_destroy(struct lpfc_hba *phba, struct lpfc_queue *eq)
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
 
@@ -17673,6 +17680,10 @@ lpfc_cq_destroy(struct lpfc_hba *phba, struct lpfc_queue *cq)
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
@@ -17698,9 +17709,11 @@ lpfc_cq_destroy(struct lpfc_hba *phba, struct lpfc_queue *cq)
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
 
@@ -17728,6 +17741,10 @@ lpfc_mq_destroy(struct lpfc_hba *phba, struct lpfc_queue *mq)
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
@@ -17753,9 +17770,11 @@ lpfc_mq_destroy(struct lpfc_hba *phba, struct lpfc_queue *mq)
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
 
@@ -17783,6 +17802,10 @@ lpfc_wq_destroy(struct lpfc_hba *phba, struct lpfc_queue *wq)
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
@@ -17807,11 +17830,13 @@ lpfc_wq_destroy(struct lpfc_hba *phba, struct lpfc_queue *wq)
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
 
@@ -17841,6 +17866,10 @@ lpfc_rq_destroy(struct lpfc_hba *phba, struct lpfc_queue *hrq,
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
@@ -17881,9 +17910,11 @@ lpfc_rq_destroy(struct lpfc_hba *phba, struct lpfc_queue *hrq,
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
2.43.0

