Received: from mail-pj1-f100.google.com (mail-pj1-f100.google.com [209.85.216.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625E83749FF
	for <linux-scsi@vger.kernel.org>; Sat, 27 Jun 2026 05:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782538969; cv=none; b=DGE9feu2QLQqij7bHrwEFYdDpVNU7CEopNQShXlHs6LVNQ78j1TtYOpT+OfDmuVihEMw12dmxPV4rJcXpMAHzzViVHX+QjZWGoE9EbdqLau9/Z8NUYHPsUmb2x8UFUYZJFWiDlN16GnuBstxygOnmmtezMaLu80AXnciKLFRA1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782538969; c=relaxed/simple;
	bh=9h7ZEz78Y6ScMBC88C8RHAAfRQ3ckL8zd/zOxP8SyRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B3jJqrMp7evBgL157yn2TY/KPnORUgc4hd78U1Wmojz0V5rD/plcNLtoJyy307eAbgTyjlWdvGoik57XJH1LvZIFhbQEvmeSSQdUoZf1AMrnVxMYI2P2nb7cJPTjdmkm1T2GW1nGJRi6ZhUgAAEuH91Ctb61mLIp6EOg1A7QNpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=KHBEvlsj; arc=none smtp.client-ip=209.85.216.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="KHBEvlsj"
Received: by mail-pj1-f100.google.com with SMTP id 98e67ed59e1d1-37c9d82cd8bso130295a91.1
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 22:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1782538968; x=1783143768; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hJetzVCmipfxkIYaKGKmSSwqDl0tCRIuzU++fp89zak=;
        b=KHBEvlsj0AlvZ3tbCDrQwsZVc7TatkU9GOkSwpfGbO6ZlT7v47ERnBptLAwtNjVMkC
         FloXWLYQ5bZYXN4gT0GojAmmpnsCSj1JoagXyfDPT3NWx7yq5Yp+T7UARxJqe/PL5ZqK
         5cQEjxpvCo5ny9jhyMTfTGmLyUQwsgEeL7w8EYXIIYRt/FA0E2K1n46ZcqGqoqBJXZRI
         PebI0CRJQ0f7JXr7s2ZF9lUnsQkhhY+x2gmBaJ/HcQf0Z1CO54ldWHHxzeJs0SrQ5Ype
         LHXchCqaeS2w+gCrrYDXFmfDK+IeAjBKVUnJtPm0fJ3qD3LTgFSiEjIVJhYvJWDnAP/g
         esXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782538968; x=1783143768;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hJetzVCmipfxkIYaKGKmSSwqDl0tCRIuzU++fp89zak=;
        b=REyMvfERvwjwZRYnAtsyb/8H621UovwK800X/QfGvTaYqXoYMVs3spAdv0gxPwHXjR
         UZ1XsslY80nQXFRvDwpJnYFDo+OyscQGHq7DZnurrw0Dqqp5Y41syb2pwvjOQLg49aIF
         Kxt9wRflwpg1pEzDwSzIYhhltc/ds4OnUTykNMs/O5+mcYgbrdt+lWRKvHzyqFrTmQEh
         5ROWW3yysWc7GDHLsqzUiGjA7xVbL5ySr4d9tu7anMXNZ6Mb4ggPFV4uWiakq7q06nW2
         rhoVQ0ovZLj6YhwTxo+H5W+xiDqF+wJAJCYxGP5pdzvEP9/G06LJQmFVHXL//IuurJf3
         KS4w==
X-Forwarded-Encrypted: i=1; AHgh+RrdsvamvyAj/hbO6ghnXrJWB+4xK5CpxemDnI8lYm9GWWW8clxdPFDSwW7j7vPOf3SEk0XAiISKbssP@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4fthy+Z9jKEqUtRy9Ij32Wy77ako+YmfFjfiPPX6qJZI1q8MJ
	sLzJKTVY/GEKBqBG2O2QZsGtRjE23+cmcUo9a0D3eF4hq+BMsDxfbiIvCqoxW1Ofd/0l/wvOoXM
	nX5tO1/pdp5tFsy3gp/sUwE+tQegMyUK8L5jVfvHj4LhvsL4BzFae
X-Gm-Gg: AfdE7ck7rXwxskP2t3Wv66yGiJ2/5cTNlSWGioEgNkeXz9/5mBzmWskvsOHYRN24esq
	mhZK2N/Thutwj+mq2EdqRxi70izjROSSa6ZuzZyN9IxBJkZR5Au+33hiAkmHv7oWmdTZKMDTcny
	/pSjYqFAYZc9c58oHJKh4QEyDQuFaie8Visi9ZuYjBMvC31O+UcQ8yIvQIZrDyxgaUDursrlRFS
	dVSRu5+2FwG+Zg6WPzPGWgn96pPnNHndzWu102UsFhbtef3Y8Aq669Ds1hx8PVwNnF1rg4iwsD4
	c9qVELpxkRaL7OhHOkMOIc2bPFkUGRBQSLNkDj7VJUr+vgd0Zp7zM6sedSuriQp7PN+muxTiTfF
	5Jp8xAWaTA8x99eaZsjVJv/lV4SUP
X-Received: by 2002:a17:90b:53c3:b0:36b:9231:9718 with SMTP id 98e67ed59e1d1-37dfa2c9951mr5148619a91.6.1782538967568;
        Fri, 26 Jun 2026 22:42:47 -0700 (PDT)
Received: from c7-smtp-2026.dev.purestorage.com ([2620:125:9017:12:36:3:6:0])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-37df39562besm848289a91.1.2026.06.26.22.42.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 22:42:47 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.12.104])
	by c7-smtp-2026.dev.purestorage.com (Postfix) with ESMTP id E8FAD402B5;
	Fri, 26 Jun 2026 23:42:46 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id E6AE6E40712; Fri, 26 Jun 2026 23:42:46 -0600 (MDT)
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
Subject: [PATCH v4 4/5] t10-pi: use bio_integrity_intervals() helper
Date: Fri, 26 Jun 2026 23:42:19 -0600
Message-ID: <20260627054220.2174166-5-csander@purestorage.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260627054220.2174166-1-csander@purestorage.com>
References: <20260627054220.2174166-1-csander@purestorage.com>
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
2.54.0

