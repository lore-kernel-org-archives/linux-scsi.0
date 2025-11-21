Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F1323D7E6
	for <linux-scsi@vger.kernel.org>; Fri, 21 Nov 2025 18:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763749294; cv=none; b=dppHADyB+IuqmJOK40ioLfoPe3gg7vBFCb/vLdQRkl9/6au0x2VHROOhiNWSpHer+ZmKUi8hT2/1r99gx2UGU1S9GtT87Kv0b/M6YhGplPHkJ9zJdmSD0aTo6KnQn8KOoud9z19z0k46sMi+959VYjLFqXSvd89YdgBBq6EK7L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763749294; c=relaxed/simple;
	bh=GpljxHR8VKZwIDuDfBZ4uKHbOaT99/BHj6bY/lVkh9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QGzQHVaFs7JAzMReudCgVVNZgRTSfYpfPffSt9OoO5uM7UBZtGbKvISY/BbLF4XYxHT81ppeH/qHQfZhU7eWfLT01pMlWdQMtinD3gb3Er9J5Tm42LJi4++ZJAgY6Ot9sxObZ9RKluIhdUTalPTWZb4lKAeSfcV1Tyb+ImuSVms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=AAvoWa2o; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="AAvoWa2o"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4dCk7b1mMqzlvF89;
	Fri, 21 Nov 2025 18:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1763749289; x=1766341290; bh=lHNrl
	NvPrqeZEkX5zWZHjY7/j7SkwoGuOVoXyVX3K3E=; b=AAvoWa2or4XDj4ASIojvp
	c0LWSLB17CmKI9AmlEp/BX4j6Zlhm8Ga92vsqv7lkCOwJ5SvL4009/zKKiN6i5uy
	aHPQPwFo8uJWFSq5Z+gLwzlb/Vbq1MrmE7Pw0zcKOXph/s6eW6oUeEzpl4G6T/8g
	BKz9IBHEp0toKkXWQ3jGrk+MykzbX5Jasaog0iQNqJ6/Wr9EnUPqwfUhMdzE8fAr
	bqudddg0KwvGPx9Mcv0SDhCXna6RGvn4/JVHdS5u0Yqv94jl+MW50X5nAGpvoUv4
	VwFPfCYWlTGLCtiN7nzA7So2s09xucMFhaf8sUVjwzwwnW+HaKb11wOZ0C1iGBCa
	Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id u_3WqNJ9h2ov; Fri, 21 Nov 2025 18:21:29 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4dCk7T6zHvzlvDRk;
	Fri, 21 Nov 2025 18:21:25 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 1/5] scsi: sd: Move the sd_remove() function definition
Date: Fri, 21 Nov 2025 10:21:06 -0800
Message-ID: <20251121182112.3485615-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
In-Reply-To: <20251121182112.3485615-1-bvanassche@acm.org>
References: <20251121182112.3485615-1-bvanassche@acm.org>
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
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 53 +++++++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f2c0744b4480..0b479153abb8 100644
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
@@ -4077,32 +4076,6 @@ static int sd_probe(struct device *dev)
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
@@ -4215,6 +4188,32 @@ static void sd_shutdown(struct device *dev)
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
