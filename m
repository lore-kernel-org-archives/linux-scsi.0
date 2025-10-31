Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A3B324B2B
	for <linux-scsi@vger.kernel.org>; Fri, 31 Oct 2025 20:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761943303; cv=none; b=aATBMxCf/0eIaLp93BsHKNZH1tfGrucVNR2xFogqXi2PHbsXmTTTPItOlnkhvnsZKIA1WDnmRRbHQEGn5EbXKzjOyJvAs59xbg1tLWd+HaPAK2Tj3v5AGp45mbXJdiawozJO84XQmIUXd4GaXPACzJqXFgUyFO6NXUKzckpZlU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761943303; c=relaxed/simple;
	bh=/UbaNQjCO3dFtXTPdHO3j7YAY4cmuNb/b4CK20CFyLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=duXjub1UtpE6gP3Yu8s/+h9Oh2b+dZbA2sPwIGmJVRhidsiaeeJwEYymanH0tRV5aPIqKFojvo+Il4yCI4n6hQB1Qhce4lZgkYjPB72Pr95NG2Hz1p8BW/wEeruSpi65x44lbhC2/8NMhABRt6pLqU0b1JeQFwAuS29xUmwQX2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2bKrOZKP; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2bKrOZKP"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cytF05yxTzm0pKc;
	Fri, 31 Oct 2025 20:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1761943299; x=1764535300; bh=9SB1c
	kJ5KRgq6tZOQ6SuJa+1dgAzArxMcBkmA3FMPmQ=; b=2bKrOZKPHZ6kLeM9rrSZz
	tYQ8/v84vv4o/hVZFXIvhNbkCLIM3cpxt65MKlQHR7aevQeZXXQYCnTQO5avwxfM
	SDuZtvrbq56yiW0Fs1kuV1ZRiKo3t987w9ddzg3Ol9fwWktx225xizWs9BJY5sHw
	iZzyprQFcgQTvrFpcYBbT9OK5SFvXJzredluOeDQT6ZU89ec8/akdQmrnKCPOfYb
	fP/H0sAOqRKKuoyxkpi0l+ZLWDtfNp3jky88kWF8SIu7uTTbk/2qpQZ5LS5LCYvJ
	qAdvW+kpOrUfYF02GUXaTvqIrrpLJgLBx9Xwh2Es+AMwoTknjadfCClTYkW4euHG
	g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id GJgRLBlxvRK5; Fri, 31 Oct 2025 20:41:39 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cytDp5pGWzm0pKv;
	Fri, 31 Oct 2025 20:41:29 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v8 09/28] ufs: core: Change the type of one ufshcd_add_cmd_upiu_trace() argument
Date: Fri, 31 Oct 2025 13:39:17 -0700
Message-ID: <20251031204029.2883185-10-bvanassche@acm.org>
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
index fc4d1b6576dc..cdb8147fceb9 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -403,10 +403,11 @@ static void ufshcd_configure_wb(struct ufs_hba *hba=
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
@@ -415,7 +416,7 @@ static void ufshcd_add_cmd_upiu_trace(struct ufs_hba =
*hba, unsigned int tag,
 	if (str_t =3D=3D UFS_CMD_SEND)
 		header =3D &rq->header;
 	else
-		header =3D &hba->lrb[tag].ucd_rsp_ptr->header;
+		header =3D &lrb->ucd_rsp_ptr->header;
=20
 	trace_ufshcd_upiu(hba, str_t, header, &rq->sc.cdb,
 			  UFS_TSF_CDB);
@@ -489,7 +490,7 @@ static void ufshcd_add_command_trace(struct ufs_hba *=
hba, unsigned int tag,
 		return;
=20
 	/* trace UPIU also */
-	ufshcd_add_cmd_upiu_trace(hba, tag, str_t);
+	ufshcd_add_cmd_upiu_trace(hba, lrbp, str_t);
 	if (!trace_ufshcd_command_enabled())
 		return;
=20
