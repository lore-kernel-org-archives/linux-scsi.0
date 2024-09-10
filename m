Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9046816C854
	for <linux-scsi@vger.kernel.org>; Tue, 10 Sep 2024 21:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726005198; cv=none; b=OKsVxCaZLYyXAeR5BUWF5Tjh59AjZeQZqgwyyCB35YPDDMBmTwrNHC+lsNh9TdekQ7RMbD281+JaGHBmxAdJ2z71pKZ8/R5S5zImAMJYYqmlT+DKzTN1h5wVuMPpYbPu56MDgnqsm2HIfrHNU0LA/GaXdIHRw5wtQvwXPhuaN2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726005198; c=relaxed/simple;
	bh=FcNXwFm2t4NtiMtmENM4EKPIqfeQvdo4dBsv89dVGKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GnO9B6FhdBaRBjqai6hoiBW9TqGXoGDBsglrNu3X9fYHfGtWJF0zVG1YPIO2A4WrjSe+dHsSk4zCoHnOcRtor6lX7IvAEEbCw5RMz7ZK1gjs4g/wxNjmEUnWztm6YWPYGQaBtcq4BSLhdnwV+tZrXyJFixv5ou/YLjmPBcipn9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=o89m8q9Z; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="o89m8q9Z"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X3HWd2JyNz6ClY9J;
	Tue, 10 Sep 2024 21:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1726005193; x=1728597194; bh=ajzJN
	SmOryFRZyCx5aom1bD2v29IejOfo6L50+TG8OY=; b=o89m8q9Z/z9FX8HfGmU76
	xwpcVlYZ7lkIUVaCDOnbmqjdZKOtRED7kRRL2M8GHoE2FE674vlRk6kZUvhY4FcV
	rCMKrpsKdtcFm98lQtDqO0Mv1GA3zY6YXMR8dA85CyZ2PCvmpNyaiqVjSsZpEv6z
	L1DCU46011tmS3iaZNy2eGRZWPu8+krX0UcG6HydVstdC8J6aDCwdhBoCnLRpkOb
	f978U/5XZ0P26siWddF7VTOJSGD056vRSh5Kjh6N3SY3C69i8mhp2EKkvL6TKBRa
	eHp+AQTxrpVhnx506Oegv/ohuuLmX8lzRbwOfzq1Ll13spM3bgXKIa0Ghrgo16F7
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id QGZv5V_Sx2KY; Tue, 10 Sep 2024 21:53:13 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X3HWV6N3Mz6ClY8n;
	Tue, 10 Sep 2024 21:53:10 +0000 (UTC)
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
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v5 10/10] scsi: ufs: core: Move code out of an if-statement
Date: Tue, 10 Sep 2024 14:50:58 -0700
Message-ID: <20240910215139.3352387-11-bvanassche@acm.org>
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

The previous patch in this series introduced identical code in both
branches of an if-statement. Move that code outside the if-statement.

Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8e4e25da9a6f..2ad2c3e968c4 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10378,21 +10378,15 @@ static int ufshcd_add_scsi_host(struct ufs_hba =
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
