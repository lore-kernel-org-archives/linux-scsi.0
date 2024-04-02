Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586F58615E;
	Tue,  2 Apr 2024 12:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712061574; cv=none; b=PFXr+Lw1sNfutoZAjzYFlBYQXVYSL4tohhBFWtulPikcoEiahd1L+WqJkJKPqjSSAvCYKmvDJorCqDahR7lPRRDF+k754oIqcQvt/n0Ln+1F+lRonvLJKpeob0hBUfj1TvQxU6DGLP1/Hnr/T6KiPdksXY1MmZr3pjZ0D6ZYQgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712061574; c=relaxed/simple;
	bh=cyp7WOQsIFl0ciROaWeBMZvEOeOCq1R+AmapKo/Ymcg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o7Fs8ZcG3OgUpcuGoEOLzQJ0KJlXrqtK6fivp0YfH7H38adgg0dffmGLLMnmKbWn48nmQCpMz9dgZk4c1fKnRmrsg83TduH3UZyX194nPPVhP+BJG32FwyFa5xXjTJIzIfFoeC+0g/GYVe/yZzvPdpo3TUaik1bYAclSoZWUWLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L7J2GRfV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L7J2GRfV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A09C43399;
	Tue,  2 Apr 2024 12:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712061574;
	bh=cyp7WOQsIFl0ciROaWeBMZvEOeOCq1R+AmapKo/Ymcg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=L7J2GRfVUVsP921wBCzK/FUM8XH2Kye92o8K35r00pMqGLg+THIBrbFNjQpgpNuxP
	 Al/W0leJ3ONgGAZ+1l+MDy/Phvt1vED0bjJGfuWWl2chR4V3cCN8UQMBVBAqW7z+Aj
	 eZANz2FyyGGqpmnFxYyv6Cy+n9wEIvWB/fbxfcWs5lr5OFHtLKJXQTWE4jPyDLtOa9
	 7GckZ5sAqcmxniajBs3nBvt9Hah1qufwKaewlRjzOXdHVo33hQlw+TiVflez1hSoIk
	 k1VlBNWjgVcpjKnoHCFQsQ1Lc0la89OwUYrq3w3Uvb+e9RmsWYWCSAYIwH7Wd9ptAF
	 5HKdr7opWpouA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v4 17/28] null_blk: Introduce fua attribute
Date: Tue,  2 Apr 2024 21:38:56 +0900
Message-ID: <20240402123907.512027-18-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240402123907.512027-1-dlemoal@kernel.org>
References: <20240402123907.512027-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the fua configfs attribute and module parameter to allow
configuring if the device supports FUA or not. Using this attribute
has an effect on the null_blk device only if memory backing is enabled
together with a write cache (cache_size option).

This new attribute allows configuring a null_blk device with a write
cache but without FUA support. This is convenient to test the block
layer flush machinery.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/block/null_blk/main.c     | 12 ++++++++++--
 drivers/block/null_blk/null_blk.h |  1 +
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index a5a50ba6ad9f..1dfaf2628007 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -225,6 +225,10 @@ static unsigned long g_cache_size;
 module_param_named(cache_size, g_cache_size, ulong, 0444);
 MODULE_PARM_DESC(mbps, "Cache size in MiB for memory-backed device. Default: 0 (none)");
 
+static bool g_fua = true;
+module_param_named(fua, g_fua, bool, S_IRUGO);
+MODULE_PARM_DESC(zoned, "Enable/disable FUA support when cache_size is used. Default: true");
+
 static unsigned int g_mbps;
 module_param_named(mbps, g_mbps, uint, 0444);
 MODULE_PARM_DESC(mbps, "Limit maximum bandwidth (in MiB/s). Default: 0 (no limit)");
@@ -446,6 +450,7 @@ NULLB_DEVICE_ATTR(virt_boundary, bool, NULL);
 NULLB_DEVICE_ATTR(no_sched, bool, NULL);
 NULLB_DEVICE_ATTR(shared_tags, bool, NULL);
 NULLB_DEVICE_ATTR(shared_tag_bitmap, bool, NULL);
+NULLB_DEVICE_ATTR(fua, bool, NULL);
 
 static ssize_t nullb_device_power_show(struct config_item *item, char *page)
 {
@@ -593,6 +598,7 @@ static struct configfs_attribute *nullb_device_attrs[] = {
 	&nullb_device_attr_no_sched,
 	&nullb_device_attr_shared_tags,
 	&nullb_device_attr_shared_tag_bitmap,
+	&nullb_device_attr_fua,
 	NULL,
 };
 
@@ -671,7 +677,7 @@ nullb_group_drop_item(struct config_group *group, struct config_item *item)
 static ssize_t memb_group_features_show(struct config_item *item, char *page)
 {
 	return snprintf(page, PAGE_SIZE,
-			"badblocks,blocking,blocksize,cache_size,"
+			"badblocks,blocking,blocksize,cache_size,fua,"
 			"completion_nsec,discard,home_node,hw_queue_depth,"
 			"irqmode,max_sectors,mbps,memory_backed,no_sched,"
 			"poll_queues,power,queue_mode,shared_tag_bitmap,"
@@ -763,6 +769,8 @@ static struct nullb_device *null_alloc_dev(void)
 	dev->no_sched = g_no_sched;
 	dev->shared_tags = g_shared_tags;
 	dev->shared_tag_bitmap = g_shared_tag_bitmap;
+	dev->fua = g_fua;
+
 	return dev;
 }
 
@@ -1920,7 +1928,7 @@ static int null_add_dev(struct nullb_device *dev)
 
 	if (dev->cache_size > 0) {
 		set_bit(NULLB_DEV_FL_CACHE, &nullb->dev->flags);
-		blk_queue_write_cache(nullb->q, true, true);
+		blk_queue_write_cache(nullb->q, true, dev->fua);
 	}
 
 	nullb->q->queuedata = nullb;
diff --git a/drivers/block/null_blk/null_blk.h b/drivers/block/null_blk/null_blk.h
index a9c5df650ddb..3234e6c85eed 100644
--- a/drivers/block/null_blk/null_blk.h
+++ b/drivers/block/null_blk/null_blk.h
@@ -105,6 +105,7 @@ struct nullb_device {
 	bool no_sched; /* no IO scheduler for the device */
 	bool shared_tags; /* share tag set between devices for blk-mq */
 	bool shared_tag_bitmap; /* use hostwide shared tags */
+	bool fua; /* Support FUA */
 };
 
 struct nullb {
-- 
2.44.0

