Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A85D1D90DB;
	Mon,  6 Jan 2025 08:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736152538; cv=none; b=EfPyuxaiJcfPCN6EyyA935eQWX6mc9z/Gib30RSUtaoD9OsoO9L+LNkf0zXU/UfHOzENsWxDMHikwqc/0tCqQ9jS0NqGtftZ7/n1G+9sIFckUziptmBLMtr/8Y7H7xW5lP5eAmVWsVkjIYH2bJgzx+krN9KffFHHyTzhiRnQSGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736152538; c=relaxed/simple;
	bh=uQbC7paO36b/NllZMFBGQoDNuCgCccKvuVV27g/PP2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=myHsl3vIC5/bxr8mMW3wVwDDi0Tt8iTkCD0tiFRIE5AOZVMc3F+OzFDZNPLO69ssEKso6ByMiEHIgArkC7up/yKkLyGCewvOwbFYz2nWtFL+kod8yYNs0hkV2+Z9y786SEgG9Ld4qQ4muF+oK4vh4vV55c6tJkaQkXJQxItiDB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=a2nRL234; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="a2nRL234"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=XMPaZOMoBw6ur5MuCUW7nPkqLLQNukGLONnBOIRNueM=; b=a2nRL234Kbw9VEHoFvHnK2pp5P
	006KIqwpv1I+pGFRYaRHEU1CJa3AJ2vmHtFV/rhE/wJGqkoDMwFyQepvrOpsNH24/1XWlXznUxUGb
	IwLC1KQHz3QSGJSMaGr5RHpxSb/AIU14GduvvalnkfgmgNcVTR6AE10K6OEN+lOHuwHs2r2g5P8v5
	3wv8G8zZNJ0GdFYgDQuMLvcjFv5/cJ/L7C5VswOvTu8sPBW4YAajG0wtGIxaOi1SQwmePFLVvYk3c
	UYcEoCx5Ui7gjfTnhA5hwVxE/NrOFZS3cazVRV6x+pAtHiy6nQP5xU4TDaNJDzTxxTlfGFOzuZB6Z
	OBXXOxqQ==;
Received: from 2a02-8389-2341-5b80-db6b-99e8-3feb-3b4e.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:db6b:99e8:3feb:3b4e] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tUiaG-00000000XE8-34GU;
	Mon, 06 Jan 2025 08:35:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	linux-block@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH 1/4] block: better split mq vs non-mq code in add_disk_fwnode
Date: Mon,  6 Jan 2025 09:35:08 +0100
Message-ID: <20250106083531.799976-2-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250106083531.799976-1-hch@lst.de>
References: <20250106083531.799976-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a big conditional for blk-mq vs not mq at the beginning of
add_disk_fwnode so that elevator_init_mq is only called for blk-mq disks,
and add checks that the right methods or set or not set based on the
queue type.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 5da3c9a64e64..befb7a516bcf 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -400,21 +400,23 @@ int __must_check add_disk_fwnode(struct device *parent, struct gendisk *disk,
 	struct device *ddev = disk_to_dev(disk);
 	int ret;
 
-	/* Only makes sense for bio-based to set ->poll_bio */
-	if (queue_is_mq(disk->queue) && disk->fops->poll_bio)
-		return -EINVAL;
-
-	/*
-	 * The disk queue should now be all set with enough information about
-	 * the device for the elevator code to pick an adequate default
-	 * elevator if one is needed, that is, for devices requesting queue
-	 * registration.
-	 */
-	elevator_init_mq(disk->queue);
+	if (queue_is_mq(disk->queue)) {
+		/*
+		 * ->submit_bio and ->poll_bio are bypassed for blk-mq drivers.
+		 */
+		if (disk->fops->submit_bio || disk->fops->poll_bio)
+			return -EINVAL;
 
-	/* Mark bdev as having a submit_bio, if needed */
-	if (disk->fops->submit_bio)
+		/*
+		 * Initialize the I/O scheduler code and pick a default one if
+		 * needed.
+		 */
+		elevator_init_mq(disk->queue);
+	} else {
+		if (!disk->fops->submit_bio)
+			return -EINVAL;
 		bdev_set_flag(disk->part0, BD_HAS_SUBMIT_BIO);
+	}
 
 	/*
 	 * If the driver provides an explicit major number it also must provide
-- 
2.45.2

