Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773D130649D
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 20:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760473325; cv=none; b=MgtKV3QWlU4U9D9BKgxW9WEM3m/UUAFv+WDpqlqZOWPQaNqcExK13zZ6YxxCVHdaSDvZqetEGdSAVEy6n7BHqbcuOn3Q+BBnvcjoCBbKBmZy55rsJR0zlf/uQHeXqHElcnl6gDUqzJxOe8R8Gvx7sWbmsEpK3yiAvwphkvtjpyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760473325; c=relaxed/simple;
	bh=EhhMScIa4itksA7Oqk4M2eRhRlECdtvExus1K9CIJB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HshpbSyTNIS+LAjiaEr5NbwVQEr3Qt2tQQqudHHrxB3DFUY+sFvL0NtyQjPYmRvwNVN90jhSZIrCxLNBaqCj2h3s6ZBQUHM+HNRp3QNjcYMBdIO7/RVe1YvIMjg5ExLB1OYJ60jxuzYhqx3JP1fUsGJuIe9l+lZ2ndPEMu7I2GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=XzldqKRM; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="XzldqKRM"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmQcB5bCXzm0ytC;
	Tue, 14 Oct 2025 20:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760473319; x=1763065320; bh=HBuib
	90ILXSBa2ePhjeNZyIKXsO8AxSyi4XY4on9JV4=; b=XzldqKRMtJKeqHeB5nWpC
	T4MiheSPsFpBpQecuuUUlQIZfh11oTDyioqq2URLH4ebVppX4+JhbM3RYh9634kN
	DOrftNJUM9zR28I/0Khz3N+uXwaKe6hY/QZa06iRU2T+B3d+o3j9CogHr39cXUta
	k9OR7Hz+U8FMUOgtgbBR1ZagSt46pFYPLEpu4+kR4ciWwAfeW7M909rXXO53Su6M
	imII5JpfvNMaYY79cScJK2XknM+5oKymLGJ67oFPRDmS5Qc2c55yhePyrOFZUPjk
	cXFXvFHRH+bVLJkLkks7VJ03fcblnsWOo5qn41HPBUmnJeBFJ+1SU9eY4DjkEMTn
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id YBwJfznF52Iv; Tue, 14 Oct 2025 20:21:59 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmQbw2czpzm0yVJ;
	Tue, 14 Oct 2025 20:21:47 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	"ping.gao" <ping.gao@samsung.com>,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Ziqi Chen <quic_ziqichen@quicinc.com>,
	Bean Huo <beanhuo@micron.com>,
	Can Guo <quic_cang@quicinc.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Avri Altman <avri.altman@sandisk.com>,
	Nitin Rawat <quic_nitirawa@quicinc.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH v6 28/28] ufs: core: Switch to scsi_get_internal_cmd()
Date: Tue, 14 Oct 2025 13:16:10 -0700
Message-ID: <20251014201707.3396650-29-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
In-Reply-To: <20251014201707.3396650-1-bvanassche@acm.org>
References: <20251014201707.3396650-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Instead of storing the tag of the reserved command in hba->reserved_slot,
use scsi_get_internal_cmd() and scsi_put_internal_cmd() to allocate the
tag for the reserved command dynamically. Add
ufshcd_queue_reserved_command() for submitting reserved commands. Add
support in ufshcd_abort() for device management commands. Use
blk_execute_rq() for submitting reserved commands. Remove the code and
data structures that became superfluous. This includes
ufshcd_wait_for_dev_cmd(), hba->reserved_slot and ufs_dev_cmd.complete.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-mcq.c     |  19 ++-
 drivers/ufs/core/ufshcd-priv.h |  25 +---
 drivers/ufs/core/ufshcd.c      | 218 ++++++++++++++++-----------------
 include/ufs/ufshcd.h           |   6 -
 4 files changed, 115 insertions(+), 153 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index dc2d6620588f..cd3b55e7e1ac 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -479,9 +479,6 @@ int ufshcd_mcq_init(struct ufs_hba *hba)
 		mutex_init(&hwq->sq_mutex);
 	}
=20
-	/* The very first HW queue serves device commands */
-	hba->dev_cmd_queue =3D &hba->uhq[0];
-
 	host->host_tagset =3D 1;
 	return 0;
 }
