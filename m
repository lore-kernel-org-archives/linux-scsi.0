Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F56273FD
	for <linux-scsi@vger.kernel.org>; Mon,  5 Aug 2024 23:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722901407; cv=none; b=clgbXeVMLwRBquoLTczZQxLTqAP1syHSRSJOLv9ttLOOf9aqJZ4m9oQdvOQE3mambupkfyJQUKm1dy9PfyIQ9GsUcCaZgtIwaAwSyQ9FYFOpABIjQeeoqFuz2E9e35uOZEvadoiHa4qBwGMmw31//DaDifDTO5EI0Q/CwWnRJYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722901407; c=relaxed/simple;
	bh=lxl+D0WES0sW06H+yFy5cB2GNGcCdsrBrQ8FiKdqCH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0c50tHosogoL1xis6QbIM3YAq+afqXOzPS2ZIgihdfQ4A+DwJhW3lit7fta31WnKPE5gbdNHHxxfP+kyU6v0/GD6dtFBHsos/sW9UGOnrctgeUkSWldun/4h9UymlmugyRN7QvCfKz3euCu7WLVcLQjWvEvDDE3faEQQo/7bZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=nbbgqGEU; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="nbbgqGEU"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WdCgJ75kKz6ClY9H;
	Mon,  5 Aug 2024 23:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1722901402; x=1725493403; bh=JzaFZ
	MKiOgbqdySnqAydHknCkQTB/lBxo+CdbudEK7g=; b=nbbgqGEUXDqIFoKU52DH/
	qsJc4VN61xDQw+cMHCs97rns0YaZ9AfFJmKhN5Hnxjdac25J+TRb0s6kUUq7coWP
	hdktfSEoZ98MOX/jx/E5vbgwGmf4a3ENeEvsQu+pXzuFl6v8dZAz6l1+cEKwcKCq
	tpsNdihUCPX3TiNi5box/3TtcGkAVM6AVj+K3rrBjg7OuHoH2OH+R84Jg2/LUBls
	Q6AFSAoHdbNIAlTQk3FZ8oWMfx8OsHKt0faN1bkrPdWgVjjJV0HNhxGMr0AJcwcf
	WqiRf0TWuh/p8uli7Qlx+WBG4VhrtrvPqQvl8YxNAy8RD/MJQR7EyxExmdvlSrCI
	w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ydiJmoDE_aAp; Mon,  5 Aug 2024 23:43:22 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WdCgD5Z7Bz6ClY9C;
	Mon,  5 Aug 2024 23:43:20 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 4/6] scsi: sd: Move the scsi_disk_release() function definition
Date: Mon,  5 Aug 2024 16:42:47 -0700
Message-ID: <20240805234250.271828-5-bvanassche@acm.org>
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

Move the scsi_disk_release() function definition such that its forward
declaration can be removed.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b9a9b24ff027..0ee4c54401ec 100644
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
