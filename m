Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FB532A809
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 20:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758745969; cv=none; b=HeJ40+e4eQup0BvxWoGGtiFY0x+s9BdtvolK4KdAQzBgxAJaKXkWaMq8Dg+e+TQSbU1NlfYQ+MLypeRuceru5xXwy1PyHZgDAGDEKCM0DdI/k1/0ylim8GhKdKqvn9HJfr4uY7PkfIfRhs8DtdJfZ+6ni6zh87FGguAHRLXfono=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758745969; c=relaxed/simple;
	bh=KaiHorPoPtbtnNsEf7Ovyp6Wo6AKoJPpdgrV6b/hhX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fedZpCgj00dj/kVNSrfW6vWh0bsU52AUAhSbgTcTTezF0bLTVcGsI2EcYndCw5dTKyla/tGP0frsXXgrMr1m3cndtMFMgwZtVV0LfohepS3WFLcaT2DL5KHYe7yPXaAdpgwL5U0KZuxlyqAKsEvSpDlGt8A5DAqUz82V/33AcBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=fId7ZuAt; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="fId7ZuAt"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cX7np5XYzzlgqyg;
	Wed, 24 Sep 2025 20:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1758745964; x=1761337965; bh=VguU2
	ijypgVhM70tTusF2MKhwweeU1dvuAv9ct541FA=; b=fId7ZuAtOkKPpvzdDlpwc
	7ihAPROTL1DvH3InBacs7JmuQ+laAFVKyy7aXE9oqxKMCP1yxQTi+6oHatxjPuT9
	KnRcDBCi4RV0Lv3ghB/FZvnVtox/Dgb8jqqey5itsrh/tA8jedQPYHzYpgsAkoKZ
	gF744RnGy6/cCMpGfKql4GcbbpKzE2yv5NagmJzUq+4EH3d3IGY41rnTgHTOYRvq
	fL9hbr6UCISnb9u2UudSAnWm0P7VmT8pQAd/FnmeGe/6tFZyuXJJikP+8PdCM9Ny
	triiJpxmoXCCEjGXrOdIBCTAwco6OpV6T3xEIqRcEELhr+9EQE3B4uao+7iZIp7J
	A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Gn0eWDZPCDwy; Wed, 24 Sep 2025 20:32:44 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cX7ng2pkpzlgqyG;
	Wed, 24 Sep 2025 20:32:38 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v5 09/28] ufs: core: Change the type of one ufshcd_add_cmd_upiu_trace() argument
Date: Wed, 24 Sep 2025 13:30:28 -0700
Message-ID: <20250924203142.4073403-10-bvanassche@acm.org>
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

Change the 'tag' argument into an LRB pointer. This patch prepares for th=
e
removal of the hba->lrb[] array.

Reviewed-by: Avri Altman <avri.altman@sandisk.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index cfc149f8238e..fa3d5a0a7db7 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -408,10 +408,11 @@ static void ufshcd_configure_wb(struct ufs_hba *hba=
)
 		ufshcd_wb_toggle_buf_flush(hba, true);
 }
=20
-static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned int =
tag,
+static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba,
+				      struct ufshcd_lrb *lrb,
 				      enum ufs_trace_str_t str_t)
 {
-	struct utp_upiu_req *rq =3D hba->lrb[tag].ucd_req_ptr;
+	struct utp_upiu_req *rq =3D lrb->ucd_req_ptr;
 	struct utp_upiu_header *header;
=20
 	if (!trace_ufshcd_upiu_enabled())
@@ -420,7 +421,7 @@ static void ufshcd_add_cmd_upiu_trace(struct ufs_hba =
*hba, unsigned int tag,
 	if (str_t =3D=3D UFS_CMD_SEND)
 		header =3D &rq->header;
 	else
-		header =3D &hba->lrb[tag].ucd_rsp_ptr->header;
+		header =3D &lrb->ucd_rsp_ptr->header;
=20
 	trace_ufshcd_upiu(hba, str_t, header, &rq->sc.cdb,
 			  UFS_TSF_CDB);
@@ -494,7 +495,7 @@ static void ufshcd_add_command_trace(struct ufs_hba *=
hba, unsigned int tag,
 		return;
=20
 	/* trace UPIU also */
-	ufshcd_add_cmd_upiu_trace(hba, tag, str_t);
+	ufshcd_add_cmd_upiu_trace(hba, lrbp, str_t);
 	if (!trace_ufshcd_command_enabled())
 		return;
=20
