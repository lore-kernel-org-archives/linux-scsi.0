Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654022E631;
	Fri,  5 Apr 2024 04:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712292150; cv=none; b=KHpP/vGPGTF0J1RHNn2BOgxxuiUoSk8+v5jlJ25S1arKmBnuH9YL2iShhaSEkaLMgX2mmVcdhFTrqAayJbfqlXoxOOb2BZwmKcq+0p/o89tsyuEWL3szvbSwClEQUve+1Lk0/Nj/rFl99QFwlOx4VFbCh5ixvhQrfNFtZYM4TEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712292150; c=relaxed/simple;
	bh=+UsofTSRNCMlf94NYmjkPcbpOdXaDsiqajIToD4TkE4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJ6JLZUwd4xWkr59ugvuOEz/g9kEBJJ0Uhmv6Tvq36+VZrUNp57EBZsPoyJ9GtBo7v0JR1PYdbd0IV5Dci3NeojEI7egY+HXptGeh1cPwdTc1bORFeLPUC4V8HeTPfJBz9fK0P71L5JcMU23VPhFE2wIA32cXI9OVBDuftrRJxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ta6cMJY/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ta6cMJY/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21FB0C43390;
	Fri,  5 Apr 2024 04:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712292150;
	bh=+UsofTSRNCMlf94NYmjkPcbpOdXaDsiqajIToD4TkE4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ta6cMJY/NeXh0miQ+0OY7xXqshJoVs7GaZwqlNfiLa2Vlg4jrGn5LSQk5N+Fo+JWc
	 vwgBpDzCnEb7SCfdG7EgJLtObZtbb18mc+7Oj8Stpn+mgusx36Zp9/9SQOaTYQridY
	 X2AwvsuSkv8zX7PZCJI/w/m0qiiWtda5MW/HcEkkrJK08SaP9UXUmOHq1HbhyswylS
	 jgmnISVcAnfvflk2n6GkTCp3QZiuhgIDjZJzQcYcySzt/TASGdfDLsYKmyBhUcgmKN
	 CrIqTeRN7GcqBY/pBaFCUxtdgp0XcaA1uyiHWoq1GITf3n4LlQ4z/Rn9IVAxTi03Ec
	 SdKlkHettNYdg==
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
Subject: [PATCH v6 14/28] ublk_drv: Do not request ELEVATOR_F_ZBD_SEQ_WRITE elevator feature
Date: Fri,  5 Apr 2024 13:41:53 +0900
Message-ID: <20240405044207.1123462-15-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240405044207.1123462-1-dlemoal@kernel.org>
References: <20240405044207.1123462-1-dlemoal@kernel.org>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Hans Holmberg <hans.holmberg@wdc.com>
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