@@ -536,6 +533,7 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int ta=
sk_tag)
 {
 	struct scsi_cmnd *cmd =3D ufshcd_tag_to_cmd(hba, task_tag);
 	struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
+	struct request *rq =3D scsi_cmd_to_rq(cmd);
 	struct ufs_hw_queue *hwq;
 	void __iomem *reg, *opr_sqd_base;
 	u32 nexus, id, val;
@@ -544,15 +542,12 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int =
task_tag)
 	if (hba->quirks & UFSHCD_QUIRK_MCQ_BROKEN_RTC)
 		return -ETIMEDOUT;
=20
-	if (task_tag !=3D hba->reserved_slot) {
-		if (!cmd)
-			return -EINVAL;
-		hwq =3D ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
-		if (!hwq)
-			return 0;
-	} else {
-		hwq =3D hba->dev_cmd_queue;
-	}
+	if (!cmd)
+		return -EINVAL;
+
+	hwq =3D ufshcd_mcq_req_to_hwq(hba, rq);
+	if (!hwq)
+		return 0;
=20
 	id =3D hwq->id;
=20
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-pri=
v.h
index 3222c4d3ceb4..35c3277a4373 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -367,30 +367,7 @@ static inline bool ufs_is_valid_unit_desc_lun(struct=
 ufs_dev_info *dev_info, u8
 static inline struct scsi_cmnd *ufshcd_tag_to_cmd(struct ufs_hba *hba, u=
32 tag)
 {
 	struct blk_mq_tags *tags =3D hba->host->tag_set.shared_tags;
-	struct request *rq;
-
-	/*
-	 * Handle reserved tags differently because the UFS driver does not
-	 * call blk_mq_alloc_request() for allocating reserved requests.
-	 * Allocating reserved tags with blk_mq_alloc_request() would require
-	 * the following:
-	 * - Allocate an additional request queue from &hba->host->tag_set for
-	 *   allocating reserved requests from.
-	 * - For that request queue, allocate a SCSI device.
-	 * - Calling blk_mq_alloc_request(hba->dev_mgmt_queue, REQ_OP_DRV_OUT,
-	 *   BLK_MQ_REQ_RESERVED) for allocating a reserved request and
-	 *   blk_mq_free_request() for freeing reserved requests.
-	 * - Set the .device pointer for these reserved requests.
-	 * - Submit reserved requests with blk_execute_rq().
-	 * - Modify ufshcd_queuecommand() such that it handles reserved request=
s
-	 *   in another way than SCSI requests.
-	 * - Modify ufshcd_compl_one_cqe() such that it calls scsi_done() for
-	 *   device management commands.
-	 * - Modify all callback functions called by blk_mq_tagset_busy_iter()
-	 *   calls in the UFS driver and skip device management commands.
-	 */
-	rq =3D tag < UFSHCD_NUM_RESERVED ? tags->static_rqs[tag] :
-					 blk_mq_tag_to_rq(tags, tag);
+	struct request *rq =3D blk_mq_tag_to_rq(tags, tag);
=20
 	if (WARN_ON_ONCE(!rq))
 		return NULL;
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 62c11f3e43ba..684937ebf754 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2355,7 +2355,7 @@ static void ufshcd_update_monitor(struct ufs_hba *h=
ba, struct scsi_cmnd *cmd)
  */
 static bool ufshcd_is_scsi_cmd(struct scsi_cmnd *cmd)
 {
-	return blk_mq_request_started(scsi_cmd_to_rq(cmd));
+	return !blk_mq_is_reserved_rq(scsi_cmd_to_rq(cmd));
 }
=20
 /**
@@ -2486,7 +2486,6 @@ static inline int ufshcd_hba_capabilities(struct uf=
s_hba *hba)
 	hba->nutrs =3D (hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS_SDB) +=
 1;
 	hba->nutmrs =3D
 	((hba->capabilities & MASK_TASK_MANAGEMENT_REQUEST_SLOTS) >> 16) + 1;
-	hba->reserved_slot =3D 0;
=20
 	hba->nortt =3D FIELD_GET(MASK_NUMBER_OUTSTANDING_RTT, hba->capabilities=
) + 1;
=20
@@ -3114,6 +3113,20 @@ static int ufshcd_queuecommand(struct Scsi_Host *h=
ost, struct scsi_cmnd *cmd)
 	return err;
 }
=20
+static int ufshcd_queue_reserved_command(struct Scsi_Host *host,
+					 struct scsi_cmnd *cmd)
+{
+	struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
+	struct request *rq =3D scsi_cmd_to_rq(cmd);
+	struct ufs_hba *hba =3D shost_priv(host);
+	struct ufs_hw_queue *hwq =3D
+		hba->mcq_enabled ? ufshcd_mcq_req_to_hwq(hba, rq) : NULL;
+
+	ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND, lrbp->ucd_req_ptr);
+	ufshcd_send_command(hba, cmd, hwq);
+	return 0;
+}
+
 static void ufshcd_setup_dev_cmd(struct ufs_hba *hba, struct scsi_cmnd *=
cmd,
 				 enum dev_cmd_type cmd_type, u8 lun, int tag)
 {
@@ -3243,84 +3256,6 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba, str=
uct ufshcd_lrb *lrbp)
 	return err;
 }
=20
-/*
- * Return: 0 upon success; > 0 in case the UFS device reported an OCS er=
ror;
- * < 0 if another error occurred.
- */
-static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
-		struct ufshcd_lrb *lrbp, int max_timeout)
-{
-	struct scsi_cmnd *cmd =3D (struct scsi_cmnd *)lrbp - 1;
-	const int tag =3D scsi_cmd_to_rq(cmd)->tag;
-	unsigned long time_left =3D msecs_to_jiffies(max_timeout);
-	unsigned long flags;
-	bool pending;
-	int err;
-
-retry:
-	time_left =3D wait_for_completion_timeout(&hba->dev_cmd.complete,
-						time_left);
-
-	if (likely(time_left)) {
-		err =3D ufshcd_get_tr_ocs(lrbp, NULL);
-	} else {
-		err =3D -ETIMEDOUT;
-		dev_dbg(hba->dev, "%s: dev_cmd request timedout, tag %d\n",
-			__func__, tag);
-
-		/* MCQ mode */
-		if (hba->mcq_enabled) {
-			/* successfully cleared the command, retry if needed */
-			if (ufshcd_clear_cmd(hba, tag) =3D=3D 0)
-				err =3D -EAGAIN;
-			return err;
-		}
-
-		/* SDB mode */
-		if (ufshcd_clear_cmd(hba, tag) =3D=3D 0) {
-			/* successfully cleared the command, retry if needed */
-			err =3D -EAGAIN;
-			/*
-			 * Since clearing the command succeeded we also need to
-			 * clear the task tag bit from the outstanding_reqs
-			 * variable.
-			 */
-			spin_lock_irqsave(&hba->outstanding_lock, flags);
-			pending =3D test_bit(tag, &hba->outstanding_reqs);
-			if (pending)
-				__clear_bit(tag, &hba->outstanding_reqs);
-			spin_unlock_irqrestore(&hba->outstanding_lock, flags);
-
-			if (!pending) {
-				/*
-				 * The completion handler ran while we tried to
-				 * clear the command.
-				 */
-				time_left =3D 1;
-				goto retry;
-			}
-		} else {
-			dev_err(hba->dev, "%s: failed to clear tag %d\n",
-				__func__, tag);
-
-			spin_lock_irqsave(&hba->outstanding_lock, flags);
-			pending =3D test_bit(tag, &hba->outstanding_reqs);
-			spin_unlock_irqrestore(&hba->outstanding_lock, flags);
-
-			if (!pending) {
-				/*
-				 * The completion handler ran while we tried to
-				 * clear the command.
-				 */
-				time_left =3D 1;
-				goto retry;
-			}
-		}
-	}
-
-	return err;
-}
-
 static void ufshcd_dev_man_lock(struct ufs_hba *hba)
 {
 	ufshcd_hold(hba);
@@ -3335,6 +3270,29 @@ static void ufshcd_dev_man_unlock(struct ufs_hba *=
hba)
 	ufshcd_release(hba);
 }
=20
+static struct scsi_cmnd *ufshcd_get_dev_mgmt_cmd(struct ufs_hba *hba)
+{
+	/*
+	 * The caller must hold this lock to guarantee that the NOWAIT
+	 * allocation will succeed.
+	 */
+	lockdep_assert_held(&hba->dev_cmd.lock);
+
+	/*
+	 * Allocate from hardware queue 0 instead of the hardware queue
+	 * corresponding to the current CPU because some UFSHCI controllers
+	 * only support hardware queue 0 for device management commands.
+	 */
+	return scsi_get_internal_cmd_hctx(
+		hba->host->pseudo_sdev, DMA_TO_DEVICE,
+		BLK_MQ_REQ_RESERVED | BLK_MQ_REQ_NOWAIT, 0);
+}
+
+static void ufshcd_put_dev_mgmt_cmd(struct scsi_cmnd *cmd)
+{
+	scsi_put_internal_cmd(cmd);
+}
+
 /*
  * Return: 0 upon success; > 0 in case the UFS device reported an OCS er=
ror;
  * < 0 if another error occurred.
@@ -3343,16 +3301,14 @@ static int ufshcd_issue_dev_cmd(struct ufs_hba *h=
ba, struct scsi_cmnd *cmd,
 				const u32 tag, int timeout)
 {
 	struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
-	int err;
-
-	ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND, lrbp->ucd_req_ptr);
-	ufshcd_send_command(hba, cmd, hba->dev_cmd_queue);
-	err =3D ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
-
-	ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR : UFS_QUERY_COMP,
-				    (struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
+	struct request *rq =3D scsi_cmd_to_rq(cmd);
+	blk_status_t sts;
=20
-	return err;
+	rq->timeout =3D timeout;
+	sts =3D blk_execute_rq(rq, true);
+	if (sts !=3D BLK_STS_OK)
+		return blk_status_to_errno(sts);
+	return lrbp->utr_descriptor_ptr->header.ocs;
 }
=20
 /**
@@ -3370,23 +3326,31 @@ static int ufshcd_issue_dev_cmd(struct ufs_hba *h=
ba, struct scsi_cmnd *cmd,
 static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 		enum dev_cmd_type cmd_type, int timeout)
 {
-	const u32 tag =3D hba->reserved_slot;
-	struct scsi_cmnd *cmd =3D ufshcd_tag_to_cmd(hba, tag);
+	struct scsi_cmnd *cmd =3D ufshcd_get_dev_mgmt_cmd(hba);
 	struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
+	u32 tag;
 	int err;
=20
-	/* Protects use of hba->reserved_slot. */
+	/* Protects use of hba->dev_cmd. */
 	lockdep_assert_held(&hba->dev_cmd.lock);
=20
+	if (WARN_ON_ONCE(!cmd))
+		return -ENOMEM;
+
+	tag =3D scsi_cmd_to_rq(cmd)->tag;
+
 	err =3D ufshcd_compose_dev_cmd(hba, cmd, cmd_type, tag);
 	if (unlikely(err))
-		return err;
+		goto out;
=20
 	err =3D ufshcd_issue_dev_cmd(hba, cmd, tag, timeout);
-	if (err)
-		return err;
+	if (err =3D=3D 0)
+		err =3D ufshcd_dev_cmd_completion(hba, lrbp);
+
+out:
+	ufshcd_put_dev_mgmt_cmd(cmd);
=20
-	return ufshcd_dev_cmd_completion(hba, lrbp);
+	return err;
 }
