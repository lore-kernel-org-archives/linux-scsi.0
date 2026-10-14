Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A09E414412;
	Wed, 14 Oct 2026 05:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791956029; cv=none; b=jI76cDTFkPBvTSRkTarLef9HuuY7AH8BTRr1xAaSTsA5cTt2LRSNRilGDBjk+Sqe2BCgexWOiGqAbZXsBoyEJB8NcXx+sWx048DY76n3vfAu+YnlqWPVZPDOb96/GOU3QEcN+VZds9pugnzCRdMDPx/Sz7WRSuPngw1JKYLx3f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791956029; c=relaxed/simple;
	bh=gas4tmAo1mG/8El6XGHsViJU+0mleL1jmhBQ0pqAHBo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tMJk87fk0WQ3SvmJcQt29iNLzmYirKwCq+vNesLDPAj9MNR3/eHTf0DOPctycY3m3ltGvUQXRZleqFXBfMpXHd3vF8uuBS1+cAzfak5cm/scgct0JcH37BpDgKvsQglFSOfVYYj1knHF4Rsei+IenFSm8lTv1G5Ml8+2DGJ12Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bhYl+hyo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bhYl+hyo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0DB1F0089A;
	Wed, 14 Oct 2026 05:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791956027;
	bh=7FzShNPCcGaSQ1LNpGKyCNV0/TpMAcUqeqZKkQaG6g8=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=bhYl+hyoGozWN/PY6X8M+DSyeAja2Vc01wJmSJ6LXNRPLtvUadtjui4ENEcb0oe1k
	 jGJhON6OSxK6tVbWp4m9Pamcy5JSEjgLeQ84J4vqIXgWVRuWOvwUwlwT9DmE2BYfz9
	 xfxminCEEEqySmMJtsntUZsCPQrHxcJrjGhbvUkLBjyCbuGab02NDZh41Vvcm3yBco
	 xO0wzVapuYzFkrhG4d0rL4Y4VMEYkQClzSAZk40TlcYu/7GCglnWSOjgjoX0VdqEzj
	 sTv/q/Qw8ginIqOc/Nz7/rtGdmU6hC/ZmJhDLffERCWFqPoR+iCxwWCKGyOZ6T42AB
	 SSsqquXaEwQUQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v7 08/10] scsi: sd: fail read commands to offline zones early
Date: Wed, 14 Oct 2026 14:33:34 +0900
Message-ID: <20261014053337.2328544-9-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261014053337.2328544-1-dlemoal@kernel.org>
References: <20261014053337.2328544-1-dlemoal@kernel.org>
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
Reviewed-by: Martin K. Petersen <mkp@kernel.org>
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

