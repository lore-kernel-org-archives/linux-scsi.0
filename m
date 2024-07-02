Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533C31CF8F
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 20:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719952910; cv=none; b=TkU+GzVxfiYWRhQzOaiNAodvNiUUDNDuE9pjSJ43PDngvs7nkzVPoQ4FFfuGz+Hqjuh4BUJcIYdZLIBeubU9frxsJ1At1d9k7mstgky+WiUFyfgW59emGonp1xWdpeGVrQFHf+o5NfJEOe/w5Wn4HzzVIUDhHeua4frJnBI/4u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719952910; c=relaxed/simple;
	bh=zlCjUk2FCBdfEh/htgA+ESN6In75xeDPxZzjvPj2/wE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=af6kgZ7RlGsfR9z284Nq7mkgJS3vd/hOP8uQgQPxwoDKtann+WmYhubcSFNPokHjSfA3y89x7TjEzAcHgL8LnAbn/ET4BB8oQzRxbqN+cB5mPmx5eVQg3KImYTdjtBpjPRcDIb171OopoAhorlCQK3/rlbb9FJLtkJER9cp6l2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=c1/snu1H; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="c1/snu1H"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WDFFT08n3z6Cnk90;
	Tue,  2 Jul 2024 20:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1719952899; x=1722544900; bh=BIjbC
	YsQwe4vVykFmL0dUV6c/uCuoKxE++Ds972Uv6s=; b=c1/snu1HUXGEeaXhsAJGj
	oAxvApcLvSXpoqxTPK7rPeoFFwjehSPfHfH1jsMPePoZlo8Hwvzhxs+tMOq3A89R
	WBvON4bMaLyopHhCUt6oWGoex6Co1bDUXbi/i/9Qmi3shMfXLM7i7j5l1ugHD91H
	eXFUR8W0PP0a0gmQPlQxz4NplQ/+LmUMrMyAFWlVaB+hj45+5BwmJXUpcYg/D+Wg
	tzQ4yrWGpwKWrwfqs9KRoKu+4huwuwK29YjZcLLCCFpFBThVFCKkmJRXYqKTNU7V
	ukQSl74Skn2enFSQKhpbuS0iDjWGVoZS0XxohE4bIo3XRsn6r4oADyqVnqYfglOI
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id DMfsYboba1qR; Tue,  2 Jul 2024 20:41:39 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WDFFF6q8Nz6Cnk9V;
	Tue,  2 Jul 2024 20:41:37 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Avri Altman <avri.altman@wdc.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>,
	Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v4 6/9] scsi: ufs: Inline is_mcq_enabled()
