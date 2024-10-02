Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3AE11D278D
	for <linux-scsi@vger.kernel.org>; Wed,  2 Oct 2024 20:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727901452; cv=none; b=r5PIB4/J7UbVIVeOvRwtKYyLdQmSeQJ4F+DKscaAbr7FFVgYmih+IOPdVt/KKmm3cGdMV8rG9LL5WpQEYxDYM5dUQXMuV+bY+FStFOHMfUd03N/NqDB7I4oHYJOBxS7QDkbxT0IxmHcgDT4JhB0GC5OsSSAQeFBfqvhlSZjlCRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727901452; c=relaxed/simple;
	bh=y6jjVP7TrtRvCc+U/dePHx2wih/VoCjT/BPGuleR0/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FrwRbm52h5pOjZTDnBmjZZBaW4o0Mvid9N2bKmzvpgocSd9UX3ztP7PITN5PeTZW7yTNMTlQzYQ4GLB+d9lMw2gRgJez/hyG5esQAuA43ZrXOBXBqeNrWt5R0N1bBMe6eDcytHP5B9MEb1KDrZXKUufWcMSfMX9pS6Vrg4Mhd/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DYrX8CFW; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DYrX8CFW"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XJmp24jpvzlgMWM;
	Wed,  2 Oct 2024 20:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1727901447; x=1730493448; bh=BDId8
	7jkV6zV8oO7rSAdA0yfvEac4/UWcnIZz449qB8=; b=DYrX8CFWvW/MH0GngyZCQ
	leOLr18Wh1IVY9bxABxMZRkfu+XkbOkK46qukeVe9sH/ORw8xHGztQl7OsCGOhl6
	lKqkDG05pEKOi7Ac1zBSWokzKwFOrkN/97qTdqV6rI5btEzzGIpsCDvcD8QFklQK
	Tb/KnnOqhU5MEyeWO2Rtfwd1UrMolkl42RnWGlMqzoZkIS29+sAPG+8PsP66YRp9
	Ahg6o7aeV5aAoa+s3TOz6in4YR7JwfgnRthEkFphkVp2M8vTf6zoDR6W2D23XtUT
	riUREJ+ZNG+17ECTy+xgaNg8EBKTf1BRb9k/vPlAIUe/GV0T4aQ7qAr7DB2bW8zD
	A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6neKpal9KACe; Wed,  2 Oct 2024 20:37:27 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XJmnf0Ml8zlgMWN;
	Wed,  2 Oct 2024 20:37:09 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 10/11] scsi: core: Remove the .slave_configure() method
Date: Wed,  2 Oct 2024 13:34:02 -0700
Message-ID: <20241002203528.4104996-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.1.824.gd892dcdcdd-goog
In-Reply-To: <20241002203528.4104996-1-bvanassche@acm.org>
References: <20241002203528.4104996-1-bvanassche@acm.org>
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

Cc: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_scan.c |  4 +---
 include/scsi/scsi_host.h | 10 +++-------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 8eae48b0b821..f1830401b9c1 100644
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
index abf203544d47..7ae99c6d26cb 100644
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
-	 * it allocated in the sdev_prep or slave_configure calls.=20
+	 * it allocated in the sdev_prep or sdev_configure calls.
 	 *
 	 * Status: OPTIONAL
 	 */
