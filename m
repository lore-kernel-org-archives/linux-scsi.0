Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3632A1E8320
	for <linux-scsi@vger.kernel.org>; Fri, 21 Nov 2025 18:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763749303; cv=none; b=DcW2y3QUM+XlGhKFbAQ3l0e15DKUUock8shVPWyiRj+T82PgwE0GYxTJvn4rseDHlL/rGZqC3jWs4T7wZqaGKcBXhPDzC9ksBHRywt4NEVRTqPJZ7Vm2JXEmGdUNBDgvgO5iD2LV4QJhNVHznXXyOwnlns+PTzOg5pz4pP3vajI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763749303; c=relaxed/simple;
	bh=6dbHzTXOfZQ3GVp2CoaIq/iG3BdeHT7Bc21ZRMjjd8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHvf2gTht0JUo3tvucmSIF24a5IT5XbE90AewAcoH42sWHPVbQynmam03skWVnMNLbM+xrNkbdYzgclfdwtDR9wK/3v7LdKcVZkn7K/jei0x931V9ai1S/Tzcm5koBOheF3KlLL5C/ModVyICkAO7Asl2KAeqf7hYxF4/XKwWAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=U3wR6uEh; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="U3wR6uEh"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4dCk7n25v5zlvF89;
	Fri, 21 Nov 2025 18:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1763749299; x=1766341300; bh=BPW52
	l2/DpNH+81eOKbGZILe19aBAlKD66zK/0szKq0=; b=U3wR6uEhCZUO1u5NAcYMQ
	QfkLSnd/oZhzNfQrn8MtpTAa4NE+Dw8I2V8yEdvgmvQ4RcR7xilxXnIlv0BViE1I
	CRaWIC2wj91GHxwt2ja44yGA5371XOq3+QjwB6g9VnXcagYBloJ2hpTHYZkEioHB
	syt4h5LO+upV5DkETZeyNqC/TyeYYI8HPNPhtHh8Ozz3EkibEhThH58Ib30ICjgF
	ZSKR7+1j+hYyaPFznqrSAIo1gzvZI3AnhZrS+YZMNfsI+ODNMXEnzeTIqKTvL54r
	T6czKnD+A5jFMYWlz/kK7L37BhV0WzLlNKSsk/lQFBDBHZcezINosWflHMIn7jwt
	g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id gfWhshEEwXtE; Fri, 21 Nov 2025 18:21:39 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4dCk7h1rGczltNPc;
	Fri, 21 Nov 2025 18:21:35 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 3/5] scsi: sd: Move the scsi_disk_release() function definition
Date: Fri, 21 Nov 2025 10:21:08 -0800
Message-ID: <20251121182112.3485615-4-bvanassche@acm.org>
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
