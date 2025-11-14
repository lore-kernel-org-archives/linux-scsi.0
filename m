Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F122BF015
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2025 10:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763116261; cv=none; b=KFXQreXEyv2eQkzqVWt690wKVG+anMt96zP75I/tnzJlJ1R85CE5xYgsJoZmaZqeoL9yWywyOpWffJqufxDf74da7nJfx/Kx/GMlt/IdEoqqz9+O4crjx2T2o4wsF8NN3DYetozOkXzRjxfjHOxb46jCcolSR2ftJb1r3YMiRbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763116261; c=relaxed/simple;
	bh=BGArzVbYYvuT0tyuLp/duXmRuMZpbDCft8M0GUCbSJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b8MWZuxXB9kxYtqJdtV/psieZvwmrrpck97A/fGOpMhusopCnJKd6zlvZrA4F9Xznc1KWyXrJtlbq5MdrHpNAsojPSEDrnbyHzMltWUR4m93Ecb+sWcexSzRalmaxaBjaVbaAFROn25FCfxkD7kKKXkasOgZhHZsBqRhF3xz3tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id D0140180F2C1;
	Fri, 14 Nov 2025 11:30:51 +0100 (CET)
Received: from trufa.intra.herbolt.com.herbolt.com ([172.168.31.30])
	by mx0.herbolt.com with ESMTPSA
	id uCL9D8sEF2ktxDQAKEJqOA:T2
	(envelope-from <lukas@herbolt.com>); Fri, 14 Nov 2025 11:30:51 +0100
From: Lukas Herbolt <lukas@herbolt.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	Lukas Herbolt <lukas@herbolt.com>
Subject: [PATCH 1/1] scsi: sd: Rounddown host->opt_sectors to logical 
Date: Fri, 14 Nov 2025 11:28:55 +0100
Message-ID: <20251114102853.1476938-4-lukas@herbolt.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251114102853.1476938-2-lukas@herbolt.com>
References: <20251114102853.1476938-2-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The host->opt_sectors are by default 512 bytes aligned if we have 4KN SAS
disk reporting zero or smaller opt_xfer_block than the host->opt_sectors
we will end up with unaligned queue_limit->io_opt.

Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
---
 drivers/scsi/sd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5b8668accf8e8..382474c3555c3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3787,7 +3787,8 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	 * an impact on performance for when the size of a request exceeds this
 	 * host limit.
 	 */
-	lim.io_opt = sdp->host->opt_sectors << SECTOR_SHIFT;
+	lim.io_opt = rounddown(lim.logical_block_size,
+			sdp->host->opt_sectors << SECTOR_SHIFT);
 	if (sd_validate_opt_xfer_size(sdkp, dev_max)) {
 		lim.io_opt = min_not_zero(lim.io_opt,
 				logical_to_bytes(sdp, sdkp->opt_xfer_blocks));
-- 
2.51.1

