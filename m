Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464568F54
	for <linux-scsi@vger.kernel.org>; Thu,  5 Sep 2024 22:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725573756; cv=none; b=lbQbzSrDGcz23EQuViBXWCL6kBvG2wuQuN/IYQKM0N5Vkxn1ml5cxUNrXJyNnkzejHBF8ecshuAp94aUasbwaVlTArjcL5lntGDWNkA5qgI/WEStS6qWFr7zewhI+WAXMwZ1C/D9DqXFyOYNIL6f0OLMhIc3ihCEdF4eY5QTy7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725573756; c=relaxed/simple;
	bh=mqupfqSVdnCk4qZBAuYXce9mvrcxrMDg6Q0xyxPruP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mpLwPeiuTePWEfiLFbZ3NxZQlw/HBMQ+CD6BSpOcUXLhgyl8GjfgHdol+wdIt5RKMVE3Q3ixpcdZjd9DV1bQPvTQfBlz1/qsz4QlF1TKB1FSv3lMs2y9Bhs11/spW7eT1ZK9rI0gdVfIc6dfzdLXSlZJV4swwW5LZlE8PTf6rlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=AyxnMvX/; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="AyxnMvX/"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X0Cyf5ZKtz6ClY8x;
	Thu,  5 Sep 2024 22:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1725573750; x=1728165751; bh=Nu151
	KQ2+rioKfJaJQxIXRlDPr6ltJfirvCDt5MReOs=; b=AyxnMvX/xnDefDjGIm6AZ
	f/l+nPW65pkAO2XkRk/dW3o1mKLiBu7AK+tgaZBw7DG181ZlD4OplYjm4b3uWAlL
	XCu7O+foK7JPn9pz09hlUZO5G0kkbOVUBDRZDoIh8BLWJ7+TX114GhtT4b6uYcNx
	jUprN+1J7b1FJwsGVtwfE2AI18ven+V6LuG6rJJt3HMiV12W3pkRzuXv+W3nLhST
	c5EH3opFQX4xSyTQuowTZsf+8f1lbN9maukG6dy9mgx8j/MvIgN62U9QgB1xils4
	1gswvjFpQOIZ5zxq3ZSXFF+ykL8/zEtouXWPbHKNROjXKjIaG8YKKWGj90EiDjOT
	g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id L6alzBOwZOv2; Thu,  5 Sep 2024 22:02:30 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X0CyY6Hj4z6Cnk98;
	Thu,  5 Sep 2024 22:02:29 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bean Huo <beanhuo@micron.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH v4 02/10] scsi: ufs: core: Introduce ufshcd_activate_link()
Date: Thu,  5 Sep 2024 15:01:28 -0700
Message-ID: <20240905220214.738506-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
In-Reply-To: <20240905220214.738506-1-bvanassche@acm.org>
References: <20240905220214.738506-1-bvanassche@acm.org>
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
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ecf6da2efed1..4cfa8dd5500a 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8709,10 +8709,9 @@ static void ufshcd_config_mcq(struct ufs_hba *hba)
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
@@ -8729,6 +8728,18 @@ static int ufshcd_device_init(struct ufs_hba *hba,=
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
