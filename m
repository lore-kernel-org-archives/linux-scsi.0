Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5270E2F747B
	for <linux-scsi@vger.kernel.org>; Tue,  9 Sep 2025 19:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757444797; cv=none; b=YKTDE6k3tF3LpoIZ9Wl7NeEg+ho4BTGWGJNgqwbDr2kWK72bRmwU+ymCwlH7t3+EUoRv7TwI736pFQpzhAQgG8pDKsmOxNWEx6iEbmwKac8IqUXJwWy2++tw0C6dFN9yD3fQtn0ojSrqvELWedCYxoYDxgdZHlXVH9dgeWRvgaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757444797; c=relaxed/simple;
	bh=n1sHyjOr873DD6m6MhfBtCiu2DDnmzYJN7NPSCOoBAo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FXXA+wkcSy3S+3n+l85AV8LYLKWsVDQGy107kMCCF8aeGZvQpbWo3seieV9RDGo004MRj0joEjmZp3ViBQiXtF10UZnzacp2Z7hX0k1m8W5oDSEhOoYqIb1qBzCkmrDV3Tn8iKYZto8X7PqSkBlo8JvqGvAKFznYnLxmC1u+L9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=TkQC3Plk; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="TkQC3Plk"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cLtbG1KjYzlrnQK;
	Tue,  9 Sep 2025 19:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1757444792; x=1760036793; bh=scVke5ByLgC3DgciiY7hsDbJ52EeRjxCmec
	v0+P5bI0=; b=TkQC3PlkitfaJVasUlTqh/xPlYxFjWdlA7D1mtNqrbvhMOGxjAQ
	cSZvI2CqrFFrS67wVcR5sBA5ciKLpIdwfcFU4YF/qcfKZZwwfMaamp4bSi+edAHB
	gEbufV3ZOOSWkuAh0MGBcVQfrDgCgIkkEr6vCD8Z0umtHTyJUhuNqP/JMlJNveae
	UOkJOvdbMQVih9IrEdJiVob+YArtxokSmOgv4IjwwO8eGtcnhpVkeI1hJVf8frWP
	Z3dHEuSYzI9dY+llGXTjyq0h7+d4tBJY/rrzE895JipeSonYgSu8DPtDy+LpzYDb
	nenmNxvYRVrPvuULYmeQCywr136xq/B2fsA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id m-WUvMwumVoA; Tue,  9 Sep 2025 19:06:32 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cLtb50vvszlgqyX;
	Tue,  9 Sep 2025 19:06:24 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Manish Pandey <quic_mapa@quicinc.com>,
	Manivannan Sadhasivam <mani@kernel.org>
Subject: [PATCH] ufs: core: Disable timestamp functionality if not supported
Date: Tue,  9 Sep 2025 12:06:07 -0700
Message-ID: <20250909190614.3531435-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Some Kioxia UFS 4 devices do not support the qTimestamp attribute.
Set the UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT for these devices such
that no error messages appear in the kernel log about failures to set
the qTimestamp attribute.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 6 +++++-
 include/ufs/ufs_quirks.h  | 3 +++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ca6a0f8ccbea..5d0793d8b0e9 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -316,6 +316,9 @@ static const struct ufs_dev_quirk ufs_fixups[] =3D {
 	{ .wmanufacturerid =3D UFS_VENDOR_TOSHIBA,
 	  .model =3D "THGLF2G9D8KBADG",
 	  .quirk =3D UFS_DEVICE_QUIRK_PA_TACTIVATE },
+	{ .wmanufacturerid =3D UFS_VENDOR_TOSHIBA,
+	  .model =3D "THGJFJT1E45BATP",
+	  .quirk =3D UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT },
 	{}
 };
=20
@@ -8777,7 +8780,8 @@ static void ufshcd_set_timestamp_attr(struct ufs_hb=
a *hba)
 	struct ufs_dev_info *dev_info =3D &hba->dev_info;
 	struct utp_upiu_query_v4_0 *upiu_data;
=20
-	if (dev_info->wspecversion < 0x400)
+	if (dev_info->wspecversion < 0x400 ||
+	    hba->dev_quirks & UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT)
 		return;
=20
 	ufshcd_dev_man_lock(hba);
diff --git a/include/ufs/ufs_quirks.h b/include/ufs/ufs_quirks.h
index f52de5ed1b3b..83563247c36c 100644
--- a/include/ufs/ufs_quirks.h
+++ b/include/ufs/ufs_quirks.h
@@ -113,4 +113,7 @@ struct ufs_dev_quirk {
  */
 #define UFS_DEVICE_QUIRK_PA_HIBER8TIME          (1 << 12)
=20
+/* Some UFS 4 devices do not support the qTimestamp attribute */
+#define UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT	(1 << 13)
+
 #endif /* UFS_QUIRKS_H_ */
