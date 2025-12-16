Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF728327BE3;
	Tue, 16 Dec 2025 22:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765924283; cv=none; b=RJPBjp7uaLZPqEY3aPDJOb8UIwaIWWP8cYO0X1UkXRHywlRuD674jy8wj97xRRZXxDvcoH0np9nrCzjVXPeGss7Tp4369y2p9So36ei40w9H63kHy5sF7t+HGGIetOOcHw+FvkEcXg7vuQCPQ+sV7523t2oowpFwdowivK32xL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765924283; c=relaxed/simple;
	bh=b4Rh6Zv5Np0dPDW0F4WZlu7DfaPEj9stZiVvpa6JJ7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BDVcKFVQCKrlZZ0/yNGZybNDZR1zqZiHeh2rJxRmmEkMWfwPj/8MvFYw5EJriRlmZNo9kHlZZfJUVZdMZIIIGECA0Ry7mmG1Boqc2AqZ5uX0oojsrSCLUsZbyGm7esA5CqH6/osQfM8I/IaAPHRcVEjD/vscEJe/hpI6IY6h/R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1+PNC1gW; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1+PNC1gW"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dWBVK2nMSzmLCvh;
	Tue, 16 Dec 2025 22:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1765924278; x=1768516279; bh=X+slc
	2BDbsARqiDD3d9v3T57s6qgWixAFZITZ6xnUzY=; b=1+PNC1gWvOvRZZt8ygv9b
	xRa6j1m9erH6LKfbOarWJY5pVqWPQm4o/pfs9JPF7XkTXq9uPhxCcvGgKWxUxB5b
	+G1sZxQ7rJP4Fg+JIMMU58ed8LWFwhKl8bn4FfruTKoG9FkHNx6FFtRTKs9caL5f
	Twk7CtrPidPEaDjZTL2+Si7Qs3qFgNN0NQ97TFV0tloX3Jqgrqccgga8BnWsSILY
	faGkV8341BMH9m1W6ArIDokIIW8Nrt1w8OmcW08tvJ00PWPwb2eNrhfTW1BFyIeD
	nLFMSnHZrip97uwA6zsYoF+uFP5qfs70q+3AmoAMPB+DjjLApnNLf38jvbgPO0K3
	Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id igiUyw-tsSSD; Tue, 16 Dec 2025 22:31:18 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dWBVD48LdzmP6YY;
	Tue, 16 Dec 2025 22:31:16 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Ming Lei <ming.lei@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v4 5/6] scsi: core: Generalize scsi_device_busy()
Date: Tue, 16 Dec 2025 14:30:49 -0800
Message-ID: <20251216223052.350366-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.305.g3fc767764a-goog
In-Reply-To: <20251216223052.350366-1-bvanassche@acm.org>
References: <20251216223052.350366-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Instead of only handling dev->budget_map.map !=3D NULL, also handle
dev->budget_map.map =3D=3D NULL. This patch prepares for supporting logic=
al
units without budget map (sdev->budget_map.map =3D=3D NULL).

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c    | 38 ++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h |  5 +----
 2 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 93031326ac3e..2f9ebf526d89 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -446,6 +446,44 @@ static void scsi_single_lun_run(struct scsi_device *=
current_sdev)
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
=20
+struct sdev_cmds_allocated_data {
+	const struct scsi_device *sdev;
+	int count;
+};
+
+static bool scsi_device_check_allocated(struct request *rq, void *data)
+{
+	struct scsi_cmnd *cmd =3D blk_mq_rq_to_pdu(rq);
+	struct sdev_cmds_allocated_data *sifd =3D data;
+
+	if (cmd->device =3D=3D sifd->sdev)
+		sifd->count++;
+
+	return true;
+}
+
+/**
+ * scsi_device_busy() - Number of commands allocated for a SCSI device
+ * @sdev: SCSI device.
+ *
+ * Note: There is a subtle difference between this function and
+ * scsi_host_busy(). scsi_host_busy() counts the number of commands that=
 have
+ * been started. This function counts the number of commands that have b=
een
+ * allocated. At least the UFS driver depends on this function counting =
commands
+ * that have already been allocated but that have not yet been started.
+ */
+int scsi_device_busy(const struct scsi_device *sdev)
+{
+	struct sdev_cmds_allocated_data sifd =3D { .sdev =3D sdev };
+	struct blk_mq_tag_set *set =3D &sdev->host->tag_set;
+
+	if (sdev->budget_map.map)
+		return sbitmap_weight(&sdev->budget_map);
+	blk_mq_tagset_iter(set, scsi_device_check_allocated, &sifd);
+	return sifd.count;
+}
+EXPORT_SYMBOL(scsi_device_busy);
+
 static inline bool scsi_device_is_busy(struct scsi_device *sdev)
 {
 	if (scsi_device_busy(sdev) >=3D sdev->queue_depth)
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index d32f5841f4f8..0dd078ac9b89 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -713,10 +713,7 @@ static inline int scsi_device_supports_vpd(struct sc=
si_device *sdev)
 	return 0;
 }
=20
-static inline int scsi_device_busy(struct scsi_device *sdev)
-{
-	return sbitmap_weight(&sdev->budget_map);
-}
+int scsi_device_busy(const struct scsi_device *sdev);
=20
 /* Macros to access the UNIT ATTENTION counters */
 #define scsi_get_ua_new_media_ctr(sdev)	atomic_read(&sdev->ua_new_media_=
ctr)
