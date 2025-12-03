Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2222F066D
	for <linux-scsi@vger.kernel.org>; Wed,  3 Dec 2025 23:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764803289; cv=none; b=YJDKmtQOHq1VCqnpTDW7s3VHdsM1soJdlc/uh4w9NppcKdVB4rM7gCHwf1PqTenmIQnLnMvi7C0tKeHBKouUcNmDtVQ40kLFjUk18cl46llBtsFDKfODoI6Z/K+dCGrY9ORznOPUFqLRLnAXyM23Kl4IvYe94YO7dZbvyMuABng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764803289; c=relaxed/simple;
	bh=+y13kyCgKcU4mIA6aKesH+K3bXRbUpJ8qqjpntEdl0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p3SU4v5+ksgfUXnIc1B56ViMYvs6jKm3nvizQyIH00rIfunRz114wa7rQz8eicX8QVNBUEl1Gxucn/8m2bytwaSgl53FWFz5iAFI/zasWPipqHyUWf168nYr/1PuDAS5XrgJmabiJ0ko6KOOQcSCSYBqQnaLT7+wkeqnOrbDx4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g/f+bhRH; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g/f+bhRH"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-29568d93e87so3057755ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 03 Dec 2025 15:08:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764803285; x=1765408085; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=satMqEH63hR6HGe0HxbaPWkGQbdqYOv7CygjB3RHFcM=;
        b=g/f+bhRH1K/UoILnJ8y/1FR6jIuVM+bFAIl9TUuJU0JGQlvzpasemdnpIFxnexKhhY
         H0Dh7Y3mpM4Kwb35hIUJ6MYzaCqBaYs3U6XLA+Y9DVw6+NIf4BPvxTfNd/iYf5Nk5gZi
         5U1yKHCTs1hF5NHfn+dPlknlb+x6uIeH+LvT/BkSTwaN1E4haCXYtl8ufQCepAZTDyIy
         aYnmuaTTSv0vAQQLwnw3SsDkqkY8fwQ8qwrglJ046+18DsUO58KaHAEdCvTBCpli0l8V
         siVmkZAxYCAbl02/Zr509y2Zy56YYwq08ePeIwKRpa0MBPNSs0oWwVTZ4KfBHx8RgliD
         Yvxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764803285; x=1765408085;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=satMqEH63hR6HGe0HxbaPWkGQbdqYOv7CygjB3RHFcM=;
        b=ZCmWRowCvgtmc045eNArcdQ9v/oWG6XYPhfr+hmRKgq8REDs356iFPYENS93rtDkdh
         fRfUfXBFyOYl/XnKQOIPMzJb8l1TAct/gSCCXpwoB6f0dzrr+5XHxL+VSdkYqV7eTeuR
         2HE0LHt68lKRbrZ6OgI1Y7cRy2CN9wQv8C0SBEU2EIl+j5PPafk+GE6Jq5QWIfBt6kFe
         MrJJnvrJalahgdHcQR3uiBVdTJZTATg2JKPPcvT9wZNEKMztSqQnWRPItnbUFQdPJ45Y
         6iSHg4Nny3EllKjTJ38RsgEjcijAurAEBnCnvP+LaWIsszCrY4G5/reoPyOjxK4UMkoU
         0yqw==
X-Forwarded-Encrypted: i=1; AJvYcCU0KYRF6cE63KHCoWwlIKYUDbJmIbZlVcwJ4V+9wdA2cqOvh9WQHnSna1LTKsBvwCeQ1cakEKIVW94x@vger.kernel.org
X-Gm-Message-State: AOJu0YwHSCCM4TTjZFvwP3hB2ame2fAFZtA8fGKzbNHbZWx0KtVOsKpa
	5knbvDfK/mxASzgGFm0h8Qw8y+GoWyAsye/UB7Upq8HmDkqB8CDelN75
X-Gm-Gg: ASbGncuNiEz9fWF1V3+Zp5GmNAi/m25CYpmYHZCL/7ByIfC4tTQWGZPxAfK7phfxYpO
	tX6CERn9Pccacj49wcN4bmC9vAmUXk1doGhhZx2q80ozTOVsusIRtLL+XcoP0xreZnqKozjG5DN
	hUcecRnUOPXV1hxI4fQIhbe7acu54qZERNFvCNM90PAE/xQXPtwi/2JhpRcNKlFWvosCDwLTWaJ
	6yIT5moO7ZJLitKeZXr9JBO0+HvYrNRd7XID5PL2dPnkc30UGb3d9JnVU9BtEonzdAzvktqvDI3
	K3JRIkkkVRG677Cn5IM8vdCWQlsNlVUZbn9/436WWZOzpL45SAYd8ZzRedVkoZ1bCgWAhrAIlhi
	a4wr9T7dIAJNrTsLkR+LBslO6/dxd6bRVwH5XimzPgIEccmz+Mg+u9gala2afBuV8mFDCwMNFyW
	yB1uODUBAB0NJADouO7lr/sf0yu8CMMG8=
X-Google-Smtp-Source: AGHT+IEe507y0kyTp9Rf719dFNfNCButUblrrqy0/Xxykz0xB7Bug9PT/70WsGwngXo3BKgpPwSC/g==
X-Received: by 2002:a05:7022:11d:b0:11b:8b4b:bff7 with SMTP id a92af1059eb24-11df649de19mr840235c88.39.1764803285338;
        Wed, 03 Dec 2025 15:08:05 -0800 (PST)
Received: from deb-101020-bm01.dtc.local ([149.97.161.244])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcb049cdesm91535333c88.8.2025.12.03.15.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 15:08:05 -0800 (PST)
From: sw.prabhu6@gmail.com
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	bvanassche@acm.org
Cc: linux-kernel@vger.kernel.org,
	mcgrof@kernel.org,
	kernel@pankajraghav.com,
	Swarna Prabhu <sw.prabhu6@gmail.com>,
	Swarna Prabhu <s.prabhu@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [RFC v2 1/2] scsi: sd: fix write_same16 and write_same10 for sector size > PAGE_SIZE
Date: Wed,  3 Dec 2025 23:05:46 +0000
Message-ID: <20251203230546.1275683-2-sw.prabhu6@gmail.com>
X-Mailer: git-send-email 2.51.0
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

Signed-off-by: Swarna Prabhu <s.prabhu@samsung.com>
Co-developed-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
Note: We are allocating pages of order aligned to 
BLK_MAX_BLOCK_SIZE for the mempool page allocator
'sd_page_pool' all the time. This is because we only
know that a bigger sector device is attached at sd_probe
and it might be too late to re allocate mempool with 
order > 0. 
 
drivers/scsi/sd.c | 19 +++++++++++++------
1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0252d3f6bed1..f2eac79d7263 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -895,11 +895,20 @@ static void sd_config_discard(struct scsi_disk *sdkp, struct queue_limits *lim,
 static void *sd_set_special_bvec(struct request *rq, unsigned int data_len)
 {
 	struct page *page;
+	struct scsi_device *sdp = scsi_disk(rq->q->disk)->device;
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
@@ -2880,10 +2889,8 @@ sd_read_capacity(struct scsi_disk *sdkp, struct queue_limits *lim,
 			  "assuming 512.\n");
 	}
 
-	if (sector_size != 512 &&
-	    sector_size != 1024 &&
-	    sector_size != 2048 &&
-	    sector_size != 4096) {
+	if (sector_size < 512 || sector_size > BLK_MAX_BLOCK_SIZE ||
+	    !is_power_of_2(sector_size)) {
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

