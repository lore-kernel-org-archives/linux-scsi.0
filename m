Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE36201276
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 21:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719957206; cv=none; b=BD+RKS1K1NUIngxvJ50RF4K4SuT2C6B/QgOFb+6JzZsi7dSf4mW/fR2A+Kbyze6nZPbN2N1RXC3pVgtre16n5a+UZGQS03fBfmYf2Akc0fKi99OU7XXmwABreL08l6FVzstojOdCqUluMk1BsPYSG8dW8+dqfEKXZZZgULTW5DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719957206; c=relaxed/simple;
	bh=F/o4ugwDQ+Cer1dUZzNqWOt3XV7Hk3Oy4tmTpQ6lwak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLtLOFsLR+bAzV4uId/JYqYfHvozfkLGi5jNx+rT9QdNPEh4Y6KArlUnHT4WWVKz3621d4+BMsrgeaS7o5TYfwOlg0T8OMBOhARS9OoBiHR1AoipQ3VR8Ky88RenUa4ufnahm9zTGCSj4RDYPxVFDfpqYNfIqaQRwncHsg0NNk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=PdA1rrGl; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="PdA1rrGl"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WDGr42h92zlnQkm;
	Tue,  2 Jul 2024 21:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1719957202; x=1722549203; bh=gLAZz
	CvNS8cSEoayz/WP3bAN8I8eNNHv5zZs8/BM224=; b=PdA1rrGlMqWPlxLKqJl7m
	Hjjf+/AnHauKyOORsvZ0R2uV/4tRKrDBthevoO0OkWqTIcBptqThGX9F3WH4dxha
	4OYO7ZIesMqOYlXLcBPnTs9lE1UJBO3Wwz7KHM19BG8PrZ5jegdIjHIJB8Vf/rS+
	DLZxGjY4sZ1NNfHwjNsiZfCPONKxrddpqOYtIHB74QDv/LeHK64KIZ7gJgpBa4Ni
	4+xDUHVhjwm7ZD0XcQLqje/MxhwMVF1ws7PcOQhHlj+FjlYT9HmVvlK40bMIoOpk
	zoPqQTL36TjMozuKp4K3MprvD5eFhEnwzZKegDm4+XRJH9+0KNm59kLHfPcaOhXG
	Q==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id HCgGdXd4HC0H; Tue,  2 Jul 2024 21:53:22 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WDGr13Nn9zlnRKl;
	Tue,  2 Jul 2024 21:53:21 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 07/18] scsi: ibmvscsi_tgt: Simplify an alloc_workqueue() invocation
Date: Tue,  2 Jul 2024 14:51:54 -0700
Message-ID: <20240702215228.2743420-8-bvanassche@acm.org>
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

Let alloc_workqueue() format the workqueue name instead of calling
snprintf() explicitly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>

ibmvscsi
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
