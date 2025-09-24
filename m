Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791C932B48B
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 20:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758746044; cv=none; b=NITqZ04604qp2I3Xq5bmCOS4+uJ3fL5hIY1nq7iyi0uz6zXsWszl+rr+InI9VohfCI2YRV1PEZdjsE8cjiM5DyqaA4eXgr08jlbmv4RgHMGpXYX/ABucCiiZ5g95d/LRdB5Me74TvNb1jlJSzHSW+2kSm8CG9/f3QPcqxLDC12s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758746044; c=relaxed/simple;
	bh=kVfGIFkBZLDHdEMxKNWfSL5CmYgvQx4YV1ZYi/s8F0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ohruZp1DM72ENiXuFKG06pB1yNjjnSsnun4uFdmiEzMdHBV3wCdPWqQN53GppZ0vnZ9SQCz2OCPTtR6WqypzKfGcLvQR5gv5/YTQekkSRlO0ifSU5zE2s6Z2/AfuSRTpefyxZOZ4JF8F2/V+Tg/INHZ+JbV1uZUK3b/r9MBlZko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=cmgCxnht; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="cmgCxnht"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cX7qF62lQzlgqVP;
	Wed, 24 Sep 2025 20:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1758746040; x=1761338041; bh=YmCkR
	ntx83zFbq9SbPNeYu/55NRdvhqIfW+L41DKNv8=; b=cmgCxnhtZiLvQVZJwDQSs
	TVA7pKM77BGMMuLaPYC/T5ZlH+fo8LWAD8bwBSiGsgZMf2iyrJ70j44B2o3FMvjB
	wa+fuzmxQ68dtZHGV3ugtYeMZo+M8gE4L01MMJImttG13IG9T3Mi6XT8b0Ev6YQA
	y70jgEDz9/hCEzj9rPuOXDk/hZJdjkuJv3tL4sRfAo3EpsZU0Jw8SDUj/PQVwTPy
	vlNL1K9uHfN0FotakEAhq8T1krTsrIPX5YrFZv8VeelO0NOLZO/DQcu0g6M6F9D5
	Xp/Zl7J5iEKo3oIg6NLC5gIEVp4MJnLBtPOENyx5esjaM2TG6nU5yUrq+YMPzFrR
	A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id nvqAzGst8gop; Wed, 24 Sep 2025 20:34:00 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cX7q80MP6zlgqyg;
	Wed, 24 Sep 2025 20:33:55 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v5 18/28] ufs: core: Allocate the SCSI host earlier
Date: Wed, 24 Sep 2025 13:30:37 -0700
Message-ID: <20250924203142.4073403-19-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
In-Reply-To: <20250924203142.4073403-1-bvanassche@acm.org>
References: <20250924203142.4073403-1-bvanassche@acm.org>
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
index 419f05efd566..7ea18204b5fb 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10581,6 +10581,9 @@ static int ufshcd_add_scsi_host(struct ufs_hba *h=
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
@@ -10731,7 +10734,11 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
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
@@ -10822,6 +10829,10 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
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
@@ -10872,10 +10883,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
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
