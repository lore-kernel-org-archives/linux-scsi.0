Received: from mail-dy1-f225.google.com (mail-dy1-f225.google.com [74.125.82.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0934F3D6CB4
	for <linux-scsi@vger.kernel.org>; Fri,  3 Apr 2026 19:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775245286; cv=none; b=aNAWp5/6j3bZysOPgmxOhPgawKLlA17t5igbIJTGXpZoq4eU+SXmcVmaN+LL7D0irESPZw7YE+ybcJMkEvEv/i8mpOgGe9iU0JLMxOdx2gziNuYSdYPZzxzC4HKoI2/OBwgXv4FiwEVl7j2KorVUGQyvjV+adcwDJkSSK3Irn9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775245286; c=relaxed/simple;
	bh=dXB9nsSEQr0UD6HILmUJ3dO6tL18AphRTyOEKOREPnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXppmzJ7d+6IGJbxQnW+NTxAgQNf/Dj1V4xYwY+11EuSq+IEQm/WuVguX3eeXednVqP3Zjp4IfSgrebYvYcxESQIinaMNU/ClfwaKkXF8JnqfI8hNb9Wpgb66kJIVv3VkG7A1VmJlaEB0YMINOoSnodDSgtKypit9uB5xxclMHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=JvULn3uO; arc=none smtp.client-ip=74.125.82.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="JvULn3uO"
Received: by mail-dy1-f225.google.com with SMTP id 5a478bee46e88-2bd801b40dbso209333eec.0
        for <linux-scsi@vger.kernel.org>; Fri, 03 Apr 2026 12:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1775245282; x=1775850082; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i7Uy8gUL8icrsg5BG6MoYGthlOT8yOCeEWU7Db5146I=;
        b=JvULn3uOwkKUaQaHqiJT+f+UAp8ILB924uzwY7yoeg21GuaTAkNMfn7WUgSTmCkyyC
         smp36/0PpdPHWDotyaAGL/JbIpK+JlJaBVTYquHkH154ucK+3pSS95gCSapl3kKo9uf4
         CwKtYFWipRUDso/ZR6Q+7MeTxbp66XDGH5FaEwhIQQf5KAHfzO4HRx5Ch2hcidmiMls7
         wASCAkOrzJBIOCxCNniqYnNrUCX2PDkSp054MqK0XYeRm+Mhy60OSUv9gYlxEKXOSt89
         AFrDjNx/epWcUHg7nLd6JKf0zEH5JSKt8eVcdbCrM6HrP6YF+DCiIQzbi/HLtM+sOnOx
         w5wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775245282; x=1775850082;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=i7Uy8gUL8icrsg5BG6MoYGthlOT8yOCeEWU7Db5146I=;
        b=ZZOiWUraRr/saDb1JjltJ+OUkxUa+XpCZdGgr47sUWuu2UN3yH6NatsopinWNI6N1z
         aN0uhfSTe1qNrvPGb502KL2LZ84gpbfTGuzUJOvuuiWOOitBDvAtu7INRGr9uMPfKxVh
         YiJSf3D13HC2mdJzpt2qUC/UemWc2nbm5Ylqc8oIEnysFKxXbKknwjCjt0klh+6tb2s9
         MRI37vzqKmzH1A3qGYhx1cuV3SBAQZNRewjAh7cpbIQinOaOj1cIQXTeu9Ots0N+nr5x
         MSLZ8Ghxc3E3CgBHaaSwyT+o+jrgPTwFiNHUqSuApJ38oSnfbflOUiCw+77T7+cRqUjP
         pdaw==
X-Forwarded-Encrypted: i=1; AJvYcCXeEmJKoMlZN9AMtnrfAxjQ5apQyAFIu0wVjBceHbcU5FAfOmXPE5JbqHmI38Fg2Ic9Uo7FcH3ol/i4@vger.kernel.org
X-Gm-Message-State: AOJu0YzJQkHs5Fb3331ZeCGJAAhLNY+KuH3iFGXZOjuNYPoaLFJ8qcR+
	JFfTFmDfKAIvUshxoTcSqPQRT2h7BwxubJVvAZdnp0b4Lg3H/zeDrXvEc8IvnQkvfaKSN0tUkHa
	NaVsNSARSBqJNzTJhS+n5nu1Cxixg/zXmhO2s
X-Gm-Gg: AeBDiete8mielr/tjrdfN3JblRyGZ/RJrJ35viNvEX//vQbfGvxRlMPVTvSUKSwF6Y1
	yV/3x6O5VWltPBrrpV6/9Df7fUo9vltAJT+2+wOrGBEGRjQ3DM171I37i+GGatGrwJGwcAqMPhN
	8dnQ913hVCfkgQfclfYFY+ttaBAJJdZDG6bk1m5QS2UcgI8tMMOgSxygvl5GuwaQhqJOI6WXobP
	8yk4313kAXvcH/yXi6TfTfjuUbVTR9hONTwFCJDZGXUJhI/ZhywuoFS1x0HEMSzI4lc5lOAvxI2
	9Z+GuBqmxb3Kei2QIrlOpWS504Gm5KcBSoc9w4ym6cDtYVOafWXNgnhhEItItct46HObZCga++Q
	D5qlp/KfRUm/zfrABRhBvj7P/HYizHdMLy7W40U3wlTwBmOFBhfRR9A==
X-Received: by 2002:a05:7301:6093:b0:2c0:c55c:156f with SMTP id 5a478bee46e88-2cbfbc82969mr870935eec.4.1775245282274;
        Fri, 03 Apr 2026 12:41:22 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id 5a478bee46e88-2cb61750eb8sm339741eec.29.2026.04.03.12.41.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 12:41:22 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 7623D34014E;
	Fri,  3 Apr 2026 13:41:21 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 6CCCEE41AC2; Fri,  3 Apr 2026 13:41:21 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH 6/6] target: use bio_integrity_intervals() helper
Date: Fri,  3 Apr 2026 13:41:09 -0600
Message-ID: <20260403194109.2255933-7-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260403194109.2255933-1-csander@purestorage.com>
References: <20260403194109.2255933-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use bio_integrity_intervals() to convert bio->bi_iter.bi_sector to
integrity intervals to reduce code duplication. Make the same change in
the nvmet code that appears to have been copied from the target code.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 drivers/nvme/target/io-cmd-bdev.c   | 3 +--
 drivers/target/target_core_iblock.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index f2d9e8901df4..dcf273360015 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -218,12 +218,11 @@ static int nvmet_bdev_alloc_bip(struct nvmet_req *req, struct bio *bio,
 		pr_err("Unable to allocate bio_integrity_payload\n");
 		return PTR_ERR(bip);
 	}
 
 	/* virtual start sector must be in integrity interval units */
-	bip_set_seed(bip, bio->bi_iter.bi_sector >>
-		     (bi->interval_exp - SECTOR_SHIFT));
+	bip_set_seed(bip, bio_integrity_intervals(bi, bio->bi_iter.bi_sector));
 
 	resid = bio_integrity_bytes(bi, bio_sectors(bio));
 	while (resid > 0 && sg_miter_next(miter)) {
 		len = min_t(size_t, miter->length, resid);
 		rc = bio_integrity_add_page(bio, miter->page, len,
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 1087d1d17c36..434ef2b0b120 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -706,12 +706,11 @@ iblock_alloc_bip(struct se_cmd *cmd, struct bio *bio,
 		pr_err("Unable to allocate bio_integrity_payload\n");
 		return PTR_ERR(bip);
 	}
 
 	/* virtual start sector must be in integrity interval units */
-	bip_set_seed(bip, bio->bi_iter.bi_sector >>
-				  (bi->interval_exp - SECTOR_SHIFT));
+	bip_set_seed(bip, bio_integrity_intervals(bi, bio->bi_iter.bi_sector));
 
 	pr_debug("IBLOCK BIP Size: %u Sector: %llu\n", bip->bip_iter.bi_size,
 		 (unsigned long long)bip->bip_iter.bi_sector);
 
 	resid = bio_integrity_bytes(bi, bio_sectors(bio));
-- 
2.45.2

