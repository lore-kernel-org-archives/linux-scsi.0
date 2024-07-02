Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91F220013C
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 20:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719952921; cv=none; b=lE4fYIcJSOIr8AO5pJEDxE9OV7cpzlb8BfQnyEO3jH5lzy3LNwUxkV78nh4E8pHXmBDe92QfGM5lTfGPyWBQ9n6S9BtSHi9dRqpawqaxz/Zc6CBjwdxRIkCGhMVeGH5r42ZwPJEvLjujHEQRw9pqHkhGatA54jnc3sDWrtdtrcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719952921; c=relaxed/simple;
	bh=+KiVxrkLJvOBGW9vaniobU33F3tUXznqOBPtj6O7ATc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WlDzUug/skB380w/S2dvjlNN8DPvSQ8uTTp2NXTc9kPzb9DHpj9b0Jhy+LFHYjoa3tKNp9PRDTxxn4Nhu99hcGdmWVPO14kIraxoOII1Vn9WDrpSxQqZbo9GYh1hai2WmcM1vVe1ZtVU22I9nbB2ICKLauswI5dc/h0oywHmvEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=gZ2FkIAR; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="gZ2FkIAR"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WDFFf4w3bz6Cnk98;
	Tue,  2 Jul 2024 20:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1719952912; x=1722544913; bh=u9JIS
	Wyai+a5Sr7d7JxZ9E06wEF8lgPVBsJf9kG1t5w=; b=gZ2FkIARH+QcFfZdq7qaT
	IEncqZCY8cLErd0VRbHb7KkkPsAeQht9rbCT7eruzsuL9sGilDywFvc5ZopOH2mx
	C6KmQq8VWRO2Wq+C+IF6Fb8RosQ89wBtMUq0/Qpcxg5cs/eDdWuoXfACTyMQKCg+
	ChRqvjjNYILG4zyx84iUe64FWy11y8lCDqlhk2BTCjRx9Sz3y/2YtXKZnwcWYcyD
	5QC5FMfCQTEv5vbEuy6sqMx6OrMV7MPUsBsNXiwXnLWQnYDMcxhhlHTosfCgtCUG
	kA9KFSYyWzCG1hCG5biPrsKhyK76XL3grqCIiSv/BPUIklbN8l3GIBJcjvvHzlI1
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id QX5ZUweONf6C; Tue,  2 Jul 2024 20:41:52 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WDFFW2vmxz6Cnk90;
	Tue,  2 Jul 2024 20:41:51 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	ChanWoo Lee <cw9316.lee@samsung.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH v4 8/9] scsi: ufs: Inline ufshcd_mcq_vops_get_hba_mac()
Date: Tue,  2 Jul 2024 13:39:16 -0700
Message-ID: <20240702204020.2489324-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
In-Reply-To: <20240702204020.2489324-1-bvanassche@acm.org>
References: <20240702204020.2489324-1-bvanassche@acm.org>
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
