Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3166A81211
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2024 21:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720473518; cv=none; b=W4cDSC5CqM/3Y80WAIOISgfNUev9LBemUCu/EdkWV0gXm+WA3XwSiR7YInM2Ig/9ZJNHiNiiQRS9QmkpH/X7OQN3Oyug3SJy1+x/xfAB0t8gbNww7fMN1N7SrFjxV+FOyVDczPqCJOoYQp33X7BW0wSJPnBQSVkpPLaTm07iUus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720473518; c=relaxed/simple;
	bh=/aZuJV20TQQnd4ghsTL1DGrgmHNMQXLzHv9ubuf7Amg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o32nBhQR+ctG6fR6QIfcmo5CGQkF6YBMwhtDdkwnIXGdk8VDSrur33X1T11Y6b+30TgVjuCNFu0LLXvq1lE2RXFlESwX5McX21WJkCcx+IlO7vgmNb3nA5AA/famMUOcoaX13f7xt4AxOgs0lCSAEpyEbWaRC4Qv7QqASkGQJj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=WKIQbMse; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="WKIQbMse"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WHxn854H9z6CmM6L;
	Mon,  8 Jul 2024 21:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1720473511; x=1723065512; bh=EAn82
	yBWlBDiTm0fHJPVfVFUzHL84kiW/YkX8khFB2o=; b=WKIQbMsem+j1VIN9dgyI6
	7ZuLM1o8/5pnZIwsYy/D8pJI1GXbJ6xOkHG4OOMcA9inGdJcPClV8RxlP2OgBEhd
	ZBd8DoBloVP3AglFEZFFT2sIYboMXtXKeO6LMX8HJMiqr8d6jQs9cf+fVGG+SBWA
	5X8XUDv9RA9nWd7qgooTyskRGGGf9RsNuYFFqeWpnOXxpPMQZF0t/f4sL0J0u4yK
	vk7FDugUsnqvp1qR7WIm24dmzTriLeofNozneqA3C19m1A/KTl86a4wqKaJ69Uz4
	kfK88GtEuZuqx6U7ZX5HWeDk23MZxE51wbIFqgv4vpeSfMONsxR0jD3vMRhEqYaV
	w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ak3RzXoeYZAX; Mon,  8 Jul 2024 21:18:31 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WHxn03Y3Bz6Cnk9V;
	Mon,  8 Jul 2024 21:18:28 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	peter.wang@mediatek.com,
	manivannan.sadhasivam@linaro.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	ChanWoo Lee <cw9316.lee@samsung.com>,
	Rohit Ner <rohitner@google.com>,
	Naomi Chu <naomi.chu@mediatek.com>,
	Yang Li <yang.lee@linux.alibaba.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v5 07/10] scsi: ufs: Move the "hba->mcq_enabled = true" assignment
Date: Mon,  8 Jul 2024 14:16:02 -0700
Message-ID: <20240708211716.2827751-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
In-Reply-To: <20240708211716.2827751-1-bvanassche@acm.org>
References: <20240708211716.2827751-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Move the "hba->mcq_enabled =3D true" assignment to prevent that it gets
duplicated by a later patch that will introduce more ufshcd_mcq_enable() =
calls.
No functionality is changed by this patch.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-mcq.c | 1 +
 drivers/ufs/core/ufshcd.c  | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 4bcae410c268..0a9597a6d059 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -416,6 +416,7 @@ EXPORT_SYMBOL_GPL(ufshcd_mcq_enable_esi);
 void ufshcd_mcq_enable(struct ufs_hba *hba)
 {
 	ufshcd_rmwl(hba, MCQ_MODE_SELECT, MCQ_MODE_SELECT, REG_UFS_MEM_CFG);
+	hba->mcq_enabled =3D true;
 }
 EXPORT_SYMBOL_GPL(ufshcd_mcq_enable);
=20
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 255d55e15b73..7647d8969001 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8704,7 +8704,6 @@ static void ufshcd_config_mcq(struct ufs_hba *hba)
 	ufshcd_mcq_config_mac(hba, hba->nutrs);
=20
 	ufshcd_mcq_enable(hba);
-	hba->mcq_enabled =3D true;
=20
 	dev_info(hba->dev, "MCQ configured, nr_queues=3D%d, io_queues=3D%d, rea=
d_queue=3D%d, poll_queues=3D%d, queue_depth=3D%d\n",
 		 hba->nr_hw_queues, hba->nr_queues[HCTX_TYPE_DEFAULT],
