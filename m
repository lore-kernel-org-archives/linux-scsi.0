Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60930166307
	for <linux-scsi@vger.kernel.org>; Wed,  6 Nov 2024 18:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730916631; cv=none; b=G3q1N+Iroups4oCCubb/iJUTPO2rvV/yt/GZtzqoS7QU/FwaO6dI0jOHFDbQDrp7Ks+z1FOEq4HYy0yTJtduH89oufJCcp4UQuT1dtbuCkUb2kuhMoyZwgUWKGn0ig4E7qfGkI6Yx2MokdrPzoAjU7bpQw3ixUCDu0m7CsBZ9Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730916631; c=relaxed/simple;
	bh=LZMLbgVkJSVy9oOBnuqBdr/r2gphCGBDZMxMPUlIdsk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t3KTPFZJQHCIIDCImZKMZI+s3fLpHtFFmkQoYwWvt4o7F50vPnEVrNVrVqwirH6b/FGxZw/8U6yD8/kXY3vT3XELgPskHpoTmZBcUfIBHi19Hiuf/LcwOAVogdHiuE7vsrwATN0IxCrG4T2xTih+WWbIyGuyoiYe/dMBGpEegtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=470ZmsRg; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="470ZmsRg"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XkCtD2yG2zlgTWK;
	Wed,  6 Nov 2024 18:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1730916624; x=1733508625; bh=62SBU3/rfRTHzXFeL8l8O/AZyh7Bitack4a
	l3j4Fv/g=; b=470ZmsRg1oPUl4N8QzGIIFcz7S06xCYI4vHqUGkGNjCQsJgiY+k
	kni35+vTyI0eyBSNQPEkARo+IYTmZaLj95FKjYPofjfrBsJfu/L4W7+mRgfeYo/t
	bTqN9e+qCF5GaSYNmxhs0/IvxrJR50k11sS8BxazHUPZpydDmrmLVbf2jW8d+rD9
	jZLFdkxY+LAEE3J0/Y6Dy9KBrHQm23O5qPHphFTga+Pi299TifmYACPCbgBxehDD
	6xAPchm0Kh2fcg4yb3iqen7Omxx2yHjaHR3qAPIXCVhkYWvz7S8hS8QlkYym/jZB
	kdvPCvyA9VToSTVavUzqWEWQEbGWzLJe42A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id OI_MVkS53_jh; Wed,  6 Nov 2024 18:10:24 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XkCt55wC0zlgTsK;
	Wed,  6 Nov 2024 18:10:20 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH] scsi: ufs: core: Restore SM8650 support
Date: Wed,  6 Nov 2024 10:10:11 -0800
Message-ID: <20241106181011.4132974-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.199.ga7371fff76-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Some early UFSHCI 4.0 controllers support the UFSHCI 3.0 register set.
The UFSHCD_QUIRK_BROKEN_LSDBS_CAP quirk must be set for these controllers=
.
Commit b92e5937e352 ("scsi: ufs: core: Move code out of an if-statement")
changed the behavior for these controllers from working fine into
"ufshcd_add_scsi_host: failed to initialize (legacy doorbell mode not
supported)". Fix this by setting the "broken LSDBS" quirk for the
SM8650 development board.

Reported-by: Neil Armstrong <neil.armstrong@linaro.org>
Closes: https://lore.kernel.org/linux-scsi/0c0bc528-fdc2-4106-bc99-f23ae3=
77f6f5@linaro.org/
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-QRD
Fixes: b92e5937e352 ("scsi: ufs: core: Move code out of an if-statement")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/host/ufs-qcom.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index a5a0646bb80a..3b592492e152 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -874,7 +874,8 @@ static void ufs_qcom_advertise_quirks(struct ufs_hba =
*hba)
 	if (host->hw_ver.major > 0x3)
 		hba->quirks |=3D UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH;
=20
-	if (of_device_is_compatible(hba->dev->of_node, "qcom,sm8550-ufshc"))
+	if (of_device_is_compatible(hba->dev->of_node, "qcom,sm8550-ufshc") ||
+	    of_device_is_compatible(hba->dev->of_node, "qcom,sm8650-ufshc"))
 		hba->quirks |=3D UFSHCD_QUIRK_BROKEN_LSDBS_CAP;
 }
=20
