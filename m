Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BD51367
	for <linux-scsi@vger.kernel.org>; Wed, 27 Aug 2025 00:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756253478; cv=none; b=dPKYY3ACw11bAs0fBFvtgPKp64cCx7WdufciP5dSCTb46QoBXm5sxSl1+cFmL+fzM9f6raVzudAH4ZBQ+sLpOV8fl4xiQpOfHSVsvSnUzesFRnE1t6DPJqGKMuZ2P5hxJ6DRxMZCIdxhG9LSkxOfJiSWR2n5T9v9+v44HWpJdCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756253478; c=relaxed/simple;
	bh=q+fDpHGDP4GHk8uhjYql1PHrtEnfk/eOX28OxJodhtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JB+feKgym8NVQJJlKuu8xG/mAZJ8j7NFmhUeIg1LFSutKeopFREyXbCWS336Fv0T83uxMTspHrWiZ+W2HZdBotTRacO5pL5qp1XGFVmCWVzPsM5Hv1HcKeoBBJ5T6OpK0xssfgdqH+nYwtaqxnRa+qZGKD+wE3OwSuLu3BrBIqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=YYUEZ+Mc; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="YYUEZ+Mc"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cBQ1F2YBJzm0yQq;
	Wed, 27 Aug 2025 00:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1756253471; x=1758845472; bh=4gkAz
	145QvuZLuHCjHmQTCOPy+Z6eFpcm+MDzevbZiI=; b=YYUEZ+McIDaeRbLPjq7zt
	ptce85MWiFJJwrhlWM3W+tsLSoK9AsO2ga7m+n/pOJ/GJBqhc1KNYvZVsU1V/xkD
	/NEDy8cfOS253vJY88vns7VGgDxYXHvDsvMo+azMK4Hpgdpkmb+nyjQYt9I+nuLp
	Lrn90WPxZUsxmE1+E5Cc5ESS0tO4DAJwgFk8aXhON+qil/SR9cTP5YnmIZ3IKg5J
	1yc8Hvkti2rRQKRBlOwJu1DX6cAkxn1sE1YpyzxMnCq9EuJAY5qElEiHikpR0gQ1
	AB0l++TNsBX0T88nkAcC4EF4+Oi+vyUo8szjweoS3zRi+IrlbKkoXBg7fd8O+sOo
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id k7CO40dzpr0G; Wed, 27 Aug 2025 00:11:11 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cBQ174pSfzm1742;
	Wed, 27 Aug 2025 00:11:06 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v3 17/26] ufs: core: Allocate the SCSI host earlier
Date: Tue, 26 Aug 2025 17:06:21 -0700
Message-ID: <20250827000816.2370150-18-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
In-Reply-To: <20250827000816.2370150-1-bvanassche@acm.org>
References: <20250827000816.2370150-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Call ufshcd_add_scsi_host() before any UPIU commands are sent to the UFS
device. This patch prepares for letting ufshcd_add_scsi_host() allocate
memory for both SCSI and UPIU commands.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 4eb6bac4d8a2..5b3534fa601c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10576,6 +10576,9 @@ static int ufshcd_add_scsi_host(struct ufs_hba *h=
ba)
 {
 	int err;
=20
+	WARN_ON_ONCE(!hba->host->can_queue);
+	WARN_ON_ONCE(!hba->host->cmd_per_lun);
+
 	if (is_mcq_supported(hba)) {
 		ufshcd_mcq_enable(hba);
 		err =3D ufshcd_alloc_mcq(hba);
@@ -10726,7 +10729,11 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
 	ufshcd_host_memory_configure(hba);
=20
 	host->can_queue =3D hba->nutrs - UFSHCD_NUM_RESERVED;
-	host->cmd_per_lun =3D hba->nutrs - UFSHCD_NUM_RESERVED;
+	/*
+	 * Set the queue depth for WLUNs. ufs_get_device_desc() will increase
+	 * host->cmd_per_lun to a larger value.
+	 */
+	host->cmd_per_lun =3D 1;
 	host->max_id =3D UFSHCD_MAX_ID;
 	host->max_lun =3D UFS_MAX_LUNS;
 	host->max_channel =3D UFSHCD_MAX_CHANNEL;
@@ -10817,6 +10824,10 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
 			    FIELD_PREP(UFSHCI_AHIBERN8_SCALE_MASK, 3);
 	}
=20
+	err =3D ufshcd_add_scsi_host(hba);
+	if (err)
+		goto out_disable;
+
 	/* Hold auto suspend until async scan completes */
 	pm_runtime_get_sync(dev);
=20
@@ -10867,10 +10878,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
 	if (err)
 		goto out_disable;
=20
-	err =3D ufshcd_add_scsi_host(hba);
-	if (err)
-		goto out_disable;
-
 	async_schedule(ufshcd_async_scan, hba);
 	ufs_sysfs_add_nodes(hba->dev);
=20
