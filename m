Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0C814B94C
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jul 2024 21:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722373292; cv=none; b=pyAiWIi99Daen5KWasQK4KD8ABgVLRXQOyVb6LgpVM4B4mebhCpnb0+/H2CXACclJ3kUS0wNFweH1rR9/dyqHGzdNzH8rvjuo65m+dt9p32wO930LL53WPOshdzEgalflyisY1R76PmUw40OElO57BbiAGRXNEXXjTtiSwD7ttc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722373292; c=relaxed/simple;
	bh=MSCDvzmhGpUUKowAsg7B5/si3ikKThoVck0E3qk2ZJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XIVcESOhR1gmwOx8lq5DPUzjtxPfBY4+Ks2Y5Y7xlNCbw51J4QeJaDXJyPrI13/0jLOTlECi8fEzFqGxy75rillRCAMM4g1Y9Klb1WOaq+DKfEjXPvyPpLlDvmGsoznxZwXBvYe8ApocIKAPCUzubvIZiDtxtimJD6cGxEA7OsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=CSCp5KQ4; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="CSCp5KQ4"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WYSM76599z6CmM6f;
	Tue, 30 Jul 2024 21:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1722373279; x=1724965280; bh=MoB+v
	WcGV34z9qL1SBrnAObpzsa3T5PWZ7ibSXidmCU=; b=CSCp5KQ4TMX27BM2GKhKu
	0LV0CqX9+4KWGA/5yhoM97NVpCg5lkvT4+p0lbvbT37+W1XtJzwvkzjlyly7P1pE
	XV7oRCMKEwGrmzpqPPaCUk40EIKMqOSSbUVa5mNZqeBe4bdOoV06UZD7MGrC7ZYb
	Jwi5lEM1IYvOosudS40bdQ4CO4KEInI74qDYqRbF1kR6OBIUl/UXG3sKtmJjp6ml
	nBQY2yNslLXMjyeicVPf0PtzzuH5pPS3lJzZlDe6qeeC/quSdoXwQncMs0wNwo49
	j0C9E3IGDgdm1dDtIjGKdMWIyf+gtQxxUsNI/fgWlZdHINlk+7Np1+YIhENzGTOF
	w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id GVdkJFIoOW9h; Tue, 30 Jul 2024 21:01:19 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WYSM23Wh5z6CmQvG;
	Tue, 30 Jul 2024 21:01:18 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 1/6] scsi: sd: Move the sd_remove() function definition
Date: Tue, 30 Jul 2024 14:00:36 -0700
Message-ID: <20240730210042.266504-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
In-Reply-To: <20240730210042.266504-1-bvanassche@acm.org>
References: <20240730210042.266504-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Move the sd_remove() function definition such that the sd_shutdown()
forward declaration can be removed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 53 +++++++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index adeaa8ab9951..58ea8c06205b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -109,7 +109,6 @@ static void sd_config_write_same(struct scsi_disk *sd=
kp,
 		struct queue_limits *lim);
 static int  sd_revalidate_disk(struct gendisk *);
 static void sd_unlock_native_capacity(struct gendisk *disk);
-static void sd_shutdown(struct device *);
 static void scsi_disk_release(struct device *cdev);
=20
 static DEFINE_IDA(sd_index_ida);
@@ -4042,32 +4041,6 @@ static int sd_probe(struct device *dev)
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
@@ -4147,6 +4120,32 @@ static void sd_shutdown(struct device *dev)
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
