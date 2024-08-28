Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED241A705E
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2024 17:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724867130; cv=none; b=fR3ZGN5MSN222QBLxydWgeYQDjFJrT+u0EcOz6SGqlooQ104ma7ThXCgI6hv0zxObTMsWm8jGy/37gSh9OLk0S6lZoDXT4KPGb9r78NXUzzVkF+x6rfCHHDzTUUgl3VEdZfonHQSvt3gxQ2XCVkbx2K3/bu2KF8mjfJIe7Fjw/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724867130; c=relaxed/simple;
	bh=nw/VJQ4J+CPqhC9yI0gXfJNtmSDcBkS2aDfZNGwFCHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hjoQCnXxm08UiydEsPcWtEcF8qH3n/gE9RCsI1C9M16YU88HH64n3wSaFc+Gm8aY5weiKaDh2bFb/ZlKyCLk6bA+cqm2i3TLrdG6dH47UYF54LLyWAMwmLINeYwRZAV6MFQlyDz0laEO8/Q45953V/wGuijtpiA2lMUAY6uJLw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=K738+pJ2; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="K738+pJ2"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WvBdj13R1zlgVXv;
	Wed, 28 Aug 2024 17:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724867125; x=1727459126; bh=LtzUz
	yKuqCYZOZSTuLuW77fiJFRF1qtsZx5UDKWRzNU=; b=K738+pJ2BHOAh9gOgviS2
	fNiMv1rmZTJ+SQjsgdupKRmRQ/uiUCnOiH54cwnfigXbH8XPIjBesRSnoXnrcmLk
	Xyfu8C8eGUz3ZkrUJfBXv1NxfqhZpklECrzk1dGrGbevjKARRWoC1p/xco8ZItKn
	k7fjKS3B8jarMpwjvYuqmLWWCG2aUSXZjbOLpbUt0n7r96u31sRcEGYFIcAIBcsF
	9/3NfzPguW1SuOo5jzawROiAZRQMIzhddFaWHhVLOjYrNfYfsWafWQqZlwmteGRB
	z3JPjp4slBht59+2k2pdpZ7LPjwNT6DU5Y3kwRRsfr2gZ53PHw7yOUjanLJKr79W
	w==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id xy7fhlQwJscH; Wed, 28 Aug 2024 17:45:25 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WvBdd1LnmzlgTGW;
	Wed, 28 Aug 2024 17:45:25 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bean Huo <beanhuo@micron.com>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH v3 6/9] ufs: core: Move the ufshcd_device_init(hba, true) call
Date: Wed, 28 Aug 2024 10:43:58 -0700
Message-ID: <20240828174435.2469498-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
In-Reply-To: <20240828174435.2469498-1-bvanassche@acm.org>
References: <20240828174435.2469498-1-bvanassche@acm.org>
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
index f62fff878980..33e5dfd794a4 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8926,10 +8926,7 @@ static void ufshcd_async_scan(void *data, async_co=
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
@@ -10623,6 +10620,10 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
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
