Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199FE3164AA;
	Mon, 12 Oct 2026 13:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791810093; cv=none; b=f8gOfCa6G1ph3xMWVKLCTxh/czw0cGj5Wbpce3fqx54I51cEYSVZuLH2Kh/Tv+MD0hw7vkuOa8QyyhiVX99RY8kKjEZySEb2ek67JJufnxQZ/knrYAakhrdhPyADYQwmfMgmO+Mq8H0h4z/nqJtSvJwpXZc4/zzf0ILTWM2tfS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791810093; c=relaxed/simple;
	bh=CYcwp5ct27JXZdB3Qjh0hLrp2Pog68ijytQEJ2hrwcQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ceTQLAWQevdAEPchmuaEV2oaGnEGS01Pw5zNv4ebq7NqU7S9MEheBhINN1WJmzUhqjxAsnAXjr3bQosfxL3+5/zjSE97yGKddXQqL3UWJU3BycDK6Y/AOuvbrFzMgjmkSf3xqJwAlduV4ywDTsJLy3B8GUcs82YJKdEN2lv/m6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i8kpuhbI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i8kpuhbI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D761F0089B;
	Mon, 12 Oct 2026 13:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791810091;
	bh=F8wEPBt7dkzOONQpL7ArVlmAXcu2szwHJPCj38JTAYM=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=i8kpuhbInRlhwRCCDa04qaP8rsaYpBf6vNw+QCjBqPKeDlUB7LK4Y/CC8j4EUWtuj
	 rUDmhpkUpfSaB53J2stJwvAdVP5T7/qgoSiOIbngAAv2ke4UZXRdkE9c+eLmJUFvFh
	 qoLZM8WBWIAhqSUy5S1A7bCXxQQs/v7duz8U1//BwvrggVoPmki6TAbJgsJ0d9ZExu
	 aFaKEgomwzLP2c3Q74N087d5s+nz/fIx8CjhiPPn2cuhuPnkFxvb/MUIGxwdaVaj+W
	 ZIHYv5fj8tLvf/UhvIkJY1YvPSLMAdcjXHmKkYG2kNj3L+2rG1Mv4OA0z+IM2tQ91V
	 zghtnM5ekN4kg==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v5 7/9] scsi: sd: fail read commands to offline zones early
Date: Mon, 12 Oct 2026 22:01:19 +0900
Message-ID: <20261012130121.1902634-8-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261012130121.1902634-1-dlemoal@kernel.org>
References: <20261012130121.1902634-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Issuing read commands to offline zones of a ZBC disk will result in
failures. So do not issue such command and fail then early in
sd_setup_read_write_cmnd(). This change also checks write commands, which
is fine but should actually never happen as the block layer zone write
plugging code already fails write BIOs to offline zones early in the
submission path.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/sd.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a1b21ea14e54..db7c19d1c2ff 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1424,7 +1424,8 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 {
 	struct request *rq = scsi_cmd_to_rq(cmd);
 	struct scsi_device *sdp = cmd->device;
-	struct scsi_disk *sdkp = scsi_disk(rq->q->disk);
+	struct gendisk *disk = rq->q->disk;
+	struct scsi_disk *sdkp = scsi_disk(disk);
 	sector_t lba = sectors_to_logical(sdp, blk_rq_pos(rq));
 	sector_t threshold;
 	unsigned int nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
@@ -1456,6 +1457,11 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 		goto fail;
 	}
 
+	/* Prevent read/write to offline zones of ZBC disks. */
+	if (sdkp->device->type == TYPE_ZBC &&
+	    disk_zone_is_offline(disk, blk_rq_pos(rq)))
+		goto fail;
+
 	/*
 	 * Some SD card readers can't handle accesses which touch the
 	 * last one or two logical blocks. Split accesses as needed.
-- 
2.55.0

