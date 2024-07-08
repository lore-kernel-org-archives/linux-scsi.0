Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC4A81211
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2024 21:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720473515; cv=none; b=jOwcHiIiCZK1opJiGry8FHXYMjTGLrN2QyN6eu5n9nRvsBrZDAECyojdcPZTDVVfGqJMdurNh8zw5cvKANNfW9kb+4twxsfLgjAcEiV3tTdKboJLYSXtnM8HehsxHYC8QVdsmOOnW7EfRHU0usQYrn3wfFmVbDEV+eyF2kZ6tAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720473515; c=relaxed/simple;
	bh=0LuI8WurHhvuYxkRi4pG8BCetfbuz27YPnjyZP14CdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UD/HtGqLgAkH9KvN3ixYO75uq+zC2dM6N7Fu8CkgLfRx7Y/lURjr9tIISzJ5JvtCFcrBm4VqsF2MGvUd96oMQK1Hd0JatKdTR6DGV5ilZYqCTyDfisGOpDYiNKgXONqBP1XH2R/+gZk3WPNo+Br/kVEUXe4xilxhnJ/r5ZSbCls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=LAxMeXcE; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="LAxMeXcE"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WHxn46TCnz6CmR43;
	Mon,  8 Jul 2024 21:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1720473500; x=1723065501; bh=RIkkv
	v10Amm/+cM8OJCBkci6GHjFHsVwAn+832ErxtY=; b=LAxMeXcEC08jJdw+ZUJDb
	Op1HM+pNXUtAJWj6zQpmsD/UPzMOi7GzCvfEJZBvvdOp7pNtBy289bOLl3AubQfm
	ZWjPst8oQjIkamp2Z37tESBmPwaE1IpUdslHYuL2dDdycWy33De5savVXptfXdap
	wbsSrnt9cFXJnclMMBCQ2HODjKt6vuDwvi8a9uYQfy5GWkdGbvMCvdse+uV52IZa
	YG6SZNaW7XCg6Ck38/HhLTi2fT7+PrOhjDm8UeAewKJiI+i/Bl4oUysso4lRHvE+
	geuLUzIj9gXBh0Ps6mWdb/Q53mQtTDOlIxvZeeBB+DzFmYvBaQYhWsi7LBktk8rK
	g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8hbpVd64T0HG; Mon,  8 Jul 2024 21:18:20 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WHxmn2Hb0z6Cnk9N;
	Mon,  8 Jul 2024 21:18:17 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	peter.wang@mediatek.com,
	manivannan.sadhasivam@linaro.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bean Huo <beanhuo@micron.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>,
	Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v5 06/10] scsi: ufs: Inline is_mcq_enabled()
Date: Mon,  8 Jul 2024 14:16:01 -0700
Message-ID: <20240708211716.2827751-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
In-Reply-To: <20240708211716.2827751-1-bvanassche@acm.org>
References: <20240708211716.2827751-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Improve code readability by inlining is_mcq_enabled().

