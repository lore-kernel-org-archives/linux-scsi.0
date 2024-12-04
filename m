Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BFF21A431;
	Wed,  4 Dec 2024 17:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733331712; cv=none; b=tGOypYLS44NPCSsy+iUHcRuwjv5BvBPjl6WVzASFSMcrp6HZQ4S7g2e2HZFxcT8DQD4uOZ6BGs52gGqjWDk/spVITiHUxM9DJtdqTaiRCAypbeSCuP4IWbIWaBt4nwhwZxmb6lP6kUfwjOdBppvVv4ati7Y9Qv87QS70v4LuCyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733331712; c=relaxed/simple;
	bh=EHJ7vzF8nxQZT43xydObxju0i4U0ZrHh0eQVIonvGbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZIs/j0xkDoVYE46hZsPqoISLSEg2/1DuP86a89hTUcr06P2iMZpYanrVTkZa+PdB5AnTJQP6T4sFLtS7WS4Sf16RTAE7cS+IVsznM0TarMx5nirSg3C/eWZ/9nb+D6fhM9u2Ksqj87814py3K2KprBlbhhgcHHj5opNEK5QAkx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=srJajYLD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="srJajYLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DFB3C4CED1;
	Wed,  4 Dec 2024 17:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733331712;
	bh=EHJ7vzF8nxQZT43xydObxju0i4U0ZrHh0eQVIonvGbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=srJajYLD9mBsMwA3yNsBEd1gvVz3izvdx7JKVJRjhgAJJ0j0DraSh0N/5FDMkruIA
	 xFWm0WUT/LvnnXXisV75R6PNqqn1232L7KlLWZUXpq1eJxxmBFdaUo+N4N/4Aty7p+
	 M/aLySiLSZznH75dhfW8IUYoFaQ5C4iPqlYpGtuFFnktFqbHLbiIuxCDMKWOiiCiP/
	 S4isyr2WZ5HPyMp6Jqx6ZkhMsjYobHonP287rH37v2Z6WFBByCYVVhsNTH2KJB7Zb+
	 xy2rt9N8SciQITOgdM4Es/dhTdM66KK3sQg0wzFK11zgOEgq3xzOoZzjr/NKCLVRpH
	 VwYdpXXnXyb2A==
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
Subject: [PATCH AUTOSEL 6.6 12/24] scsi: lpfc: Call lpfc_sli4_queue_unset() in restart and rmmod paths
Date: Wed,  4 Dec 2024 10:49:32 -0500
Message-ID: <20241204155003.2213733-12-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241204155003.2213733-1-sashal@kernel.org>
References: <20241204155003.2213733-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.63
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
index 416816d74ea1c..424b39a8155cb 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -13513,6 +13513,8 @@ lpfc_sli4_hba_unset(struct lpfc_hba *phba)
 	/* Disable FW logging to host memory */
 	lpfc_ras_stop_fwlog(phba);
 
+	lpfc_sli4_queue_unset(phba);
+
 	/* Reset SLI4 HBA FCoE function */
 	lpfc_pci_function_reset(phba);
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 9cd22588c8eb3..136698862dbad 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -5274,6 +5274,8 @@ lpfc_sli_brdrestart_s4(struct lpfc_hba *phba)
 			"0296 Restart HBA Data: x%x x%x\n",
 			phba->pport->port_state, psli->sli_flag);
 
+	lpfc_sli4_queue_unset(phba);
+
 	rc = lpfc_sli4_brdreset(phba);
 	if (rc) {
 		phba->link_state = LPFC_HBA_ERROR;
@@ -17619,6 +17621,9 @@ lpfc_eq_destroy(struct lpfc_hba *phba, struct lpfc_queue *eq)
 	if (!eq)
 		return -ENODEV;
 
+	if (!(phba->sli.sli_flag & LPFC_SLI_ACTIVE))
+		goto list_remove;
+
 	mbox = mempool_alloc(eq->phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox)
 		return -ENOMEM;
@@ -17645,10 +17650,12 @@ lpfc_eq_destroy(struct lpfc_hba *phba, struct lpfc_queue *eq)
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
 
@@ -17676,6 +17683,10 @@ lpfc_cq_destroy(struct lpfc_hba *phba, struct lpfc_queue *cq)
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
@@ -17701,9 +17712,11 @@ lpfc_cq_destroy(struct lpfc_hba *phba, struct lpfc_queue *cq)
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
 
@@ -17731,6 +17744,10 @@ lpfc_mq_destroy(struct lpfc_hba *phba, struct lpfc_queue *mq)
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
@@ -17756,9 +17773,11 @@ lpfc_mq_destroy(struct lpfc_hba *phba, struct lpfc_queue *mq)
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
 
@@ -17786,6 +17805,10 @@ lpfc_wq_destroy(struct lpfc_hba *phba, struct lpfc_queue *wq)
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
@@ -17810,11 +17833,13 @@ lpfc_wq_destroy(struct lpfc_hba *phba, struct lpfc_queue *wq)
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
 
@@ -17844,6 +17869,10 @@ lpfc_rq_destroy(struct lpfc_hba *phba, struct lpfc_queue *hrq,
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
@@ -17884,9 +17913,11 @@ lpfc_rq_destroy(struct lpfc_hba *phba, struct lpfc_queue *hrq,
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

