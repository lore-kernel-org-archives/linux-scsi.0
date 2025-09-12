Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C913009D5
	for <linux-scsi@vger.kernel.org>; Fri, 12 Sep 2025 18:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757701505; cv=none; b=fxLgpyKULvSPe1T/q0Dq2zcycbUtxm3vl1V2s6L+f/8S+E3IkBy6ylh/OiP76pMYAJ13zryozlrhHx9xiAHlELJE8JFId9XmMz5rnfLPUn1TfOQ/RxwAUnA2bxXS+vjkFUlwPj8UFVZvMvI6fN/G+xb9a1tZfNX4DYMxPUpwsnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757701505; c=relaxed/simple;
	bh=LLlLc8C6le6CVZuLNy80CWMR3UeyvVxz7byo8905hR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cK+tbfkRzasLPY00xJMm1ZdCmsaBizOLr1IBeVu9kj68cb3kdzr8bg08z6BX5TFxREkMPfQrKXp6W66W82X5dnboHYV2usB7KITmCHTcd27Xm5qll8BpsiQi+WyN9PpRqkLMo/QCA7fO9xLUMsaHHQvpq+yvIArIbs+ZpZtI66M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=JH4BxIId; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="JH4BxIId"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cNjWz07PwzlgqVx;
	Fri, 12 Sep 2025 18:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1757701501; x=1760293502; bh=L5nNr
	Z5/mTMLLyMpESgnJ7mt2nCGUSU9gZMLVzyaBRQ=; b=JH4BxIIdVJIEkcY9K0kl3
	zd+uD33ougsV01WrfZsHiy9UNaDvO6zDYTCt2UBdSIJsjNMZSvr4f4HaFqDgCxZY
	xFPKRWEUQZVyUvnPldEG5ZPsO6jqsvz5Z/QVTgzVZcDcsSf6icqHcD3pJ1A8d6UQ
	clsCY+ZydrGRUgG5mbyMwp5piyUzMeosDZNLNZ2AR/Zalw8U40oV899iJj4JSdyG
	WeoJBkxocQSAhjziL52eyWzAtaGn0Ffk6ZPknVpgM4yO3IFVU0lh2KJ7HSqXRMZZ
	AknFaHEJDKyo6SJZtibpwdJhyGaMSHK1KZRcY698KxROYKaESDkYd5XMeigrbQrX
	g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 7nVz_5GdtszZ; Fri, 12 Sep 2025 18:25:01 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cNjWr2GWVzltJQc;
	Fri, 12 Sep 2025 18:24:55 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	Ming Lei <ming.lei@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v4 03/29] scsi: core: Make the budget map optional
Date: Fri, 12 Sep 2025 11:21:24 -0700
Message-ID: <20250912182340.3487688-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
In-Reply-To: <20250912182340.3487688-1-bvanassche@acm.org>
References: <20250912182340.3487688-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Prepare for not allocating a budget map for pseudo SCSI devices by
checking whether a budget map has been allocated before using a budget
map.

Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi.c     |  2 ++
 drivers/scsi/scsi_lib.c | 14 ++++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 9a0f467264b3..ff6b0973d3b4 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -216,6 +216,8 @@ int scsi_device_max_queue_depth(struct scsi_device *s=
dev)
  */
 int scsi_change_queue_depth(struct scsi_device *sdev, int depth)
 {
+	WARN_ON_ONCE(!sdev->budget_map.map);
+
 	depth =3D min_t(int, depth, scsi_device_max_queue_depth(sdev));
=20
 	if (depth > 0) {
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9c67e04265ce..91a0c7f843c1 100644
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
+	if (!sdev->budget_map.map)
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
+	if (sdev->budget_map.map)
+		sbitmap_put(&sdev->budget_map, budget_token);
 }
=20
 /*
