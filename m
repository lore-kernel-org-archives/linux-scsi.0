Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311902072B3;
	Wed, 25 Sep 2024 12:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727266074; cv=none; b=NTDAsOhNr3mpDE2NoTGQyKoO1bjnCLDRzGYG819iLaB4skIyRMPCKBuOjjCR9oVPJQnZrBj4MoJJVrBWRnBEvbQp1JdceBzZZNOYv96fCE0hMAM1O5vsYfnvlVBz3wD4cuSS7qtx4CKn2zsqKl+OMdsxwjgk1wyNI5sm46zgRpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727266074; c=relaxed/simple;
	bh=81zeLLxcyczQoI9yZx3SseYdXAJQrm4ESwiUNAHNnD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMTeYqzl44uu2+yjeZ1czAaHp7flQd5yPzKC7F6vUtDtVdIiZlR9fT8pTxXRtOEK6YeFxSGLSr7BQjeLrAx3azZcvuOSYZk1381FYw0GbYLLNgu9GXVvoPbJK8MrOS6fGREEdv9R8MO5nidOWAh7jyFCYn15vZ7uec1NS/FMDEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kykv6tHf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kykv6tHf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D2C4C4CEC7;
	Wed, 25 Sep 2024 12:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727266073;
	bh=81zeLLxcyczQoI9yZx3SseYdXAJQrm4ESwiUNAHNnD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kykv6tHfQfZvpQ1EjOUyDFfpu5FK/B2ephTF/ceemF0JAE42CvkevAAnu5Ndvus6a
	 2FJE1Kk9mXJPW/aaO/P7j4G2yzslpbK7+H/op3Zhj4i2bHChrN1eIZSntiOfxzWyXw
	 ZMtoueOP5D7fmgOnHIIP1uL1lMwifK+n9I9bPo9sc8VG+G+qgXTQc18tLJwq6QThGg
	 2DyhOtnkKWvpOv1hoOm0ELXvcC3raB+czsmkTdYKKGGiPCmZ6dREl6wQebJ1fiztCS
	 f5CWZBhv7GFFcoAF7uYgUPYuWPG1QDqg1WiEFq6XC/0yP/xf4KZFVBTzIilKLy2Ebk
	 przqEeNtcR5Vg==
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
Subject: [PATCH AUTOSEL 6.10 162/197] scsi: lpfc: Validate hdwq pointers before dereferencing in reset/errata paths
Date: Wed, 25 Sep 2024 07:53:01 -0400
Message-ID: <20240925115823.1303019-162-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240925115823.1303019-1-sashal@kernel.org>
References: <20240925115823.1303019-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.10.11
Content-Transfer-Encoding: 8bit

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 2be1d4f11944cd6283cb97268b3e17c4424945ca ]

When the HBA is undergoing a reset or is handling an errata event, NULL ptr
dereference crashes may occur in routines such as
lpfc_sli_flush_io_rings(), lpfc_dev_loss_tmo_callbk(), or
lpfc_abort_handler().

Add NULL ptr checks before dereferencing hdwq pointers that may have been
freed due to operations colliding with a reset or errata event handler.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20240726231512.92867-4-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c |  3 ++-
 drivers/scsi/lpfc/lpfc_scsi.c    | 13 +++++++++++--
 drivers/scsi/lpfc/lpfc_sli.c     | 11 +++++++++++
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 13b08c85440fe..e74a676b6e153 100644
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
index 98ce9d97a2257..60cd60ebff38e 100644
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
index 3e55d5edd60ab..c6fcaeeb52945 100644
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
2.43.0

