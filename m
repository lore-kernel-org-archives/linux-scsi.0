Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A833D27FD68;
	Mon, 17 Nov 2025 22:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763419982; cv=none; b=MUJ/DVLDmr+vhVW06fsJ0NF0+RZtD6+ZOloI4gGhx4rfNlw3ifc4DsAehUnf9pbQ7WwIpUp80/Ap5mdxhahzbR0MsD6WvNaHeMEP3H0N7bWWxUvQaV7HDomwPOo64bOt0CZ56FaXry9Owy9w51v0cSxddu+D36SwhtxLyFeNug0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763419982; c=relaxed/simple;
	bh=x/w446n/RSaF+jW+bwQKxgxtrs2wR8uIz2jO9RJWSj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rEj66Yf8awWwDqAb7XgZ/mexdffvYhwMCDbOl8RSDuRREfJpAimgSfhwahXFq7GkCTRHaPuf7h8aXNlgIT/UbSk3SSj9Cg2nWoi5nX4fVrRkDsHjLCwvGMtbGI4iTvsPp0T4epd0sS9ST87aoBhyBuEoJ6yCkQz37ZbMrXkX4do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=eC86WCc8; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="eC86WCc8"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4d9NLf6JMfzltNPh;
	Mon, 17 Nov 2025 22:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1763419976; x=1766011977; bh=tMyZH
	oVekGei4w5TiB42NUznYkZZoEzFvcz8yo1vOtI=; b=eC86WCc8YU/xAqOtVVOws
	kJkzviptKCqp1VQF/ypbKTmfcrTgwGapyjmPowo08A/PXJPpG7LyVf2FFcl8R87r
	lfUCSVIyUz4Tw6cF3hAoDpyoKvGKUVudBTbNS17Pq9qGThDC9rvS2cY8AGdRKaNX
	Kz5o0ELLYWKVHw93WgF62cM+ntfsj9tqFNVyTMkziQChdi02kPVnZEHpT+W05bu6
	RiS1GOrsr1soTSXsUPoNfRrap/owO3dc3b1qvIfGcMa3ojJsuVJu2PzRR0JfbhUw
	N0KyauP6dwYrOz2n2LtiUiqkC5jbLsG4NhIPxuryz9W5DaCcCe6cjfsd2oyT4P+z
	w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Xv6kT4wvowTv; Mon, 17 Nov 2025 22:52:56 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4d9NLV54H5zltMJY;
	Mon, 17 Nov 2025 22:52:49 +0000 (UTC)
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
Subject: [PATCH v2 5/5] scsi: core: Improve IOPS in case of host-wide tags
Date: Mon, 17 Nov 2025 14:52:04 -0800
Message-ID: <20251117225205.2024479-6-bvanassche@acm.org>
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

The SCSI core uses the budget map to restrict the number of commands
that are in flight per logical unit. That limit check can be left out if
host->cmd_per_lun >=3D host->can_queue and if the host tag set is shared
across all hardware queues or if there is only one hardware queue  Since
scsi_mq_get_budget() shows up in all CPU profiles for fast SCSI devices,
do not allocate a budget map if cmd_per_lun >=3D can_queue and if the hos=
t
tag set is shared across all hardware queues.

For the following test this patch increases IOPS by 5%:

modprobe scsi_debug delay=3D0 no_rwlock=3D1 host_max_queue=3D192 submit_q=
ueues=3D$(nproc)

fio --bs=3D4096 --disable_clat=3D1 --disable_slat=3D1 --group_reporting=3D=
1 \
  --gtod_reduce=3D1 --invalidate=3D1 --ioengine=3Dio_uring --ioscheduler=3D=
none \
  --norandommap --runtime=3D60 --rw=3Drandread --thread --time_based=3D1 =
\
  --buffered=3D0 --numjobs=3D1 --iodepth=3D192 --iodepth_batch=3D24 --nam=
e=3D/dev/sda \
  --filename=3D/dev/sda

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi.c      |  3 ++-
 drivers/scsi/scsi_scan.c | 18 +++++++++++++++++-
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 76cdad063f7b..3daa32c9e790 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -229,7 +229,8 @@ int scsi_change_queue_depth(struct scsi_device *sdev,=
 int depth)
 	if (sdev->request_queue)
 		blk_set_queue_depth(sdev->request_queue, depth);
=20
-	sbitmap_resize(&sdev->budget_map, sdev->queue_depth);
+	if (sdev->budget_map.map)
+		sbitmap_resize(&sdev->budget_map, sdev->queue_depth);
=20
 	return sdev->queue_depth;
 }
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 7acbfcfc2172..99b82e28f292 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -215,9 +215,17 @@ static void scsi_unlock_floptical(struct scsi_device=
 *sdev,
 			 SCSI_TIMEOUT, 3, NULL);
 }
=20
+static bool scsi_needs_budget_map(struct Scsi_Host *shost, unsigned int =
depth)
+{
+	if (shost->host_tagset || shost->tag_set.nr_hw_queues =3D=3D 1)
+		return depth < shost->can_queue;
+	return true;
+}
+
 static int scsi_realloc_sdev_budget_map(struct scsi_device *sdev,
 					unsigned int depth)
 {
+	struct Scsi_Host *shost =3D sdev->host;
 	int new_shift =3D sbitmap_calculate_shift(depth);
 	bool need_alloc =3D !sdev->budget_map.map;
 	bool need_free =3D false;
@@ -225,6 +233,13 @@ static int scsi_realloc_sdev_budget_map(struct scsi_=
device *sdev,
 	int ret;
 	struct sbitmap sb_backup;
=20
+	if (!scsi_needs_budget_map(shost, depth)) {
+		memflags =3D blk_mq_freeze_queue(sdev->request_queue);
+		sbitmap_free(&sdev->budget_map);
+		blk_mq_unfreeze_queue(sdev->request_queue, memflags);
+		return 0;
+	}
+
 	depth =3D min_t(unsigned int, depth, scsi_device_max_queue_depth(sdev))=
;
=20
 	/*
@@ -1120,7 +1135,8 @@ static int scsi_add_lun(struct scsi_device *sdev, u=
nsigned char *inq_result,
 	scsi_cdl_check(sdev);
=20
 	sdev->max_queue_depth =3D sdev->queue_depth;
-	WARN_ON_ONCE(sdev->max_queue_depth > sdev->budget_map.depth);
+	WARN_ON_ONCE(sdev->budget_map.map &&
+		     sdev->max_queue_depth > sdev->budget_map.depth);
=20
 	/*
 	 * Ok, the device is now all set up, we can
