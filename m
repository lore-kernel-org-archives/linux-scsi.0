Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1C418CC05
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jul 2024 21:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722373292; cv=none; b=kK8znLs95tWrz/7R8JeiQcm/b16eZhJTWCGSPKzJfn++BDFyQmxACPOJ5luStwrhKOUsvMc1AmybMHbrDASvkGY3ZVEoclraxPg/WMqA97qZa7UrZA9q94OJzsQfdhxzgT6oHUFJ3PBT0K14XuSktseg0f0cT663Y8f2/mFglzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722373292; c=relaxed/simple;
	bh=CBmpXk5Nbvh3lnBjV1qYu68yz7NIAEKATg0NZK3kQ2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bvsWgGZq27pWtnpOOpKQpgVzO/+S5lI+mGgCH/4jpiDMBefcpIcmRBAferobHs098/vQyhjYvNwx/0bEz39nAgrDo6S7Tm0GGzwV/RRYR0mjujFjHjpsRPGAuXvd8Gz0jppX6oc/z6uvAYcbgsZWKeXGuEvcApD0lICfniWZre8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=jOOsmKD2; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="jOOsmKD2"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WYSMC377Xz6CmM5x;
	Tue, 30 Jul 2024 21:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1722373283; x=1724965284; bh=LPlXb
	avZQYC1J/63gyuayZvIZuUNSl3EEhiFzPPrAJc=; b=jOOsmKD2pncJFNJYLx4H5
	9H6vyC5nPhR0btAudkVA6tt3GacHeWwKIRoKbwF+ahPfV9eSs3D3Xk1iiqCsAP33
	E9KmrRuCSkDl+lLd2B1JlRMXti+fIc1yZIFCCPWA5cYiggv7oyOIn6eCa3pargI6
	bn2jh2QfP3NhkyxCMAnbMyQM1ddmebd2QGirRet3SR6/Jqb1/nudJQzVdlw3k8BF
	r/93+54WWKXIHrw16iHQI1EuoU49L6qPNgmRAbw654E7Sd08edH92MZ/aqQKWE58
	SHw0V1uA5IVezI13YbyfGZUzAeUX3mlS+FriW1VNbCqYqCQgVtWtkYvuB/p44o/0
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id qgEAHu9FdgP7; Tue, 30 Jul 2024 21:01:23 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WYSM508bDz6CmQwN;
	Tue, 30 Jul 2024 21:01:20 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 4/6] scsi: sd: Move the scsi_disk_release() function definition
Date: Tue, 30 Jul 2024 14:00:39 -0700
Message-ID: <20240730210042.266504-5-bvanassche@acm.org>
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

Move the scsi_disk_release() function definition such that its forward
declaration can be removed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 30c1792df1b3..cefc40de6ee8 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -105,7 +105,6 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_ZBC);
=20
 static int  sd_revalidate_disk(struct gendisk *);
 static void sd_unlock_native_capacity(struct gendisk *disk);
-static void scsi_disk_release(struct device *cdev);
=20
 static DEFINE_IDA(sd_index_ida);
=20
@@ -792,6 +791,17 @@ static struct attribute *sd_disk_attrs[] =3D {
 };
 ATTRIBUTE_GROUPS(sd_disk);
=20
+static void scsi_disk_release(struct device *dev)
+{
+	struct scsi_disk *sdkp =3D to_scsi_disk(dev);
+
+	ida_free(&sd_index_ida, sdkp->index);
+	put_device(&sdkp->device->sdev_gendev);
+	free_opal_dev(sdkp->opal_dev);
+
+	kfree(sdkp);
+}
+
 static struct class sd_disk_class =3D {
 	.name		=3D "scsi_disk",
 	.dev_release	=3D scsi_disk_release,
@@ -4037,17 +4047,6 @@ static int sd_probe(struct device *dev)
 	return error;
 }
=20
-static void scsi_disk_release(struct device *dev)
-{
-	struct scsi_disk *sdkp =3D to_scsi_disk(dev);
-
-	ida_free(&sd_index_ida, sdkp->index);
-	put_device(&sdkp->device->sdev_gendev);
-	free_opal_dev(sdkp->opal_dev);
-
-	kfree(sdkp);
-}
-
 static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 {
 	unsigned char cmd[6] =3D { START_STOP };	/* START_VALID */
