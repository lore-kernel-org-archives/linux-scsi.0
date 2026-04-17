Received: from mail-pl1-f226.google.com (mail-pl1-f226.google.com [209.85.214.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098022C11E3
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 01:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776391070; cv=none; b=jNifI4ay7Nw6ZlwVMHQhdrlsMbrmva90UWWalcPOUeOk5nAer+qOwWjuCVkfm6nrYmSzVTBSJQXehWGgEcg4Q4ZPcI0TLy0TnJcXaXep4viZ+1wadJfqiU14zWAjiyFaqYmTho44Nk7Qr1oOF8RQOSj7d6Gas2VZoa23nJNXv2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776391070; c=relaxed/simple;
	bh=D1sF5rCpyJ8v1Q/Gw4hLl9PjXnZwN2O7sQ73iHxyGO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nllQq041UJAIGFVbBQzEzSWKkVgccGga92ugq7kKEGqYlblJ+NBpsmUmcJPFxM9Co/89pIFpcMMD5PZF7goNNodNC5J2AeBr9km3kQ4d/E1aRm1RV3dalb/5zv6OqnO92k1Dnc+iAaQ9hjw5zz4aB1rO/s9kPPEUJ5gcumSmT14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=AFvkSnDU; arc=none smtp.client-ip=209.85.214.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="AFvkSnDU"
Received: by mail-pl1-f226.google.com with SMTP id d9443c01a7336-2b240d753ceso416885ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2026 18:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1776391062; x=1776995862; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ePLDDsMaoT6WX22t4kx7uDAhAvj4BaoTe7M9oy5w3tM=;
        b=AFvkSnDUcK3u1Z91caVhRRC7hPOoHYN5oMUDYLNsn1oapZb2taaVA74MEYy3uy1u2s
         mkA0uFhcwjmNZrN3CJKgLYa05x/RXD/8mvlp48UXaYdGnqNz0HFZs9tH+R9cPrVtmJVi
         R7rwtpxbDoq6HX6DHaNz9/yAOVUvy0r+fLX4LUhYB261yQc5rOV0aswngv945idzpHoN
         5/7DAN5v+81jzxH4wFidWM3vpGVwB2oLYb1BAHkdlTq0yE8PUfJdWcEHQXeweCtbbMrj
         ya+0cEmczxyk9+BV3fWb13UX03yrFNTzRv6/4ixTBeNXVmYkwJBfW/8hQ/y9FxVzd8Rf
         q5Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776391062; x=1776995862;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ePLDDsMaoT6WX22t4kx7uDAhAvj4BaoTe7M9oy5w3tM=;
        b=ivKncsQlmAwXBQfod1jUxk2SXWVZwJCmeXdIXDi+viTrY5pFKJsZ0aNSLfZt5y6v9F
         VFxweNvJ3iLZYcWBnR05RORq4A3WeUew9YrQ1rw/sbTpkssNtY58cnXfFmKMUg3HCYoS
         BBG83kWF//wyQnMuMM7oIfpuRcqamtkhKv94UNx4ykPVFWLwHr6jNJpkq3NHx9qnTqYL
         Q6el/eFuCs+xowD26kZxfi7Qu99MLogrXK3oDVM9UwDEifpv4PiL/7S9jEEuHxiWyU31
         8mODSOjpc6m4O/zoqxTrHkPjh1YeQCbQwDT3H/n27ztGf3ZnSW3zo3W9SKs/NerxE+5h
         RrVw==
X-Forwarded-Encrypted: i=1; AFNElJ+kjGyMzo+6LltyIhD/knTK6C7Pvi9FOAKNpQ6NEIw5cGAA8AuXttgzSm3aWMgUNilZUOAcn2jhG6hA@vger.kernel.org
X-Gm-Message-State: AOJu0YxInvhe66y64IqqJSDIchd6OWgl+x9/WOLXbfXoOcE3jE1bgFmN
	hlq2MRcmshuHDCcWTf3r5utGhTdLAtphtN00PSW0Bz/ZGlMA2lhKrc74INoN75Fl7IAGi7CBue3
	Zf2dKpfFCXUrK2o6X596Aw0+4Yk5gDAOsnVLt
X-Gm-Gg: AeBDiesoWDSoB7fO7npiTJltSmJyYUOmasSKLyh9qwt5wJuy0v+Wg+i4Qf+JmTvo2Cn
	/5LWPLRs1Zt4j/6dqyCkiDPbUSlY04xKDJTPWwShg2CIvk9qeyTM3ABNjjVmwgm+Hp1ctTPmHq/
	nRMOZqQqUyebkeyQLQH2Fw3zmLgWjJsYa0aLFW51avoPqbpG9lGUXbx7qY+Sz/+qY8Qa9ub+H8p
	bQzT7H8fZLuVyK/fdIozPVZYsSK8xEKfZfzQDRXFcUERIjkF1xVs1kIM4XJrqcRQ1J29xLdc6s0
	g2d+zlGtMshiMk0/ZST0NUDMdsezElTngNl78JeOW0/IL6Z+owZRcy+ipzOznX7cTwjafgAM9Mm
	sC8OM4cyz3PlgpN1RHWcIShM6uQXcVtQ0vYfvhBViUqqwsuIgHafi+zF8HGDKzw2z
X-Received: by 2002:a17:902:b68f:b0:2b2:48a5:45c3 with SMTP id d9443c01a7336-2b5f9eceb6amr2890535ad.1.1776391062085;
        Thu, 16 Apr 2026 18:57:42 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2b5faa0fa70sm233095ad.14.2026.04.16.18.57.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 18:57:42 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 658EC3406AA;
	Thu, 16 Apr 2026 19:57:41 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 60208E406BE; Thu, 16 Apr 2026 19:57:40 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Anuj Gupta <anuj20.g@samsung.com>,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v3 5/6] t10-pi: use bio_integrity_intervals() helper
Date: Thu, 16 Apr 2026 19:57:31 -0600
Message-ID: <20260417015732.2692434-6-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260417015732.2692434-1-csander@purestorage.com>
References: <20260417015732.2692434-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use bio_integrity_intervals() to convert blk_rq_pos(rq) to integrity
intervals to reduce code duplication.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/t10-pi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/t10-pi.c b/block/t10-pi.c
index e58d5eb6cefb..787950dec50a 100644
--- a/block/t10-pi.c
+++ b/block/t10-pi.c
@@ -541,11 +541,11 @@ static void __blk_reftag_remap(struct bio *bio, struct blk_integrity *bi,
 
 static void blk_integrity_remap(struct request *rq, unsigned int nr_bytes,
 				bool prep)
 {
 	struct blk_integrity *bi = &rq->q->limits.integrity;
-	u64 ref = blk_rq_pos(rq) >> (bi->interval_exp - SECTOR_SHIFT);
+	u64 ref = bio_integrity_intervals(bi, blk_rq_pos(rq));
 	unsigned intervals = nr_bytes >> bi->interval_exp;
 	struct bio *bio;
 
 	if (!(bi->flags & BLK_INTEGRITY_REF_TAG))
 		return;
-- 
2.45.2

