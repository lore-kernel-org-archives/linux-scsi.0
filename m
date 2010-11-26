From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] target: Convert transport_dev_end_lba() to ->get_blocks()
Date: Thu, 25 Nov 2010 23:52:40 -0800
Message-ID: <1290757960-22505-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm20.bullet.mail.sp2.yahoo.com ([98.139.91.90]:23066 "HELO
	nm20.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753645Ab0KZHwr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Nov 2010 02:52:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts transport_get_sectors() -> transport_dev_end_lba() to use
dev->transport->get_blocks(dev) directly instead of the dev->dev_sectors_total
assignment in transport_add_device_to_core_hba().

This fixes a bug where backend struct block_devices like (Linux/LVM w/ IBLOCK)
could change their effective size reported by ->get_blocks(), but the original
dev->dev_sectors_total was still be enforced by transport_dev_end_lba().

Tested with IBLOCK, FILEIO, RAMDISK_DR and pSCSI LUNs of TYPE_DISK.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    5 +----
 include/target/target_core_base.h      |    1 -
 2 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index dbe5dbf..665eaac 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1715,9 +1715,6 @@ struct se_device *transport_add_device_to_core_hba(
 	}
 	scsi_dump_inquiry(dev);
 
-	if (TRANSPORT(dev)->get_device_type(dev) == TYPE_DISK)
-		dev->dev_sectors_total = dev->transport->get_blocks(dev);
-
 out:
 	if (!ret)
 		return dev;
@@ -4248,7 +4245,7 @@ EXPORT_SYMBOL(transport_generic_map_mem_to_cmd);
 
 static inline long long transport_dev_end_lba(struct se_device *dev)
 {
-	return dev->dev_sectors_total + 1;
+	return dev->transport->get_blocks(dev) + 1;
 }
 
 static int transport_get_sectors(struct se_cmd *cmd)
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 7ccde37..ba15644 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -731,7 +731,6 @@ struct se_device {
 	/* Used for SPC-2 reservations enforce of ISIDs */
 	u64			dev_res_bin_isid;
 	t10_task_attr_index_t	dev_task_attr_type;
-	unsigned long long	dev_sectors_total;
 	/* Pointer to transport specific device structure */
 	void 			*dev_ptr;
 	u32			dev_index;
-- 
1.5.6.5

