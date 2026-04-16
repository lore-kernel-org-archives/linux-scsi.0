Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24AB1A683B
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2026 00:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776298970; cv=none; b=d4arZOm1LWnbiwr5/x84aRDth8m2MhYxlhVeng6oV8BEuvpL3EkzE39PRerDynpOk/rEpS0+Q2OO3OL4/HBSyTUByovP3uV75nL6MQHbmc7VfU2Tg2d2Afp2CsD5zRFTj6YuKZUGV5nHttIC+t9Ed3x/oMg1T1BCDu/WL47frZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776298970; c=relaxed/simple;
	bh=OqvmwxPUynjDh5Tn3iMgPFDXoA/L2INxvr56NUjgkIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OEER53VWPuPz8vX8nHmz4a9hnmYYbvO7ScuDDk3czxpseUtODnm1Yptx9UWWJhASl/M+UMXS7TGlhTGvtXfKZgImEC+8MN0E54s/sc9/dKtEfzyqs7uqVIXH6+kQyJ3Fq+g7eIhqy/cRQ5pD9QVDdwKgzgzdEsWyplYkKhlWwcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=UNsHozT1; arc=none smtp.client-ip=209.85.216.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="UNsHozT1"
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-35e4617924eso811837a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2026 17:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1776298968; x=1776903768; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eyCXVkuEBYx6RuPx/hECYTdCdsu/oyGta5lJzqSGfU8=;
        b=UNsHozT1KlO2DwnCIh6jPeQ+TDp/CiNCzfZl4OGWY1NAbw0Qqf1tC8hL/KuwIpud22
         lhCBocSoB219FHkQMJKmua65/xMRnhuJch+ZH50amgT2p6FErj3sai1dKPujjfj7jcJo
         Y3wU6Mp19/assUTplr4q+6CSD+Abqodhu+Ytn1TKP1DcxI8JuQia+9IxfG35w4mY8hnZ
         rYgbV5MUZHpsDqRXNW8whyI7Yt7y1YwBpN0YiiM/ZhytMQ0JcgB/C9zBVS+AW+wo+SDO
         Og0rmfAgN+1+VWDUfD1eUs+H/5D5D5+8AeYFqfumi3cpgP3FvA0LFOoP8Vy5Gww2ruWj
         Th1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776298968; x=1776903768;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eyCXVkuEBYx6RuPx/hECYTdCdsu/oyGta5lJzqSGfU8=;
        b=gsL2eS+y/KXgEV4I9CqwRZwXHAF2f/Y8MJi0A4mPsinbYoQesGn5sFBxzsWyTQHSCC
         BqHofkZu8rr7MZ/Rm3sZ8Tt5sTfTrELWUkX4wqOPf+s8tVmyhd9oN/rPozE5tDmALG8X
         LLuwfegiAuCrNcIk9VUZHuVHq4zTwSFqjioTBRg0hD7NQkS1GC7GoUp1lRZ772l+xLCT
         Ota2jr2ukCjqtqpsQpQBoY88gcCYPpFLhSeMU8ydAeAKpnks28SVSunwfrnfJNe6+lgj
         VMJZsDZpd1tggpy9XNy480CcnGTIIFAUaKFcZQMR1Si5Vzv6IFPxWu2tXEUTYPvYFg7S
         JyMg==
X-Forwarded-Encrypted: i=1; AFNElJ8Nzio7Bf1rtjkWBLpmSk6tr1J2u30/V4FFYELlW7btg08OaszzAfLKdJqegOxNchkaJZB01/1vC4ZE@vger.kernel.org
X-Gm-Message-State: AOJu0YxhaKotqp2ZRgpgiDDZlV4m/2WN4jbWK2tJSP/sW8aYgKlYm3zb
	YkQj03DRG3p11bHnzPGe2Zorg+s8U5fvOYco5YZ0RnrRfnAnb9QZ+1Qw5FCs+Z/tNw7p15Fd5qc
	fZnmMC3bpeR1q1DEqL6N52hoNf88oTn60WtGx