=20
 /**
@@ -5654,6 +5618,10 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int=
 task_tag,
 	struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
 	enum utp_ocs ocs;
=20
+	if (WARN_ONCE(!cmd, "cqe->command_desc_base_addr =3D %#llx\n",
+		      le64_to_cpu(cqe->command_desc_base_addr)))
+		return;
+
 	if (hba->monitor.enabled) {
 		lrbp->compl_time_stamp =3D ktime_get();
 		lrbp->compl_time_stamp_local_clock =3D local_clock();
@@ -5664,15 +5632,21 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, in=
t task_tag,
 		ufshcd_add_command_trace(hba, cmd, UFS_CMD_COMP);
 		cmd->result =3D ufshcd_transfer_rsp_status(hba, cmd, cqe);
 		ufshcd_release_scsi_cmd(hba, cmd);
-		/* Do not touch lrbp after scsi done */
-		scsi_done(cmd);
 	} else {
 		if (cqe) {
 			ocs =3D le32_to_cpu(cqe->status) & MASK_OCS;
 			lrbp->utr_descriptor_ptr->header.ocs =3D ocs;
+		} else {
+			ocs =3D lrbp->utr_descriptor_ptr->header.ocs;
 		}
-		complete(&hba->dev_cmd.complete);
+		ufshcd_add_query_upiu_trace(
+			hba,
+			ocs =3D=3D OCS_SUCCESS ? UFS_QUERY_COMP : UFS_QUERY_ERR,
+			(struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
+		cmd->result =3D 0;
 	}
+	/* Do not touch lrbp after scsi_done() has been called. */
+	scsi_done(cmd);
 }
=20
 /**
@@ -7382,15 +7356,20 @@ static int ufshcd_issue_devman_upiu_cmd(struct uf=
s_hba *hba,
 					enum dev_cmd_type cmd_type,
 					enum query_opcode desc_op)
 {
-	const u32 tag =3D hba->reserved_slot;
-	struct scsi_cmnd *cmd =3D ufshcd_tag_to_cmd(hba, tag);
+	struct scsi_cmnd *cmd =3D ufshcd_get_dev_mgmt_cmd(hba);
 	struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
+	u32 tag;
 	int err =3D 0;
 	u8 upiu_flags;
=20
-	/* Protects use of hba->reserved_slot. */
+	/* Protects use of hba->dev_cmd. */
 	lockdep_assert_held(&hba->dev_cmd.lock);
=20
+	if (WARN_ON_ONCE(!cmd))
+		return -ENOMEM;
+
+	tag =3D scsi_cmd_to_rq(cmd)->tag;
+
 	ufshcd_setup_dev_cmd(hba, cmd, cmd_type, 0, tag);
=20
 	ufshcd_prepare_req_desc_hdr(hba, lrbp, &upiu_flags, DMA_NONE, 0);
@@ -7434,6 +7413,8 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_=
hba *hba,
 		}
 	}
