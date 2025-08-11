Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D850311C16
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 17:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754934135; cv=none; b=dJy71bLhz+S6yC2Loa6D0XzL0dp+j8I1OGUctzNiOZSZGeouUt8ZWG+sRpxdMVWqm5eiWVWz0p0z8/CUM9gyh8mpqkkmPj7f5/NKjmmLoBdaYB8uvcq3tRXbYrk81NmfIXDMzhTa8MkB7hdMvrDbgvgGFNuZvNyBQ+xFgmnDeiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754934135; c=relaxed/simple;
	bh=dpNUToctrX9kLKCdxqKyP4Kw6nFglxVsBoOjgHYwMKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jpF7A2TqhBxKkXokQj7h7YI+IQAdidqwVkwmFcXaeFGvpTxLNMBdj94WuXvCpYZNX9FazUVjKEtUuzF7n6TRoPtbmvzQPZPVEg1LZIqrVFzuelcxKpdWubOUStbnIHSBYl+eV9RKfGNIXcMoRhs/t5JSLcbt6IdYvF69+Mk4VzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ylYBHET7; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ylYBHET7"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c125K4Q0RzlgqTq;
	Mon, 11 Aug 2025 17:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1754934132; x=1757526133; bh=Bm6jv
	m+VEYHNbub5stUs42TOP0G3wsDytkJIWLZTK34=; b=ylYBHET7AO3+t6nqz01rr
	p9byiWv++9hRZF9HqpIoEILuKTjYmGDzQLLFNIhDgGKY8hfgL+HVxjIC+iHEGJdF
	KvZzkDkggWsPsUnNptgwlRUMKtqyP9AbrQGIuqbA/jjDvC9iNfrlKnECNNHOh3FT
	vNeqlSz/D4iLWAmYUrpceZ33p0KG7q5p6GPVgx+brlD2Eomos1iGRVPki+eR1vsQ
	yfz3MtWAI07isBKVjWY7QUnfS/pkMPcLxYfiGPg8TTKyDq7ICjLN3F6mRFFtqi0N
	KhvivcmDrSWqnZ90h9LRmHggT74bhzaoosHANYD+43zsx6imD1ese9cCjzvPKxhu
	A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id XlUaseOUv-G3; Mon, 11 Aug 2025 17:42:12 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c125C5pwzzlgqTr;
	Mon, 11 Aug 2025 17:42:06 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v2 29/30] ufs: core: Make blk_mq_tagset_busy_iter() skip reserved requests
Date: Mon, 11 Aug 2025 10:34:41 -0700
Message-ID: <20250811173634.514041-30-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
In-Reply-To: <20250811173634.514041-1-bvanassche@acm.org>
References: <20250811173634.514041-1-bvanassche@acm.org>
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
index 56af37706155..84875a6aee4e 100644
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
@@ -5730,7 +5731,7 @@ static bool ufshcd_mcq_force_compl_one(struct reque=
st *rq, void *priv)
 	struct ufs_hba *hba =3D shost_priv(shost);
 	struct ufs_hw_queue *hwq =3D ufshcd_mcq_req_to_hwq(hba, rq);
=20
-	if (!hwq)
+	if (blk_mq_is_reserved_rq(rq) || !hwq)
 		return true;
=20
 	ufshcd_mcq_compl_all_cqes_lock(hba, hwq);
@@ -5757,7 +5758,7 @@ static bool ufshcd_mcq_compl_one(struct request *rq=
, void *priv)
 	struct ufs_hba *hba =3D shost_priv(shost);
 	struct ufs_hw_queue *hwq =3D ufshcd_mcq_req_to_hwq(hba, rq);
=20
-	if (hwq)
+	if (!blk_mq_is_reserved_rq(rq) && hwq)
 		ufshcd_mcq_poll_cqe_lock(hba, hwq);
=20
 	return true;
@@ -6624,6 +6625,9 @@ static bool ufshcd_abort_one(struct request *rq, vo=
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
@@ -7560,7 +7564,7 @@ static bool ufshcd_clear_lu_cmds(struct request *re=
q, void *priv)
 	const u64 lun =3D *(u64 *)priv;
 	const u32 tag =3D req->tag;
=20
-	if (sdev->lun !=3D lun)
+	if (blk_mq_is_reserved_rq(req) || sdev->lun !=3D lun)
 		return true;
=20
 	if (ufshcd_clear_cmd(hba, tag) < 0) {
