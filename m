Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B32A1C6880
	for <linux-scsi@vger.kernel.org>; Fri, 16 Aug 2024 21:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723845414; cv=none; b=utE4fl55UvFJjm54RxN5r4N3I7ziPC+5ClFVS7Pu6veWI19MeeZw3TWXEUDBeY1OdVkA1A8tAuwDyqTj1RPc3SWB25eyChMnni+lzlKpjWllzqRJA1EB9jKhRI80hWmgIQ7tzUTJVc2IGFQwxnAht83GGRE2fm+Q4qSkHz4hr5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723845414; c=relaxed/simple;
	bh=k8xnEwjxncBmibJ9rb/duQSAGGar3W77zTxGI5zxoEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fcUamIhQMcyjvrsocR88lJsVB/B2wVICAEAai136IzQSgsLaS/wZKHWwyONgXNfT7vHLm67f6/M3uF41nubW45i/MggbRCcu+S9OACjFGX2Yw3OiG9k0/qfTCMNjrtyjhEMDkvQm9c2hC2Ac5hTXtvx9G0j/UilaOWuPiRTVDiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ZXnJCRq9; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ZXnJCRq9"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WlwnJ12Xjz6ClY9D;
	Fri, 16 Aug 2024 21:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1723845409; x=1726437410; bh=7huO0
	lWghV3UcNebybQ0VORXyW0Ba/Jtu3bltncobaM=; b=ZXnJCRq99gR+0BudR64/b
	ojtRiWGhpubkxToKMjwsEi8RKhKqOdm4YAQCviRjH1PkK4+4RawQLEfGk8CFqkqJ
	awzF5/FN3oPDVxsVJRhanLkTG8lN2Yn5odlRBUDkxNFvySHDSA14HLlEHCmKoOER
	PzKkM743p86hAeE8v+Xm3VNyrZU58bscPkc3RBjHbqouSWQ4/fGMRws0dDrVnbDJ
	jIu9CSxNzdJGXdMgqLUbud56Dhdaq5yY18PBBgXjEqNfWLvVSFJlWkUc/Nrhcbo2
	dCSOONcfSbpQj+/p0RbHKNsEl1fx9OFvEgMDVrfI2zQxXjyi9TUdjoUp2RB/2PPg
	Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id sCzNMGWWQaSS; Fri, 16 Aug 2024 21:56:49 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WlwnD49T5z6ClY98;
	Fri, 16 Aug 2024 21:56:48 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 07/18] scsi: ibmvscsi_tgt: Simplify an alloc_workqueue() invocation
Date: Fri, 16 Aug 2024 14:55:30 -0700
Message-ID: <20240816215605.36240-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.184.g6999bdac58-goog
In-Reply-To: <20240816215605.36240-1-bvanassche@acm.org>
References: <20240816215605.36240-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Let alloc_workqueue() format the workqueue name instead of calling
snprintf() explicitly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmv=
scsi_tgt/ibmvscsi_tgt.c
index 639f72f28911..16d085d56e9d 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3425,7 +3425,6 @@ static int ibmvscsis_probe(struct vio_dev *vdev,
 	struct scsi_info *vscsi;
 	int rc =3D 0;
 	long hrc =3D 0;
-	char wq_name[24];
=20
 	vscsi =3D kzalloc(sizeof(*vscsi), GFP_KERNEL);
 	if (!vscsi) {
@@ -3536,8 +3535,8 @@ static int ibmvscsis_probe(struct vio_dev *vdev,
 	init_completion(&vscsi->wait_idle);
 	init_completion(&vscsi->unconfig);
=20
-	snprintf(wq_name, 24, "ibmvscsis%s", dev_name(&vdev->dev));
-	vscsi->work_q =3D alloc_workqueue("%s", WQ_MEM_RECLAIM, 1, wq_name);
+	vscsi->work_q =3D alloc_workqueue("ibmvscsis%s", WQ_MEM_RECLAIM, 1,
+					dev_name(&vdev->dev));
 	if (!vscsi->work_q) {
 		rc =3D -ENOMEM;
 		dev_err(&vscsi->dev, "create_workqueue failed\n");
