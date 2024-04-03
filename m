Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5730B7FBD1;
	Wed,  3 Apr 2024 08:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712133792; cv=none; b=OU18S1ASFuiPWCpiNOgOgOCIgWCRm3Gl2Dktxaw0BTKvg7l1PHogMHog/eb5NZ+/qFtlGssKq2R6to8YLocL/5pGpWxuHWHdWzSvifJyIQ9p9GttGRF8v3tLP89ccFNSJPuMvADPEho4G88f+3jrqfex0DT9EA5V42+mxa5L69I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712133792; c=relaxed/simple;
	bh=nMry4ZEBzaq6P0CgjEd5nmJRTc+Xolb7U7Xwyyw7OHM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b1Xjb1jRXwlp5z69xTDxnvE+7+2ouNlO3qbaVSPfUJfi805nx98jWQhbf9cythTkRXRMwXPQeUypJ/mnCcvaYXRWHWM/kRgrszFvRNa8ultvE0obyX7tu9CXvpKJZ5VhG+3OVY/osKlvXDMwc6cebBODHVvsriSchrdLlB0UofQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zcf1z/Uk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zcf1z/Uk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0058EC43399;
	Wed,  3 Apr 2024 08:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712133792;
	bh=nMry4ZEBzaq6P0CgjEd5nmJRTc+Xolb7U7Xwyyw7OHM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Zcf1z/Ukvtla+eOroIGLzhmvlnYBn0Y8ngI3ICt8I+myvs1MfIltt7Fi1VenfBfXT
	 FTRDIiMd5TuNGkALSXO6hdeQ2MU+ZPIZC0fu+Fos5y9Qx4HurmP+hI3yeVRiyOqhjc
	 OhORF0aHE89c5eLkFpSaXmdqsQuGOM9Rj9SkkpBVvklRLX8YLFsGxGgIGsyp2voIFB
	 isLR1gqnV8wbbIunN2FDUhAAQLV/00PZH/F32SGYYCM0Mxk7DOC4l9sMLRe2rwcsxl
	 /o+D5TqO/FgJ0E5rZ/M+o419Lz3iXEyIFvNZygPy8ZUcqwpR1GVaofeEg+mxAnBVz7
	 R+v2xU5TZLjKQ==
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
Subject: [PATCH v5 14/28] ublk_drv: Do not request ELEVATOR_F_ZBD_SEQ_WRITE elevator feature
Date: Wed,  3 Apr 2024 17:42:33 +0900
Message-ID: <20240403084247.856481-15-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240403084247.856481-1-dlemoal@kernel.org>
References: <20240403084247.856481-1-dlemoal@kernel.org>
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

