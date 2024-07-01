Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBABF9DF
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jul 2024 18:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719857112; cv=none; b=M0wqCWsZdnsYNN3A9eWteemRDgZkdNfrNUZcCCa/MUm0eoR8VjlEP1/XyXxIMdZ046Oz96oegzPbhzDoyGeUKftD1pGTcvxVModUb1mPdsrH81ph5tlrr340vfr1MVyklCvfZY765dmS3GvK5UHHBuYKyhXA0TGEWKBBH2iFoPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719857112; c=relaxed/simple;
	bh=uYMsEJLFhe2ZHA1w7BfnvmdqIn5NL6zBll/PbahXRBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jB9CbsuHEabxdoO1DWM9Geal9RN225+aJV4M+iX/f+aG1otXVWUjN6+EuaGdi7BJ/uFURiSe8jZcxqi9/GO1ePM/ot4UZy4/hhwGxnzVz+BWgygbpNyH4mYHCGjMJehXegsGbRzDzVxj5fdptwYXbmIZ58ritZtQyiroEF1uoZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=O/Txzpfi; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="O/Txzpfi"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WCYqC217nzlffm0;
	Mon,  1 Jul 2024 18:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1719857106; x=1722449107; bh=DKyyw
	YXt8XaEVN9rJ8M0dWIP8Yui52+50urqpxdF+zw=; b=O/Txzpfizd8waPvlKeE9N
	QYm73dpImM39WhZZzw8kleDzIcSq93cooMyM0Lh6blJMZXVoDoWOI+PXPrtv6Cu5
	whsmqWF6PfheAWJL16VER11GFdTbsIfcf8OiD7F85zcStOc5K0JbAwXwgIJ0WFQp
	zR5AHEuRHbSwysfMM2M2vk/mTM1mTLE9gBTRNmxWU+UfIRKTO1+mWRw0Dhz+FgR1
	nPhPuBEFAjY4gGp8wl+ano9k3A714QL+2biDGiB8HtAFee1DcyN83aXhpGllqLLU
	7G8U8BCcSzdDA7N/YUaNfDH1s5tgAC5jRE4z9nhFddIkcApgVFbVhJ7WRjnQ3fV2
	A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id S2zmzKyDIl_d; Mon,  1 Jul 2024 18:05:06 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WCYq51LBvzllCSD;
	Mon,  1 Jul 2024 18:05:05 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	ChanWoo Lee <cw9316.lee@samsung.com>,
	Po-Wen Kao <powen.kao@mediatek.com>,
	Naomi Chu <naomi.chu@mediatek.com>,
	Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH v3 6/7] scsi: ufs: Inline ufshcd_mcq_vops_get_hba_mac()
Date: Mon,  1 Jul 2024 11:03:34 -0700
Message-ID: <20240701180419.1028844-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
In-Reply-To: <20240701180419.1028844-1-bvanassche@acm.org>
References: <20240701180419.1028844-1-bvanassche@acm.org>
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
index 668748477e6e..88ce93748305 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -249,14 +249,6 @@ static inline int ufshcd_vops_mcq_config_resource(st=
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
