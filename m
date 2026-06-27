Received: from mail-wr1-f104.google.com (mail-wr1-f104.google.com [209.85.221.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C123876B3
	for <linux-scsi@vger.kernel.org>; Sat, 27 Jun 2026 05:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782538971; cv=none; b=PEfjaZEAXlQTzsSfBvHvlleKRabK6tKdli2Z4J/fffsUM9zq+f+N7kBrQnjXHIPbZqPKvXveZPaeS1dp8GqAWDs6fSB8s0EHK+7XJspC/hwOb3uj1duZSVpuFj0ZSd50fKIs8So8cMZEnDDHTu55r8r3hxdyHI88LvB0ZREPVyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782538971; c=relaxed/simple;
	bh=3m0aj9nfgTpMPyTKR0ZRW5BNaB7D8LtbyalSkO5JWfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cXBDdQ+qFBEuEC3UvVfwwNREGQnj6AINTD7eSSQ0dtx4Rxy9D1NHjF9J/KPdGA18+monXJvOkNLZCEaGn8kR5Vfm4tOTfuHi3ikzpQej1R28REnWoVgHVDvQBhN4EifQ+RkmfNAhuUr977w80QOmdv78drkbvRxv+BrvYqPtcWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=IrZ8LMpA; arc=none smtp.client-ip=209.85.221.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="IrZ8LMpA"
Received: by mail-wr1-f104.google.com with SMTP id ffacd0b85a97d-46cb4a98168so134356f8f.2
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 22:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1782538968; x=1783143768; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TdMp+kUDXzcCHRaLfP/G+q/ZKBuIsQ8XItHm4El4CqI=;
        b=IrZ8LMpAFf2rtrlm4o1mva2y7IIHa82m7d3kd1p3482zXtCHojgrAA0dfJoktVB8h2
         zh0qwsoUoMs5a7bSGT+yv0kgcxUGK99JWgrHpjPDdoSLAfqWYLHtYv3Zh2kUya5aKlaM
         Bw6diaYQU0iuPmGQxRm7bDC66vT6Ye2LOFyeoYb01P2GzrjcmqVeMOqIu8sTOd2oKNb+
         akYGUbqwpjgE23drOmDhCxjR4fNHfoXpRpkk0JVPDSkhSK/UvwZ8fBd88NqJS4DF6zmP
         pBkkwBKJOTxL03EzDef1AbRPrfT9e1vN3aF1hEYgjOSO7Sawr3bmO12SbaFoFDiBBQpK
         m0kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782538968; x=1783143768;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TdMp+kUDXzcCHRaLfP/G+q/ZKBuIsQ8XItHm4El4CqI=;
        b=U5zSpfvTuI0WLvdhBKWL+YXLcBFJjUVW1L9XNxbQBzjRFqE19BQmd9+kZ6L4vTQelV
         AHzLFX07QCBODcoSUVLOPgUqOy+SgTVtio01sgf7KbpM0Y9HdjUh9xMBTTkpHA/KCOzx
         bM5IVCqJndvFnnmITWNKuQkQ3a3yDNLQPqB54aSZbiiYnJSl1M2FoJLdGn5xt7xuNs1p
         49LHlFufdf10v/S+uWtd1Y0OZCG/+Ef+8NR0rVJ5kvIZaZ5+wpW0OmGAymCSmZEAizT4
         BLTqPj6/nrR2Pcuebmh9YxL07rX0TPWzID9yl7+nP0uY/KyMKcqpMeDmvO4XyaBjTxeL
         3JFA==
X-Forwarded-Encrypted: i=1; AFNElJ+u2svnT1N801+QCTXqqGBh2Ip+kNO1alQRw+b0QC7lgUwfgmfrOeAyxHFPyGGA6eM0ab+y6F5TbD+2@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5uEZDe8v9IhdWocRT81kWWvGOrRJUV/iVR/Y6NxfVP5LRbMFD
	9SjDewg76Ytl9BhzFtpjZm40nf8hsSrJnzOKtqBzjTQslBXRvLMnvxa+BuAbR9n76N1fnVEXOXN
	q8/y0lddcXv6h11m79ANzcx+GIr8VsYdvzGeO
X-Gm-Gg: AfdE7ckUHIK3/gCJbeprfQ/tIAsoVRKbhrHQDetqCSaTKlQzKhLaA2+KHBd93CZo7eg
	nwSJCUNURfiC9gWOp4DjzcSo5wzhwGhvGuMC2yfVoo+UzX6yNLJhLyFfMB2OtxCPurJ/bVB5P8E
	qe5ofsz07ur+DKhoVj25voN7UXLBw0fVGmW2CwP7Mtj67Mt3JL4rESYsNvuabGzA3Hpy9LKTcOC
	02sBSkdken0dBKwvAhUDZcnpiAPIZeqANROmso20AbtjZeUHx6Aw27nXrpRmTMDNntYh1vnhsDZ
	d88zUESaJ72pH5HXzldvpxEBGcgsh083ZYWl9RvnjbF6feNhPTpqbE7cCgy/R2eEnFdHxxQxoRW
	R0pJM8ZC7a7DMwgEoLF7MXNGVcezF2w7jZ4v6Vs53YK0=
X-Received: by 2002:a05:600c:c043:b0:492:4708:d73d with SMTP id 5b1f17b1804b1-4926686b471mr48451735e9.1.1782538968091;
        Fri, 26 Jun 2026 22:42:48 -0700 (PDT)
Received: from c7-smtp-2026.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id 5b1f17b1804b1-4926902d9b4sm2356335e9.14.2026.06.26.22.42.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 22:42:48 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (bond0.slc5-n17m28-k8s.dev.purestorage.com [IPv6:2620:125:9025:20::a31:41f])
	by c7-smtp-2026.dev.purestorage.com (Postfix) with ESMTP id B2CB8402B4;
	Fri, 26 Jun 2026 23:42:46 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id B0913E40712; Fri, 26 Jun 2026 23:42:46 -0600 (MDT)
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
Subject: [PATCH v4 3/5] bio-integrity-fs: use integrity interval instead of sector as seed
Date: Fri, 26 Jun 2026 23:42:18 -0600
Message-ID: <20260627054220.2174166-4-csander@purestorage.com>
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

bip_iter.bi_sector is meant to be in units of integrity intervals rather
than 512-byte sectors. bio_integrity_verify() doesn't actually use it
currently (it uses the passed in struct bvec_iter's bi_sector instead).
But let's set it to the expected value for consistency.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/bio-integrity-fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bio-integrity-fs.c b/block/bio-integrity-fs.c
index 9c5fe5fa8f0d..770eacb2220f 100644
--- a/block/bio-integrity-fs.c
+++ b/block/bio-integrity-fs.c
@@ -65,11 +65,11 @@ int fs_bio_integrity_verify(struct bio *bio, sector_t sector, unsigned int size)
 	 *
 	 * This is for use in the submitter after the driver is done with the
 	 * bio.  Requires the submitter to remember the sector and the size.
 	 */
 	memset(&bip->bip_iter, 0, sizeof(bip->bip_iter));
-	bip->bip_iter.bi_sector = sector;
+	bip->bip_iter.bi_sector = bio_integrity_intervals(bi, sector);
 	bip->bip_iter.bi_size = bio_integrity_bytes(bi, size >> SECTOR_SHIFT);
 	return blk_status_to_errno(bio_integrity_verify(bio, &data_iter));
 }
 
 static int __init fs_bio_integrity_init(void)
-- 
2.54.0

