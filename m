Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D4A4CB8A8;
	Tue, 13 Oct 2026 12:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894483; cv=none; b=Ft65Z4yrkhtefvq4YRwbKeARpCLTn3a4Vv8sxw0I6dhd81tWGkcoV7bmWRBzGXSNmSB3tU9cq78kb3+qrv5JrSmrGVL4th+LWp8ZlX2GE0YxXxG7PmI7xqtzMQ+zgw5KhxDn6RIJe7KTp/PBj4paQAMBruihZFetoP27aRkx/d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894483; c=relaxed/simple;
	bh=gFceItdXoGhmNsrSd0N8hmiAI//PagnXRvNEdU/vSVo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZSNQph4TvyuVuOpXTJLimJ12Puju6blt730rWA0Ol5dmriQXFe1QVBphCI1mrIgz4ReCIH1ivunYlEpE+JcX7pxbeUdf7h/v4EUsUkEGBf0j5aKbxQIpBmkZWQz/NraneVSLXxoDiFDe5sviDX9UQDHa/iqQ44kS2UPhwKYbvfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=imQL1Wd2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="imQL1Wd2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1071F00898;
	Tue, 13 Oct 2026 12:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791894481;
	bh=jn1U6cMu9KOvJEf/qNJctsJSWtSdEDpO9pxDP/Jj/d8=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=imQL1Wd2mY6uKN3CQlE2UfmUin2bhZQMcUtR4cxHKGzM/EGD+OjTKM8rdhrf0g0iy
	 RldGULcfuTer68JEWpAwHdJxqLyk0PuYx4DAmw2q1HQlRFNm0t69zznsaOriwzuwS5
	 jFiJUYIyuOtEHN+5Iw2ItiL5gzPzA/ZIvF9/mcgtQSh/S95pqd8PqSl5DDeTmmdBri
	 VkpyjK0SfC8jlCz+9f4p9aZHvMIBZqrtcGj03JPefg96XFsLhiMw/BbLfnUHYDOuYC
	 0ijtLu2SA+DeD8ALRNHTMetxJLY4LdsWvD3cDpvozmADalZMFpyR1v6DAWWH2KtejO
	 S1bYDCUMc0CQg==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v6 08/10] scsi: sd: fail read commands to offline zones early
Date: Tue, 13 Oct 2026 21:27:48 +0900
Message-ID: <20261013122750.2237843-9-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013122750.2237843-1-dlemoal@kernel.org>
References: <20261013122750.2237843-1-dlemoal@kernel.org>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

