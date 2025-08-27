Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C142F39A9
	for <linux-scsi@vger.kernel.org>; Wed, 27 Aug 2025 11:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756294569; cv=none; b=g97Yxy2JTJdFHH/CN+zgkOZeXrx8NbMW/Pcba58m9rd9PhgeGQTFBGFNEWxEkPD2jDQdtZamSCGBBcbRyv2QED+1/t95N+sCtFE3yoOLIUd7Ap2tLujCfIQ4s3EN62qYRQQemk2Ey2G/mXrrvFH3dSZp1N1H2xnTtzdR0mHpo7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756294569; c=relaxed/simple;
	bh=wgh29TBAWfK7IKN4tu05jI5GQ1jj7c3Y9FY4aM9NduY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TkH+/mXt+nb+Im/DgpMdbrgze86SfJXRZRMo/OqPGy5fAiruhsyuquLnrl2WtFz3829Mhu8KBCuiCu3TKSHyYAJi7wgE+hm7/wMNk5pPQE2vKt3an0bup89mc3iwRH5M4XA5hSm+S5kbunHpsIlOx0r6ifIib445z5yNf1F6c9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WvvTTz0b; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WvvTTz0b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756294566;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=39v9pRG04LvRBmUW/1LxWE2Bfz+SiAEdqQeLGr3S5f8=;
	b=WvvTTz0bV9SSspe1Cktklf9eX3Cz5a3ULZrgrpGFTZBCvaaPT776uKglIi8qK/dUC1chcN
	h9cYErBSJEsmIx5p1uIMBt7KBBVDzmAsx0+JpEEDYlt62j3mO529rSmd8gvqg7GIP1bYtp
	gqgtaMUOvE2YH3xrrFru0pyl9dDrqZc=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-490-dKZKw90oNq2ZzKzLX-7iCA-1; Wed,
 27 Aug 2025 07:36:05 -0400
X-MC-Unique: dKZKw90oNq2ZzKzLX-7iCA-1
X-Mimecast-MFC-AGG-ID: dKZKw90oNq2ZzKzLX-7iCA_1756294564
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EA6261955F29;
	Wed, 27 Aug 2025 11:36:03 +0000 (UTC)
Received: from localhost (unknown [10.72.116.24])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 85AA730001A8;
	Wed, 27 Aug 2025 11:36:02 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Ming Lei <ming.lei@redhat.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH] scsi: sr: Set rotational feature flag back
Date: Wed, 27 Aug 2025 19:35:50 +0800
Message-ID: <20250827113550.2614535-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Set rotational feature flag back for cd-rom which is really rotational disk,
and the flag is `cleared` since commit bd4a633b6f7c ("block: move the nonrot
flag to queue_limits"). And this way breaks some applications.

Move queue limits configuration from get_sectorsize() to
sr_revalidate_disk(), so that it is more readable to set rotational
feature flag and sector size limit in sr_revalidate_disk().

Cc: Christoph Hellwig <hch@lst.de>
Fixes: bd4a633b6f7c ("block: move the nonrot flag to queue_limits")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/sr.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index b17796d5ee66..add13e306898 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -475,13 +475,21 @@ static blk_status_t sr_init_command(struct scsi_cmnd *SCpnt)
 
 static int sr_revalidate_disk(struct scsi_cd *cd)
 {
+	struct request_queue *q = cd->device->request_queue;
 	struct scsi_sense_hdr sshdr;
+	struct queue_limits lim;
+	int sector_size;
 
 	/* if the unit is not ready, nothing more to do */
 	if (scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr))
 		return 0;
 	sr_cd_check(&cd->cdi);
-	return get_sectorsize(cd);
+	sector_size = get_sectorsize(cd);
+
+	lim = queue_limits_start_update(q);
+	lim.logical_block_size = sector_size;
+	lim.features |= BLK_FEAT_ROTATIONAL;
+	return queue_limits_commit_update_frozen(q, &lim);
 }
 
 static int sr_block_open(struct gendisk *disk, blk_mode_t mode)
@@ -721,10 +729,8 @@ static int sr_probe(struct device *dev)
 
 static int get_sectorsize(struct scsi_cd *cd)
 {
-	struct request_queue *q = cd->device->request_queue;
 	static const u8 cmd[10] = { READ_CAPACITY };
 	unsigned char buffer[8] = { };
-	struct queue_limits lim;
 	int err;
 	int sector_size;
 	struct scsi_failure failure_defs[] = {
@@ -795,9 +801,7 @@ static int get_sectorsize(struct scsi_cd *cd)
 		set_capacity(cd->disk, cd->capacity);
 	}
 
-	lim = queue_limits_start_update(q);
-	lim.logical_block_size = sector_size;
-	return queue_limits_commit_update_frozen(q, &lim);
+	return sector_size;
 }
 
 static int get_capabilities(struct scsi_cd *cd)
-- 
2.47.1