=20
+	ufshcd_put_dev_mgmt_cmd(cmd);
+
 	return err;
 }
=20
@@ -7527,9 +7508,9 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hba=
 *hba, struct utp_upiu_req *r
 			 struct ufs_ehs *rsp_ehs, int sg_cnt, struct scatterlist *sg_list,
 			 enum dma_data_direction dir)
 {
-	const u32 tag =3D hba->reserved_slot;
-	struct scsi_cmnd *cmd =3D ufshcd_tag_to_cmd(hba, tag);
-	struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
+	struct scsi_cmnd *cmd;
+	struct ufshcd_lrb *lrbp;
+	u32 tag;
 	int err =3D 0;
 	int result;
 	u8 upiu_flags;
@@ -7537,9 +7518,18 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hb=
a *hba, struct utp_upiu_req *r
 	u16 ehs_len;
 	int ehs =3D (hba->capabilities & MASK_EHSLUTRD_SUPPORTED) ? 2 : 0;
=20
-	/* Protects use of hba->reserved_slot. */
 	ufshcd_dev_man_lock(hba);
=20
+	cmd =3D ufshcd_get_dev_mgmt_cmd(hba);
+
+	if (WARN_ON_ONCE(!cmd)) {
+		ufshcd_dev_man_unlock(hba);
+		return -ENOMEM;
+	}
+
+	lrbp =3D scsi_cmd_priv(cmd);
+	tag =3D scsi_cmd_to_rq(cmd)->tag;
+
 	ufshcd_setup_dev_cmd(hba, cmd, DEV_CMD_TYPE_RPMB, UFS_UPIU_RPMB_WLUN,
 			     tag);
=20
@@ -7586,6 +7576,8 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hba=
 *hba, struct utp_upiu_req *r
 		}
 	}
