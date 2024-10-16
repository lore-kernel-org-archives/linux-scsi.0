Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0540D12E4A
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2024 20:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729109603; cv=none; b=AAuDMlxKtJuGZVh806mOj2kWKjuU4Ido04McqJR3XxZKv8W5jYy/9+ufffJU44TJhhAqSJUZBlqYPvSnXPY86MB/N6P1zm9l0ZwGflqIpc0f2ZgrIMI+BVqpRBjOfmKZ3MdYplqeyRpRnFqqZtbaLK/TUDWI/+O15nl+SM+vzCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729109603; c=relaxed/simple;
	bh=1u9W0UVV1kxoSTpzz5IgFEAL5FTGNwluT8g/j2VjMyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBN2gYWzGGO9fKGknjHz05nXRDU37ALG8sY2qviX/YF27wFoQ3qH05uy8LQGpUaOnD5Q/q3lGcoNT8ZXN1KDeEPZIDWQC9UHEwgqj9NCyv8MO3taZO2kew8xD8SAW2dxDm8h9uBRN0EtzM1SjT1qXL8cUJ/ntB/711Ro3uHTug4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=dMaRx0cx; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="dMaRx0cx"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XTMbj3hr8z6ClY9l;
	Wed, 16 Oct 2024 20:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1729109595; x=1731701596; bh=Qff3Z
	vJGx1Rk01P3Futdi2VhVug8QU9Lh1vOk6C4gg8=; b=dMaRx0cxbY9qkAzUqmSN2
	XNbiQrskKEjlcpUheeNgJF5JKnswQFNrsLxhWsBfk1TEX7vSYFWdZ1wG2z2QVMgl
	5mIpEzhdcqLBIYJ+OLhArupCbH1VnbdMCYRO2Uqpj7mMzemxqvNTT5C3ctaOnOP8
	6ctTxUXM3K8+JZNf7Va1pkhe2ob+qwr0J32D/QlTnW/cfGMjShxOUQoHYkHK7wfZ
	lObURgioZ9+UlWKVu4P7bmt21kKgQWZCGuGnmjxRzQ+n9pC97LMF7n5khOpkvCsJ
	3owt7uOUKdxN/7DTcSu8vNj1z4MLJ5n2ijZ3SkvT1p03kXt4+qJRgINLAeouoKQU
	Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id XedZKqiv-CUZ; Wed, 16 Oct 2024 20:13:15 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XTMbY21N2z6Cnk9T;
	Wed, 16 Oct 2024 20:13:13 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>
Subject: [PATCH v6 03/11] scsi: ufs: core: Call ufshcd_add_scsi_host() later
Date: Wed, 16 Oct 2024 13:11:59 -0700
Message-ID: <20241016201249.2256266-4-bvanassche@acm.org>
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

Call ufshcd_add_scsi_host() after host controller initialization has
completed. This is safe because no code between the old and new
ufshcd_add_scsi_host() call site depends on the scsi_add_host() call.

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 17c22e880cef..17604397aaba 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10572,10 +10572,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
 		hba->is_irq_enabled =3D true;
 	}
=20
-	err =3D ufshcd_add_scsi_host(hba);
-	if (err)
-		goto out_disable;
-
 	/* Reset the attached device */
 	ufshcd_device_reset(hba);
=20
@@ -10587,7 +10583,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem=
 *mmio_base, unsigned int irq)
 		dev_err(hba->dev, "Host controller enable failed\n");
 		ufshcd_print_evt_hist(hba);
 		ufshcd_print_host_state(hba);
-		goto free_tmf_queue;
+		goto out_disable;
 	}
=20
 	/*
@@ -10622,6 +10618,10 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
 	 */
 	ufshcd_set_ufs_dev_active(hba);
=20
+	err =3D ufshcd_add_scsi_host(hba);
+	if (err)
+		goto out_disable;
+
 	async_schedule(ufshcd_async_scan, hba);
 	ufs_sysfs_add_nodes(hba->dev);
=20
@@ -10629,12 +10629,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
 	ufshcd_pm_qos_init(hba);
 	return 0;
=20
-free_tmf_queue:
-	blk_mq_destroy_queue(hba->tmf_queue);
-	blk_put_queue(hba->tmf_queue);
-	blk_mq_free_tag_set(&hba->tmf_tag_set);
-	if (hba->scsi_host_added)
-		scsi_remove_host(hba->host);
 out_disable:
 	hba->is_irq_enabled =3D false;
 	ufshcd_hba_exit(hba);
