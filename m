Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795208833;
	b=hVuO2fXMqqQDWEsBym8rZGcJOd47O/fW5tyiUJtz7xff5RISxpucsT4NHIbJb4qPsS6O
	 rjAlz1EY1gsbhzpK7l7ln3b50YWVVNMOS1TpIIediDqszdcgBbCtrteOcGvl0dI3SDu+E
	 9tgNS6P5h0m6qcP9pj95Z+dnz61m9ZKSU+d6jw+sCrXCF2u24ZbvrvPPkpaj1QcnglUR/
	 NWUH41u45cT9n7ObLmr1jJDDaoEpEW/N/IzBf99CRFxLopqGc9UVNDcI+Xx8b2tDirNCy
	 /O6/MfCBrkt4XBsZ62NfUVlMr20mPePBkJsTDYgZR9spqAWhElNLrZLQHK/Ek025jyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795208833;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=zHMnUL1+/CyX4MoE10A6pC0xIc4IIoSrgMcTbaBIueg=;
	b=Z21OtvxGUJjzl+foaE+r1pPobUG0V5wOJjOG6Oa+yETWnM9tololLsOmL1BOzyH+HQA/
	 DXeqIdOK+nYgjhHeehoX2aRDqhEr9FbHWDRnb0BKpf4/g04d9wP1Df70mU4kBNEIRutt9
	 fYDY7SyPWvFm15KshyWwR1DpV2xbf8t5D+MxiLPdN8AwlQW8A23Vf7CKFhj+gECT0SKQ9
	 EU4M7f8HrJpd+bht+u78ibeAEROGDlTaKMTp04TvmXSXE7WpCvvOEBJ6YB5KC4P1/nKJ0
	 GmcvB4a2CPIC0tNeX7wAZFU/8wXzgHv9IGcMfbg5Msj8r6zpZT8GYbAkU5/3qoz2ITA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wi2SAlVG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB27606A6AF;
	Fri, 20 Nov 2026 21:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wi2SAlVG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A511F000C0;
	Fri, 20 Nov 2026 21:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795208832;
	bh=zHMnUL1+/CyX4MoE10A6pC0xIc4IIoSrgMcTbaBIueg=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Wi2SAlVGJGX8sw2HdXw8fswPTqkwDW4+cEe1NPYSPuiBGl57y3nO2a11pWbgDtbK8
	 uzolCyOIsYnroz14bsr2rInr2eu5O9lLT4+F6963Rb2KkcHglNlfbBy5yuwEMfgBfy
	 86pOdind699lnkYhLQOv8Xql9Orr1KYlOFxnnYBQrsyQult8ruWO7NZHDr7OoNwvp3
	 KjNDOn6RHqldWxlSt+eV0aW72asKkyo57WmvqszfMf/iYjxuksSvYRn5PJmhK74lQr
	 O31d9THcfVsoS9XsnLpZFRvqe+wM6u9f6lgZ00JPf4aeycFIvICHYyopYiEuOcIxjW
	 GjQRkGmYav6MA==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v13 13/13] scsi: sd: fail read commands to offline zones early
Date: Sat, 21 Nov 2026 06:06:51 +0900
Message-ID: <20261120210651.580511-14-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261120210651.580511-1-dlemoal@kernel.org>
References: <20261120210651.580511-1-dlemoal@kernel.org>
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

