Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6BDE1863F
	for <linux-scsi@vger.kernel.org>; Thu,  5 Sep 2024 22:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725573785; cv=none; b=pJQxngs/6mr0h+dFyMGLRADcYoaAobYUNKiEDEmuOl61rwFs0h0aiNUpyJMi66w5MF5xGC//kVG2ITyxf3pvoFkfogVXjsqhQLb/sioF7l8+IpDyLhEHvrGNb3vKtf8fGpx1wmLn4zgo7ldxlm8r0jSwYGMI5w6y/sWoWOZtCSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725573785; c=relaxed/simple;
	bh=ss/sKEDXl3PmB7Kf0sDbFGVrbRVl9/VZmQoF8Ytem7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gBCHGhvEfHUvic94EAfKMhbNRS0H52BMVyTi5ZcsVdXRUCK68ikzG25/l11BOLedRNeyCe5KSsTRt6Dz1KFbyVqTcA0Bvlr/hnAXVodPRInqSHIChFYId5nPKMauHXDNQPZ8PWT2QSw+PtJt7fMZlne2XCrmMXbxVigHpEv7EiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=QpR5YigQ; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="QpR5YigQ"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X0CzC3Lnqz6ClY8x;
	Thu,  5 Sep 2024 22:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1725573778; x=1728165779; bh=FIIrY
	S+ctROYpXJeXdK6dBVc5uAUU3fdyEOTNy0DciQ=; b=QpR5YigQPGAlMIvQW9BEf
	Hi1ORMXlO+amIcrUYZGBn8CJ0TcyEpMdcm64lY8kGCHs10HkxXuG6Ufq5vTFWQ/J
	aRwEsKPAP8i1xi8vSlxqp0YZaKjdQYXY7GR2SS5c+uc69d2BqKYM9Ewkq/2CNQXw
	KHM1Xq4BYJEjlCl3DXljtQpKmimuhb5aT3ysjrHpKBVYLtMnwj33NafHdWKSqpTh
	9cZInj1x6zw/YZMAgjolYvC8AAefuiX4HgFdJ2r52SaVNVj3NAmr0Nv/kEMz4rnV
	hcvU/aPaA88osuEU4f2LOGBn/Lbrj0NzI47lkiNY2bNsGn7133S0wWtbor9fCcJr
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fk2Jbw-CY91u; Thu,  5 Sep 2024 22:02:58 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X0Cz56fLFz6Cnk98;
	Thu,  5 Sep 2024 22:02:57 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v4 08/10] scsi: ufs: core: Move the MCQ scsi_add_host() call
Date: Thu,  5 Sep 2024 15:01:34 -0700
Message-ID: <20240905220214.738506-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
In-Reply-To: <20240905220214.738506-1-bvanassche@acm.org>
References: <20240905220214.738506-1-bvanassche@acm.org>
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
 drivers/ufs/core/ufshcd.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 014bc74390af..b46e9b526839 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10379,7 +10379,25 @@ static int ufshcd_add_scsi_host(struct ufs_hba *=
hba)
 {
 	int err;
=20
-	if (!is_mcq_supported(hba)) {
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
+		err =3D scsi_add_host(hba->host, hba->dev);
+		if (err) {
+			dev_err(hba->dev, "scsi_add_host failed\n");
+			return err;
+		}
+		hba->scsi_host_added =3D true;
+	} else {
 		err =3D scsi_add_host(hba->host, hba->dev);
 		if (err) {
 			dev_err(hba->dev, "scsi_add_host failed\n");
@@ -10623,25 +10641,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
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
