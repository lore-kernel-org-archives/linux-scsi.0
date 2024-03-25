Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3488D1C32A2;
	Mon, 25 Mar 2024 04:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711341927; cv=none; b=V/FfkEt0Z2ytUDJZpOontyLCDYIAvweQ/uQDiM9CSj0aARzHbFiDFRkGEvxw5K2hUcoaPPNXBhvA90OaNLfFAhncdD6NB3MSRzw7NHJJDWcuksaU5yIlp5M8xbQun6Jfo/yttjZ5FlTnxijII8Ftt7KXMmRSlq+VaT4wQ+FpBw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711341927; c=relaxed/simple;
	bh=qoEibzLZjgtTKtSOz/7gZtcAbueqRKkO2g10bjgbvI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FcKY93Ez4XQgSjiNdzIBYPYt9ud9qZdd73SDlo9SyiQ8g1tphjnVi9CIWNAEZ6qB839HGJHTdt/LHecJHeVEgG0I1HHOq18fZGEUMY/fxOR/pLzKaySTt0TBUgsHVWsWE/D/Wz9S4hZR4MY/hM6YF5Nc5HjIZizgp2pN7/JB6N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TkDWynDa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TkDWynDa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3607C433F1;
	Mon, 25 Mar 2024 04:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711341927;
	bh=qoEibzLZjgtTKtSOz/7gZtcAbueqRKkO2g10bjgbvI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TkDWynDagp4tWvq/qsONeOgOoBKiQPUZA1vLGZDaY+MI5Tc2QMlPAthOAzNESio9J
	 bmFAKmCgMEgzZOlfE9bcF14D9sCUahpb/xn5dmtaqRtRmFTNeHkLj2kOxDlOCa+jEA
	 z+bjVlyQ697G44V4G9rYP0SqlxLx6a+O8nNsiWr359TLJpvGrLu2SCL1cNEXibY3FN
	 x/4uW2b25C0wP9a0vNOLVAocOXUCXDGVxtdstpkaG3p3xae4N8XuCzHWicseOebQUU
	 Dbj9ZLMWvderdqYPHveHEqq3LHY7RQQ86QC99Up10YuI3wAow3+jr7DVWN+lfym1Zv
	 NKSdFuN6jEKVA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 16/28] null_blk: Do not request ELEVATOR_F_ZBD_SEQ_WRITE elevator feature
Date: Mon, 25 Mar 2024 13:44:40 +0900
Message-ID: <20240325044452.3125418-17-dlemoal@kernel.org>
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
feature. Removing this allows using a zoned null_blk device with any
scheduler, including "none".

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/block/null_blk/zoned.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
index 1689e2584104..8e217f8fadcd 100644
--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -165,7 +165,6 @@ int null_register_zoned_dev(struct nullb *nullb)
 	struct request_queue *q = nullb->q;
 
 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
-	blk_queue_required_elevator_features(q, ELEVATOR_F_ZBD_SEQ_WRITE);
 	nullb->disk->nr_zones = bdev_nr_zones(nullb->disk->part0);
 	return blk_revalidate_disk_zones(nullb->disk, NULL);
 }
-- 
2.44.0

