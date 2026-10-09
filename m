Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0084B49B1FA;
	Fri,  9 Oct 2026 09:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791536996; cv=none; b=a78xtp3VqAIqg2lbr6h49ihOg9LaR+TYgR6s8/ntIroyckGBwuJOQAEoo37Re7qKSqhGjWpakbV3K2RR6cP4tvAPtPWbV9ovVRY7pWptbXqCn6u93sjhgvOjzN4gtlqDyLvEX34Hh1NbOOZuvxYIq3m6h1CIarLLsMKvhwqgKuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791536996; c=relaxed/simple;
	bh=CYcwp5ct27JXZdB3Qjh0hLrp2Pog68ijytQEJ2hrwcQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lFVzu124Yswbmege3IIyisFgPDXMsh1aL6b4eQe6nVUd90gL5oXJrJALjOHemCai7esnese8ioE76BkaUOgKDvVTvzF8ZlIT4ZuY2wSZ1tPOFoibLMZRQQ9G7Ecy+gbg6eASGU+MpxjbUE2wev5hmV+jd/rPVBSrktJ+EqafM7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JhzLiI+H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JhzLiI+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 344A61F000FF;
	Fri,  9 Oct 2026 09:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791536994;
	bh=F8wEPBt7dkzOONQpL7ArVlmAXcu2szwHJPCj38JTAYM=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=JhzLiI+HtBXj2WeEVEBA2ZaXp0atFq8GlsBhatX0Ae7LJeg8dOrUr64f/76uG94RE
	 QwNuT72hcwvR7ze0A+LCoFM+6wVDJsv/8eAzQJ+i6ZMmnTPEDjnbM3ChT37o5Pbh1u
	 1Eg8g70r7tOgTZf5iHSpt/gL2qBQgG1Chj94QXMqdxov/QcC0TtPxQVUiv4qAkEueK
	 3Yl+fiIDX6YXkR/MixOoDxN6BU0MzPpl8em2yCJIn9aE8eUlOVtnGxvW1Ya2OKB9y3
	 F7xMDYeW5tZ167eq8rQRx+EX4rWDra52mhcjHWoEhFpdBObpS1TyJXSHDswl6HDziy
	 F9XPyIL/XBfoA==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v4 7/9] scsi: sd: fail read commands to offline zones early
Date: Fri,  9 Oct 2026 18:09:43 +0900
Message-ID: <20261009090945.1504194-8-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261009090945.1504194-1-dlemoal@kernel.org>
References: <20261009090945.1504194-1-dlemoal@kernel.org>
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