X-Gm-Gg: AeBDievVRBptbc7CNksPot3VTtmLa9egPdzctBD7Ph7oAIJBqozxHlbZfApBTxd2zJs
	5TTkjKBPWARzMtWVICN8TV6ZzQW+W/sf/b8HB3eI5vdNfIgcj9vqS7k0JH6kNRuS9xyZVtXbet4
	GBOuUXaf2B3Q0eARykhLeuwD2L6kNQWQFnzruA6AKktYjvzcYWNiPhKcVU5LgcAdIYuZQ6yeZoq
	veY1RopsLDWC9WFNupLMXykdJbr5CjrIOSU0Q5ORpjUjxV8yMcI0LkUkl/L34mY9268g7fc1Qb3
	xaGpzfSizQusQHLCaH+yY4CJbNC9ITxms8FHWcSiNT+7VdR2AYY5qMNJNoryPVIK+8n26m/SdQ5
	gv8tuvHzIMN/i/0VptykWGg3CNmYqw/0mUSgxze/fcfFhBUtlwE0mGPM0UFWww5Vi
X-Received: by 2002:a17:902:d58c:b0:2b0:7041:63fc with SMTP id d9443c01a7336-2b5eda8b366mr2383085ad.7.1776298968060;
        Wed, 15 Apr 2026 17:22:48 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2b4781301b8sm2399375ad.18.2026.04.15.17.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 17:22:48 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id AEDE23422C8;
	Wed, 15 Apr 2026 18:22:46 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id A3C50E41B93; Wed, 15 Apr 2026 18:22:46 -0600 (MDT)
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
Subject: [PATCH v2 3/6] blk-integrity: take u64 in bio_integrity_intervals()
Date: Wed, 15 Apr 2026 18:22:11 -0600
Message-ID: <20260416002214.2048150-4-csander@purestorage.com>
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

To allow bio_integrity_intervals() to convert an absolute sector to an
absolute integrity interval, use u64 for its argument and return types.
Also use SECTOR_SHIFT instead of the magic constant 9.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
---
 include/linux/blk-integrity.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/blk-integrity.h b/include/linux/blk-integrity.h
index b1b530613c34..825d777c078b 100644
--- a/include/linux/blk-integrity.h
+++ b/include/linux/blk-integrity.h
@@ -64,23 +64,23 @@ queue_max_integrity_segments(const struct request_queue *q)
 {
 	return q->limits.max_integrity_segments;
 }
 
 /**
- * bio_integrity_intervals - Return number of integrity intervals for a bio
+ * bio_integrity_intervals - Convert sectors to integrity intervals
  * @bi:		blk_integrity profile for device
- * @sectors:	Size of the bio in 512-byte sectors
+ * @sectors:	Number of 512-byte sectors
  *
  * Description: The block layer calculates everything in 512 byte
  * sectors but integrity metadata is done in terms of the data integrity
  * interval size of the storage device.  Convert the block layer sectors
  * to the appropriate number of integrity intervals.
  */
-static inline unsigned int bio_integrity_intervals(struct blk_integrity *bi,
-						   unsigned int sectors)
+static inline u64 bio_integrity_intervals(const struct blk_integrity *bi,
+					  u64 sectors)
 {
-	return sectors >> (bi->interval_exp - 9);
+	return sectors >> (bi->interval_exp - SECTOR_SHIFT);
 }
 
 static inline unsigned int bio_integrity_bytes(struct blk_integrity *bi,
 					       unsigned int sectors)
 {
@@ -151,12 +151,12 @@ static inline unsigned short
 queue_max_integrity_segments(const struct request_queue *q)
 {
 	return 0;
 }
 
-static inline unsigned int bio_integrity_intervals(struct blk_integrity *bi,
-						   unsigned int sectors)
+static inline u64 bio_integrity_intervals(const struct blk_integrity *bi,
+					  u64 sectors)
 {
 	return 0;
 }
 
 static inline unsigned int bio_integrity_bytes(struct blk_integrity *bi,
-- 
2.45.2

