Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4771BD512
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 21:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719957232; cv=none; b=d/cDxN9Fr4Jo16Qp8/IVgHWbg7SW8/O3YGT6lPgxITuzq2SPVVxa0o72YL2Z3klMj43r373CwRyDRLb+iQ64BRNLhsylKTrzlvw/IVf31Veijc91F36o6ZfIu5TaZEZKyFSXiBe0bz204j8mDwV/xuXPQkDW52txbd2uiX0SfrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719957232; c=relaxed/simple;
	bh=O2OrLXJz8NlgzXoaHx3h+T2weOez+12wHqJLQT6eTug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qfZjy4u7zpLrp0ktUdL4C6uJGHUo4gvNU8HWnjF6K6pyX3OTG7DENVF5iFps61gxuxuw6VECwRSx8DdywH+9uHbbvEESvQ7tR48y0DsRyf20MpwJa86hrXpZ2XkO43yvXaFqVF8eAds4FvLHvVJBgyWJdC8sLkUUSX4a3DKVtu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=kHlLSoAx; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="kHlLSoAx"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WDGrZ43cfzlnRR8;
	Tue,  2 Jul 2024 21:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1719957229; x=1722549230; bh=mQrK3
	KKyRGgIt9lcPNd0uRl3KXZA98cf9AH6yNIdU6s=; b=kHlLSoAxVR6o6f2Rh2Bu1
	Paop604DF1teERwYBYeQB8OcEQ2QflHsCkk8yjdGMztmf6NMD1tymgRavBp7Py76
	WGyCZjztLX8GLZEEgrsBFhD2moecq7+xpNve6YzfUY7D8fdy9ryQlh55j1k8tcWV
	9AhGGUxujHlEV+bzKXEtt3AQWzS/nvuvk0pKpr4uekJ58T4Hpr1QbWEej70z8FGF
	KJSqFA1pqv+kN5OhF/89wpUStLMDLaS4FB+MihNJsre4y1e1QdTE/HDKWRw7OzDR
	LItw6Cst9muMIXd7KUGUg+k9r8yG25FI1a8ogYMSOpJclSi1AC4EZ5ZpXtON2hb2
	A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id priFveoiEDQn; Tue,  2 Jul 2024 21:53:49 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WDGrW5ybRzlnQkq;
	Tue,  2 Jul 2024 21:53:47 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 18/18] scsi: core: Simplify an alloc_workqueue() invocation
Date: Tue,  2 Jul 2024 14:52:05 -0700
Message-ID: <20240702215228.2743420-19-bvanassche@acm.org>
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

Let alloc_workqueue() format the workqueue name.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hosts.c     | 9 ++++-----
 include/scsi/scsi_host.h | 1 -
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 7f987335b44c..e021f1106bea 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -292,11 +292,10 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost,=
 struct device *dev,
 	}
=20
 	if (shost->transportt->create_work_queue) {
-		snprintf(shost->work_q_name, sizeof(shost->work_q_name),
-			 "scsi_wq_%d", shost->host_no);
-		shost->work_q =3D alloc_workqueue("%s",
-			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
-			1, shost->work_q_name);
+		shost->work_q =3D alloc_workqueue(
+			"scsi_wq_%d",
+			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND, 1,
+			shost->host_no);
=20
 		if (!shost->work_q) {
 			error =3D -EINVAL;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 19a1c5c48935..2b4ab0369ffb 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -677,7 +677,6 @@ struct Scsi_Host {
 	/*
 	 * Optional work queue to be utilized by the transport
 	 */
-	char work_q_name[20];
 	struct workqueue_struct *work_q;
=20
 	/*
