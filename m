Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D371367
	for <linux-scsi@vger.kernel.org>; Wed, 27 Aug 2025 00:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756253573; cv=none; b=N95N28MFmB8hxKHQK7l1U/fDdE9nYE0RSfHDse6I3C4XrxIshHfrXndG5M0nkcEYJATFQC76YcXWWRK7H8O4ahV1KK/H/DBkpOH18ZsywhUtv47vc3FzKydzLk7IcJz07V/uv0dvsCc+j9DO/ACITJ0TYWYxR61FtDZ/coFHuP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756253573; c=relaxed/simple;
	bh=3VMYLNNrAAHI65E8m0jLG8KE+nV4urhj+EH/egaEFCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hrncin0fPRbxGdxp/T4ueEydQ4gqimbkBpx/RulEN+lhILi2uIX3S1XiPGqC1cmZW8Xf2I6LfZyCHyyRV+tDniOktXS5qJzsivzyXUlRBGpdmjzR7xf0S558HZoD5hztBjhzVZsifqC8ryIkvtFO8F0o1wMyl7bF+yUHF4xeTt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=nA4bLAKD; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="nA4bLAKD"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cBQ373zkMzm1742;
	Wed, 27 Aug 2025 00:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1756253570; x=1758845571; bh=SoWYH
	CtWfJd0BJpoOUe3G+P23lwjQkFj43+kg3EcKIs=; b=nA4bLAKDh6CcWkhF5pOhE
	wD5ODeScEj6LMAPmMgeOP738qxU6LbrVYZ6tB4RxNEYycrSG6trFHhIoe0DNO5tl
	9BvNq49dwYR8l4xEgFwDYdXOPV09U0A9dk2s/JCEw1ieWTy9aDzcA0ibV4NOe68j
	9EpA3FIbUZ2g6eb67hPbzSIPm42SGYirc505jSsvJlNmZ+HPVY6M7QY8mG0ZPD6y
	BRIA3b8zawjPyg7zLTKvPjq/1sOksYC/ulpp6OimSo2ME6hwAoo0paLcpX0XkTQz
	ArChOkMRswlL2MoXVrCmXr++9hACet7LajYYkVV7thElRpgWSHuBOjVK6atJLNvW
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id DZOPDRImGlfY; Wed, 27 Aug 2025 00:12:50 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cBQ311qr8zm0ysy;
	Wed, 27 Aug 2025 00:12:44 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v3 25/26] ufs: core: Make blk_mq_tagset_busy_iter() skip reserved requests
Date: Tue, 26 Aug 2025 17:06:29 -0700
Message-ID: <20250827000816.2370150-26-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
In-Reply-To: <20250827000816.2370150-1-bvanassche@acm.org>
References: <20250827000816.2370150-1-bvanassche@acm.org>
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
index 1fddf0669731..cccf4fb7b40e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -646,7 +646,8 @@ static bool ufshcd_print_tr_iter(struct request *req,=
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
@@ -5741,7 +5742,7 @@ static bool ufshcd_mcq_force_compl_one(struct reque=
st *rq, void *priv)
 	struct ufs_hba *hba =3D shost_priv(shost);
 	struct ufs_hw_queue *hwq =3D ufshcd_mcq_req_to_hwq(hba, rq);
=20
-	if (!hwq)
+	if (blk_mq_is_reserved_rq(rq) || !hwq)
 		return true;
=20
 	ufshcd_mcq_compl_all_cqes_lock(hba, hwq);
@@ -5768,7 +5769,7 @@ static bool ufshcd_mcq_compl_one(struct request *rq=
, void *priv)
 	struct ufs_hba *hba =3D shost_priv(shost);
 	struct ufs_hw_queue *hwq =3D ufshcd_mcq_req_to_hwq(hba, rq);
=20
-	if (hwq)
+	if (!blk_mq_is_reserved_rq(rq) && hwq)
 		ufshcd_mcq_poll_cqe_lock(hba, hwq);
=20
 	return true;
@@ -6629,6 +6630,9 @@ static bool ufshcd_abort_one(struct request *rq, vo=
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
@@ -7564,7 +7568,7 @@ static bool ufshcd_clear_lu_cmds(struct request *re=
q, void *priv)
 	const u64 lun =3D *(u64 *)priv;
 	const u32 tag =3D req->tag;
=20
-	if (sdev->lun !=3D lun)
+	if (blk_mq_is_reserved_rq(req) || sdev->lun !=3D lun)
 		return true;
=20
 	if (ufshcd_clear_cmd(hba, tag) < 0) {
