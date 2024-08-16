Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122A61C57B2
	for <linux-scsi@vger.kernel.org>; Fri, 16 Aug 2024 21:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723845441; cv=none; b=ASkxt0JPJI5dPt443XNl038sbHaR0qj+SeVuWsl1MDN65tUo5sUsSjiItvedig3mG+p4u6q1q5qKnGt8ZOkn9bVVCmd5BciaIjvjUwOQp8JSkFhIlY+sw6LMf5cC6w3aLSDIKNjFdY3jYUsuzzRguK7sRu5S/FpQBBu5k61Vdw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723845441; c=relaxed/simple;
	bh=O2OrLXJz8NlgzXoaHx3h+T2weOez+12wHqJLQT6eTug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QRgnjScMTkdTkZMMdR/e07U0mLakkKcs2jf6DqSAjgUDZ3qMwss3MN6vQHTZ+305DgCSc25diI56qCaTRULYYhnBB+gDm7BMcjC4YyKbRIJPeas+4/72M+qpWBdZ//ogsdVnZu95KiCN2tPkIwM9Usx1+DDlKRUTG3BVCTjyQ0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=5DsCrQuT; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="5DsCrQuT"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Wlwnq3LKQz6ClY9D;
	Fri, 16 Aug 2024 21:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1723845437; x=1726437438; bh=mQrK3
	KKyRGgIt9lcPNd0uRl3KXZA98cf9AH6yNIdU6s=; b=5DsCrQuTmfB4s5MxiVmNS
	RjM4+onV6kW1PJbgfxAaK7PaoQe/8CMQcq8r26iXx9K8mzyls4gtG9dqxY1Xe4zJ
	X6Lv+MVyBiJNJf/i52JRzbythX7SVxbKjhBJROxOUvnkuLuuL2GlyxWhaytMkIvE
	mnDpgBBBpAjPlkUZoaXeSITyp4bWaGyJL9jkLC9S9h2olmum+6OqQ3WKrXn02Cuy
	sEiehO6hrLrjZ7iQkSIxRo2L/0G3S1HKyJG0p+qwaVDkalTNuzZMu837+ynN3KJ/
	rzhaJw+0oJbvOlz7f9KdIWj+RnMjS3XttSE/jLGnpZ+z9RWxSANl5x5Xz84hkd+C
	Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ue-UjcuW1mn4; Fri, 16 Aug 2024 21:57:17 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Wlwnm4SKfz6ClY99;
	Fri, 16 Aug 2024 21:57:16 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 18/18] scsi: core: Simplify an alloc_workqueue() invocation
Date: Fri, 16 Aug 2024 14:55:41 -0700
Message-ID: <20240816215605.36240-19-bvanassche@acm.org>
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
