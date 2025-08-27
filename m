Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12BF801
	for <linux-scsi@vger.kernel.org>; Wed, 27 Aug 2025 00:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756253428; cv=none; b=uN5+zSvuPc0C2g2/jUH5SyddCafoTTrm5I7fxepEG/QL4sogeEOBLZbyNvr+3zcmRZeBo50Kfnpvv1eTjWIRjFEwrbW2Z5giXOsI4gOAWLi9RcozWbhavkDej0pKV5NvkvQOFd8u9RMZhJ64XnSZefx/TDuNCdOVeDlHztlgQUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756253428; c=relaxed/simple;
	bh=Ju0nZTvtwf742+vGNXsBoDWg9MfK53mWbc/JFzEI5YE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nB/xHmMmK3RG7j+ZDbCGKuOeLY+DZPskv7nEL6KuaFUQGAjlR+g3UYzxt5xLuagZA/kdlt+Hz5vycu3ARKnXDifsk4akFOQhunFzDitMOcw8yIDw+sjeHqekRKGo5g5viCmNuAyuinNn/VJxdzyDN+D5Mz0TcFC9WrLL6b1+ZBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Gok15f1G; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Gok15f1G"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cBQ0K6w6Zzm1742;
	Wed, 27 Aug 2025 00:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1756253424; x=1758845425; bh=yYugG
	Nz2Z2iTCeF174JAPmzZgxCZX4EwTMroLHt4Y5o=; b=Gok15f1G3lerIdUgfhthN
	Qq88aA1WTygcS1AZa+jBT3H8K/LnjSO7ZnFrRiitze1A9YyjzoYELTgOQ1pjM09H
	yXovoTh8TU4tlmv3qhGa89YX4ZnRvX081hBc1V73bFOG2IcIq3Uo29iPtkq55qcm
	iHgEKYKPy1tDOqrBsQd2K2v5d1klEO/E8pVY1ezI0vnKpjEQzJC0PnBxPZZkOR+f
	p/uplyWS7Gxf7PInGfs8xRI4XohOe6o0BikEsTzmwSGHKkOs1Z9rETjef9mo9tyt
	JhL/Y006yoxzeDDhginKlitXNqswLFxe4XjArmVYtmeWQptimyCghfClG5m/m6BC
	g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id wPeQbptI6Yjj; Wed, 27 Aug 2025 00:10:24 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cBQ0D1d20zm0ySM;
	Wed, 27 Aug 2025 00:10:19 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v3 13/26] ufs: core: Change the monitor function argument types
Date: Tue, 26 Aug 2025 17:06:17 -0700
Message-ID: <20250827000816.2370150-14-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
In-Reply-To: <20250827000816.2370150-1-bvanassche@acm.org>
References: <20250827000816.2370150-1-bvanassche@acm.org>
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

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 44 +++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 586e707bd35e..4d6a3e97f8d9 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2291,19 +2291,20 @@ static inline int ufshcd_monitor_opcode2dir(u8 op=
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
@@ -2312,14 +2313,15 @@ static void ufshcd_start_monitor(struct ufs_hba *=
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
@@ -2354,6 +2356,7 @@ static inline void ufshcd_send_command(struct ufs_h=
ba *hba,
 				       struct ufshcd_lrb *lrbp,
 				       struct ufs_hw_queue *hwq)
 {
+	struct scsi_cmnd *cmd =3D lrbp->cmd;
 	unsigned long flags;
=20
 	if (hba->monitor.enabled) {
@@ -2362,11 +2365,11 @@ static inline void ufshcd_send_command(struct ufs=
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
@@ -2382,8 +2385,7 @@ static inline void ufshcd_send_command(struct ufs_h=
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
@@ -5617,19 +5619,17 @@ void ufshcd_release_scsi_cmd(struct ufs_hba *hba,
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
