Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D2A22B8B0
	for <linux-scsi@vger.kernel.org>; Fri, 31 Oct 2025 20:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761943361; cv=none; b=YkSoi/EJ7DpBzm0+RM19v3giLOMngQAVllbwXC4vWip7dC4AgNNuoOqe6nF5XO0VKUzsYeGkx/TVPlNtmeEYXrPIuz5ZWIls6ksNprutIVYGx2AL826iWO84MxmglS7lxKNo+WXGBGxV/Wug3acln0465Zsi9IoAbxswfe2wsYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761943361; c=relaxed/simple;
	bh=J2SY+cFEfRwg8JO0wzljUT+IdoKXVYoHRywIh2GvqaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gv88POpUvsNfeyKmJ4vxKTcMJvm8gUCeCO+bGxzdZEAtC7muutu6quezsBIWnoR8bwX4mOWrSA6ZZ2wwavX/XY/Fdj6INLX44MPAPy7gf5kjUOJstDZ3tJV7cuLsfk6IXfFWlPASkrfT21waNtBJoeHnVPJve3tkgZxjClSC7WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=x8XP7+OU; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="x8XP7+OU"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cytG6510Szm0pKX;
	Fri, 31 Oct 2025 20:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1761943356; x=1764535357; bh=hTHb1
	PjsvakuwyhacZ/9eLTFOarsCAcf9K5qZcwgYVg=; b=x8XP7+OU6v9owU0f82u2S
	/svSeLm6AyKBQbm1kKWfLNCon+as87u069AehmwlMGhW81GeGi6AzThqJ4zngtl8
	14BGQFoW865NeUOC5PuUVCv3qsjr6U2DyzgXzhCHporIYAcW6Qa6xRweWJDFwZ6f
	Z/5g5K8V6VzmYWqI5+5+4ywg3w3b6wt5WHdissNZzZOnt6Oq81PAB1NexHRCNad9
	mTusW6ne9EOS1MpFWPbs2meOEw2ZTu2Rp0c9nYYBZMZa/osu9jnNqlWd3Y6utuIp
	t8k5Rq+yIFqfNgokqEc6F0IcMhYjzBSPS1tw0rj0JwzKZULe/cJPqKNk+2XRZcD4
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id HexGPIO8CpgS; Fri, 31 Oct 2025 20:42:36 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cytFy68y2zm0pKC;
	Fri, 31 Oct 2025 20:42:30 +0000 (UTC)
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
Subject: [PATCH v8 15/28] ufs: core: Rework ufshcd_mcq_compl_pending_transfer()
Date: Fri, 31 Oct 2025 13:39:23 -0700
Message-ID: <20251031204029.2883185-16-bvanassche@acm.org>
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

Replace a tag loop with blk_mq_tagset_busy_iter(). This patch prepares
for removing the hba->lrb[] array.

Reviewed-by: Avri Altman <avri.altman@sandisk.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 80 ++++++++++++++++++++++-----------------
 1 file changed, 46 insertions(+), 34 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index df3f651c8d91..ed5def669a33 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5725,6 +5725,48 @@ static int ufshcd_poll(struct Scsi_Host *shost, un=
signed int queue_num)
 	return completed_reqs !=3D 0;
 }
=20
+static bool ufshcd_mcq_force_compl_one(struct request *rq, void *priv)
+{
+	struct scsi_cmnd *cmd =3D blk_mq_rq_to_pdu(rq);
+	struct scsi_device *sdev =3D rq->q->queuedata;
+	struct Scsi_Host *shost =3D sdev->host;
+	struct ufs_hba *hba =3D shost_priv(shost);
+	struct ufshcd_lrb *lrbp =3D &hba->lrb[rq->tag];
+	struct ufs_hw_queue *hwq =3D ufshcd_mcq_req_to_hwq(hba, rq);
+
+	if (!hwq)
+		return true;
+
+	ufshcd_mcq_compl_all_cqes_lock(hba, hwq);
+
+	/*
+	 * For those cmds of which the cqes are not present in the cq, complete
+	 * them explicitly.
+	 */
+	scoped_guard(spinlock_irqsave, &hwq->cq_lock) {
+		if (!test_bit(SCMD_STATE_COMPLETE, &cmd->state)) {
+			set_host_byte(cmd, DID_REQUEUE);
+			ufshcd_release_scsi_cmd(hba, lrbp);
+			scsi_done(cmd);
+		}
+	}
+
+	return true;
+}
+
+static bool ufshcd_mcq_compl_one(struct request *rq, void *priv)
+{
+	struct scsi_device *sdev =3D rq->q->queuedata;
+	struct Scsi_Host *shost =3D sdev->host;
+	struct ufs_hba *hba =3D shost_priv(shost);
+	struct ufs_hw_queue *hwq =3D ufshcd_mcq_req_to_hwq(hba, rq);
+
+	if (hwq)
+		ufshcd_mcq_poll_cqe_lock(hba, hwq);
+
+	return true;
+}
+
 /**
  * ufshcd_mcq_compl_pending_transfer - MCQ mode function. It is
  * invoked from the error handler context or ufshcd_host_reset_and_resto=
re()
@@ -5739,40 +5781,10 @@ static int ufshcd_poll(struct Scsi_Host *shost, u=
nsigned int queue_num)
 static void ufshcd_mcq_compl_pending_transfer(struct ufs_hba *hba,
 					      bool force_compl)
 {
-	struct ufs_hw_queue *hwq;
-	struct ufshcd_lrb *lrbp;
-	struct scsi_cmnd *cmd;
-	unsigned long flags;
-	int tag;
-
-	for (tag =3D 0; tag < hba->nutrs; tag++) {
-		lrbp =3D &hba->lrb[tag];
-		cmd =3D lrbp->cmd;
-		if (!ufshcd_cmd_inflight(cmd) ||
-		    test_bit(SCMD_STATE_COMPLETE, &cmd->state))
-			continue;
-
-		hwq =3D ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
-		if (!hwq)
-			continue;
-
-		if (force_compl) {
-			ufshcd_mcq_compl_all_cqes_lock(hba, hwq);
-			/*
-			 * For those cmds of which the cqes are not present
-			 * in the cq, complete them explicitly.
-			 */
-			spin_lock_irqsave(&hwq->cq_lock, flags);
-			if (cmd && !test_bit(SCMD_STATE_COMPLETE, &cmd->state)) {
-				set_host_byte(cmd, DID_REQUEUE);
-				ufshcd_release_scsi_cmd(hba, lrbp);
-				scsi_done(cmd);
-			}
-			spin_unlock_irqrestore(&hwq->cq_lock, flags);
-		} else {
-			ufshcd_mcq_poll_cqe_lock(hba, hwq);
-		}
-	}
+	blk_mq_tagset_busy_iter(&hba->host->tag_set,
+				force_compl ? ufshcd_mcq_force_compl_one :
+					      ufshcd_mcq_compl_one,
+				NULL);
 }
=20
 /**
