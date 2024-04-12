Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EA66AA7
	for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2024 00:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712880226; cv=none; b=Zn+5qG7ZaknsTxgkuKa6h8a0pQlsEL7Lsd57plrpQvBCxhFtGz1bUtweAsRyens19VIQGsiFjWaMigOYpq7ycr0deJgvQY8kVO0BRyS6ZpIT8xxLplHMsXIzO4t54yTiaZjJyXEVRzZeefoqtDP8faKVViDmmK2uJJeS5qOHkQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712880226; c=relaxed/simple;
	bh=eQ/qhs1ik29keoE15NCTXV32HbfcEnrHkpRhCTgMh1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KKV7AXlAOOV4LquTEYGUIvozxKmTXI+oIOSiMBxmiU0HjqtbAcvgbUEBn9qSbseqWrolRsIUWfQ+Nz4FHHRa64hCjBdgvO6psJWvhJN6vBBTuvMfNnrMaeHiZmrPbsoWkF2YeVqxvOdzN2p9lB9wDG/UzplKxHVzq/tMd1zm1RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=B42RdYrm; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="B42RdYrm"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VFxcJ2t7Rz6Cnk8t;
	Fri, 12 Apr 2024 00:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1712880199; x=1715472200; bh=3zKPl
	niePqLPgrhgP09Zb8NAsJ/pSjX7dV9ryrPihLI=; b=B42RdYrmJrKFXRHr25X3/
	FTX1MBhYczYQ19GfG35ZBOZocUqnrvl9/P0PdSpSyNUbY/chtEj4Bek7Yb7Yut9R
	9QMGR6B3ylBXRYMLy3OQZ1YdNIiEoIz+4VZwvMUdpSTMGCALXW0PJMviSheNmlqd
	LOWp97C/Jw7SCuOVIu/+CZqEcbRLCiWKHo2uTURWZYaYASqNDIb+B4e4ev7lZr77
	VMtOmDZvyFkGdYn45o+texT17ImeXtCQIjhYh2aYt9MkWsLw4dHlU3Oaz88fz5xB
	fTlU3I9wM18o+7RzdtkQBMrzJCMNJ6QHsrXDssD71NpEcyQBcloDiDWsaNHhilIN
	g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8Cz9c1E4F2P9; Fri, 12 Apr 2024 00:03:19 +0000 (UTC)
Received: from bvanassche-glaptop2.roam.corp.google.com (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VFxbm2cLVz6Cnk8m;
	Fri, 12 Apr 2024 00:03:16 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Stanley Jhu <chu.stanley@gmail.com>,
	Po-Wen Kao <powen.kao@mediatek.com>,
	Can Guo <quic_cang@quicinc.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	ChanWoo Lee <cw9316.lee@samsung.com>,
	Yang Li <yang.lee@linux.alibaba.com>,
	zhanghui <zhanghui31@xiaomi.com>,
	Keoseong Park <keosung.park@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>,
	Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 3/4] scsi: ufs: Make the polling code report which command has been completed
Date: Thu, 11 Apr 2024 17:02:23 -0700
Message-ID: <20240412000246.1167600-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
In-Reply-To: <20240412000246.1167600-1-bvanassche@acm.org>
References: <20240412000246.1167600-1-bvanassche@acm.org>
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
 drivers/ufs/core/ufs-mcq.c     | 23 +++++++++++++-------
 drivers/ufs/core/ufshcd-priv.h |  4 ++--
 drivers/ufs/core/ufshcd.c      | 39 +++++++++++++++++++++++-----------
 drivers/ufs/host/ufs-qcom.c    |  2 +-
 include/ufs/ufshcd.h           |  3 ++-
 5 files changed, 47 insertions(+), 24 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 228975caf68e..5a02e1b3b3a5 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -268,17 +268,20 @@ static int ufshcd_mcq_get_tag(struct ufs_hba *hba, =
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
+		/* Mark the CQE as invalid. */
 		cqe->command_desc_base_addr =3D 0;
+		return ufshcd_compl_one_cqe(hba, tag, cqe, compl_cmd);
 	}
+	return false;
 }
