Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9556829D28B
	for <linux-scsi@vger.kernel.org>; Fri, 31 Oct 2025 20:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761943264; cv=none; b=XBnrg+wZkxTteNlyq92dJuEhHQWa/Y2DASUKEORaIHGDcKOginfN81Ekvd6ldxuDnmQXmUfAqeBesFWtr22mi4Eu1VWdQjjL1j3EVwf9FWhxeKWRDf10IOYMxH4onvsvT2kWVkztwgGSlurbHjeYUkRhaWOHIhuXQ3wRZA7Bpqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761943264; c=relaxed/simple;
	bh=Fn0r71KK+K5XU/MG0bF+m48LHaGIX3qhbcFHNer23Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jma9oOpz2BR2Pv0DH2EMgo+TUbEa/8j0m+WXZjgWJ+0pk3f4ifc5Wi+iXM/GZdU7M1ldKCwjHNzeQ4/Ujf2Swa+mO2xVWPyUVj4g2rJqNxbnqD5CF8Qk2I4bEVko/ENkH1BcHbEap3HVeJRKA2xnFLSqCtwkhRmuLoqmKOU0TzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=v+MX7JOr; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="v+MX7JOr"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cytDF4sgszm0pKT;
	Fri, 31 Oct 2025 20:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1761943260; x=1764535261; bh=ENlHm
	PxLgr3kpDMAyVjcF/4CgYFX1TJF5IdrKKEHUVk=; b=v+MX7JOr4MjtpS4w5yov9
	lSTkN2gqBGDQvO1irqZbCc+YBl0/RmG4HFCENfp5Qbqi2ksrIbMSQd23ghuvYN7V
	2lAdH6dR01FxD5XovDgzzUiJZoMZcR5j+bBdOmrTcexwc1KW5l1NGlOaSeQX3nwW
	2VTN5AX6KtfxqafhxMfC2dsksU/gy39T/798zLAgHYh28cE2eQjDw0FKyrqPHUG0
	eXoXpNFF9uCmo0GDVqQyhZrXDUCOSEUIUTPHu6jWvRi1yk8sDPSzBOwFfy7Y0uOT
	9GiC62eJRBHzVpBZumZzo0WjCXFf94BNnpCVEaLnm9PcrgT9In7ga/suF0Sjtscf
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id OMESvyxmPhF2; Fri, 31 Oct 2025 20:41:00 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cytD73mF8zm0jvG;
	Fri, 31 Oct 2025 20:40:54 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	Ming Lei <ming.lei@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v8 03/28] scsi: core: Make the budget map optional
Date: Fri, 31 Oct 2025 13:39:11 -0700
Message-ID: <20251031204029.2883185-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
In-Reply-To: <20251031204029.2883185-1-bvanassche@acm.org>
References: <20251031204029.2883185-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Prepare for not allocating a budget map for pseudo SCSI devices by
checking whether a budget map has been allocated before using it.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi.c       | 5 +++++
 drivers/scsi/scsi_error.c | 3 +++
 drivers/scsi/scsi_lib.c   | 9 +++++++--
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 9a0f467264b3..589ae28b2c8b 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -216,6 +216,9 @@ int scsi_device_max_queue_depth(struct scsi_device *s=
dev)
  */
 int scsi_change_queue_depth(struct scsi_device *sdev, int depth)
 {
+	if (!sdev->budget_map.map)
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
index d52bbbe5a357..53ff348b3a4c 100644
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
