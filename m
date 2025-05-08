Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82BA429A0;
	Thu,  8 May 2025 20:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746734504; cv=none; b=ZZVmUijFoI9Wi0pj1CT4a/N8oyAFhN9f6NkqIsWYwSk8c+odNVEvTBfpjp+EdtK+eXckEz8GxPF8ry7cd67SkeJYACK8hY0MGzmC0KiuMJMOGa1Ed8FSQkHBCJ7JBHdPsZhVqIiCP4yN0m/02xAcKr3P3RjlDd9qLiP8tgHr9FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746734504; c=relaxed/simple;
	bh=o1lVW46PXTWWdu/UpHD+IYP3tsrSGXwyJV65NS1S7k4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7HpfbWFcuFz1kO315TOQkOMT4om2w/HHjPDP5SymqQnzbwGnY+kTw3zf92RW2Bru/rftaHzV2vkAS/gXTwqrWucrme1ktvGEnf/PMKfsSbUs5HRwEBgtAl9IHeOcDcRw0f7fW9579RrJol06L1zU/nM3hYgwbpBgimdvEAH8OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gn+wy42R; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gn+wy42R"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7c55500d08cso148881185a.0;
        Thu, 08 May 2025 13:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746734501; x=1747339301; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kgM6c6LraGF3CFvj1Ab2yrgYuKDmDrIThr6mCkYZ2qc=;
        b=gn+wy42Rpo4BG03Myg51OhJ5/HjygooBG9rjt32Ovwe4W6FQU8iwsf1ZvT8u1wg64/
         mLLL/TVgjLPV6S5d1hWTrZQADle210b1i2YOfpcVGOch81kDq3I+/alMl+kKpQ4JqdA6
         EFSHRSVXRYo9/YNKZrqeV3/8NQ0Wzw/qfKrarOAILT7e3QP3lfvCgf3unTzYhdDknzUe
         thX1BFwYBtfai5bfmk8WuMKJP3J24+kNKd87N8IS4V+9m3xkYQMdYpHgYaz/1p7e7yck
         OQDnw01k7sMlPtmAJ6kooHY5bQsuA39l8/IUJ2WCVJBkZh7TowdUxTFbuZTJceNy2xfL
         69TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746734501; x=1747339301;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kgM6c6LraGF3CFvj1Ab2yrgYuKDmDrIThr6mCkYZ2qc=;
        b=suI9I5IRIN6dRJdwqJmjZxp+Ol/3RerF1yzeOv+U+AAcyn5SjSVkhHgbgdWL1C7ry9
         YW9XJccphayX7Rnbw8WvppGXEyjCfDG51QkubqkN6oJEiwhZ6Nf3xUpMrZttyjW8xLlF
         jv6I+EDaCZ1FMEfn8mDs9XjR2Q4xAaIIisDBhbFWwCob2xcdOiYn/M74YzB3FbZ46DDJ
         iP0yRWOejVrK8d9m6cFn0p1wtXuqp6AkpLLw6kcWzjiVlG0X/E+4M97f/dscA1K2KvZc
         2hu/SwffUmoJJinMkLreLVJ1m0/lEUppBByp5ARN5SUIUQcVWsv9UN5OL+4Pi4+98fIN
         Dtrw==
X-Forwarded-Encrypted: i=1; AJvYcCUpAGTZ2PBEqfpoAwX9ePhi4zXyUhZ9x2348BOnKIUJYW16NzRWnu/WnPcCkUb/wZ0SZU+loEKO93OZoQ==@vger.kernel.org, AJvYcCWeGZhBXT6Ukf/8K1RtVPDdO3sLcyG+EQVU6y6Zt+mNffFdEQtcxAZQ17+rEIGK7SWJoYLumn0I@vger.kernel.org, AJvYcCXD+Z7JMuJCy3yWgqCRERqqrLN64AgQk5hEYv/POodZTqCi6wmDFzrA74hrWtIbwmjpyy5XK+nrxVP7uel0@vger.kernel.org, AJvYcCXtYdu1CekUUzLmMikmaV3ldaL5idslavUYRdFlmw7W9bQLrxnPT+CB288zG1bWNKU9io91l7FtOOKahQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwZ0nqe6zDvF4jjAFxc0YHbaK8ViK3EQFXq/6BDIUG6gmrDQuKw
	BtPmKOXX2Y0m37u+AT4Z5JW2PUp4/p9BRvnO5jZYENKXMIyf/73Y
X-Gm-Gg: ASbGncuO5Vv0BvQfPr/HUUyGciR52O0EayEpVytNVupIBjXXKMlzswLfn3Vohrxe8Bu
	gEiPr8VbKtV2B2H771uwN4NzLpH3LWAUol8vTIFGoJr0DVqEfgjSqihLMlXZ9X364JEC7vlm3SN
	52dmUf4Eiy7uuVsbMsEYUBGSDf8s0YHN6pGu2X16esGdBnXnDMRpi9rZhyJCKvJCkSGD6OZPBx5
	rOzR/CXDKbAmm3/77cO9w+Hchh9QI/9Wx1DyrCf49n8eiDKZVUW7neyhuMIQPhPgGZpO9CIgdXL
	LW1e1zuynjJHV2o+rad6I21tEXWolBxVHImVeuTA5WwvyOT+ArypMqkwgqrPXbRcVmWcR4eBeiI
	nxw==
