Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BEE6303C87
	for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 17:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755105073; cv=none; b=Q4zSvv+MURmmN/MzUofOcZNtHPQKkHuXS4qlGHfIi//XdEUE6piEN/QTBdTzl1UzO2LeNIY7IAZ+yCPSFJV39R6r7BL/B4qvRj88j1Giw1eFA08AwhjEtK7rjZRSqOFOird78AkkuEwCEud1O7vxKULTY4Aq1Ol29xvbh7NBnB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755105073; c=relaxed/simple;
	bh=boO7ZDd3fcmEsW9fX3PKV6hzuYiMkvyY7qzLgX2AyfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YdnMn88P0S96//LIqC6Bm6DVISrS3oT/nMU9PQCkeB2iZC4g93hp5YSg0WLj0kOvBZL+VhuNeOMlKZK+WSKstiCltI2a+wBvChmBgz1GXlLM8Hp0ldGxrEXRIRRpQ4Dpe9Basn2isXK7iqGHgOXZG+tPSe9KxAcqqDNDFbxXSzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ljU4hAw0; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ljU4hAw0"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c2FJb0fQtzlfnBh;
	Wed, 13 Aug 2025 17:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1755105069; x=1757697070; bh=k2orm+3JzanzWs9O6muAGRMF8kMFRKD7g03
	HTh7Xe5w=; b=ljU4hAw0W2zdLt9g3Tibv3pp825C47ZFREB6mVUVgUroJFoVUFS
	hQ44LC5E/CJQ4kgdLoxGFHRWMKvtn+xpRLTUxzw0ot3EdAGshgaKL6kKi28qWvAx
	zGRrrfdg1vAaPit3sEgGL5SO1lyt6emw6y/kV/l6v311s8JIJuTmi+gQhyiX5q97
	GpcrdAbv4rh0GVb+v+YPTwYhspqp0szA8c8e9A+Ggk4MgiJ3TfWHCn1Gs0LH77yk
	RYyIFy+CyJoUz3hMQpc4uqF1J0y18ywuJ419a6cE0QnZq7whJFH0p7KYeg2B3sTr
	jSWhcg1mNS5YBkzK4e3D5w/q2QyJ8zyeglA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id WT7t_csPzmwT; Wed, 13 Aug 2025 17:11:09 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c2FJQ02zjzltH6Q;
	Wed, 13 Aug 2025 17:11:01 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH] ufs: core: Improve IOPS
Date: Wed, 13 Aug 2025 10:10:41 -0700
Message-ID: <20250813171049.3399387-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Measurements have shown that IOPS improve by 2% - 3% on my UFS 4 test
setup every time a ktime_get() call is removed from the UFS driver
command processing path. Hence this patch that modifies
ufshcd_clk_scaling_start_busy() such that ktime_get() is only called
if the returned value will be used.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index b20f262fc8e4..9579e2481062 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2231,11 +2231,13 @@ static void ufshcd_exit_clk_gating(struct ufs_hba=
 *hba)
 static void ufshcd_clk_scaling_start_busy(struct ufs_hba *hba)
 {
 	bool queue_resume_work =3D false;
-	ktime_t curr_t =3D ktime_get();
+	ktime_t curr_t;
=20
 	if (!ufshcd_is_clkscaling_supported(hba))
 		return;
=20
+	curr_t =3D ktime_get();
+
 	guard(spinlock_irqsave)(&hba->clk_scaling.lock);
=20
 	if (!hba->clk_scaling.active_reqs++)
