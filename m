Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3AE418C356
	for <linux-scsi@vger.kernel.org>; Mon, 17 Jun 2024 21:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718658623; cv=none; b=UFeWFfPqxm8furkD3K5z20nL/NTQJscR8VradnchQSKA8SYbQoMY926mF5aGE0api8sgzbpUTMw4UQ32FWKWLwjKhV03zAYi9HZQVYScWn/kp96H2ljve3JM9USUWWbfloicb94av08TwsHgWCn7jFQMz+0sv7vPNaNV2E/Jglg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718658623; c=relaxed/simple;
	bh=hPHjiDx82O4XZfWXcB77/9420Z7wOTk88urjKEgSZBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILsU/QxRWV7TB34e3yiBkLlY6Yd4PXG+ZpTW9Gmo1x+HdYRyhxAPOss5jE9Ng6d//pgnJl3BfgqSaxQawtF7BzFYpadc3wDLQ1p/kfnwSin7DgNF2XyXhjbA3jJr3wVQ0YFhcasJLh2XUz7YUPbQN6WjNZPKChWtWWHarsgM1Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Zcl/MpDH; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Zcl/MpDH"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4W32bK4qGqz6Cnk98;
	Mon, 17 Jun 2024 21:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1718658596; x=1721250597; bh=bCRLs
	SD2qdYp34UMbcSPqJbZlGJqTdMGxVq3wDaKD5k=; b=Zcl/MpDHwjF4S3M/eytrr
	vwILM8qDtEm5OeFIJlPqPYI9fcxSFaUUQsiciVy9UwklKswpFEQxuf65ynwI00so
	72GTg37dnzv6d4TVQa1fSO5Vunlr88Je3Nb1NKIa3MFrPxxKDJeo4xOdNYGoEsgq
	Aeh6xneNr9xv+7XXhONJ1WoIkP7IRVY2IyCLlRtDEthCwVAd9XO3OHUA1iMoRCiB
	YxOrM2uOdytUWBo95Ff9dVPwing+6m+lKPRB+4tV3AYvr49pZC/eLV/lnQqdncy8
	H9j6NBN4vfJhdO3M86J/Rw9GH7ORNiLZhxmzKilSw6ThMxFbAwMP2XbeahNxhwwy
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id PyYqoJ_fYUvH; Mon, 17 Jun 2024 21:09:56 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4W32Zp5tvQz6Cnk95;
	Mon, 17 Jun 2024 21:09:54 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	ChanWoo Lee <cw9316.lee@samsung.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Po-Wen Kao <powen.kao@mediatek.com>,
	Yang Li <yang.lee@linux.alibaba.com>,
	Keoseong Park <keosung.park@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>,
	Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 7/8] scsi: ufs: Make the polling code report which command has been completed
Date: Mon, 17 Jun 2024 14:07:46 -0700
Message-ID: <20240617210844.337476-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.627.g7a2c4fd464-goog
In-Reply-To: <20240617210844.337476-1-bvanassche@acm.org>
References: <20240617210844.337476-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Prepare for introducing a new __ufshcd_poll() caller that will need to
know whether or not a specific command has been completed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-mcq.c      | 25 +++++++++++++-------
 drivers/ufs/core/ufshcd-priv.h  |  4 ++--
 drivers/ufs/core/ufshcd.c       | 41 +++++++++++++++++++++++----------
 drivers/ufs/host/ufs-mediatek.c |  2 +-
 drivers/ufs/host/ufs-qcom.c     |  2 +-
 include/ufs/ufshcd.h            |  3 ++-
 6 files changed, 52 insertions(+), 25 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index d6f966f4abef..c9155759934c 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -294,17 +294,22 @@ static int ufshcd_mcq_get_tag(struct ufs_hba *hba, =
struct cq_entry *cqe)
 	return div_u64(addr, ufshcd_get_ucd_size(hba));
 }
