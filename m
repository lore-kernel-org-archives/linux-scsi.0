Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADBD2E62CF
	for <linux-scsi@vger.kernel.org>; Thu,  3 Apr 2025 21:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743715288; cv=none; b=ZOJZmWjfshpbUQ5HnBbHEZSzPS8IMJJllWlElzeiX/c5zIVVzklBIkgZzQZq0EDu5LIAu5E0sZ4z4QQjjsIBkpI+05cVfmIZq6mtz9nOW0lfJ41+P3NT5+GwW2iSYLn55D1tKPfM1nmMarnH0a0JZATopoU+ov3juDRx7pa7kr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743715288; c=relaxed/simple;
	bh=0F1cI+oK0xRSlh9jTmxllj0F13+8qqLN2UDti0POtno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JMu6kFM+o+W6sZlrDu4/MRyJD0Q9MZtN1slpCsT8/w0ZJAXymqyLZ5IlzR6DqvIKtFeyb0LB64KiiQgLCW3oJ2FB1BVBe/QT3vkmQd7F1J6SxNA7ztsTuYwXlVx0x1+UNwNaPh7j5DMKytt4gft0fkTAFobhY2XnH3hfsSUSbbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=gnVbDOJ4; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="gnVbDOJ4"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZTF6G3KHNzm0jvW;
	Thu,  3 Apr 2025 21:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1743715284; x=1746307285; bh=gYPax
	1jTTkLQoxgVC2K0kgxALrk52GjtvW9kQgwcpzc=; b=gnVbDOJ4WMQR5zgTPBsRk
	K44BAp+aMY7cOXCU9MmuVd7tminzDLEXCnzizs/nJrFY6H0B2TcZPrfk1XgQ63nL
	6kUyJQVz16bxlky3oM9uUhXt68p4FVkCUMXdYo7hi3Px4p3K2NC1nZAmfQNugp0i
	j8nyK3CJ2HHoUUBQKvwm5TGaA460EYNgG5Stw2iuNKw3J9XdsLs/BbtYzTipRMrd
	SSvCH8wyDLgtfOXclG7GmaOzBMvutBqLd3K/m82Z5V2IFfP7UTl393+YRj5h9QqJ
	7kg4QSazs9druUzbdINd9jsXRZR2xjR/KgRiU+gFUgAZXPsUi4YUD12PgjqJPQ3m
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Js8utDk7uqMD; Thu,  3 Apr 2025 21:21:24 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZTF674pCgzm0ysj;
	Thu,  3 Apr 2025 21:21:18 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH 11/24] scsi: ufs: core: Change the monitor function argument types
Date: Thu,  3 Apr 2025 14:17:55 -0700
Message-ID: <20250403211937.2225615-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
In-Reply-To: <20250403211937.2225615-1-bvanassche@acm.org>
References: <20250403211937.2225615-1-bvanassche@acm.org>
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
 drivers/ufs/core/ufshcd.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index f61ba94a8204..4b5734bbb12b 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2237,19 +2237,20 @@ static inline int ufshcd_monitor_opcode2dir(u8 op=
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
@@ -2258,14 +2259,16 @@ static void ufshcd_start_monitor(struct ufs_hba *=
hba,
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 }
=20
-static void ufshcd_update_monitor(struct ufs_hba *hba, const struct ufsh=
cd_lrb *lrbp)
+static void ufshcd_update_monitor(struct ufs_hba *hba,
+				  const struct scsi_cmnd *cmd)
 {
-	int dir =3D ufshcd_monitor_opcode2dir(*lrbp->cmd->cmnd);
+	const struct request *req =3D scsi_cmd_to_rq(cmd);
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
@@ -2309,8 +2312,8 @@ static inline void ufshcd_send_command(struct ufs_h=
ba *hba,
 	if (lrbp->cmd) {
 		ufshcd_add_command_trace(hba, lrbp->cmd, UFS_CMD_SEND);
 		ufshcd_clk_scaling_start_busy(hba);
-		if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
-			ufshcd_start_monitor(hba, lrbp);
+		if (unlikely(ufshcd_should_inform_monitor(hba, lrbp->cmd)))
+			ufshcd_start_monitor(hba, lrbp->cmd);
 	}
=20
 	if (hba->mcq_enabled) {
@@ -5562,8 +5565,8 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int =
task_tag,
 	lrbp->compl_time_stamp_local_clock =3D local_clock();
 	cmd =3D lrbp->cmd;
 	if (cmd) {
-		if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
-			ufshcd_update_monitor(hba, lrbp);
+		if (unlikely(ufshcd_should_inform_monitor(hba, lrbp->cmd)))
+			ufshcd_update_monitor(hba, lrbp->cmd);
 		ufshcd_add_command_trace(hba, cmd, UFS_CMD_COMP);
 		cmd->result =3D ufshcd_transfer_rsp_status(hba, lrbp, cqe);
 		ufshcd_release_scsi_cmd(hba, lrbp);
