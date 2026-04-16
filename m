Received: from mail-dl1-f98.google.com (mail-dl1-f98.google.com [74.125.82.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490641B4138
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2026 00:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776298972; cv=none; b=i8s/cWtTDw5FPRi/myqFcHA4I74NsUJBhoptwuvxfc6CwDzJRe2YsG9r87iOgxFe5GqAsVdC0EfncbhwyHevbWtTOQrvPO1jMXlOdPhZJQhCMcWjCPQpXx47NzV5T7PT3UPuxO1EQeJHYzNtYuL1fHSqZL38e8KfZjUiW/QwX0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776298972; c=relaxed/simple;
	bh=D1sF5rCpyJ8v1Q/Gw4hLl9PjXnZwN2O7sQ73iHxyGO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4z9Cgc+20VzfE6QiAGPokW7/k2Prgwh06aIyIG98HkaH998q18n1MFdRFx2pH2U+xxzf70enY6Uf6P1Qub615XTzeygerAzFcUbvZ+GNLFfOp/t/2pbUkCSYwMinLOyEsYI4t07ilVsQRCLzlnYIlheKgG+8AvxKbQ5/Xk7mE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Z4gt3sjs; arc=none smtp.client-ip=74.125.82.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Z4gt3sjs"
Received: by mail-dl1-f98.google.com with SMTP id a92af1059eb24-124a7216c9cso471305c88.0
        for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2026 17:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1776298968; x=1776903768; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ePLDDsMaoT6WX22t4kx7uDAhAvj4BaoTe7M9oy5w3tM=;
        b=Z4gt3sjs7HJOg5E1Rhbzz43BV0kwY8dMsAmzdD/tuifVtfLydTShtX2/qQmkGD3T30
         9Nnejmw1T9pK1E5ePw9Cj15I1zEzIiHzYpKTzMII6xi5ndDVrX/DruADAvAizl+iWQaQ
         ciaZEKelqJn9pWp3JyMSyDQvBAC18BdebOUSEB1ULtYpfJcXVxxvnxtEUWoLEjmYOpbR
         L0WDu0VGPzQp3zVukilu42+UvgbPmy2qu7pverMeEWb3Cz7zvxGrhuYoesL8TltK6EjF
         yWcHkQLPInhgMqX9I3o5OGltw2TWgrzLOv+7RUcZufkaVJxHoxpzg6FeQiJJnSBEJOfb
         DwmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776298968; x=1776903768;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ePLDDsMaoT6WX22t4kx7uDAhAvj4BaoTe7M9oy5w3tM=;
        b=QAsJtd5QrRCL8verKjIj41DlwJSDzyHIcw8OXr5tKFJJqSsLY0Vsi4/2J7Y21ZJwlY
         PscW2iKJHFjPAC4q6zN6A9Iy3W+95cN5ucvTjS7UTJnF8DpKAgRJhtn61PGX0h1Wxfml
         2CJ7ozes+fHOtF1/gbZAHLcNokjYQZbiqMihNA5ndpeywH8GuOI6C4NYKL/9Eg7ymHGS
         0ESgqGKv9mwak8e74kJcufSFWb92OeooL0bO4xtwhOB8Is+PzGZhr75/8qlfNpf7IEkI
         GgkG3hHDK4aMNcVtPkjiNdTrggEhmf9PzjALEEXBFjernKjzL4vmgrLIUZcM+hX26qpr
         aaBQ==
X-Forwarded-Encrypted: i=1; AFNElJ9N6pB/miPbBIFAJemKLnXMXxFTrUpvu7UQSk45RJ7Z4vJFEydgnLn2HtGA+vj8Mz0gYKHEb8djLXOF@vger.kernel.org
X-Gm-Message-State: AOJu0YzmlfEKCW8Mremj0iXI8ipZm5lCp7x/Ok7hFAOgrQI9r2tgUUsN
	N7aVKCREj2OZYDlg+SjeJ5FRh8p4++xdYG+Ic0IcVTTQRFWtBPUeogCb+AdohiX3wJimwVbQ8ZI
	L2USDyWqtTbPVJqZW3o13pETE659+x4fs8+d9r4IyV55ZfZEL74f0
X-Gm-Gg: AeBDievULprr4LK2B1S/qt7Lq8q6bVoY4bPRBPuGOVFWEzcwBW8GFYNOuVv7MnBdB07
	8AlsVt1g1LDIH+zq1guy37QubzfvJ0Yc2DDXtlaJQGlUOaqqxP9lANiMxgLKITwguuMY7zQno5A
	TnSp5mzdKv3W2rgTgzfadCt9jADSsTvRB4JNV2cES0kmunSk65e2V3WITbVpaoKTK9M0Nbkt+96
	/Cn649gaDY8Wv6YM9M6+Rw4RaALq3GU26/wfLiYKmiEwwHAh2sJKNCcJoHrKx29Lw6//oPAF9al
	UAy0LpNBB0X3fSh9xAWMTmblNMQZrUaSintCx5jaoNZAMWvwshZksFxKLsYcMBbbLwVznAFyLRv
	QjCvSRco/fiUSxvyYAPB2Uy3UPUpNz8CLz9KjHhLbLcPjhXLXWw==
X-Received: by 2002:a05:7300:ac81:b0:2d5:9438:2a02 with SMTP id 5a478bee46e88-2e17d815b51mr60486eec.1.1776298968089;
        Wed, 15 Apr 2026 17:22:48 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id 5a478bee46e88-2de8ea899b9sm240344eec.18.2026.04.15.17.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 17:22:48 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 49AC33405AE;
	Wed, 15 Apr 2026 18:22:47 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 3F4A0E41B93; Wed, 15 Apr 2026 18:22:47 -0600 (MDT)
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
Subject: [PATCH v2 5/6] t10-pi: use bio_integrity_intervals() helper
Date: Wed, 15 Apr 2026 18:22:13 -0600
Message-ID: <20260416002214.2048150-6-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260416002214.2048150-1-csander@purestorage.com>
References: <20260416002214.2048150-1-csander@purestorage.com>
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

