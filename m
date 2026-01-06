Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31CF633D6E3
	for <linux-scsi@vger.kernel.org>; Tue,  6 Jan 2026 19:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767726494; cv=none; b=NwTjdvqBvN2jYN1VQc5Am0cOWHTlIwF7FC4pwDAgtXMXMT0+qX/mo55va4tFJEX41McK4LgWn7thgLE2zYx93B2lwt0MD0EdCJONDfATFeDQj05cq+TYjWamNY4m7sP1v26UfxjS6K6vDZgFxALl1XCW5Ja6qhWaYJD1CQe4UDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767726494; c=relaxed/simple;
	bh=P4X275lo6YLlxxH9DdxSAnUkMl7beHBQCXytTwJI0Vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6XWrdLLCPb+qFjlYTCIbjL5G+m50B5iTdYfPjiyCUd6h8aXXpRHZzldiDa5ze2Uj/CsBQPFVKRoE2QM6WXcEtBRld9jn9FB+/ggSKyM8PDdwkk8oS/mxu58ImK1f3DjLawb2G926pHCe8xXX8eUSL8nJxhUuSEv70pYNlYU5Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Rq3jNJB4; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Rq3jNJB4"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dm10C4YPPz1XScCW;
	Tue,  6 Jan 2026 19:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1767726490; x=1770318491; bh=Jl9WF
	YywYrnQTZBfoDgR0tzrEjYPO+RNSwkLkPXbL94=; b=Rq3jNJB491Yol0LiMDuYE
	idTrOsQGglg64M25+0Q/z05bjVMy7aGu+DX2hFhFtmoPA70SeNdO7YvnDW8lzb+9
	hGk8+Zx9WxWl996Of/diGJuI/TNxkzlKNHdLMrWdiuG1CAzPXIjtcCsVpPg41WNR
	G/KtpxIBEpdP4TLTND7EJv1wb4fN0GDbjRaBdH22TjfY2FjsL5yw9gfwKNsWL4Mt
	zapeLuSIL2LqTqNnLYRZWp60SwpjiGxNCjywIrOIl4Hruge7qBWfYYuD5+nV9Uyk
	NREHkphO6CsqndRsDp5o3SZwys5usDWPRiR2cmsl1w28KHcqRSpymw5JIWGd9l+7
	w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id nEM_kHWSoGfF; Tue,  6 Jan 2026 19:08:10 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dm1084fkdz1XPpVK;
	Tue,  6 Jan 2026 19:08:08 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v5 4/5] scsi: sd: Move the sd_fops definition
Date: Tue,  6 Jan 2026 12:07:47 -0700
Message-ID: <20260106190749.2549070-5-bvanassche@acm.org>
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
index 3cd9d552de9e..95e1e6d5d5e2 100644
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
