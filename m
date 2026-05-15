Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35283806BE
	for <linux-scsi@vger.kernel.org>; Fri, 15 May 2026 20:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778878370; cv=none; b=XlNatHGa/vKSqan89P8SMNj5yzuSUfgg16YvNTXg9PDHN5hRgwMu8+cQnM26MFDMEbvtome+geI78cGcjhh+kfpk7+c7c/vlgpJfqWmJjcRxVOIObdyJwtrZfFnuSmi6u7txKPDufAHr1nbghIX7RaxiA720hvYVZEZQDflenSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778878370; c=relaxed/simple;
	bh=wBQ9hMRO+l63GN+d+EpJRSdYSmSvQhMN4oh2ZZFtpJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rC5GdAx0VjbmBboQogcUB9wrnoK+WkweH9P7HBQ1PDEfBhJ+UoQv13Dbd7E/7UMOA+L6KPQ96jF0nRcoFm2FWkGSUpOXsPhHl/nmnt0gTVMx6HVithXWOJrOmLcLEwzs2Axph5ZwhSv6w+5Q/Hq2WdVd4uwJ+prQZxxcl0cJirI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ydJXpr5X; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ydJXpr5X"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gHKCM3fHTzlgd7G;
	Fri, 15 May 2026 20:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1778878361; x=1781470362; bh=IOxE5
	5BgbYkHHTKhyaDrFp3RA4xIKynrcJE2FvWDdVY=; b=ydJXpr5XLqV6sojG+BFtr
	79J7Wq7+vkxXukuzbqiTLeE89Ed18lkELZfsHzjqrSJKzbHIcH1RZZb5My6MqNT/
	fd7yKj+2e6KHbJ6htUHOhHCh51oho3kG9OPnI9246Jys/1QozMVkvLoa8kPLBOFc
	190Zo5JDq7F9LV6zjMgHlnpLBbZz0JJjNdMEggbTi7/+Kb1Kna8MifcLZna/agfv
	3mSHNrn5BruUvERUgn/b2SFlhWq0Oih3caYEyCq4v/opjHbE9HpXms0LZpnOtr6P
	V+ayRqq+MuGXsuaS6EGN+M2vHJrPwLE4C49iYdRmuQYKxPp8992ZYNKnIb03zfmK
	A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id sRxj0uKYmcll; Fri, 15 May 2026 20:52:41 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gHKCC0tzCzlgqqp;
	Fri, 15 May 2026 20:52:38 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Brian Bunker <brian@purestorage.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Guenter Roeck <linux@roeck-us.net>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 3/3] scsi: core: Convert INQUIRY information
Date: Fri, 15 May 2026 13:52:21 -0700
Message-ID: <20260515205222.1754621-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
In-Reply-To: <20260515205222.1754621-1-bvanassche@acm.org>
References: <20260515205222.1754621-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Currently the vendor, model, and revision members of struct scsi_device
are pointers to fixed-length strings that are not NUL-terminated.
Fixed-precision format specifiers (e.g., "%.8s") are required whenever
they are printed and strncmp() must be used to compare these fields.
This is error-prone.

Convert these fields to fixed-size character arrays within struct
scsi_device. Remove an !sdev->model check because sdev->model is now
guaranteed not to be NULL.

This patch fixes a bug in the qla2xxx driver. It makes the following
code safe:

		if (state_flags & BIT_4)
			scmd_printk(KERN_WARNING, cp,
			    "Unsupported device '%s' found.\n",
			    cp->device->vendor);

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/hwmon/drivetemp.c  |  5 +----
 drivers/scsi/scsi_scan.c   | 18 ++++++++++++------
 include/scsi/scsi_device.h |  7 ++++---
 3 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/hwmon/drivetemp.c b/drivers/hwmon/drivetemp.c
