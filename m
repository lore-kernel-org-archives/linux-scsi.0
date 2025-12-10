Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7EB24291B
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 01:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765331095; cv=none; b=jITjScTl0DOw/uAN8moDjVDwFfkFZGVfwhhCGJ3aLA5u2H2iWLOzRD/ZcksP91XoHfv/TkGrWEA6P1GNbQMx23Rc0IfZqCh9l2OQjXM2/TrotFXi+iuJIKMQ0cCT2PmXihnWLSirrQXb8WtEp8VUX17hYQjxH7c4OPPlCkE8efs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765331095; c=relaxed/simple;
	bh=monXj7+R4cpXUJkrbIONb5M7vohrDue1L1wHC5K6XC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujQIvng9/1bkWhSDGi+TU7I1C+WylUfrBOGDhRZxk7rTrCHmHttl98evd4pSCNLnKKn+sHGm7ujWKHgCqD7Yi3PM0/K6yMPwf+O93GjgdlK98nBzP2euHJJ3kMmHopvjzfjSfv2nnR8mbkb34EYIa5FDV5ot2KmdQ/Je8mhGif8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cNtXbt/w; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cNtXbt/w"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-34a4078f669so1932376a91.1
        for <linux-scsi@vger.kernel.org>; Tue, 09 Dec 2025 17:44:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765331093; x=1765935893; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=keA9F3YxBh09o9pCPWxgnr568IGr525xE5zudb3+saA=;
        b=cNtXbt/wWsL6aALrH54eYTGFPpdd8phcG3lmKumZ8ur/3+nEm260LsFo3ipKsrxSsS
         4Y9dhKOTuaizLVgbTsBvZcEWifp2s6WBjtiC04OkYL2sf5S4JYUPU7P4QNHis3jb3dwc
         MijUQ828tn1J6lL/KVloH8HoDkvvzuePJomwUKk/4JrBPZFPAZCB0IURuPDByuqW9GFB
         0aFRhFRuVqjrFzU2uyUEuCSd87Z60mChKYvWkD3Xm92Mqx9Hne8WEpsca2MUT1gzXVKi
         9X1yzLRblmu3cYpKdWszY/+eana7/AZREWU6Y6JOV9WhLlFkJKXoPnMXpSGAs/GFsbIq
         +8IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765331093; x=1765935893;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=keA9F3YxBh09o9pCPWxgnr568IGr525xE5zudb3+saA=;
        b=AVf7QITkaNjX+Yj4apuXJS3hguYlNmmOnq3Ir7GF+i/R7VXuTs0bs+c2DFQ8fWMtkh
         DBHemexHiXabo8X9yW9PmMM7uMMIHVkN/Skgrgr3+g0NQG8FEp97hjqfjiE2AYIL695X
         4hSBxOxegmEF17xJzBXcDs65da++M4UOi5oI6kN8R2fD66lZRUQLR+Ivl+mwFZ5vI1B+
         vDExyMdzP87TtNg/8XtG5Hj930lOO+toi9V5SC8oEQtPhGfr5ae0pisJqvX637uaFwwR
         kmVhe6akaTdYwSfjRkDItoDNjHS+zNCE86/0WJthpF4cOPpe1RMYXpICUYvOG/LFc688
         WgPQ==
X-Forwarded-Encrypted: i=1; AJvYcCUwU7gl+AwD9BbVY/RU0T4k4DU7XsiB2yFHgNy9p2f3uLbCGJsRaUx5D6zftroxGmSW5L0vodyweRbe@vger.kernel.org
X-Gm-Message-State: AOJu0YxAf4ThiR0CM0RjDpcW8nWayh1kgQalNcZoeYsHVZz9SP27yjda
	V00ZwBPXTlBSpgZNKWJFTaPyHWRZ81YNpshXB9UJBJk9jj9uZlAt2VrE
X-Gm-Gg: ASbGnctJoT1DIKDO/+QhIwTU/6T6W92FAqHUo4UtzJsKNUyJbTEwd6pNeGjlMN4Q0jS
	dsHJIfV3VihDuNrlKeU2jLStQFq3LctPMSqQeKxF3sgB4rByKjA8hdRIKxW/Rsv1qVDnuX0FCLN
	GlTPx45BCWjBSR1TeTjKWdg12Ncg4WmOAAET6nLXpzKb/5ApPJqnjn9+xiR8M2MKjbm8FPX0VGv
	FbDdE7oANWNEvtWNS/0TXMpuqS1zlcOYDY0EsUUlob2t9x/WXa7NzygiuYzCuVp8A2cuhNYEW0m
	e2LaDeAApxdzW1zCyvEkubAdvxwuptmmsIqXLMC68f4eSp7+NrbbL5aZ7XA8d2yEYydBx5iijPC
	VymeOyIePxo/mZIHvmAn1RGui43Rxtc9DcWspcFLjXk0lK600ce1ptk2OB/+kTqZkTu4D7tweBU
	ZskkNuxQrwkxfM1hjSg+BJgUihwelU1eY=
