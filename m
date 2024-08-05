Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3F416F0C6
	for <linux-scsi@vger.kernel.org>; Mon,  5 Aug 2024 23:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722901409; cv=none; b=dKfAeEJvg2LdI/S8wUEvlo7MQXVR2dRB0zJtX2VrK9z000xbAwLxSeFSOsOjEAPcIoTTdJaHNd9vuwM7L/zi5MlgBkEHvn4f0OmXjyg5YLHlK80NGfJGRWZBcc3Y+9onPSWnvcHa4lh/Mj1SdmFNxQbhBGLibri+sWBtW3NI6L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722901409; c=relaxed/simple;
	bh=B3XNjMhJncUCh+F/iAezQzI7BU/tDUP/j+23cu9YpzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EBj5xFSjYvX5kJCtwkD/eYp7IDyd+bh2fr3r0UzGF7v2X6LQmBr6U0utvhexjskbwXKNoTlP5PvPnrC1krfMuOky/HQDSQkLZTVQJCMjSC26THrxTUU9+/W3yI/oLdf56nT25kksBe8QdAHhb7qCvDVylhsAyT2xDaHHI+OxOoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Q/xOqrAx; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Q/xOqrAx"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WdCgM4BHHz6ClY9F;
	Mon,  5 Aug 2024 23:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1722901404; x=1725493405; bh=hDyCL
	32RWlbCwJpWdKdkJeAXlbLmdGhXtJqWA+HKuWs=; b=Q/xOqrAx/Mhz/SfUILSpY
	P5y18clvkAy+kqtmVjOUxSEsp6IyRlX+YY30lxVbbiPCX7ehQthOzPJwaBdnbEL2
	BPHzzGViRltXKu50TM4/qcWhYIF6E1A+u3kED4gdwVCTHAKe5o3/VHwXqGAn9/4n
	/HxwT19fOro0RmpQS6zTeuQlWRUeggGJtp8kofd7JM5/HQPJQ2V1nCWi77S5NxLC
	yRgrTXir7BBk5brWjLNghDUo8bPZTK2A0ZqlG4hGAYE3dRfNYr4WH1eaqVzp2/pU
	0kGvS1wqUbZfx04PQnLcf/KdgJKev1lNE0wvA6HdKCHT3u/7qOMDDuH13375mU4u
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id RhegGD3-5d3W; Mon,  5 Aug 2024 23:43:24 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WdCgG5d5Rz6CmLxj;
	Mon,  5 Aug 2024 23:43:22 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 5/6] scsi: sd: Move the sd_fops definition
Date: Mon,  5 Aug 2024 16:42:48 -0700
Message-ID: <20240805234250.271828-6-bvanassche@acm.org>
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

Move the sd_fops definition such that the sd_unlock_native_capacity()
forward declaration can be removed.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0ee4c54401ec..afd53ef2afcb 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -104,7 +104,6 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_ZBC);
 #define SD_MINORS	16
=20
 static int  sd_revalidate_disk(struct gendisk *);
-static void sd_unlock_native_capacity(struct gendisk *disk);
=20
 static DEFINE_IDA(sd_index_ida);
=20
@@ -2140,21 +2139,6 @@ static void scsi_disk_free_disk(struct gendisk *di=
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
@@ -3845,6 +3829,21 @@ static void sd_unlock_native_capacity(struct gendi=
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
