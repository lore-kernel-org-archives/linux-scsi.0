Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284B460EC4
	for <linux-scsi@vger.kernel.org>; Thu, 27 Jun 2024 20:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719518467; cv=none; b=r8TPOgUYG7EBNwcxrdYniTwqjyqE1jhLJDDcfgkeNvLCS8yHIaoFN/XD0o4qPBer1a7IRM4W/ETne6IQ17bSMJtHgfeuthe8UddSm6wmcB16qTXObL+yHtuWEbr4NQ25AjqU1Hgdn6q3c2s5CexEntzbYYjECIi2Co3NfcJ6v7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719518467; c=relaxed/simple;
	bh=ofG2i6iZjxZz0CkQth4444QwyMEJ0F990W50wJOL67U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQHp3NkQOiNufL11tgQCUYDiK5/rkqO1f7V+4C+hPAZubBbHOTrt+2yt50RHvEdA5r3+GGHssDkFWP9A0gkDo3LTjPzSfUA2n04VjDqPdUJ9cDKwndJXRLXNltdR9wy+WgSWIocyi5sZzxdoNLuSLA+LNSEnqxlAYNTn6kU27i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=MVc/Ac1q; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="MVc/Ac1q"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4W98Zn56LQzll9bv;
	Thu, 27 Jun 2024 20:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1719518460; x=1722110461; bh=Yhd76
	0WXkoDafpSFoN/9yIHF3/TTwYo+cWGDdf2LbBU=; b=MVc/Ac1qsL2+5KLnd/C2y
	7BYm2TeN2UoTDLn0Sz1/Rn8ro0eXvMBupRS1ctRrCGXMxr1V7gYXQ1n7BpijsG7g
	atJ90hT5Nx+bqhrW0Df22N0c0ldtf1DprFRfEdYi3DxQPGwMWw5fE5qTCsfE2dK/
	YZScC2XM86o8PMGl4xDQVs5OqFEE8YS/J27VxJxbNmIJ1UgLVg7M+iu21B7zGz1/
	8YBNe10yNyIfLa4bqwbFgIqlXeKYaZG629+v08P62xalCVQTsomBK9WU+hOXMrIl
	0gwxRx/vtLl928W8taZWR1Ci1WBgUUeqsSh1Gib5Mt6lilVOiMB0DW50q3etDhU0
	A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Y2fgNvXxoVjk; Thu, 27 Jun 2024 20:01:00 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4W98Zd3gLQzlgMVW;
	Thu, 27 Jun 2024 20:00:57 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	ChanWoo Lee <cw9316.lee@samsung.com>,
	Rohit Ner <rohitner@google.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Yang Li <yang.lee@linux.alibaba.com>,
	Keoseong Park <keosung.park@samsung.com>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v2 6/7] scsi: ufs: Inline ufshcd_mcq_vops_get_hba_mac()
Date: Thu, 27 Jun 2024 12:58:32 -0700
Message-ID: <20240627195918.2709502-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
In-Reply-To: <20240627195918.2709502-1-bvanassche@acm.org>
References: <20240627195918.2709502-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Make ufshcd_mcq_decide_queue_depth() easier to read by inlining
ufshcd_mcq_vops_get_hba_mac().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-mcq.c     | 18 +++++++++++-------
 drivers/ufs/core/ufshcd-priv.h |  8 --------
 2 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 4bcae410c268..0482c7a1e419 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -144,14 +144,14 @@ EXPORT_SYMBOL_GPL(ufshcd_mcq_queue_cfg_addr);
  */
 int ufshcd_mcq_decide_queue_depth(struct ufs_hba *hba)
 {
-	int mac;
+	int mac =3D -EOPNOTSUPP;
=20
-	/* Mandatory to implement get_hba_mac() */
-	mac =3D ufshcd_mcq_vops_get_hba_mac(hba);
-	if (mac < 0) {
-		dev_err(hba->dev, "Failed to get mac, err=3D%d\n", mac);
-		return mac;
-	}
+	if (!hba->vops || !hba->vops->get_hba_mac)
+		goto err;
+
+	mac =3D hba->vops->get_hba_mac(hba);
+	if (mac < 0)
+		goto err;
=20
 	WARN_ON_ONCE(!hba->dev_info.bqueuedepth);
 	/*
@@ -160,6 +160,10 @@ int ufshcd_mcq_decide_queue_depth(struct ufs_hba *hb=
a)
 	 * shared queuing architecture is enabled.
 	 */
 	return min_t(int, mac, hba->dev_info.bqueuedepth);
+
+err:
+	dev_err(hba->dev, "Failed to get mac, err=3D%d\n", mac);
+	return mac;
 }
=20
 static int ufshcd_mcq_config_nr_queues(struct ufs_hba *hba)
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-pri=
v.h
index 0bce72848402..fb4457a84d11 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -253,14 +253,6 @@ static inline int ufshcd_vops_mcq_config_resource(st=
ruct ufs_hba *hba)
 	return -EOPNOTSUPP;
 }
=20
-static inline int ufshcd_mcq_vops_get_hba_mac(struct ufs_hba *hba)
-{
-	if (hba->vops && hba->vops->get_hba_mac)
-		return hba->vops->get_hba_mac(hba);
-
-	return -EOPNOTSUPP;
-}
-
 static inline int ufshcd_mcq_vops_op_runtime_config(struct ufs_hba *hba)
 {
 	if (hba->vops && hba->vops->op_runtime_config)
