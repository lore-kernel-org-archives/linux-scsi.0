Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0211B1D0DC0
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 20:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724356826; cv=none; b=Pz0tlE8dN/6KwQSeFANinGsEXfapJSZ/q5TAOPNUEAm4AItsTRQq2iwiR8DA6QX/nBQH3mlQnyIPFLtYtXJMD5GYsI3uiRJSIV+k7wm8AQQRQEG+vu2RxevrPhnzU0cijwP4yquqQ3k05dvc6udNv8xopiXffUtZ/OWHx/SCZ1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724356826; c=relaxed/simple;
	bh=ILSVpTz5PpXWddwJQr5xWOBWbKeXj2zOpyoIuIBN3Os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZltj3FMywLowdKWbwH1SmrFWI8a7h7AXVwaBh1XKJCNiSo/ULGbG2UTtIWOXsGIip2eBjYVdc+x/K1ntSgSEinQP6GwbxP8J/7Eb7rCnS+ZrbQK1ZJ9LiXsy28shsY6yt2euJ52bvNgi5aRFBYYypoQ/PvLHodHhxZJ59BriAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=eOxFnP5M; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="eOxFnP5M"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WqYw61kJnz6ClY9R;
	Thu, 22 Aug 2024 20:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724356819; x=1726948820; bh=zFCfV
	ZLZz8yi36LVVhvfZgNT0zp7fTxTj5SMahBW1dQ=; b=eOxFnP5MTe2r1+AprgBH+
	ksF+UQ0kkywPMONXupw9ln7zUFQv2bpodbSwlA1O2vwbNjt51k7dSTdqrnB8xetO
	mn/OS2Vt0Is5WiHSeNKO2eCnkJQYb/G2XTmz76OJv3bmDiGPo+RIb/XkXnpCZD5V
	Cs0Z+FZwwHl/bmZZULN8ulgUofuIhJYA6HxgewaG3h1Vm3N9SAiYqpMfJfxkRE8u
	HJS9U0OK3xpSu+Czr9PWS9UZExbYN8mqRk3Q1gdhRewa6pLk5GZ5Zgytl6qLeGzN
	HfOL/Ct2iFK+IspuoT+rSWwQWZIEeidjvsbeAfCCVKdg1ojYM+KQcZSTWXqnxbGS
	w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id C3AmXP1C9-fm; Thu, 22 Aug 2024 20:00:19 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WqYw26dbgz6ClY9Q;
	Thu, 22 Aug 2024 20:00:18 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	Hannes Reinecke <hare@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 11/18] scsi: myrs: Simplify an alloc_ordered_workqueue() invocation
Date: Thu, 22 Aug 2024 12:59:15 -0700
Message-ID: <20240822195944.654691-12-bvanassche@acm.org>
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

Let alloc_ordered_workqueue() format the workqueue name instead of callin=
g
snprintf() explicitly.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/myrs.c | 6 ++----
 drivers/scsi/myrs.h | 1 -
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 8a8f26633cda..3392feb15cb4 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -2206,10 +2206,8 @@ static bool myrs_create_mempools(struct pci_dev *p=
dev, struct myrs_hba *cs)
 		return false;
 	}
=20
-	snprintf(cs->work_q_name, sizeof(cs->work_q_name),
-		 "myrs_wq_%d", shost->host_no);
-	cs->work_q =3D
-		alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, cs->work_q_name);
+	cs->work_q =3D alloc_ordered_workqueue("myrs_wq_%d", WQ_MEM_RECLAIM,
+					     shost->host_no);
 	if (!cs->work_q) {
 		dma_pool_destroy(cs->dcdb_pool);
 		cs->dcdb_pool =3D NULL;
diff --git a/drivers/scsi/myrs.h b/drivers/scsi/myrs.h
index 9f6696d0ddd5..e1d6b123de7b 100644
--- a/drivers/scsi/myrs.h
+++ b/drivers/scsi/myrs.h
@@ -904,7 +904,6 @@ struct myrs_hba {
 	bool disable_enc_msg;
=20
 	struct workqueue_struct *work_q;
-	char work_q_name[20];
 	struct delayed_work monitor_work;
 	unsigned long primary_monitor_time;
 	unsigned long secondary_monitor_time;
