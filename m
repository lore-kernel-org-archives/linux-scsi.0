Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794931074;
	b=rpOcW8ierZZi+aysLrQ895gSrekTzM4hf2YTRzqXbLnZ+7iFIk+GJ6nvzExsfsOOtMrR
	 V2NmaQhy6lyvsk7RPYmdQGwzf32i3napoV476XfUxiLq7ItxMM9lS/1Hwk8zFjCA7hI5L
	 etmn+haJkOV+BwqRQVP+R9QBgMSZb6JdSlLwZsizRc+ZZNhMETMuG1inyCOxDISYZXCQD
	 +WPfYMEJe9/RYbZjbFjZBdqTj89e+ouPk7I3xf+SDy1eevTbjaEIuGPxEJcW37c8dQUsS
	 MW21YmpZ8+yUjcT28R//OkJ9VtKQweKEBqYJKba5t1k1WQBFnG70FfjqvuKeJdqsvdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794931074;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=3Vo9II34r+vXp8sn8wqU4dnBZeV9Jv3jA463zN7CRak=;
	b=dqKaCqCtilVTpCtwfKNUwIX3qNbTGvyTMhI/kfJ8jnXIlQAwUWOSYTZfzEg4alqSsdv1
	 ZOZM7CLTWabx7HKs1ps1Y1H77nEy/b2LDB043kE3H73nr09pOQUCHwL8EvOTocF0Y4jJ5
	 1DzKkh9K9HLqQB29khKiJEYu0EK+d0QmiLFHuxqUoKaMGB+rFXQ6VLwuvsiT4I8xZSOfK
	 ejPlqGqd9/T8XVHfsKN/iKMo+3PC4IdmPqngbZ6B9tvcb6ORUCzYUAC8OrX36LzAKp2X+
	 ZAouLDpdcqepPJ7Ek8FYPvkbWOSSNiuBiVNJmBZcHS+6TWFlM36DyBWGPkMe6k3C35g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jv323uS+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9260606A880;
	Tue, 17 Nov 2026 15:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jv323uS+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57931F000C5;
	Tue, 17 Nov 2026 15:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794931074;
	bh=3Vo9II34r+vXp8sn8wqU4dnBZeV9Jv3jA463zN7CRak=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Jv323uS+uHlOc0cK12UezOk0Vd56bPR9uOQNFHgkOw4mPpE2BsSJTA4FwOuKWsYUQ
	 4Sm7k1cGkz2jZop1YLMzAAvXVvCiDRIFM1dUzchkTpzhAiAMMNpg2lCplei3Ywg11q
	 0Wrt67wQ80UJV0lcYmo9oszWCHxF5woWXP4fXxb+uRf43/CvO4eet8t8rLkZgCC76l
	 A+MntRQExbjRdO3b3VG/5bUPQC1dMNJZSVgZ430uaUsula/DwCLdDh4L45GN0KRcql
	 PlI0EwDJ5+3SoffyVcb0QfvCxH1Bh4tlLp/oUd+JgVCb1p5X+21C0BwPLnGK0TfL0w
	 NNy3HD/TZYuTQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v12 11/13] scsi: sd_zbc: always revalidate zones for disks supporting head depopulation
Date: Wed, 18 Nov 2026 00:57:37 +0900
Message-ID: <20261117155739.304506-12-dlemoal@kernel.org>
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
2.56.1

