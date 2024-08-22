Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72FF1D172B
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 20:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724356830; cv=none; b=sNl4GMdMh/IW61yKFDnXn4iRghfsPRmYD4Dfzz2RAzqQgtTY5LHg5VXEyJPl4GCEaUWaWKDUwDxxy01ozNRdCUL1r+4NjBTMnPJRfMF4BoQWF788DZrj+Ix3/jSqm4tM3DR7nGoMAuCulT6UAdcBDmQttHSWi37zS25BQ1ojqAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724356830; c=relaxed/simple;
	bh=3k4ojss9UB7ndHPbNW1ez+COSFbfUAE8I1Pvuiq2pjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAQKlne1sd7mT8ZCYwUcQTTyoLvgTdImoP5ACBDcSXozMUncmUd3wGxxwGfbvFwLcrJs1oiY4KSCs/jtQcWaxtXwpQYzbfP8AHdezTRfo8Yy3jY5difkVPa15xjMm8eQruxIKjucacFbFAWvY/k0lcYPs+8ys0zeLPLngoNHh6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ZvXu5hXw; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ZvXu5hXw"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WqYw92P06z6ClY9M;
	Thu, 22 Aug 2024 20:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724356822; x=1726948823; bh=/E5GT
	rDEaVP02Hizwx6adZbgC16BvVgdfuw5s3s7RX8=; b=ZvXu5hXwalZzvwzCh4Z7x
	b1i6GzNO4/UltNIrPpVBJZUty03/y/F19yPUxK++dk8onf9KfwbkxK+LC9iylCVY
	27FzMqbhxTsfAJKnxKVo1MLdWLT4M5umhCfU7NzMLLgA+6hO3GZkxV0f6G/ieIC4
	/5Wh5qetAwj7Y1ZEyPT11F/PU0x3XjsdTafWvgLDlY7Im3ViMjfhioGkpjCMNMEx
	3WZ9JiXTaNSfC8EiIx2xzLaJqfJ7WnZJBOwohvQLlYlCTK9DGvJJP2E+FoOIZoHp
	JP3ghpTD6rO4cXQkwke+3+CbLxygZCG3rbdzhO1zXfpoghbmeBuH+EIsGgQwX7t0
	Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Njtmct7FwcTC; Thu, 22 Aug 2024 20:00:22 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WqYw62DSjz6ClY9P;
	Thu, 22 Aug 2024 20:00:22 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 15/18] scsi: scsi_transport_fc: Simplify alloc_workqueue() invocations
Date: Thu, 22 Aug 2024 12:59:19 -0700
Message-ID: <20240822195944.654691-16-bvanassche@acm.org>
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
