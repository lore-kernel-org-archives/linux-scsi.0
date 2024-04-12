Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCD428E7
	for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2024 00:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712880189; cv=none; b=DpqDCOPhpPRfhCN2zEdUrrvHW721GsLKzeJaIjOGLxdhUWA+hkX30ab8QiLh2ASBD9tLZ7D8v5cgGXpx4AcaUfdRRSH13w46+RzeXoFj0vOWU9jqcS57hPoAZt/BVnu6rs7CNVwxy5cTxbMxhnGYJgSJb9P1lwRsV4cBwKGgQ3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712880189; c=relaxed/simple;
	bh=tVSFqs4M+dZdosEXmcx7d0wioApvxbkm4QJMEGyKg7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DofrCZA2w3PC6wb7ON5Rfnl5OTXZuEoVHAPojuOP5GM6rT0ZXwPecQH1Fnbl29s9RmB+bSKhs4rrobS8a5XJs4rCXbb9YDSbJCcAMIK8d11/Lf5G5Bo9f9MLjQKppN/ie2ROkhgiSas24ZtoX1ApqwQxplO66/jZwZOZQk0LBU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=dq4pPuMw; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="dq4pPuMw"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VFxbb4JRcz6Cnk8m;
	Fri, 12 Apr 2024 00:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1712880183; x=1715472184; bh=pVq15
	uAKoGgM8Aqrh+JwHv5Y1sBgqhp+mELSsza3CB8=; b=dq4pPuMwjllyfFH+bdV9b
	HIlTq/pxPwKMZk4NNic2hgCI7A8otI1IuXsx48F7+YLCixSWndHiGpjLue00SKBr
	qM9mF3O9Qk336Ef/MZI79kjD1nOcTrjD0hW3mwtnGmvmg5u8S8s8jeGtjHmRzSgp
	jelmdYBBllqmVdNHpFHKZWkvTRCwz/8iz1EZRgyrPh3rzfdamTLiiVuYIHF/4qEt
	juTU7T9o1GVFKosOrK3urO+zHn2OHTNAuveGZz34PEnoMT6hxNkw+6XWYXsXEj2T
	N8vtoqyzZLa6qxRHjBDuedNnTltHvKeSTTZXxThZmtpPfwUn3ibFAro70u9EYGEQ
	g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id XO5xLE3P75XW; Fri, 12 Apr 2024 00:03:03 +0000 (UTC)
Received: from bvanassche-glaptop2.roam.corp.google.com (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VFxbT6pVSz6Cnk8t;
	Fri, 12 Apr 2024 00:03:01 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	Avri Altman <avri.altman@wdc.com>,
	Can Guo <quic_cang@quicinc.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Bean Huo <beanhuo@micron.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 2/4] scsi: ufs: Make ufshcd_poll() complain about unsupported arguments
Date: Thu, 11 Apr 2024 17:02:22 -0700
Message-ID: <20240412000246.1167600-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
In-Reply-To: <20240412000246.1167600-1-bvanassche@acm.org>
References: <20240412000246.1167600-1-bvanassche@acm.org>
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
index 62c8575f2c67..66198eee51b0 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5617,6 +5617,7 @@ static int ufshcd_poll(struct Scsi_Host *shost, uns=
igned int queue_num)
 	struct ufs_hw_queue *hwq;
=20
 	if (is_mcq_enabled(hba)) {
+		WARN_ON_ONCE(queue_num =3D=3D UFSHCD_POLL_FROM_INTERRUPT_CONTEXT);
 		hwq =3D &hba->uhq[queue_num];
=20
 		return ufshcd_mcq_poll_cqe_lock(hba, hwq);
