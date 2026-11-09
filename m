Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794217920;
	b=oewv3ER92SaGYB3uPwCGescOEqJxVkqrUbyRkitxXH9viQo6XDP6Kir0ehEsFkquB259
	 MMOej5NscfKGxq7JORo5sO+hsVIDxa5EZeq6uuTeskOzchzSTfYQm+J//Ks388YUuOkkn
	 JD+iRJjFW6dNxo8BW0oLY1VgQVIkXZSKR5GAask0F2f+iDJSspABlCwKcWX6cQaTw792s
	 sgMbapucIneOfdJICZP8WPfoQR7SUqf2yTcr7y20+aMVg/lvrpVzJMjYw/o0z/RMEu9Z2
	 eKXCbjCfOEbVdgw2EM+ZAuhP6iBggqAVm0KYl1nMyabG/zU5KL4F8bf5nwaSY7/1FqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794217920;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=bVr5tuS7xh2PYiaNEswRMPU76wRqKv1igzs8AyprowU=;
	b=Ixd9bHpPC86X787SYH8sYQS/ii9GJcL+CTPkA4c+BNGgGJdspg0NeHQKMilhyTENo66H
	 liJ6mhFD4gGD4H+WeNz/MsoQf2EztgLzJpWsm4wfC+hC52MuLdZYDE/xZf9lgaUGW/oyT
	 vj/BlhodLGTN7lgSuP/CqT0C5h0uYO0xcU1x1iYTXk+sfYT3Wrij/B0efS/pIvUgrv7zt
	 RXj111SDQkqB5WivkdNOHu93Rje9hOTPpXVP9iZBtNnSfDqed+nN+UDbO13H4LUYDyQi9
	 fxwOJGY9jupNC/1NZ61lcBxACu6tU0d7+31/Hr72xvCvG192zlD3Iuus05Ud1thV7Dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QqPzKFvp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34AB606A339;
	Mon,  9 Nov 2026 09:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QqPzKFvp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE7C21F008A2;
	Mon,  9 Nov 2026 09:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794217919;
	bh=bVr5tuS7xh2PYiaNEswRMPU76wRqKv1igzs8AyprowU=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=QqPzKFvpQPgpJiBgGCMIJffOHdZhSkujqdzuRJa6PIzumbuDqiyJUAdPCWmYlne+6
	 NNUq/Hxfvu7N+Xgom7vQLbU4ox5JIx96k3qsr2BSdnxPQq7sZZAiCrWmwu8DFpwtNp
	 1Qy1iN3MbsTAE4KNMH2S/6oKCyTKIvC7pSh8PsOVyKeMLYi2sCu0HziC8dO2Dkh5oS
	 uh9kPORPYOVEA5uKag/hqR+6QB08PnkRuTe4ykpMNtIKW7xls/M6DNP7VuxXczLrXO
	 dhlv87i+92skmj6JqBunG2TsIo83GV5uKLwyDjGTenItTjAUqPQ7M9IIDOerohuqBj
	 gPxP7WdQIVhsA==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v8 12/12] scsi: sd: fail read commands to offline zones early
Date: Mon,  9 Nov 2026 18:51:44 +0900
Message-ID: <20261109095144.819709-13-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261109095144.819709-1-dlemoal@kernel.org>
References: <20261109095144.819709-1-dlemoal@kernel.org>
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

