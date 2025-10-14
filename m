Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11B5305E38
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 20:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760473290; cv=none; b=udpUwhYvRyng/0V9Rnbv7iQ4/04k1Ou9qisyzUIpYLobsIM+6vT7d5mfF1ZdNGSOsLD6GGAZ1rousN2+Hcm+Ud4LVjTOoau5o8TscM4c+Bif4oWW0cVWdNwpa6LdXgv0ljUf31YB8C6Elop8ERn/wJCGgzHrlcImxdymub5Sw2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760473290; c=relaxed/simple;
	bh=rdOGyRPSTx8DIdyfxWglT7Bfe6MGidhjZCEm3BKV5kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nkNBb29zVXW3CVgeZVtFGilHgNzbGlXPA6c66XtOwvUfWQyWa/4viNwV55pkX/cLVt173084dSaCrSrAO+muveZa/xdUA2t4hyQa86lJt7NgHTBOv6XR/cMeXgLOBEZIL8Elz6off3aeAkuK3ybTOGnHxKoRaEfJy8kGy2Q6ylc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Kvhhs2Xn; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Kvhhs2Xn"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmQbX2HXDzm0yTq;
	Tue, 14 Oct 2025 20:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760473285; x=1763065286; bh=WEUH6
	saqSFEUFSlF0SHe8r88IAn7AapHmcB7lkecPmo=; b=Kvhhs2XnxOab4QctY8kuA
	MB5n91LcZEETEIcaND8wp8plHx3EFhP37GWPNsfFTdFJMrGfMcAOoEuGCOCn6ZYr
	vFOUKyFgXjB+mennr5qorG8qeAGt6e/ilTlMNHd35/T6xaM45zmHXzxPWzajLE3w
	fw4n8etK7Q4GswJA2s3596x9/24W5iG4Uz3NF3Lxl6uO6B7zOQSZ9DjiyeJvJREP
	L4VLR8U6HvgavDQsndgfGmkoNW63nBtyiZRO0JA+AY/V0cV0ODCmeBQqDtdz/B8K
	LaABVYzy7gmMa//6WjUvLhTPQZY/A9P8rFND3GgXsHMR1mCfsHkk28jagiVMR/k9
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id vFkybcFzsvu5; Tue, 14 Oct 2025 20:21:25 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmQbK1fjfzm0ytj;
	Tue, 14 Oct 2025 20:21:16 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Can Guo <quic_cang@quicinc.com>,
	Nitin Rawat <quic_nitirawa@quicinc.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH v6 25/28] ufs: core: Remove the ufshcd_lrb task_tag member
Date: Tue, 14 Oct 2025 13:16:07 -0700
Message-ID: <20251014201707.3396650-26-bvanassche@acm.org>
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

