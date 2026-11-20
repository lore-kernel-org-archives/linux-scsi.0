Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795208829;
	b=37UkNIKzgmWrx0pDZen+yH1yrkCkOAszbMRyDn2UuUuzDn4+dzwHEI6BCBVvsj5jr0Bc
	 TOHTcbapqbnguOvnbEVyFFj7bWHzc7ZTN3BKy7Fz6jqfYUf4AzUiqHEtQGK/Rr1jCZVU0
	 M5oaKgqGnkljkfZ9j0tfX17XhS7yYQzi94mKMtsQHIQ0lleuds/lyF8K2+7uC99WatQ0O
	 9GVo6UfVM424PU4TwHCz6D19/VCnV+4SIoVFp3hykx4cH0ziJ7gG2thjEj9MEun4jdnLn
	 LBhbiqpTgAZeK/U4UTyvgA9OXmqgVX114YiPHgVu9TOUoi+hDFSN3C0H1fmyheVWWbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795208829;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=6RphHK8EADhRhYVNdUFgEx1TWrWD/YcQxfjbLyAOF0c=;
	b=DOWZo/YlOvjnNDtS2NpNZbNoN1zBJWonGN3Hk/rgIlalE7RKMy+kK5GQ0CkgR31Fgm9P
	 QvnoyQP2I6PMTB7ZqlOUBIT/Q8jbQ6x2heVFipgS/MALLtpPow3V0mjDkvwA0yERSSWBd
	 eiBChRnL7ovL3DzSqySNtadd2UnfyKdWRmR7sFu1HzW030C6Bnd0fIziU6xkSunChK0BT
	 FkK5Un4PFJaXUZKVIxMZxbFdmPxLEOf4kn1ioxZYlxYvGkBW+jrainJsd3+fN4J3gLKt7
	 q46CKmkV+fEr6R5e2QAfsTi7lJWWgAGbDazAkOyHmE0l6rgPRbtdPbKpb5Rj+Dw0LrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XDqMonc1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3172606A6A8;
	Fri, 20 Nov 2026 21:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XDqMonc1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09F91F000C4;
	Fri, 20 Nov 2026 21:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795208829;
	bh=6RphHK8EADhRhYVNdUFgEx1TWrWD/YcQxfjbLyAOF0c=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=XDqMonc12fegILe4iluMlkZsCWJ9Ksvlmtw/tmmcU9botAS6zwaPLgUYiG22YUh+L
	 XIlCVMWU6VFhHIXaZcJW15BTkwMplPkaWTaGhb2H65KDlhV2DXgNUoA0G+XRXzpJh4
	 MZVfMPspEnSvucr4inIoVAi7dNE30w1Jn5GTae7esXDmiNIjGh6yN6T64WjiqdPq3o
	 Xh4t9JE+ttl3hs68J+EiU04HNEZ+Cxju7ckQKjC9x9fZe2f2F9cElr6n1Fbyfn9pSo
	 G5r5g1J50w79a+0oKJKRyT6j/N/Obrep8Sn6v3Xvn4xIqFWesLo9hzpZLZEAFSyfWc
	 AmeM5LtzZOZFw==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v13 11/13] scsi: sd_zbc: always revalidate zones for disks supporting head depopulation
Date: Sat, 21 Nov 2026 06:06:49 +0900
Message-ID: <20261120210651.580511-12-dlemoal@kernel.org>
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

sd_zbc_revalidate_zones() skips revalidating the zones of a ZBC device if
the zone size and total number of zones of the disk has not changed. This
is to avoid the sometimes slow report zones for the entire disk that
blk_revalidate_disk_zones() will generate.

For ZBC devices that support the storage element depopulation feature, a
revalidation after executing a passthrough REMOVE ELEMENT AND TRUNCATE
command will thus correctly trigger a zone revalidation as the disk
capacity and number of zones changed.

However, for devices supporting the data preserving head depopulation
variant of the depopulation feature (REMOVE ELEMENT AND MODIFY ZONES
command), a disk capacity and number of zones does not change after a head
is depopulated. Only the conditions of the zones served by the head that
was depopulated change. These zones are transitioned to either read-only
or offline.

While the block layer storage element management functions always call
blk_revalidate_disk_zones() to catch these changes, a user scan, libata
device rescan after EH or a depopulation or restoration action executed
through SG_IO would not. In these cases, not calling
blk_revalidate_disk_zones() prevents the block layer from taking
appropriate actions on the zone write plugs of the disk.