=20
-static void ufshcd_mcq_process_cqe(struct ufs_hba *hba,
-				   struct ufs_hw_queue *hwq)
+/* Returns true if and only if @compl_cmd has been completed. */
+static bool ufshcd_mcq_process_cqe(struct ufs_hba *hba,
+				   struct ufs_hw_queue *hwq,
+				   struct scsi_cmnd *compl_cmd)
 {
 	struct cq_entry *cqe =3D ufshcd_mcq_cur_cqe(hwq);
-	int tag =3D ufshcd_mcq_get_tag(hba, cqe);
=20
 	if (cqe->command_desc_base_addr) {
-		ufshcd_compl_one_cqe(hba, tag, cqe);
-		/* After processed the cqe, mark it empty (invalid) entry */
+		const int tag =3D ufshcd_mcq_get_tag(hba, cqe);
+
+		/* Mark the CQE as invalid. */
 		cqe->command_desc_base_addr =3D 0;
+
+		return ufshcd_compl_one_cqe(hba, tag, cqe, compl_cmd);
 	}
+	return false;
 }
=20
 void ufshcd_mcq_compl_all_cqes_lock(struct ufs_hba *hba,
@@ -315,7 +320,7 @@ void ufshcd_mcq_compl_all_cqes_lock(struct ufs_hba *h=
ba,
=20
 	spin_lock_irqsave(&hwq->cq_lock, flags);
 	while (entries > 0) {
-		ufshcd_mcq_process_cqe(hba, hwq);
+		ufshcd_mcq_process_cqe(hba, hwq, NULL);
 		ufshcd_mcq_inc_cq_head_slot(hwq);
 		entries--;
 	}
@@ -325,8 +330,10 @@ void ufshcd_mcq_compl_all_cqes_lock(struct ufs_hba *=
hba,
 	spin_unlock_irqrestore(&hwq->cq_lock, flags);
 }
=20
+/* Clears *@compl_cmd if and only if *@compl_cmd has been completed. */
 unsigned long ufshcd_mcq_poll_cqe_lock(struct ufs_hba *hba,
-				       struct ufs_hw_queue *hwq)
+				       struct ufs_hw_queue *hwq,
+				       struct scsi_cmnd **compl_cmd)
 {
 	unsigned long completed_reqs =3D 0;
 	unsigned long flags;
@@ -334,7 +341,9 @@ unsigned long ufshcd_mcq_poll_cqe_lock(struct ufs_hba=
 *hba,
 	spin_lock_irqsave(&hwq->cq_lock, flags);
 	ufshcd_mcq_update_cq_tail_slot(hwq);
 	while (!ufshcd_mcq_is_cq_empty(hwq)) {
-		ufshcd_mcq_process_cqe(hba, hwq);
+		if (ufshcd_mcq_process_cqe(hba, hwq,
+					   compl_cmd ? *compl_cmd : NULL))
+			*compl_cmd =3D NULL;
 		ufshcd_mcq_inc_cq_head_slot(hwq);
 		completed_reqs++;
 	}
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-pri=
v.h
index fb4457a84d11..42802fd689fb 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -61,8 +61,8 @@ int ufshcd_query_attr(struct ufs_hba *hba, enum query_o=
pcode opcode,
 int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 	enum flag_idn idn, u8 index, bool *flag_res);
 void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit);
-void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
-			  struct cq_entry *cqe);
+bool ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
+			  struct cq_entry *cqe, struct scsi_cmnd *compl_cmd);
 int ufshcd_mcq_init(struct ufs_hba *hba);
 int ufshcd_mcq_decide_queue_depth(struct ufs_hba *hba);
 int ufshcd_mcq_memory_alloc(struct ufs_hba *hba);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index db374a788140..e3835e61e4b1 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5488,9 +5488,12 @@ void ufshcd_release_scsi_cmd(struct ufs_hba *hba,
  * @hba: per adapter instance
  * @task_tag: the task tag of the request to be completed
  * @cqe: pointer to the completion queue entry
+ * @compl_cmd: if not NULL, check whether this command has been complete=
d
+ *
+ * Returns: true if and only if @compl_cmd has been completed.
  */
-void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
-			  struct cq_entry *cqe)
+bool ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
+			  struct cq_entry *cqe, struct scsi_cmnd *compl_cmd)
 {
 	struct ufshcd_lrb *lrbp;
 	struct scsi_cmnd *cmd;
@@ -5507,6 +5510,7 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int =
task_tag,
 		ufshcd_release_scsi_cmd(hba, lrbp);
 		/* Do not touch lrbp after scsi done */
 		scsi_done(cmd);
+		return cmd =3D=3D compl_cmd;
 	} else if (hba->dev_cmd.complete) {
 		if (cqe) {
 			ocs =3D le32_to_cpu(cqe->status) & MASK_OCS;
@@ -5514,20 +5518,26 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, in=
t task_tag,
 		}
 		complete(hba->dev_cmd.complete);
 	}