Remove the ufshcd_lrb task_tag member and use scsi_cmd_to_rq(cmd)->tag
instead. Use rq->tag instead of lrbp->task_tag. This patch reduces the
size of struct ufshcd_lrb.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 62 +++++++++++++++++++--------------------
 include/ufs/ufshcd.h      |  1 -
 2 files changed, 30 insertions(+), 33 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index da2d9e398c61..c20e2f87a65f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -599,7 +599,7 @@ static void ufshcd_print_tr(struct ufs_hba *hba, stru=
ct scsi_cmnd *cmd,
 			    bool pr_prdt)
 {
 	struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
-	const int tag =3D lrbp->task_tag;
+	const int tag =3D scsi_cmd_to_rq(cmd)->tag;
 	int prdt_length;
=20
 	if (hba->monitor.enabled) {
@@ -2368,6 +2368,7 @@ static inline void ufshcd_send_command(struct ufs_h=
ba *hba,
 				       struct ufs_hw_queue *hwq)
 {
 	struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
+	const int tag =3D scsi_cmd_to_rq(cmd)->tag;
 	unsigned long flags;
=20
 	if (hba->monitor.enabled) {
@@ -2396,11 +2397,10 @@ static inline void ufshcd_send_command(struct ufs=
_hba *hba,
 	} else {
 		spin_lock_irqsave(&hba->outstanding_lock, flags);
 		if (hba->vops && hba->vops->setup_xfer_req)
-			hba->vops->setup_xfer_req(hba, lrbp->task_tag,
+			hba->vops->setup_xfer_req(hba, tag,
 						  ufshcd_is_scsi_cmd(cmd));
-		__set_bit(lrbp->task_tag, &hba->outstanding_reqs);
-		ufshcd_writel(hba, 1 << lrbp->task_tag,
-			      REG_UTP_TRANSFER_REQ_DOOR_BELL);
+		__set_bit(tag, &hba->outstanding_reqs);
+		ufshcd_writel(hba, 1 << tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 		spin_unlock_irqrestore(&hba->outstanding_lock, flags);
 	}
 }
@@ -2797,6 +2797,7 @@ static void ufshcd_prepare_utp_scsi_cmd_upiu(struct=
 scsi_cmnd *cmd,
 					     u8 upiu_flags)
 {
 	struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
+	const int tag =3D scsi_cmd_to_rq(cmd)->tag;
 	struct utp_upiu_req *ucd_req_ptr =3D lrbp->ucd_req_ptr;
 	unsigned short cdb_len;
=20
@@ -2804,11 +2805,11 @@ static void ufshcd_prepare_utp_scsi_cmd_upiu(stru=
ct scsi_cmnd *cmd,
 		.transaction_code =3D UPIU_TRANSACTION_COMMAND,
 		.flags =3D upiu_flags,
 		.lun =3D lrbp->lun,
-		.task_tag =3D lrbp->task_tag,
+		.task_tag =3D tag,
 		.command_set_type =3D UPIU_COMMAND_SET_TYPE_SCSI,
 	};
=20
-	WARN_ON_ONCE(ucd_req_ptr->header.task_tag !=3D lrbp->task_tag);
+	WARN_ON_ONCE(ucd_req_ptr->header.task_tag !=3D tag);
=20
 	ucd_req_ptr->sc.exp_data_transfer_len =3D cpu_to_be32(cmd->sdb.length);
=20
@@ -2829,6 +2830,7 @@ static void ufshcd_prepare_utp_query_req_upiu(struc=
t ufs_hba *hba,
 {
 	struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
 	struct utp_upiu_req *ucd_req_ptr =3D lrbp->ucd_req_ptr;
+	const int tag =3D scsi_cmd_to_rq(cmd)->tag;
 	struct ufs_query *query =3D &hba->dev_cmd.query;
 	u16 len =3D be16_to_cpu(query->request.upiu_req.length);
=20
@@ -2837,7 +2839,7 @@ static void ufshcd_prepare_utp_query_req_upiu(struc=
t ufs_hba *hba,
 		.transaction_code =3D UPIU_TRANSACTION_QUERY_REQ,
 		.flags =3D upiu_flags,
 		.lun =3D lrbp->lun,
-		.task_tag =3D lrbp->task_tag,
+		.task_tag =3D tag,
 		.query_function =3D query->request.query_func,
 		/* Data segment length only need for WRITE_DESC */
 		.data_segment_length =3D
@@ -2860,12 +2862,13 @@ static inline void ufshcd_prepare_utp_nop_upiu(st=
ruct scsi_cmnd *cmd)
 {
 	struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
 	struct utp_upiu_req *ucd_req_ptr =3D lrbp->ucd_req_ptr;
+	const int tag =3D scsi_cmd_to_rq(cmd)->tag;
=20
 	memset(ucd_req_ptr, 0, sizeof(struct utp_upiu_req));
=20
 	ucd_req_ptr->header =3D (struct utp_upiu_header){
 		.transaction_code =3D UPIU_TRANSACTION_NOP_OUT,
-		.task_tag =3D lrbp->task_tag,
+		.task_tag =3D tag,
 	};
 }
=20
@@ -2950,7 +2953,6 @@ static void __ufshcd_setup_cmd(struct ufs_hba *hba,=
 struct scsi_cmnd *cmd,
=20
 	memset(lrbp->ucd_req_ptr, 0, sizeof(*lrbp->ucd_req_ptr));
=20
-	lrbp->task_tag =3D tag;
 	lrbp->lun =3D lun;
 	ufshcd_prepare_lrbp_crypto(cmd ? scsi_cmd_to_rq(cmd) : NULL, lrbp);
 }
@@ -3247,6 +3249,8 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba, stru=
ct ufshcd_lrb *lrbp)
 static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 		struct ufshcd_lrb *lrbp, int max_timeout)
 {
+	struct scsi_cmnd *cmd =3D (struct scsi_cmnd *)lrbp - 1;
+	const int tag =3D scsi_cmd_to_rq(cmd)->tag;
 	unsigned long time_left =3D msecs_to_jiffies(max_timeout);
 	unsigned long flags;
 	bool pending;
@@ -3263,18 +3267,18 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba=
 *hba,
 	} else {
 		err =3D -ETIMEDOUT;
 		dev_dbg(hba->dev, "%s: dev_cmd request timedout, tag %d\n",
-			__func__, lrbp->task_tag);
+			__func__, tag);
=20
 		/* MCQ mode */
 		if (hba->mcq_enabled) {
 			/* successfully cleared the command, retry if needed */
-			if (ufshcd_clear_cmd(hba, lrbp->task_tag) =3D=3D 0)
+			if (ufshcd_clear_cmd(hba, tag) =3D=3D 0)
 				err =3D -EAGAIN;
 			return err;
 		}
=20
 		/* SDB mode */
-		if (ufshcd_clear_cmd(hba, lrbp->task_tag) =3D=3D 0) {
+		if (ufshcd_clear_cmd(hba, tag) =3D=3D 0) {
 			/* successfully cleared the command, retry if needed */
 			err =3D -EAGAIN;
 			/*
@@ -3283,11 +3287,9 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba =
*hba,
 			 * variable.
 			 */
 			spin_lock_irqsave(&hba->outstanding_lock, flags);
-			pending =3D test_bit(lrbp->task_tag,
-					   &hba->outstanding_reqs);
+			pending =3D test_bit(tag, &hba->outstanding_reqs);
 			if (pending)
-				__clear_bit(lrbp->task_tag,
-					    &hba->outstanding_reqs);
+				__clear_bit(tag, &hba->outstanding_reqs);
 			spin_unlock_irqrestore(&hba->outstanding_lock, flags);
=20
 			if (!pending) {
@@ -3300,11 +3302,10 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba=
 *hba,
 			}
 		} else {
 			dev_err(hba->dev, "%s: failed to clear tag %d\n",
-				__func__, lrbp->task_tag);
+				__func__, tag);
=20
 			spin_lock_irqsave(&hba->outstanding_lock, flags);
-			pending =3D test_bit(lrbp->task_tag,
-					   &hba->outstanding_reqs);
+			pending =3D test_bit(tag, &hba->outstanding_reqs);
 			spin_unlock_irqrestore(&hba->outstanding_lock, flags);
=20
 			if (!pending) {
@@ -5466,6 +5467,7 @@ static inline int ufshcd_transfer_rsp_status(struct=
 ufs_hba *hba,
 					     struct cq_entry *cqe)
 {
 	struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
+	const int tag =3D scsi_cmd_to_rq(cmd)->tag;
 	int result =3D 0;
 	int scsi_status;
 	enum utp_ocs ocs;
@@ -5537,10 +5539,8 @@ static inline int ufshcd_transfer_rsp_status(struc=
t ufs_hba *hba,
 	case OCS_ABORTED:
 	case OCS_INVALID_COMMAND_STATUS:
 		result |=3D DID_REQUEUE << 16;
-		dev_warn(hba->dev,
-				"OCS %s from controller for tag %d\n",
-				(ocs =3D=3D OCS_ABORTED ? "aborted" : "invalid"),
-				lrbp->task_tag);
+		dev_warn(hba->dev, "OCS %s from controller for tag %d\n",
+			 ocs =3D=3D OCS_ABORTED ? "aborted" : "invalid", tag);
 		break;
 	case OCS_INVALID_CMD_TABLE_ATTR:
 	case OCS_INVALID_PRDT_ATTR:
@@ -5553,9 +5553,8 @@ static inline int ufshcd_transfer_rsp_status(struct=
 ufs_hba *hba,
 	case OCS_GENERAL_CRYPTO_ERROR:
 	default:
 		result |=3D DID_ERROR << 16;
-		dev_err(hba->dev,
-				"OCS error from controller =3D %x for tag %d\n",
-				ocs, lrbp->task_tag);
+		dev_err(hba->dev, "OCS error from controller =3D %x for tag %d\n",
+			ocs, tag);
 		ufshcd_print_evt_hist(hba);
 		ufshcd_print_host_state(hba);
 		break;
@@ -7688,8 +7687,8 @@ int ufshcd_try_to_abort_task(struct ufs_hba *hba, i=
nt tag)
 	u8 resp =3D 0xF;
=20
 	for (poll_cnt =3D 100; poll_cnt; poll_cnt--) {
-		err =3D ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp->task_tag,
-				UFS_QUERY_TASK, &resp);
+		err =3D ufshcd_issue_tm_cmd(hba, lrbp->lun, tag, UFS_QUERY_TASK,
+					  &resp);
 		if (!err && resp =3D=3D UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED) {
 			/* cmd pending in the device */
 			dev_err(hba->dev, "%s: cmd pending in the device. tag =3D %d\n",
@@ -7722,8 +7721,7 @@ int ufshcd_try_to_abort_task(struct ufs_hba *hba, i=
nt tag)
 	if (!poll_cnt)
 		return -EBUSY;
=20
-	err =3D ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp->task_tag,
-			UFS_ABORT_TASK, &resp);
+	err =3D ufshcd_issue_tm_cmd(hba, lrbp->lun, tag, UFS_ABORT_TASK, &resp)=
;
 	if (err || resp !=3D UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
 		if (!err) {
 			err =3D resp; /* service response error */
@@ -7833,7 +7831,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		goto release;
 	}
=20
-	err =3D ufshcd_try_to_abort_task(hba, lrbp->task_tag);
+	err =3D ufshcd_try_to_abort_task(hba, tag);
 	if (err) {
 		dev_err(hba->dev, "%s: failed with err %d\n", __func__, err);
 		ufshcd_set_req_abort_skip(hba, hba->outstanding_reqs);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 39f426aa1df9..54e0653c53f5 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -188,7 +188,6 @@ struct ufshcd_lrb {
 	int scsi_status;
=20
 	int command_type;
-	int task_tag;
 	u8 lun; /* UPIU LUN id field is only 8-bit wide */
 	bool intr_cmd;
 	bool req_abort_skip;