Avoid any issue with the block layer view of the zone conditions by not
skipping the call to blk_revalidate_disk_zones() for disks that support
both the GET PHYSICAL ELEMENTS STATUS and REMOVE ELEMENT AND MODIFY ZONES
commands. This check is done from sd_zbc_read_zones() using the helper
function sd_zbc_check_depop_supported(). The new SCSI disk flags
depop_report_supported and depop_modify_zones_supported are defined to
remember the result of this check.

This change will slow down a little SMR disk revalidation. However, user
forced revalidations are normally rare, and other revalidations triggered
by udev only happen when the disk device files is not in use anymore
(closed). So this slow down should in practice not be an issue.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.h     |  2 ++
 drivers/scsi/sd_zbc.c | 47 +++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 574af8243016..84c87d0f05d8 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -156,6 +156,8 @@ struct scsi_disk {
 	unsigned	ignore_medium_access_errors : 1;
 	unsigned	rscs : 1; /* reduced stream control support */
 	unsigned	use_atomic_write_boundary : 1;
+	unsigned	depop_report_supported : 1;
+	unsigned	depop_modify_zones_supported : 1;
 };
 #define to_scsi_disk(obj) container_of(obj, struct scsi_disk, disk_dev)
 
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 06f4e3fcda1d..cc4d4146def8 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -521,6 +521,33 @@ static int sd_zbc_check_capacity(struct scsi_disk *sdkp, unsigned char *buf,
 	return 0;
 }
 
+/*
+ * sd_zbc_check_depop_supported - Check if the device supports storage element
+ *				  depopulation
+ * @sdkp: Target SCSI disk
+ * @buf: command buffer
+ *
+ * Check if the device supports the REMOVE ELEMENT AND MODIFY ZONES command.
+ */
+static void sd_zbc_check_depop_supported(struct scsi_disk *sdkp,
+					 unsigned char *buf)
+{
+	/* Mandate support for reporting storage elements health. */
+	sdkp->depop_report_supported =
+		scsi_report_opcode(sdkp->device, buf, SD_BUF_SIZE,
+				   SERVICE_ACTION_IN_16,
+				   SAI_GET_PHYSICAL_ELEMENT_STATUS) == 1;
+	if (!sdkp->depop_report_supported) {
+		sdkp->depop_modify_zones_supported = false;
+		return;
+	}
+
+	sdkp->depop_modify_zones_supported =
+		scsi_report_opcode(sdkp->device, buf, SD_BUF_SIZE,
+				   SERVICE_ACTION_IN_16,
+				   SAI_REMOVE_ELEMENT_AND_MODIFY_ZONES) == 1;
+}
+
 static void sd_zbc_print_zones(struct scsi_disk *sdkp)
 {
 	if (sdkp->device->type != TYPE_ZBC || !sdkp->capacity)
@@ -550,6 +577,7 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 	u32 zone_blocks = sdkp->early_zone_info.zone_blocks;
 	unsigned int nr_zones = sdkp->early_zone_info.nr_zones;
 	unsigned int flags;
+	bool print_zones;
 	int ret;
 
 	/*
@@ -559,11 +587,22 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
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
+	    !sdkp->depop_modify_zones_supported)
 		return 0;
 
+	print_zones =
+		sdkp->zone_info.zone_blocks != zone_blocks ||
+		sdkp->zone_info.nr_zones != nr_zones ||
+		disk->nr_zones != nr_zones;
+
 	sdkp->zone_info.zone_blocks = zone_blocks;
 	sdkp->zone_info.nr_zones = nr_zones;
 
@@ -576,7 +615,8 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 		return ret;
 	}
 
-	sd_zbc_print_zones(sdkp);
+	if (print_zones)
+		sd_zbc_print_zones(sdkp);
 
 	return 0;
 }
@@ -615,6 +655,9 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, struct queue_limits *lim,
 	sdkp->device->use_10_for_rw = 0;
 	sdkp->device->use_16_for_sync = 1;
 
+	/* Check if storage element depopulation is supported. */
+	sd_zbc_check_depop_supported(sdkp, buf);
+
 	/* Check zoned block device characteristics (unconstrained reads) */
 	ret = sd_zbc_check_zoned_characteristics(sdkp, buf);
 	if (ret)
-- 
2.56.1

