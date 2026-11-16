Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794865039;
	b=Fu9tsnEy5/HYuqGjZXT/V5Ct2ufYlT9csZSrYPMIhW+QBMf7rzARyOvUe14oejnrCi+8
	 iTxl6EXhOhUHRWxAdoyaP8Dj5owQOy8/O/qwLX2oeQsenR84qudI8pm7/hv8TrO1VjTUD
	 9XykfFFmqPk54yJ0WoGK/xWyF/Ah9hTqs7lVIlAd/dkeSFtoY/8i7+BDJ+4yu9vynP9iu
	 wDfFgrZWvDqmzHX8VTPc5+tjT1iZFlwLRxf6tKdjvb9vish1X3oNFXqsMB//Z+qUnS2ew
	 Jqmi7mDf6qh7mlgmxT6y2/JfqR8oLCJynGC/dBDOzgk3bxHKtuwsasA/XCKOOXVFiKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794865039;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=zHMnUL1+/CyX4MoE10A6pC0xIc4IIoSrgMcTbaBIueg=;
	b=TQ9aOcDncWCbsCMgRlmrGSW9eUhPVcFWoy35Yj1SrBLJrNhWFJ9xcKXSoHd7lhufuzjP
	 rmiCoys8ug3TYTI/ooZ21F2NjA5JOlTU6j//SujoiAY+Q4NXZYdsB4BV7yCidBj/f7m0N
	 i3fb0OMkkjuL/tW7yp5NbJUQ4Lci6EWfXyDmqc/IM5w0z2gCYEBZjE7KCU2BaB6G8Ckde
	 gPFUHWfbUMaiMfj3GLR99iGd55xN14yd+tZzwTNHoX6psb4e1Od/Uxd0n8e6tBLdnmyot
	 6sAvGayzQ91DsOvEL86Q96LTyIJs0og8NS/Qlcd24vFmhQ3h5WWvmGAtkutGy6pQM1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GhZanTHg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A4C606A323;
	Mon, 16 Nov 2026 21:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GhZanTHg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7AAA1F000C8;
	Mon, 16 Nov 2026 21:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794865038;
	bh=zHMnUL1+/CyX4MoE10A6pC0xIc4IIoSrgMcTbaBIueg=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=GhZanTHgaW9AqWTJNmd16PWzz2SA5xzPblC421wuoxFJZRZ8+VEkhIf7Iqtx/OWW5
	 7GGujJit0bODyghbSQif52W+eCFgKdeX5erwnXAvjZSzs4Eqw8PuIRiFuMZqLrfool
	 7tWXjN6FdXb2Q/UmLKzXY8iVQHdGPWPajrftOWbimTsGxxUQjvuJK2VYj8Ol/6Hnlh
	 oqHsM5VScAmSt55mMEoHYlyVNj+8OjVnMpqx9cntpxQfpYh79c5cGd3jsr8Hm26qAX
	 iABmG/GNn++rzG8Xeup4jEW/vIetjKwPTJ9Q0QieQFgmA7QjiIyBipFUL/y8Ig1Gy5
	 jWr3T5PPZaLSA==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v11 13/13] scsi: sd: fail read commands to offline zones early
Date: Tue, 17 Nov 2026 06:37:02 +0900
Message-ID: <20261116213702.225970-14-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261116213702.225970-1-dlemoal@kernel.org>
References: <20261116213702.225970-1-dlemoal@kernel.org>
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
2.56.1

