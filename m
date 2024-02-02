Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A6D18C36;
	Fri,  2 Feb 2024 07:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706859080; cv=none; b=iQX4w1FK/JtrCkggdHWHA0F5HJYFboXFNq6J8IXaRIlP2YgQq4ECkps9xsybEiMteYr8Fni/LhuNHRkUrEhUlzxJZDX+mEHE4zz62zG3BhMpyBmEvTeyOBKCX41O8vTj0/okm5t28FC/ZE5Q8hwbjbXTvHGDBN9QQ05iJndJ7xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706859080; c=relaxed/simple;
	bh=3FNfIamjgU+K2ag+8mJcQ9Cg1ujx30ixRmzCBzZD5Zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZUgXvZ1I2HD/WI5FU6V/gKwcmSrNIcVM9dM6uDBnKnNevMcmx3xoDrOmhEwpQmg7Ue9vZVqjVWBEjQRO2zfADlccDOI4x/my20EkMLcMmIt2Y4Tjq6c9hi8Y6tEZ2+2T3UK4B1n3/1y+FI2XPwb03fZLDzwx0i2ef5MRh4P5ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lt2F+J0l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lt2F+J0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1809AC433F1;
	Fri,  2 Feb 2024 07:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706859080;
	bh=3FNfIamjgU+K2ag+8mJcQ9Cg1ujx30ixRmzCBzZD5Zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lt2F+J0lORsmWSkUicjsgpW5wYQrwdQLxH/BgyfnGl6wJKa4dbO521nYrWkGDGc5n
	 manfN329trgmKe5Kia+YX7i2+0gw4coLNLVmJVwiAgeIt9+H55yCZW6gNqchnRqyUp
	 ysAdmx/vRVMBk7Gg4NvLp/WUKBuGx9xx8nSnNhXLaq1i7SxAUPIpFoL22exHnvMZOH
	 q6VCMenIJiyRiUks6Q0DD2ldJo/VwKYxZ4BfBvm51ScrNFTWy7F0NElSxNO/sUGsuG
	 bbya0DOrjz6Mrb6GkNOF5pNiUuPMm8rszIW3hbC9om87cLu/4Vqc6L137pmY58Uehj
	 Qhg+Fn4PrGasw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/26] block: Allow BIO-based drivers to use blk_revalidate_disk_zones()
Date: Fri,  2 Feb 2024 16:30:47 +0900
Message-ID: <20240202073104.2418230-10-dlemoal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240202073104.2418230-1-dlemoal@kernel.org>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the check in blk_revalidate_disk_zones() restricting the use of
this function to mq request-based drivers to allow also BIO-based
drivers to use it. This is safe to do as long as the BIO-based block
device queue is already setup and usable, as it should, and can be
safely frozen.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-zoned.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 929c28796c41..8bf6821735f3 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1316,8 +1316,8 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
  * be called within the disk ->revalidate method for blk-mq based drivers.
  * Before calling this function, the device driver must already have set the
  * device zone size (chunk_sector limit) and the max zone append limit.
- * For BIO based drivers, this function cannot be used. BIO based device drivers
- * only need to set disk->nr_zones so that the sysfs exposed value is correct.
+ * BIO based drivers can also use this function as long as the device queue
+ * can be safely frozen.
  * If the @update_driver_data callback function is not NULL, the callback is
  * executed with the device request queue frozen after all zones have been
  * checked.
@@ -1334,8 +1334,6 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
 
 	if (WARN_ON_ONCE(!blk_queue_is_zoned(q)))
 		return -EIO;
-	if (WARN_ON_ONCE(!queue_is_mq(q)))
-		return -EIO;
 
 	if (!capacity)
 		return -ENODEV;
-- 
2.43.0

