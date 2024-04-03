Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBCC82864;
	Wed,  3 Apr 2024 08:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712133797; cv=none; b=cPSsXBd1I3dC+HgFNEPPhXFzIS6Lm2GArAcEM8Pl9Rq9gFCqnUBH9MrPd/Bq8D83zF3YLR1SFtppSzSbqApcI2TCx7SDI7QyAHgXbrxBJSoWBd9m0r+lODxPqpO2Enajn21wL/0lkdJBvEiEg0eWL+3+plMK7VPnTyMhhWyQ18k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712133797; c=relaxed/simple;
	bh=5kuGDz7PFBe8BfeXEWEPHhMGeK8Ab2+ZUYqbLV7Sh2g=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ojyvoes2eSCoqHmau+rkpSYmETagMhkQyzBGxHj93pFN3WLifAVrCzrXQro1VbmKlEs1yUA4pPR5RLxHGGK/uUCiskLvINMDwP36qw+naffZECNjZkAFOgihPZcHZvncox4y8m4OIwAIp/Sq+BvS/LX4pBEy3IUHrR+sWIAVMDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pw1VDLft; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pw1VDLft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B912AC43390;
	Wed,  3 Apr 2024 08:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712133797;
	bh=5kuGDz7PFBe8BfeXEWEPHhMGeK8Ab2+ZUYqbLV7Sh2g=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=pw1VDLftOSgKpHFZtNZf3OWDCXuwpyDGOwmWzbnMwANuxJQzwYJPaT+rCG2og8cK3
	 KJ8vEZaeRU96arvXTBuYzhN9WflGe/1BXyKypsViMSiBrv4F6ESfRLzN17b0Wd1quv
	 JE8PRclTDzD1Ifob1fgxbxC/b8fD1f2aKkWmG7Ruh+PRnDHss3HV1SET08l1csai0D
	 l8Vj1Z6N9Wwdjuy4d6xYxTnYP2PryMpe+L07E73/R68Ul+nVVXDkPylSRCq8Fspu8s
	 z4OUJMJoRRMtUz6KUzNUoLxQICfrt5R1hA2YiGdvcuJtda2cJyrTKApH40vBSPY3hs
	 U6iBGex1YaD8Q==
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
Subject: [PATCH v5 17/28] null_blk: Introduce fua attribute
Date: Wed,  3 Apr 2024 17:42:36 +0900
Message-ID: <20240403084247.856481-18-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240403084247.856481-1-dlemoal@kernel.org>
References: <20240403084247.856481-1-dlemoal@kernel.org>
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
index a5a50ba6ad9f..578660b1ad01 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -225,6 +225,10 @@ static unsigned long g_cache_size;
 module_param_named(cache_size, g_cache_size, ulong, 0444);
 MODULE_PARM_DESC(mbps, "Cache size in MiB for memory-backed device. Default: 0 (none)");
 
+static bool g_fua = true;
+module_param_named(fua, g_fua, bool, 0444);
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

