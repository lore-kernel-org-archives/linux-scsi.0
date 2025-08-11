Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75B4311C16
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 17:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754933902; cv=none; b=BO4gJqcwoO00G5kd3F+GPusyZHc/3mbeWhyxahph4Oz8a6tWUR+PsKOwTHGaVrfNWiDuIYCwz0BeNx70Xb5O0DWEQtLRHdYUDwJ3j4NrM8hi8WDDgSx7dhl4EE+Tiop0KHRYaegZwHj6bhb2qpejCqrGkJkX5Wk3zIvGNd1RpPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754933902; c=relaxed/simple;
	bh=tavIclgMo993TNg9riBclpXlpjppsQV+KdsJg/7qcJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHSfp1JU3+kFhqDPghpHrR9LChTJPyaYrjMt3FYE7vk6YCBqCRPT5VrURiFG4KaEZLbfWtNoMYhWt4mkNkyMlkxYIHYx041lD6DY3jh2LOwF/Mad3w5x1nGxsLAyOE8D57Ko8/5Gn88MHQg74miNnZNYjYCZbJqQT1HjlzNsNP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=PrLzPXQq; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="PrLzPXQq"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c120r1Qp6zlsxDx;
	Mon, 11 Aug 2025 17:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1754933898; x=1757525899; bh=5KCOT
	5puDX091LDhDN75DWzNcUpeKa+bIOwZJmH0GaU=; b=PrLzPXQqLrOefftGaiZb6
	d+ONIntM51HHqLKLYdHBxcmOhW5ps/WkAUA0t9+FfawTci1YoGlKVWBcMcqSdbaq
	NAy6W24Df6bgAcHKKEtwKRM650dFJacYzoFPWzvfhJ8+5eTP+EpQLor2LJnBVbpT
	4JjHnTYT0ZM8/G+we/a4A5bWBqHl533bfYTxea2Yuaj/wEqJZGqcsEeghwCX1282
	E1iZwx7tWZtnJdi4+82PFFF163yzSS2FsLIych3EuGzvZGwf9Zqi5XXvH+riuJND
	XI39CoqSs5n9L1f9RjSKt7Vj9A8BcsNMKrCYez+TgJhfvGk66+/Tl0IpAxL4iREU
	g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Y6mhNb5r0bMK; Mon, 11 Aug 2025 17:38:18 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c120h2LCWzlgqVH;
	Mon, 11 Aug 2025 17:38:10 +0000 (UTC)
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
Subject: [PATCH v2 08/30] ufs: core: Change the type of one ufshcd_add_cmd_upiu_trace() argument
Date: Mon, 11 Aug 2025 10:34:20 -0700
Message-ID: <20250811173634.514041-9-bvanassche@acm.org>
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
index b5057ce27aa9..fee144f36c4a 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -405,10 +405,11 @@ static void ufshcd_configure_wb(struct ufs_hba *hba=
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
@@ -417,7 +418,7 @@ static void ufshcd_add_cmd_upiu_trace(struct ufs_hba =
*hba, unsigned int tag,
 	if (str_t =3D=3D UFS_CMD_SEND)
 		header =3D &rq->header;
 	else
-		header =3D &hba->lrb[tag].ucd_rsp_ptr->header;
+		header =3D &lrb->ucd_rsp_ptr->header;
=20
 	trace_ufshcd_upiu(hba, str_t, header, &rq->sc.cdb,
 			  UFS_TSF_CDB);
@@ -491,7 +492,7 @@ static void ufshcd_add_command_trace(struct ufs_hba *=
hba, unsigned int tag,
 		return;
=20
 	/* trace UPIU also */
-	ufshcd_add_cmd_upiu_trace(hba, tag, str_t);
+	ufshcd_add_cmd_upiu_trace(hba, lrbp, str_t);
 	if (!trace_ufshcd_command_enabled())
 		return;
=20
