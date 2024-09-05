Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0C715532A
	for <linux-scsi@vger.kernel.org>; Thu,  5 Sep 2024 22:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725573775; cv=none; b=lELp7lR+SUELsejdv/B0pxzashrb13ln9sU8EpSIHpEFaNEDJx26RQdwkmpDcHBmRdXyOCqOK/koId9uqEvSoz+GpnOTjPrSrUuryO4M7C01xYqR361KhVV5AhbKLyfHNOHSjK+x5rfgt8GhtvvFGBNEb7Lgr8ngbJCviTdQvbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725573775; c=relaxed/simple;
	bh=lJLyFb/Ul7zIMEsfZ77b26BRegm9VVp/upjwjQk3K2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QIxh3spgz2Ek5QWHAl1ZGe9kWn63dZrw1uhqWOdRVAcWoFHTWvw5tAXBY/b5tJeqPSO2JeT7w/4axFxfPNejvbcWH+MOUCjbNJ4X1BgTHY3yuEDENobD09NdUv1eZ2BGM3DOc3J55S8iiM8R8+0GHte64ym0ProIC61Hr3gSS5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=hF7+jVMD; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="hF7+jVMD"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X0Cz11Kndz6ClY8w;
	Thu,  5 Sep 2024 22:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1725573769; x=1728165770; bh=zELt5
	g5uvvRisZ9et/+0oyEiHnto9XLPei+vOKt6r7w=; b=hF7+jVMDlqFSjaitUJ8sS
	FPeD6zsfFp04a8I9Bc0Q9vdwJ05+JiaXMLVBO+A7fcw6iBO+T+U2l3PSixXZXoAV
	SoswlWLrEqbdf4khlkofssDzRG4b3zE4zawTtpCAx4AOWbkvi8oaWEjWexm1lGax
	eQj33J8y6ODgOgzCtLMt8+7a22UmAqMNouUW5+P/nYjpC5VxgYRA7QDLmiT0twwv
	5pyX7HdNN9qOKepeI7y33NBWmxOxOUtakDJbYxCucIIFLXt/mP8lWss059m4JAbk
	PvjKhYghS8QtniRxsEix/FHKtvVpXVa6xu5jSJ8Lt6VxRi/SeUOsk/vHjzR/RP36
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id qUSBhOzOntAG; Thu,  5 Sep 2024 22:02:49 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X0Cyw3dw7z6Cnk98;
	Thu,  5 Sep 2024 22:02:48 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v4 06/10] scsi: ufs: core: Move the ufshcd_device_init(hba, true) call
Date: Thu,  5 Sep 2024 15:01:32 -0700
Message-ID: <20240905220214.738506-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
In-Reply-To: <20240905220214.738506-1-bvanassche@acm.org>
References: <20240905220214.738506-1-bvanassche@acm.org>
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
ufshcd_init() without holding hba->host_sem is safe. This is safe because
hba->host_sem serializes core code and sysfs callbacks. The
ufshcd_device_init() call is moved before the scsi_add_host() call and
hence happens before any SCSI sysfs attributes are created.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 6e3cffcdf9a6..843566720afa 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8908,10 +8908,7 @@ static void ufshcd_async_scan(void *data, async_co=
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
@@ -10605,6 +10602,10 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
 	 */
 	ufshcd_set_ufs_dev_active(hba);
=20
+	err =3D ufshcd_device_init(hba, /*init_dev_params=3D*/true);
+	if (err)
+		goto out_disable;
+
 	err =3D ufshcd_add_scsi_host(hba);
 	if (err)
 		goto out_disable;
