Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287262A1BF
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 20:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758745931; cv=none; b=aNnbtxxLXGQNj8m1bAZHzr6/R3a5FKne83uO2Z7gagpObiDf4L30vSLh68hoLetlxKF/QqPkca2qgq4loi2qKyWOawRm2ZLfhxCOgfSAhRBpu6za+qzgJvCVSUtP32vEqdIvpffVjsowBbpfBJuf6esjy7tUVR3bxZ0xPNKcpRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758745931; c=relaxed/simple;
	bh=+nr6XVPjyPtbrufuomOVyxl1GUsk0LSN8QPzCAFvkxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=knHzmJi/ZRprnaHvKb26RtNY7nf2x57jaGrtCMEf/KxZmt86O4iQEWNLYJ1rMlGhklKIys5LP6SRrxOSAlLUxh+z7AiT0PVlmkB6uLXbQp5kXRn1qKvnbVzYojmLZftmC+OKE0cv+G8fWLE6hZqbXMz4Xi+KhkMuFN8g3VKbVOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=sCgwGxiQ; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="sCgwGxiQ"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cX7n41D7BzltKGg;
	Wed, 24 Sep 2025 20:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1758745926; x=1761337927; bh=ES9xo
	JbdAp2IlmckXJXybEpVB/wQYD40M7RxODsOxVE=; b=sCgwGxiQjfbzFCf+EUFvC
	VY7JgrQCSq4UKfFtCH8DgZF3C0n8/zL8AUS64tt1QKZ3F6M/2fAXsGdaKUKSr76t
	aiHhU+kSaeSDI6UZWfE9o4/rVNUsjw08ZEs8xcx1lpps940YcmSa/RH7dt0ITgNE
	dNAjQ/rUDHDhI8UR6ma0fHwT7y7mBhrV8Ic7qS/1jydm04sp+RJKMS/IfuXXhBgf
	n2FwiwBSME1rygNlZP52+sB8TMJKnEGrUpesZtCt7ttU91hGR3BH1u4qLoBWnXkF
	pxvElBtzwJk2Ee9Rgr++xNybOp2TzXDMPsKQWm+IV/7SyXT0VrgStjX5YSN5AID/
	Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id c7sYat93juHe; Wed, 24 Sep 2025 20:32:06 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cX7mz1Q54zlgqyg;
	Wed, 24 Sep 2025 20:32:02 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	John Garry <john.g.garry@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v5 02/28] scsi: core: Move two statements
Date: Wed, 24 Sep 2025 13:30:21 -0700
Message-ID: <20250924203142.4073403-3-bvanassche@acm.org>
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

Move two statements that will be needed for pseudo SCSI devices in front
of code that won't be needed for pseudo SCSI devices. No functionality
has been changed.

Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_scan.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3c6e089e80c3..de039efef290 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -347,6 +347,8 @@ static struct scsi_device *scsi_alloc_sdev(struct scs=
i_target *starget,
 	kref_get(&sdev->host->tagset_refcnt);
 	sdev->request_queue =3D q;
=20
+	scsi_sysfs_device_initialize(sdev);
+
 	depth =3D sdev->host->cmd_per_lun ?: 1;
=20
 	/*
@@ -363,8 +365,6 @@ static struct scsi_device *scsi_alloc_sdev(struct scs=
i_target *starget,
=20
 	scsi_change_queue_depth(sdev, depth);
=20
-	scsi_sysfs_device_initialize(sdev);
-
 	if (shost->hostt->sdev_init) {
 		ret =3D shost->hostt->sdev_init(sdev);
 		if (ret) {
@@ -1068,6 +1068,8 @@ static int scsi_add_lun(struct scsi_device *sdev, u=
nsigned char *inq_result,
=20
 	transport_configure_device(&sdev->sdev_gendev);
=20
+	sdev->sdev_bflags =3D *bflags;
+
 	/*
 	 * No need to freeze the queue as it isn't reachable to anyone else yet=
.
 	 */
@@ -1113,7 +1115,6 @@ static int scsi_add_lun(struct scsi_device *sdev, u=
nsigned char *inq_result,
=20
 	sdev->max_queue_depth =3D sdev->queue_depth;
 	WARN_ON_ONCE(sdev->max_queue_depth > sdev->budget_map.depth);
-	sdev->sdev_bflags =3D *bflags;
=20
 	/*
 	 * Ok, the device is now all set up, we can
