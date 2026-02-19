Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35924238C16
	for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2026 04:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771475980; cv=none; b=IeDUwF99I4+PbEf8ZDIF0zhXkxxtejPRoi+eSn+kbw0jxMOJJrHLDPHw4rWqEvLglXIbcs8x72mHZ/t+fUvVQqQRMK4FTSrzekz+6VVw4W2s3OqIHER0c2qnmjgyi6L60uLHDtBCz1XccOtzrmUfMk7lb5qXWDkQezG2PqfTCZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771475980; c=relaxed/simple;
	bh=/+hxZZTRXC2qWipiE54XkooIeb/8eA4K6wnLScBQbQI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CmZWds1Ys44NZXrFBBlUbmoEPLcxYbJdoyr50Hv7i5hDAaTnZalKHuzF1Gg7rIpIdnGlirp6wtvtUGJcZqURTwC/HCMO3E83lL2k6Q5WsV2ZQDawwNpfIGCY4TX7J5OkxO6JCVq/ggwODfCXDHa0nxEwYoYYab7sjqOMjGfTtew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bn6mg0CI; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bn6mg0CI"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-c62239decbeso232201a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Feb 2026 20:39:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771475978; x=1772080778; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=46IFIdbZ1G8VUr2RBCZqSJUa4eIUYoNzWfYcnZxpWws=;
        b=Bn6mg0CIOiSt7LVhehiqm1Qr8fImugXCkxSSjWcJgvZT49amemmMpzW3gjLMBBJEYM
         gIAU+nO8ZV2ZAtAT1kzIGxqX6/idzlzWTCJM3hRceALgS55ko9Xf2eH2RFkN4gxwYwcw
         SAzScdzzYF+F1xol7b8EUcmlNpVOClChnICewWEIdytbbTm9n9yqx8FnQyoyyFlaA7Tb
         XJWPudQFfobvDzDmk2O4yWvo0gNr5aJNcYeRlgBT8XgCOrLNBJipFpGs0Oyntogti1BF
         gshVf8oHqBFfY9Yq2/3o++Wd+K9G9Z5CgukhnSqIZpDiy2QnDoZLHIMVC3mSLgJNkS1d
         QBfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771475978; x=1772080778;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=46IFIdbZ1G8VUr2RBCZqSJUa4eIUYoNzWfYcnZxpWws=;
        b=QWKQebBjnW4kjMC44HyldJiL1Qu8pKXY3QcX6M3WbVm3Jr6+8KjzQ4iZeKJ4EA7N/b
         hlakvz3zXZU2Ii9mcDWMsemEF5AhTOVCelgW6LIpmRrLPlaG4gB5n4tqGDX+sOeTJePS
         8JhfIh8lzCjQ0mhvf9QyEA+Crq0w/rKzObMfd+4FXk6LCfr+29yuyHeSqRkBR3XVo5tZ
         dJl/ut8zP2lcf3kpYiCI3QwDxC2aByYT0zjQFGuIbepBs8uU3ohHY589nIGbeIs+t86O
         oZXxBIgNvsthOjYsa/26JabgVwkC0ihkb60MxCopbv1fSBwH2nkdObu5wdm6NKYhnsxX
         baLQ==
X-Forwarded-Encrypted: i=1; AJvYcCUK8IccPvJXPozLmEnrmWjKVoLf6a0W1mKXecrRSLh3b5kUE7VRWiZBiDuRa49OiVWBcjGNS+LiMwjQ@vger.kernel.org
X-Gm-Message-State: AOJu0Yyu4YUE4oebWq8Ewp3Wf7zP5NqDZSIo9TVwUb/qVfiCPJgVdr/G
	wm0eS+vEBcSRxVDjJo15vutROCChD4WjA50tlD1PBm2Lsr07iMH9b8wm
X-Gm-Gg: AZuq6aLT+l88RmK9a5qg6iruJqrpfhWK/EbRJ127PWxMGi34qqa57kmIyaLJYfK3lB5
	wZOuO07dkkjNcpcGDM/GduZqG0Vl4RXtKfz6jhh6ZforEpFm5InL8jvdeCBVOV5+G8nVn0T1mt3
	9hey66YuJnfWQKnqhDymzmXb0yDfD/FI57y5aRLDxnQo4NsujP9wh4bDod/31MSXgLpN8s5wQLR
	G8Yf9qhNm5+sxIvMnmWHU4enYXR2voRxCBiMes4fkwcLbIzZP8Xbce5gqURY5HEZxycnbM0HxXf
	Wb5hjCir/Rs+4/Z0pxopd2WrqdGv2A8LRh6R3KyOLyNwSSZ0bocksrdtvUoAc00bDaDzkZYF261
	0JPuZX4iYsLKO7uQ+vYsCYHYMLekh6tF8qeyHNyNH6jn87zKJIgjvd736PsVenw7CB190QBaaKV
	qwBb9oWz2RE9OKXvXxMPT07CMC5YasjU/V6kq6KgQQA0QEl/E=
