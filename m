Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C62A933
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 21:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724362644; cv=none; b=JVyQIG2xvBWGbJh4zs63KtitaIQIfIYzw09rS0SWebCD4MPMqObKZVzoy4kMW7WSGBFk8JirEuu8MjeTQmXJ6PD3sFG3VamV07mdTft91iywowGl7/qD0D3uvbqS747aZ9cXga3eQYthC3VDxJqcBj2Oa1Kn5bELz+JAsDnHg7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724362644; c=relaxed/simple;
	bh=j4pdLL9Yw9DBsT5fmbg29U+agDA9fFtG4Lgqwkpbg3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V4o6wd+/mSSjtRcgZGMWYqi81Sto1TIRHCtnFPjqQR6pLw1I8JTJOsYNUyHKOWobZnqv/D2TjParUXTcbZ33AZYshCCTuk+hLSh+1sHqyPMqpw5AT/n1NQ69E+fnpt9cfRpFZMtDf42pY++Wt47Vk7iJ8QjUdCs0ppfblgxNkUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pfO0MU3M; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pfO0MU3M"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Wqc426ML6zlgVnK;
	Thu, 22 Aug 2024 21:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724362639; x=1726954640; bh=0YazD
	5+p7Rwln0to7DqY+9rbQQ4jYV+1W1F/00+9VIw=; b=pfO0MU3MJwMeLFX0qn1X4
	UpN8T9Ozd0BJllVusg9VpfF70UzJZeKfpcCeH0114FuT2rTh9oNeRLig9cPIfSCG
	wGgTseudbCrpEu4rU+naBzZYHyy66y8ZOfOkhvh+O/LwFgIbKfBifE6vXYgxe2G/
	xXohPNwJIek61CbR77iqycIMhDqUSoTnOZqNnpPBajHdB0usJtjTEHzEAqJUtx9q
	mLLDQEXegWxjoA5O2PwkMt/eCxsJT7rFTwtClKut7CdXI5M59ylH9ofJVyrcV3ww
	gxEoSlVxia8iFRodsr3f1DEx+rYeRnKj+z/7dsCKYx2g4NAdxL3OJQJG6v0NKsEK
	A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Wo0umtqhwJdQ; Thu, 22 Aug 2024 21:37:19 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Wqc3y4xmZzlgVnf;
	Thu, 22 Aug 2024 21:37:18 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v2 6/9] ufs: core: Move the ufshcd_device_init(hba, true) call
Date: Thu, 22 Aug 2024 14:36:07 -0700
Message-ID: <20240822213645.1125016-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
In-Reply-To: <20240822213645.1125016-1-bvanassche@acm.org>
References: <20240822213645.1125016-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Move the ufshcd_device_init(hba, true) call from ufshcd_async_scan()
into ufshcd_init(). This patch prepares for moving both scsi_add_host()
calls into ufshcd_add_scsi_host(). Calling ufshcd_device_init() from
ufshcd_init() without holding hba->host_sem is safe because
hba->host_sem serializes core code with sysfs callback code and because
the ufshcd_device_init() is moved before the scsi_add_host() call.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 5c8751672bc7..0fdf19889191 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8933,10 +8933,7 @@ static void ufshcd_async_scan(void *data, async_co=
okie_t cookie)
 	int ret;
=20
 	down(&hba->host_sem);
-	/* Initialize hba, detect and initialize UFS device */
-	ret =3D ufshcd_device_init(hba, /*init_dev_params=3D*/true);
-	if (ret =3D=3D 0)
-		ret =3D ufshcd_probe_hba(hba);
+	ret =3D ufshcd_probe_hba(hba);
 	up(&hba->host_sem);
 	if (ret)
 		goto out;
@@ -10632,6 +10629,11 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
 	 */
 	ufshcd_set_ufs_dev_active(hba);
=20
+	/* Initialize hba, detect and initialize UFS device */
+	err =3D ufshcd_device_init(hba, /*init_dev_params=3D*/true);
+	if (err)
+		goto out_disable;
+
 	err =3D ufshcd_add_scsi_host(hba);
 	if (err)
 		goto out_disable;
