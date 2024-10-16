Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A6A216A2C
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2024 20:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729109645; cv=none; b=bPE3B4A2ymUN9ZmvqD0J+kCVRW3mK42shPb3SWQ4UAd4lGMLYvU8ufWafFIegODcxrJQR8nZRs6X7QnDjdAd6KSBWVW3IATdIs2IcVoGFgtmR74Uj5emwAKQ0zopOX9pqKdGyC4l5OOGWBTupSPBO+3Vt/PoI7MvheQIeWFJQUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729109645; c=relaxed/simple;
	bh=cYV42VxVhY5kL8e2T5dqcRDubzKO90rYMF9KTubK/pQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DMXpPXJg5Wbt97hT4uNhPeBhzv11mWJpZF8lCMQqqhUsMRQ2qoEm9rw6LVKG8r8+Hnvj02dHGIYb4mAO90y/FBOric9zBD6mQyXoddUL9r5mSOHasoVMaYOIkmGfr7MgaXQfgI/h/6RC90Qa1GV1azZJUpFtRA1o9de+qmE7yG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=JEvW8UlW; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="JEvW8UlW"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XTMcW33Pnz6Cnk9T;
	Wed, 16 Oct 2024 20:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1729109638; x=1731701639; bh=me3Sb
	bjeBlWKgZJa41qIV0pALnmHH9ZVDS9G/r1+FTU=; b=JEvW8UlWbKXuWG2bfCmi/
	n5S14cN8j9SX+h6qCrtSH4m/tAaphLBHg6p5p2mGgLCfC9CmwOFusbp0vnLOWlh6
	Y2wSDeCGVfPV1wrd4O0UOuUhLhar8EObVoy6u5qTdInbK4w2pzaLRzFtQkNXlmKR
	70E3YF4uHNwVsnjb2C1A/CVt1LQiVt6wL0QN/Mu5qFT+ioZW1lJqGM2WexsIwsG9
	mVg4Th223QYAUTW+0XmwfZjtgEgA78xmXxxfx52ItpLfaX1hN91kII3eaNIQw9it
	NHzVZmst3r/ys23NH47bS54NyXFTEhYGAlaCwbmH4CYcWzi/Siwtntq36rltsA6q
	g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id L6hiy44is_jp; Wed, 16 Oct 2024 20:13:58 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XTMcP2sGqz6ClY9d;
	Wed, 16 Oct 2024 20:13:57 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>
Subject: [PATCH v6 11/11] scsi: ufs: core: Move code out of an if-statement
Date: Wed, 16 Oct 2024 13:12:07 -0700
Message-ID: <20241016201249.2256266-12-bvanassche@acm.org>
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

The previous patch in this series introduced identical code in both
branches of an if-statement. Move that code outside the if-statement.

Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index f34563e3a51d..70d89e154c4f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10400,26 +10400,20 @@ static int ufshcd_add_scsi_host(struct ufs_hba =
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
-		if (!hba->lsdb_sup) {
-			dev_err(hba->dev,
-				"%s: failed to initialize (legacy doorbell mode not supported)\n",
-				__func__);
-			return -EINVAL;
-		}
-		err =3D scsi_add_host(hba->host, hba->dev);
-		if (err) {
-			dev_err(hba->dev, "scsi_add_host failed\n");
-			return err;
-		}
-		hba->scsi_host_added =3D true;
 	}
+	if (!is_mcq_supported(hba) && !hba->lsdb_sup) {
+		dev_err(hba->dev,
+			"%s: failed to initialize (legacy doorbell mode not supported)\n",
+			__func__);
+		return -EINVAL;
+	}
+
+	err =3D scsi_add_host(hba->host, hba->dev);
+	if (err) {
+		dev_err(hba->dev, "scsi_add_host failed\n");
+		return err;
+	}
+	hba->scsi_host_added =3D true;
=20
 	hba->tmf_tag_set =3D (struct blk_mq_tag_set) {
 		.nr_hw_queues	=3D 1,