=20
+	ufshcd_put_dev_mgmt_cmd(cmd);
+
 	ufshcd_dev_man_unlock(hba);
=20
 	return err ? : result;
@@ -7756,7 +7748,8 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *host =3D cmd->device->host;
 	struct ufs_hba *hba =3D shost_priv(host);
-	int tag =3D scsi_cmd_to_rq(cmd)->tag;
+	struct request *rq =3D scsi_cmd_to_rq(cmd);
+	int tag =3D rq->tag;
 	struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
 	unsigned long flags;
 	int err =3D FAILED;
@@ -7786,7 +7779,8 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	 * to reduce repeated printouts. For other aborted requests only print
 	 * basic details.
 	 */
-	scsi_print_command(cmd);
+	if (ufshcd_is_scsi_cmd(cmd))
+		scsi_print_command(cmd);
 	if (!hba->req_abort_count) {
 		ufshcd_update_evt_hist(hba, UFS_EVT_ABORT, tag);
 		ufshcd_print_evt_hist(hba);
@@ -7838,7 +7832,10 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		goto release;
 	}
=20
-	err =3D ufshcd_try_to_abort_task(hba, tag);
+	if (blk_mq_is_reserved_rq(rq))
+		err =3D ufshcd_clear_cmd(hba, tag);
+	else
+		err =3D ufshcd_try_to_abort_task(hba, tag);
 	if (err) {
 		dev_err(hba->dev, "%s: failed with err %d\n", __func__, err);
 		ufshcd_set_req_abort_skip(hba, hba->outstanding_reqs);
@@ -9208,6 +9205,7 @@ static const struct scsi_host_template ufshcd_drive=
r_template =3D {
 	.cmd_size		=3D sizeof(struct ufshcd_lrb),
 	.init_cmd_priv		=3D ufshcd_init_cmd_priv,
 	.queuecommand		=3D ufshcd_queuecommand,
+	.queue_reserved_command	=3D ufshcd_queue_reserved_command,
 	.nr_reserved_cmds	=3D UFSHCD_NUM_RESERVED,
 	.mq_poll		=3D ufshcd_poll,
 	.sdev_init		=3D ufshcd_sdev_init,
@@ -10753,8 +10751,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem=
 *mmio_base, unsigned int irq)
 						UFS_SLEEP_PWR_MODE,
 						UIC_LINK_HIBERN8_STATE);
