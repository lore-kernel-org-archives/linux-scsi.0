Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3DC208DA;
	Thu, 28 Mar 2024 00:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711586682; cv=none; b=Adg30K0eyqsCTcL1kMpq9l3nQT/Exb+exq6AMmBzrRj7Y6goERowedBcXEW/LCKQ2/ZhrcfIU6cJYtB+sagFanMR1+tCbGuPMGFYUc6/T21jSeV7y1SrYEPwH25gU+bbYbR/VH2zqKtISqRZwcVbhQoDCLUPov2By8P3GxMHmhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711586682; c=relaxed/simple;
	bh=ODVsC1HbJGQ0xy47J0sOpPmNReTkb8nd71OLgnXHrrE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQBDXF/tEvpN2v5tqlNuj3XXKhocqrn11AgBPbVUy3UJSB2CkEgfzkL6+1B0QSAvDfzKCeuce6WFCJovIJJhXMZQkFdEyXdGbB5vcFgwrTGbqsJnr9gwOygma2vwuxrCQQ5Ioile8mrLv9M4VsRInnCEi3AYk2IIor+yN6YS6n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UIkvnjQ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UIkvnjQ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF37C43394;
	Thu, 28 Mar 2024 00:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711586681;
	bh=ODVsC1HbJGQ0xy47J0sOpPmNReTkb8nd71OLgnXHrrE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=UIkvnjQ+Pd78daqoPK8zTOCSuCDb9ZHi6b6VfFk7jQYwRd7aGYQy3QEGScqHjGiPX
	 YpYxpKhaYhCX0JDi2SucOoCiHGoS8gy3HMw3IeS6dxVzrkvscjE95p4GUhlreZQWCL
	 gerIM8++teBXw4aUsDDg7px/c/LJT+I3DfhmQPtmQjN9COOgtqKkM1qoBs+sescz0g
	 1lF9oe1N7wTtRY6RPOFzqDCiQ6CcKRgIAoCvXgoqu5tVNaJdLYbxQWuHn5iASwpuSI
	 Y1CQsXxmmdy+I3Hhk32FzByrodxlWslltPnhzmwElG0E8CTNSs7kaXe8f7NGgiBSVu
	 TOEhKMgjTjMLA==
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
Subject: [PATCH v3 16/30] ublk_drv: Do not request ELEVATOR_F_ZBD_SEQ_WRITE elevator feature
Date: Thu, 28 Mar 2024 09:43:55 +0900
Message-ID: <20240328004409.594888-17-dlemoal@kernel.org>
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

