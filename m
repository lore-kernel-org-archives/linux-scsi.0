Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4B72E62BF
	for <linux-scsi@vger.kernel.org>; Thu,  3 Apr 2025 21:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743715236; cv=none; b=oayom87nw+OLAICwKJOOcw8hL8NNZiKTY7w5Zt8uDU7/Qq0vvvqjrCPE+o+oAVMPcOPjZcZ2hfoGccR+VfH+O9fvi7mMxxXoMVhtr5M5Z1WfHgFLhqbfA0HtTttJELbyLm15GjADiJCOAosqY4nveBI9fkASyrS0tjFCnqjwgm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743715236; c=relaxed/simple;
	bh=D1oYvdSS3vWEsGDMRNU7CesR0gufUfF6/KHQifh6r5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UFiSR4SU4myGcVeEuSRpoO+aeFfUKATCo7wDtPsDYXh9EUUB+v5qu4tgaaoJPstAl+fR+j5wGZEE/KaxJeHTCCCuPQoS4EgcQw1k2c2BtKtmSbBV6m2FVFoZlAfvEY21efbrp/6j7/TzA+wFBpZif/drqAujmEu8RBNPkmeYMrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=vp40vjeb; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="vp40vjeb"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZTF5G0fc2zm0yV3;
	Thu,  3 Apr 2025 21:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1743715232; x=1746307233; bh=ASITi
	mpvXpJNtaITIDhV0SD4xzhbY9rDjZmUuBjbjYM=; b=vp40vjebmn4QK5I2zwg06
	YOAYUTTQi3+HNK58ES9d3hUgi6WTM701takvU1RozkzhZ8iOE3TYbxuuXrdWgvob
	TwvOlpxujQ6vhoZrvx8SecSnNk95f8RudFHm+J8SeBSV68xEG/pQNMGbzb/X2sTI
	gtnSCkMHRZJdUY7gVI+B7kdYoTsKsEaf2KuAADEED1fVkY8AuB34IHpA0EawlAb6
	1W6ASfxjDDoMfhvnoQkcG6kgH1ttIPyk31qcL3vqKrA1naNjTU0fFv/9iqwb8moO
	v+ZhBJFW9lrda9OOCv69XO9pTkCiilSerhhNjdQ9CFNTSZkn8diS7EYouo1AskTs
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id iYei7ENTolLk; Thu,  3 Apr 2025 21:20:32 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZTF54190bzm0yVH;
	Thu,  3 Apr 2025 21:20:22 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH 06/24] scsi: ufs: core: Change the type of one ufshcd_add_cmd_upiu_trace() argument
Date: Thu,  3 Apr 2025 14:17:50 -0700
Message-ID: <20250403211937.2225615-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
In-Reply-To: <20250403211937.2225615-1-bvanassche@acm.org>
References: <20250403211937.2225615-1-bvanassche@acm.org>
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

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c4448b94092f..3b470f564313 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -355,10 +355,11 @@ static void ufshcd_configure_wb(struct ufs_hba *hba=
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
@@ -367,7 +368,7 @@ static void ufshcd_add_cmd_upiu_trace(struct ufs_hba =
*hba, unsigned int tag,
 	if (str_t =3D=3D UFS_CMD_SEND)
 		header =3D &rq->header;
 	else
-		header =3D &hba->lrb[tag].ucd_rsp_ptr->header;
+		header =3D &lrb->ucd_rsp_ptr->header;
=20
 	trace_ufshcd_upiu(hba, str_t, header, &rq->sc.cdb,
 			  UFS_TSF_CDB);
@@ -441,7 +442,7 @@ static void ufshcd_add_command_trace(struct ufs_hba *=
hba, unsigned int tag,
 		return;
=20
 	/* trace UPIU also */
-	ufshcd_add_cmd_upiu_trace(hba, tag, str_t);
+	ufshcd_add_cmd_upiu_trace(hba, lrbp, str_t);
 	if (!trace_ufshcd_command_enabled())
 		return;
=20
