Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4AB1C1F10;
	Fri,  3 Jan 2025 07:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735890165; cv=none; b=MbGqsLkRE8SVIuXFUDVK8tFhZ/o4rWZr1HAIO6HxhCeSM82s1ISR2INUZqfVGKMIMSUf6oyw+1ecLkk1nRk/4mSufX++q/D7IcleDpm+VmLCf2XEFBobBi2WcSpEeyJRoZdF3+RSIZCGcoS1AR3yjGXMccg4leV4nFsNl2YdPOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735890165; c=relaxed/simple;
	bh=U9IogqFQ/+OuQqloW2oIf/dg5DDB439QS/jvfhpNFwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TyCxP3ZQsgFxMRecT/jRODurRMPSzVl4hwq0SJy/+gY4GWNB0mknqZVhco+32IgN7q/E0VvxwI/QRQNJ6IneHTJNZzMBsK1+lu2PrscNikJ1N7oExCHkjtvkJm344YwhSd8S5IZNzGSDmuUoxkOHB8XzFJFH/otzB0Pjx05g+zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xNgauOQh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xNgauOQh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=iQlA8Yz+qd2U/c34P+2wJP+a7YEau+u9d5FsTdJxE5E=; b=xNgauOQhiaKkhUeDDVsv9LGowd
	m+i2iE8usGs1gk4qLZu8iaEpppF0Kll6XybaMYeryTvANCf4A5NP1PiEXiosg90Y0oCE1YJVbDDw6
	YKUXcl8YXTqKIvyOcXJ7UyARNj+5lzeob633+lEtwKg6OM7oyRTB3+xQJ42HO4VTACJj13bFdripR
	dQDjuZEvvLvNwzL7HNrWWYO7Ohzo8JlTE5ZfptIyhZS77cL8VrdTSBgw01uxNFQ1vPr0lhea5SkZF
	J37bthEDraSpUWjbWK53E9o/ljA3t3m4n+l+xgRi7wf4SGjaSuKhyfkfIi71SjK0DbtSTNHP8Zvog
	zJ2kE5rQ==;
Received: from [2001:4bb8:2dc:484c:63c3:48c7:ceee:8370] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tTcKR-0000000CNrG-07uw;
	Fri, 03 Jan 2025 07:42:43 +0000
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
Date: Fri,  3 Jan 2025 08:42:09 +0100
Message-ID: <20250103074237.460751-2-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250103074237.460751-1-hch@lst.de>
References: <20250103074237.460751-1-hch@lst.de>
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
index 5678194b6b1a..018721b14053 100644
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

