Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2401A2545
	for <linux-scsi@vger.kernel.org>; Mon, 30 Sep 2024 20:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727727723; cv=none; b=b5KpWY4NKDCBy2RDcL4SSkbbjdqND72/vEMEaiF7E49hSGm932CayDvcHHdTeLqNlNOK+PL5rvo0OAmHSYiNHKfGX6o0SMGOtd4Dm70uw3TUF9d7LJAn2yyKvLFriBrMJCjmlKy7DLbE5ct8seTy5Q4UxBGWzHKVyzVHes1bEUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727727723; c=relaxed/simple;
	bh=1wyh8oZlX0eto5DWPsmLVQ5D6vPFj3cRdU/TSoP703I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fd+Pa6FWWdiaPbihMk+rshSYKnmvx/65nRz+4RMTU4oCrCrI0kyjWl8TXLH+j9G44BR9UcqIq+fkuq/GYarGlVnSVSNmRryjZfJ2TV1A9N2xOx5sKVIb6PHB9SaCAk/0jc8Bb45MuUanRraW0851tLuXVIAZ5PncoCRMqI7auL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pTpym/hA; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pTpym/hA"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XHXY542Bcz6ClY9Z;
	Mon, 30 Sep 2024 20:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1727727718; x=1730319719; bh=CEN9T
	7y/xsdW1CW/WDVfxJkfDKyspZNf/WEOqAX9WJA=; b=pTpym/hAzDzDuo2jH6rgf
	XPMTp6pRToBAEMN7jURNauE2QAFE+5dfE35V7hK9MUrOl6mi4q+rHFayz/Pi7lmD
	65puijG7IPgsBFPCFjQgxvAQ4+nSstHV+fhUO5NvoDaeNaaTn3MC0fEwXTwsfIlc
	I5x6wXhwud5iXYReWR9V0iM+M+yGS9VteEBo3MzALOdiizch9SP9ErCeXPOM28Vm
	F7CgioqHhU/7RIkoF4KFfThelsXrhRTCtEK33qRdC/UWWXBS7BGf3BLzMRqugxmj
	xyaXtEvbnqVwZAHD2an8VrXt9nI8KpIcZdRoQ+QMaGnRkCSU7ME/c1WLxvZQ8z+T
	Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ONrqsrc2ecy3; Mon, 30 Sep 2024 20:21:58 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XHXWq3Lffz6ClY9b;
	Mon, 30 Sep 2024 20:20:55 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 3/4] scsi: core: Remove .slave_configure()
Date: Mon, 30 Sep 2024 13:18:49 -0700
Message-ID: <20240930201937.2020129-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.1.824.gd892dcdcdd-goog
In-Reply-To: <20240930201937.2020129-1-bvanassche@acm.org>
References: <20240930201937.2020129-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Now that all SCSI drivers have been converted from .slave_configure() to
.device_configure(), remove support for .slave_configure() from the SCSI
core. Change all references to .slave_configure() in the SCSI documentati=
on
into references to .device_configure().

Cc: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_scan.c |  4 +---
 include/scsi/scsi_host.h | 10 +++-------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 05ea1e781d21..bb4ebb744b69 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1076,8 +1076,6 @@ static int scsi_add_lun(struct scsi_device *sdev, u=
nsigned char *inq_result,
=20
 	if (hostt->device_configure)
 		ret =3D hostt->device_configure(sdev, &lim);
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
-	if (hostt->device_configure || hostt->slave_configure)
+	if (hostt->device_configure)
 		scsi_realloc_sdev_budget_map(sdev, sdev->queue_depth);
=20
 	if (sdev->scsi_level >=3D SCSI_3)
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 934aae4254c3..28df2bd7af46 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -169,11 +169,11 @@ struct scsi_host_template {
 	 *
 	 * Deallocation:  If we didn't find any devices at this ID, you will
 	 * get an immediate call to device_destroy().  If we find something
-	 * here then you will get a call to slave_configure(), then the
+	 * here then you will get a call to device_configure(), then the
 	 * device will be used for however long it is kept around, then when
 	 * the device is removed from the system (or * possibly at reboot
 	 * time), you will then get a call to device_destroy().  This is
-	 * assuming you implement slave_configure and device_destroy.
+	 * assuming you implement device_configure and device_destroy.
 	 * However, if you allocate memory and hang it off the device struct,
 	 * then you must implement the device_destroy() routine at a minimum
 	 * in order to avoid leaking memory
@@ -211,19 +211,15 @@ struct scsi_host_template {
 	 *     up after yourself before returning non-0
 	 *
 	 * Status: OPTIONAL
-	 *
-	 * Note: slave_configure is the legacy version, use device_configure fo=
r
-	 * all new code.  A driver must never define both.
 	 */
 	int (* device_configure)(struct scsi_device *, struct queue_limits *lim=
);
-	int (* slave_configure)(struct scsi_device *);
=20
 	/*
 	 * Immediately prior to deallocating the device and after all activity
 	 * has ceased the mid layer calls this point so that the low level
 	 * driver may completely detach itself from the scsi device and vice
 	 * versa.  The low level driver is responsible for freeing any memory
-	 * it allocated in the device_alloc or slave_configure calls.=20
+	 * it allocated in the device_alloc or device_configure calls.=20
 	 *
 	 * Status: OPTIONAL
 	 */
