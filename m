Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B339208B0;
	Thu, 28 Mar 2024 00:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711586683; cv=none; b=rcfOCgcR69cg08hRBlpPOR5KVkHEwqkO8/4VM9QRoCJLyuFpdiyjdkRyTsqhDKpfBQfuSlPzamNNLn5S6BnfzFV3EFeAz0EUiW7G/fv5PmAma/bAnNrmA3W2ZzkL8cUkGc0XTLubrqYIAPfYjTZ36HebYt+CjKuPjRPYixkZRnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711586683; c=relaxed/simple;
	bh=qoEibzLZjgtTKtSOz/7gZtcAbueqRKkO2g10bjgbvI4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXPKlQi6HcWKtjpD/x1gGqRvvlinrCMQ2sTJZ5c8/4ff1sQo8VMkl6GTE6SYn+yYN2TyS6b0cupeJekhY0YCBJipQTAZwd0Mb7dDBy4eK0NY2Y563qCIzFXk1EVW2XqNmNHj2WQcxRe/OYcN8t0aM4bH8zu5OJWRAnroP2JcphE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qwFl8Kq3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qwFl8Kq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF73C433F1;
	Thu, 28 Mar 2024 00:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711586683;
	bh=qoEibzLZjgtTKtSOz/7gZtcAbueqRKkO2g10bjgbvI4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=qwFl8Kq3/2IBpoe22HUbHBJaqbLS/L5vqLLZnaoQaLQfXZ7DHqWbV85dPXn52DAx8
	 ruowiPjLPpeJ0pXpzm46d7GuGxbJuRLjPzZJ+RYsKCIc5esfVYCLdtuFd6FHvAe0pc
	 Sc5FOW5V7E+yz16GrrXVrlnU57VNhnCQDBN05Tbj5jVvvDul1g7FylVOayZ4YSS6pA
	 DKMDewpWm1ojABxzQjafOZYrrnlmAMf+wHKZI/vVWxcEWn7B9btZYWk1A33KjQ/wgR
	 /sWANfXdR0E9feUfKNfhuG0Dfg3hnj0ZbBqIWXzUFrBSODE0Cszx6EhUGdBSHIonbT
	 SLTWG0dUAqS/A==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3 17/30] null_blk: Do not request ELEVATOR_F_ZBD_SEQ_WRITE elevator feature
Date: Thu, 28 Mar 2024 09:43:56 +0900
Message-ID: <20240328004409.594888-18-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240328004409.594888-1-dlemoal@kernel.org>
References: <20240328004409.594888-1-dlemoal@kernel.org>
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

