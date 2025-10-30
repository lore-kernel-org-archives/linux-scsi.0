Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD8B1482F2
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2025 19:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761853215; cv=none; b=Vao4i92n9XixmAClPAW3efXL2xu/8SA1guDp9A6ElI18w/SeZxaERJzbW470IUGtG3aEXstCB5zQrY5qtQMEGzxCb9wsenQhR832N0sTx5z9QdGY487KpPQ/Hxhtr7/1uL7pjsit2UFdbXBZtY0asyLF9l298QnHHDSM3xzEJ5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761853215; c=relaxed/simple;
	bh=QDqfRTaG2HYnnJcRqVZHUAzSrR9gVW/CdgV+OUl8Thk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dqG5spghIne3y6da2QyOnFCTTtBh++DhhEshzycbxpxiVM/BBPt6dgsDuJXujU2hwEZA1TgFXAwZ07IVF8TtyzYdpNlTylV9a+xiZaTer4kYKYejMPOEc+Z754D1Ru2VGUHBNI6WnXuXPfcieMHf5qeTUob66fB04Ed72Bmjfow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=K/X/0SeG; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="K/X/0SeG"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cyDwY0FP8zlmm7l;
	Thu, 30 Oct 2025 19:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1761853211; x=1764445212; bh=/ajQp
	inFf13MLYxpNUe48xRy5UR+URiLycrE/AV0hl4=; b=K/X/0SeGTGWw1YTg8M/Z3
	vFMdDbHqyGMlcVuZTwi8HHAJkTEg4SiHRdOv2b7cKGMlDDuCrMSTYoafiqpo0vJQ
	av61b8aoywYkc7YOJAxcMtj592OvYNcC7Y/OlOXFuZxGL10Brm/Sxoef9/99HvAj
	UILI/vScJtXETGp2l5E+hEskwpbDNF0gRc01zvv6vFhUi+XYfet8PbLiBLqNwJ9x
	LYX1UA6js4uyJ9Xi1d5X3PsXBEJpXxrc23nNVaQiZFQUGK0jJsDSsOpy4d8ZIzW2
	Z2gxA1ugrEUi2SlCz2GwwS84NnuWFkSHmmGE1mdoeuECemZhbf4UEfTReMizY/VQ
	w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id oM2_GFumD6UZ; Thu, 30 Oct 2025 19:40:11 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cyDwP1D5szlpTG1;
	Thu, 30 Oct 2025 19:40:04 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v7 18/28] ufs: core: Allocate the SCSI host earlier
Date: Thu, 30 Oct 2025 12:36:17 -0700
Message-ID: <20251030193720.871635-19-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
In-Reply-To: <20251030193720.871635-1-bvanassche@acm.org>
References: <20251030193720.871635-1-bvanassche@acm.org>
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
index 93f2853ff5df..7935aad4ca13 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10605,6 +10605,9 @@ static int ufshcd_add_scsi_host(struct ufs_hba *h=
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
@@ -10765,7 +10768,11 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
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
@@ -10857,6 +10864,10 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
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
@@ -10907,10 +10918,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
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
