Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1313E1D172E
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 21:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724362654; cv=none; b=TDZQAGs3hEsaUWVfPJKGVhT/kYH6tPdQBPDAFxn5xyGT8sX7Ura2TXrCDNHAPp7odxAvdYCP97R3e7MNV38Raj+XAbNCdHWIBiQq8cf0VdfMhcj7tqTGbgFeLP7qPOrT2UvwQxNl9o8PiS85ZMQ9BAyHhH10AUPXL7kPo4T26EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724362654; c=relaxed/simple;
	bh=O7f4AK9uAe/0m0yfKC5aNABGNOhD8/tfbXxrNMbwY+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IeT5da22PxFzpWr18YUv1gXb4rze697Pl6yAENTT7/69FPNu9d3kmkLPSGZjyOODcoe7b3InSzYFG+uvPZDUOIj63BPpvm05f63GP9oD6EtrRDr689/PLF+y4RI0Z9troShjr65jTn2EjprGrqZ87u/skPkjZGnN6JbrK7iWnbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=aTC+oZY/; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="aTC+oZY/"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Wqc4D4VGjzlgVnK;
	Thu, 22 Aug 2024 21:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724362649; x=1726954650; bh=uY7Wg
	LCZQp6b0dMRnpJQ9/izYWM4XFzPTNtTEgTM/Wo=; b=aTC+oZY/UgUstzxYP69Kj
	2AyVV64/Oq9Z0oIkvh4v2oqq05Cy+96n1w8fAInyJYZNKAlcPDAE44HOewMOudDw
	uHo0VUDzXxxJAFwHKLx6BKndhdMFVLgvivbNVbqnTYwRvJ42NRJaSzKoeMgzJC8u
	5LVDsb7qhon9zlfBOUn6a6jkXP9fskFRQwu4X547U7nGDCrdIAUHZPnyjoN/oJCr
	Vt1dyNHTQnxaYQPw+XXItEP72l7VujaEcc7egDuQLVPIOSKgGPkoUVxGTPFIgs9x
	tfzGGjgZgFzlNJB3vGA0K7Ke5TAgV4RREsJQJhyzQQU9nQom5RTKINU/KfhKQJ5t
	Q==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FeAoW00fP_hj; Thu, 22 Aug 2024 21:37:29 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Wqc483PFkzlgVnf;
	Thu, 22 Aug 2024 21:37:28 +0000 (UTC)
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
Subject: [PATCH v2 8/9] ufs: core: Move the MCQ scsi_add_host() call
Date: Thu, 22 Aug 2024 14:36:09 -0700
Message-ID: <20240822213645.1125016-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
In-Reply-To: <20240822213645.1125016-1-bvanassche@acm.org>
References: <20240822213645.1125016-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Whether or not MCQ is used, call scsi_add_host from ufshcd_add_scsi_host(=
).
For MCQ this patch swaps the order of the scsi_add_host() and
ufshcd_post_device_init() calls. This patch also prepares for moving
both scsi_add_host() calls into ufshcd_add_scsi_host().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 43 ++++++++++++++++-----------------------
 1 file changed, 18 insertions(+), 25 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 6a3873991d2a..b9aaa3c55d17 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10404,15 +10404,27 @@ static int ufshcd_add_scsi_host(struct ufs_hba =
*hba)
 {
 	int err;
=20
-	if (!is_mcq_supported(hba)) {
-		err =3D scsi_add_host(hba->host, hba->dev);
-		if (err) {
-			dev_err(hba->dev, "scsi_add_host failed\n");
-			return err;
+	if (is_mcq_supported(hba)) {
+		ufshcd_mcq_enable(hba);
+		err =3D ufshcd_alloc_mcq(hba);
+		if (!err) {
+			ufshcd_config_mcq(hba);
+		} else {
+			/* Continue with SDB mode */
+			ufshcd_mcq_disable(hba);
+			use_mcq_mode =3D false;
+			dev_err(hba->dev, "MCQ mode is disabled, err=3D%d\n",
+				err);
 		}
-		hba->scsi_host_added =3D true;
 	}
=20
+	err =3D scsi_add_host(hba->host, hba->dev);
+	if (err) {
+		dev_err(hba->dev, "scsi_add_host failed\n");
+		return err;
+	}
+	hba->scsi_host_added =3D true;
+
 	hba->tmf_tag_set =3D (struct blk_mq_tag_set) {
 		.nr_hw_queues	=3D 1,
 		.queue_depth	=3D hba->nutmrs,
@@ -10650,25 +10662,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
 	err =3D ufshcd_device_params_init(hba);
 	if (err)
 		goto out_disable;
-	if (is_mcq_supported(hba)) {
-		ufshcd_mcq_enable(hba);
-		err =3D ufshcd_alloc_mcq(hba);
-		if (!err) {
-			ufshcd_config_mcq(hba);
-		} else {
-			/* Continue with SDB mode */
-			ufshcd_mcq_disable(hba);
-			use_mcq_mode =3D false;
-			dev_err(hba->dev, "MCQ mode is disabled, err=3D%d\n",
-				err);
-		}
-		err =3D scsi_add_host(host, hba->dev);
-		if (err) {
-			dev_err(hba->dev, "scsi_add_host failed\n");
-			goto out_disable;
-		}
-		hba->scsi_host_added =3D true;
-	}
=20
 	err =3D ufshcd_post_device_init(hba);
 	if (err)
