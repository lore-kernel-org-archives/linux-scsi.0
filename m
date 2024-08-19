Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A461591FC
	for <linux-scsi@vger.kernel.org>; Mon, 19 Aug 2024 22:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724107921; cv=none; b=OI7ocqff4rsAr2uRm7HvrVAnXgwjHJnXF7Pj1vGKXhoPessB0gjogGSj6LhT9V2YIr33Ro3MmKGTNQsbGbLo4wulAqS00bRPLj0Hm4qQsp2YtIcKxtKLirRKsfImtFCBDUJpRxqlv6CIvR/rguHxI1KVP5CfclzK5W9qQjpb+CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724107921; c=relaxed/simple;
	bh=U7/18uJ6mNK8+gtQLT5rsKnyoNdAbrmgZczE7P3LwCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KARkZ78XgtDkw47m9uJNzo2ZUh38ZiZtRE/Q9O73eHmukhFcR4fjNWm6CVntO3j9OSUBDACQvS7BmPwiGWU3Ju70eXrefYlhxqxsuERCOAgxWWN8aM9VSEWqSD/u3Jpe+R6nXsf5nc+EcnbhNPAsh4qUfdNeoG0gm6N6R0boNYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=TApmRYvX; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="TApmRYvX"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WnnsW3Jfrz6ClY8r;
	Mon, 19 Aug 2024 22:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724107915; x=1726699916; bh=Brw7m
	6CYsyNkQ/LP2ADMUT+fY9pzvby5wp+YSq9gXJg=; b=TApmRYvX5b/USmayjBczP
	14dC0QLGHs9w5omyVLph2mh3IIJik5oNPOIdQP6zJb1v2XGyqJAn6ja87v1h//28
	v+MAj78JTbF7JEucD2Zof9LkS17Nvr6aXuPA+SWP0Z2tsbQVbp+Yi78Ct10cpXAo
	U12guzn712S8vJar595rgzp+1BYjtfSIW0DXm6ZK+2+1FXooQGvQxgI6CTVKG/yf
	lWnSTekTfQ6FXTrhZbqiQBFCYCtalLBReC26I+pE82nqJwDFJq7cO7WUFtSjW2k/
	L9fDp+ES63oD6W8eeUq8tJ50r9GX57xfkmmtbKxuTeTRYGrUfHrDGxHOv1zgAaPi
	g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id xLVHxP-kkLmv; Mon, 19 Aug 2024 22:51:55 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WnnsQ2VPvz6Cnk9X;
	Mon, 19 Aug 2024 22:51:54 +0000 (UTC)
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
Subject: [PATCH 7/9] ufs: core: Expand the ufshcd_device_init(hba, true) call
Date: Mon, 19 Aug 2024 15:50:24 -0700
Message-ID: <20240819225102.2437307-8-bvanassche@acm.org>
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

Expand the ufshcd_device_init(hba, true) call and remove all code that
depends on init_dev_params =3D=3D false.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 44 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2754f496d10e..dedbef27d5c5 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10627,8 +10627,48 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
 	 */
 	ufshcd_set_ufs_dev_active(hba);
=20
-	/* Initialize hba, detect and initialize UFS device */
-	err =3D ufshcd_device_init(hba, /*init_dev_params=3D*/true);
+	err =3D ufshcd_activate_link(hba);
+	if (err)
+		goto out_disable;
+
+	/* Verify device initialization by sending NOP OUT UPIU. */
+	err =3D ufshcd_verify_dev_init(hba);
+	if (err)
+		goto out_disable;
+
+	/* Initiate UFS initialization and waiting for completion. */
+	err =3D ufshcd_complete_dev_init(hba);
+	if (err)
+		goto out_disable;
+
+	/*
+	 * Initialize UFS device parameters used by driver, these
+	 * parameters are associated with UFS descriptors.
+	 */
+	err =3D ufshcd_device_params_init(hba);
+	if (err)
+		goto out_disable;
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
 	if (err)
 		goto out_disable;
=20
