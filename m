Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F28B1990AA
	for <linux-scsi@vger.kernel.org>; Mon, 17 Jun 2024 21:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718658584; cv=none; b=X73uAN8f+hggFp9xsGjSYB/wgEASt5QNdkhwUIkWN57t7zUDFr0mPI0OLx1KY+R6sY3uwiOJv7Xplcr6EjZrg7D9+xzoka5ruLtG2DQd6e8f5MFtERD4hy6dd+a4cfQOO5PT6SMVKr3PWXvDWMbV86Ao5JV3cD/YO2waCsM54vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718658584; c=relaxed/simple;
	bh=xgJj6t3fBWpmlB3hDcPD1m1ugdyL8Tpx1obBtHTQ+i4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L3CC46r+5zKcuCt3krAfhAlor3BT1BviAAR65UGDVvHdItB8oQocX3A6cDlmCPfLVYv155CiTQcFkvv+cpCY9cwykPAYRxL8TW+UejZKl0PJWWFwaLAcngOoP+uAXojZU8OO/zQyBYtJTfupXMe97aN6L2cGi6+7ov7PPCs7700=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=gmOf8J40; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="gmOf8J40"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4W32ZZ4Dm4z6Cnk8y;
	Mon, 17 Jun 2024 21:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1718658579; x=1721250580; bh=huP5g
	gTZKKqUkyhGa5Wjm6aKhUkPbI0naNf9IfumIbg=; b=gmOf8J40433ZjAT/fesDB
	yt4HhMQv5ux+kxvbEllWBoAdTdXFd9Beem8GWRUit4z1ZrIZSqywFyn/RiKYDyfG
	lqx3/nq3/KkJUc0vTE/B11FU0vwWmG3uA22RZ9szsC2FqXxwpQ93P93/3dHtMPFp
	y1rJxtzRVXkM4+keKECKMaLu2o5d4Ki1udJRP8WO5DBt1c/7ylQc9RT8RpsY/khm
	wClKTtVkM0QQfepl1306yyBaKPreDiExrPg4EOL4sdRXy3Ofay91CbM/C5f4NSvX
	PlBm6u0K0JvvZwFs8w2eVNdKA+dHYPIAkFaLw2U8viF/0qtOud6ecmdJ21DhSVH8
	Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id UWbARFDW8CAr; Mon, 17 Jun 2024 21:09:39 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4W32ZV4ncYz6Cnk95;
	Mon, 17 Jun 2024 21:09:38 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Avri Altman <avri.altman@wdc.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bean Huo <beanhuo@micron.com>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH 6/8] scsi: ufs: Make ufshcd_poll() complain about unsupported arguments
Date: Mon, 17 Jun 2024 14:07:45 -0700
Message-ID: <20240617210844.337476-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.627.g7a2c4fd464-goog
In-Reply-To: <20240617210844.337476-1-bvanassche@acm.org>
References: <20240617210844.337476-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The ufshcd_poll() implementation does not support queue_num =3D=3D
UFSHCD_POLL_FROM_INTERRUPT_CONTEXT in MCQ mode. Hence complain
if queue_num =3D=3D UFSHCD_POLL_FROM_INTERRUPT_CONTEXT in MCQ mode.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 7761ccca2115..db374a788140 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5562,6 +5562,7 @@ static int ufshcd_poll(struct Scsi_Host *shost, uns=
igned int queue_num)
 	struct ufs_hw_queue *hwq;
=20
 	if (is_mcq_enabled(hba)) {
+		WARN_ON_ONCE(queue_num =3D=3D UFSHCD_POLL_FROM_INTERRUPT_CONTEXT);
 		hwq =3D &hba->uhq[queue_num];
=20
 		return ufshcd_mcq_poll_cqe_lock(hba, hwq);