=20
-	init_completion(&hba->dev_cmd.complete);
-
 	err =3D ufshcd_hba_init(hba);
 	if (err)
 		goto out_error;
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 54e0653c53f5..5fee5da4d8ea 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -236,13 +236,11 @@ struct ufs_query {
  * struct ufs_dev_cmd - all assosiated fields with device management com=
mands
  * @type: device management command type - Query, NOP OUT
  * @lock: lock to allow one command at a time
- * @complete: internal commands completion
  * @query: Device management query information
  */
 struct ufs_dev_cmd {
 	enum dev_cmd_type type;
 	struct mutex lock;
-	struct completion complete;
 	struct ufs_query query;
 };
=20
@@ -838,7 +836,6 @@ enum ufshcd_mcq_opr {
  * @nutrs: Transfer Request Queue depth supported by controller
  * @nortt - Max outstanding RTTs supported by controller
  * @nutmrs: Task Management Queue depth supported by controller
- * @reserved_slot: Used to submit device commands. Protected by @dev_cmd=
.lock.
  * @ufs_version: UFS Version to which controller complies
  * @vops: pointer to variant specific operations
  * @vps: pointer to variant specific parameters
@@ -929,7 +926,6 @@ enum ufshcd_mcq_opr {
  * @res: array of resource info of MCQ registers
  * @mcq_base: Multi circular queue registers base address
  * @uhq: array of supported hardware queues
- * @dev_cmd_queue: Queue for issuing device management commands
  * @mcq_opr: MCQ operation and runtime registers
  * @ufs_rtc_update_work: A work for UFS RTC periodic update
  * @pm_qos_req: PM QoS request handle
@@ -981,7 +977,6 @@ struct ufs_hba {
 	int nortt;
 	u32 mcq_capabilities;
 	int nutmrs;
-	u32 reserved_slot;
 	u32 ufs_version;
 	const struct ufs_hba_variant_ops *vops;
 	struct ufs_hba_variant_params *vps;
@@ -1099,7 +1094,6 @@ struct ufs_hba {
 	bool mcq_esi_enabled;
 	void __iomem *mcq_base;
 	struct ufs_hw_queue *uhq;
-	struct ufs_hw_queue *dev_cmd_queue;
 	struct ufshcd_mcq_opr_info_t mcq_opr[OPR_MAX];
=20
 	struct delayed_work ufs_rtc_update_work;
