Received: from mail-dy1-f228.google.com (mail-dy1-f228.google.com [74.125.82.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B483D6696
	for <linux-scsi@vger.kernel.org>; Fri,  3 Apr 2026 19:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775245287; cv=none; b=lpf8HEMGwUc+eGcgeNc8FFJdfKKM4mPrQvKGc1McCrOcpYx99PVUAVXFl/rVsP0g2wLJf0xDBs//K/XSRuIgGgGxgu1cDxoA1ZgP/H3+2Isjqz/qEcJrTqpkDwx9jfVbFo2pneXHSfhzk8eakoT+8xdKuASF+AdY8F/TgKEq41A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775245287; c=relaxed/simple;
	bh=StQVmJOsIkuZMZaXOXrZ3Rg0RILGKQN07uYzkf41kBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qhvl7O/0i4yGAZhlOdcZPl65eGUn8uVr0QUJDlQd8ir7gsIWRUCGyVYexK0kMuQjMSZGM8MYXmM5tx6N+0zxChjyMBekqD3Md61KOXAVZNy/ptfkhbpM1Qc/lMNsHju6GwXf1u4xcwevhgS0cUdQLhYx7rimjTMyRqLM5h9yhI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=HaMdiZD+; arc=none smtp.client-ip=74.125.82.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="HaMdiZD+"
Received: by mail-dy1-f228.google.com with SMTP id 5a478bee46e88-2c7e5f38a69so113201eec.1
        for <linux-scsi@vger.kernel.org>; Fri, 03 Apr 2026 12:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1775245282; x=1775850082; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5OR26UHwrmX/qKb/xGTxkRmRxVQZGF/pWpTgOpuYDGw=;
        b=HaMdiZD+T89llB9XbG9YMNXsvdolFfaoxG3De0eUfa47cWS3Ai5R+Q3br2EinrTQWA
         a09nDSTUHeBaq6OcBC7jUS7NVsPkkv7gI2VQwS3TP7zwfq3ua7oVGwXVIhv7fC1TFxbQ
         c1zs5RrO/Adc49vReJXjKqOyb4nKOSlL01JJlHXs8Ch/3OlHZ4f4BEFlDiMoGHWQtWMv
         RGIpa58Lg6/GXq3oXEa3Yzk2OTqCdBbr/Fr4X/ci14XxBymNT3i3InRP9ScSUAqUPV4L
         GF1IdAc8bdQGuLf7pJ2p55GsKdHsntoanloOxDX0FnduyiKQ3vlnHJA/FovFM9QxdqUX
         YiZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775245282; x=1775850082;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5OR26UHwrmX/qKb/xGTxkRmRxVQZGF/pWpTgOpuYDGw=;
        b=rFaDQrlnuT4J0PMniAzTfwjZ8wqFNNRlhbEODGdfcAUuBF3K3sRHiElG+f+zsvRdLb
         hJogjyieUx7tHYKgNM1r4Omc/J5Ol0HWWeSiopUkQHM+3ONnxKevEGxBX7DLJqaThdWj
         rftEE1tdoLHkKM5QCcSr60OTkYa8Ue/TUMe1f926K8h0fOcaqI72T0BzAv2dFyEPyI+S
         V8kGLJkUOfF3r7SFJ8OgZWvDW0d9NOf/2vfrth1L/13sstY4KGY6+uJdKOZDbxhOz5gP
         onlYVMqs+NMZSLn1kCbn1YjG7i+xcfI2e3yH1aoxCebz803gxz+GHf0+hCzwn6J2yqSK
         GvEw==
X-Forwarded-Encrypted: i=1; AJvYcCX9riRlDrluFCTjcSDkUy73yfzf7WddgIvMt6GgAKSdNoYX38z/DabYwDIT2UH9x0l+axct369eA1a4@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/CdZJzwx6oibs7uemwkcGb+1kOmOipSNDX01Cc8eMvbXfnhMu
	+PanzbwoZrgKFaJ7D7A8wORFhU64SlPfsMdSkHsWWPPKGyAjxA0AyhvEtVgwTwLjnmqwqRYfjI6
	e5YQ9p4YSofO5E1p1b0+OUBs5bsGdNJl4A1MV
X-Gm-Gg: AeBDies3zUkqFe6lMW6EGZ0vXFlrMEbneFg/Dk8m5xDUHwZp/wTOLCoIJG5VnKOzm1U
	BjdscPJLYtU9fjtFUYejVYvPfbmhaxpsvWz2ii92+JE6bZkGWdJOlnnvVgZELVshKpHOJh6QKV0
	JZahq0D01ULlQSaUiWEuvRhOFiw9iheVkszk9sIps/Zt3cECnhfUi9F1fh5o4ktuJXF93ewR0XO
	nG1vC5zj1kn63lLpwV+raN2tpceTS65ggoawlYueE5TPY8wY119I2+cO3Jwq0bys7oFOGqfT/jP
	+Yaw/igBp1OqEq+eTNPbf2tmn/OyqVb2FeDt88V5OVgq0thPp8X0B9qeMS0j3Uz9oSHEJdxtKqH
	2qhvzwAvlzxT+ni10tjdQcGaUcC12l4/Ic3GxBiDdpDhaAcVGj5XIDA==
X-Received: by 2002:a05:7300:2315:b0:2c4:76a3:bdfc with SMTP id 5a478bee46e88-2cbf6897126mr861527eec.0.1775245281934;
        Fri, 03 Apr 2026 12:41:21 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id 5a478bee46e88-2ca7bf00671sm474049eec.22.2026.04.03.12.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 12:41:21 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 0C47D3422DF;
	Fri,  3 Apr 2026 13:41:21 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 029C7E41AC2; Fri,  3 Apr 2026 13:41:21 -0600 (MDT)
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
Subject: [PATCH 3/6] bio-integrity-fs: pass data iter to bio_integrity_verify()
Date: Fri,  3 Apr 2026 13:41:06 -0600
Message-ID: <20260403194109.2255933-4-csander@purestorage.com>
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

bio_integrity_verify() expects the passed struct bvec_iter to be an
iterator over bio data, not integrity. So construct a separate data
bvec_iter without the bio_integrity_bytes() conversion and pass it to
bio_integrity_verify() instead of bip_iter.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Fixes: 0bde8a12b554 ("block: add fs_bio_integrity helpers")
---
 block/bio-integrity-fs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/bio-integrity-fs.c b/block/bio-integrity-fs.c
index acb1e5f270d2..389372803b38 100644
--- a/block/bio-integrity-fs.c
+++ b/block/bio-integrity-fs.c
@@ -53,21 +53,22 @@ EXPORT_SYMBOL_GPL(fs_bio_integrity_generate);
 
 int fs_bio_integrity_verify(struct bio *bio, sector_t sector, unsigned int size)
 {
 	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
 	struct bio_integrity_payload *bip = bio_integrity(bio);
+	struct bvec_iter data_iter = {.bi_sector = sector, .bi_size = size};
 
 	/*
 	 * Reinitialize bip->bip_iter.
 	 *
 	 * This is for use in the submitter after the driver is done with the
 	 * bio.  Requires the submitter to remember the sector and the size.
 	 */
 	memset(&bip->bip_iter, 0, sizeof(bip->bip_iter));
 	bip->bip_iter.bi_sector = sector;
 	bip->bip_iter.bi_size = bio_integrity_bytes(bi, size >> SECTOR_SHIFT);
-	return blk_status_to_errno(bio_integrity_verify(bio, &bip->bip_iter));
+	return blk_status_to_errno(bio_integrity_verify(bio, &data_iter));
 }
 
 static int __init fs_bio_integrity_init(void)
 {
 	fs_bio_integrity_cache = kmem_cache_create("fs_bio_integrity",
-- 
2.45.2

