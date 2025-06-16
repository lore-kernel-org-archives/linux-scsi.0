Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42C31DB92A;
	Mon, 16 Jun 2025 22:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750113267; cv=none; b=lIbSnaT9NNZvDxHx1A2OHRhAPMZA/1TTOoBtDgl73K6vuVV+2PpSNcHMxvKUWhI/9y07ytov9u3+is66y/sy8QCnhf/f7giBgWFZoLi0RkwbpGCNoq8UXMqTDJMRxQGfWIUK217UYZD94jPoxlc58MrMfaTJP6WkaNX+Fvt0m/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750113267; c=relaxed/simple;
	bh=nUu/P956qFKPTLZJ+EE+nbZr5DTSyfgJMzZo3aIryZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gdaMRGGDYxyuEWz5zEMkmYAvKqU9QP/ms/psyXkmByHwuPgguZtm1mkEhcWVY4nwkttCAqsJSiD4KTSJu0QUnFO9qAt+9rSzSVdB54ri8CIswmw8r4AOshnwpfhYZNCB+t4NCKkC8OftPVD67U5YSxbsWF3q7HlaqgAKASoIZoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=l/y4fsy5; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="l/y4fsy5"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bLlDK0xG7zlgqxr;
	Mon, 16 Jun 2025 22:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1750113263; x=1752705264; bh=3TDpt
	GXYFDjQWPXazFKS9qAdi/nTvRIVWafz+MxYZak=; b=l/y4fsy5fMyfGUeH3W+1S
	aSNWbhlPLBw+k7cw2TDUz82jBVfXKWR0ioHN54/RhRPucp+uMPTXE20khGugdl8z
	6MSbERdj3uUAql2hzY1z/d+tQ1RiTrozlFtr3+s1PqCQ2+5stF/pV/sn031VwrZx
	atJq998sH+8h1SoRKgeX41jNf4FDbdsSUO3ovRHnu0jzsxwbfHBkpWNRGC14fWNj
	gJu/A6TLE3YsZkDWAFx7Qiwn5DnASSSqCboHNw/We2Hm3e7K5ZDehTpRK9GjkoWG
	F87MafmMCBxhm/8TC0r05N5egZaT2LjNjeew/V8JPiAsAyuhud4XJAsyKW1uFNW/
	A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ngWWGQLvfR0Y; Mon, 16 Jun 2025 22:34:23 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bLlDC4mb3zlgqVy;
	Mon, 16 Jun 2025 22:34:18 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v18 05/12] blk-zoned: Add an argument to blk_zone_plug_bio()
Date: Mon, 16 Jun 2025 15:33:05 -0700
Message-ID: <20250616223312.1607638-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.0.rc2.692.g299adb8693-goog
In-Reply-To: <20250616223312.1607638-1-bvanassche@acm.org>
References: <20250616223312.1607638-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Prepare for preserving the order of pipelined zoned writes per zone.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-mq.c         | 2 +-
 block/blk-zoned.c      | 4 +++-
 drivers/md/dm.c        | 2 +-
 include/linux/blkdev.h | 2 +-
 4 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 1735b1ac0574..ec04ff556983 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3184,7 +3184,7 @@ void blk_mq_submit_bio(struct bio *bio)
 	if (blk_mq_attempt_bio_merge(q, bio, nr_segs))
 		goto queue_exit;
=20
-	if (blk_queue_is_zoned(q) && blk_zone_plug_bio(bio, nr_segs))
+	if (blk_queue_is_zoned(q) && blk_zone_plug_bio(bio, nr_segs, &from_cpu)=
)
 		goto queue_exit;
=20
 new_request:
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 351d659280e1..a79bb71a83e0 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1104,6 +1104,8 @@ static void blk_zone_wplug_handle_native_zone_appen=
d(struct bio *bio)
  * blk_zone_plug_bio - Handle a zone write BIO with zone write plugging
  * @bio: The BIO being submitted
  * @nr_segs: The number of physical segments of @bio
+ * @from_cpu: [out] CPU of the software queue to which the bio should be
+ *	queued
  *
  * Handle write, write zeroes and zone append operations requiring emula=
tion
  * using zone write plugging.
@@ -1112,7 +1114,7 @@ static void blk_zone_wplug_handle_native_zone_appen=
d(struct bio *bio)
  * write plug. Otherwise, return false to let the submission path proces=
s
  * @bio normally.
  */
-bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs)
+bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs, int *from_=
cpu)
 {
 	struct block_device *bdev =3D bio->bi_bdev;
=20
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 1726f0f828cc..18084277ea27 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1788,7 +1788,7 @@ static inline bool dm_zone_bio_needs_split(struct m=
apped_device *md,
 }
 static inline bool dm_zone_plug_bio(struct mapped_device *md, struct bio=
 *bio)
 {
-	return dm_emulate_zone_append(md) && blk_zone_plug_bio(bio, 0);
+	return dm_emulate_zone_append(md) && blk_zone_plug_bio(bio, 0, NULL);
 }
=20
 static blk_status_t __send_zone_reset_all_emulated(struct clone_info *ci=
,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6d01269f9fcf..f3471c98c22f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -842,7 +842,7 @@ static inline unsigned int disk_nr_zones(struct gendi=
sk *disk)
 {
 	return disk->nr_zones;
 }
-bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs);
+bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs, int *from_=
cpu);
=20
 /**
  * disk_zone_capacity - returns the zone capacity of zone containing @se=
ctor
