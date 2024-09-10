Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BB316C854
	for <linux-scsi@vger.kernel.org>; Tue, 10 Sep 2024 21:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726005193; cv=none; b=swpHtNQYY4+BkbLzKBAVH2+o5YxFw7iDUDagH/JKZhoJgrdvylZVIPQyPxE6i8MD/hMRpWWsjunViVFeht0L5GLkaMcDDMN6LnVrfa51RnIuxyvJhEgMI0Qfj1uaXH6+J7CJwnBuBqSwcH6NXMStNrpjeRN5lGqc88Weg141mOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726005193; c=relaxed/simple;
	bh=0SdYyNklTWMjUNeGd2bfwc8KjT1wUihB7YLNEUN3zjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kPimQyMqgPhx9+rPvDHIDoB7Zpm1Ay3NWMqc/PzDnj9E8WvamxBwEe4qUY9RgvySYyuEHskLPoU+px62A+dYUl7WID6IHC2n+lKIDKVy5h9AjYMRDKvzlD5PXyHC4mfw5KxisPfHKQOtX2GT9oH0uE4PzjMHkSwimkRPun39Au8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=XKtOS82q; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="XKtOS82q"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X3HWW56GFz6ClY9H;
	Tue, 10 Sep 2024 21:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1726005186; x=1728597187; bh=j4boG
	iLUFUuN9zSPBCgUzs66zsHPCZMQitRzINFsoUk=; b=XKtOS82qiMf5JLR0Qyjzm
	YieUrWSAYHczXbwSI6t0Uue0Rck0lMHD4Vb4umGRbN0yqaay45pKAkt0jsU8IVi8
	0q/HMhgoRIZzc9y/CKf2sbrxrw3ckuKuy9iZEN0Jl7FoM3lTarxw1zyFJ1Zg/JgJ
	+YzAVopach5Lcoc+sn+7HvK2RqG2yk1qg53pFqSSro39NgYa0gY/jm1LFGgaAdeI
	/SSnOtwl1eQxbGDvoOZ6lVSORUA7OiNoFX6scrVRns9P9Stv1MRw6nKKuR6EonoZ
	Xbvj8KmaGtjsxTvxixLglBVSnBRMT3KmiFl/XP3PgQIy6jPcKdEvfVcvqGCOE9D9
	w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 5keeQAZiK88q; Tue, 10 Sep 2024 21:53:06 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X3HWN42rgz6ClY9J;
	Tue, 10 Sep 2024 21:53:04 +0000 (UTC)
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
Subject: [PATCH v5 09/10] scsi: ufs: core: Move the MCQ scsi_add_host() call
Date: Tue, 10 Sep 2024 14:50:57 -0700
Message-ID: <20240910215139.3352387-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
In-Reply-To: <20240910215139.3352387-1-bvanassche@acm.org>
References: <20240910215139.3352387-1-bvanassche@acm.org>
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
ufshcd_post_device_init() calls. This patch prepares for combining the
two scsi_add_host() calls.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 40 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ce4f9c8554c3..8e4e25da9a6f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10366,7 +10366,25 @@ static int ufshcd_add_scsi_host(struct ufs_hba *=
hba)
 {
 	int err;
=20
-	if (!hba->scsi_host_added) {
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
@@ -10621,26 +10639,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
 	if (err)
 		goto out_disable;
=20
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
-
 	err =3D ufshcd_post_device_init(hba);
=20
 initialized:
