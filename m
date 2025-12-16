Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05D930BF65
	for <linux-scsi@vger.kernel.org>; Tue, 16 Dec 2025 21:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765919266; cv=none; b=q4iXkX1l+SDmUlyUKlmzdE1hOxdVU63EaXwB7IbsV8dHazw7ZtmsBLvgwjV0hlekRL1l6obVTZWC8eSN5cefdMHo/7WENBeLqyGQ+DxvUdpYnH8EAsZgSOIyPmb2YwfSeYUB84ts6kJAsmX4Lfq1tghEIY83luIeZ9h7L717M5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765919266; c=relaxed/simple;
	bh=RfeMuZy24kOE4i5GP5xojU/AEjLIgIH9mYHfojujF0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eD1uzVo5dyeLBLJj6lb5RImrGfLIYqfE3EiRQLOFkmkseYC3nVJik/Z3uSHzGbmjSkFt4YE/f1P6eaUCyGVYTNnkzJEHP4HAGZuZVwgB6HJot+GUlcfLNuWMrYqFPiM8F5dFv8e39TC4JS1Wj8o4PDhrgJ2FqAdtSIHQjYxuUAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=lUEImSgs; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="lUEImSgs"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dW8dr2JXLzmP4tK;
	Tue, 16 Dec 2025 21:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1765919262; x=1768511263; bh=xlb8X
	hC0A18q86FNAkULtYE4sJQolg1CKKPpXe/8/pA=; b=lUEImSgsRD6IzqjMQjGpj
	ew44let9LMMhshVP92ttRnYLY5TlAfvw6THFiAJQgHfISa4pcAMi3J0DTC9JJXnB
	e/97ZxKY1VzAH6M6ZsP/ubSvkNjEwEiyg6O8nrujfWtOTUIlZBAcp2BpCYtOWF+A
	gyn+NcEUe2cetfl5cGEFcat16crsFmMQUL6eeY1H+6OM5fFrS5k5FkgzcgYD3Odi
	bTWj4bBixA0USUkfR+uvJXgungovDG9S7II7o2gxvcL8iyQzv380ZBn1SM0cSgEb
	QRv5H4gur2xDrzDlC0YiZNgx3bc+PnCWQmemlmGuy/3SWjnHmf8ko86eVLcSzIOC
	Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id CYLHiFwC-vyJ; Tue, 16 Dec 2025 21:07:42 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dW8dn41N2zmP6Yj;
	Tue, 16 Dec 2025 21:07:41 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v4 4/5] scsi: sd: Move the sd_fops definition
Date: Tue, 16 Dec 2025 13:07:16 -0800
Message-ID: <20251216210719.57256-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.305.g3fc767764a-goog
In-Reply-To: <20251216210719.57256-1-bvanassche@acm.org>
References: <20251216210719.57256-1-bvanassche@acm.org>
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
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 58b33e9dad76..f52b435bf398 100644
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
@@ -2174,21 +2173,6 @@ static void scsi_disk_free_disk(struct gendisk *di=
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
@@ -3882,6 +3866,21 @@ static void sd_unlock_native_capacity(struct gendi=
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
