Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDAC12E4A
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2024 20:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729109630; cv=none; b=JjBVHyMiMguOYUXIHSwXMhcgOF7dH0t1Z+Ww2g5nMWDDeFKqMhO3JzgzZAhM4rKFYoZiXUsc4KcAc4bWVLbGy3b7sDJ8VvO70GSXGenCm52blIH1RQrXBAwH9L711fudXBrjH+bi0P9yiglUUoxAtRhmfu7/HAowyCyj8fWesRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729109630; c=relaxed/simple;
	bh=fGM2q4jbIeIYvTnf9cN/S7IQXUZFQM+jGIJGHI6SoXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nHs6hN8bKBmUDifowoNBRzF9mlphmJ9TUteDbSB7ZFP2swpFOTGANckYTaEOhyDJWHRTBQMsAnvHLr27uRIoQidq8YwT8CVrg3u70/jYIt+aX5J51jOB8Vd7DOj16stHREB5PRUfrcfxMAz9cfPoRSDn4bFTFA2rQwnXgODV0gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=oJiKwPh5; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="oJiKwPh5"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XTMcD4YPwz6ClY9l;
	Wed, 16 Oct 2024 20:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1729109623; x=1731701624; bh=ri7JD
	4f1O0MmRZ9rEvuXjVcJHtBUCL03CLsP40e53b0=; b=oJiKwPh5RG7v5q5hmHUMu
	yzGnQ8RmYrkp0EoZiDkLvFDTTf6+vw2LLICVd4fESltoG5KIWUhZ+bqfU8W+2tyc
	y5Bsb7adsu8VckD2mRQ8o9MddK/oScaFSVS+iI62/MkI3TW23amj7SOdPpX8lhba
	6rpZJ3h+RxXR9K48GOME+cvhFgqCIUXci/DAlwA4FXOQR3WJytZuNbRyt7x1JlSH
	8VwEsiI1TaSSafbrudtADms+iPl0W8cgY/3McMP5avgVz5AbNtiavttspmmwrh1q
	TvLo8bZBQ0PQypekA4lAGXakxSnXyucM47KMWg+H4ZjdzeH2iNVhLiFyjnzSiYYi
	w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id cxzDoEE8FHt8; Wed, 16 Oct 2024 20:13:43 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XTMc60dGvz6Cnk9T;
	Wed, 16 Oct 2024 20:13:41 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>
Subject: [PATCH v6 08/11] scsi: ufs: core: Expand the ufshcd_device_init(hba, true) call
Date: Wed, 16 Oct 2024 13:12:04 -0700
Message-ID: <20241016201249.2256266-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
In-Reply-To: <20241016201249.2256266-1-bvanassche@acm.org>
References: <20241016201249.2256266-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Expand the ufshcd_device_init(hba, true) call and remove all code that
depends on init_dev_params =3D=3D false. This change prepares for combini=
ng
the two scsi_add_host() calls.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 56 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 063b87be23e9..d09aa3763f88 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10637,7 +10637,61 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
 	ufshcd_set_ufs_dev_active(hba);
=20
 	/* Initialize hba, detect and initialize UFS device */
-	err =3D ufshcd_device_init(hba, /*init_dev_params=3D*/true);
+	ktime_t probe_start =3D ktime_get();
+
+	hba->ufshcd_state =3D UFSHCD_STATE_RESET;
+
+	err =3D ufshcd_link_startup(hba);
+	if (err)
+		goto out_disable;
+
+	if (hba->quirks & UFSHCD_QUIRK_SKIP_PH_CONFIGURATION)
+		goto initialized;
+
+	/* Debug counters initialization */
+	ufshcd_clear_dbg_ufs_stats(hba);
+
+	/* UniPro link is active now */
+	ufshcd_set_link_active(hba);
+
+	/* Verify device initialization by sending NOP OUT UPIU */
+	err =3D ufshcd_verify_dev_init(hba);
+	if (err)
+		goto out_disable;
+
+	/* Initiate UFS initialization, and waiting until completion */
+	err =3D ufshcd_complete_dev_init(hba);
+	if (err)
+		goto out_disable;
+
+	err =3D ufshcd_device_params_init(hba);
+	if (err)
+		goto out_disable;
+
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
+		}
+		err =3D scsi_add_host(host, hba->dev);
+		if (err) {
+			dev_err(hba->dev, "scsi_add_host failed\n");
+			goto out_disable;
+		}
+		hba->scsi_host_added =3D true;
+	}
+
+	err =3D ufshcd_post_device_init(hba);
+
+initialized:
+	ufshcd_process_probe_result(hba, probe_start, err);
 	if (err)
 		goto out_disable;
=20
