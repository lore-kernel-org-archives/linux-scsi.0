Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3933A3314D2
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 18:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786559078; cv=none; b=hfdAPgAJSnq+e0s/r7x0Kg/SARD72ACg2QH925mwnDYNyoDE6tvG/336tOoD80ztUn8nrb89J+iBcIbHDSKd7u+p8SqGNTGsJCnAtOjWCSF+SitEuJpjdy0HsEI/qsVQrs/IUQWUyFo2eKpZeGIWlS0V52GHUOwTysJme5kJO2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786559078; c=relaxed/simple;
	bh=Eq9ExLVbkmv5XxnfEGp5SPXTMxuCDs6zLFumNBtnNjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JpOGfBBLoT+yex6AhQeV27V9b62tpk0J/gCQ/8XIDOlbl/A7OI+SCaMFRFVFroJcknTNM9xSneIjjsnyFufDJ270avFvMm8Xxfvxl/kAm9a+garl3irvdzEQH+jQ9TZksbTWCHLvWLjSxR1Cu86GLhV9R1uQECLoPYGxU0B7mBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=wNQ/iD+8; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="wNQ/iD+8"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hKxjJ4QX3z1XM6JR;
	Wed, 12 Aug 2026 18:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1786559061; x=1789151062; bh=o0svL
	obZCuZ0kuLY86I6mS0mGwlxKXczkecoZYjJEr0=; b=wNQ/iD+864DP4p7UUhCRH
	Iznj4vnn9AD+brzX35n9SRh4GwSy0w80epsWPNJ2lN6TPsB4KIpjFi+9Z5PXR138
	/pGojx24WQAaa+KbqSXm8CJE7r/Rmw6huUo6X67IT400gX8tHmCdqTlbKfUBWpkM
	8+ZR8T9mj14OPBNGU/B2h+LR1fwLdDGAt3eUs1yB5raTkYQZX3WZkLreDyTPIYi4
	AlS879sdtLm3rRY2NRPLK9IPJ7W9fqGaZca2fgYpajdK4yGcOqDfj2Sy88WUDYWM
	vUUWLvZU9ZuL5DdNwVDlZiICOHZeEJw6Bb9fFz1AQXxb1Z60ZaAc3xVE1UzICQ64
	w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id YlctbCMCZkhZ; Wed, 12 Aug 2026 18:24:21 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (245.199.118.34.bc.googleusercontent.com [34.118.199.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hKxhw0TzSz1XM6Jb;
	Wed, 12 Aug 2026 18:24:15 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	vamshi gajjela <vamshigajjela@google.com>,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Hyeoncheol Jeong <hyenc.jeong@samsung.com>,
	Chanwoo Lee <cw9316.lee@samsung.com>,
	Bean Huo <beanhuo@micron.com>,
	Can Guo <can.guo@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH 3/3] ufs: core: Do not forcibly complete SCSI commands
Date: Wed, 12 Aug 2026 18:22:58 +0000
Message-ID: <182ad9c472505abc7958d85c772d56e8a40e3b69.1786558726.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.691.gc56d675ccc-goog
In-Reply-To: <cover.1786558726.git.bvanassche@acm.org>
References: <cover.1786558726.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The SCSI core error handler is responsible for deciding whether to abort =
or
to requeue SCSI commands. A SCSI LLD shouldn't interfere with this decisi=
on.
Hence, do not forcibly complete SCSI commands from inside the UFS error
handler. This patch makes the MCQ behavior consistent with the behavior f=
or
legacy mode.

Fixes: ab248643d3d6 ("scsi: ufs: core: Add error handling for MCQ mode")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-mcq.c     | 26 ------------------
 drivers/ufs/core/ufshcd-priv.h |  2 --
 drivers/ufs/core/ufshcd.c      | 48 +++++-----------------------------
 3 files changed, 7 insertions(+), 69 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 8106d55f4041..55ed72d15ada 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -328,32 +328,6 @@ static void ufshcd_mcq_process_cqe(struct ufs_hba *h=
ba,
 	}
 }
=20
-/*
- * This function is called from the UFS error handler with the UFS host
- * controller disabled (HCE =3D 0). Reading host controller registers, e=
.g. the
- * CQ tail pointer (CQTPy), may not be safe with the host controller dis=
abled.
- * Hence, iterate over all completion queue entries. This won't result i=
n
- * double completions because ufshcd_mcq_process_cqe() clears a CQE afte=
r it
- * has been processed.
- */
-void ufshcd_mcq_compl_all_cqes_lock(struct ufs_hba *hba,
-				    struct ufs_hw_queue *hwq)
-{
-	unsigned long flags;
-	u32 entries =3D hwq->max_entries;
-
-	spin_lock_irqsave(&hwq->cq_lock, flags);
-	while (entries > 0) {
-		ufshcd_mcq_process_cqe(hba, hwq);
-		ufshcd_mcq_inc_cq_head_slot(hwq);
-		entries--;
-	}
-
-	ufshcd_mcq_update_cq_tail_slot(hwq);
-	hwq->cq_head_slot =3D hwq->cq_tail_slot;
-	spin_unlock_irqrestore(&hwq->cq_lock, flags);
-}
-
 unsigned long ufshcd_mcq_poll_cqe_lock(struct ufs_hba *hba,
 				       struct ufs_hw_queue *hwq)
 {
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-pri=
v.h
index e55c2a02c1f5..8ddc19143abf 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -73,8 +73,6 @@ int ufshcd_get_hba_mac(struct ufs_hba *hba);
 int ufshcd_mcq_memory_alloc(struct ufs_hba *hba);
 struct ufs_hw_queue *ufshcd_mcq_req_to_hwq(struct ufs_hba *hba,
 					   struct request *req);
-void ufshcd_mcq_compl_all_cqes_lock(struct ufs_hba *hba,
-				    struct ufs_hw_queue *hwq);
 bool ufshcd_cmd_inflight(struct scsi_cmnd *cmd);
 int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int task_tag);
 int ufshcd_mcq_abort(struct scsi_cmnd *cmd);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0618712be32c..963784f8c0a6 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6018,34 +6018,6 @@ static int ufshcd_poll(struct Scsi_Host *shost, un=
signed int queue_num)
 	return completed_reqs !=3D 0;
 }