Date: Tue,  2 Jul 2024 13:39:14 -0700
Message-ID: <20240702204020.2489324-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
In-Reply-To: <20240702204020.2489324-1-bvanassche@acm.org>
References: <20240702204020.2489324-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Improve code readability by inlining is_mcq_enabled().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 28 ++++++++++++++--------------
 include/ufs/ufshcd.h      |  5 -----
 2 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 178b0abaeb30..4c138f42a802 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -453,7 +453,7 @@ static void ufshcd_add_command_trace(struct ufs_hba *=
hba, unsigned int tag,
=20
 	intr =3D ufshcd_readl(hba, REG_INTERRUPT_STATUS);
=20
-	if (is_mcq_enabled(hba)) {
+	if (hba->mcq_enabled) {
 		struct ufs_hw_queue *hwq =3D ufshcd_mcq_req_to_hwq(hba, rq);
=20
 		hwq_id =3D hwq->id;
@@ -2301,7 +2301,7 @@ void ufshcd_send_command(struct ufs_hba *hba, unsig=
ned int task_tag,
 	if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
 		ufshcd_start_monitor(hba, lrbp);
=20
-	if (is_mcq_enabled(hba)) {
+	if (hba->mcq_enabled) {
 		int utrd_size =3D sizeof(struct utp_transfer_req_desc);
 		struct utp_transfer_req_desc *src =3D lrbp->utr_descriptor_ptr;
 		struct utp_transfer_req_desc *dest;
@@ -3000,7 +3000,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *ho=
st, struct scsi_cmnd *cmd)
 		goto out;
 	}
=20
-	if (is_mcq_enabled(hba))
+	if (hba->mcq_enabled)
 		hwq =3D ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
=20
 	ufshcd_send_command(hba, tag, hwq);
@@ -3059,7 +3059,7 @@ static int ufshcd_clear_cmd(struct ufs_hba *hba, u3=
2 task_tag)
 	unsigned long flags;
 	int err;
=20
-	if (is_mcq_enabled(hba)) {
+	if (hba->mcq_enabled) {
 		/*
 		 * MCQ mode. Clean up the MCQ resources similar to
 		 * what the ufshcd_utrl_clear() does for SDB mode.
@@ -3169,7 +3169,7 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *=
hba,
 			__func__, lrbp->task_tag);
=20
 		/* MCQ mode */
-		if (is_mcq_enabled(hba)) {
+		if (hba->mcq_enabled) {
 			/* successfully cleared the command, retry if needed */
 			if (ufshcd_clear_cmd(hba, lrbp->task_tag) =3D=3D 0)
 				err =3D -EAGAIN;
@@ -5560,7 +5560,7 @@ static int ufshcd_poll(struct Scsi_Host *shost, uns=
igned int queue_num)
 	u32 tr_doorbell;
 	struct ufs_hw_queue *hwq;
=20
-	if (is_mcq_enabled(hba)) {
+	if (hba->mcq_enabled) {
 		hwq =3D &hba->uhq[queue_num];
=20
 		return ufshcd_mcq_poll_cqe_lock(hba, hwq);
@@ -6201,7 +6201,7 @@ static void ufshcd_exception_event_handler(struct w=
ork_struct *work)
 /* Complete requests that have door-bell cleared */
 static void ufshcd_complete_requests(struct ufs_hba *hba, bool force_com=
pl)
 {
-	if (is_mcq_enabled(hba))
+	if (hba->mcq_enabled)
 		ufshcd_mcq_compl_pending_transfer(hba, force_compl);
 	else
 		ufshcd_transfer_req_compl(hba);
@@ -6458,7 +6458,7 @@ static bool ufshcd_abort_one(struct request *rq, vo=
id *priv)
 		*ret ? "failed" : "succeeded");
=20
 	/* Release cmd in MCQ mode if abort succeeds */
-	if (is_mcq_enabled(hba) && (*ret =3D=3D 0)) {
+	if (hba->mcq_enabled && (*ret =3D=3D 0)) {
 		hwq =3D ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(lrbp->cmd));
 		spin_lock_irqsave(&hwq->cq_lock, flags);
 		if (ufshcd_cmd_inflight(lrbp->cmd))
@@ -7389,7 +7389,7 @@ static int ufshcd_eh_device_reset_handler(struct sc=
si_cmnd *cmd)
 		goto out;
 	}
=20
-	if (is_mcq_enabled(hba)) {
+	if (hba->mcq_enabled) {
 		for (pos =3D 0; pos < hba->nutrs; pos++) {
 			lrbp =3D &hba->lrb[pos];
 			if (ufshcd_cmd_inflight(lrbp->cmd) &&
@@ -7485,7 +7485,7 @@ int ufshcd_try_to_abort_task(struct ufs_hba *hba, i=
nt tag)
 			 */
 			dev_err(hba->dev, "%s: cmd at tag %d not pending in the device.\n",
 				__func__, tag);
-			if (is_mcq_enabled(hba)) {
+			if (hba->mcq_enabled) {
 				/* MCQ mode */
 				if (ufshcd_cmd_inflight(lrbp->cmd)) {
 					/* sleep for max. 200us same delay as in SDB mode */
@@ -7563,7 +7563,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
=20
 	ufshcd_hold(hba);
=20
-	if (!is_mcq_enabled(hba)) {
+	if (!hba->mcq_enabled) {
 		reg =3D ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 		if (!test_bit(tag, &hba->outstanding_reqs)) {
 			/* If command is already aborted/completed, return FAILED. */
@@ -7596,7 +7596,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	}
 	hba->req_abort_count++;
=20
-	if (!is_mcq_enabled(hba) && !(reg & (1 << tag))) {
+	if (!hba->mcq_enabled && !(reg & (1 << tag))) {
 		/* only execute this code in single doorbell mode */
 		dev_err(hba->dev,
 		"%s: cmd was completed, but without a notifying intr, tag =3D %d",
@@ -7623,7 +7623,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		goto release;
 	}
=20
-	if (is_mcq_enabled(hba)) {
+	if (hba->mcq_enabled) {
 		/* MCQ mode. Branch off to handle abort for mcq mode */
 		err =3D ufshcd_mcq_abort(cmd);
 		goto release;
@@ -8732,7 +8732,7 @@ static int ufshcd_device_init(struct ufs_hba *hba, =
bool init_dev_params)
 	ufshcd_set_link_active(hba);
=20
 	/* Reconfigure MCQ upon reset */
-	if (is_mcq_enabled(hba) && !init_dev_params)
+	if (hba->mcq_enabled && !init_dev_params)
 		ufshcd_config_mcq(hba);
=20
 	/* Verify device initialization by sending NOP OUT UPIU */
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index d4d63507d090..c0e28a512b3c 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1132,11 +1132,6 @@ struct ufs_hw_queue {
=20
 #define MCQ_QCFG_SIZE		0x40
=20
-static inline bool is_mcq_enabled(struct ufs_hba *hba)
-{
-	return hba->mcq_enabled;
-}
-
 static inline unsigned int ufshcd_mcq_opr_offset(struct ufs_hba *hba,
 		enum ufshcd_mcq_opr opr, int idx)
 {
