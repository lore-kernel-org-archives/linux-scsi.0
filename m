Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6FA322C99
	for <linux-scsi@vger.kernel.org>; Wed, 14 Jan 2026 17:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768413076; cv=none; b=RbIPZvRYXS5pyRBaFDI/sCTbbLnVck2vox3Prx/tcnY8FUkNoKh53KMc5nkYJ6mZbg7TLAV/drabpehNX0y2jghwG17rwGe+GN/sUBgIwMF++ettLZu+gRRxQ2u5jofGyN7JpWEE4ewwXlGCqRKRiaA8hOHhs1RSaYejoMEeXJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768413076; c=relaxed/simple;
	bh=g7WXiX9/bWJbk1BoRIXHNs9eUn7PdsfyxrX8h2Vx6N4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MbM00zDu8SO0KV70e+OhH3d4sb99axBFI4Gkzo354kAGB1EKWY73YcppNSioJeUcA+jEpG4uoE0wDjfLlkBGQgc6kJPzMFjGAczXWDobha3qsiasrVQnZYuDjUEjqjY8WoYp+3o5u/r56qLQwIe4aM/XHHMAQPmprY8dnjILAdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=AUjJykJg; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="AUjJykJg"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4drtvd5M1zzllCWV;
	Wed, 14 Jan 2026 17:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1768413068; x=1771005069; bh=LRmd6
	A3h02rahavDAt+JamQy2cVv3Ac1AbVNtNLZnjw=; b=AUjJykJg1jGBrWV8aSsqv
	99mgukfYPp0tIUfch54xNMUEqCvGZXyJNWNg0G+yuKoqWM/xiafuW7WXV0qburco
	JwZX8pebt62nWKKHC14/ieidDg7MUiRxOTvFf8EoY+YT2UiG7N+i25+qBudN0btE
	5MSa1O06QfVtlvpv5NibM56kdIIroSJiBcN2ZvNUE1LllgAghYr+a9UMjteOZD+2
	au+A0pI4oxg6ovGhexfS0KRlvNvvmWcZr7DAJTsgsEstwQzOvl2kaBUpdwNK4vYP
	eSQC1z8dLwH0t6IqKUsnThP2b079En8M88U3O5lhO9e5oOYz7HwSY0z1i6gMbJ7H
	A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ypgUU5EN599l; Wed, 14 Jan 2026 17:51:08 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4drtvZ49LZzllCWp;
	Wed, 14 Jan 2026 17:51:06 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v6 1/5] scsi: sd: Move the sd_remove() function definition
Date: Wed, 14 Jan 2026 09:50:49 -0800
Message-ID: <20260114175054.4118163-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
In-Reply-To: <20260114175054.4118163-1-bvanassche@acm.org>
References: <20260114175054.4118163-1-bvanassche@acm.org>
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
index dc7eac6211bc..b30c50693372 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -108,7 +108,6 @@ static void sd_config_write_same(struct scsi_disk *sd=
kp,
 		struct queue_limits *lim);
 static void  sd_revalidate_disk(struct gendisk *);
 static void sd_unlock_native_capacity(struct gendisk *disk);
-static void sd_shutdown(struct scsi_device *);
 static void scsi_disk_release(struct device *cdev);
=20
 static DEFINE_IDA(sd_index_ida);
@@ -4087,32 +4086,6 @@ static int sd_probe(struct scsi_device *sdp)
 	return error;
 }
=20
-/**
- *	sd_remove - called whenever a scsi disk (previously recognized by
- *	sd_probe) is detached from the system. It is called (potentially
- *	multiple times) during sd module unload.
- *	@sdp: pointer to device object
- *
- *	Note: this function is invoked from the scsi mid-level.
- *	This function potentially frees up a device name (e.g. /dev/sdc)
- *	that could be re-used by a subsequent sd_probe().
- *	This function is not called when the built-in sd driver is "exit-ed".
- **/
-static void sd_remove(struct scsi_device *sdp)
-{
-	struct device *dev =3D &sdp->sdev_gendev;
-	struct scsi_disk *sdkp =3D dev_get_drvdata(dev);
-
-	scsi_autopm_get_device(sdkp->device);
-
-	device_del(&sdkp->disk_dev);
-	del_gendisk(sdkp->disk);
-	if (!sdkp->suspended)
-		sd_shutdown(sdp);
-
-	put_disk(sdkp->disk);
-}
-
 static void scsi_disk_release(struct device *dev)
 {
 	struct scsi_disk *sdkp =3D to_scsi_disk(dev);
@@ -4226,6 +4199,32 @@ static void sd_shutdown(struct scsi_device *sdp)
 	}
 }
=20
+/**
+ *	sd_remove - called whenever a scsi disk (previously recognized by
+ *	sd_probe) is detached from the system. It is called (potentially
+ *	multiple times) during sd module unload.
+ *	@sdp: pointer to device object
+ *
+ *	Note: this function is invoked from the scsi mid-level.
+ *	This function potentially frees up a device name (e.g. /dev/sdc)
+ *	that could be re-used by a subsequent sd_probe().
+ *	This function is not called when the built-in sd driver is "exit-ed".
+ **/
+static void sd_remove(struct scsi_device *sdp)
+{
+	struct device *dev =3D &sdp->sdev_gendev;
+	struct scsi_disk *sdkp =3D dev_get_drvdata(dev);
+
+	scsi_autopm_get_device(sdkp->device);
+
+	device_del(&sdkp->disk_dev);
+	del_gendisk(sdkp->disk);
+	if (!sdkp->suspended)
+		sd_shutdown(sdp);
+
+	put_disk(sdkp->disk);
+}
+
 static inline bool sd_do_start_stop(struct scsi_device *sdev, bool runti=
me)
 {
 	return (sdev->manage_system_start_stop && !runtime) ||