+	return false;
 }
=20
 /**
  * __ufshcd_transfer_req_compl - handle SCSI and query command completio=
n
  * @hba: per adapter instance
  * @completed_reqs: bitmask that indicates which requests to complete
+ * @compl_cmd: if not NULL, check whether *@compl_cmd has been completed=
.
+ *	Clear *@compl_cmd if it has been completed.
  */
 static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
-					unsigned long completed_reqs)
+					unsigned long completed_reqs,
+					struct scsi_cmnd **compl_cmd)
 {
 	int tag;
=20
 	for_each_set_bit(tag, &completed_reqs, hba->nutrs)
-		ufshcd_compl_one_cqe(hba, tag, NULL);
+		if (ufshcd_compl_one_cqe(hba, tag, NULL,
+					 compl_cmd ? *compl_cmd : NULL))
+			*compl_cmd =3D NULL;
 }
=20
 /* Any value that is not an existing queue number is fine for this const=
ant. */
@@ -5554,7 +5564,8 @@ static void ufshcd_clear_polled(struct ufs_hba *hba=
,
  * Return: > 0 if one or more commands have been completed or 0 if no
  * requests have been completed.
  */
-static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
+static int __ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num=
,
+			 struct scsi_cmnd **compl_cmd)
 {
 	struct ufs_hba *hba =3D shost_priv(shost);
 	unsigned long completed_reqs, flags;
@@ -5565,7 +5576,7 @@ static int ufshcd_poll(struct Scsi_Host *shost, uns=
igned int queue_num)
 		WARN_ON_ONCE(queue_num =3D=3D UFSHCD_POLL_FROM_INTERRUPT_CONTEXT);
 		hwq =3D &hba->uhq[queue_num];
=20
-		return ufshcd_mcq_poll_cqe_lock(hba, hwq);
+		return ufshcd_mcq_poll_cqe_lock(hba, hwq, compl_cmd);
 	}
=20
 	spin_lock_irqsave(&hba->outstanding_lock, flags);
@@ -5582,11 +5593,16 @@ static int ufshcd_poll(struct Scsi_Host *shost, u=
nsigned int queue_num)
 	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
=20
 	if (completed_reqs)
-		__ufshcd_transfer_req_compl(hba, completed_reqs);
+		__ufshcd_transfer_req_compl(hba, completed_reqs, compl_cmd);
=20
 	return completed_reqs !=3D 0;
 }
