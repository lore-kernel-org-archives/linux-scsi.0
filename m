Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FF927FD68;
	Mon, 17 Nov 2025 22:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763419974; cv=none; b=UpFT89Epr9XKqViHwEdmQ+BHutBB2pinBslfNhcK1F06pujdPzq5GAGaJMMcDAjPbltd0mdOcwPnYYNqaC5BmNkvGZF7Rpbi4RwzSAt2I5PJaH8yGjq8o260RZALdRyWDo0iLuh6n/ERqXdfSY8FU7aCwH7u430axPyfZQvOWaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763419974; c=relaxed/simple;
	bh=DLWK5qzzP3YeRmdlz/dhfX4UaVV15SGMInFtix7uBRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RddClX4wRWESyI+VWpVSGpIW6zlkEOle4cH6IT/qbcR3NiG+GzcO6VxiVmC6jQOtTmBl+PVk2WWjEeqfyasBu2zp0d7MpaZZdYWDZQDrHtCw9iNcd7Km71CwrnFGeVEvBeTSl8ovQpqbKYiltVozOF9V7e3mJUGI5Dl3STXLRuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=HaABAEYS; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="HaABAEYS"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4d9NLW4DyczltP0Q;
	Mon, 17 Nov 2025 22:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1763419969; x=1766011970; bh=jqf+Z
	8Xo8QRSlcE0GiwY3IMilfEbBq3SJGxP3IH7IEc=; b=HaABAEYSbTU1gKqirbWmG
	x72eZf9VAL5o08F/iq1AHT6dpAoLAIUnhCZaRc/vstaFy2s4bOm5Hn8bOoBoTcre
	A6WHvvnbaz7DNaBTYt/9RJmhlQ+PFgM/efPhADHCNzL0+sW4RQNqYtnRIitKMCS4
	YkVXuAinAk/I4EAFmUgV7fsSQ4Fjt0SC+kAAMg0KkUvsy1ebcZNAX80BKlo0ohyj
	MNN8Q3Et8g2e/MwJFUAn8Y6DI3LHXiFGlU5kyYKhLyO8953gbAmtQ0dW+c+Jlwls
	Ck7c1ATnNFuiDK6Q+pMO8N63G/Bb6H2k+nAESnM/Bzvsh0nC3laJm0JwPaD39Jpm
	Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id exZDmNwaSPFG; Mon, 17 Nov 2025 22:52:49 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4d9NLM3WV9zltP0N;
	Mon, 17 Nov 2025 22:52:42 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>,
	Ming Lei <ming.lei@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 4/5] scsi: core: Generalize scsi_device_busy()
Date: Mon, 17 Nov 2025 14:52:03 -0800
Message-ID: <20251117225205.2024479-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251117225205.2024479-1-bvanassche@acm.org>
References: <20251117225205.2024479-1-bvanassche@acm.org>
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
index 51ad2ad07e43..ddc51472b5eb 100644
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
index d62265d12cfe..661f0a8e4de6 100644
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
 #define scsi_get_ua_new_media_ctr(sdev) \
