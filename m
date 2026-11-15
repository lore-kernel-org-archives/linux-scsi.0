Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794785623;
	b=M/+Due8J9hUd3cm6h+KrOS8OpcFaRRZQrPWkTSWPKxPsPMMhT2kXI7ZGPT/rSa+bWPit
	 NLQefkeFehRwaPKzazeof1UMMmM1YhNVLMeuFTGoBnhx4MdScyxxksKKciwPZ2hKDQzpf
	 RmbkLAW1fWfBHbJ2+3SpBURItGtR+xlUeJTBB9fUB3DpK23WDSiKndxLumnp8HiJ7qzgC
	 psdKtRevOcrbfEuEnNcNz7m62e11dJ9iCr8W4e/qyI2v68rubLYsqqSbH5vDT0VNYG9NG
	 UM3oHEzJ6Ji/swQ87zahBrWvjKPYkseNgxBJ3GkVUWPflNMoC+xAZuHUbpk4EqxGmTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794785623;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=bVr5tuS7xh2PYiaNEswRMPU76wRqKv1igzs8AyprowU=;
	b=Pew7ZhEoqQarfbFvVH+v7JUY5G8cbDQulUNxtdLb/eBSKUDg/9nrmxaDSQK6wNfJaXfe
	 KvEQpMl/zuqDQK41Nx8dqgpBCJts5GwJ4HyV/V6JXpGTDLXT4qR/yXV8ElUtUXh1QeaQ1
	 6uW+UJkR+phNfTMno3QsKKq6pHhdXKj27eRjCSTY1iqL39RFmf/r3bKSA2jhcfzLto18y
	 BTK0TtfMm5v6lyaQ6NbLF37frneQwovzCKcC1nN6mqLZtmi96pqoO4y4ARjLi1Roo5iqc
	 unqKVSOZG1AGVOMJEtjkQQWYS6eL+eA3VDZgIPjsRkpfs2NhTDQZftXlZ/ZdVuv4VZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Acmh/DLN";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B305B606A330;
	Sun, 15 Nov 2026 23:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Acmh/DLN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79731F000C4;
	Sun, 15 Nov 2026 23:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794785623;
	bh=bVr5tuS7xh2PYiaNEswRMPU76wRqKv1igzs8AyprowU=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Acmh/DLNQED+Td1KSP6EYkvlYBKFgMhU2eNJ0Ph8JYs5I99po+huvVr6VYTW49MvX
	 JgXOlxayxlCiqM01RSAicPMwQ9L8RU5ZM8uEuf9tHc0NxjCWcjoobMPR+ZZ+9d6RQD
	 MnxpGUG1zH8nSMx5sis2wx5GwtcQk9/ez5qINAnXPBlDInxJ4jP623eSZwv7r1mIDx
	 TbTTuG6jLEY2Ri0Aax6qSLerOEnZE0yJcDmEob2/1Gmp6dbmY6Ub+m5yehiUv9Qx8e
	 6TLRn7jY9/ldIfjww90BOiFXguEhEl8CF7ZHlCgejHUaJcLGg2LpcOqMN1TN0ll4D7
	 88YVrjfOIU6jg==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v10 13/13] scsi: sd: fail read commands to offline zones early
Date: Mon, 16 Nov 2026 08:33:27 +0900
Message-ID: <20261115233327.941586-14-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261115233327.941586-1-dlemoal@kernel.org>
References: <20261115233327.941586-1-dlemoal@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Issuing read commands to offline zones of a ZBC disk will result in
failures. So do not issue such command and fail them early in
sd_setup_read_write_cmnd(). This change also checks write commands, which
is fine but should actually never happen as the block layer zone write
plugging code already fails write BIOs to offline zones early in the
submission path.

As the code comment explains, since disk_zone_is_offline() uses the block
layer cached zone condition, this is inherently racy with zone
revalidation updating the zone condition. However, this will never prevent
valid read operations as the only case where we could proceed is if the
read is received after a restoration of the disk storage element completes
but before the zones are revalidated. And in that case, all zones are
empty and thus have no data to read.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <mkp@kernel.org>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/sd.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 34b44d72b2b7..8b1c05de541d 100644
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
@@ -1456,6 +1457,23 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 		goto fail;
 	}
 
+	/*
+	 * The block layer already prevents writes to offline zones of zoned
+	 * block devices. But there are no checks for reads, so check this here.
+	 * Since disk_zone_is_offline() uses the block layer cached zone
+	 * condition, this is inherently racy with zone revalidation updating
+	 * the zone condition. However, this will never prevent valid read
+	 * operations as the only case where we could proceed is if the read is
+	 * received after a restoration of the disk storage element completes
+	 * but before the zones are revalidated. And in that case, all zones are
+	 * empty and thus have no data to read.
+	 * Note that we are quiet about the error (no message) to avoid flooding
+	 * the kernel log.
+	 */
+	if (sdkp->device->type == TYPE_ZBC &&
+	    disk_zone_is_offline(disk, blk_rq_pos(rq)))
+		goto fail;
+
 	/*
 	 * Some SD card readers can't handle accesses which touch the
 	 * last one or two logical blocks. Split accesses as needed.
-- 
2.56.0

