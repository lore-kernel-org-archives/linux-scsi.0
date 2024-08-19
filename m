Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAEA1DD3B5
	for <linux-scsi@vger.kernel.org>; Mon, 19 Aug 2024 22:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724107926; cv=none; b=llx/iDI5sr8sryGbUZAKhEyrWJoxiuMhxg8iLkLDyR9KPr/I3uCXenWMiMbvjpdy9tFsoQRhJTcgkJp+0LWgjCy229t1VucnKnreKhGrpde0BwrW1n1XdH27sZWitCRXxCyFCUFR9ZBOJVOMav6dCZICi4UDy5gMRNe1l+euL0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724107926; c=relaxed/simple;
	bh=QlrZSTGvkrogyPy2k1dzpotDHSuS2TmdZtfDXjJn77Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BN7QqJvduXzBNtPNPSY8PyQJ+EFC2yBeANnLMN/qhvGCiLW3QSV2dMTy/dg0aW5s1gzVLhjRteqWUWoetVTbHp7cXiow2gGEzj8cqyOq1JMyMTVV7fF8vK/IQHuJY8bbZji9VHa6Mkf1Ru0eh2wEi0rDuV/EupC/a+knC45qWT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=krysSZj8; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="krysSZj8"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Wnnsc4NGmz6ClY8r;
	Mon, 19 Aug 2024 22:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724107920; x=1726699921; bh=0cnm8
	v/dUyGqva6tz1T3n9d8ekdZh2e/wxznsOntlXo=; b=krysSZj8rHj7EGs0EKz/N
	tWd6ksZZi4Tueb7hm4wSKo97OKd6PKtyGU0+AdL2In+OebPdlVtU5xvC2f4T0Guj
	52ZksmyXzKKEUH/6tdrk4myQ1kt/qBEwihdnXEJ1J9WUQ5cYSjKKtc9xhnaKxs1f
	Jzb0ypa3PPF7NRG+GkDCB2k9kt7Kr/oWaKSMe0WEgHfCipFrV1bUw9f/FAAL9cRC
	0oVjxeZZRnGYIEBl5UCTvMCfT5XuT6bMKuFHCR/2KBi/Lg3Nc2yOsMZX/Y3pgMvM
	X8D33ofOFJPegLBWoNnV3NiD8HK/2+2AbHCI0CEZMiByk5nv6Esye5jka6co9sHh
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id IbTIta5E44qL; Mon, 19 Aug 2024 22:52:00 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WnnsW2j69z6ClY8q;
	Mon, 19 Aug 2024 22:51:59 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Avri Altman <avri.altman@wdc.com>,
	Bean Huo <beanhuo@micron.com>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH 8/9] ufs: core: Move the MCQ scsi_add_host() call
Date: Mon, 19 Aug 2024 15:50:25 -0700
Message-ID: <20240819225102.2437307-9-bvanassche@acm.org>
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
index dedbef27d5c5..b3fae37e4f6a 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10402,15 +10402,27 @@ static int ufshcd_add_scsi_host(struct ufs_hba =
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
@@ -10648,25 +10660,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
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
