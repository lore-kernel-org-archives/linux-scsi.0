Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82281205E15
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 21:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719957222; cv=none; b=bCoIqYyNcB2+LTzUOV//DfTr71WkKGERkqOxW8kxLGHxcr3lKuEShb3SpVEoPFPfS7C5cJ49Q8ir1eFQCEf303XkBrhpN5yZDRVehgdeI83k3SKbLjxFJPk7Io47rpT60g5Ld1oLQPpyS4eUqtX902N8sdGh+Hrd/UIAb9pspEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719957222; c=relaxed/simple;
	bh=3k4ojss9UB7ndHPbNW1ez+COSFbfUAE8I1Pvuiq2pjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eja6FnSDK9gbqZANQwOQNPck+9+ytoTz5vONaQ9IJwEArg2SW1PwZh0QrVaN6xOAzQP+VF7nhM/e8n/GoP/PD6K2RGwxMoPZUw1xhXX8vy2AHKZLxDWhVT/cbUb7BmULtw6IANPXXPESD1mRDae+CyJcwo+ZtfuSPFLR7uY33uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=WxLL2eed; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="WxLL2eed"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WDGrP0HPHzlnRR8;
	Tue,  2 Jul 2024 21:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1719957219; x=1722549220; bh=/E5GT
	rDEaVP02Hizwx6adZbgC16BvVgdfuw5s3s7RX8=; b=WxLL2eedhtgBH+5B2mH64
	xKA081EbTi17z+Q0kiRHasIp71kAIkKtEd/myjf5gFyC1ZXJnM9c1XHvsJ9fAAs8
	0HNJDyA66HqgaEkJ+xPEl/N0mQouCEHsXVFumNgnsPw+fag5xLmhbppkhfbF+Htj
	IJ8nS89S6RqbGCGJtTUUnWnopzTlWo/e29PUBf6Kw0d+INQOaXfVV6yb0rtaK7Kj
	Ded5RIzSmSf4rFtGG3zR2SUIfjKpKPP283swFPNFAVESKUkzZvPqj2TfspaEUShW
	AtfRZ1jBn8Zl4DsagyxyllnAr0q2Eeuf67mGLex+9VZlpaVni1IZ/FrVRTPEkjY7
	A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id wXA1mA4lE9WO; Tue,  2 Jul 2024 21:53:39 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WDGrL1b4szlnQkr;
	Tue,  2 Jul 2024 21:53:37 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 15/18] scsi: scsi_transport_fc: Simplify alloc_workqueue() invocations
Date: Tue,  2 Jul 2024 14:52:02 -0700
Message-ID: <20240702215228.2743420-16-bvanassche@acm.org>
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
---
 drivers/scsi/scsi_transport_fc.c | 11 +++--------
 include/scsi/scsi_transport_fc.h |  6 ------
 2 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transpo=
rt_fc.c
index 7d088b8da075..62ea7e44460e 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -441,18 +441,13 @@ static int fc_host_setup(struct transport_container=
 *tc, struct device *dev,
 	fc_host->next_vport_number =3D 0;
 	fc_host->npiv_vports_inuse =3D 0;
=20
-	snprintf(fc_host->work_q_name, sizeof(fc_host->work_q_name),
-		 "fc_wq_%d", shost->host_no);
-	fc_host->work_q =3D alloc_workqueue("%s", 0, 0, fc_host->work_q_name);
+	fc_host->work_q =3D alloc_workqueue("fc_wq_%d", 0, 0, shost->host_no);
 	if (!fc_host->work_q)
 		return -ENOMEM;
=20
 	fc_host->dev_loss_tmo =3D fc_dev_loss_tmo;
-	snprintf(fc_host->devloss_work_q_name,
-		 sizeof(fc_host->devloss_work_q_name),
-		 "fc_dl_%d", shost->host_no);
-	fc_host->devloss_work_q =3D alloc_workqueue("%s", 0, 0,
-					fc_host->devloss_work_q_name);
+	fc_host->devloss_work_q =3D alloc_workqueue("fc_dl_%d", 0, 0,
+					shost->host_no);
 	if (!fc_host->devloss_work_q) {
 		destroy_workqueue(fc_host->work_q);
 		fc_host->work_q =3D NULL;
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transpo=
rt_fc.h
index 4b884b8013e0..8e6c60090c62 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -575,9 +575,7 @@ struct fc_host_attrs {
 	u16 npiv_vports_inuse;
=20
 	/* work queues for rport state manipulation */
-	char work_q_name[20];
 	struct workqueue_struct *work_q;
-	char devloss_work_q_name[20];
 	struct workqueue_struct *devloss_work_q;
=20
 	/* bsg support */
@@ -654,12 +652,8 @@ struct fc_host_attrs {
 	(((struct fc_host_attrs *)(x)->shost_data)->next_vport_number)
 #define fc_host_npiv_vports_inuse(x)	\
 	(((struct fc_host_attrs *)(x)->shost_data)->npiv_vports_inuse)
-#define fc_host_work_q_name(x) \
-	(((struct fc_host_attrs *)(x)->shost_data)->work_q_name)
 #define fc_host_work_q(x) \
 	(((struct fc_host_attrs *)(x)->shost_data)->work_q)
-#define fc_host_devloss_work_q_name(x) \
-	(((struct fc_host_attrs *)(x)->shost_data)->devloss_work_q_name)
 #define fc_host_devloss_work_q(x) \
 	(((struct fc_host_attrs *)(x)->shost_data)->devloss_work_q)
 #define fc_host_dev_loss_tmo(x) \
