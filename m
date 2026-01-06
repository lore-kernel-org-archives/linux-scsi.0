Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8488033C1B9
	for <linux-scsi@vger.kernel.org>; Tue,  6 Jan 2026 19:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767726490; cv=none; b=sVzBsaCs6Knx70fpA+c1fG/cjzZFNiYHW/J5V0P3I4nvjdoRn+tyu5/x9JyaKEuJg/Y6v2AQrLF2coINoEbV47t6gOhWkdN0ZQuFZTjimbO6g3/kK/6Lc+E85OtnTpPLZf7Us1omP6wekCkiQ5WWrekLDjM/znJ0VtbfhnWMoOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767726490; c=relaxed/simple;
	bh=dIuB3eeZMWUO0ElGX1Hz6JcD/dH2YPZbPCRbQ7Bib7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1COZzjY9BcEnS+XwJZfUiBgcpY3Myr6TZafJSoZzHHmcKLXWaKPQ9HW0cWACWPOEcAvBYk3B1J/qiyYnEWlDYFF6VjP32tgX4BeDJkEIaEhPnJSeLH3vhTxkEGZQjt70AvtjqvENcl8xQW7ZXPAc/CfBNgxRKcvYD6kJIukjkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=UTzPGxcN; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="UTzPGxcN"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dm1056XLyz1XSlJr;
	Tue,  6 Jan 2026 19:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1767726484; x=1770318485; bh=Pejb9
	Cw3auQhnUKw0dzxmnPM8EN8ZhIsQ2wwHNSREnQ=; b=UTzPGxcNkhLZgGx1OdpQV
	efxUnRqTvQQNzm34utp9VhZNBwrN9q5YvIuLrjtwNMXSN8i0NSMzohaJMJapvf/m
	ySiWWna5sYtmwxuv1FcSC+EZdEDECYk3JHoXfE9NMqmTrCjLTDjjDOSubfM9oemF
	iP+K3JV9WACca40chGXD8qcXpN3ftYYMzuA+Y0kDotlusYxOTKf9h2VXYdNOyEUf
	+sBUu5swdY11JpVHhJPlVWQjntAqtGklAJ54+cKHYTNdFKnZsQ15aaSDSbCAX5h3
	ofAhCdkaEQ/Jx2DobMmSZw1hA8qwlirsnPN/2Q7z6Rvagnd1gIWxKVleETiJh8RB
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id eMS7bJXKsHMv; Tue,  6 Jan 2026 19:08:04 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dm10267vmz1XScCW;
	Tue,  6 Jan 2026 19:08:02 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v5 1/5] scsi: sd: Move the sd_remove() function definition
Date: Tue,  6 Jan 2026 12:07:44 -0700
Message-ID: <20260106190749.2549070-2-bvanassche@acm.org>
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

Move the sd_remove() function definition such that the sd_shutdown()
forward declaration can be removed.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 53 +++++++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f50b92e63201..8da2a35499ed 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -108,7 +108,6 @@ static void sd_config_write_same(struct scsi_disk *sd=
kp,
 		struct queue_limits *lim);
 static void  sd_revalidate_disk(struct gendisk *);
 static void sd_unlock_native_capacity(struct gendisk *disk);
-static void sd_shutdown(struct device *);
 static void scsi_disk_release(struct device *cdev);
=20
 static DEFINE_IDA(sd_index_ida);
@@ -4087,32 +4086,6 @@ static int sd_probe(struct device *dev)
 	return error;
 }
=20
-/**
- *	sd_remove - called whenever a scsi disk (previously recognized by
- *	sd_probe) is detached from the system. It is called (potentially
- *	multiple times) during sd module unload.
- *	@dev: pointer to device object
- *
- *	Note: this function is invoked from the scsi mid-level.
- *	This function potentially frees up a device name (e.g. /dev/sdc)
- *	that could be re-used by a subsequent sd_probe().
- *	This function is not called when the built-in sd driver is "exit-ed".
- **/
-static int sd_remove(struct device *dev)
-{
-	struct scsi_disk *sdkp =3D dev_get_drvdata(dev);
-
-	scsi_autopm_get_device(sdkp->device);
-
-	device_del(&sdkp->disk_dev);
-	del_gendisk(sdkp->disk);
-	if (!sdkp->suspended)
-		sd_shutdown(dev);
-
-	put_disk(sdkp->disk);
-	return 0;
-}
-
 static void scsi_disk_release(struct device *dev)
 {
 	struct scsi_disk *sdkp =3D to_scsi_disk(dev);
@@ -4225,6 +4198,32 @@ static void sd_shutdown(struct device *dev)
 	}
 }
=20
+/**
+ *	sd_remove - called whenever a scsi disk (previously recognized by
+ *	sd_probe) is detached from the system. It is called (potentially
+ *	multiple times) during sd module unload.
+ *	@dev: pointer to device object
+ *
+ *	Note: this function is invoked from the scsi mid-level.
+ *	This function potentially frees up a device name (e.g. /dev/sdc)
+ *	that could be re-used by a subsequent sd_probe().
+ *	This function is not called when the built-in sd driver is "exit-ed".
+ **/
+static int sd_remove(struct device *dev)
+{
+	struct scsi_disk *sdkp =3D dev_get_drvdata(dev);
+
+	scsi_autopm_get_device(sdkp->device);
+
+	device_del(&sdkp->disk_dev);
+	del_gendisk(sdkp->disk);
+	if (!sdkp->suspended)
+		sd_shutdown(dev);
+
+	put_disk(sdkp->disk);
+	return 0;
+}
+
 static inline bool sd_do_start_stop(struct scsi_device *sdev, bool runti=
me)
 {
 	return (sdev->manage_system_start_stop && !runtime) ||
