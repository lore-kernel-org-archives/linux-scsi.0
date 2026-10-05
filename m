Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016ED46A61D;
	Mon,  5 Oct 2026 09:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791193611; cv=none; b=UqjKNXZepWK0cYOdzNLrNqiN20fWEomlTxtqKxCpPzGeRdTsIR1LjOrxJJKEMlhNPQVUZ0xTYIp6b/MPm+rcQvj/eAPaLTi2BSVD+CHd0VYT+stlm0PW3nS6ex22m9sfwiiJvKRmZVNZgvznlz8rvDD6oS2ZVFudjnCAWofjrV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791193611; c=relaxed/simple;
	bh=xbFvBa+TUnnlddB06UOuH8yLVlYrJv/hs+4MAT4utNA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hMxmL5dr8wo78BHsFpN6Xl/ZIQ4iTEEGsgsyDzYvPBd4jp8K7uodi2WE2lpZm4ChezU7egWgPyyBJ7himKQ0pyjptSP3tNFLBThtFTbD5XMkRCuMuIYuiUK3+eruy6fItiUlehSP53pHnj5a4J8MooOU5/ec7WspoXSNuvMbki8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SB7dvY2q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SB7dvY2q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0B31F0089D;
	Mon,  5 Oct 2026 09:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791193601;
	bh=O/PxZAbzQe04VVNkcUUw/+EKUtlBgPt0Wp0fZer6l8g=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=SB7dvY2qYHYJJfmIE/itavVwMVss4dfSUEclYIvxwx8+FGDtM7Z43KigRaFhrbwEo
	 MWbnF2H0SNVaPojmWnvBtHCVDXdjosXGm2NyCXHtKGD62fBGgXfcNBBAH+UPjLlzjE
	 U4ouy+zy9kHFIlT34d+16uILDDZ40mn0u/r3UgJ8SBujSw++Jodrt1PsVt2cBz3QrS
	 0aArGZCZBw9r9P8XzffxqPi6Wm74scbHR6LaIztMMY/bWXDsf6SKMM3bn7wJQaFYwO
	 GIIkctum1ujrqpCK9SXyCGMXBL+41Ka7cyXtuwZZHd0vaQ4xkjNBkQ/M0kT0Ur0k4S
	 cjFqBy9hwo9dA==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6/7] scsi: sd_zbc: always revalidate zones for disks supporting head depopulation
Date: Mon,  5 Oct 2026 18:46:31 +0900
Message-ID: <20261005094632.580753-7-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005094632.580753-1-dlemoal@kernel.org>
References: <20261005094632.580753-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sd_zbc_revalidate_zones() skips revalidating the zones of a ZBC device if
the zone size and total number of zones of the disk has not changed. This
is to avoid a call to the rather slow blk_revalidate_disk_zones().

However, for ZBC devices that support data preserving head depopulation
(REMOVE ELEMENT AND MODIFY ZONES command), a disk capacity and number of
zones does not change after a head is depopulated but the condition of
zones changes as the zones served by the head that was depopulated become
either read-only or offline. In this case, not calling
blk_revalidate_disk_zones() prevents the block layer from taking
appropriate actions on the zone write plugs of the disk for the zones that
became read-only or offline.

Avoid any issue with the block layer view of the zone conditions by not
skipping the call to blk_revalidate_disk_zones() for disks that support
the REMOVE ELEMENT AND MODIFY ZONES command. This check is done from
sd_zbc_read_zones() using the helper function sd_zbc_check_modify_zones().
The new scsi disk flag modify_zones_supported is defined to remember the
result of this check.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/sd.h     |  1 +
 drivers/scsi/sd_zbc.c | 26 +++++++++++++++++++++++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 574af8243016..6a72371fee78 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -156,6 +156,7 @@ struct scsi_disk {
 	unsigned	ignore_medium_access_errors : 1;
 	unsigned	rscs : 1; /* reduced stream control support */
 	unsigned	use_atomic_write_boundary : 1;
+	unsigned	modify_zones_supported : 1;
 };
 #define to_scsi_disk(obj) container_of(obj, struct scsi_disk, disk_dev)
 
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 456beaf2e769..2c77f878ab3f 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -516,6 +516,21 @@ static int sd_zbc_check_capacity(struct scsi_disk *sdkp, unsigned char *buf,
 	return 0;
 }
 
+/*
+ * sd_zbc_check_modify_zones - Check if the device supports depopulation
+ * @sdkp: Target disk
+ * @buf: command buffer
+ *
+ * Check if the device supports the REMOVE ELEMENT AND MODIFY ZONES command.
+ */
+static inline bool sd_zbc_check_modify_zones(struct scsi_disk *sdkp,
+					     unsigned char *buf)
+{
+	return scsi_report_opcode(sdkp->device, buf, SD_BUF_SIZE,
+				  SERVICE_ACTION_IN_16,
+				  SAI_REMOVE_ELEMENT_AND_MODIFY_ZONES) == 1;
+}
+
 static void sd_zbc_print_zones(struct scsi_disk *sdkp)
 {
 	if (sdkp->device->type != TYPE_ZBC || !sdkp->capacity)
@@ -554,9 +569,15 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 	if (!blk_queue_is_zoned(q))
 		return 0;
 
+	/*
+	 * If the zone size and number of zones has not changed, and the disk
+	 * does not support depopulating heads, skip the rather slow call to
+	 * blk_revalidate_disk_zones().
+	 */
 	if (sdkp->zone_info.zone_blocks == zone_blocks &&
 	    sdkp->zone_info.nr_zones == nr_zones &&
-	    disk->nr_zones == nr_zones)
+	    disk->nr_zones == nr_zones &&
+	    !sdkp->modify_zones_supported)
 		return 0;
 
 	sdkp->zone_info.zone_blocks = zone_blocks;
@@ -620,6 +641,9 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, struct queue_limits *lim,
 	if (ret != 0)
 		goto err;
 
+	/* Check if REMOVE ELEMENT AND MODIFY ZONES is supported. */
+	sdkp->modify_zones_supported = sd_zbc_check_modify_zones(sdkp, buf);
+
 	nr_zones = round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_blocks);
 	if (nr_zones > INT_MAX) {
 		sd_printk(KERN_ERR, sdkp, "Too many zones (%llu)\n",
-- 
2.55.0

