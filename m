Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5CAC3009D5
	for <linux-scsi@vger.kernel.org>; Fri, 12 Sep 2025 18:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757701603; cv=none; b=XOIVDk0zb0XhKVreJNnWnoZC3ph1ilb1SLnGX31oLPJaznzA4WwnwIzq5uoAhr8Wlt50alaaGVcqosIyvQfLH2Znds/vhmDdjJK6PRY4fBvQpjqQryDz+3hxm3nRZNCO76ll6v/ky9ldTYcJEyOh8aBoXnpumUOi1GfWk61xqoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757701603; c=relaxed/simple;
	bh=SrgSlDWm5q6VmRTzY0AwJdYkqIDYP9YCP7VmQBOucqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VzWiSWLYPU/aGqRUWSsL7/vVeO6yYCyL+yb3AvPvAvuMK4VX1nt+c04gZj8wRKaySbWhSNyQzBD8Sj7QQFs1PnTqdIE3p8yrSOznSwhIYeyVDYHeRo9fkYocNN0JcQRq6qX/SIj0uTafVGrbCtL2zVakLpzZVvxhytGd/yWNUug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Yfu/pVOH; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Yfu/pVOH"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cNjYs1pKLzltNQJ;
	Fri, 12 Sep 2025 18:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1757701599; x=1760293600; bh=+HfVl
	sekz7tMXidf5kqmTp+dJvvE9CLY1fpU9LF2qMQ=; b=Yfu/pVOH5D+I3R3Q2Pyva
	ie+CVGS8F7/P83FZTRMMgFlJLh3LOW7cdDPfc2vGOelAs+bTmK5kHKLRdfMGys5X
	NJQTTw5Xh2QThG3MMHbLCfR4IxPdSMKSx6L1Z/St4pUaxn//M/4OzfDWYcZiUL23
	AshuNfJewQFI94ycjnrbZKJXbXZf4eLkp7MIS6OKOcPL6kT5ywu6QuPmhx+WSfj5
	PXXKZaVGZ4nU9rWFLCS1iEXotUeT+DiVgmA2JdLsd4apMChMf9jwduk08kXCo0cf
	nzMNew3GmsPAf6fUizeKOEIv60kQF6ydP83fZiZ5FfrCjq5i9LvlUCYxLhhj0J3n
	Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Cklqiha7TSyL; Fri, 12 Sep 2025 18:26:39 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cNjYl4G5QzlgqVJ;
	Fri, 12 Sep 2025 18:26:34 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v4 15/29] ufs: core: Rework ufshcd_mcq_compl_pending_transfer()
Date: Fri, 12 Sep 2025 11:21:36 -0700
Message-ID: <20250912182340.3487688-16-bvanassche@acm.org>
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

Replace a tag loop with blk_mq_tagset_busy_iter(). This patch prepares
for removing the hba->lrb[] array.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 80 ++++++++++++++++++++++-----------------
 1 file changed, 46 insertions(+), 34 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 23c2e94bfd89..876c4de86b26 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5714,6 +5714,48 @@ static int ufshcd_poll(struct Scsi_Host *shost, un=
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
+		if (cmd && !test_bit(SCMD_STATE_COMPLETE, &cmd->state)) {
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
@@ -5728,40 +5770,10 @@ static int ufshcd_poll(struct Scsi_Host *shost, u=
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
