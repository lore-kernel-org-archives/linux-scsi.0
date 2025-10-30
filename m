Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258C62FCC1D
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2025 19:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761853172; cv=none; b=LDEYsQSOLpb35ErqD6pPSzsNHJP0qgFQOVzFnJWGESdNd5vuwkHFI8x5d4f7tI4jRmXd8lZPRRNnfcHb+TDuDR1erCEAW019D6LCsubIEB5QNJUCLIhHeL9mpSi/lCdAbitaGhxhy36FLDzqCvFfugDOMUr9DwFXoKNiNcIoNfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761853172; c=relaxed/simple;
	bh=S5wvUyiEtPspEeNlhWeb/3oWG7h0wLNHNK8AVNZew2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j7TsP/liPze3bjy0a/awlYnit2qTRoVYTGfZyP9IQO1cFd9jIO3ioaLxiOJCT+kKLbrvi+Y5KZxd7QmHQZA3n8l36uARWwL+g3PztoZWbz5eSgf8SznNdkfjtOXOt22/0+f2FiX/2JuFVDrDaLKWXZ2ALSahaZQ6mqDR4/Ihp0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=5I0UHGh2; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="5I0UHGh2"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cyDvk38nnzlpTG1;
	Thu, 30 Oct 2025 19:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1761853168; x=1764445169; bh=6BkR2
	Gzm2/SwFntMz7Gls83IP07wZgYLhWTfZXnYW1s=; b=5I0UHGh2DrMa/7imfWkAW
	IK/8lrNttIQ1zl0ErpYe5UihiHXztOXG/ezPVmYsKbSSVG6LHXs80yWwljVRKmR8
	hd3CPPcnVtkVKrCMkUIgMm5CKEXQISvtYYRTBFBKS18vMXF1urgYiQTcLm0U/vfq
	7Wcu2erTDSESeqPSdPxhh3J/5PVXYAjPZAFmKdP8Smvwsb5NrcI0k10UisgqyUcS
	P9vKL/Zj3BIjgNzUh4BKfeqB0Of/buCGrwoKg/a+1Uvp4WbdH+neLIQPwRhSkCQR
	euEPqNLm/pmdJyjhLWCcIl3hxd+ajbTCieTiutdHBfxx4cxwCkSVt9CYxbIVtVbe
	Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id dXWjeQ-1gYYP; Thu, 30 Oct 2025 19:39:28 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cyDvY5V0Hzlvbn2;
	Thu, 30 Oct 2025 19:39:20 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v7 14/28] ufs: core: Change the monitor function argument types
Date: Thu, 30 Oct 2025 12:36:13 -0700
Message-ID: <20251030193720.871635-15-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
In-Reply-To: <20251030193720.871635-1-bvanassche@acm.org>
References: <20251030193720.871635-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Pass a SCSI command pointer instead of a struct ufshcd_lrb pointer. This
patch prepares for combining the SCSI command and ufshcd_lrb data
structures into a single data structure.

Reviewed-by: Avri Altman <avri.altman@sandisk.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 44 +++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index dbdb8c30ca09..df3f651c8d91 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2295,19 +2295,20 @@ static inline int ufshcd_monitor_opcode2dir(u8 op=
code)
=20
 /* Must only be called for SCSI commands. */
 static inline bool ufshcd_should_inform_monitor(struct ufs_hba *hba,
-						struct ufshcd_lrb *lrbp)
+						struct scsi_cmnd *cmd)
 {
 	const struct ufs_hba_monitor *m =3D &hba->monitor;
+	struct request *rq =3D scsi_cmd_to_rq(cmd);
+	struct ufshcd_lrb *lrbp =3D &hba->lrb[rq->tag];
=20
-	return (m->enabled &&
-		(!m->chunk_size || m->chunk_size =3D=3D lrbp->cmd->sdb.length) &&
-		ktime_before(hba->monitor.enabled_ts, lrbp->issue_time_stamp));
+	return m->enabled &&
+	       (!m->chunk_size || m->chunk_size =3D=3D cmd->sdb.length) &&
+	       ktime_before(hba->monitor.enabled_ts, lrbp->issue_time_stamp);
 }
