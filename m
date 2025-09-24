Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D747532A81C
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 20:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758745938; cv=none; b=ubRVC6TGtGjNgZWodgvCLc0YFxPnYny2Ru43EION+nOk8DLLLYtPncNd3eiDCLl6aIq3BXoEQ0ptHOwLFt+seoOAViwlhQrEJhQ+dk8dUxz1RU+oTs8Kz8nKWWy+O/4fUbxuKx1FX8KUdLiRJod+OBGtLnBbhswtAt+rUWgbnvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758745938; c=relaxed/simple;
	bh=/oTD2JSbSigiVUCR7g4v5Lz7uwzeBGhvgU430yMwRPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSv9PvPADP0DhtKcW3h6SHyf5EgRsjWfvRk2CnpyzmrugTsVazzHjyzWPH+p/EQmYFiNHD4Q41aV/cVmeoigSolqxC9A4xrmeNCbSLumZbTBRCrTmmWXTyajTsxlzhr913mXG87vAd1myGHgkvLUViadOX8X15C5TiTZeBk7+Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=T1k3FgIr; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="T1k3FgIr"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cX7n96CnZzlgqxl;
	Wed, 24 Sep 2025 20:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1758745932; x=1761337933; bh=67cju
	xkG+0IyaPU7RRsUsJeDvua03Vfyrz8rY/BDBTc=; b=T1k3FgIrWIaan3/stvRFz
	2irbQ7za7szprDu8kBe5C+P/Zd5cIx/IxqBtp2jkZETH2stwGjoCkzP0nbv3ZNqh
	i9wbB8FTr3KaR8gege/WvmsEQ6V2z3nSeKNN0H9fcfOOdOHZ3T8J4N5zGr9MRPop
	an4P8OHMzmNPsxaJOmJaZcPu+/Fcvu2a45HCsM5HO69lGz6KmOJWVlfxo0ioxvwn
	ULKjneYuztRveeBF4Q2r23mXro5TMI5JpvzA3VkJBNN+byBM79PZ+uNbYxQEzyqZ
	5xCg1C+3Wt/1tI+6hsowiIU00VV90vDB9h1x7u4O3fhFx1o48doRxeHHbBu9vSWo
	A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 4KucCZ-Ztq3z; Wed, 24 Sep 2025 20:32:12 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cX7n4012QzltNPd;
	Wed, 24 Sep 2025 20:32:07 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	Ming Lei <ming.lei@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v5 03/28] scsi: core: Make the budget map optional
Date: Wed, 24 Sep 2025 13:30:22 -0700
Message-ID: <20250924203142.4073403-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
In-Reply-To: <20250924203142.4073403-1-bvanassche@acm.org>
References: <20250924203142.4073403-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Prepare for not allocating a budget map for pseudo SCSI devices by
checking whether a budget map has been allocated before using it.

Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi.c       | 5 +++++
 drivers/scsi/scsi_error.c | 3 +++
 drivers/scsi/scsi_lib.c   | 9 +++++++--
 drivers/scsi/scsi_scan.c  | 3 +++
 4 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 9a0f467264b3..a9d3e0242555 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -216,6 +216,9 @@ int scsi_device_max_queue_depth(struct scsi_device *s=
dev)
  */
 int scsi_change_queue_depth(struct scsi_device *sdev, int depth)
 {
+	if (WARN_ON_ONCE(!sdev->budget_map.map))
+		return -EINVAL;
+
 	depth =3D min_t(int, depth, scsi_device_max_queue_depth(sdev));
=20
 	if (depth > 0) {
@@ -255,6 +258,8 @@ EXPORT_SYMBOL(scsi_change_queue_depth);
  */
 int scsi_track_queue_full(struct scsi_device *sdev, int depth)
 {
+	if (!sdev->budget_map.map)
+		return 0;
=20
 	/*
 	 * Don't let QUEUE_FULLs on the same
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 746ff6a1f309..87636068cd37 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -749,6 +749,9 @@ static void scsi_handle_queue_ramp_up(struct scsi_dev=
ice *sdev)
 	const struct scsi_host_template *sht =3D sdev->host->hostt;
 	struct scsi_device *tmp_sdev;
=20
+	if (!sdev->budget_map.map)
+		return;
+
 	if (!sht->track_queue_depth ||
 	    sdev->queue_depth >=3D sdev->max_queue_depth)
 		return;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9c67e04265ce..8d711f6d8959 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -396,7 +396,8 @@ void scsi_device_unbusy(struct scsi_device *sdev, str=
uct scsi_cmnd *cmd)
 	if (starget->can_queue > 0)
 		atomic_dec(&starget->target_busy);
=20
-	sbitmap_put(&sdev->budget_map, cmd->budget_token);
+	if (sdev->budget_map.map)
+		sbitmap_put(&sdev->budget_map, cmd->budget_token);
 	cmd->budget_token =3D -1;
 }
=20
@@ -1360,6 +1361,9 @@ static inline int scsi_dev_queue_ready(struct reque=
st_queue *q,
 {
 	int token;
=20
+	if (!sdev->budget_map.map)
+		return INT_MAX;
+
 	token =3D sbitmap_get(&sdev->budget_map);
 	if (token < 0)
 		return -1;
@@ -1749,7 +1753,8 @@ static void scsi_mq_put_budget(struct request_queue=
 *q, int budget_token)
 {
 	struct scsi_device *sdev =3D q->queuedata;
=20
-	sbitmap_put(&sdev->budget_map, budget_token);
+	if (sdev->budget_map.map)
+		sbitmap_put(&sdev->budget_map, budget_token);
 }
=20
 /*
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index de039efef290..3267b36a6059 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -225,6 +225,9 @@ static int scsi_realloc_sdev_budget_map(struct scsi_d=
evice *sdev,
 	int ret;
 	struct sbitmap sb_backup;
=20
+	if (WARN_ON_ONCE(!sdev->budget_map.map))
+		return -EINVAL;
+
 	depth =3D min_t(unsigned int, depth, scsi_device_max_queue_depth(sdev))=
;
=20
 	/*
