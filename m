Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896BE26C3AA;
	Wed, 10 Sep 2025 21:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757540020; cv=none; b=YQzXV24i5hWuKc+Dn5i+jjcKisXi+uDHhI8TUAVhl9yZZPpHi54xFerOyJAGio0O5dZYvPBFHzFpsdAU3B3PwoFrHkXTs2Hmg4Bqc8Va8DR10Eer5BDm//7QgbUnfzV/tR005XT7OEm/K2vAy1j8hjtCnLkB1rZtlGfcDMD5L6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757540020; c=relaxed/simple;
	bh=+4KkeoLUhSW+vmcgkRDCcgxPHp8czWxlSNwo7z6YbAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hIRKb5lF9IawRs09vPM2vIeRWFQVfHuqQgIBE5X6+4uUx8JPMMjAbTggHRA6BQFZnJQFnOZaoqrhUKMsTOF+v0dK3eBRwuKXtXfAy5R5TZCJVhXRKa58gpFmA92HWshSjZT5cNcNDtbYImVbh+hWF/YCrFpGjYFV51C+u48yBAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=RKN8aziM; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="RKN8aziM"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cMYpT3jSqzm174M;
	Wed, 10 Sep 2025 21:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1757540015; x=1760132016; bh=n20R4
	QpM5HQ1dSvP9ErHvlAAwjbuGyZRUqxhkxMxUh8=; b=RKN8aziMwl6IX3zmP3mb6
	ige7a6YuAgtVBaUM6B9FTOS/v6AClxy9NyyPFoFgYCYqmltKP7s70WV9OqZIvosr
	GoR5nWgE//TZdgJCn1u3vtMvZBIqADj5/L4xmbjVibERAkE1UZeBjQIfx9g3uoRh
	wv+HQ3vHrcPBuJ0dLjl1zunU9ZtPzHrs/kkV3kRe9UvzBGnZdwLebzYlVQPtzX3O
	HO8igbBkor3XDntS3R/x9mEjqr2OBu20ebFxFP8Kj8xUP/pIZpaNBC7AkmFw8JNC
	7Dsot6t9Rr/YDoIeyy9QBu1cFUqW7aSz8JN3lscJcUUJ5Tn2ygqhATgAJYGWLjIZ
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id o9mi001ieW1D; Wed, 10 Sep 2025 21:33:35 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cMYpK2Ylszm0ySN;
	Wed, 10 Sep 2025 21:33:28 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>,
	Ming Lei <ming.lei@redhat.com>,
	John Garry <john.g.garry@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 3/3] scsi: core: Improve IOPS in case of host-wide tags
Date: Wed, 10 Sep 2025 14:32:51 -0700
Message-ID: <20250910213254.1215318-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
In-Reply-To: <20250910213254.1215318-1-bvanassche@acm.org>
References: <20250910213254.1215318-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The SCSI core uses the budget map to enforce the cmd_per_lun limit.
That limit cannot be exceeded if host->cmd_per_lun >=3D host->can_queue
and if the host tag set is shared across all hardware queues.
Since scsi_mq_get_budget() shows up in all CPU profiles for fast SCSI
devices, do not allocate a budget map if cmd_per_lun >=3D can_queue and
if the host tag set is shared across all hardware queues.

On my UFS 4 test setup this patch improves IOPS by 1% and reduces the
time spent in scsi_mq_get_budget() from 0.22% to 0.01%.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: John Garry <john.g.garry@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi.c        |  7 ++++-
 drivers/scsi/scsi_lib.c    | 60 +++++++++++++++++++++++++++++++++-----
 drivers/scsi/scsi_scan.c   | 11 ++++++-
 include/scsi/scsi_device.h |  5 +---
 4 files changed, 70 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 9a0f467264b3..06066b694d8a 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -216,6 +216,8 @@ int scsi_device_max_queue_depth(struct scsi_device *s=
dev)
  */
 int scsi_change_queue_depth(struct scsi_device *sdev, int depth)
 {
+	struct Scsi_Host *shost =3D sdev->host;
+
 	depth =3D min_t(int, depth, scsi_device_max_queue_depth(sdev));
=20
 	if (depth > 0) {
@@ -226,7 +228,10 @@ int scsi_change_queue_depth(struct scsi_device *sdev=
, int depth)
 	if (sdev->request_queue)
 		blk_set_queue_depth(sdev->request_queue, depth);
=20
-	sbitmap_resize(&sdev->budget_map, sdev->queue_depth);
+	if (shost->host_tagset && depth >=3D shost->can_queue)
+		sbitmap_free(&sdev->budget_map);
+	else
+		sbitmap_resize(&sdev->budget_map, sdev->queue_depth);
=20
 	return sdev->queue_depth;
 }
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0c65ecfedfbd..c546514d1049 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -396,7 +396,8 @@ void scsi_device_unbusy(struct scsi_device *sdev, str=
uct scsi_cmnd *cmd)
 	if (starget->can_queue > 0)
 		atomic_dec(&starget->target_busy);
=20
-	sbitmap_put(&sdev->budget_map, cmd->budget_token);
+	if (sdev->budget_map.map)
+		sbitmap_put(&sdev->budget_map, cmd->budget_token);
 	cmd->budget_token =3D -1;
 }
