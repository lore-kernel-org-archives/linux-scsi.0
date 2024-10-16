Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E695478E
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2024 21:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729113141; cv=none; b=L3bLc98t78Df5FOEFLGjEaN1eOAkbgIBoX7oqJscsFoNaUAHleb+Ua2lo8tsHWFU0moIS5EntMknhQ761e69YHA9RYQ8kt60vzhYZS4FC6rV4v2SXEGU6INRp6D5SdZj5Ns2AGqRlAMFblzxnYVB/m2xWeysA8/5i9neMPhCth4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729113141; c=relaxed/simple;
	bh=nJiCNFEr2nvYXouCa9qPiMnCv1XWLEmW3ZArSD8YwX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Al+qBgZPSE8f+KEnV/yz7iXxfFbkp33uKew41zpZe6bDSZaA2+4qr5vgDa0Z3EdqBM0KLH7Nqk9VKWzSPPKelfIkww8+0NuC9y5V8wc4B2lzsfP/wU6zeaHuLIi+zd3EhjsO4nZOCz3r1dN5ROXjZwrcFohp+MOXVN8jEfzxxkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=n1g/dyCg; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="n1g/dyCg"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XTNvl1qMMzlgMVt;
	Wed, 16 Oct 2024 21:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1729113134; x=1731705135; bh=bjieb
	x6JIRUFVTLwcC94SgZT6Wzx5o/Qw/I4S74mwmU=; b=n1g/dyCg/ccxlg6vVXCDT
	zLJ/X6hAYAEHsdAKKLyC5LDjFbnZXGBXTUwERIWngwIUcDVIUVSLr8/vSpgpwgwq
	6jva4iid3S4CiXG0ymvoVeBCSH32U5QiR0xSEAs6tRvCncnKL4ELCKvL5hLzoBTq
	gN0yjAnVozDYk+5oZO2kz3B8m9QtoGxhcwZMps7Hrd8zqpSr0FBX6gi4XJ2yaW/A
	V8jWx4aY1OkoFRYJiVaDNuS0kYxB4jSyDNx40rcC9TjlfatZ393bewW7NX+ceO5y
	C6nZYXYVYqK+IqBdlW0B7pUcOwnDX6OLZk50B7EP3PEcO7zD5W44Z2fS3Z2kHYV8
	g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id vOBNMffYo0yD; Wed, 16 Oct 2024 21:12:14 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XTNvb1vRvzlgTWP;
	Wed, 16 Oct 2024 21:12:11 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Minwoo Im <minwoo.im@samsung.com>,
	Chanwoo Lee <cw9316.lee@samsung.com>,
	Rohit Ner <rohitner@google.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Eric Biggers <ebiggers@google.com>,
	Avri Altman <avri.altman@wdc.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>
Subject: [PATCH 1/7] scsi: ufs: core: Move the ufshcd_mcq_enable_esi() definition
Date: Wed, 16 Oct 2024 14:11:12 -0700
Message-ID: <20241016211154.2425403-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
In-Reply-To: <20241016211154.2425403-1-bvanassche@acm.org>
References: <20241016211154.2425403-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Move the ufshcd_mcq_enable_esi() definition such that it occurs
immediately before the ufshcd_mcq_config_esi() definition.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-mcq.c | 14 +++++++-------
 include/ufs/ufshcd.h       |  2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 5891cdacd0b3..57ced1729b73 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -417,13 +417,6 @@ void ufshcd_mcq_make_queues_operational(struct ufs_h=
ba *hba)
 }
 EXPORT_SYMBOL_GPL(ufshcd_mcq_make_queues_operational);
=20
-void ufshcd_mcq_enable_esi(struct ufs_hba *hba)
-{
-	ufshcd_writel(hba, ufshcd_readl(hba, REG_UFS_MEM_CFG) | 0x2,
-		      REG_UFS_MEM_CFG);
-}
-EXPORT_SYMBOL_GPL(ufshcd_mcq_enable_esi);
-
 void ufshcd_mcq_enable(struct ufs_hba *hba)
 {
 	ufshcd_rmwl(hba, MCQ_MODE_SELECT, MCQ_MODE_SELECT, REG_UFS_MEM_CFG);
@@ -437,6 +430,13 @@ void ufshcd_mcq_disable(struct ufs_hba *hba)
 	hba->mcq_enabled =3D false;
 }
=20
+void ufshcd_mcq_enable_esi(struct ufs_hba *hba)
+{
+	ufshcd_writel(hba, ufshcd_readl(hba, REG_UFS_MEM_CFG) | 0x2,
+		      REG_UFS_MEM_CFG);
+}
+EXPORT_SYMBOL_GPL(ufshcd_mcq_enable_esi);
+
 void ufshcd_mcq_config_esi(struct ufs_hba *hba, struct msi_msg *msg)
 {
 	ufshcd_writel(hba, msg->address_lo, REG_UFS_ESILBA);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index a95282b9f743..a0b325a32aca 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1321,8 +1321,8 @@ void ufshcd_mcq_write_cqis(struct ufs_hba *hba, u32=
 val, int i);
 unsigned long ufshcd_mcq_poll_cqe_lock(struct ufs_hba *hba,
 					 struct ufs_hw_queue *hwq);
 void ufshcd_mcq_make_queues_operational(struct ufs_hba *hba);
-void ufshcd_mcq_enable_esi(struct ufs_hba *hba);
 void ufshcd_mcq_enable(struct ufs_hba *hba);
+void ufshcd_mcq_enable_esi(struct ufs_hba *hba);
 void ufshcd_mcq_config_esi(struct ufs_hba *hba, struct msi_msg *msg);
=20
 int ufshcd_opp_config_clks(struct device *dev, struct opp_table *opp_tab=
le,
