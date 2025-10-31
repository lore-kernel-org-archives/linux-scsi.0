Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADCCCA6F
	for <linux-scsi@vger.kernel.org>; Fri, 31 Oct 2025 20:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761943474; cv=none; b=UtN8DgF8G7F0AJSsk2mDwlmZNPcHRthEMGAgKR+kmaUHd+1FfJiFQoaJDcNnAo545s5Dn83I6R3v2LYF9t1bVGvkvL9PaZz64jNan64p3yEUxPt98tDJSp45lqa70yOjVt4LRhXJJxVYPoNNwu0LRw4xnckSsgj1OCd6dwRwMkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761943474; c=relaxed/simple;
	bh=LWJbsvliFcIE6sYzSzBWRCadfaoyUdU76Nm2zMQuAC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V60KouOGS7IHRT4NyaeKAvR4RXJbHr5cVBoLUCwrViP9z56MhR2y6gUO2m0dVJMuv3dn1tFSjisEErc/aRljyj5OuNpTXyCYAt+QjQrMJs4098kNuc0mehnB/4uHrnxsAmaPyBdVp8xdo+OJR+ZTEdK0ong13GKUKcq7GQz6AMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Ae0++QCw; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Ae0++QCw"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cytJH6VkGzm0jvG;
	Fri, 31 Oct 2025 20:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1761943469; x=1764535470; bh=7uDgh
	DwpVk4idNwXwFvxPG1zFSEgOd/+y6ydEnZZml8=; b=Ae0++QCwKJOjwU/zBxq2b
	YqYqjceyX/vHcVk81nroIlrv9jDEzOPn8S6i33eMr1WRN2bkLHPbStTRlfDPv7DY
	ApnLgslzFQuY8kFWQj08kTLbLEwJau5amuVbz+FijLsRSdQvONyscrB9iUDz2XyQ
	PnRgzvd/dW6G5uHD4pPtLUUGEN6+UFdQtwEONS8spDFvl5ug+/+C/78a19rYP2OC
	wBkiYY0cIKyX+3aNuUqkpl4s1pIpkVda6YbAK0ZNPbYv6XLEPyRns1T1qSW3u9bM
	I0djiePsVHcYWYRIco6wNgFlqVGlKWM7xLNmRqTAqHe2OYw86zo/mwYRvNONF4ax
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id BRClhiNpeknw; Fri, 31 Oct 2025 20:44:29 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cytJ33nKgzm0pKy;
	Fri, 31 Oct 2025 20:44:18 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Can Guo <quic_cang@quicinc.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Nitin Rawat <quic_nitirawa@quicinc.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH v8 25/28] ufs: core: Remove the ufshcd_lrb task_tag member
Date: Fri, 31 Oct 2025 13:39:33 -0700
Message-ID: <20251031204029.2883185-26-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
In-Reply-To: <20251031204029.2883185-1-bvanassche@acm.org>
References: <20251031204029.2883185-1-bvanassche@acm.org>
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
index cf2c08baa9ae..3e0fa433579d 100644
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
@@ -2369,6 +2369,7 @@ static inline void ufshcd_send_command(struct ufs_h=
ba *hba,
 				       struct ufs_hw_queue *hwq)
 {
 	struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
+	const int tag =3D scsi_cmd_to_rq(cmd)->tag;
 	unsigned long flags;
=20
 	if (hba->monitor.enabled) {
@@ -2397,11 +2398,10 @@ static inline void ufshcd_send_command(struct ufs=
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
@@ -2798,6 +2798,7 @@ static void ufshcd_prepare_utp_scsi_cmd_upiu(struct=
 scsi_cmnd *cmd,
 					     u8 upiu_flags)
 {
 	struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
+	const int tag =3D scsi_cmd_to_rq(cmd)->tag;
 	struct utp_upiu_req *ucd_req_ptr =3D lrbp->ucd_req_ptr;
 	unsigned short cdb_len;
=20
@@ -2805,11 +2806,11 @@ static void ufshcd_prepare_utp_scsi_cmd_upiu(stru=
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
@@ -2830,6 +2831,7 @@ static void ufshcd_prepare_utp_query_req_upiu(struc=
t ufs_hba *hba,
 {
 	struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
 	struct utp_upiu_req *ucd_req_ptr =3D lrbp->ucd_req_ptr;
+	const int tag =3D scsi_cmd_to_rq(cmd)->tag;
 	struct ufs_query *query =3D &hba->dev_cmd.query;
 	u16 len =3D be16_to_cpu(query->request.upiu_req.length);
=20
@@ -2838,7 +2840,7 @@ static void ufshcd_prepare_utp_query_req_upiu(struc=
t ufs_hba *hba,
 		.transaction_code =3D UPIU_TRANSACTION_QUERY_REQ,
 		.flags =3D upiu_flags,
 		.lun =3D lrbp->lun,
-		.task_tag =3D lrbp->task_tag,
+		.task_tag =3D tag,
 		.query_function =3D query->request.query_func,
 		/* Data segment length only need for WRITE_DESC */
 		.data_segment_length =3D
@@ -2861,12 +2863,13 @@ static inline void ufshcd_prepare_utp_nop_upiu(st=
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
@@ -2951,7 +2954,6 @@ static void __ufshcd_setup_cmd(struct ufs_hba *hba,=
 struct scsi_cmnd *cmd,
=20
 	memset(lrbp->ucd_req_ptr, 0, sizeof(*lrbp->ucd_req_ptr));
=20
-	lrbp->task_tag =3D tag;
 	lrbp->lun =3D lun;
 	ufshcd_prepare_lrbp_crypto(ufshcd_is_scsi_cmd(cmd) ?
 				   scsi_cmd_to_rq(cmd) : NULL, lrbp);
@@ -3249,6 +3251,8 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba, stru=
ct ufshcd_lrb *lrbp)
 static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 		struct ufshcd_lrb *lrbp, int max_timeout)
 {
+	struct scsi_cmnd *cmd =3D (struct scsi_cmnd *)lrbp - 1;
+	const int tag =3D scsi_cmd_to_rq(cmd)->tag;
 	unsigned long time_left =3D msecs_to_jiffies(max_timeout);
 	unsigned long flags;
 	bool pending;
@@ -3265,18 +3269,18 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba=
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
@@ -3285,11 +3289,9 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba =
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
@@ -3302,11 +3304,10 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba=
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
@@ -5468,6 +5469,7 @@ static inline int ufshcd_transfer_rsp_status(struct=
 ufs_hba *hba,
 					     struct cq_entry *cqe)
 {
 	struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
+	const int tag =3D scsi_cmd_to_rq(cmd)->tag;
 	int result =3D 0;
 	int scsi_status;
 	enum utp_ocs ocs;
@@ -5539,10 +5541,8 @@ static inline int ufshcd_transfer_rsp_status(struc=
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
@@ -5555,9 +5555,8 @@ static inline int ufshcd_transfer_rsp_status(struct=
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
@@ -7692,8 +7691,8 @@ int ufshcd_try_to_abort_task(struct ufs_hba *hba, i=
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
@@ -7726,8 +7725,7 @@ int ufshcd_try_to_abort_task(struct ufs_hba *hba, i=
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
@@ -7837,7 +7835,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		goto release;
 	}
=20
-	err =3D ufshcd_try_to_abort_task(hba, lrbp->task_tag);
+	err =3D ufshcd_try_to_abort_task(hba, tag);
 	if (err) {
 		dev_err(hba->dev, "%s: failed with err %d\n", __func__, err);
 		ufshcd_set_req_abort_skip(hba, hba->outstanding_reqs);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index fbed47b6c61f..a92062f65455 100644
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
