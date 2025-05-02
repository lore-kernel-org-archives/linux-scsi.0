Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12EF81A3174;
	Fri,  2 May 2025 19:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746214599; cv=none; b=eC8BcSkTRIov+sd6GxAkKot2/B+QyMnFguldR/tjRx5jPrdjqbctARobMzkmGAr3QymqzdTdu6kDzInm0Vab8jHYauAJvLnYrjL46jryp/LL2oU+DO8cbB0sKg2EXu6yIqrzrAAc8zu1JYLXzmz2d8Jjvb+0J0KyWdV5+pwJ4rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746214599; c=relaxed/simple;
	bh=fgGG7QrhOKoZpiUcmgMoK+3yVi0OST6qgUklpczJDy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GAtjoodSZJdLUPbZMVWU3/JNlyvRgg8QJOMmxXiA9s+ap4cxl7Q8HPBkFW4VYjaaZnN42ycf/QuVFy5d09gYA6SeryvQioNTJe4ieuN50/lYHMmr2KCiUuTQDFVOtutLnIcNyxNEHLhjAnph+pHNOcZg7bEyjBDEAyuIYeiIf2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a6PCVVho; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a6PCVVho"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4769b16d4fbso16604901cf.2;
        Fri, 02 May 2025 12:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746214597; x=1746819397; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=li9KWmA/pSaEUOrVMYX9FezW9V8Hws+6p3tdXCs68iY=;
        b=a6PCVVhoIQlf3ybSq7lp2xs8SXgH5KxF8QWmuAic8fxw2c0Tc+Zq83dUV/AIJ4aoYU
         eVe6g48Z0gkZnSLEqceqgJXIu9v/SaVj9l71tOHQu8JLPTWI1Yy9s299oRxSUmgeE9tE
         IvUIWpdr4hnlCZ4K2c/OwETGi59nCVdyIERCcVu6Aeh8hl6c8+nXx70nS1qHcnbuYYxo
         v2nAOKaHV6leCDr07WNebvvvo7uCrn/9D8DEXwOrZ1voV5u97t4oRgwLbaUYevcXTBNT
         LYR/k8CAD3dqPc7OVyN0Xk+E+wsK/SvDWDPxrsxgH5+kpOiq1zK1nfHA3IlVAET+McX+
         u4ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746214597; x=1746819397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=li9KWmA/pSaEUOrVMYX9FezW9V8Hws+6p3tdXCs68iY=;
        b=RxiUeBDiL1nr8NyUcRMe00uA5NPl6dr75Uluvg74Q3WLEzMZSgkOdphU1VvP0sPxPF
         da2yKaJORGGPUn48aCGqxt0VClSO2CBG7Y9A/4gyQ/Fhrzn+1GI993JAHwWjv78yDo91
         xuu3Oz0MXv6ohIdyim6Loonr3a1Ng4wppMpM2qpYIzvB+dHqKMelalHiAtSAF8xNjpb9
         SO5j5EpEcptUXZnMNytJFIRSo+cinBZFS7FUv+sQloTf/erz9aAGclepIPwXRGjTvYiH
         g3R13toPtTS1Gl8cYr+dPmnzYZiqu53G3zxYag3GFTHD24NsDVH/PB33Zjn1U9hJOjDh
         83kg==
X-Forwarded-Encrypted: i=1; AJvYcCVCTpkLPyZBY5idzwH5NSJRcoxce7lRYrukOyQy8Mp9R0yRh3AsGtKmauvs2e72XbcwiIY4zrhEUQCwvw==@vger.kernel.org, AJvYcCXb5eAxP6inUHR6OywWi0pg8WlK6kReAmS1kS+I6DEzLroMm5B3N0hx6wkQ0EdxQSAhCVcP8XKiS+kZdg==@vger.kernel.org, AJvYcCXdqjQL85N6YKn32c0ChlwMX/wKXEaydOFnvNnLpIaW4tdf/XGTmpcPO/+pPjU0XwaXZjY2m/zBgmqY/U3r@vger.kernel.org
X-Gm-Message-State: AOJu0YwBLuI+JlIUvnYnC40msOodfXzbyAIq2LSf0eyNXQv6jQNSbKn3
	HgJbiqtcc/BlWJ9edJWjVclu7ODlngY4ffV1O6Gda51W5zv/buiSobLpjv2Z
