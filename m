Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33F3205E0E
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 21:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719957224; cv=none; b=EFGePZTCzi3J95YT/5H4wykENzxk3UKazCccdxxMJ/OTbfsEDRE98ZLbP0C9b5PIamz1Kr5fTFpUfUgNeASJYNc2OkW8jwoiriBLM56fwWUDuWz5XoM8E80jwYNjrXCwYZ+Ej2ap1EOYayDDrzOLxqMHZfO38d6K9oZ/IPcfekI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719957224; c=relaxed/simple;
	bh=R8HumJBM8ZU/AKzLjESjdXJq5h4uLvaVuxrkBFXonYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YZvjU/jzpXOmENB9k/SAsnjEfmLId9GAv1/yfI54r5jdmjGD9XgHBeYmdDD4//JlTJPFavEtFDVrqxEjoh+svY2Hbv0ECW1y6SW/+i1ZSJm7fVVpYlfWaMuxVJcv5b1ybMIfD03TDsE6NLAjjGRATsCiox6QpFoYE5wWZ+vR3WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qs1m+rMD; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qs1m+rMD"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WDGrQ2DH4zlnQkm;
	Tue,  2 Jul 2024 21:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1719957220; x=1722549221; bh=NUMwq
	9m0NGA/JPJnvjiSkyJiugCR5QZ35pSWfTHWtKw=; b=qs1m+rMDxdWE0O1l0bSOv
	Ss2OSJ6Alt2cA+UVShHGpMPHDmqimns9y3m+HJTusf8UI4BVNMQNFDihUEjlgavz
	AP/m/72RymnDUEzK+Lz9Us2ryg99+L98AeFFot8H0NtDLlzWCqWyWG/3wzOBT0AM
	ZCFUQYRx6TF2gpajCRD9AQF/7nIVrTYS1SHgoIrxhuBpogqGoJiZDeUmv54GdHO3
	WUg8brcl0mlZ/9P2p1QguNgapdKyGEDP9zkCJjjSoRQ0tYzVmJ1H5LYqDoVl29b+
	Ik2OvYZl7Nr6ZbQMTWyow68ZDrodyZec/bphw2Ewl6BWuRl6p4iiNS+BC2da3v6b
	w==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 3f4N-LEZfOB5; Tue,  2 Jul 2024 21:53:40 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WDGrM5S3MzlnQkq;
	Tue,  2 Jul 2024 21:53:39 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 16/18] scsi: stex: Simplify an alloc_ordered_workqueue() invocation
Date: Tue,  2 Jul 2024 14:52:03 -0700
Message-ID: <20240702215228.2743420-17-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
In-Reply-To: <20240702215228.2743420-1-bvanassche@acm.org>
References: <20240702215228.2743420-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Let alloc_ordered_workqueue() format the workqueue name instead of callin=
g
snprintf() explicitly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/stex.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index fbee7db4a835..0e81125df8c7 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -334,7 +334,6 @@ struct st_hba {
 	struct st_ccb *wait_ccb;
 	__le32 *scratch;
=20
-	char work_q_name[20];
 	struct workqueue_struct *work_q;
 	struct work_struct reset_work;
 	wait_queue_head_t reset_waitq;
@@ -1795,10 +1794,8 @@ static int stex_probe(struct pci_dev *pdev, const =
struct pci_device_id *id)
 	hba->pdev =3D pdev;
 	init_waitqueue_head(&hba->reset_waitq);
=20
-	snprintf(hba->work_q_name, sizeof(hba->work_q_name),
-		 "stex_wq_%d", host->host_no);
-	hba->work_q =3D
-		alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, hba->work_q_name);
+	hba->work_q =3D alloc_ordered_workqueue("stex_wq_%d", WQ_MEM_RECLAIM,
+					      host->host_no);
 	if (!hba->work_q) {
 		printk(KERN_ERR DRV_NAME "(%s): create workqueue failed\n",
 			pci_name(pdev));
