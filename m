Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3753B24DCFD
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 17:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754933869; cv=none; b=fIbiu9U+OeVw8HI8l5udWxJlnABk78+MCnpusCa/nYHo7KmfKD48mNE4g61jzeeYLuYXgpgQSoWBL+I6YAb+Pzmd8XCarL0DI84TDbhf3nZFkgFRVU2sLibvUQWk29gQaIFzHEieq/UgMl4kmKpi7wHglgskG3p1+bhwSzZ7vBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754933869; c=relaxed/simple;
	bh=d2bGuKqXG+D3hfnXJonpbGzHleUyQGgdE1oBMdtx2cE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jh2eYuIJvM6WZi5kEdyXCMo5z9hiYG5pVVX1Mt2enQgOAt4rURSdQ4J23LjSd7vL7mvn6SEtHqPNZHd/cHxPGP07OLt9o12rGVuexxM9MklBv8fSOEZ0Dg3uKvhQZyoXnEm0OjgUEZ6S9yKgav+5j6ejaw9yjBM1bDdskSzI9NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=zOs6IlUT; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="zOs6IlUT"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c120C2Cq4zllRp2;
	Mon, 11 Aug 2025 17:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1754933865; x=1757525866; bh=+ykvf
	ADyz0Ppg5/hmNlZR7oMNFSG7VwkgDNgUPHAKI0=; b=zOs6IlUT4o4rn+xAdHL/5
	6nfABnKckEsgKrDI1QVrbOi1M4HPlyjrlc+LZcP+xDxrDfH8CAgArg7nf9AiNYgH
	8YRiy5vrzweMOLV3hnSKUekH3BXiOmO+nr0FR4JYQJBr/My+QCuabAa18QlX10Yf
	uARHS32Oq1HovR5z7LF79kRSdz5ak0SDx5iJh5zKhtZKMYTWBOL3bO2BFKVJYvOO
	ypXc8wQJqF5ntuxr/1wgGbHXSP1UhEQ/e60GpthlITGgE4zglLgkdtEY6IDkDn67
	Of9EjX0Pspkq6R/Kl8f+aDjjHwkknitaHR2bWUEK95ynAtP1X+lF71eG1fmUHT1W
	A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id y7B8Pj3WoDIL; Mon, 11 Aug 2025 17:37:45 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c12046G0SzlgqV4;
	Mon, 11 Aug 2025 17:37:40 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	Ming Lei <ming.lei@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 03/30] scsi: core: Do not allocate a budget token for reserved commands
Date: Mon, 11 Aug 2025 10:34:15 -0700
Message-ID: <20250811173634.514041-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
In-Reply-To: <20250811173634.514041-1-bvanassche@acm.org>
References: <20250811173634.514041-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The SCSI budget mechanism is used to implement the host->cmd_per_lun limi=
t.
This limit does not apply to reserved commands. Hence, do not allocate a
budget token for reserved commands.

Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9c67e04265ce..0112ad3859ff 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -396,7 +396,8 @@ void scsi_device_unbusy(struct scsi_device *sdev, str=
uct scsi_cmnd *cmd)
 	if (starget->can_queue > 0)
 		atomic_dec(&starget->target_busy);
=20
-	sbitmap_put(&sdev->budget_map, cmd->budget_token);
+	if (cmd->budget_token < INT_MAX)
+		sbitmap_put(&sdev->budget_map, cmd->budget_token);
 	cmd->budget_token =3D -1;
 }
=20
@@ -1360,6 +1361,14 @@ static inline int scsi_dev_queue_ready(struct requ=
est_queue *q,
 {
 	int token;
=20
+	/*
+	 * Do not allocate a budget token for reserved SCSI commands. Budget
+	 * tokens are used to enforce the cmd_per_lun limit. That limit does no=
t
+	 * apply to reserved commands.
+	 */
+	if (scsi_device_is_pseudo_dev(sdev))
+		return INT_MAX;
+
 	token =3D sbitmap_get(&sdev->budget_map);
 	if (token < 0)
 		return -1;
@@ -1749,7 +1758,8 @@ static void scsi_mq_put_budget(struct request_queue=
 *q, int budget_token)
 {
 	struct scsi_device *sdev =3D q->queuedata;
=20
-	sbitmap_put(&sdev->budget_map, budget_token);
+	if (budget_token < INT_MAX)
+		sbitmap_put(&sdev->budget_map, budget_token);
 }
=20
 /*
