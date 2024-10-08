Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B76215F53
	for <linux-scsi@vger.kernel.org>; Tue,  8 Oct 2024 20:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728420785; cv=none; b=ElHKXGUwwRsDbdJlhDXJwX+PfyUv1sIxAJq5VhnFwRFBM5tTrQVtuS92zA88dXyE03HSbCPhjzfwaypU+lJZ+P7V+yN8TQJ4JxTuRFXpIJBo/ioNJ1n86YjcS4sDf6WoCjVtBZllYIoGOFrLYIDTILvdIXR3Lw34+YvlNXgN29M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728420785; c=relaxed/simple;
	bh=AaN+N0RQvF3137oh5sYyUwEdCeVY8lvIjaugjVF0Lf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ui7J24eDpUgxaMyL/Y9FKACZmMT79ed8BUb2eliiGGYjve7fZlC3wdG/c7mAl/jAslobKMVd+wGHnGVnCdUwO+kVfdiSX7DcmvTkAtWdwICeLkvv0Lex2hTgow7UCGMgYYLbZsXsgWan9tzdbfF13k+ev0amZHBBuTVyT8ybf34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=zBG+n5Ho; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="zBG+n5Ho"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XNSsC5gPyzlgMVP;
	Tue,  8 Oct 2024 20:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1728420780; x=1731012781; bh=TKrrN
	WHWAF/u5qQanl4M07Yclfr4qZ4t1TC8VqioXfg=; b=zBG+n5HoHnjifTT+OdmgH
	knTBTAJrm9HgOrgD/cSCbQIpru9ZUGeTzGctnD0O7u/ZnNhR3CoL8hVtGBoEV99H
	hemXIJ4rLa2fRHDUxa3wWkwVSmXjaa/B2thy56txng61yU1sUYYM8VYqsTAkFrGA
	t7KtrtACB6njFwGVELaDjzqrRPAmg6d3EDBkzXzFsvu58WumQ7sb3X5CcLMNB5em
	x2qvjYwQQ21zC61vxJn1Zd9gkKX7/W9j3AxaecC6soPC1dxvwaqyqBUTTQzT3WEl
	5FcRS10ABsRmXLdtzK63uOt8UW9+4JMKGYK+Vh8NwFTfkkCVbVWJVRmxS7Vx170e
	A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id w6UbInHXUctD; Tue,  8 Oct 2024 20:53:00 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XNSrr49fSzlgT1M;
	Tue,  8 Oct 2024 20:52:44 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 5/6] scsi: core: Remove the .slave_configure() method
Date: Tue,  8 Oct 2024 13:50:51 -0700
Message-ID: <20241008205139.3743722-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
In-Reply-To: <20241008205139.3743722-1-bvanassche@acm.org>
References: <20241008205139.3743722-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Now that all SCSI drivers have been converted from .slave_configure() to
.sdev_configure(), remove support for .slave_configure() from the SCSI
core.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_scan.c |  4 +---
 include/scsi/scsi_host.h | 10 +++-------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index abd2da3ef45f..f478c7c4ea24 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1076,8 +1076,6 @@ static int scsi_add_lun(struct scsi_device *sdev, u=
nsigned char *inq_result,
=20
 	if (hostt->sdev_configure)
 		ret =3D hostt->sdev_configure(sdev, &lim);
-	else if (hostt->slave_configure)
-		ret =3D hostt->slave_configure(sdev);
 	if (ret) {
 		queue_limits_cancel_update(sdev->request_queue);
 		/*
@@ -1102,7 +1100,7 @@ static int scsi_add_lun(struct scsi_device *sdev, u=
nsigned char *inq_result,
 	 * Set up budget map again since memory consumption of the map depends
 	 * on actual queue depth.
 	 */
-	if (hostt->sdev_configure || hostt->slave_configure)
+	if (hostt->sdev_configure)
 		scsi_realloc_sdev_budget_map(sdev, sdev->queue_depth);
=20
 	if (sdev->scsi_level >=3D SCSI_3)
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 7e1b1a54e46a..8fccfd27393e 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -169,11 +169,11 @@ struct scsi_host_template {
 	 *
 	 * Deallocation:  If we didn't find any devices at this ID, you will
 	 * get an immediate call to sdev_destroy().  If we find something
-	 * here then you will get a call to slave_configure(), then the
+	 * here then you will get a call to sdev_configure(), then the
 	 * device will be used for however long it is kept around, then when
 	 * the device is removed from the system (or * possibly at reboot
 	 * time), you will then get a call to sdev_destroy().  This is
-	 * assuming you implement slave_configure and sdev_destroy.
+	 * assuming you implement sdev_configure and sdev_destroy.
 	 * However, if you allocate memory and hang it off the device struct,
 	 * then you must implement the sdev_destroy() routine at a minimum
 	 * in order to avoid leaking memory
@@ -211,19 +211,15 @@ struct scsi_host_template {
 	 *     up after yourself before returning non-0
 	 *
 	 * Status: OPTIONAL
-	 *
-	 * Note: slave_configure is the legacy version, use sdev_configure for
-	 * all new code.  A driver must never define both.
 	 */
 	int (* sdev_configure)(struct scsi_device *, struct queue_limits *lim);
-	int (* slave_configure)(struct scsi_device *);
=20
 	/*
 	 * Immediately prior to deallocating the device and after all activity
 	 * has ceased the mid layer calls this point so that the low level
 	 * driver may completely detach itself from the scsi device and vice
 	 * versa.  The low level driver is responsible for freeing any memory
-	 * it allocated in the sdev_init or slave_configure calls.=20
+	 * it allocated in the sdev_init or sdev_configure calls.
 	 *
 	 * Status: OPTIONAL
 	 */
