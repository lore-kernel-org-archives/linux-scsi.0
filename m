Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B6E2A1BF
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 20:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758746023; cv=none; b=YxmhTnaMUWazsnpfHaBRQ+VofXJCRbx14C9NPKa9TLBgCO10rp5Fl4riVyxBNQ8OK8YDhiekp9/k6bpU6XfwwSGanXam3+lzu62KsXU6+1qpvM3czUTV01oQ2VQCZmfAQGkfi/xyK+vi49W0vhedN2IfetQFD1mqMGAYXsHId2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758746023; c=relaxed/simple;
	bh=yjakNsQk/Bb7D2IyTLZfFijMKyvufPmlcNt1yGPLafI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fIsjlAH1G5sJUPxMJUUgeUciR0qXe4qO7+mE3JmBWMtxIazBFSw3hUYLw6oXIHOvsvE8qykYWhnpz8UxuDZp5iUqM6T3DSKIU2c2tT6zafNhoA8Ixe1BMJ4QR1ZUg7mDSASBUyvi90QwSkstEtKexAw77Z1peRlNdOsFMr/Sbdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=gs7oMVgm; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="gs7oMVgm"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cX7pr4Z1Tzlgqxf;
	Wed, 24 Sep 2025 20:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1758746018; x=1761338019; bh=gf2mn
	at/mcP/Cyam1G6wT5WgYLX+1AOqJpJFrgZawHM=; b=gs7oMVgmCYELQlwASARf1
	4mgRi5ihm73dqGTi5Pm5vdr/+AkuJ+4vmMMTFZit1JNHNBUz/AobZrvjRxW6NDsp
	nrjzHBFWQvMy/z7AikeaXLKZReRNrtH5sLFiTMe7vij0wkqxWxICddjK+A3PxkIV
	Bwo0rSL5mdL5J7mAY1o/58mOoSGS2uihh23uPOHc0wFMT+quSEmsjJsTQMaaGvLZ
	LtJEhdf812JywQHRXVYp+R4RqFHOQvezNtfV63nNcHqCKSWFaCwkcft5eMAZu9OT
	O/XDeEkNfswWJ/7nSWnDC9FIJNuUF7V6wSk2uom4uPU8ybH5wFm6MV/n4REcymou
	Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id KlXBS7QD9Hu9; Wed, 24 Sep 2025 20:33:38 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cX7pk57T5zlgqVP;
	Wed, 24 Sep 2025 20:33:33 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v5 16/28] ufs: core: Rework ufshcd_eh_device_reset_handler()
Date: Wed, 24 Sep 2025 13:30:35 -0700
Message-ID: <20250924203142.4073403-17-bvanassche@acm.org>
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

Merge the MCQ mode and legacy mode loops into a single loop. This patch
prepares for optimizing the hot path by removing the direct hba->lrb[]
accesses from ufshcd_eh_device_reset_handler().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 84 ++++++++++++++++++---------------------
 1 file changed, 38 insertions(+), 46 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index eea9e707ab4b..67607f2d10a2 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7538,6 +7538,36 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hb=
a *hba, struct utp_upiu_req *r
 	return err ? : result;
 }
=20
+static bool ufshcd_clear_lu_cmds(struct request *req, void *priv)
+{
+	struct scsi_cmnd *cmd =3D blk_mq_rq_to_pdu(req);
+	struct scsi_device *sdev =3D cmd->device;
+	struct Scsi_Host *shost =3D sdev->host;
+	struct ufs_hba *hba =3D shost_priv(shost);
+	const u64 lun =3D *(u64 *)priv;
+	const u32 tag =3D req->tag;
+
+	if (sdev->lun !=3D lun)
+		return true;
+
+	if (ufshcd_clear_cmd(hba, tag) < 0) {
+		dev_err(hba->dev, "%s: failed to clear request %d\n", __func__,
+			tag);
+		return true;
+	}
+
+	if (hba->mcq_enabled) {
+		struct ufs_hw_queue *hwq =3D ufshcd_mcq_req_to_hwq(hba, req);
+
+		if (hwq)
+			ufshcd_mcq_poll_cqe_lock(hba, hwq);
+		return true;
+	}
+
+	ufshcd_compl_one_cqe(hba, tag, NULL);
+	return true;
+}
+
 /**
  * ufshcd_eh_device_reset_handler() - Reset a single logical unit.
  * @cmd: SCSI command pointer
@@ -7546,12 +7576,8 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hb=
a *hba, struct utp_upiu_req *r
  */
 static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 {
-	unsigned long flags, pending_reqs =3D 0, not_cleared =3D 0;
 	struct Scsi_Host *host;
 	struct ufs_hba *hba;
-	struct ufs_hw_queue *hwq;
-	struct ufshcd_lrb *lrbp;
-	u32 pos, not_cleared_mask =3D 0;
 	int err;
 	u8 resp =3D 0xF, lun;
=20
@@ -7560,50 +7586,16 @@ static int ufshcd_eh_device_reset_handler(struct =
scsi_cmnd *cmd)
=20
 	lun =3D ufshcd_scsi_to_upiu_lun(cmd->device->lun);
 	err =3D ufshcd_issue_tm_cmd(hba, lun, 0, UFS_LOGICAL_RESET, &resp);
-	if (err || resp !=3D UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
-		if (!err)
-			err =3D resp;
-		goto out;
-	}
-
-	if (hba->mcq_enabled) {
-		for (pos =3D 0; pos < hba->nutrs; pos++) {
-			lrbp =3D &hba->lrb[pos];
-			if (ufshcd_cmd_inflight(lrbp->cmd) &&
-			    lrbp->lun =3D=3D lun) {
-				ufshcd_clear_cmd(hba, pos);
-				hwq =3D ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(lrbp->cmd));
-				ufshcd_mcq_poll_cqe_lock(hba, hwq);
-			}
-		}
-		err =3D 0;
-		goto out;
-	}
-
-	/* clear the commands that were pending for corresponding LUN */
-	spin_lock_irqsave(&hba->outstanding_lock, flags);
-	for_each_set_bit(pos, &hba->outstanding_reqs, hba->nutrs)
-		if (hba->lrb[pos].lun =3D=3D lun)
-			__set_bit(pos, &pending_reqs);
-	hba->outstanding_reqs &=3D ~pending_reqs;
-	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
-
-	for_each_set_bit(pos, &pending_reqs, hba->nutrs) {
-		if (ufshcd_clear_cmd(hba, pos) < 0) {
-			spin_lock_irqsave(&hba->outstanding_lock, flags);
-			not_cleared =3D 1U << pos &
-				ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
-			hba->outstanding_reqs |=3D not_cleared;
-			not_cleared_mask |=3D not_cleared;
-			spin_unlock_irqrestore(&hba->outstanding_lock, flags);
-
-			dev_err(hba->dev, "%s: failed to clear request %d\n",
-				__func__, pos);
-		}
+	if (err) {
+	} else if (resp !=3D UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
+		err =3D resp;
+	} else {
+		/* clear the commands that were pending for corresponding LUN */
+		blk_mq_tagset_busy_iter(&hba->host->tag_set,
+					ufshcd_clear_lu_cmds,
+					&cmd->device->lun);
 	}
-	__ufshcd_transfer_req_compl(hba, pending_reqs & ~not_cleared_mask);
=20
-out:
 	hba->req_abort_count =3D 0;
 	ufshcd_update_evt_hist(hba, UFS_EVT_DEV_RESET, (u32)err);
 	if (!err) {
