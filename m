Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7FEB2BE02A
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 20:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760473219; cv=none; b=PhkXRoX0NPxUVaPpfQazZa6dD0FRYaafBojYc33MD8NQSR25x9nDZM6SQl5ru9UyjU9yMtpVTNqHkemcJuEsSNAumokWwLD/mNZawPe/cptWyywex2KxjhhQnl6EoL1384rv2yufhjo4PFFs0py0w31rQMnWCXYabNK19/wi1d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760473219; c=relaxed/simple;
	bh=kVwwlEJaZNfTe6GuxG7N95xCO4qNS4Hyzp1YSYMAY4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpE10+ur/Uirxdp1JZI3k2+IKKkdrcGPLvLkjdATfEONxKSkrBrCRHLHETAhJl3oesMR41ThosJC9suwCqBVzMU6voVjb4O2O+5B115g70vl1v1JDI7gVKFUTvDnXEdr9EWvAbBweWwqZMSxFbb9uXVJpAoMtcpeOTC1dDXgjd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=oehmr6n8; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="oehmr6n8"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmQZ85FWSzm0yTq;
	Tue, 14 Oct 2025 20:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760473215; x=1763065216; bh=HOBzM
	SlqAibWUpMY7niTxU4n1OapMoz1EJ+nsWvdK6c=; b=oehmr6n8V4ibPdIv+eP08
	CDQEGWPZXs8qGss1W1te1EwBDSxYYHoFLVHhsC8d00TKoQYLFLzAKTF2zRa2EimS
	TZqALGrWazaimY58ZIWRgbSrt/Gn2DRGMA/EBNmx/2XiJ1uylruX+XNfAO3hWDkZ
	Ey3Ayfi6KA3xMl8hpCIySv7nQef2RQvjQD/Imlt0wijMix2HeujUzT2DlIRai3u5
	q5okheSFvglDMlqoCXH71mGhUL49fk8L5UHe+5UBcmDgUgkGWKgKevYlxAHcvT4s
	UD0WJzftsSsFEv/Mof44dygzgWQ+d6XeNb70RxFbnrBWrltXSd44ZIfhUUIxZgjX
	g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Y8jOUE_4a3dH; Tue, 14 Oct 2025 20:20:15 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmQZ26yktzm0ytH;
	Tue, 14 Oct 2025 20:20:10 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v6 18/28] ufs: core: Allocate the SCSI host earlier
Date: Tue, 14 Oct 2025 13:16:00 -0700
Message-ID: <20251014201707.3396650-19-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
In-Reply-To: <20251014201707.3396650-1-bvanassche@acm.org>
References: <20251014201707.3396650-1-bvanassche@acm.org>
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
index 696837b031b9..a7e4aee959df 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10602,6 +10602,9 @@ static int ufshcd_add_scsi_host(struct ufs_hba *h=
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
@@ -10755,7 +10758,11 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
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
@@ -10847,6 +10854,10 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
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
@@ -10897,10 +10908,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
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
