Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57627201276
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 21:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719957212; cv=none; b=kZphw+l4SJzzpVdD5KmAlRwVvV/RtInxaP8yGR5zLwQFsHE5O2wtz1Ft8yt524lDmf3+NZ7frrOGArjfNxcKgTqFh6JuudfCJnmFC8DVW1PdyB58slMwgJyaP2w56VjVaxAoMfZkc08sKr8CnqxTi5KuS7I9Te6eCJNCR5d/scg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719957212; c=relaxed/simple;
	bh=2s+G+LzpAhYsLg/2kf5ZO6zX0bF5RjejmxHj3yiwQoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hi96ZGGDy60aLawXmO+lUunpnKmbyAqyvTT+ptzVg/EtCRQ60ebAbGMvEAeMvkRMMfc9TZxCcjWGtcqGw3CG7Qm64u06Hc9KX7g1Fa/qW55WSj0LmD1SltPanyy8O/fPBZ528l9AylPw58MhtFAq9ZVWxAr4KbIn+BxqDVK9lss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=0pbCqfJ8; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="0pbCqfJ8"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WDGrB6Xx6zlnQkm;
	Tue,  2 Jul 2024 21:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1719957209; x=1722549210; bh=WyArX
	V9oGK5qD03Tr7Dgm4Kgc1lyC9nGVVMVeNfoqoE=; b=0pbCqfJ8VnXb+OmLO0Xk4
	8SQv8Y+i7kD1JPaHmgtKMOTO0Gik/0iktVYJLTqCX13QVQ31ZzsLJ/Wo7rDmG63n
	POV8RsOW+KTR4LNg/cBNjdfZJTpM/1JXmFkM7dlefphN0jhGSKK0o+0dCHjwyFkd
	oMkXW44WTF1vvmaTW2aQ5fDRP4TtxgIqwuXrlipBmVAJVu/4Isc+eWWF7n7mBsCk
	RVzhSy5zxsoZnBASar/XmHyRjKT/OMxocIDS6hZptmugmEMhOeNoKPKvsd/RZBH3
	vi8PwFnJxcD+2BQUTIWXNdF49CF0lrwGEugjMNCGWn24O0FtuSzOgnvUQzS2DcJl
	g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id jES0i2e4Q69U; Tue,  2 Jul 2024 21:53:29 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WDGr800t6zlnQkr;
	Tue,  2 Jul 2024 21:53:27 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 10/18] scsi: myrb: Simplify an alloc_ordered_workqueue() invocation
Date: Tue,  2 Jul 2024 14:51:57 -0700
Message-ID: <20240702215228.2743420-11-bvanassche@acm.org>
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
 drivers/scsi/myrb.c | 6 ++----
 drivers/scsi/myrb.h | 1 -
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index 140dc0e9cead..bfc2b835e612 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -112,10 +112,8 @@ static bool myrb_create_mempools(struct pci_dev *pde=
v, struct myrb_hba *cb)
 		return false;
 	}
=20
-	snprintf(cb->work_q_name, sizeof(cb->work_q_name),
-		 "myrb_wq_%d", cb->host->host_no);
-	cb->work_q =3D
-		alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, cb->work_q_name);
+	cb->work_q =3D alloc_ordered_workqueue("myrb_wq_%d", WQ_MEM_RECLAIM,
+					     cb->host->host_no);
 	if (!cb->work_q) {
 		dma_pool_destroy(cb->dcdb_pool);
 		cb->dcdb_pool =3D NULL;
diff --git a/drivers/scsi/myrb.h b/drivers/scsi/myrb.h
index fb8eacfceee8..78dc4136fb10 100644
--- a/drivers/scsi/myrb.h
+++ b/drivers/scsi/myrb.h
@@ -712,7 +712,6 @@ struct myrb_hba {
 	struct Scsi_Host *host;
=20
 	struct workqueue_struct *work_q;
-	char work_q_name[20];
 	struct delayed_work monitor_work;
 	unsigned long primary_monitor_time;
 	unsigned long secondary_monitor_time;
