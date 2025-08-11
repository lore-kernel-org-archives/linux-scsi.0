Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540C02D6E40
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 17:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754934043; cv=none; b=AGNXIkXZTEqyGFCeMIaXyqRYTllzSqSrzsRmExAo0Gxjg6MJW2avHPGQCDN1XRvM5wTw6uZNSkjoTIl4BpwAQE56GCgBWhsweoEnFmjmq/DOP2Ozzx/i0C3iS/EtMFcK2Yr2nc925XwOyTIA1ZYUgZgjTm5dbT86mQYAqyj25vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754934043; c=relaxed/simple;
	bh=xOq8W0bBS53OS/NU9XIod8BgnbtrUShnPmhMKF2jg1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZyIE6cB4v8bRZPer7CzHRaaXA88jSIebCRhagWE8IVklfGIRNixDUbePnPczpKeeakWlImaSJrkZom3ygnBRooG1jqwNWXsm//SdA7+G4nIbB1R9+wa2eKB2VRQffmMZxxtQD5G0Bn4Qk6BJCnM6xTWnpcVqsRIe4RyiiWjRgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=HJtBOEn9; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="HJtBOEn9"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c123Y51M9zlgqTr;
	Mon, 11 Aug 2025 17:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1754934039; x=1757526040; bh=DqLur
	5WAzEUZ2eZec6GOhTVG0xE+pea1UZssclnfkuY=; b=HJtBOEn9ymj3Fw61OrVRw
	JIyqJ746U1HFvg4duzUJv4alihBQFzP1sZ9ZolXLWrCsaidT+zgCCYkQjtnOBr4x
	VPtoJcPeDCQRUt3dPATUWt6/uscytLUtnno3/0Apzf9KXJRfni9sHpXZq2O6Oyer
	lpK64DwcHt2Q4RxteiI+uUmRqOj2eZh4Z45nRTysHV7tPnvWzLcaD7dFVVttcu01
	b+fqwS7B9cJxkkRl8bVbvlX3xCfPcPhSeENSBtczoDrZobjZkJ0YUsD5mcwbqSkf
	Lw0VV7Xj5OE599QRkzThQFmfMMzlOuF4diW4NzR42/R9iqThgscK2svTplNE4E5G
	g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id AAX21mbctsyu; Mon, 11 Aug 2025 17:40:39 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c123N4CdrzlgqTq;
	Mon, 11 Aug 2025 17:40:31 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	"ping.gao" <ping.gao@samsung.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v2 21/30] ufs: core: Make ufshcd_mcq_init() independent of hba->nutrs
Date: Mon, 11 Aug 2025 10:34:33 -0700
Message-ID: <20250811173634.514041-22-bvanassche@acm.org>
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

Prepare for modifying hba->nutrs after ufshcd_mcq_init() has been called.
No functionality has been changed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-mcq.c | 1 -
 drivers/ufs/core/ufshcd.c  | 5 ++++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index a44ab6c010d8..6a1838ced02e 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -477,7 +477,6 @@ int ufshcd_mcq_init(struct ufs_hba *hba)
=20
 	for (i =3D 0; i < hba->nr_hw_queues; i++) {
 		hwq =3D &hba->uhq[i];
-		hwq->max_entries =3D hba->nutrs + 1;
 		spin_lock_init(&hwq->sq_lock);
 		spin_lock_init(&hwq->cq_lock);
 		mutex_init(&hwq->sq_mutex);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 82d804dd0c85..27140432d737 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8872,8 +8872,8 @@ static void ufshcd_memory_free(struct ufs_hba *hba)
=20
 static int ufshcd_alloc_mcq(struct ufs_hba *hba, int ufs_dev_qd)
 {
-	int ret;
 	int old_nutrs =3D hba->nutrs;
+	int i, ret;
=20
 	ret =3D ufshcd_mcq_decide_queue_depth(hba, ufs_dev_qd);
 	if (ret < 0)
@@ -8891,6 +8891,9 @@ static int ufshcd_alloc_mcq(struct ufs_hba *hba, in=
t ufs_dev_qd)
 			goto err;
 	}
=20
+	for (i =3D 0; i < hba->nr_hw_queues; i++)
+		hba->uhq[i].max_entries =3D hba->nutrs + 1;
+
 	/*
 	 * Previously allocated memory for nutrs may not be enough in MCQ mode.
 	 * Number of supported tags in MCQ mode may be larger than SDB mode.
