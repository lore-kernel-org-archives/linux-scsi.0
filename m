Received: from mail-dl1-f100.google.com (mail-dl1-f100.google.com [74.125.82.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871C83D5252
	for <linux-scsi@vger.kernel.org>; Fri,  3 Apr 2026 19:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775245286; cv=none; b=LRIUhfnSFc0T722iCyfI1OyxASSk72JnEdkZOKPv7PuQEnE9Xgr6DevbjwJzdP2HOIqtngM0jfQE2rcmv0uHQnOXh3he3Qb6C3pztnl+oCB7YSTQXR+nWGdHc5/Zyu32iKVppqpq8TWQDXhbh6gAvRilwRW6fsQVeIK8qe2jyfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775245286; c=relaxed/simple;
	bh=6guigZtakqC5pvuDbptKgaqm6++svhWNI/4P7FQdOpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ise+5rVQYrmPebzVsyGT94BxgvMBjnza73Ht5dh9rSh8WK+WXiFmVzR3pjuhbiIetQ0ti4T68/VUglKEeSVsSWcqvJMRaYvmv2jFXQ7DpstaQtWi0z9U4j2jGyf8WdVqdKl21Xz/QL4sGhnBLlFZvOUMPifZlobeCnQ6aXtloeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=W3GRVnJA; arc=none smtp.client-ip=74.125.82.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="W3GRVnJA"
Received: by mail-dl1-f100.google.com with SMTP id a92af1059eb24-12734af2cdcso91196c88.0
        for <linux-scsi@vger.kernel.org>; Fri, 03 Apr 2026 12:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1775245282; x=1775850082; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L5n7eMwAf8ARSdCe/bC94DhqCdtLVwx2F31J3F2H4e4=;
        b=W3GRVnJAV+88NGTdK1YaoDuXShp6cW/1gloZhDOSAJUahZ0CQw/tcrbUXrHuR+n4//
         VBo7wwIemJ9vuXs0lhr+pZxRDYk8iOsd3wBTk/Jrfs0nc5msQLeUrxlmNjr3N6Y65Rb/
         ONqXfOtsCDm+22UfgtjyQIVrnnwOUHyeW/TLokpgSTsujHpkUQpgfjnSn1B+AiYWerm+
         D8vaXTwvlHyzL5Sz+6VjF3PVP3hlrdj9PReH7KTuCuHQbq3BxyvbnYK2pJaZeab4FfpY
         RRM0ZCnedorRkquh7Y18SaZh3DqHfyy15c7H1dxrFa56GCntKjCmNheZ3Rh0LhUJTHoJ
         waqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775245282; x=1775850082;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=L5n7eMwAf8ARSdCe/bC94DhqCdtLVwx2F31J3F2H4e4=;
        b=qCLrqIJ5GpOW42usT4VzKjMfkMCSE4jasuxXWW5FTh1Q/5zB9jRhH+SuLiYQ7oOFpH
         yBqH5tfrZinhpIetNPEsawK2HpA5eYIwrXjW7PBtxAu6ISDriRaxMnGzWGBf+n93CjeV
         j1cNz5Wb1ceLiJ2MQL0plTPDw9QAmCSldnod31yGgDtJVupPzC3ll4S5uDxgLZlm3yLa
         Q5hleA7hdC27o7y2wtOK6qUJf2w452iH/Reb3fe6lISO1ve/8jgrk3q1Vr7sbzbI3ByH
         FqhzmaWCxrDZAvmj1jKx+tQ3Ip8uOQkBMMiRoAMEyM6iunlzQ1OnuA76VX4HWw+Ax8Aj
         h8pg==
X-Forwarded-Encrypted: i=1; AJvYcCWX504vVhF5riXnQIE1rZouzjNHMM5v3Q6UJELjmXa/XaCa3KVR7NXSLo5WyJDWDY5Xp4vljnh34krQ@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+EeuWXab9CWfnY7KQaOQSbKAr1Av3MfQRdloCgYfjr4ccmkma
	8Sd0gAbUS+5crQUBEfhupnxvd5oardidxOQID9ViV7jH8nTPkLvr5Z5XZfhqp2g2KXk7al6t2WE
	NQDvIYGgSWnMkLrAG8m6VeRcrvHl085DyxArs
X-Gm-Gg: AeBDiev7SyJ8S4aNAVzZme7xoixjwqzR0tWZnatIfAq2hTCTHLOUj+6WfVhoYtLgw9A
	zfhOzeQ581xQUGeX3u5++zxTnxaxWmnREzr/iAYEhQ8ORYDeztmM9fx0yt8kBADsWnLiHj9S+Dd
	wOp3r98cXa55IP7i3bv3X2VPiz8AheCgNc25xNoY0wzq2XrTe5u2nhWP1BH3WEzDvFX7Q7Z9D3x
	Zy3+npC/5wB/wmRbXtf8Rn8CcKKBtlqtg4WjpIsqiabYUnEUDgQhQYZMUXr1Y9xgekAvITth9M/
	oSVE4db2FwtAFi5PUKig6MGdKmsg0NCIAY1kVTiHt6qW0FrlbFwD5spJd058xTMvx4uoyRkw4+C
	PDigg1DZmn87HTLygfE2/9zR19ZYt+e86NjWBZ9g/CVkjZhpuqKX7jA==
X-Received: by 2002:a05:7300:4347:b0:2c0:c961:4b98 with SMTP id 5a478bee46e88-2cbfc85e0eemr888275eec.7.1775245281557;
        Fri, 03 Apr 2026 12:41:21 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id 5a478bee46e88-2ca7b9037b5sm474222eec.17.2026.04.03.12.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 12:41:21 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id ABDFF34071E;
	Fri,  3 Apr 2026 13:41:20 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id A21A2E41AC2; Fri,  3 Apr 2026 13:41:20 -0600 (MDT)
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
Subject: [PATCH 1/6] blk-integrity: take sector_t in bio_integrity_intervals()
Date: Fri,  3 Apr 2026 13:41:04 -0600
Message-ID: <20260403194109.2255933-2-csander@purestorage.com>
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

To allow bio_integrity_intervals() to convert an absolute sector_t to an
absolute integrity interval, change its argument type to sector_t and
its return type to u64.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 include/linux/blk-integrity.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/blk-integrity.h b/include/linux/blk-integrity.h
index b1b530613c34..2e366f03a3d8 100644
--- a/include/linux/blk-integrity.h
+++ b/include/linux/blk-integrity.h
@@ -64,21 +64,21 @@ queue_max_integrity_segments(const struct request_queue *q)
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
+static inline u64 bio_integrity_intervals(struct blk_integrity *bi,
+					  sector_t sectors)
 {
 	return sectors >> (bi->interval_exp - 9);
 }
 
 static inline unsigned int bio_integrity_bytes(struct blk_integrity *bi,
@@ -151,12 +151,12 @@ static inline unsigned short
 queue_max_integrity_segments(const struct request_queue *q)
 {
 	return 0;
 }
 
-static inline unsigned int bio_integrity_intervals(struct blk_integrity *bi,
-						   unsigned int sectors)
+static inline u64 bio_integrity_intervals(struct blk_integrity *bi,
+					  sector_t sectors)
 {
 	return 0;
 }
 
 static inline unsigned int bio_integrity_bytes(struct blk_integrity *bi,
-- 
2.45.2

