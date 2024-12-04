Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE4C215F4B;
	Wed,  4 Dec 2024 16:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733331508; cv=none; b=dmaDfKTrMuhyjx0gnB47N0vk+49hY5cQhIFJkk85avhzs4V3K+0I+0H7UVlaMvDGOY8L9+izZ6GQwpWqdHTDgNE466kQKglYPjI8AkxYD18hq3lkGsYMnebMj/+/lwIIHQUPrharwjMpltdkaOH6FSVkA7wjOduCz2/wm4d8yQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733331508; c=relaxed/simple;
	bh=ShxyKbUZbqLWskYD7MScECKc0N7WMzo8edmStbKj94g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmdOIY1smmk6VmN59U59/T5C08oogXpYZNPsS0Iahd8/LWFHc9zKmyPgSSxgrcOE119b+3RwDADOEkt5F/k+AqPn9A+NiFrRO2AGgbUX8iSn7ZEsA+iqm9vAYQ0FtJZV+Lxz9YK+L7WnKzs63wPtIVM2wD4X5L4DfHym1oS9HvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sMV339sZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sMV339sZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD874C4CECD;
	Wed,  4 Dec 2024 16:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733331507;
	bh=ShxyKbUZbqLWskYD7MScECKc0N7WMzo8edmStbKj94g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sMV339sZZ7uiJGnGydhXEFB6tzR9a5kz6iZWmSFrp0c76ISQlIpGdwS7puiDgjdm6
	 06mSjJYTMgDaJgjGUrV2/cwaJRtNvSKLruKwM70CYoAGOdhc4lfK2h/QIioZA7iepO
	 Rwp/GZIQmodI7qh28P6M5vtBhhBkzBstYag/IWVd70pciEjtXLR9kG8FNId1D5jLZy
	 L1hI5E8f6qnrzX8tBXqpG2pJ1JtksEP5sh4Kh/JTOmeA4Jfo5K210/awlm20IDH3Fv
	 YyL4eTwduGlattMdzAdV/hTpBsx8g5bT2Q0Pw3cIwPLDlJJ53Pi3heeKDpvLLzQvHg
	 vzje4Y5nVlpAg==
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
Subject: [PATCH AUTOSEL 6.12 17/36] scsi: lpfc: Call lpfc_sli4_queue_unset() in restart and rmmod paths
Date: Wed,  4 Dec 2024 10:45:33 -0500
Message-ID: <20241204154626.2211476-17-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241204154626.2211476-1-sashal@kernel.org>
References: <20241204154626.2211476-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.1
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
index 0dd451009b079..a3658ef1141b2 100644
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
index 2ec6e55771b45..6748fba48a07e 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -5291,6 +5291,8 @@ lpfc_sli_brdrestart_s4(struct lpfc_hba *phba)
 			"0296 Restart HBA Data: x%x x%x\n",
 			phba->pport->port_state, psli->sli_flag);
 
+	lpfc_sli4_queue_unset(phba);
+
 	rc = lpfc_sli4_brdreset(phba);
 	if (rc) {
 		phba->link_state = LPFC_HBA_ERROR;
@@ -17625,6 +17627,9 @@ lpfc_eq_destroy(struct lpfc_hba *phba, struct lpfc_queue *eq)
 	if (!eq)
 		return -ENODEV;
 
+	if (!(phba->sli.sli_flag & LPFC_SLI_ACTIVE))
+		goto list_remove;
+
 	mbox = mempool_alloc(eq->phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox)
 		return -ENOMEM;
@@ -17651,10 +17656,12 @@ lpfc_eq_destroy(struct lpfc_hba *phba, struct lpfc_queue *eq)
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
 
@@ -17682,6 +17689,10 @@ lpfc_cq_destroy(struct lpfc_hba *phba, struct lpfc_queue *cq)
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
@@ -17707,9 +17718,11 @@ lpfc_cq_destroy(struct lpfc_hba *phba, struct lpfc_queue *cq)
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
 
@@ -17737,6 +17750,10 @@ lpfc_mq_destroy(struct lpfc_hba *phba, struct lpfc_queue *mq)
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
@@ -17762,9 +17779,11 @@ lpfc_mq_destroy(struct lpfc_hba *phba, struct lpfc_queue *mq)
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
 
@@ -17792,6 +17811,10 @@ lpfc_wq_destroy(struct lpfc_hba *phba, struct lpfc_queue *wq)
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
@@ -17816,11 +17839,13 @@ lpfc_wq_destroy(struct lpfc_hba *phba, struct lpfc_queue *wq)
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
 
@@ -17850,6 +17875,10 @@ lpfc_rq_destroy(struct lpfc_hba *phba, struct lpfc_queue *hrq,
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
@@ -17890,9 +17919,11 @@ lpfc_rq_destroy(struct lpfc_hba *phba, struct lpfc_queue *hrq,
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

