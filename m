Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75ECB306489
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 20:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760473197; cv=none; b=S4wOl4zUsCVfHqxsYcX6jh1w1SkZiTjTwclLVdEs1qyYGfdjI7Lc8T0ISxRVnonrbvMDQOGqDcaJUeGlx14YmjE7kVdq/ewIO9DxaZF/kaCB9QyHil0mWdhD85CtvQqQKoXfFvnY1Fr0kOxFUxB41qyPWu0B6WW78xNHDrz5zZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760473197; c=relaxed/simple;
	bh=E7lVFiY117wgyhE0XNWg1im4TvhZ6/2OBytfHvmWa5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b195zrWCv6hLQbTgo7tT4fDeloFMkU/RZU5BUPVLLKBIoTPOldnanVGZDTl2uRee1YYiVr7sPPq4o8yxvPxlxfW/Q4n+Dr3l5vtlOgOEEM9x5aznhJKKpc/9JP8hjKZkZDzCB2cYPNHjSekizUpt3qhYfWzmd2swjoT4MntPI20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=QHLv77ic; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="QHLv77ic"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmQYk3WgQzm0yVD;
	Tue, 14 Oct 2025 20:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760473192; x=1763065193; bh=zaFDj
	2aJBU1VVw0THqjXvacOVi+MEZvRhiD7c49Fml4=; b=QHLv77ic6XwfeOTZIYNJp
	HyvRIa9mvTPn3FcSWMZkMPifSTn4v/rpU57HPTy3RQuQTi50F0+cr5hg32H1BcI1
	4JKwwVzYh5pba22l5UDpcQxG9XjLveCVxLXmCJNauGCVZaeohJshrNYut0GD0n33
	3GURuhjTgyV74/t8yi8+BKxt3gLURnKG8S1hbTl+NUsdzd265PmCYkOAmTPw8FbS
	emjQ8l+lgpQ1CRX/xTG0sJzwL3K5yZk3fd/aHQf86ZbDzNSg26tvSWOLOSTQ7t3t
	aL99XkBe/H2tfP4AmBc612CsD/eUsyQKZr/Lm0UJYS7gd78jdBkw86W68oF48G7l
	g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id phU0ADqWPnzt; Tue, 14 Oct 2025 20:19:52 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmQYc5YMTzm0yV3;
	Tue, 14 Oct 2025 20:19:48 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v6 16/28] ufs: core: Rework ufshcd_eh_device_reset_handler()
Date: Tue, 14 Oct 2025 13:15:58 -0700
Message-ID: <20251014201707.3396650-17-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
In-Reply-To: <20251014201707.3396650-1-bvanassche@acm.org>
References: <20251014201707.3396650-1-bvanassche@acm.org>
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

Reviewed-by: Avri Altman <avri.altman@sandisk.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 84 ++++++++++++++++++---------------------
 1 file changed, 38 insertions(+), 46 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 32427b7b54df..7042880c4e60 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7563,6 +7563,36 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hb=
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
@@ -7571,12 +7601,8 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hb=
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
@@ -7585,50 +7611,16 @@ static int ufshcd_eh_device_reset_handler(struct =
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