=20
+static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
+{
+	return __ufshcd_poll(shost, queue_num, NULL);
+}
+
 /**
  * ufshcd_mcq_compl_pending_transfer - MCQ mode function. It is
  * invoked from the error handler context or ufshcd_host_reset_and_resto=
re()
@@ -5630,7 +5646,7 @@ static void ufshcd_mcq_compl_pending_transfer(struc=
t ufs_hba *hba,
 			}
 			spin_unlock_irqrestore(&hwq->cq_lock, flags);
 		} else {
-			ufshcd_mcq_poll_cqe_lock(hba, hwq);
+			ufshcd_mcq_poll_cqe_lock(hba, hwq, NULL);
 		}
 	}
 }
@@ -6905,7 +6921,7 @@ static irqreturn_t ufshcd_handle_mcq_cq_events(stru=
ct ufs_hba *hba)
 			ufshcd_mcq_write_cqis(hba, events, i);
=20
 		if (events & UFSHCD_MCQ_CQIS_TAIL_ENT_PUSH_STS)
-			ufshcd_mcq_poll_cqe_lock(hba, hwq);
+			ufshcd_mcq_poll_cqe_lock(hba, hwq, NULL);
 	}
=20
 	return IRQ_HANDLED;
@@ -7398,7 +7414,7 @@ static int ufshcd_eh_device_reset_handler(struct sc=
si_cmnd *cmd)
 			    lrbp->lun =3D=3D lun) {
 				ufshcd_clear_cmd(hba, pos);
 				hwq =3D ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(lrbp->cmd));
-				ufshcd_mcq_poll_cqe_lock(hba, hwq);
+				ufshcd_mcq_poll_cqe_lock(hba, hwq, NULL);
 			}
 		}
 		err =3D 0;
@@ -7426,7 +7442,8 @@ static int ufshcd_eh_device_reset_handler(struct sc=
si_cmnd *cmd)
 				__func__, pos);
 		}
 	}
-	__ufshcd_transfer_req_compl(hba, pending_reqs & ~not_cleared_mask);
+	__ufshcd_transfer_req_compl(hba, pending_reqs & ~not_cleared_mask,
+				    NULL);
=20
 out:
 	hba->req_abort_count =3D 0;
@@ -7603,7 +7620,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		dev_err(hba->dev,
 		"%s: cmd was completed, but without a notifying intr, tag =3D %d",
 		__func__, tag);
-		__ufshcd_transfer_req_compl(hba, 1UL << tag);
+		__ufshcd_transfer_req_compl(hba, 1UL << tag, NULL);
 		goto release;
 	}
=20
diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
index c7a0ab9b1f59..4dbe334b36bb 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1715,7 +1715,7 @@ static irqreturn_t ufs_mtk_mcq_intr(int irq, void *=
__intr_info)
 		ufshcd_mcq_write_cqis(hba, events, qid);
=20
 	if (events & UFSHCD_MCQ_CQIS_TAIL_ENT_PUSH_STS)
-		ufshcd_mcq_poll_cqe_lock(hba, hwq);
+		ufshcd_mcq_poll_cqe_lock(hba, hwq, NULL);
=20
 	return IRQ_HANDLED;
 }
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index cca190d1c577..cc1d9614fcd6 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -1715,7 +1715,7 @@ static irqreturn_t ufs_qcom_mcq_esi_handler(int irq=
, void *data)
 	struct ufs_hw_queue *hwq =3D &hba->uhq[id];
=20
 	ufshcd_mcq_write_cqis(hba, 0x1, id);
-	ufshcd_mcq_poll_cqe_lock(hba, hwq);
+	ufshcd_mcq_poll_cqe_lock(hba, hwq, NULL);
=20
 	return IRQ_HANDLED;
 }
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index d32637d267f3..443afb97a637 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1284,7 +1284,8 @@ unsigned int ufshcd_mcq_queue_cfg_addr(struct ufs_h=
ba *hba);
 u32 ufshcd_mcq_read_cqis(struct ufs_hba *hba, int i);
 void ufshcd_mcq_write_cqis(struct ufs_hba *hba, u32 val, int i);
 unsigned long ufshcd_mcq_poll_cqe_lock(struct ufs_hba *hba,
-					 struct ufs_hw_queue *hwq);
+				       struct ufs_hw_queue *hwq,
+				       struct scsi_cmnd **compl_cmd);
 void ufshcd_mcq_make_queues_operational(struct ufs_hba *hba);
 void ufshcd_mcq_enable_esi(struct ufs_hba *hba);
 void ufshcd_mcq_enable(struct ufs_hba *hba);