=20
-static bool ufshcd_mcq_force_compl_one(struct request *rq, void *priv)
-{
-	struct scsi_cmnd *cmd =3D blk_mq_rq_to_pdu(rq);
-	struct scsi_device *sdev =3D rq->q->queuedata;
-	struct Scsi_Host *shost =3D sdev->host;
-	struct ufs_hba *hba =3D shost_priv(shost);
-	struct ufs_hw_queue *hwq =3D ufshcd_mcq_req_to_hwq(hba, rq);
-
-	if (blk_mq_is_reserved_rq(rq) || !hwq)
-		return true;
-
-	ufshcd_mcq_compl_all_cqes_lock(hba, hwq);
-
-	/*
-	 * For those cmds of which the cqes are not present in the cq, complete
-	 * them explicitly.
-	 */
-	scoped_guard(spinlock_irqsave, &hwq->cq_lock) {
-		if (!test_bit(SCMD_STATE_COMPLETE, &cmd->state)) {
-			set_host_byte(cmd, DID_REQUEUE);
-			ufshcd_release_scsi_cmd(hba, cmd);
-			scsi_done(cmd);
-		}
-	}
-
-	return true;
-}
-
 static bool ufshcd_mcq_compl_one(struct request *rq, void *priv)
 {
 	struct scsi_device *sdev =3D rq->q->queuedata;
@@ -6066,16 +6038,10 @@ static bool ufshcd_mcq_compl_one(struct request *=
rq, void *priv)
  * the scsi command.
  *
  * @hba: per adapter instance
- * @force_compl: This flag is set to true when invoked
- * from ufshcd_host_reset_and_restore() in which case it requires specia=
l
- * handling because the host controller has been reset by ufshcd_hba_sto=
p().
  */
-static void ufshcd_mcq_compl_pending_transfer(struct ufs_hba *hba,
-					      bool force_compl)
+static void ufshcd_mcq_compl_pending_transfer(struct ufs_hba *hba)
 {
-	blk_mq_tagset_busy_iter(&hba->host->tag_set,
-				force_compl ? ufshcd_mcq_force_compl_one :
-					      ufshcd_mcq_compl_one,
+	blk_mq_tagset_busy_iter(&hba->host->tag_set, ufshcd_mcq_compl_one,
 				NULL);
 }
=20
@@ -6632,10 +6598,10 @@ static void ufshcd_exception_event_handler(struct=
 work_struct *work)
 }
=20
 /* Complete requests that have door-bell cleared */
-static void ufshcd_complete_requests(struct ufs_hba *hba, bool force_com=
pl)
+static void ufshcd_complete_requests(struct ufs_hba *hba)
 {
 	if (hba->mcq_enabled)
-		ufshcd_mcq_compl_pending_transfer(hba, force_compl);
+		ufshcd_mcq_compl_pending_transfer(hba);
 	else
 		ufshcd_transfer_req_compl(hba);
=20
@@ -6936,7 +6902,7 @@ static bool ufshcd_abort_all(struct ufs_hba *hba)
=20
 out:
 	/* Complete the requests that are cleared by s/w */
-	ufshcd_complete_requests(hba, false);
+	ufshcd_complete_requests(hba);
=20
 	return ret !=3D 0;
 }
@@ -6998,7 +6964,7 @@ static void ufshcd_err_handler(struct work_struct *=
work)
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
=20
 	/* Complete requests that have door-bell cleared by h/w */
-	ufshcd_complete_requests(hba, false);
+	ufshcd_complete_requests(hba);
 	spin_lock_irqsave(hba->host->host_lock, flags);
 again:
 	needs_restore =3D false;
@@ -8229,7 +8195,7 @@ static int ufshcd_host_reset_and_restore(struct ufs=
_hba *hba)
 	 */
 	ufshcd_hba_stop(hba);
 	hba->silence_err_logs =3D true;
-	ufshcd_complete_requests(hba, true);
+	ufshcd_complete_requests(hba);
 	hba->silence_err_logs =3D false;
=20
 	/* scale up clocks to max frequency before full reinitialization */
