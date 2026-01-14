Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C6D32C326
	for <linux-scsi@vger.kernel.org>; Wed, 14 Jan 2026 17:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768413078; cv=none; b=n4ZPHp3456h9ZsYRHGSuDEjMH/ZxVPUTsg7VJNfTTbbdHHacv/VDUmPgePR/keqW1mv4/RpFeOVjem1X68y+UhanbabT9pu8kd3XvbNEQwetwoH6gTkKaN7xxBfpHvL834oX+ke1XngI1TaaKFMbBneu65OOx/KnVpfVxEKTfEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768413078; c=relaxed/simple;
	bh=VdjaWbUIp2vHUGo+QfBTSPevFMt1CxivqPgZWlbyNZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q7dl3k/7GQZW1VbZpZy6h7fvdNhIu8k+QIIkBZnRl/ecKBNMJA/HDMi1rGm6T87a7QAqLqb4TKjK2cBkrP+Juz46ulQrcp+1/RkMIS7wHF6LY9FVeyRytnzHzKfZqMmV9KtiDb59s6BiMHzNDFQTf3HyQnleHWxf9pam7d1Z7cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pefvtcWY; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pefvtcWY"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4drtvm099BzllCX0;
	Wed, 14 Jan 2026 17:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1768413074; x=1771005075; bh=vcZKG
	6mq2+PxNPYnhOsq20oHUNcUNa8L4m+zqDICYNI=; b=pefvtcWYEOjyVQo6cLhxZ
	vIHgvzXUOxstjVy/sq8TRQh/FZh5xSLO5gi1oC3WNQkrzjtx8nNACOhJBrP11Z9l
	KybCN4Ga21KRAMmVeK+fnyZMS7wI9pfXEaNkh89vn3dW8IsPn8ffahkaM2onqBa6
	adGNyzsQx7dBJDMvuQ0Q3NtCJzWPmvch1qOAnHJGEE4aMUVr8RN3ijw0KqW6OJBE
	cscQGSfwGOBpKh5sf28JZUiJuTtHVPjs/mqNPt25r5TZcijAJwLZ8oHsyNetdEpD
	Bi4DC4zMjA6Vct1Yd0JUlj8v5ZSxWgMTPJ76xjjgv4cVJ5gG7H/uJkXvaSv46yLJ
	Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id cMfOF8cWdWUe; Wed, 14 Jan 2026 17:51:14 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4drtvh6WyhzllCWw;
	Wed, 14 Jan 2026 17:51:12 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v6 4/5] scsi: sd: Move the sd_fops definition
Date: Wed, 14 Jan 2026 09:50:52 -0800
Message-ID: <20260114175054.4118163-5-bvanassche@acm.org>
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

Move the sd_fops definition such that the sd_unlock_native_capacity()
forward declaration can be removed.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0d07f3734257..1dae8a02c446 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -105,7 +105,6 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_ZBC);
 static void sd_config_write_same(struct scsi_disk *sdkp,
 		struct queue_limits *lim);
 static void  sd_revalidate_disk(struct gendisk *);
-static void sd_unlock_native_capacity(struct gendisk *disk);
=20
 static DEFINE_IDA(sd_index_ida);
=20
@@ -2184,21 +2183,6 @@ static void scsi_disk_free_disk(struct gendisk *di=
sk)
 	put_device(&sdkp->disk_dev);
 }
=20
-static const struct block_device_operations sd_fops =3D {
-	.owner			=3D THIS_MODULE,
-	.open			=3D sd_open,
-	.release		=3D sd_release,
-	.ioctl			=3D sd_ioctl,
-	.getgeo			=3D sd_getgeo,
-	.compat_ioctl		=3D blkdev_compat_ptr_ioctl,
-	.check_events		=3D sd_check_events,
-	.unlock_native_capacity	=3D sd_unlock_native_capacity,
-	.report_zones		=3D sd_zbc_report_zones,
-	.get_unique_id		=3D sd_get_unique_id,
-	.free_disk		=3D scsi_disk_free_disk,
-	.pr_ops			=3D &sd_pr_ops,
-};
-
 /**
  *	sd_eh_reset - reset error handling callback
  *	@scmd:		sd-issued command that has failed
@@ -3892,6 +3876,21 @@ static void sd_unlock_native_capacity(struct gendi=
sk *disk)
 		sdev->host->hostt->unlock_native_capacity(sdev);
 }
=20
+static const struct block_device_operations sd_fops =3D {
+	.owner			=3D THIS_MODULE,
+	.open			=3D sd_open,
+	.release		=3D sd_release,
+	.ioctl			=3D sd_ioctl,
+	.getgeo			=3D sd_getgeo,
+	.compat_ioctl		=3D blkdev_compat_ptr_ioctl,
+	.check_events		=3D sd_check_events,
+	.unlock_native_capacity	=3D sd_unlock_native_capacity,
+	.report_zones		=3D sd_zbc_report_zones,
+	.get_unique_id		=3D sd_get_unique_id,
+	.free_disk		=3D scsi_disk_free_disk,
+	.pr_ops			=3D &sd_pr_ops,
+};
+
 /**
  *	sd_format_disk_name - format disk name
  *	@prefix: name prefix - ie. "sd" for SCSI disks
