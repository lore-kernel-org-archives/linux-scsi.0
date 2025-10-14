Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA7030597F
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 20:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760473298; cv=none; b=IjE7CmIdyoM+vgRM1V92bnmnpk/rqfiyyR6kmiq+jYuURZomG+MZ3ohBM2oQtopq3nqESKx0duvC8Tr6jd0CMnchQ6PvGRH7yeE4Ir+SYSNhax00QMzgsIfpnfF4b9RDgQK90QjRlZgRH/8wQFhq7YZcufqHaRF2rSGYZPjrAWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760473298; c=relaxed/simple;
	bh=ibqR1A3anvoQsri8lNrVj6uOP2p+mFirVYww6W2I6Yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DFlhVso5b+Zt4fjyg80znnqb4omGVa7u65la6rK5II2OHv0FkijTXLU4PFb7Ck/QD6nAhzb9NUL0Nt7aaU6XgeJS46B38hDHEYHRt2VztAXU58slRxISXMEdvVHXzyQyJLWZQAxiSpsTggJEp1VQyiESEMe6TnW4nK4BsxhZ5Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=xnhpS1RU; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="xnhpS1RU"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmQbg16Stzm0yVD;
	Tue, 14 Oct 2025 20:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760473293; x=1763065294; bh=8zqVk
	VfrApbpoiwyE9Rc4jLe5dDq2Whk3f4zxwuDiCc=; b=xnhpS1RU+UtBNtNPOv/0K
	BNNx6r4hD3XZkl7QVSJyQDMYgV+U9HL4M8hcZc50S5gFDEHuFhDMecjvTsskUNhA
	1WhNLsGGhiXaxSaaNgPKgVGQ6b1WHPbpdMTvnpbRlCOoTbZRg2WnSP5qdBwmFACT
	r1SPnuGe4i4bRAvMdJEzoVLGiCjYzhWJuMCOwFRobTZRTV21HDFri9PU1U7zw1WW
	bzNU+g/Ggt/kC5H/yFpl3hM7IStwjSlwyVf1p+mvCnrUZPXdgj0HUDFGQ6USdxHg
	L+oAhoinaGqA53PvuQus5jLyALSs15LCt5rl57kdvoaIEFtudpKYhFBso9A+CVV2
	g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 1xwJHIINvJWM; Tue, 14 Oct 2025 20:21:33 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmQbX5wv1zm0yV3;
	Tue, 14 Oct 2025 20:21:28 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v6 26/28] ufs: core: Make blk_mq_tagset_busy_iter() skip reserved requests
Date: Tue, 14 Oct 2025 13:16:08 -0700
Message-ID: <20251014201707.3396650-27-bvanassche@acm.org>
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

A later patch will convert hba->reserved_slot into a reserved tag. Make
blk_mq_tagset_busy_iter() skip reserved requests such that device
management commands are skipped.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c20e2f87a65f..92c1a47044d5 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -644,7 +644,8 @@ static bool ufshcd_print_tr_iter(struct request *req,=
 void *priv)
 	struct Scsi_Host *shost =3D sdev->host;
 	struct ufs_hba *hba =3D shost_priv(shost);
=20
-	ufshcd_print_tr(hba, blk_mq_rq_to_pdu(req), *(bool *)priv);
+	if (!blk_mq_is_reserved_rq(req))
+		ufshcd_print_tr(hba, blk_mq_rq_to_pdu(req), *(bool *)priv);
=20
 	return true;
 }
@@ -5749,7 +5750,7 @@ static bool ufshcd_mcq_force_compl_one(struct reque=
st *rq, void *priv)
 	struct ufs_hba *hba =3D shost_priv(shost);
 	struct ufs_hw_queue *hwq =3D ufshcd_mcq_req_to_hwq(hba, rq);
=20
-	if (!hwq)
+	if (blk_mq_is_reserved_rq(rq) || !hwq)
 		return true;
=20
 	ufshcd_mcq_compl_all_cqes_lock(hba, hwq);
@@ -5776,7 +5777,7 @@ static bool ufshcd_mcq_compl_one(struct request *rq=
, void *priv)
 	struct ufs_hba *hba =3D shost_priv(shost);
 	struct ufs_hw_queue *hwq =3D ufshcd_mcq_req_to_hwq(hba, rq);
=20
-	if (hwq)
+	if (!blk_mq_is_reserved_rq(rq) && hwq)
 		ufshcd_mcq_poll_cqe_lock(hba, hwq);
=20
 	return true;
@@ -6644,6 +6645,9 @@ static bool ufshcd_abort_one(struct request *rq, vo=
id *priv)
 	struct Scsi_Host *shost =3D sdev->host;
 	struct ufs_hba *hba =3D shost_priv(shost);
=20
+	if (blk_mq_is_reserved_rq(rq))
+		return true;
+
 	*ret =3D ufshcd_try_to_abort_task(hba, tag);
 	dev_err(hba->dev, "Aborting tag %d / CDB %#02x %s\n", tag,
 		ufshcd_is_scsi_cmd(cmd) ? cmd->cmnd[0] : -1,
@@ -7593,7 +7597,7 @@ static bool ufshcd_clear_lu_cmds(struct request *re=
q, void *priv)
 	const u64 lun =3D *(u64 *)priv;
 	const u32 tag =3D req->tag;
=20
-	if (sdev->lun !=3D lun)
+	if (blk_mq_is_reserved_rq(req) || sdev->lun !=3D lun)
 		return true;
=20
 	if (ufshcd_clear_cmd(hba, tag) < 0) {
