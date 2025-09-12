Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B0A32ED36
	for <linux-scsi@vger.kernel.org>; Fri, 12 Sep 2025 18:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757701642; cv=none; b=IBB5lysLcnxj7TghMGvg6VHzzRRtglMi8MhQACcWzKkt2zujA27fnGGyvUWGaxlvSXmKJBfDbWOQvyzT3OwxHCGqBS5FB3jE/K5LISQgvc1L2te74OsrJF3uOF8Uwa8KBLjIqwXFXU1fw7AExZ8cc/bCtpa2juHP+US/RYauF3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757701642; c=relaxed/simple;
	bh=KrE+yPH0SwTlyC5RQr3mXUcoKthv9+MVXi3vOlMJUbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OB84W/siIdm6NHi2gshK2Lp0sNvP6OQHQib9bVfzc0XZMSqHyb17BqqUATv+FZfv6YxoK4kJfXZB8xhNNbigOKBiNSbcNAbLMpZ0hyVCgOofHqauv8vCBKAKOhQok+kKI3BtM9kLjAVDZmRdxXYo4zcXTY+CRyZNIW/RJ4Q2/nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4VYOc51V; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4VYOc51V"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cNjZb66XmzlgqVx;
	Fri, 12 Sep 2025 18:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1757701638; x=1760293639; bh=r5lkF
	WZbUMg1bCy0HpMTL2CqPJCwSeHfd5JZqxHT6/c=; b=4VYOc51VmP8YXkZVe+TYu
	c+n3nekIutMfRRjc5WaZJYUSORJPwBWeZ0Dr3TRb5wMPL77cbLxYrs6ApLtk+Wq6
	lJi/OdSSHDqn9hiFQ1PgpYZOszy3dyApHu30bl4XlohWJQmvby1v1IXt5QFtFNNS
	1AKhSjSI6SFJS83Chm+/3zuGxZiUmSH3tntrRV7mzll5rquUHm2nhFllk2efvRfH
	+sl9xxd3qtQZH5vWjejiAwQMsRpI5V7sClT9xRJSyYX/0/frzPIpAyKenZxtudf0
	lGQj+YMXz3n0h4NYYJ5PN3aGoFJcrk7eo/c3PN2z5ItQjKaVTeZX3UKmSfowcOkF
	A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id lpmp-QqJSQdw; Fri, 12 Sep 2025 18:27:18 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cNjZV1V7nzlgqTs;
	Fri, 12 Sep 2025 18:27:13 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v4 18/29] ufs: core: Allocate the SCSI host earlier
Date: Fri, 12 Sep 2025 11:21:39 -0700
Message-ID: <20250912182340.3487688-19-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
In-Reply-To: <20250912182340.3487688-1-bvanassche@acm.org>
References: <20250912182340.3487688-1-bvanassche@acm.org>
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
index f54599490c86..161d54a532fe 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10577,6 +10577,9 @@ static int ufshcd_add_scsi_host(struct ufs_hba *h=
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
@@ -10727,7 +10730,11 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
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
@@ -10818,6 +10825,10 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
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
@@ -10868,10 +10879,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
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
