Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D4232ED21
	for <linux-scsi@vger.kernel.org>; Fri, 12 Sep 2025 18:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757701501; cv=none; b=ildkzN22r6O4SOJinTnCFFTXFv+8Y7SIG8il0T3xUtWQVo6do6teasOAoNBYZCuGX+cKIscZ4UKwelvTMNhmhmag9wKzPszntr6OHFCkROITcOxai5i6qqKdeiRkzL5/8OxDLSeo2C8rNv7jps5uuH7ryDIzMSca3B0dX7WZD70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757701501; c=relaxed/simple;
	bh=5ZAbPdQ4aVdViQt5z8dvu7cl8ttBvgC/24qluXQiLQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rmSZ0h/DgUP3I5thFbntZxdMBs0LafM0AYfg43S+e8CVF12PERHvdlNiD9jkPKUKHuOnBkWDATRSKnnG9tdX/gZRh95LMCpIowtFwLsl+6PRIzWRIl2XHPUrcfDN+0Em5aDpnSe0v3m3Y1+UA+53vAwOjMcN+yHBVr4RyKoJS2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=tKHMdtn9; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="tKHMdtn9"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cNjWr6c2qzltJQj;
	Fri, 12 Sep 2025 18:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1757701495; x=1760293496; bh=4HYdA
	YlYfs7Zl9fXncxSayVDspfO+7ou17oofjzWJuE=; b=tKHMdtn9yQULzsw30/c1U
	NQJeVIlVhPSzCbqNhiUzSoMeaNXhYUWZyrkjgsrbe3TxjqI3KXnmwuAU4LTweqe9
	Y/xhGCJXpN7qtWvPlE+72pektd/q72qf6gBksEUZRgKQqaLI+ECXvlAwU7TsDDne
	W0zningvmgwjTsCZ1Zbzy1mbidxg3z/onv2tFjJOdM3P83K7aKtWXHBY/joRt6M1
	exwDRdY2rY3h4ZqPPvxvTmei7uavzpBpiqpxn6bneHf7km34XqDpzUJdz4JzeGz8
	T6R4rPR3959dDyLPrwc/zheirkJ71JwVkfYY5973f0GXQj9KpIN4GUXevDOh7NpX
	g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Z4qAR3ZykBZS; Fri, 12 Sep 2025 18:24:55 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cNjWj58fHzlgqVx;
	Fri, 12 Sep 2025 18:24:48 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	John Garry <john.g.garry@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v4 02/29] scsi: core: Move two statements
Date: Fri, 12 Sep 2025 11:21:23 -0700
Message-ID: <20250912182340.3487688-3-bvanassche@acm.org>
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

Move two statements that will be needed for pseudo SCSI devices in front
of code that won't be needed for pseudo SCSI devices. No functionality
has been changed.

CC: John Garry <john.g.garry@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>
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
