Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE86633B976
	for <linux-scsi@vger.kernel.org>; Tue,  6 Jan 2026 19:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767726492; cv=none; b=JRHBCJe0pbdZL8Lvq1M9PH1VlfWyoQHswKVbPPq5gqeWqyerOJgdk7GUiPlNwBq8hg20O/+RvMQYg9OYE2QzDv0Ltc8HKvAp6gZEf6qTbl7F6U+uZyeOvgOfrdupEOEU0cnXAOq05N+WIPhCn5fsAcyZ205/Eo7JbzIcuRVsY5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767726492; c=relaxed/simple;
	bh=R/z6TbgvmEelCR+MJmID611Vt7wIdv2iYfHR2Z5QPEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/oWcfY5PuHHwgK23QGcYYs1eUtgOmbbhblQ/ch0Pj3jK8ZvVWYo80/w91G7N59t/pKcz9pNWCHATuTgDCKjkgZ/u9xKkJ1Zx46knDD3OSTpMmTlWBMvozQIDPvA+0rPjmmv7QrXYZZM29Gv6ZRRDZFQABwW6pB0gtolF9b1hZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=BAjO87DJ; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="BAjO87DJ"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dm1096VDRz1XSlKH;
	Tue,  6 Jan 2026 19:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1767726488; x=1770318489; bh=pRHTn
	SdEwg7/zAEuIbs3PudL1sfo780csqypNCiVu6w=; b=BAjO87DJRbtc6VsnVRGaD
	+tELNB64q1B8zU/GMVqkmgFzSscwJ6/iXgPbse/aCgWsd5jJpLaEpdR1hvyZ/qN9
	+vroZMshCIb8tdQXFO0tLMO3n+3E9D8n5gS46Ww2QIQnhzFTxla/ah2xWjjn3DHy
	dpvfhtootllbBFlOZeHO2VJqyMxZiFym6w/+oYJ3OusFLeCpKnds6yOgsRyTNqn7
	p5OFFuz2Voa4DAQha5QasUQt7rwQr7pp9qtdEXINoQMMeUwcTZSRtiY9sHRxEKrd
	wMSguj5pOPJWU1aA4T4WLq9ipV8CLEg+rjNJ3HbPUfCT05z9dVZyZ/8XzUPchcA1
	Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id hlJFZoF956HE; Tue,  6 Jan 2026 19:08:08 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dm1064QF7z1XSlK5;
	Tue,  6 Jan 2026 19:08:06 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v5 3/5] scsi: sd: Move the scsi_disk_release() function definition
Date: Tue,  6 Jan 2026 12:07:46 -0700
Message-ID: <20260106190749.2549070-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
In-Reply-To: <20260106190749.2549070-1-bvanassche@acm.org>
References: <20260106190749.2549070-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Move the scsi_disk_release() function definition such that its forward
declaration can be removed.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 692453004d78..3cd9d552de9e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -106,7 +106,6 @@ static void sd_config_write_same(struct scsi_disk *sd=
kp,
 		struct queue_limits *lim);
 static void  sd_revalidate_disk(struct gendisk *);
 static void sd_unlock_native_capacity(struct gendisk *disk);
-static void scsi_disk_release(struct device *cdev);
=20
 static DEFINE_IDA(sd_index_ida);
=20
@@ -751,6 +750,17 @@ static struct attribute *sd_disk_attrs[] =3D {
 };
 ATTRIBUTE_GROUPS(sd_disk);
=20
+static void scsi_disk_release(struct device *dev)
+{
+	struct scsi_disk *sdkp =3D to_scsi_disk(dev);
+
+	ida_free(&sd_index_ida, sdkp->index);
+	put_device(&sdkp->device->sdev_gendev);
+	free_opal_dev(sdkp->opal_dev);
+
+	kfree(sdkp);
+}
+
 static struct class sd_disk_class =3D {
 	.name		=3D "scsi_disk",
 	.dev_release	=3D scsi_disk_release,
@@ -4084,17 +4094,6 @@ static int sd_probe(struct device *dev)
 	return error;
 }
=20
-static void scsi_disk_release(struct device *dev)
-{
-	struct scsi_disk *sdkp =3D to_scsi_disk(dev);
-
-	ida_free(&sd_index_ida, sdkp->index);
-	put_device(&sdkp->device->sdev_gendev);
-	free_opal_dev(sdkp->opal_dev);
-
-	kfree(sdkp);
-}
-
 static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 {
 	unsigned char cmd[6] =3D { START_STOP };	/* START_VALID */
