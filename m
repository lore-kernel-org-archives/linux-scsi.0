Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D408B1C8FBA
	for <linux-scsi@vger.kernel.org>; Fri, 21 Nov 2025 18:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763749308; cv=none; b=oT5U6OpkQ8GYR7Jctx3zGZEhyEupN/vmVXU3/Sd87JR5eJNhPn0+jauxT2O4JS9ITkUoraUJ8WYzwl8r9TYyxwqZzx7/ZqJGmgyzb6zVr4workcNRVEo9dF0tcIPXKPm0Ba5yrwo8ZzPZClpd4OVEpHo3XDF1EfAaMUZQidZ+0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763749308; c=relaxed/simple;
	bh=RfeMuZy24kOE4i5GP5xojU/AEjLIgIH9mYHfojujF0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZtliykkIzum131yFm0kY0yvoAXyRjBqXE4CNCr1uSE8Kn9tIsoCbo1j/1zYQnamCVAae4QNaFXdvS5Sg3l4qQ61GvDXjVFX6Fv5KTSeK+Ju+an2BX88Vfjz7UviPEpThJSt6WfKPeIXSE0S7CAs+sB+xe6jw5oMSc74EXhp8yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=u1b0bhoS; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="u1b0bhoS"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4dCk7s5pRRzlvF8H;
	Fri, 21 Nov 2025 18:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1763749304; x=1766341305; bh=xlb8X
	hC0A18q86FNAkULtYE4sJQolg1CKKPpXe/8/pA=; b=u1b0bhoSUj5FTdCEsIY+Q
	POxgjpWWYrsKDPEgfz/BfPUrv5nzLRmTSQFnLiMeE7k8OVePYAH6tMdU+kiNDbXU
	trz6kuucwyRMKWq9FS5JdQobP5H9it3HgsQDO8lw4lkYWFtOOrTfimIc70fdwOcB
	xUs9VY1qIyZW+IEDKig4h7b5ZUKcKPbEBeItJh6+gytRZKiwgWbr9yKHeJLmMN2o
	BcB6s5+MwPwXYPGA7fsvfhdPJpWNh/2zrhT+jlvoR7PwNm82TUp+SkmQeR7bF6/A
	96g3PJ+yuDkujhN6XLgbQoMP+NWtrClUsPklBNpewLz4X6SWRVSq0ha2XO8FDwv2
	w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ZhuCSaI7_t3e; Fri, 21 Nov 2025 18:21:44 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4dCk7m69rKzlvF8M;
	Fri, 21 Nov 2025 18:21:40 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 4/5] scsi: sd: Move the sd_fops definition
Date: Fri, 21 Nov 2025 10:21:09 -0800
Message-ID: <20251121182112.3485615-5-bvanassche@acm.org>
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
