Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4BF10F1
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2025 02:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764641980; cv=none; b=KuaoOYdMZa0knuno/1kUljZdjO2zRnQxvGIxuArkydlfi28KnmSUCFr1DW0KYY8VzwPActIlzo7LREruXzGEj0gPlnSfWG6QsGrYJW4wSeqcIaSJCFLalcKHM/8Ah1mbQO/n/z52etK7eTKDPnps9/VP72N+ZzTlbGl0JznUDug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764641980; c=relaxed/simple;
	bh=b4E0Y/IhkdkV/mveWRS+oNb7kRAI3f5/RudsznDxzuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OhaAvLms5TpkQzuZ33+HUqQ2wlpZv6rb4CC7YOBjta1Jujrn1j38hxr6El1m9vMePSVRvbvgp79XpYp2Afw7pNWlzqEzKDLJqS1pk18M6+ly3/X7BHYSce9s5sr6wq7LxcQN3l8GWhnRl7hBCVQg8Jevm2ns2ghWFlgSpzEgokY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eZ6egw8Z; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eZ6egw8Z"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-297dd95ffe4so43366395ad.3
        for <linux-scsi@vger.kernel.org>; Mon, 01 Dec 2025 18:19:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764641976; x=1765246776; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ocO/7XfNa9pSLsCJ9FZ9opMjiT8rgXV0iXbJnUsLWB8=;
        b=eZ6egw8Zm+5Ter7PSXVNQn7mWEyT5BxPIbI8XQLJKzyRlVwR1hZ2GdY8yNrvJOCQZ6
         lZE2Cxmk5hmIRI8Bvf7QgUlWRKfT+oxIQTyHVqzuv25R3F/2KpOjD8gUIm2Z1Cep8oCe
         cYNNfKHZ28avEbvg2NAdMDSdpa4jOpSJz0RUFaOncxZ0DCuSG8UfKMOu5Y7Q4FsbgiZ+
         MuqitSG7kTn2Nmrb+ceMXf5u5r6TTAXcIgSGlstr85z6gdCIzJ7n1rRi6HSz+Y7edkGE
         vPu+QaRqYVDE+daeq8wGN2P6JU8JFypkrO38tZyxjrTwR0x8hIVo6Q5D4kEl0iApV1BC
         aRig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764641976; x=1765246776;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ocO/7XfNa9pSLsCJ9FZ9opMjiT8rgXV0iXbJnUsLWB8=;
        b=HXM3larNN4dxQfMDGaHwLNBgoV6pi0LWeYWN6D4SeMBPRD0m2K6rppoxfwUGeQ8hes
         z9Q1LUAs10Jf6X9EsEReNeS8FAHtN6kr2fBpMUTjrE+yi0XZaNDo85sRivQ9fjqCSXJg
         9Om0hc3/CmGk6xK3NXIQqaLwdK43zgBP9yg/lbhkMtt3Gf0XHStqIq47wEhTi0tTGMZs
         rq+TRAxXMDdmlTEsGkbUfiZZqx8RUCNJhky2n/tFgOyQvpqWMg1QqXT9yWgNWhmoUx18
         m9f4pbuHEP/MEZ99oIAwA3oB+chOwmbzuh/dNBF+oZeEQsGcVkvtYdw7+Qi7nXA+RBPS
         MN8w==
X-Forwarded-Encrypted: i=1; AJvYcCWl9VNlzwJY5iqlElyARn1mi3uDXTLVislaECKEQS7j+ItwEb6sfAN8tJpWcuRdBgXpeAgQWbSKdE0N@vger.kernel.org
X-Gm-Message-State: AOJu0YzZquAa37BjU3eWuHqAd+DeI+UDT1z6j7d4ks8fBBIMfOVeaJkT
	rswXvKh7n8zxPH5Ot7mZ7o35MTPkc1q1sf7ktf62QYRfNFvOKsWDZ6ab
X-Gm-Gg: ASbGncsOk5Mc4ZH6mStBjEIfs5ZMurzUbwy4l0y+KvYrHSdJEZCfC1Ek1W/Vc0aqLE0
	gRwUXJ19EHYCUEu0WGMoeQxH6LWiTMHU9m0zhORPI3WTtAtku3Rxt9zjPx52ALhpsQ6fZ3UOQwU
	wkZIIUdxa1JwMIjRSGkiGfvlPNhmhugvnsTgB9GOOtaDyEIauabaKwRMY0kxCMGnxPfb/0p6FJ0
	7TbNNH3ugOldvFeQV9DiYyhnuRkmSzTJqXHd18MyRCg7M5GYs++jSAV1HxKWHa83qIdEYHiYQnw
	BI/jKCSV2X3E1vQqyEISTeWRT9ZCzr+3rur5BH2Zw2Ukh2Ygav8FXFNBUlNYeJZOEnfYGm94Yn3
	otuXhF4ouugz9B3/Nu0bM/qFkvejWFBEP6KjV3A43CDt9oHnkLd8igTAeGv5LA5TuOseNien5LT
	L+752Klqa3sRb1Wq+PbaCk+yVC9R/jxlA=
X-Google-Smtp-Source: AGHT+IGkFCaVZ4N3mEb6qCj+KmRztcvmelJ3dJ4RpmAr/DNPhghBZKHnzBGq2FcUj+1pvqKbi3/f6g==
X-Received: by 2002:a05:7022:797:b0:11b:ceee:a46d with SMTP id a92af1059eb24-11cb3edd0fbmr17491665c88.15.1764641976403;
        Mon, 01 Dec 2025 18:19:36 -0800 (PST)
Received: from deb-101020-bm01.dtc.local ([149.97.161.244])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2a9655ceb04sm49089945eec.1.2025.12.01.18.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 18:19:36 -0800 (PST)
From: sw.prabhu6@gmail.com
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	mcgrof@kernel.org,
	kernel@pankajraghav.com,
	Swarna Prabhu <sw.prabhu6@gmail.com>,
	Swarna Prabhu <s.prabhu@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH 1/2] scsi: fix write_same16 and write_same10 for sector size > PAGE_SIZE
Date: Tue,  2 Dec 2025 02:15:22 +0000
Message-ID: <20251202021522.188419-3-sw.prabhu6@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251202021522.188419-1-sw.prabhu6@gmail.com>
References: <20251202021522.188419-1-sw.prabhu6@gmail.com>
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

Signed-off-by: Swarna Prabhu <s.prabhu@samsung.com>
Co-developed-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
Note: We are allocating pages of order aligned to 
BLK_MAX_BLOCK_SIZE for the mempool page allocator 
'sd_page_pool' all the time. This is because we only
know that a bigger sector size device is attached at 
sd_probe and it might be too late to reallocate mempool
with order > 0.

 drivers/scsi/sd.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0252d3f6bed1..c3502fcba1bb 100644
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
@@ -4368,7 +4377,7 @@ static int __init init_sd(void)
 	if (err)
 		goto err_out;
 
-	sd_page_pool = mempool_create_page_pool(SD_MEMPOOL_SIZE, 0);
+	sd_page_pool = mempool_create_page_pool(SD_MEMPOOL_SIZE, get_order(BLK_MAX_BLOCK_SIZE));
 	if (!sd_page_pool) {
 		printk(KERN_ERR "sd: can't init discard page pool\n");
 		err = -ENOMEM;
-- 
2.51.0

