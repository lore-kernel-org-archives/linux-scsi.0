Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CBF16C684
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 20:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724356821; cv=none; b=WvLR6mHpnZSlkS5ONv9ltOBe8X0x3wW+FtipUmtX+9O6IpyVoqs1n3GoqKnlv1pUd8vR+6HJChg4Mq0CFHbZFTh8Yd3nUA+HC+/LCwS4sMpRe7O9+vRMUWsY1MeJnVCbbmq19nZy8n1WkekTjXEfIE1WZuqDGCTMise3zAbOy0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724356821; c=relaxed/simple;
	bh=k8xnEwjxncBmibJ9rb/duQSAGGar3W77zTxGI5zxoEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nhHpxvXyU2yXKtL/PE0+RaAUbk5/B9g9+piKcP6uQiI00ggQQZbh9kxlYNRdpKznx3g8lZ3K1SJbzmDXrWDaQj6agJUS7B2nMdzdEtxYjj9dE+Q68bpqxvrljZcDfPBvukgl/LICJK5fQlg/GVusNf4pk9xCH3V/BPFg2hGPnp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=dG+Mf3un; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="dG+Mf3un"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WqYw32Gy1z6ClY9V;
	Thu, 22 Aug 2024 20:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724356816; x=1726948817; bh=7huO0
	lWghV3UcNebybQ0VORXyW0Ba/Jtu3bltncobaM=; b=dG+Mf3unkAU5VkPo3aAqb
	1LT9aod9fsdDOnzSphcyORdy7AyASNXnimXWEHWPIwbRtwLxJD79izvjWTPfCZAc
	W0Y/RLfnCG+g0HymIoWi+JZdK6gXMzAJFq3ty4bqkupy+kG2Az297GUmRreT39lz
	c1Do+9LwHxrCEUXOaQU9DQB/InzGlbTdLkPYjrBz1okxYSIXZ5iNxPRzne1668WQ
	KpYCnN1wjg3RxNLk4phtcqWYHcKLdbu0N9GpbrAEi+k64+pIdEdbjgIE2b83RSME
	wqNqrRl2T9z4bOg75vf026kgtAz3OzLe5T7mK6dS2B/OLX1bEChZw15Q8kEKS8XG
	g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id vDiAb73oNaDx; Thu, 22 Aug 2024 20:00:16 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WqYvz2X1jz6ClY9M;
	Thu, 22 Aug 2024 20:00:15 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 07/18] scsi: ibmvscsi_tgt: Simplify an alloc_workqueue() invocation
Date: Thu, 22 Aug 2024 12:59:11 -0700
Message-ID: <20240822195944.654691-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
In-Reply-To: <20240822195944.654691-1-bvanassche@acm.org>
References: <20240822195944.654691-1-bvanassche@acm.org>
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
