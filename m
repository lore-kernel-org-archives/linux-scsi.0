Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C051D14F117
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2024 21:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720473538; cv=none; b=YFiWxOnnC0tm84O3ZOPEZW9Q0go4Se/BZTd4IjdrXhnS0geywTBoo1u4REZ/MF+AEf2mY8b+MSyyydPt4TwWQMIC8PdFU4RTRBuulLww6vjArpbk+EKgkF8sTNonvS0ZKvPow0MF46B0Cbi0wWj+aTwBhEzc9yp85L5djaVGB70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720473538; c=relaxed/simple;
	bh=25ONgGd/9OKImgCd/A6nWe/9/CLMIUNh8u51HbmpPxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXfZqG8/jRaPYfYpmbySUY9DrXUgsE1JwFcOFueq0foDRIZwTQhBkx0KVWuJKeJESd2Zb5XBnHGfBE69jg2gJmPgfPS8GV4AbedhqZ9gUpMYsOeqO/ojPXkfk+2wqXs/+1olp0PLoseKnek8ZjM3VpyvcLPc3kv6pVyQhcpQQtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=XsAI4yq4; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="XsAI4yq4"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WHxnX3qVVz6CmR43;
	Mon,  8 Jul 2024 21:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1720473529; x=1723065530; bh=GehI3
	XXL4Ad36kvz3hlcm2rtGolWxFPbZ9vzX2/j/NM=; b=XsAI4yq4Hv07BGMcdWSJj
	H2BhKzAxRP9lg5nREyxIaon4dtC3I7d0byvHtxHYgGFWDvfyjGmH0hcCG5oPX+Kb
	t0NAWQrkZsb03SkVfJ0VBEKze8QMIJqCtl0c8B6w55aIBarRbEwoIASNNYfAInAZ
	0VQFn6n9VoaKiDPRXRSDye2zE92nbF9WgU3/1dwqCjlhaLwu7Oj8zr1JJ8O/HEKW
	bVXMOHE8mHSmpnGC6K0b2Q+Id21O+vF7blGyL78x3ULPSckxC+hSnNVBBhRfs+yw
	I/j803h33kfBd9VCPLa3NQ9rmSpTQhN+YfEhfWwyZD6ve+cbOPZUFekjxuIILmEq
	Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id VV9AFcosktUv; Mon,  8 Jul 2024 21:18:49 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WHxnL23Q6z6Cnk9V;
	Mon,  8 Jul 2024 21:18:46 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	peter.wang@mediatek.com,
	manivannan.sadhasivam@linaro.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	ChanWoo Lee <cw9316.lee@samsung.com>,
	Naomi Chu <naomi.chu@mediatek.com>,
	Po-Wen Kao <powen.kao@mediatek.com>,
	Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH v5 09/10] scsi: ufs: Inline ufshcd_mcq_vops_get_hba_mac()
Date: Mon,  8 Jul 2024 14:16:04 -0700
Message-ID: <20240708211716.2827751-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
In-Reply-To: <20240708211716.2827751-1-bvanassche@acm.org>
References: <20240708211716.2827751-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Make ufshcd_mcq_decide_queue_depth() easier to read by inlining
ufshcd_mcq_vops_get_hba_mac().

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-mcq.c     | 18 +++++++++++-------
 drivers/ufs/core/ufshcd-priv.h |  8 --------
 2 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 0a9597a6d059..ef98c9797d07 100644
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
