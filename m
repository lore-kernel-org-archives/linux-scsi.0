Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794754231;
	b=iI3Rc8OYO69eh3IiNz7FuXpmpecPryN5sIwCF2oxDsF5iJcE+aMwgzXPLyeIpymnZou/
	 CqSBa/r7F1dXpPbbwbW8rdrat2aNEG9djhpbsBNe15LkGJeVHxGaDYwVDOEjtj2zNpM88
	 LJl2Kewss0p6oTjlF1IFGyJPgvPeYdeBMlsoEAA4IFcRvNwv2/8bYlXsTQF0EfuKtiFiJ
	 zdCFIM7UN41D1jQ7R5sVb4TavMHqTq50PSljAen8/v+lLw+NljpBCJRlUjCVLC0Dog5l1
	 wQGQ/1Rz4uhZ6STldIFcD/PWRqaQMeYwd+Nwp7T2/8PIyv2DKaS26E89QzUQKWNm9MA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794754231;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=tZ9fny5ziY8iWhqiX+Jhk8PuXcFl3sAc8WiWA+u3QlE=;
	b=cdLu3tNyFbL+T3vW7xRotRb4MSeHi+MAOw5QCi+z+6PmVaKZpwHAdx1Z9Wr7luaH5Hze
	 3O953h4+kmTOgENqHmskVwL1juOrYmq7vZMRU+bVVA2JZrH5Pe01kyOUbqPavtCg4BbTv
	 EPaKgb5NjTc8yhgl87+gVaeJW1CS7M6AsIjWWCrVcxIc5AwQdzD5X4V4QnRCJ4VG6hr74
	 RjgBtjE4UshaHJtnCaSNmpZFAZPSymltjlikn7b+3MragGohF77s0WjBZz2awSeCrH7K/
	 FtZR2JNCFUP1h3OcMhLonn1PeHonoYtmUIESqTsWSgxqguVtA/wYzg+Mgbagf/rjelg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dzv8Lopk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B8C606A32C;
	Sun, 15 Nov 2026 14:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dzv8Lopk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9046B1F000C4;
	Sun, 15 Nov 2026 14:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794754231;
	bh=tZ9fny5ziY8iWhqiX+Jhk8PuXcFl3sAc8WiWA+u3QlE=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=dzv8LopkZ66YkueiWLrSzKpzNGYsrvDLBdgi8I9spmd67ibKdhSFqXjqJEsuEM9/E
	 LFJ8IIhSEw9PESqx7YRa3JSmXMqSK9o/fxKgBcuQStGazvxFy+KWX2S332FjLYSM/U
	 MEcxSs0z2OwgKRkyrhfwY35E7KW/Xlb8ze6bo/LYMs7auXIY3kEj94qH2u3OXpkSoK
	 UWOTxpkU32Ypjw3Iy16EXYAbXiR3aXRTetWiHoSwtO9IZTCaHQ2aGIBM49vB0qkY4B
	 vZdx4J3Lfp5UYDid4Pf7WznKUAHmOnI7KaLeb9ZEV3eTWDr3c8nnzD5gIuGfyvY9hP
	 O7MVjdtatWIDw==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v9 11/13] scsi: sd_zbc: always revalidate zones for disks supporting head depopulation
Date: Sun, 15 Nov 2026 23:50:13 +0900
Message-ID: <20261115145015.938426-12-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261115145015.938426-1-dlemoal@kernel.org>
References: <20261115145015.938426-1-dlemoal@kernel.org>
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
index 8cbf171e6fab..bf2e60071d57 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -516,6 +516,33 @@ static int sd_zbc_check_capacity(struct scsi_disk *sdkp, unsigned char *buf,
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
@@ -545,6 +572,7 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 	u32 zone_blocks = sdkp->early_zone_info.zone_blocks;
 	unsigned int nr_zones = sdkp->early_zone_info.nr_zones;
 	unsigned int flags;
+	bool print_zones;
 	int ret;
 
 	/*
@@ -554,11 +582,22 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
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
 
@@ -571,7 +610,8 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 		return ret;
 	}
 
-	sd_zbc_print_zones(sdkp);
+	if (print_zones)
+		sd_zbc_print_zones(sdkp);
 
 	return 0;
 }
@@ -610,6 +650,9 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, struct queue_limits *lim,
 	sdkp->device->use_10_for_rw = 0;
 	sdkp->device->use_16_for_sync = 1;
 
+	/* Check if storage element depopulation is supported. */
+	sd_zbc_check_depop_supported(sdkp, buf);
+
 	/* Check zoned block device characteristics (unconstrained reads) */
 	ret = sd_zbc_check_zoned_characteristics(sdkp, buf);
 	if (ret)
-- 
2.56.0

