Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A1F3009D5
	for <linux-scsi@vger.kernel.org>; Fri, 12 Sep 2025 18:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757701594; cv=none; b=lUSH94iFVacyPV39xS/m6thPIn/w/NTn7vRQerZMPFQ+GD5hKbDvbOD0e3vZq+vahtAkiYihgfwaXgTY/p2R5mClUHwsU/oK4q/p2PM1ec7oGCUpnRSR5sXTgs5+/wUcKsEovfOClUaaml5+y5Hcw84vK9vxNbFPVqB0zWMj9uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757701594; c=relaxed/simple;
	bh=lmsClijod0ULNJrzK+MfPNAcBjE1yN0zkT1Ha2dErks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNEkXa61N5lt1UuXbJYalVXSUwHn07bPLUKjxMH8O4TL+HELxiIAnpIpXo6m1A+z8STV1v1Cb/dyNTR1TgFHPXsMw7ayrzQbBaXel8wfzPg3s8dhlGxaAx2MsMq3H4Oq7BV4XSGHgLUL3jszH+pW14NYNmxjtKKiiJumgzQPvAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=QuGCKj4x; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="QuGCKj4x"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cNjYh3LzczlgqVx;
	Fri, 12 Sep 2025 18:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1757701590; x=1760293591; bh=WhlbQ
	z6zYI37y9+lowVb/77Me0PpF1tAEfjdVQbT03w=; b=QuGCKj4xeoBtN9WXBoniO
	wJV31maOKV65zGoelspdovf7MGUc+ox+6e6WW88p1xaQwP3vChoaDQ6HKFeENZ/R
	MXykHk1GUiECrxdk5vW/k1Vqgs4S0Enq0I0qAKyhSk2FWI7hHDkhKSTrBJtfrKy3
	mkVSFcq7QNxQaW+x4UERmTz0EXqbMOc+DbKLpxy6FUgUGYd/ApcUHzEjwS2qrzJb
	jwqsvCYhrIQ4b+ewKWblJaRdeIlwFEiJ5OEzL+AU1IKVmShJLLF4/So3sRBZvnPy
	eBW8d3T5iPMalt16yHQQx72GfLXc8N7Fmsmpv0uej8sBW8O8la3FRKeyM2L+DUU9
	A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id t80K6kXGNohO; Fri, 12 Sep 2025 18:26:30 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cNjYY4z9vzlgqVJ;
	Fri, 12 Sep 2025 18:26:24 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v4 14/29] ufs: core: Change the monitor function argument types
Date: Fri, 12 Sep 2025 11:21:35 -0700
Message-ID: <20250912182340.3487688-15-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
In-Reply-To: <20250912182340.3487688-1-bvanassche@acm.org>
References: <20250912182340.3487688-1-bvanassche@acm.org>
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
index bd57baa15e8d..23c2e94bfd89 100644
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
