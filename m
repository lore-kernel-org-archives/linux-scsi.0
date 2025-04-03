Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1631A80B
	for <linux-scsi@vger.kernel.org>; Thu,  3 Apr 2025 21:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743715298; cv=none; b=rZO0d7+zHPGg6+8KeQ404zyseE0iWsuz4hBfkzKZUQEJIU36hOl66W91WHE3m66j992aeJcZyuFivZQsBLKM8uVSw3gV5yRGN1rITqVq4RWYsB73hqplkwqQDo+mceVvMMmqd3Vv1nuJixoDIoc+fCAGCOoRc3mLLnjBNM9URDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743715298; c=relaxed/simple;
	bh=xCOIQCkJpdOMQzY/DrDuJV1Oy0FRCX5dBN6WtM3UaoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ND8OUAsslPJ+Yhlko4ZpCm1//A97X2tJUz84XslpEopRk6vhzi3qdL6B2ytIfh3CaAcotypbQhDrMxZJ3ezzSQP5x0WM3lvItUMkbjGtFNwD3coiwFLKVLEldoPLnU40PMTdx20Bx5TFSKMeVVKpb3IFKmk7grdKIEiu98YlOto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Tope2Eqh; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Tope2Eqh"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZTF6S0Vqbzm0yVH;
	Thu,  3 Apr 2025 21:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1743715294; x=1746307295; bh=xYRLW
	D5X2om02WIA1YVwWI5j0tonfPMlbIEyZuyiwzI=; b=Tope2Eqh4Fds/Y6b/yZZA
	PucraHehLyYgDY2OBQbQPgGpVrglTWkc5720KxC2ikyzGSASY18NM4Ga9QpQEHNn
	bXh9QSnTzHw105fpnQfSD8PQN40n3g1lenafCzMqG7dusDL9ns+hjcyskzWFF0j9
	qFMPxwO0fYHZEx/mh8VxfPmwkLNj5mZLpVd8zoXxAlek6N4oFMebAaPmJh7UDLeS
	SiLZuRT1BSO5If5H0mKKDCJwkAZIPRHEW8/tAHwJtn+4k1bIZlGLEY9+lovrw8Tv
	X1zF72xMW+vDrOxah+MfmPQMKMpDCNQNxwJ6N4Jh051woPNP+5FXWLI2jq1bxXDp
	Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id kcG_IlsdviPe; Thu,  3 Apr 2025 21:21:34 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZTF6K145lzm0yVk;
	Thu,  3 Apr 2025 21:21:28 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH 12/24] scsi: ufs: core: Rework ufshcd_mcq_compl_pending_transfer()
Date: Thu,  3 Apr 2025 14:17:56 -0700
Message-ID: <20250403211937.2225615-13-bvanassche@acm.org>
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

Replace a tag loop with blk_mq_tagset_busy_iter(). This patch prepares
for removing the hba->lrb[] array.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 74 ++++++++++++++++++++++-----------------
 1 file changed, 42 insertions(+), 32 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 4b5734bbb12b..a5faf5af462e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5651,6 +5651,44 @@ static int ufshcd_poll(struct Scsi_Host *shost, un=
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
+	unsigned long flags;
+
+	ufshcd_mcq_compl_all_cqes_lock(hba, hwq);
+	/*
+	 * For those cmds of which the cqes are not present
+	 * in the cq, complete them explicitly.
+	 */
+	spin_lock_irqsave(&hwq->cq_lock, flags);
+	if (cmd && !test_bit(SCMD_STATE_COMPLETE, &cmd->state)) {
+		set_host_byte(cmd, DID_REQUEUE);
+		ufshcd_release_scsi_cmd(hba, lrbp);
+		scsi_done(cmd);
+	}
+	spin_unlock_irqrestore(&hwq->cq_lock, flags);
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
+	ufshcd_mcq_poll_cqe_lock(hba, hwq);
+
+	return true;
+}
+
 /**
  * ufshcd_mcq_compl_pending_transfer - MCQ mode function. It is
  * invoked from the error handler context or ufshcd_host_reset_and_resto=
re()
@@ -5665,38 +5703,10 @@ static int ufshcd_poll(struct Scsi_Host *shost, u=
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