X-Received: by 2002:a17:903:8cc:b0:2a0:9d16:5fb4 with SMTP id d9443c01a7336-2ad174441b9mr157343435ad.18.1771475978488;
        Wed, 18 Feb 2026 20:39:38 -0800 (PST)
Received: from 5163NRD-SPRABHU.ssi.samsung.com ([103.50.21.94])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a713675sm203345025ad.27.2026.02.18.20.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 20:39:38 -0800 (PST)
From: sw.prabhu6@gmail.com
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	mcgrof@kernel.org,
	pankaj.raghav@linux.dev,
	bvanassche@acm.org,
	dlemoal@kernel.org,
	Swarna Prabhu <sw.prabhu6@gmail.com>,
	Swarna Prabhu <s.prabhu@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH 1/2] scsi: sd: enable sector size > PAGE_SIZE in scsi sd driver
Date: Wed, 18 Feb 2026 20:37:42 -0800
Message-Id: <20260219043741.276729-2-sw.prabhu6@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260219043741.276729-1-sw.prabhu6@gmail.com>
References: <20260219043741.276729-1-sw.prabhu6@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Swarna Prabhu <sw.prabhu6@gmail.com>

The WRITE SAME(16) and WRITE SAME(10) scsi commands uses
a page from a dedicated mempool('sd_page_pool') for its
payload. This pool was initialized to allocate single
pages, which was sufficient as long as the device sector
size did not exceed the PAGE_SIZE.

