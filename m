Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794931077;
	b=OGMH9tnJ7PC6FRWyHcrRdvMexpA8NNh08c0lyHHSRrLxvfE2+9RfazDvtxYbFWBUB9S7
	 1nNIBdXgl84Zv14W0VeJnSk01sgfpzDMh0eZUL0zmle3aZ9dDwSSORnqroqMfOlEzQpFe
	 u4yrUuCIHaamXZ01IYvPAxZgB8noVxaFjqB+zVKtTA1Dd4/9Jn9kUuJqJGofDpkyxB4Ao
	 WzMRfQ4oEQhkt3qSGC6JNHBw2brG8aP96M48xG1ofxtH6AtAGsDrByPG82ftorlDdccRw
	 eqNDYnHFulwVXFdT8pW4ls4fXl7SIeWocwBmdcn16LAFwYZdai/rYqYj2LELGrr42Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794931077;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=zHMnUL1+/CyX4MoE10A6pC0xIc4IIoSrgMcTbaBIueg=;
	b=RRV3oBT6BQ2yMZipLqY7mmDzP3dxrd6TDsHoCgpL5MTtzvoUtJR28GMi5ATvbmbzvOyu
	 PQjcGjUFDuV3F7WgJSi2oCV3dUKBLjPXWKQHstWoS9dd099bz2Th4QmO3jjKAoQ+LSae0
	 yUOoIV+GJB0/msSrXewBs/wcmiiPVnuTim/6knNjGnRmyEm+OIEPKc75p0zYNqcASUyIG
	 KU0eeQVwkUR1QVp+jMiVGC22A83KJOii2qax0kBWzg+KSXTaaIg5Lq1GzZVsVs+Cjfsjb
	 oge3DkMSqQ8DwwjrZKGt8Ox50bSYjnXCSl/85EGIzibtt3IYaKm/GziQbXJm4CtWQuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GeDNZ5ed;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23603606A33F;
	Tue, 17 Nov 2026 15:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GeDNZ5ed
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DAB61F000C6;
	Tue, 17 Nov 2026 15:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794931077;
	bh=zHMnUL1+/CyX4MoE10A6pC0xIc4IIoSrgMcTbaBIueg=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=GeDNZ5edgzlMYFbFcpdvjYqzvR3sIgUvzFHFAfrJWXmKU0MLXd9v20RRr6/Zy2Hm9
	 nPwCRU+L16/Nu7ZqTP2xsW1KSO3OGcEdOMC4BsrO6f8dDOkfNlUIt+zEE9Dqj7IEeN
	 Uc4pN8RlV/6+w6tFWNugupG4Xwrf9rEMMFnLDr7+HIAIgwsoSj6P5AbEqkdjB12tMF
	 wPbDfKogew9TsXZg3COObD7guU8B7Q1r3RCbdyrE0axb6rkEeJY2AQjwbXY7TRNyk5
	 +a6soe+EOWzOqd0KeYZwyMOIBLgbLxqsZiKBlNy1AK1NMEuoXjc4cUcCScP7yftUu4
	 m+XAvLWp8fxpQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v12 13/13] scsi: sd: fail read commands to offline zones early
Date: Wed, 18 Nov 2026 00:57:39 +0900
Message-ID: <20261117155739.304506-14-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261117155739.304506-1-dlemoal@kernel.org>
References: <20261117155739.304506-1-dlemoal@kernel.org>
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

