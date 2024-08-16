Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FD71C6883
	for <linux-scsi@vger.kernel.org>; Fri, 16 Aug 2024 21:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723845421; cv=none; b=XxApllJpTqXx5tOAG6zwfUScyuQaXC+/BWCYiGRMmxsMZw4MCvIQTwZOK37qs2gVi4eJE1ojbxCjp7pLToJ7a/tfxZPdGOKfkJgAcrGTHrdASBEdwrlj1ddiRs3msOa7wtI5E0B1JcbKgZ3cKQlJ3n8QGohBPMVWQR42CgBX8I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723845421; c=relaxed/simple;
	bh=pKoaZ+AWdHtH3ENZvSwQNYVhA6qLwmMRi6N1YCz+V5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KXKFPF5V0GwpvmSfA5oNLPA0DZEtXKV1FNgmHIszQc7QNiAf2knR0sKqVHos7nawSew3Ww7b99hsH8GhCeQ4R8ojcU9bdWM6UoLW2T4KUpt9nTNm40P7jCsAea/PbXJuIOB9WZHs5LZw7WpHgKgdLSMfXivztnCGFdhp/+0y5mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ozpk9NM+; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ozpk9NM+"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WlwnR5s8vz6ClY9D;
	Fri, 16 Aug 2024 21:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1723845416; x=1726437417; bh=grUuH
	VtYtG0vOU6ssbFXaGw2TolOmql3pZyaX7x0xbQ=; b=ozpk9NM+3s0PwdHwQhKtC
	JN/ky2zsalihjruzS7f3f1VD7XEIlCp6HtV1dQ/QVPP0/5AjqHQyp47yZSFx3VOY
	rOw8ie1usuLxIfRaq6RcfqiG066T2nsBEpSq3AJlwGSpUkyMagCiZ2FS0mZY3Cvn
	j7yEKO50Vqf8R2cr6IkFsSzjYIUinI891dffOalVaHnOke93Bcp/GcvYcfFxhx73
	G8Usw5qACVKANA5TOms4EpOKXK54NtzVNOyLTg1JudIBPNAKxHYVsIVC92AHTVlq
	GRUvBy3rewzYiATakM3ST/L0AuaY05PsczUUhgx2sque8JtJ4eGHf7LTICmvM+Ep
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id CfWbByBIrgAE; Fri, 16 Aug 2024 21:56:56 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WlwnM3C3tz6ClY9C;
	Fri, 16 Aug 2024 21:56:55 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	Hannes Reinecke <hare@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 10/18] scsi: myrb: Simplify an alloc_ordered_workqueue() invocation
Date: Fri, 16 Aug 2024 14:55:33 -0700
Message-ID: <20240816215605.36240-11-bvanassche@acm.org>
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

Let alloc_ordered_workqueue() format the workqueue name instead of callin=
g
snprintf() explicitly.

Reviewed-by: Hannes Reinecke <hare@suse.de>
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
