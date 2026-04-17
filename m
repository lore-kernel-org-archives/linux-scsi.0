Received: from mail-yw1-f227.google.com (mail-yw1-f227.google.com [209.85.128.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB382C3248
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 01:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776391072; cv=none; b=XSpbI3ZU2880IkFChy0cmes6iiE5Ok+euRDotdDPeVvMRZlTyd4DaW0XGMOjX8tkIFk27dM7WsQg8ZZKKfeHBVme231JDu3oeIi+3aq47bYcyhFZFhFadWfjiLWkaAWMngOwVzUSrIB53pHr8jN1TDEKttnthVy+KSo/5VI5GQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776391072; c=relaxed/simple;
	bh=4rwKcoxtwwyEUMs+lZSg7yRkJNPnm1I0J0geFKeIcpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nEjgHABLuiW0YiTYeXaHbFOsboOiPql4RA08QQu3AoVLmCb+gJn8d6XTN1fXbSoruCJ3KTL1SHNGjRBgBZwvOIFiGO/0fJ9QnkTPOt3x9Cpv3WsSSnuqqAZ/qMxWWSstYFLU//mswLyZ0TXK9NKmZqlxTH6zqyisanwyuFMQCvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=dxq58Rwp; arc=none smtp.client-ip=209.85.128.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="dxq58Rwp"
Received: by mail-yw1-f227.google.com with SMTP id 00721157ae682-79853007604so35377b3.0
        for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2026 18:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1776391061; x=1776995861; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nVdvVaugSDz6j9AO/nmgKpHbKb4qPtoLkQfjj793Zaw=;
        b=dxq58RwpRQQBlt04OmbEH1R33EnT3d1TCgA1dmt+LGq32r0ELoA/TIOYRSQEvWuZlZ
         /clMEcjdCCnXogPb0rQlAKPufdE44kTA6l2oWn6MZfQJ57H5wwKqMjKGq1LxIPZoeEnh
         H8HoCZM34DNvvaepcGHdySfabteMnvohic2kflq4SLCtYo75/c01bbGnvAtVQv0YAVrr
         0X+6n+OHnHkCH8puWj/ilZejiiHAfXg8pFaFqQG3UWqK71rSAMtQ+7ylPV8JjtkEjpYO
         BLV1zktVZeMe+LRHU1QCcyfdw6t8ECeV0ErgrYYGk2JDs4Lqt9xzQwFHkdg3vGWHnA9K
         8B/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776391061; x=1776995861;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nVdvVaugSDz6j9AO/nmgKpHbKb4qPtoLkQfjj793Zaw=;
        b=tHoUp8ZNxm6LrSeHdHMo+pVWUzdnBXhpE3XZ6bVhznNxBYnGhPyAOrcUbN8eRafp2h
         vCN2vw9cdjZWeeWmoT9rw1dad8ubX6YcHJiGybZXcbwCW61capc58xfK5o0ZOhKrJEjv
         Cw+MjxPFoYqgjKElHN4/b/Jfon5pCs/wKx7WNCLr5slAlCoCJ8uJEyYuZYmIPH8TACHO
         ExF/BAcOdtaHLl0p1m68dpq1BoUxstr5PHF67fx1Ml95YM/Big/loBKOeKBmY0v55FAy
         hMUyRJk2LmFk8L4UCspFno103yNLsKConGqb6ADUdDnjvxjZrt3UKEsqWyN6bCHdYwoG
         Cj6w==
X-Forwarded-Encrypted: i=1; AFNElJ9isf2oxE/iZW/0CZnR09j6mw8tKZ4PXKcKKNqUOpPoCz6rGRavum/OCyb8Sv91vvxNWjRzEOSl6rNt@vger.kernel.org
X-Gm-Message-State: AOJu0YwXUR4jWwg07qAWarsYzrKKnrUXYtuoezuCzJdtjyjL0wPGPBky
	7q9HZePRJCnKhI9uuA2piKCxfIiYg3HU6KL77sZbXfkzQ/apL5DLzrQkRiJrbph/4IJJAww/K3j
	sgJEoNFCc7w2I+vI5f38zQaNXuUUjCWauKDFLzTsOB8M3jDYN48Gs
X-Gm-Gg: AeBDievKkqekFzHalVJJI7Sbz15lCiDXBivp6PrfQrPvi/tCbxthcDyxbAH4V6kAo/R
	sF50nhHl+TIB3ciZPw9d66JV3YkghG3LceUJQzcmkFvkcFa+jffUpfy+eGpjacxLJ9kHmvQaUAY
	mjJPndrsHR6M9aAJC9NJvEC4mRKg2r8i3b1EsbrJiPFzvpum710ZdmZHKGto70x8v99IjghqcaK
	wHJtwZ5ZSzE3d5q5INEkNkhX5OPzxklrfL2MNTQ6KGtvJ/7odoEzPt5grELHomhHIu7GcxIDA9S
	uWKzJLxiH2c+zYGI77H/YlZq1RV+kiP7ZKEU/X3rz/+bUz2Hht4NS5dCI3gXi6Rl7SZ15Yrtmr7
	JRJJnjsMLLX6pBXPNd++xpaEIGo7uHwBhvzXAbeKc2OePEgN03g==
X-Received: by 2002:a05:690c:4b0f:b0:79c:ff02:a03e with SMTP id 00721157ae682-7b9ed037d1emr5894277b3.2.1776391060655;
        Thu, 16 Apr 2026 18:57:40 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id 00721157ae682-7b9ee9a8042sm125407b3.21.2026.04.16.18.57.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 18:57:40 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 295C2340BC4;
	Thu, 16 Apr 2026 19:57:40 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 25C2DE406BE; Thu, 16 Apr 2026 19:57:40 -0600 (MDT)
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
Subject: [PATCH v3 3/6] blk-integrity: take u64 in bio_integrity_intervals()
Date: Thu, 16 Apr 2026 19:57:29 -0600
Message-ID: <20260417015732.2692434-4-csander@purestorage.com>
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

To allow bio_integrity_intervals() to convert an absolute sector to an
absolute integrity interval, use u64 for its argument and return types.
Also use SECTOR_SHIFT instead of the magic constant 9.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

