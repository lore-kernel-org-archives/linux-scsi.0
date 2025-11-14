Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6B92F0689
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2025 19:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763148871; cv=none; b=pGKhnKnBCL0aq5zVmWzqn4mfWPyUAmIL0qViTVsu2T7v5F4M1GbgIGdEVFSe2RVOBqff1hnlgf+x8/56coqaxNrxd2Ib9NyoYj6qMpk66guKZURRZRNz7VgEB+1xPzsfj38A4DGAexzWUEXtoHLaWLn60e9zGNgagwruQunze9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763148871; c=relaxed/simple;
	bh=V/2yzl6EKa8k9T10BRJVopvUf4c9UpzbBvqF5Bxf+uY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XC+I5gs8T0cTlTLnTpaiBlakQWHT4l8RVS72sO2VtJomF5wlu+2Asu80aOSDNDypcZ23zFkhmzL+NXrhVoNxarjZ/GqlN4DgCezyvArvJ7HQFx0wGodEyLHsUMl0TRPNCFlb7cX+LDiqRoVHGFutit29o0O0pAw+DLOjlNoTsvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Bq1jkG73; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Bq1jkG73"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4d7S503kkrzm1DtP;
	Fri, 14 Nov 2025 19:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:mime-version
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1763148866; x=1765740867; bh=l0Y+A
	xfDak9wJqQ1bcd4K2guuU0aQ+GvtZ1thEsmGQE=; b=Bq1jkG730izzHe/FHJMOp
	pI9HUvjU60yPM4RliMk6MDW2WtzBrrw2KuBa5Tg4FQUPrvniiGScQU/usDxLQLi9
	ASXVz1J1tj7/v2f88JE7ah+rP6Z9hS6DdZsWvmlsxvV2tVl5TAlRU1C74A1ILm/d
	KMwC7eC1Dj7U8DN1wukAp+Zg8Z2K+8+7GwYunjGA6fzEmIVmTH7StCq41Km4flWp
	oRIL9Ok9z7CuwKUjXgDwjcSKOF4bARC1EYMsKW2oyb7LtUduSaR35+5NroFD208M
	OUuAq0mL+0p6gOofV9O2CmxRmzbGUNqi6xj5ujkxnRu3BOb1DtmQo8UUgLo4pr/l
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id HT6h11NraMyx; Fri, 14 Nov 2025 19:34:26 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4d7S4p0YR9zm2LcM;
	Fri, 14 Nov 2025 19:34:17 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Ziqi Chen <quic_ziqichen@quicinc.com>,
	Can Guo <quic_cang@quicinc.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH] ufs: core: Fix single doorbell mode support
Date: Fri, 14 Nov 2025 11:34:03 -0800
Message-ID: <20251114193406.3097237-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Commit 22089c218037 ("scsi: ufs: core: Optimize the hot path")
accidentally broke support for the legacy single doorbell mode.
The tag_set.shared_tags pointer is only !=3D NULL if shared tag support i=
s
enabled. The UFS driver only enables shared tag support in MCQ mode.

Fix this by handling legacy and MCQ modes differently in
ufshcd_tag_to_cmd().

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Closes: https://lore.kernel.org/linux-scsi/c988a6dd-588d-4dbc-ab83-bbee17=
f2a686@samsung.com/
Reported-by: Andr=C3=A9 Draszik <andre.draszik@linaro.org>
Closes: https://lore.kernel.org/linux-scsi/83ffbceb9e66b2a3b6096231551d96=
9034ed8a74.camel@linaro.org/
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Fixes: 22089c218037 ("scsi: ufs: core: Optimize the hot path")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd-priv.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-pri=
v.h
index 2f752a45db87..676ebb02db8b 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -368,7 +368,12 @@ static inline bool ufs_is_valid_unit_desc_lun(struct=
 ufs_dev_info *dev_info, u8
  */
 static inline struct scsi_cmnd *ufshcd_tag_to_cmd(struct ufs_hba *hba, u=
32 tag)
 {
-	struct blk_mq_tags *tags =3D hba->host->tag_set.shared_tags;
+	/*
+	 * Host-wide tags are enabled in MCQ mode only. See also the
+	 * host->host_tagset assignment in ufs-mcq.c.
+	 */
+	struct blk_mq_tags *tags =3D hba->host->tag_set.shared_tags ?:
+					   hba->host->tag_set.tags[0];
 	struct request *rq =3D blk_mq_tag_to_rq(tags, tag);
=20
 	if (WARN_ON_ONCE(!rq))
