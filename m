Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7CB30595A
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 20:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760473132; cv=none; b=I6V1rhFTNpVpg/pGVmcFZUW1hOsoo1dn0Nl9uq805mFCLikvIcvqom+CREdES+g2BSU6BEdR9C2aYlEDvJE4udYdbeJayQn55LUAKZFaMG9sIkD1DYDJkOt5htvIR5HNXywP3fHrwEn8nY6VapMhQX980R3gwAPM/EnZg6wo9aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760473132; c=relaxed/simple;
	bh=4BooHVzsfS8Zc8JsHTeKFv6M8dri2Wij6zFkJ6h2KVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FF/GXllkYQCRf3wT419dozIxusSlDQJmQ0SY6PlbKNA+r7UTEAdQFAyfSGf1I2DGEmxlgX/xvbEohh1evTf8Ru5bruBc45f8M7pb8A9HKj6C5cVezkE8JhubBWkXfCnfOhCQZxHdqgTPaiPz34jhrtUuD7vS72pBqjGSzZgJOH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=mCpAmZ00; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="mCpAmZ00"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmQXT5Xhwzm0yVS;
	Tue, 14 Oct 2025 20:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760473127; x=1763065128; bh=VuTx4
	hxLtDtUAsoW8q55m3zamQigO0OlxiBmNRo2E8s=; b=mCpAmZ007+3bzS67jPWNz
	e5aL2Fc5/P81h27ptMVarK+BjA6/SrRJ1FMWPr77jXIhcSuhVyLeF+RbULYhhI8M
	tbs8pc1jvoavdq/c3o/WXqUXlrgcI86XWOQugFdVng/Cov06FoBz7PDt3gjqXVUF
	+GuXP4VEDPZ0Mh5WffraaUUxjS4dMYc9aXICV4Rx2/yIPcaotw17w0aNbEsL1jr2
	l4C0mS+PKXgttZdAk01U66ktwGmXwwytLyoSCIR0UcYesMTgyPDL887BqoE9B92W
	q6ys07gqy/T7VQzeq2kp+MTczwJo0CGHkXLURRIf824Xv729SsFX/mn2a57sd82X
	g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 7g_dc_0Ka3l2; Tue, 14 Oct 2025 20:18:47 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmQXJ5Gh4zm0yVD;
	Tue, 14 Oct 2025 20:18:39 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	"ping.gao" <ping.gao@samsung.com>
Subject: [PATCH v6 08/28] ufs: core: Move an assignment in ufshcd_mcq_process_cqe()
Date: Tue, 14 Oct 2025 13:15:50 -0700
Message-ID: <20251014201707.3396650-9-bvanassche@acm.org>
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

Prepare for introducing a WARN_ON_ONCE() call in ufshcd_mcq_get_tag() if
the tag lookup fails.

Reviewed-by: Avri Altman <avri.altman@sandisk.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-mcq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index c9bdd4140fd0..8780be79a0f8 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -307,9 +307,10 @@ static void ufshcd_mcq_process_cqe(struct ufs_hba *h=
ba,
 				   struct ufs_hw_queue *hwq)
 {
 	struct cq_entry *cqe =3D ufshcd_mcq_cur_cqe(hwq);
-	int tag =3D ufshcd_mcq_get_tag(hba, cqe);
=20
 	if (cqe->command_desc_base_addr) {
+		int tag =3D ufshcd_mcq_get_tag(hba, cqe);
+
 		ufshcd_compl_one_cqe(hba, tag, cqe);
 		/* After processed the cqe, mark it empty (invalid) entry */
 		cqe->command_desc_base_addr =3D 0;
