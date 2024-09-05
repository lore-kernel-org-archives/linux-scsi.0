Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF9B198838
	for <linux-scsi@vger.kernel.org>; Thu,  5 Sep 2024 22:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725573788; cv=none; b=URIwxXHUv1CMgBi2nuagr1Dz5g5Bb0d3pIOB2qp8AegyPWfatQ3nC0l40bj3F1LZGcM/++XUwGFYw4gS8VdHGDyVTTDfKkk/2Fe4YkE29AkflhqOlxSLAlI4pQ1W4D4tqRnt9tgaoLp0YJVbopFPuVthJb/DmjE6lC5Vd/gtuNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725573788; c=relaxed/simple;
	bh=vxAG7YELlPYdZmgLTddKtvaVXspoeadGd9t3Rr0aU6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CT2LEdE/+g7Iaio/gxE4daIHwgAGdYoiFLXJA8JiEfBMpbd73v5Wg2FHRZ9VP+JeveBmeccXZ78QWNNb24MM3G6owr6P4FK7PVr0vxjKIqy+r4JhD5uzEqXbh+gutFBE6YuplsMj5ztYE1C4k6venXIsH/YVcsqcLISVxLg3AwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=gpYyIQVo; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="gpYyIQVo"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X0CzG7247z6Cnk98;
	Thu,  5 Sep 2024 22:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1725573783; x=1728165784; bh=d+ZU2
	WmW7NTrSQcCm6ZsMaG+tRWsQFzTqNS4phBgSJ4=; b=gpYyIQVoKIU8MylgMgb8e
	9/Naw6o+NvlJuCYv9zoh9klbjAz02/uISVt/rehGCBocpJJyWvKcrJSAcg10JLgU
	eRE1pth4dzFUD78iYYmelkBtE9OXkyUmzuvxEAIfKC1BonpYIdDsSVU2x/D9oTWb
	x7BAL8Z05I/R/+CKr05jOzYlcbhK7ywKc44wHi9qdtFGnetP+aob5Zx6095ZWVpV
	XgZJvxOJKqCTvoiK0aWL1O2mJwfSueoeTD+FtZ/t0xl81SgSQC6vbQGvpnttNags
	P4sPPqqsfnJ6zWVBVRYDS0yd9QRKNlqi+cyhXoK3KX7j2w2LgdvH6thR06lwlH6N
	w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id nujMH__VdhU8; Thu,  5 Sep 2024 22:03:03 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X0CzB4jC6z6ClY8w;
	Thu,  5 Sep 2024 22:03:02 +0000 (UTC)
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
Subject: [PATCH v4 09/10] scsi: ufs: core: Move code out of an if-statement
Date: Thu,  5 Sep 2024 15:01:35 -0700
Message-ID: <20240905220214.738506-10-bvanassche@acm.org>
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

The previous patch in this series introduced identical code in both
branches of an if-statement. Move that code outside the if-statement.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index b46e9b526839..17615b56e83e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10391,21 +10391,15 @@ static int ufshcd_add_scsi_host(struct ufs_hba =
*hba)
 			dev_err(hba->dev, "MCQ mode is disabled, err=3D%d\n",
 				err);
 		}
-		err =3D scsi_add_host(hba->host, hba->dev);
-		if (err) {
-			dev_err(hba->dev, "scsi_add_host failed\n");
-			return err;
-		}
-		hba->scsi_host_added =3D true;
-	} else {
-		err =3D scsi_add_host(hba->host, hba->dev);
-		if (err) {
-			dev_err(hba->dev, "scsi_add_host failed\n");
-			return err;
-		}
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
