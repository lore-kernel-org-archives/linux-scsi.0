Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D09A27B32B
	for <linux-scsi@vger.kernel.org>; Sat, 14 Feb 2026 01:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031971; cv=none; b=oQ44Wyk0siVH6Z0zlhNbYw2yjdbnlmQBNZSlou95mW2XRqQHeaAf5WV3FlBI29KsrX+I7vLpyWXGT4gSD+yW6OsRpRcZfFbTbm8oBcOENYbj3B+QgkYHaLnHAPEpD0APOxsuypae3BJyrrWfRAcQUGlOe9bUWxTFqUdF5xYRjDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031971; c=relaxed/simple;
	bh=pxsUPV3X+1Lx97Sg7gCRq669oEOJQ1slTn/9AXcycEo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Syv1GkQSHQqdpj/Bel+qoO7HZbSdh+JL1lKg172xVc/aF0HfN6oV2rmwUW8ViJNzFHNJi7ild36vT+DmsNHq2QCTEqF5I0qcCwYC3+qEcFdpZNAv2TS/1WmIgrrNeFUeN3EMT3fqziZeRCKsDjc8o4mXNRcGBPjLr6jWkY4jKTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YbpPtxbK; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YbpPtxbK"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-797a52d8c34so10155417b3.2
        for <linux-scsi@vger.kernel.org>; Fri, 13 Feb 2026 17:19:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771031969; x=1771636769; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jHjZcdDVe5lgkEsrlgfB21xqxgW4tVK8CvZ+GE1VuYM=;
        b=YbpPtxbKDQdQNrvjzB5LurHvGi1LA0TPrA6qJ4lcIBFBSWJuKjlX5rham8HsNy2VLi
         5AbccYgcEHgmIZTyySW+rkbSQE8BvWP7ZpOBoqeYYUk3eeb92QRlYSAJgFIkiSikxWxF
         xrcWVDCbSlTLfWWVhZy1q2O59XIweDox+Yt7SUdldhzkySqGsOxdPGc/ZIvXFtjUAoi0
         8Lp8eAeaPIF395j2LTr1OVH89WplIBukIKHbJP56rqP81X/bBFAnE8yp3z3aHVm75MUC
         PO2315DMre9lr2AqzXfz9XFlAf9T8vURPJCVT2vdgJcLZx+gxr9a4rBmRwN3A/5OilDV
         20Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771031969; x=1771636769;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jHjZcdDVe5lgkEsrlgfB21xqxgW4tVK8CvZ+GE1VuYM=;
        b=FkWJ34G9wSYWEe9aZ5jHJR6J3/EVchJ6ZVUnzYd+2OhwyofYgg+JGB7c0Z1cw2GS0j
         k2BzXbrkweHAkMx4KkLt2pEe8AxgQqQKjTOf4X4X4aEIV9DE2FF4i9R4Xus5I27zqPJ3
         eNLbh5JbXdfPDqDba8bZycLdv1347geer2tanDU6FuACLYDBnUbildIKk25Y8SlWJRib
         mUK8O/HrfAK+vShJkT0sqhC5S41SVYdHFc0aJWrTsom+/723YbCxIuZsZLWpBHF8OCbg
         XJGyYeXSXZaPybBhaKTayUlZREgB/w7euMRaIlBZpYzG/gUv/3h5Uh1jHF4MiG2WYBkv
         2meA==
X-Forwarded-Encrypted: i=1; AJvYcCVW+Sn+6dJYDHHiYdbJscONVEsvPUkcZNxdenm6m5UfKwgM0bwV0K90yWCcQDZfpuPWMcO35Vws6e7G@vger.kernel.org
X-Gm-Message-State: AOJu0YxAsxXmdq1dSg6KfF6LFs0cTFwCn/ZvApXeyu1iNiXFedDHLluM
	vHHNp5m/ai0F1Hf8zfOrp2hHZfHQ+/ojAEgmD83yhynz17OBs7j2xzAz
X-Gm-Gg: AZuq6aK8sTNgcgb9Uz3p3aEaqvrx97kPbUm3Tw7I54iUsMlT3QZq++LU44HbS+5FaJi
	GPQSXzzUoLFq9kMZYy8+oco7HcpLxaz7q4szersQbrwzrhUlfHbONypjR57beNbqArTBRgJXfGU
	D7ZqpwRLW1ErpaWarQqBpQcPT59B4DG9VZ0Y/wF2ogKZYbdRJpAmStAJktTHEKXR1vDuqdlPp3y
	Nj7mceROKA5Xp+7KgeoBRAB0ue9/UG4/A4m2ONcGz5LXqYWjibprHjQcgBGUYWNimHC9jvgV6Rk
	ftFBf8pHSbPNN7lumqWuqSsMcP1jK5UozwT2x4FvyCCQPWL4usm9YvQ0xVPY2XX36KbKFmFD8ug
	NX8uE3gv1Uo37rJxsWnCw5cBcCW+1Mdp1Y8b3LfdP5yeuVpiTJ7OxiHYzMs4cPSVATaexc2nkp7
	VUyZXLUYLDZAJZ/vWw+tjpA54ZRNMWEZRjt0R7AtfIdp/9JwI=
X-Received: by 2002:a05:690c:ec5:b0:796:4f04:bbc3 with SMTP id 00721157ae682-797a0cb9269mr33087647b3.35.1771031969513;
        Fri, 13 Feb 2026 17:19:29 -0800 (PST)
Received: from 5163NRD-SPRABHU.ssi.samsung.com ([50.205.20.42])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7966c177773sm77655057b3.2.2026.02.13.17.19.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Feb 2026 17:19:28 -0800 (PST)
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
Subject: [PATCH v3 1/2] scsi: sd: enable sector size > PAGE_SIZE in scsi sd driver
Date: Fri, 13 Feb 2026 17:18:29 -0800
Message-Id: <20260214011829.508272-2-sw.prabhu6@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260214011829.508272-1-sw.prabhu6@gmail.com>
References: <20260214011829.508272-1-sw.prabhu6@gmail.com>
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

Signed-off-by: Swarna Prabhu <s.prabhu@samsung.com>
Co-developed-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/scsi/sd.c | 80 ++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 68 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d76996d6cbc9..ae6ccfed79b9 100644
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
 
+static int sd_large_pool_create_lock(void)
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
+static void sd_large_pool_destroy_lock(void)
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
+		if (sd_large_pool_create_lock()) {
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
+			sd_large_pool_destroy_lock();
 		goto out;
 	}
 
@@ -4212,6 +4263,9 @@ static void sd_remove(struct scsi_device *sdp)
 		sd_shutdown(sdp);
 
 	put_disk(sdkp->disk);
+
+	if (sdp->sector_size > PAGE_SIZE)
+		sd_large_pool_destroy_lock();
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

