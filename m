Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFB92F4A15
	for <linux-scsi@vger.kernel.org>; Tue, 16 Dec 2025 21:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765919264; cv=none; b=uXIDQWiN0X/kLz5dRpJUL1mIllCoDNIrnMwehcHFaV2/HDvsAj9/oYQBRJothBbt//XHa3wGWyunuEnFV8OLiITpyHQhO/rtb1hNrpDqZvGEGS6T+/QmLl+PJZUdj3Pfb3I7pJwG3euMNv3w9qXmBodClGF04/Cj7TAjwWQvv5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765919264; c=relaxed/simple;
	bh=6dbHzTXOfZQ3GVp2CoaIq/iG3BdeHT7Bc21ZRMjjd8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bfr15NTZqEzJbjVuMYOJUFNbF67hqH9m9fNQkODWLMadqa8kucxP1tkZst5iEObh/fTrZ8zh3aAjTBRabeU+sSfIqPoa/seWjPs+0ITtNnOeiQ3EEdUWMqUURHvo4a86kPey5fj5t/96aDTEgCU+dijK7XhrFp+mA1DTUGYIXXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=vtAyByZm; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="vtAyByZm"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dW8dp422YzmP4tL;
	Tue, 16 Dec 2025 21:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1765919261; x=1768511262; bh=BPW52
	l2/DpNH+81eOKbGZILe19aBAlKD66zK/0szKq0=; b=vtAyByZmcf5hGxEy4vNGc
	iPUarGuf8QYZHS+qRKlNjU3NBdsIEVivw6Z1ZUOUX1v5OqmOVQ8KEIsH9nIM3UX1
	Pz99uBVA45mI0mKAa2TOIRA3Lo+U2+Arp4h8OStTHWSjI2PplEK/UwuA8caj4O6y
	QjVtIINe2ley/2pwSphOXXrG1SrtZyIAyWIK3EIHXM0owra26VUVCKtEYIIs0T7t
	tk0wkIUAV+uHYQ58lz8EZYaa4mwtDuCJFIp6K6AF4Rj8lNWSmMGmb6oYJDQNCkdy
	83r117VSQGi4miok8xZXWAKWkxYccPcEaZAw9bVOBxS/jlCsHF7h8yFpnii1F8ax
	g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id TzWOkdNTg1kf; Tue, 16 Dec 2025 21:07:41 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dW8dl6HvzzmP4vC;
	Tue, 16 Dec 2025 21:07:39 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v4 3/5] scsi: sd: Move the scsi_disk_release() function definition
Date: Tue, 16 Dec 2025 13:07:15 -0800
Message-ID: <20251216210719.57256-4-bvanassche@acm.org>
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

Move the scsi_disk_release() function definition such that its forward
declaration can be removed.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d5cb313d1a91..58b33e9dad76 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -106,7 +106,6 @@ static void sd_config_write_same(struct scsi_disk *sd=
kp,
 		struct queue_limits *lim);
 static void  sd_revalidate_disk(struct gendisk *);
 static void sd_unlock_native_capacity(struct gendisk *disk);
-static void scsi_disk_release(struct device *cdev);
=20
 static DEFINE_IDA(sd_index_ida);
=20
@@ -751,6 +750,17 @@ static struct attribute *sd_disk_attrs[] =3D {
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
@@ -4074,17 +4084,6 @@ static int sd_probe(struct device *dev)
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
