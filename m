From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 08/14] block: Add a disk flag to block integrity profile
Date: Wed, 28 May 2014 23:28:42 -0400
Message-ID: <1401334128-15499-9-git-send-email-martin.petersen@oracle.com>
References: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33066 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944AbaE2D3W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 May 2014 23:29:22 -0400
In-Reply-To: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@fb.com, nab@daterainc.com, sagig@dev.mellanox.co.il, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

So far we have relied on the app tag size to determine whether a disk
has been formatted with T10 protection information or not. However, not
all target devices provide application tag storage.

Add a flag to the block integrity profile that indicates whether the
disk has been formatted with protection information.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 Documentation/ABI/testing/sysfs-block |  9 +++++++++
 block/blk-integrity.c                 | 11 +++++++++++
 drivers/scsi/sd_dif.c                 |  8 +++++++-
 include/linux/blkdev.h                |  1 +
 4 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
index 279da08f7541..5876e163c430 100644
--- a/Documentation/ABI/testing/sysfs-block
+++ b/Documentation/ABI/testing/sysfs-block
@@ -53,6 +53,15 @@ Description:
 		512 bytes of data.
 
 
+What:		/sys/block/<disk>/integrity/disk
+Date:		February 2011
+Contact:	Martin K. Petersen <martin.petersen@oracle.com>
+Description:
+		Indicates whether a storage device is capable of
+		persistently storing integrity metadata. Set if the
+		device is T10 PI-capable.
+
+
 What:		/sys/block/<disk>/integrity/write_generate
 Date:		June 2008
 Contact:	Martin K. Petersen <martin.petersen@oracle.com>
diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 95f451a3c581..8cf87655152b 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -307,6 +307,11 @@ static ssize_t integrity_generate_show(struct blk_integrity *bi, char *page)
 	return sprintf(page, "%d\n", (bi->flags & BLK_INTEGRITY_GENERATE) != 0);
 }
 
+static ssize_t integrity_disk_show(struct blk_integrity *bi, char *page)
+{
+	return sprintf(page, "%u\n", (bi->flags & BLK_INTEGRITY_DISK) != 0);
+}
+
 static struct integrity_sysfs_entry integrity_format_entry = {
 	.attr = { .name = "format", .mode = S_IRUGO },
 	.show = integrity_format_show,
@@ -329,11 +334,17 @@ static struct integrity_sysfs_entry integrity_generate_entry = {
 	.store = integrity_generate_store,
 };
 
+static struct integrity_sysfs_entry integrity_disk_entry = {
+	.attr = { .name = "disk", .mode = S_IRUGO },
+	.show = integrity_disk_show,
+};
+
 static struct attribute *integrity_attrs[] = {
 	&integrity_format_entry.attr,
 	&integrity_tag_size_entry.attr,
 	&integrity_verify_entry.attr,
 	&integrity_generate_entry.attr,
+	&integrity_disk_entry.attr,
 	NULL,
 };
 
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 801c41851a01..1d401f864fbe 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -270,7 +270,13 @@ void sd_dif_config_host(struct scsi_disk *sdkp)
 		  "Enabling DIX %s protection\n", disk->integrity->name);
 
 	/* Signal to block layer that we support sector tagging */
-	if (dif && type && sdkp->ATO) {
+	if (dif && type) {
+
+		disk->integrity->flags |= BLK_INTEGRITY_DISK;
+
+		if (!sdkp)
+			return;
+
 		if (type == SD_DIF_TYPE3_PROTECTION)
 			disk->integrity->tag_size = sizeof(u16) + sizeof(u32);
 		else
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index bb44630d27f8..4be0446a8817 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1431,6 +1431,7 @@ static inline uint64_t rq_io_start_time_ns(struct request *req)
 enum blk_integrity_flags {
 	BLK_INTEGRITY_VERIFY		= 1 << 0,
 	BLK_INTEGRITY_GENERATE		= 1 << 1,
+	BLK_INTEGRITY_DISK		= 1 << 2,
 };
 
 struct blk_integrity_iter {
-- 
1.9.0

