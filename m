Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE591CA6F
	for <linux-scsi@vger.kernel.org>; Fri, 31 Oct 2025 20:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761943482; cv=none; b=rvbf5g75QDolcU8bf9v/fU812I8fuMTm+0R0R6EDt2ZG7EKiuUdQaM23Z9nLDPUcNxocgQq8zQE7WP1P1U2JvTEOdCGI6kxOCC2dkb96Ycv0i+bhQdbb/MKJe0s+k6M7UKjkWJvzGwTemX8V8AG/TNd2vFqBToNOB3qdm1pBtyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761943482; c=relaxed/simple;
	bh=BprVuljO6AVQ1aFCV9bhIM5lG1CWo8VnI1J7srzaBmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=finbMMDXkd6ni1PvOgC2kTxxn/gtirWZEyFnI7YavxZp2/1ma9DBh8v860ue8+wgawr89L1X779imwOy1CeAo9+j37j00vkZbCgqqi5epTfpQIENyWA371wg1nNvQW3cFXfFXgC+bNmLVBaWc+JJcW5MxSYAnwL/okrbTtD2424=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=EXVNeLob; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="EXVNeLob"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cytJR4t1Gzm0jvG;
	Fri, 31 Oct 2025 20:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1761943477; x=1764535478; bh=L24Bz
	7JY0DPOVT1hG6ArhBW/+TUYANutzjBnogKxdtM=; b=EXVNeLobvDFGqmcK1Gz4z
	Q2uz6VPM/DLkmu+Pn5kRB+uMH1PJ6CATKxvlAYUg/j5M/4PZPXvINd5xDndLCtKK
	w8wgpknxnggfb/VCwWY8mCjcfu5ZgmEY7bi6ERYAI7x6Culz40qnCcAh/bxTi5Dn
	FM9CLBZ908r71ivfBB/YjSowMH1xD1jxKMTieIRyYEKEXmf29geOmcfztGvf2P/j
	emWDGYfhV7oUKDwqw4giUWv/H1kZaLOvUAposoPclLruZ2SMSvV3kfZI/0Hn1gQT
	KKtO3V1riHC5chStrrSrNObITk8ETCBcxiy6BQ8b+vzFRpL1r6uf3qn9ogmXGujs
	Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id nmKgOvTWmjaf; Fri, 31 Oct 2025 20:44:37 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cytJH6RGVzm0pL4;
	Fri, 31 Oct 2025 20:44:31 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v8 26/28] ufs: core: Make blk_mq_tagset_busy_iter() skip reserved requests
Date: Fri, 31 Oct 2025 13:39:34 -0700
Message-ID: <20251031204029.2883185-27-bvanassche@acm.org>
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

A later patch will convert hba->reserved_slot into a reserved tag. Make
blk_mq_tagset_busy_iter() skip reserved requests such that device
management commands are skipped.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 3e0fa433579d..f493f180279f 100644
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
@@ -5753,7 +5754,7 @@ static bool ufshcd_mcq_force_compl_one(struct reque=
st *rq, void *priv)
 	struct ufs_hba *hba =3D shost_priv(shost);
 	struct ufs_hw_queue *hwq =3D ufshcd_mcq_req_to_hwq(hba, rq);
=20
-	if (!hwq)
+	if (blk_mq_is_reserved_rq(rq) || !hwq)
 		return true;
=20
 	ufshcd_mcq_compl_all_cqes_lock(hba, hwq);
@@ -5780,7 +5781,7 @@ static bool ufshcd_mcq_compl_one(struct request *rq=
, void *priv)
 	struct ufs_hba *hba =3D shost_priv(shost);
 	struct ufs_hw_queue *hwq =3D ufshcd_mcq_req_to_hwq(hba, rq);
=20
-	if (hwq)
+	if (!blk_mq_is_reserved_rq(rq) && hwq)
 		ufshcd_mcq_poll_cqe_lock(hba, hwq);
=20
 	return true;
@@ -6648,6 +6649,9 @@ static bool ufshcd_abort_one(struct request *rq, vo=
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
@@ -7597,7 +7601,7 @@ static bool ufshcd_clear_lu_cmds(struct request *re=
q, void *priv)
 	const u64 lun =3D *(u64 *)priv;
 	const u32 tag =3D req->tag;
=20
-	if (sdev->lun !=3D lun)
+	if (blk_mq_is_reserved_rq(req) || sdev->lun !=3D lun)
 		return true;
=20
 	if (ufshcd_clear_cmd(hba, tag) < 0) {
