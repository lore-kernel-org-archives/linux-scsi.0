Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F41F329F0F
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 20:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758746009; cv=none; b=c8wbvEDzIMB1ctfL97dBd59/1M1n32JTzoIcPx6HVc3E8SABVFWSXQaZODOdiIt3E0ROX4AzJ65x5OJi+6BWytzTY04VfMy44g2dU3hqQvw+0agQtfRGMlXN85huQMMPMWsg2kqvVxIgLCgWnLQamhoHGnIR6EHRl2Qq/vfitqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758746009; c=relaxed/simple;
	bh=nOz1m/aXPTTUGpE+Mlg74C5dQ5vg+8EyDpjhp7Wd5OM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLhtBRhMhNS5dhdKR0OZCuDHe0OLlL8Gx6tWwLGyX1IWEdBM4ZRmNDWi+18zIGKtH0hzNuB/tXL3JhABlNr5UAfqnB67d8xNxeczLo1KED7IUPnYc8ndc872GbLCxalt5W/ttGl9YFEoZaLCLYRXunCmVPvlQlZrp9/kZPWDU24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=kvgMeTzz; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="kvgMeTzz"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cX7pZ4kjwzlgqxl;
	Wed, 24 Sep 2025 20:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1758746004; x=1761338005; bh=xtLaQ
	RLEgEGSHx4Uk01zQ8m7p5btSPaoY7YRDfa4xWA=; b=kvgMeTzz8MBhVqge9d2pG
	WHSEBvds6bcchLC3F6TUHj/KfJTAdHt2vgNP+n3MX0dImUbPQd+hh03GPiSc2vJA
	Y7jvRDQ3gh4nFJSssAsHxcHUqjxzYzjtxIFDobpy8Z0KXw3CtZY1fVsTILmQRu9d
	ij3b+r7o8tXpQoMqJN/vAxfp+VO0elSwHKwSQB8k1XCmcm/Fgrf9UDNebtILonE9
	va1MMIEsz09Mtx3zYulqKlHixttceEqqaIGnkts0IE4Q/sRZXM8XLiDxQGmjwZZc
	Xb6SJxLiVu5O2p5kot7miCJtPe98rhqe0QM2sOtoRDM4Bg17o7IglNLuVB8QlOW8
	w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6Jh18AKVAZk0; Wed, 24 Sep 2025 20:33:24 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cX7pS56kLzlgqVP;
	Wed, 24 Sep 2025 20:33:19 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v5 14/28] ufs: core: Change the monitor function argument types
Date: Wed, 24 Sep 2025 13:30:33 -0700
Message-ID: <20250924203142.4073403-15-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
In-Reply-To: <20250924203142.4073403-1-bvanassche@acm.org>
References: <20250924203142.4073403-1-bvanassche@acm.org>
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
index be8fd3b15d5f..ec1c8bdf07e6 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2294,19 +2294,20 @@ static inline int ufshcd_monitor_opcode2dir(u8 op=
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
@@ -2315,14 +2316,15 @@ static void ufshcd_start_monitor(struct ufs_hba *=
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
@@ -2357,6 +2359,7 @@ static inline void ufshcd_send_command(struct ufs_h=
ba *hba,
 				       struct ufshcd_lrb *lrbp,
 				       struct ufs_hw_queue *hwq)
 {
+	struct scsi_cmnd *cmd =3D lrbp->cmd;
 	unsigned long flags;
=20
 	if (hba->monitor.enabled) {
@@ -2365,11 +2368,11 @@ static inline void ufshcd_send_command(struct ufs=
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
@@ -2385,8 +2388,7 @@ static inline void ufshcd_send_command(struct ufs_h=
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
@@ -5620,19 +5622,17 @@ void ufshcd_release_scsi_cmd(struct ufs_hba *hba,
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