Cc: Peter Wang <peter.wang@mediatek.com>
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c       | 28 ++++++++++++++--------------
 drivers/ufs/host/ufs-mediatek.c |  6 +++---
 include/ufs/ufshcd.h            |  5 -----
 3 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 3d452aa923dc..255d55e15b73 100644
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
@@ -2302,7 +2302,7 @@ void ufshcd_send_command(struct ufs_hba *hba, unsig=
ned int task_tag,
 	if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
 		ufshcd_start_monitor(hba, lrbp);
=20
-	if (is_mcq_enabled(hba)) {
+	if (hba->mcq_enabled) {
 		int utrd_size =3D sizeof(struct utp_transfer_req_desc);
 		struct utp_transfer_req_desc *src =3D lrbp->utr_descriptor_ptr;
 		struct utp_transfer_req_desc *dest;
@@ -3001,7 +3001,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *ho=
st, struct scsi_cmnd *cmd)
 		goto out;
 	}
=20
-	if (is_mcq_enabled(hba))
+	if (hba->mcq_enabled)
 		hwq =3D ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
=20
 	ufshcd_send_command(hba, tag, hwq);
@@ -3060,7 +3060,7 @@ static int ufshcd_clear_cmd(struct ufs_hba *hba, u3=
2 task_tag)
 	unsigned long flags;
 	int err;
=20
-	if (is_mcq_enabled(hba)) {
+	if (hba->mcq_enabled) {
 		/*
 		 * MCQ mode. Clean up the MCQ resources similar to
 		 * what the ufshcd_utrl_clear() does for SDB mode.
@@ -3170,7 +3170,7 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *=
hba,
 			__func__, lrbp->task_tag);
=20
 		/* MCQ mode */
-		if (is_mcq_enabled(hba)) {
+		if (hba->mcq_enabled) {
 			/* successfully cleared the command, retry if needed */
 			if (ufshcd_clear_cmd(hba, lrbp->task_tag) =3D=3D 0)
 				err =3D -EAGAIN;
@@ -5561,7 +5561,7 @@ static int ufshcd_poll(struct Scsi_Host *shost, uns=
igned int queue_num)
 	u32 tr_doorbell;
 	struct ufs_hw_queue *hwq;
=20
-	if (is_mcq_enabled(hba)) {
+	if (hba->mcq_enabled) {
 		hwq =3D &hba->uhq[queue_num];
=20
 		return ufshcd_mcq_poll_cqe_lock(hba, hwq);
@@ -6202,7 +6202,7 @@ static void ufshcd_exception_event_handler(struct w=
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
@@ -6459,7 +6459,7 @@ static bool ufshcd_abort_one(struct request *rq, vo=
id *priv)
 		*ret ? "failed" : "succeeded");
=20
 	/* Release cmd in MCQ mode if abort succeeds */
-	if (is_mcq_enabled(hba) && (*ret =3D=3D 0)) {
+	if (hba->mcq_enabled && (*ret =3D=3D 0)) {
 		hwq =3D ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(lrbp->cmd));
 		spin_lock_irqsave(&hwq->cq_lock, flags);
 		if (ufshcd_cmd_inflight(lrbp->cmd))
@@ -7390,7 +7390,7 @@ static int ufshcd_eh_device_reset_handler(struct sc=
si_cmnd *cmd)
 		goto out;
 	}
=20
-	if (is_mcq_enabled(hba)) {
+	if (hba->mcq_enabled) {
 		for (pos =3D 0; pos < hba->nutrs; pos++) {
 			lrbp =3D &hba->lrb[pos];
 			if (ufshcd_cmd_inflight(lrbp->cmd) &&
@@ -7486,7 +7486,7 @@ int ufshcd_try_to_abort_task(struct ufs_hba *hba, i=
nt tag)
 			 */
 			dev_err(hba->dev, "%s: cmd at tag %d not pending in the device.\n",
 				__func__, tag);
-			if (is_mcq_enabled(hba)) {
+			if (hba->mcq_enabled) {
 				/* MCQ mode */
 				if (ufshcd_cmd_inflight(lrbp->cmd)) {
 					/* sleep for max. 200us same delay as in SDB mode */
@@ -7564,7 +7564,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
=20
 	ufshcd_hold(hba);
=20
-	if (!is_mcq_enabled(hba)) {
+	if (!hba->mcq_enabled) {
 		reg =3D ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 		if (!test_bit(tag, &hba->outstanding_reqs)) {
 			/* If command is already aborted/completed, return FAILED. */
@@ -7597,7 +7597,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	}
 	hba->req_abort_count++;
=20
-	if (!is_mcq_enabled(hba) && !(reg & (1 << tag))) {
+	if (!hba->mcq_enabled && !(reg & (1 << tag))) {
 		/* only execute this code in single doorbell mode */
 		dev_err(hba->dev,
 		"%s: cmd was completed, but without a notifying intr, tag =3D %d",
@@ -7624,7 +7624,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		goto release;
 	}
=20
-	if (is_mcq_enabled(hba)) {
+	if (hba->mcq_enabled) {
 		/* MCQ mode. Branch off to handle abort for mcq mode */
 		err =3D ufshcd_mcq_abort(cmd);
 		goto release;
@@ -8733,7 +8733,7 @@ static int ufshcd_device_init(struct ufs_hba *hba, =
bool init_dev_params)
 	ufshcd_set_link_active(hba);
=20
 	/* Reconfigure MCQ upon reset */
-	if (is_mcq_enabled(hba) && !init_dev_params)
+	if (hba->mcq_enabled && !init_dev_params)
 		ufshcd_config_mcq(hba);
=20
 	/* Verify device initialization by sending NOP OUT UPIU */
diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
index c7a0ab9b1f59..02c9064284e1 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -693,7 +693,7 @@ static void ufs_mtk_mcq_disable_irq(struct ufs_hba *h=
ba)
 	struct ufs_mtk_host *host =3D ufshcd_get_variant(hba);
 	u32 irq, i;
=20
-	if (!is_mcq_enabled(hba))
+	if (!hba->mcq_enabled)
 		return;
=20
 	if (host->mcq_nr_intr =3D=3D 0)
@@ -711,7 +711,7 @@ static void ufs_mtk_mcq_enable_irq(struct ufs_hba *hb=
a)
 	struct ufs_mtk_host *host =3D ufshcd_get_variant(hba);
 	u32 irq, i;
=20
-	if (!is_mcq_enabled(hba))
+	if (!hba->mcq_enabled)
 		return;
=20
 	if (host->mcq_nr_intr =3D=3D 0)
@@ -1308,7 +1308,7 @@ static int ufs_mtk_link_set_hpm(struct ufs_hba *hba=
)
 	if (err)
 		return err;
=20
-	if (is_mcq_enabled(hba)) {
+	if (hba->mcq_enabled) {
 		ufs_mtk_config_mcq(hba, false);
 		ufshcd_mcq_make_queues_operational(hba);
 		ufshcd_mcq_config_mac(hba, hba->nutrs);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 42d1bd2120ea..3eaa8bc7eaea 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1133,11 +1133,6 @@ struct ufs_hw_queue {
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