index 002e0660a0b8..efe8b229bdbe 100644
--- a/drivers/hwmon/drivetemp.c
+++ b/drivers/hwmon/drivetemp.c
@@ -306,13 +306,10 @@ static bool drivetemp_sct_avoid(struct drivetemp_da=
ta *st)
 	struct scsi_device *sdev =3D st->sdev;
 	unsigned int ctr;
=20
-	if (!sdev->model)
-		return false;
-
 	/*
 	 * The "model" field contains just the raw SCSI INQUIRY response
 	 * "product identification" field, which has a width of 16 bytes.
-	 * This field is space-filled, but is NOT NULL-terminated.
+	 * This field is space-filled and NUL-terminated.
 	 */
 	for (ctr =3D 0; ctr < ARRAY_SIZE(sct_avoid_models); ctr++)
 		if (!strncmp(sdev->model, sct_avoid_models[ctr],
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index b0473f4595c1..7e60e3a4bca6 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -292,9 +292,9 @@ static struct scsi_device *scsi_alloc_sdev(struct scs=
i_target *starget,
 	if (!sdev)
 		goto out;
=20
-	sdev->vendor =3D scsi_null_device_strs;
-	sdev->model =3D scsi_null_device_strs;
-	sdev->rev =3D scsi_null_device_strs;
+	strscpy(sdev->vendor, scsi_null_device_strs);
+	strscpy(sdev->model, scsi_null_device_strs);
+	strscpy(sdev->rev, scsi_null_device_strs);
 	sdev->host =3D shost;
 	sdev->queue_ramp_up_period =3D SCSI_DEFAULT_RAMP_UP_PERIOD;
 	sdev->id =3D starget->id;
@@ -910,9 +910,15 @@ static int scsi_add_lun(struct scsi_device *sdev, un=
signed char *inq_result,
 	if (sdev->inquiry =3D=3D NULL)
 		return SCSI_SCAN_NO_RESPONSE;
=20
-	sdev->vendor =3D (char *) (sdev->inquiry + 8);
-	sdev->model =3D (char *) (sdev->inquiry + 16);
-	sdev->rev =3D (char *) (sdev->inquiry + 32);
+	strscpy(sdev->vendor, sdev->inquiry + INQUIRY_VENDOR_OFFSET);
+	strscpy(sdev->model, sdev->inquiry + INQUIRY_MODEL_OFFSET);
+	/*
+	 * memcpy() instead of strscpy() because strscpy() would read past
+	 * the end of sdev->inquiry if its length is exactly 36 bytes.
+	 */
+	memcpy(sdev->rev, sdev->inquiry + INQUIRY_REVISION_OFFSET,
+	       INQUIRY_REVISION_LEN);
+	sdev->rev[INQUIRY_REVISION_LEN] =3D '\0';
=20
 	sdev->is_ata =3D strncmp(sdev->vendor, "ATA     ", 8) =3D=3D 0;
 	if (sdev->is_ata) {
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 9c2a7bbe5891..029f5115b2ea 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -7,6 +7,7 @@
 #include <linux/workqueue.h>
 #include <linux/blk-mq.h>
 #include <scsi/scsi.h>
+#include <scsi/scsi_common.h>
 #include <linux/atomic.h>
 #include <linux/sbitmap.h>
=20
@@ -137,9 +138,9 @@ struct scsi_device {
 	struct mutex inquiry_mutex;
 	unsigned char inquiry_len;	/* valid bytes in 'inquiry' */
 	unsigned char * inquiry;	/* INQUIRY response data */
-	const char * vendor;		/* [back_compat] point into 'inquiry' ... */
-	const char * model;		/* ... after scan; point to static string */
-	const char * rev;		/* ... "nullnullnullnull" before scan */
+	char vendor[INQUIRY_VENDOR_LEN + 1];
+	char model[INQUIRY_MODEL_LEN + 1];
+	char rev[INQUIRY_REVISION_LEN + 1];
=20
 #define SCSI_DEFAULT_VPD_LEN	255	/* default SCSI VPD page size (max) */
 	struct scsi_vpd __rcu *vpd_pg0;
