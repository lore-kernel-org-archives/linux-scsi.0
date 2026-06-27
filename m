Received: from mail-lf1-f98.google.com (mail-lf1-f98.google.com [209.85.167.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FF238D3E4
	for <linux-scsi@vger.kernel.org>; Sat, 27 Jun 2026 05:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782538972; cv=none; b=rbYD61e8Cy2pu2VcU2N9ws5RKpHHo1WhRM8cpS6Ax77pSu/QQkzxdVWAbaM5Fn8AGOpLvvH3Dr9wjrzsgIcfepAsOSgtdSLUgEfUjbVgV2Gzo/PwI9Rr5HRVzcl490D1W8+QuiGl10FHL1wZ7thqkaMz9W90YVq3/GpgM6hvfwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782538972; c=relaxed/simple;
	bh=DpRzB5nNneV2e7fuNOjzFT7N1hOW9bUMAuLBZOKGdKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MVZ4NqIlLKVNPwSneX5lqZ1nc8MpfrMd6z65RjkwBruvrzKA/oaloINaMxs2S90V5lO8Ah/guzQ7Z4m2am3l5hfYL2NLhrghTLVKN7vRqJa1qYkLfOGrmER54e7gAnIqT8ZeEe1JMGvYgubYAELCVvXhFatIC5XCLRXg/UX8nLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Vp10ZeVx; arc=none smtp.client-ip=209.85.167.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Vp10ZeVx"
Received: by mail-lf1-f98.google.com with SMTP id 2adb3069b0e04-5ae9f62f6e0so70058e87.0
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 22:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1782538969; x=1783143769; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hKeiCzbPRbTnzm/AI4vnqpxf3f5IT13bPWCisZ89M54=;
        b=Vp10ZeVx7XVjmbAa4vox2w1K6GM4lUTjADwmeyN+4UqJx+MZPzugyreZPc8U2Ctgio
         v5tpw7rg6Zx/CDa6Iv38SOVaCZF/OJlmr4I/TGiJ9YsSXvs5y6GM0NNxav49kVhFF6Bn
         uhpdI0oTu5vsSUey8FxUnpZE3CqiVDNop/ld1Oh6kh3tVO4FDD/fE1rXr5xHlIxzCsMD
         YXKwRRE5uBgk2CEzP2hCmg1R12sFaJiOs7pOzUZN3nCQ3t+1UwZSJeqdMttqSpyYfnPJ
         ceEUjhPFGaECYeyKPKIB4iA+v/+TwzmT+/Gg8J16fbQfnRlyTPs5XI5I4jO0BG54T40o
         yO/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782538969; x=1783143769;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hKeiCzbPRbTnzm/AI4vnqpxf3f5IT13bPWCisZ89M54=;
        b=BpWCVt3dONbWyY8B5o4mgORYrxnIEYPax3fXjFBLJKKmWI18usO/EmzLK3byeL1cN5
         BpMPFm8A2bBRNiVNliwll0/U7E7KsigHfd4SH8vf7kWjskpJYwuPKfJF1rMn8U1w4THt
         6gQiKeLtEMWG7zWI8S4upnHiHHCXBYe5aQ4E5UWDa/Fbaf2yhwQkYuIpHpOStlOKzQmM
         nd3K0VZO9aQyBsVzpzD81aYvMqrFI1i3fwykWroFX1dZy0nufvy2VJH3Wv13Qg7KpXXz
         yhrkhwZ7vDLJ30Pdt6sj3G67JoXjRQ10MI5F32WNEe4Qfn5E3MhLQm5UeE1OAgFOD7Ta
         ckcQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpf1mQL4mOHMUZaAj2XBqCSYozv2RTZbcKtbjoU0+lf1AZRI0k2+v+lPZ2lU2DeCEY12ySnV4vdVMl1@vger.kernel.org
X-Gm-Message-State: AOJu0YxIYA+cx7IIRrQLxDdfpGTRhPnFEhNWiJGEAkd0x68pWeQ0NVMg
	IUb64MI91KKeIkLDGC5rdECZMB6SSNu5ujXro+5ggUs5mWfCvcje6PRxYeo/bA/WLyW3Y0c9OoW
	Eu5S6yx2R+YXbf8N09AXpn8uYSq6TUJ8Gbm67
X-Gm-Gg: AfdE7cliZ1Jk3bZ/nPVjWbX+9E5roLrKkxDPD4xW9ievzL53nKoXgq+EwqxUpPMX92d
	DxJRIFijl9v+S+B0PDHzUxA8lAtie18FO2wet4Y1gCvulqUP4gWymPmSf3cIt/VypbqTG9rMsni
	o6hG8awZqX4rjNXZQdVlvZAb9BqVcHpq7J9UU1hhYlGDOtvldI1/icW5b34f7/v9SuJfwLAk7Gk
	K4RinwcSvMPNsqPMiSV7nCXNMf5mnPhmWOuWLs3GaA/9c2iIza9dRjLlw/uERrPD/VR1++YxeyP
	EuBtKG2OOtVfpTHbyQ6+EG/Kc2h4CKy3u7Ex86f4AH+nyrpVq0ueQi+tYlfLki4AvQvH2veqpnk
	ng5fkSuDw/dYkgKj2wwLIHJqnYd790kwtzkghkHIwZpE=
X-Received: by 2002:a05:651c:2224:b0:396:8491:3135 with SMTP id 38308e7fff4ca-39acb54fe16mr10822271fa.1.1782538969173;
        Fri, 26 Jun 2026 22:42:49 -0700 (PDT)
Received: from c7-smtp-2026.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id 38308e7fff4ca-3999b1cf17bsm15732331fa.13.2026.06.26.22.42.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 22:42:49 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (bond0.slc5-n17m28-k8s.dev.purestorage.com [IPv6:2620:125:9025:20::a31:41f])
	by c7-smtp-2026.dev.purestorage.com (Postfix) with ESMTP id 73DC4402B3;
	Fri, 26 Jun 2026 23:42:46 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 7161FE40712; Fri, 26 Jun 2026 23:42:46 -0600 (MDT)
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
Subject: [PATCH v4 2/5] blk-integrity: take u64 in bio_integrity_intervals()
Date: Fri, 26 Jun 2026 23:42:17 -0600
Message-ID: <20260627054220.2174166-3-csander@purestorage.com>
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
2.54.0

