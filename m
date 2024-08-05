Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8185E273FD
	for <linux-scsi@vger.kernel.org>; Mon,  5 Aug 2024 23:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722901402; cv=none; b=CNNA8vDolkYcTVrI+gXoRkwQz26haCraJvcIM2E0lO/PgnzjXeLFZVUJy45r7ZPm3pRHPBfHUIqJAFIlRocInPOkcs8+xTl1pyULaoU0++WvteQ5GSqG19X/XW2HDn5hICe5EClX7bOkBBD9ztHml1mnm+FmQxwj1pugcsjJSi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722901402; c=relaxed/simple;
	bh=e5fkY0n3fW1lqgdeO2n+Ho88k6KSEVpKmggXJAp4R6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djA4wLcagDVEAD8EAOBRvONugw4xBtYEW0b8NmlAfh54UpvdaJQJsSQ6t0nMHd93EdDCh7R/MD5KGm5BgxiiEcdvZLsJsxOf6tUS25eGEZOmAC8RqeAHdh+Em4FwDTL/Dq4aVGmKroYF6m3KNFkxd2hWuPnT+7Ja7drVZgdp++M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=sivXqJ0D; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="sivXqJ0D"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WdCgD0BYZz6ClY9H;
	Mon,  5 Aug 2024 23:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1722901396; x=1725493397; bh=QcdTI
	NhVsKwz1ArBmBkszqPppUXUT84ZQluMtjS8RMs=; b=sivXqJ0DvHAP/JnoMahUG
	xGaZ4GZkDOaLZm35OaVmdBOFcZA8pW59+le5vFJvgLIZzcNFNnlcBxHRFtrs/eUw
	L0sz9XeCEAciYrZjmHwKrocsfz4lvo0ccZfdKlz8nnoa7SyFN27JCXayFXTW+uML
	c+CIklsnZgFJCViehmWPnQHDaNl8G0SUID8DzvGAR3jo9UluyCE8ZKnzguoZlkxS
	9gBsfCpXcbkWhp2KYtAjVuaZfgk/sppelE8KXSXkrbIrAIYKOYHJ1yY6rKJqLygB
	XvSWXOGn1tLDRC6XyhJ3xqPIiRd/D3ZyOgGisPyEMQ0ucgzDhu4LKTkf+l1KdKnU
	Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id P4v39udq5Rab; Mon,  5 Aug 2024 23:43:16 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WdCg659Skz6ClY9C;
	Mon,  5 Aug 2024 23:43:14 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 1/6] scsi: sd: Move the sd_remove() function definition
Date: Mon,  5 Aug 2024 16:42:44 -0700
Message-ID: <20240805234250.271828-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
In-Reply-To: <20240805234250.271828-1-bvanassche@acm.org>
References: <20240805234250.271828-1-bvanassche@acm.org>
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
index 8bb3a3611851..50be1f01f1c2 100644
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