X-Google-Smtp-Source: AGHT+IFei0SQ90u6Oo5qESgNgaX/ZB5xweXsWOOgXwPrIkFrPplRPh3HKFMlJlzkz4fQ2pW/0i3uYw==
X-Received: by 2002:a05:7022:2384:b0:11b:b882:3ed5 with SMTP id a92af1059eb24-11f296d812bmr624718c88.37.1765331093388;
        Tue, 09 Dec 2025 17:44:53 -0800 (PST)
Received: from deb-101020-bm01.dtc.local ([149.97.161.244])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2eefsm80274777c88.6.2025.12.09.17.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 17:44:53 -0800 (PST)
From: sw.prabhu6@gmail.com
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org
Cc: bvanassche@acm.org,
	linux-kernel@vger.kernel.org,
	mcgrof@kernel.org,
	kernel@pankajraghav.com,
	dlemoal@kernel.org,
	Swarna Prabhu <sw.prabhu6@gmail.com>,
	stable@vger.kernel.org,
	Swarna Prabhu <s.prabhu@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH 1/2] scsi: sd: fix write_same(16/10) to enable sector size > PAGE_SIZE
Date: Wed, 10 Dec 2025 01:41:36 +0000
Message-ID: <20251210014136.2549405-3-sw.prabhu6@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251210014136.2549405-1-sw.prabhu6@gmail.com>
References: <20251210014136.2549405-1-sw.prabhu6@gmail.com>
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
64K ie beyond PAGE_SIZE, adapt sd_set_special_bvec()
to accommodate that.

With the above fix, enable sector sizes > PAGE_SIZE in
scsi sd driver.

Cc: stable@vger.kernel.org
Signed-off-by: Swarna Prabhu <s.prabhu@samsung.com>
Co-developed-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
Note: We are allocating pages of order aligned to 
BLK_MAX_BLOCK_SIZE for the mempool page allocator
'sd_page_pool' all the time. This is because we only
know that a bigger sector size device is attached at
sd_probe and it might be too late to reallocate mempool
with order >0.

 drivers/scsi/sd.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0252d3f6bed1..17b5c1589eb2 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -892,14 +892,24 @@ static void sd_config_discard(struct scsi_disk *sdkp, struct queue_limits *lim,
 		(logical_block_size >> SECTOR_SHIFT);
 }
 
-static void *sd_set_special_bvec(struct request *rq, unsigned int data_len)
+static void *sd_set_special_bvec(struct scsi_cmnd *cmd, unsigned int data_len)
 {
 	struct page *page;
+	struct request *rq = scsi_cmd_to_rq(cmd);
+	struct scsi_device *sdp = cmd->device;
+	unsigned sector_size = sdp->sector_size;
+	unsigned int nr_pages = DIV_ROUND_UP(sector_size, PAGE_SIZE);
+	int n = 0;
 
 	page = mempool_alloc(sd_page_pool, GFP_ATOMIC);
 	if (!page)
 		return NULL;
-	clear_highpage(page);
+
+	do {
+		clear_highpage(page + n);
+		n++;
+	} while (n < nr_pages);
+
 	bvec_set_page(&rq->special_vec, page, data_len, 0);
 	rq->rq_flags |= RQF_SPECIAL_PAYLOAD;
 	return bvec_virt(&rq->special_vec);
@@ -915,7 +925,7 @@ static blk_status_t sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
 	unsigned int data_len = 24;
 	char *buf;
 
-	buf = sd_set_special_bvec(rq, data_len);
+	buf = sd_set_special_bvec(cmd, data_len);
 	if (!buf)
 		return BLK_STS_RESOURCE;
 
@@ -1004,7 +1014,7 @@ static blk_status_t sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd,
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
 	u32 data_len = sdp->sector_size;
 
-	if (!sd_set_special_bvec(rq, data_len))
+	if (!sd_set_special_bvec(cmd, data_len))
 		return BLK_STS_RESOURCE;
 
 	cmd->cmd_len = 16;
@@ -1031,7 +1041,7 @@ static blk_status_t sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd,
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
 	u32 data_len = sdp->sector_size;
 
-	if (!sd_set_special_bvec(rq, data_len))
+	if (!sd_set_special_bvec(cmd, data_len))
 		return BLK_STS_RESOURCE;
 
 	cmd->cmd_len = 10;
@@ -2880,10 +2890,7 @@ sd_read_capacity(struct scsi_disk *sdkp, struct queue_limits *lim,
 			  "assuming 512.\n");
 	}
 
-	if (sector_size != 512 &&
-	    sector_size != 1024 &&
-	    sector_size != 2048 &&
-	    sector_size != 4096) {
+	if (blk_validate_block_size(sector_size)) {
 		sd_printk(KERN_NOTICE, sdkp, "Unsupported sector size %d.\n",
 			  sector_size);
 		/*
@@ -4368,7 +4375,7 @@ static int __init init_sd(void)
 	if (err)
 		goto err_out;
 
-	sd_page_pool = mempool_create_page_pool(SD_MEMPOOL_SIZE, 0);
+	sd_page_pool = mempool_create_page_pool(SD_MEMPOOL_SIZE, get_order(BLK_MAX_BLOCK_SIZE));
 	if (!sd_page_pool) {
 		printk(KERN_ERR "sd: can't init discard page pool\n");
 		err = -ENOMEM;
-- 
2.51.0

