Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C6918C356
	for <linux-scsi@vger.kernel.org>; Mon, 17 Jun 2024 21:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718658564; cv=none; b=nXwfoVneUM5zb4ZlJVF0LQc60GWwN1k36TMFb3oYxgoJdCG8eUvcN6WgBrr3AEPbiFONeTTBXgs9Sx6SXyUtae4wWIBtt+y6FE2NFjLuqDiLom5C18uTnkRhGXhazpc1uNNli6u5M0kf19bbAQFUzhWEV321GFn0QiCCf5yJFjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718658564; c=relaxed/simple;
	bh=OoJLwAFNGsANX8AMDEEGDq9DOjbfM7yxO52DiqBftqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fr6h7mUOISD+N0eyeUq0/wtVsa5YhZBZnAfP87pDC39R3O75AlyebgulPkISaXXfVz0f+r1bkdISxxJsoG23a8mQhHZKHe7GmJ28zNOaaHf0M2ER+9QwMZi3zjOrKFhPh7PdIi/KtPOnqrbQ6chcUZJjSh0Q6xu5LI1tRMpeAV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=VrEntE1r; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="VrEntE1r"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4W32ZB6f0Tz6Cnk98;
	Mon, 17 Jun 2024 21:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1718658557; x=1721250558; bh=aQcdM
	7osT1j4+4virxde9dcGmwT94mxRb7fWbCygNfg=; b=VrEntE1r9Ae/SmnMmAXli
	of7t7UXApBdACP5essTi2CRSZZ1GkDKs/OFr0HjWG5wmb1Q8kP7cSfJHZl+sRDIS
	NyWPnw+12S/czXNkyMgseXlCG9eW139R+1lakbV+afyfwi67IJWBRXwhmYPCzOIn
	Vn9u1JNHrl62PzcNPWeYdOKCKz5NSTceJ/qXusn+teiwrF7Y6GiUbZPI5N699VUU
	xjG9OvXCyLO6FP9Hvkr0D9KsdUomDQoBnInBvIWgVz5ZdlGVWYLHifsMbAA+6y4h
	de7XqUDNeR+tqGOF5jKnvzghZXuwW7h7NRxyX7YJEieOLDv9SspEtNaM/o1jaOXf
	g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 07SkSgVHPb5R; Mon, 17 Jun 2024 21:09:17 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4W32Z44s16z6Cnk95;
	Mon, 17 Jun 2024 21:09:16 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Peter Wang <peter.wang@mediatek.com>,
	ChanWoo Lee <cw9316.lee@samsung.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Po-Wen Kao <powen.kao@mediatek.com>,
	Yang Li <yang.lee@linux.alibaba.com>,
	Keoseong Park <keosung.park@samsung.com>
Subject: [PATCH 3/8] scsi: ufs: Inline ufshcd_mcq_vops_get_hba_mac()
Date: Mon, 17 Jun 2024 14:07:42 -0700
Message-ID: <20240617210844.337476-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.627.g7a2c4fd464-goog
In-Reply-To: <20240617210844.337476-1-bvanassche@acm.org>
References: <20240617210844.337476-1-bvanassche@acm.org>
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
index f42d99ce5bf1..a1add22205db 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -255,14 +255,6 @@ static inline int ufshcd_vops_mcq_config_resource(st=
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
