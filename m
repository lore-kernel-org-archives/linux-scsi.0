Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34D51A4F35
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2024 17:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724867112; cv=none; b=DcSmIm3WTArI46AyMw1WUfSc5FxfpmqwIa0nZeogSIet016k8jyA66VWTXYbSqH2BwbaaSTlSIa90OUDWV96VAjt5C/4WgVhXlfYxUcSAcG1QnxznB7Tw8RsOzY5uXNf24cnqfW81XMpSemWol2n3JnBLFfQivVnNNU6bPnVgi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724867112; c=relaxed/simple;
	bh=xZJOu6jbrtxGIi43e24drfszxB4/XyV33YO7+9uSTQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etYUlo3wZp+ZjrlLx8v4L8aQQA3Ft8gD6NiYpmG/tLZN7jNlj+Y7k2cCCl4qt3R2eJ9vGzaNmqJZ1IhbM2/Ul5G0VyN9Q75BL+USFvngyV2I0an0Q+MdO3MhgDNRRsNPP61LO8gh2B0z/1AgV152+FBwdrlTiXkeItPI0ujsgkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=TRkePe9V; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="TRkePe9V"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WvBdL4HNYzlgVXv;
	Wed, 28 Aug 2024 17:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724867107; x=1727459108; bh=LnzIy
	yhOnZY+p66B6nwgFw3YMD8ecCvnxJOHOB47lOA=; b=TRkePe9VRtFbebE4tiTl8
	CEx4SzcQulCV0Hl42G6DbaCV5IHafgy0ZlSD4d00gb4LqhZsmEjeEFjR8rAN+sIs
	aUeZEYGsJAO6HMRZgf5wIusY5a3ln9XoTpmjF21CgC5gafThn64tW8PFb6CP5b/d
	KDTD2/asBAUdSv3mYGWEyFwL5EI3IzCyIjDVEiJNz9YbBJj2DQYZdfOBzBp6qxaL
	AX6O5d893s6p/+GPKQUcoxVhh/wpA+9oEOkmyFsbHZcVLgpmpsk3qo5BB9Ol07u+
	Z48MnM2fHo0m2iN4sCYNzuSDbxSSmJi9OCrZN4DDphvF3IyoWmMojp0p66oii4xA
	w==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id TBumYg9S8Kxn; Wed, 28 Aug 2024 17:45:07 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WvBdG4S1CzlgTGW;
	Wed, 28 Aug 2024 17:45:06 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH v3 2/9] ufs: core: Introduce ufshcd_activate_link()
Date: Wed, 28 Aug 2024 10:43:54 -0700
Message-ID: <20240828174435.2469498-3-bvanassche@acm.org>
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

Prepare for introducing a second caller by moving the code for
activating the link between UFS controller and device into a new
function. No functionality has been changed.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 70e9341a3043..6dbc01b47ff6 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8727,10 +8727,9 @@ static void ufshcd_config_mcq(struct ufs_hba *hba)
 		 hba->nutrs);
 }
=20
-static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
+static int ufshcd_activate_link(struct ufs_hba *hba)
 {
 	int ret;
-	struct Scsi_Host *host =3D hba->host;
=20
 	hba->ufshcd_state =3D UFSHCD_STATE_RESET;
=20
@@ -8747,6 +8746,18 @@ static int ufshcd_device_init(struct ufs_hba *hba,=
 bool init_dev_params)
 	/* UniPro link is active now */
 	ufshcd_set_link_active(hba);
=20
+	return 0;
+}
+
+static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
+{
+	struct Scsi_Host *host =3D hba->host;
+	int ret;
+
+	ret =3D ufshcd_activate_link(hba);
+	if (ret)
+		return ret;
+
 	/* Reconfigure MCQ upon reset */
 	if (hba->mcq_enabled && !init_dev_params) {
 		ufshcd_config_mcq(hba);