X-Gm-Gg: ASbGncs6vyDe/k5UGYhf2/eixF21wWdCU2NccCFzA/DZnV4AjJ0BsdaDf53uDZuJGm/
	GED+KTxJYGkIE2mjHnLMDBt5AEKizbWnWbGn8olIyWd+D58gew6Uh8phf2kzH24XmY7tghS6mQI
	QEZ9lZK3vTAHrZQAncqoFkhDs5D7+mZ6LDmZWKY+Ga+ZfrtJmSU+G9CieYqrzjnopM7jAWihJoX
	LxbgLzHwPuXhbJG7ZqCNz2/pKFMfOeiG9wHJZCFL/kw+IP+KlnnU7hwhzu78sSDYf58qtA30Ggo
	l5bHTT3lcUitTZGuwvbmSJKVaAlo+fOpbIbn+WqMFkQcl+8e23KwDhVUhrOnmXpZirU=
X-Google-Smtp-Source: AGHT+IH7LI2EE0zppHkYHV2lHFgz2fjtbkObPtUdGJG/+lgDSbfOuTtGVHcwGS06scKChD60MP9RHQ==
X-Received: by 2002:a05:622a:5819:b0:476:76bc:cfb8 with SMTP id d75a77b69052e-48c31a23f58mr68709061cf.31.1746214596785;
        Fri, 02 May 2025 12:36:36 -0700 (PDT)
Received: from localhost.localdomain.com (sw.attotech.com. [208.69.85.34])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-48b966cdafasm22424951cf.24.2025.05.02.12.36.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 May 2025 12:36:36 -0700 (PDT)
From: Steve Siwinski <stevensiwinski@gmail.com>
X-Google-Original-From: Steve Siwinski <ssiwinski@atto.com>
To: hch@infradead.org
Cc: James.Bottomley@hansenpartnership.com,
	bgrove@atto.com,
	dlemoal@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	ssiwinski@atto.com,
	stevensiwinski@gmail.com,
	axboe@kernel.dk,
	tdoedline@atto.com,
	linux-block@vger.kernel.org
Subject: [PATCH v2] block, scsi: sd_zbc: Respect bio vector limits for report zones buffer
Date: Fri,  2 May 2025 15:35:54 -0400
Message-ID: <20250502193554.113928-1-ssiwinski@atto.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <aBIucgM0vrlfE2f9@infradead.org>
References: <aBIucgM0vrlfE2f9@infradead.org>
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

Signed-off-by: Steve Siwinski <ssiwinski@atto.com>
---
 block/bio.c           | 2 +-
 drivers/scsi/sd_zbc.c | 3 +++
 include/linux/bio.h   | 2 ++
 3 files changed, 6 insertions(+), 1 deletion(-)

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
index 7a447ff600d2..a5364fdc2824 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -180,12 +180,15 @@ static void *sd_zbc_alloc_report_buffer(struct scsi_disk *sdkp,
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
 	bufsize = min_t(size_t, bufsize, queue_max_segments(q) << PAGE_SHIFT);
+	bufsize = min_t(size_t, bufsize, BIO_MAX_INLINE_VECS << PAGE_SHIFT);
 
 	while (bufsize >= SECTOR_SIZE) {
 		buf = kvzalloc(bufsize, GFP_KERNEL | __GFP_NORETRY);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index cafc7c215de8..7cf9506a6c36 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -11,6 +11,8 @@
 #include <linux/uio.h>
 
 #define BIO_MAX_VECS		256U
+/* BIO_MAX_INLINE_VECS must be at most the size of UIO_MAXIOV */
+#define BIO_MAX_INLINE_VECS	1024
 
 struct queue_limits;
 
-- 
2.43.5