X-Google-Smtp-Source: AGHT+IFewyOueSH4VcN5bLw+ZFthO2Ya/CLXTWm+zH5sTHftdu9/7mh7k0vUBEcGTs6EWcx2G1Pofw==
X-Received: by 2002:a05:620a:2688:b0:7c5:4adb:782a with SMTP id af79cd13be357-7cd010eeaccmr145817085a.9.1746734501085;
        Thu, 08 May 2025 13:01:41 -0700 (PDT)
Received: from localhost.localdomain.com (sw.attotech.com. [208.69.85.34])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7cd00f637e3sm34235685a.31.2025.05.08.13.01.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 13:01:40 -0700 (PDT)
From: Steve Siwinski <stevensiwinski@gmail.com>
X-Google-Original-From: Steve Siwinski <ssiwinski@atto.com>
To: dlemoal@kernel.org
Cc: James.Bottomley@hansenpartnership.com,
	axboe@kernel.dk,
	bgrove@atto.com,
	hch@infradead.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	ssiwinski@atto.com,
	stevensiwinski@gmail.com,
	tdoedline@atto.com,
	stable@vger.kernel.org
Subject: [PATCH v3] block, scsi: sd_zbc: Respect bio vector limits for report zones buffer
Date: Thu,  8 May 2025 16:01:22 -0400
Message-ID: <20250508200122.243129-1-ssiwinski@atto.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <32a7f1ad-e28a-4494-9293-96237c4ed70b@kernel.org>
References: <32a7f1ad-e28a-4494-9293-96237c4ed70b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The report zones buffer size is currently limited by the HBA's
maximum segment count to ensure the buffer can be mapped. However,
the block layer further limits the number of iovec entries to
1024 when allocating a bio.

To avoid allocation of buffers too large to be mapped, further
restrict the maximum buffer size to BIO_MAX_INLINE_VECS.

Replace the UIO_MAXIOV symbolic name with the more contextually
appropriate BIO_MAX_INLINE_VECS.

Fixes: b091ac616846 ("sd_zbc: Fix report zones buffer allocation")
Cc: stable@vger.kernel.org
Signed-off-by: Steve Siwinski <ssiwinski@atto.com>
---
 block/bio.c           | 2 +-
 drivers/scsi/sd_zbc.c | 6 +++++-
 include/linux/bio.h   | 1 +
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 4e6c85a33d74..4be592d37fb6 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -611,7 +611,7 @@ struct bio *bio_kmalloc(unsigned short nr_vecs, gfp_t gfp_mask)
 {
 	struct bio *bio;
 
-	if (nr_vecs > UIO_MAXIOV)
+	if (nr_vecs > BIO_MAX_INLINE_VECS)
 		return NULL;
 	return kmalloc(struct_size(bio, bi_inline_vecs, nr_vecs), gfp_mask);
 }
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 7a447ff600d2..a8db66428f80 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -169,6 +169,7 @@ static void *sd_zbc_alloc_report_buffer(struct scsi_disk *sdkp,
 					unsigned int nr_zones, size_t *buflen)
 {
 	struct request_queue *q = sdkp->disk->queue;
+	unsigned int max_segments;
 	size_t bufsize;
 	void *buf;
 
@@ -180,12 +181,15 @@ static void *sd_zbc_alloc_report_buffer(struct scsi_disk *sdkp,
 	 * Furthermore, since the report zone command cannot be split, make
 	 * sure that the allocated buffer can always be mapped by limiting the
 	 * number of pages allocated to the HBA max segments limit.
+	 * Since max segments can be larger than the max inline bio vectors,
+	 * further limit the allocated buffer to BIO_MAX_INLINE_VECS.
 	 */
 	nr_zones = min(nr_zones, sdkp->zone_info.nr_zones);
 	bufsize = roundup((nr_zones + 1) * 64, SECTOR_SIZE);
 	bufsize = min_t(size_t, bufsize,
 			queue_max_hw_sectors(q) << SECTOR_SHIFT);
-	bufsize = min_t(size_t, bufsize, queue_max_segments(q) << PAGE_SHIFT);
+	max_segments = min(BIO_MAX_INLINE_VECS, queue_max_segments(q));
+	bufsize = min_t(size_t, bufsize, max_segments << PAGE_SHIFT);
 
 	while (bufsize >= SECTOR_SIZE) {
 		buf = kvzalloc(bufsize, GFP_KERNEL | __GFP_NORETRY);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index cafc7c215de8..b786ec5bcc81 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -11,6 +11,7 @@
 #include <linux/uio.h>
 
 #define BIO_MAX_VECS		256U
+#define BIO_MAX_INLINE_VECS	UIO_MAXIOV
 
 struct queue_limits;
 
-- 
2.43.5