Given that block layer now supports block size upto
64K ie beyond PAGE_SIZE, initialize large page pool in
'sd_probe()' if a higher sector device is attached ensuring
atomicity. Adapt 'sd_set_special_bvec()' to use large page
pool when a higher sector size device is attached. Hence
enable sector sizes > PAGE_SIZE in scsi sd driver.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Swarna Prabhu <s.prabhu@samsung.com>
Co-developed-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/scsi/sd.c | 80 ++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 68 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d76996d6cbc9..ce09239c18cb 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -107,8 +107,11 @@ static void sd_config_write_same(struct scsi_disk *sdkp,
 static void  sd_revalidate_disk(struct gendisk *);
 
 static DEFINE_IDA(sd_index_ida);
+static DEFINE_MUTEX(sd_mutex_lock);
 
 static mempool_t *sd_page_pool;
+static mempool_t *sd_large_page_pool;
+static atomic_t sd_large_page_pool_users = ATOMIC_INIT(0);
 static struct lock_class_key sd_bio_compl_lkclass;
 
 static const char *sd_cache_types[] = {
@@ -116,6 +119,33 @@ static const char *sd_cache_types[] = {
 	"write back, no read (daft)"
 };
 
+static int sd_large_pool_create(void)
+{
+	mutex_lock(&sd_mutex_lock);
+	if (!sd_large_page_pool) {
+		sd_large_page_pool = mempool_create_page_pool(
+			SD_MEMPOOL_SIZE, get_order(BLK_MAX_BLOCK_SIZE));
+		if (!sd_large_page_pool) {
+			printk(KERN_ERR "sd: can't create large page mempool\n");
+			mutex_unlock(&sd_mutex_lock);
+			return -ENOMEM;
+		}
+	}
+	atomic_inc(&sd_large_page_pool_users);
+	mutex_unlock(&sd_mutex_lock);
+	return 0;
+}
+
+static void sd_large_pool_destroy(void)
+{
+	mutex_lock(&sd_mutex_lock);
+	if (atomic_dec_and_test(&sd_large_page_pool_users)) {
+		mempool_destroy(sd_large_page_pool);
+		sd_large_page_pool = NULL;
+	}
+	mutex_unlock(&sd_mutex_lock);
+}
+
 static void sd_disable_discard(struct scsi_disk *sdkp)
 {
 	sdkp->provisioning_mode = SD_LBP_DISABLE;
@@ -928,14 +958,24 @@ static unsigned char sd_setup_protect_cmnd(struct scsi_cmnd *scmd,
 	return protect;
 }
 
-static void *sd_set_special_bvec(struct request *rq, unsigned int data_len)
+static void *sd_set_special_bvec(struct scsi_cmnd *cmd, unsigned int data_len)
 {
 	struct page *page;
+	struct request *rq = scsi_cmd_to_rq(cmd);
+	struct scsi_device *sdp = cmd->device;
+	unsigned sector_size = sdp->sector_size;
+	unsigned int nr_pages = DIV_ROUND_UP(sector_size, PAGE_SIZE);
+	int n;
 
-	page = mempool_alloc(sd_page_pool, GFP_ATOMIC);
+	if (sector_size > PAGE_SIZE)
+		page = mempool_alloc(sd_large_page_pool, GFP_ATOMIC);
+	else
+		page = mempool_alloc(sd_page_pool, GFP_ATOMIC);
 	if (!page)
 		return NULL;
-	clear_highpage(page);
+
+	for (n = 0; n < nr_pages; n++)
+		clear_highpage(page + n);
 	bvec_set_page(&rq->special_vec, page, data_len, 0);
 	rq->rq_flags |= RQF_SPECIAL_PAYLOAD;
 	return bvec_virt(&rq->special_vec);
@@ -951,7 +991,7 @@ static blk_status_t sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
 	unsigned int data_len = 24;
 	char *buf;
 
-	buf = sd_set_special_bvec(rq, data_len);
+	buf = sd_set_special_bvec(cmd, data_len);
 	if (!buf)
 		return BLK_STS_RESOURCE;
 
@@ -1040,7 +1080,7 @@ static blk_status_t sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd,
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
 	u32 data_len = sdp->sector_size;
 
-	if (!sd_set_special_bvec(rq, data_len))
+	if (!sd_set_special_bvec(cmd, data_len))
 		return BLK_STS_RESOURCE;
 
 	cmd->cmd_len = 16;
@@ -1067,7 +1107,7 @@ static blk_status_t sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd,
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
 	u32 data_len = sdp->sector_size;
 
-	if (!sd_set_special_bvec(rq, data_len))
+	if (!sd_set_special_bvec(cmd, data_len))
 		return BLK_STS_RESOURCE;
 
 	cmd->cmd_len = 10;
@@ -1513,9 +1553,15 @@ static blk_status_t sd_init_command(struct scsi_cmnd *cmd)
 static void sd_uninit_command(struct scsi_cmnd *SCpnt)
 {
 	struct request *rq = scsi_cmd_to_rq(SCpnt);
+	struct scsi_device *sdp = SCpnt->device;
+	unsigned sector_size = sdp->sector_size;
 
-	if (rq->rq_flags & RQF_SPECIAL_PAYLOAD)
-		mempool_free(rq->special_vec.bv_page, sd_page_pool);
+	if (rq->rq_flags & RQF_SPECIAL_PAYLOAD) {
+		if (sector_size > PAGE_SIZE)
+			mempool_free(rq->special_vec.bv_page, sd_large_page_pool);
+		else
+			mempool_free(rq->special_vec.bv_page, sd_page_pool);
+	}
 }
 
 static bool sd_need_revalidate(struct gendisk *disk, struct scsi_disk *sdkp)
@@ -2912,10 +2958,7 @@ sd_read_capacity(struct scsi_disk *sdkp, struct queue_limits *lim,
 			  "Sector size 0 reported, assuming 512.\n");
 	}
 
-	if (sector_size != 512 &&
-	    sector_size != 1024 &&
-	    sector_size != 2048 &&
-	    sector_size != 4096) {
+	if (blk_validate_block_size(sector_size)) {
 		sd_printk(KERN_NOTICE, sdkp, "Unsupported sector size %d.\n",
 			  sector_size);
 		/*
@@ -4043,6 +4086,12 @@ static int sd_probe(struct scsi_device *sdp)
 	sdkp->max_medium_access_timeouts = SD_MAX_MEDIUM_TIMEOUTS;
 
 	sd_revalidate_disk(gd);
+	if (sdp->sector_size > PAGE_SIZE) {
+		if (sd_large_pool_create()) {
+			error = -ENOMEM;
+			goto out_free_index;
+		}
+	}
 
 	if (sdp->removable) {
 		gd->flags |= GENHD_FL_REMOVABLE;
@@ -4060,6 +4109,8 @@ static int sd_probe(struct scsi_device *sdp)
 	if (error) {
 		device_unregister(&sdkp->disk_dev);
 		put_disk(gd);
+		if (sdp->sector_size > PAGE_SIZE)
+			sd_large_pool_destroy();
 		goto out;
 	}
 
@@ -4212,6 +4263,9 @@ static void sd_remove(struct scsi_device *sdp)
 		sd_shutdown(sdp);
 
 	put_disk(sdkp->disk);
+
+	if (sdp->sector_size > PAGE_SIZE)
+		sd_large_pool_destroy();
 }
 
 static inline bool sd_do_start_stop(struct scsi_device *sdev, bool runtime)
@@ -4435,6 +4489,8 @@ static void __exit exit_sd(void)
 
 	scsi_unregister_driver(&sd_template);
 	mempool_destroy(sd_page_pool);
+	if (sd_large_page_pool)
+		mempool_destroy(sd_large_page_pool);
 
 	class_unregister(&sd_disk_class);
 
-- 
2.39.5

