Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB781F2C34
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2025 19:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761853069; cv=none; b=XDrPyTCCnQ02AsW4QVU6RZpmip8H+ZWancqu/uBnp8ZihBigvUNyxvb6htZV76sQrgFyQ4WObaj3Kxof3j9Gj0nm+ho/ur6BEWTyOzeSXFcsTv4/EmAOwBttaWOC/ADB9f2ki7CQf5wzjJtrB/u9MnveqFbJIxW7/PLlHyAPqPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761853069; c=relaxed/simple;
	bh=+nr6XVPjyPtbrufuomOVyxl1GUsk0LSN8QPzCAFvkxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RAXcTI1EMugYecHy4gSbCZ2hGc6SOllKeAhXr84nKmY2RRSo5vYGDTQ5hPbwlhFWDzf033KMRemD00pfir4iPGdQfFBiRpOJC2Gh55kjnFOg7mthUP0pbDhUQlxkILMY4LM0hAHnAdfEjO7FFfhANPmBmalGelihFuX/2MpqIwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=wRblTAE/; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="wRblTAE/"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cyDsl32q0zlvWhJ;
	Thu, 30 Oct 2025 19:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1761853065; x=1764445066; bh=ES9xo
	JbdAp2IlmckXJXybEpVB/wQYD40M7RxODsOxVE=; b=wRblTAE/nfig4PapDJJjj
	HHJ++ffg+Yu2fJJoFPtPjamxe0PAAbHejj3ytascFDFftOpUk87ZyPqKr3Zk+byJ
	Fv3EfDcSCDm+JGT1YT5smmovwbqGLK9fmIv5PHjmTPOENt9zBUWeULqgerYiYY9C
	IhvPKWMmle8Sn+jn0aRvPDM3aJyNhAUUX00WfQ7LWsA5udo12PyQwsnvhTkuyNsU
	QID5s34tPzVHPfnUel03oO0EDw85oHXoHIoPUPEEg5B2dpvMjChsH1ga3GC5Vmxc
	Ewf3c2v43MCu5RjLvZ7bMyp6Kr8r3T3sscpjIPvP0FMFjdUERz7V5zvcPkcG7MgZ
	Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id BjIZH6eKasb7; Thu, 30 Oct 2025 19:37:45 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cyDsf0GdKzlng8M;
	Thu, 30 Oct 2025 19:37:41 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	John Garry <john.g.garry@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v7 02/28] scsi: core: Move two statements
Date: Thu, 30 Oct 2025 12:36:01 -0700
Message-ID: <20251030193720.871635-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
In-Reply-To: <20251030193720.871635-1-bvanassche@acm.org>
References: <20251030193720.871635-1-bvanassche@acm.org>
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
