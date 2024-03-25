Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15B61C323F;
	Mon, 25 Mar 2024 04:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711341926; cv=none; b=qFFslc3PtH6eBxYwVm+xyPNogQ4YPPcBabd1PtWaEinjvWgwSl5q6c5E/dOj2twCbvDqy4VQjfjEFTX/JB0wd1pw3WVXw8sWko97PUZlBB9qeZEUuguRegMSQoIGDXSEz6XQ5+eHv9XgnIYctsvvkN3lKtirc5xu3KMiwHWnOkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711341926; c=relaxed/simple;
	bh=ODVsC1HbJGQ0xy47J0sOpPmNReTkb8nd71OLgnXHrrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ACaZ7KiPwQxbFY9UT1NAz+jOuF+PrHzrUfgnR0R3y3eWqvVX+68lAwmCOHIfls8H9vLIvjRx1hwGScNn1GZ2bGuPnF1BUIsx1ssV7kHlhJQ35Ij/aUXZ6FyJWGu3d2KM32ax3ZCMqJt90tttBv/3GqUOHrgGi3pfRSf7f1Bvc9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s4PBTt8f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s4PBTt8f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8189C433C7;
	Mon, 25 Mar 2024 04:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711341925;
	bh=ODVsC1HbJGQ0xy47J0sOpPmNReTkb8nd71OLgnXHrrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s4PBTt8fOT4OcSqrgbuY3Lgpwf4fY7mx2przGOTa+NsHGNdIAwGS1mcYsbAIzN5vN
	 +u/zbmgm4SGJDIcTt/RnCWn1zFG9UZuhsU0o0Yq4sEdTVQnuAkT3j5QNfKeprLgAqK
	 tKm3HJdBru0JQGlAc8fnEX0V61nIiSG2az/Le8eNMJSD/2pbAd9t+qr5zQNlPIRMjE
	 A152A+zsH6kV5KCzQBTfRwV4zGDNIKKgRG5ICuKBmZe8jWIrzo9q16YxCga6ygH+Cf
	 L0+4pTtOeocpB66KnweWUYozKU41kexCWw23j9fqBoYpVVY0dPu85SrogBoTeuREhs
	 otucYyQxMjxkA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 15/28] ublk_drv: Do not request ELEVATOR_F_ZBD_SEQ_WRITE elevator feature
Date: Mon, 25 Mar 2024 13:44:39 +0900
Message-ID: <20240325044452.3125418-16-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240325044452.3125418-1-dlemoal@kernel.org>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With zone write plugging enabled at the block layer level, any zone
device can only ever see at most a single write operation per zone.
There is thus no need to request a block scheduler with strick per-zone
sequential write ordering control through the ELEVATOR_F_ZBD_SEQ_WRITE
feature. Removing this allows using a zoned ublk device with any
scheduler, including "none".

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/block/ublk_drv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index bea3d5cf8a83..ab6af84e327c 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -249,8 +249,7 @@ static int ublk_dev_param_zoned_validate(const struct ublk_device *ub)
 static void ublk_dev_param_zoned_apply(struct ublk_device *ub)
 {
 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, ub->ub_disk->queue);
-	blk_queue_required_elevator_features(ub->ub_disk->queue,
-					     ELEVATOR_F_ZBD_SEQ_WRITE);
+
 	ub->ub_disk->nr_zones = ublk_get_nr_zones(ub);
 }
 
-- 
2.44.0

