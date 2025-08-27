Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B24F9D6
	for <linux-scsi@vger.kernel.org>; Wed, 27 Aug 2025 00:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756253341; cv=none; b=fjXbzmAuV1fReTTerU1kqPPoqMYMOnKnBxBy2BCAp2AFij8bt7xxdcjURzB8dTI4wF4XxOaKVKDwYm83lP7UP5jiGuj2vkWK3tQklcNdYIPXAItoGqrJ5WJCzl3btpwgRqy6cdlIJklXqevtELJcs5aPD7HEgB+tZqHr9BKay6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756253341; c=relaxed/simple;
	bh=d2bGuKqXG+D3hfnXJonpbGzHleUyQGgdE1oBMdtx2cE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMa+6aDJ6Be/exjasJDmqC8O2hH5UWr/6JRIN4xMOC6cq8NeN93WKoZe5Es/uuu0dfUaOMrPXVZ4VFDGLhc/GVKYk4yOSQvIhMBjesl1SJV2Lu1FbDwY4W85Iyj0Dtb1I2L9j6yTP9Tubu5TjD98v+Rgti1zHAXxv89iIy7AjDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=36DgtYSA; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="36DgtYSA"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cBPyf6NSgzm0ysy;
	Wed, 27 Aug 2025 00:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1756253337; x=1758845338; bh=+ykvf
	ADyz0Ppg5/hmNlZR7oMNFSG7VwkgDNgUPHAKI0=; b=36DgtYSA5mGSNUe1PtqwB
	6ZVOPH0EsXczCJ6fJEpl4Rxl38gciRFsyPguLXuzyp1xLXUYjZY8Xpx7P4LF7Mmj
	bAnKAEE3qlxb+aT+Hy0kMqTEeht+u7vlIWN75BKgG1+j9kEmZj9+NgS/K7iDQLOv
	Px6KL1WXYJWSGjdwwYKiMs+wuhPeJQVfQgcpDv75eRV1hpdT50uG84iomIw4AWAM
	0OH1c4nqaC12gNy96BgzgZdonBdyRXKNebU4NeaIJuto8B7ySczWFr+W/ywkF8Tm
	YJ0NAokdU7ayNmX0YK2LlwIehTuoBz/7kK5BUagRGskdl2Uqg6gA7J0IfD9ddp9V
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Mqh_kbhtsixW; Wed, 27 Aug 2025 00:08:57 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cBPyX3Kktzm0yQq;
	Wed, 27 Aug 2025 00:08:51 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	Ming Lei <ming.lei@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 03/26] scsi: core: Do not allocate a budget token for reserved commands
Date: Tue, 26 Aug 2025 17:06:07 -0700
Message-ID: <20250827000816.2370150-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
In-Reply-To: <20250827000816.2370150-1-bvanassche@acm.org>
References: <20250827000816.2370150-1-bvanassche@acm.org>
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