=20
 void ufshcd_mcq_compl_all_cqes_lock(struct ufs_hba *hba,
@@ -289,7 +292,7 @@ void ufshcd_mcq_compl_all_cqes_lock(struct ufs_hba *h=
ba,
=20
 	spin_lock_irqsave(&hwq->cq_lock, flags);
 	while (entries > 0) {
-		ufshcd_mcq_process_cqe(hba, hwq);
+		ufshcd_mcq_process_cqe(hba, hwq, NULL);
 		ufshcd_mcq_inc_cq_head_slot(hwq);
 		entries--;
 	}
@@ -299,8 +302,10 @@ void ufshcd_mcq_compl_all_cqes_lock(struct ufs_hba *=
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
@@ -308,7 +313,9 @@ unsigned long ufshcd_mcq_poll_cqe_lock(struct ufs_hba=
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
index 66198eee51b0..08abdd763c51 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5540,9 +5540,12 @@ void ufshcd_release_scsi_cmd(struct ufs_hba *hba,
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
@@ -5559,6 +5562,7 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int =
task_tag,
 		ufshcd_release_scsi_cmd(hba, lrbp);
 		/* Do not touch lrbp after scsi done */
 		scsi_done(cmd);
+		return cmd =3D=3D compl_cmd;
 	} else if (lrbp->command_type =3D=3D UTP_CMD_TYPE_DEV_MANAGE ||
 		   lrbp->command_type =3D=3D UTP_CMD_TYPE_UFS_STORAGE) {
 		if (hba->dev_cmd.complete) {
@@ -5569,6 +5573,7 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int =
task_tag,
 			complete(hba->dev_cmd.complete);
 		}
 	}
+	return false;
 }
=20
 /**
@@ -5577,12 +5582,15 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, in=
t task_tag,
  * @completed_reqs: bitmask that indicates which requests to complete
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
@@ -5609,7 +5617,8 @@ static void ufshcd_clear_polled(struct ufs_hba *hba=
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
@@ -5620,7 +5629,7 @@ static int ufshcd_poll(struct Scsi_Host *shost, uns=
igned int queue_num)
 		WARN_ON_ONCE(queue_num =3D=3D UFSHCD_POLL_FROM_INTERRUPT_CONTEXT);
 		hwq =3D &hba->uhq[queue_num];
=20
-		return ufshcd_mcq_poll_cqe_lock(hba, hwq);
+		return ufshcd_mcq_poll_cqe_lock(hba, hwq, compl_cmd);
 	}
=20
 	spin_lock_irqsave(&hba->outstanding_lock, flags);
@@ -5637,11 +5646,16 @@ static int ufshcd_poll(struct Scsi_Host *shost, u=
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
@@ -5685,7 +5699,7 @@ static void ufshcd_mcq_compl_pending_transfer(struc=
t ufs_hba *hba,
 			}
 			spin_unlock_irqrestore(&hwq->cq_lock, flags);
 		} else {
-			ufshcd_mcq_poll_cqe_lock(hba, hwq);
+			ufshcd_mcq_poll_cqe_lock(hba, hwq, NULL);
 		}
 	}
 }
@@ -6960,7 +6974,7 @@ static irqreturn_t ufshcd_handle_mcq_cq_events(stru=
ct ufs_hba *hba)
 			ufshcd_mcq_write_cqis(hba, events, i);
=20
 		if (events & UFSHCD_MCQ_CQIS_TAIL_ENT_PUSH_STS)
-			ufshcd_mcq_poll_cqe_lock(hba, hwq);
+			ufshcd_mcq_poll_cqe_lock(hba, hwq, NULL);
 	}
=20
 	return IRQ_HANDLED;
@@ -7453,7 +7467,7 @@ static int ufshcd_eh_device_reset_handler(struct sc=
si_cmnd *cmd)
 			    lrbp->lun =3D=3D lun) {
 				ufshcd_clear_cmd(hba, pos);
 				hwq =3D ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(lrbp->cmd));
-				ufshcd_mcq_poll_cqe_lock(hba, hwq);
+				ufshcd_mcq_poll_cqe_lock(hba, hwq, NULL);
 			}
 		}
 		err =3D 0;
@@ -7481,7 +7495,8 @@ static int ufshcd_eh_device_reset_handler(struct sc=
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
@@ -7658,7 +7673,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		dev_err(hba->dev,
 		"%s: cmd was completed, but without a notifying intr, tag =3D %d",
 		__func__, tag);
-		__ufshcd_transfer_req_compl(hba, 1UL << tag);
+		__ufshcd_transfer_req_compl(hba, 1UL << tag, NULL);
 		goto release;
 	}
=20
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index b3ca9b3bf94b..0598cd8f53dd 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -1704,7 +1704,7 @@ static irqreturn_t ufs_qcom_mcq_esi_handler(int irq=
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
index 4ba826fe7b62..8fac282e0476 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1263,7 +1263,8 @@ void ufshcd_mcq_config_mac(struct ufs_hba *hba, u32=
 max_active_cmds);
 u32 ufshcd_mcq_read_cqis(struct ufs_hba *hba, int i);
 void ufshcd_mcq_write_cqis(struct ufs_hba *hba, u32 val, int i);
 unsigned long ufshcd_mcq_poll_cqe_lock(struct ufs_hba *hba,
-					 struct ufs_hw_queue *hwq);
+				       struct ufs_hw_queue *hwq,
+				       struct scsi_cmnd **compl_cmd);
 void ufshcd_mcq_make_queues_operational(struct ufs_hba *hba);
 void ufshcd_mcq_enable_esi(struct ufs_hba *hba);
 void ufshcd_mcq_enable(struct ufs_hba *hba);