=20
-static void ufshcd_start_monitor(struct ufs_hba *hba,
-				 const struct ufshcd_lrb *lrbp)
+static void ufshcd_start_monitor(struct ufs_hba *hba, struct scsi_cmnd *=
cmd)
 {
-	int dir =3D ufshcd_monitor_opcode2dir(*lrbp->cmd->cmnd);
+	int dir =3D ufshcd_monitor_opcode2dir(cmd->cmnd[0]);
 	unsigned long flags;
=20
 	spin_lock_irqsave(hba->host->host_lock, flags);
@@ -2316,14 +2317,15 @@ static void ufshcd_start_monitor(struct ufs_hba *=
hba,
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 }
=20
-static void ufshcd_update_monitor(struct ufs_hba *hba, const struct ufsh=
cd_lrb *lrbp)
+static void ufshcd_update_monitor(struct ufs_hba *hba, struct scsi_cmnd =
*cmd)
 {
-	int dir =3D ufshcd_monitor_opcode2dir(*lrbp->cmd->cmnd);
+	struct request *req =3D scsi_cmd_to_rq(cmd);
+	struct ufshcd_lrb *lrbp =3D &hba->lrb[req->tag];
+	int dir =3D ufshcd_monitor_opcode2dir(cmd->cmnd[0]);
 	unsigned long flags;
=20
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (dir >=3D 0 && hba->monitor.nr_queued[dir] > 0) {
-		const struct request *req =3D scsi_cmd_to_rq(lrbp->cmd);
 		struct ufs_hba_monitor *m =3D &hba->monitor;
 		ktime_t now, inc, lat;
=20
@@ -2358,6 +2360,7 @@ static inline void ufshcd_send_command(struct ufs_h=
ba *hba,
 				       struct ufshcd_lrb *lrbp,
 				       struct ufs_hw_queue *hwq)
 {
+	struct scsi_cmnd *cmd =3D lrbp->cmd;
 	unsigned long flags;
=20
 	if (hba->monitor.enabled) {
@@ -2366,11 +2369,11 @@ static inline void ufshcd_send_command(struct ufs=
_hba *hba,
 		lrbp->compl_time_stamp =3D ktime_set(0, 0);
 		lrbp->compl_time_stamp_local_clock =3D 0;
 	}
-	if (lrbp->cmd) {
-		ufshcd_add_command_trace(hba, lrbp->cmd, UFS_CMD_SEND);
+	if (cmd) {
+		ufshcd_add_command_trace(hba, cmd, UFS_CMD_SEND);
 		ufshcd_clk_scaling_start_busy(hba);
-		if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
-			ufshcd_start_monitor(hba, lrbp);
+		if (unlikely(ufshcd_should_inform_monitor(hba, cmd)))
+			ufshcd_start_monitor(hba, cmd);
 	}
=20
 	if (hba->mcq_enabled) {
@@ -2386,8 +2389,7 @@ static inline void ufshcd_send_command(struct ufs_h=
ba *hba,
 	} else {
 		spin_lock_irqsave(&hba->outstanding_lock, flags);
 		if (hba->vops && hba->vops->setup_xfer_req)
-			hba->vops->setup_xfer_req(hba, lrbp->task_tag,
-						  !!lrbp->cmd);
+			hba->vops->setup_xfer_req(hba, lrbp->task_tag, !!cmd);
 		__set_bit(lrbp->task_tag, &hba->outstanding_reqs);
 		ufshcd_writel(hba, 1 << lrbp->task_tag,
 			      REG_UTP_TRANSFER_REQ_DOOR_BELL);
@@ -5628,19 +5630,17 @@ void ufshcd_release_scsi_cmd(struct ufs_hba *hba,
 void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
 			  struct cq_entry *cqe)
 {
-	struct ufshcd_lrb *lrbp;
-	struct scsi_cmnd *cmd;
+	struct ufshcd_lrb *lrbp =3D &hba->lrb[task_tag];
+	struct scsi_cmnd *cmd =3D lrbp->cmd;
 	enum utp_ocs ocs;
=20
-	lrbp =3D &hba->lrb[task_tag];
 	if (hba->monitor.enabled) {
 		lrbp->compl_time_stamp =3D ktime_get();
 		lrbp->compl_time_stamp_local_clock =3D local_clock();
 	}
-	cmd =3D lrbp->cmd;
 	if (cmd) {
-		if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
-			ufshcd_update_monitor(hba, lrbp);
+		if (unlikely(ufshcd_should_inform_monitor(hba, cmd)))
+			ufshcd_update_monitor(hba, cmd);
 		ufshcd_add_command_trace(hba, cmd, UFS_CMD_COMP);
 		cmd->result =3D ufshcd_transfer_rsp_status(hba, lrbp, cqe);
 		ufshcd_release_scsi_cmd(hba, lrbp);