=20
@@ -445,6 +446,47 @@ static void scsi_single_lun_run(struct scsi_device *=
current_sdev)
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
=20
+struct sdev_in_flight_data {
+	const struct scsi_device *sdev;
+	int count;
+};
+
+static bool scsi_device_check_in_flight(struct request *rq, void *data)
+{
+	struct scsi_cmnd *cmd =3D blk_mq_rq_to_pdu(rq);
+	struct sdev_in_flight_data *sifd =3D data;
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
+	struct sdev_in_flight_data sifd =3D { .sdev =3D sdev };
+	struct blk_mq_tag_set *set =3D &sdev->host->tag_set;
+
+	if (sdev->budget_map.map)
+		return sbitmap_weight(&sdev->budget_map);
+	if (WARN_ON_ONCE(!set->shared_tags))
+		return 0;
+	blk_mq_all_tag_iter(set->shared_tags, scsi_device_check_in_flight,
+			    &sifd);
+	return sifd.count;
+}
+EXPORT_SYMBOL(scsi_device_busy);
+
 static inline bool scsi_device_is_busy(struct scsi_device *sdev)
 {
 	if (scsi_device_busy(sdev) >=3D sdev->queue_depth)
@@ -1358,11 +1400,13 @@ scsi_device_state_check(struct scsi_device *sdev,=
 struct request *req)
 static inline int scsi_dev_queue_ready(struct request_queue *q,
 				  struct scsi_device *sdev)
 {
-	int token;
+	int token =3D INT_MAX;
=20
-	token =3D sbitmap_get(&sdev->budget_map);
-	if (token < 0)
-		return -1;
+	if (sdev->budget_map.map) {
+		token =3D sbitmap_get(&sdev->budget_map);
+		if (token < 0)
+			return -1;
+	}
=20
 	if (!atomic_read(&sdev->device_blocked))
 		return token;
@@ -1373,7 +1417,8 @@ static inline int scsi_dev_queue_ready(struct reque=
st_queue *q,
 	 */
 	if (scsi_device_busy(sdev) > 1 ||
 	    atomic_dec_return(&sdev->device_blocked) > 0) {
-		sbitmap_put(&sdev->budget_map, token);
+		if (sdev->budget_map.map)
+			sbitmap_put(&sdev->budget_map, token);
 		return -1;
 	}
=20
@@ -1749,7 +1794,8 @@ static void scsi_mq_put_budget(struct request_queue=
 *q, int budget_token)
 {
 	struct scsi_device *sdev =3D q->queuedata;
=20
-	sbitmap_put(&sdev->budget_map, budget_token);
+	if (sdev->budget_map.map)
+		sbitmap_put(&sdev->budget_map, budget_token);
 }
=20
 /*
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3c6e089e80c3..6f2d0bf0e3ec 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -218,6 +218,7 @@ static void scsi_unlock_floptical(struct scsi_device =
*sdev,
 static int scsi_realloc_sdev_budget_map(struct scsi_device *sdev,
 					unsigned int depth)
 {
+	struct Scsi_Host *shost =3D sdev->host;
 	int new_shift =3D sbitmap_calculate_shift(depth);
 	bool need_alloc =3D !sdev->budget_map.map;
 	bool need_free =3D false;
@@ -225,6 +226,13 @@ static int scsi_realloc_sdev_budget_map(struct scsi_=
device *sdev,
 	int ret;
 	struct sbitmap sb_backup;
=20
+	if (shost->host_tagset && depth >=3D shost->can_queue) {
+		memflags =3D blk_mq_freeze_queue(sdev->request_queue);
+		sbitmap_free(&sb_backup);
+		blk_mq_unfreeze_queue(sdev->request_queue, memflags);
+		return 0;
+	}
+
 	depth =3D min_t(unsigned int, depth, scsi_device_max_queue_depth(sdev))=
;
=20
 	/*
@@ -1112,7 +1120,8 @@ static int scsi_add_lun(struct scsi_device *sdev, u=
nsigned char *inq_result,
 	scsi_cdl_check(sdev);
=20
 	sdev->max_queue_depth =3D sdev->queue_depth;
-	WARN_ON_ONCE(sdev->max_queue_depth > sdev->budget_map.depth);
+	WARN_ON_ONCE(sdev->budget_map.map &&
+		     sdev->max_queue_depth > sdev->budget_map.depth);
 	sdev->sdev_bflags =3D *bflags;
=20
 	/*
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 6d6500148c4b..3c7a95fa9b67 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -687,10 +687,7 @@ static inline int scsi_device_supports_vpd(struct sc=
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
