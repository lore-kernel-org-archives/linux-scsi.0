Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3AB91591FC
	for <linux-scsi@vger.kernel.org>; Mon, 19 Aug 2024 22:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724107896; cv=none; b=gz6PO1+Nh1D606oixmjpAo1SDp0DjTURxrMD5zBvNnDnWcZbuG64gZOY0Fq8zri+O2HwJ3nW0qSOQkzLnGwps0VOrjHe/Pcca8ppb1g9t4bq4187z1UeiAN6bNU/aneED0k7yaLFYZZlRXMNVjGNVMGYJElShv6+4tJLfrTnSaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724107896; c=relaxed/simple;
	bh=YkhHAXhAWiKkZqXv6oyYvxDbrZcnvuqKCNANecfuSME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZupva042yiIKf90qV7F6sutKK//R/lB4nFbaYEpulwaO1FNXTkKmEKS0Z6KFMbEmHfPEwCYH1koq8jaJ7+6TFmAt5RVJWdixeqrXLydGEgGr0ULpKgusCKK3iXdKhcC0bsobn5Htu3ZK0bE1oRq3BDi4R0yMaLfbxOO6rgzsSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=uFpOCVbU; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="uFpOCVbU"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Wnns22wjHz6Cnk9X;
	Mon, 19 Aug 2024 22:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724107890; x=1726699891; bh=nZjx0
	idykRFXTxU5sySZM8noGg3gIw8VanZLBw0eZio=; b=uFpOCVbUMkfvdN05j2teZ
	JTLqmxPWtmMFl06R4qo9/n159xo/0gs68wyN8Sj6VupSQlM7uXKdzrLEmL/DCMaL
	nvgqghp1V5/ydic4n2/Q6jhZ46+od0WlAX7ypFeEP/4/d7ZNce7eQWT45y2uqIbO
	uxvk5fKoY4ZzbFsXzFTvGZW6CcYsHpBZbvQf6ecmOAx595oDrupIBJYAXX2f7AWK
	pirwWFBXvD2X9H0R+AGx9UeKBy/iOkbEeNseXfWvPjAVgavyYOeGmarU8Qihm/2Z
	MfkU++o2kx7rhUMLkzNUOsS/wOQx7HlozwFmRh6dn71epI4Ob3ArHonLnZPP821I
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ntBz2Idh56Aw; Mon, 19 Aug 2024 22:51:30 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Wnnrx4NfFz6ClY8r;
	Mon, 19 Aug 2024 22:51:29 +0000 (UTC)
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
Subject: [PATCH 2/9] ufs: core: Introduce ufshcd_activate_link()
Date: Mon, 19 Aug 2024 15:50:19 -0700
Message-ID: <20240819225102.2437307-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.184.g6999bdac58-goog
In-Reply-To: <20240819225102.2437307-1-bvanassche@acm.org>
References: <20240819225102.2437307-1-bvanassche@acm.org>
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

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d29e469c3873..04d94bf5cc2d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8733,10 +8733,9 @@ static void ufshcd_config_mcq(struct ufs_hba *hba)
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
@@ -8753,6 +8752,18 @@ static int ufshcd_device_init(struct ufs_hba *hba,=
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
