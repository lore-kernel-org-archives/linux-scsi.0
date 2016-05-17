From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH 2/2] target: fix max discard sectors calculation
Date: Tue, 17 May 2016 16:49:11 -0500
Message-ID: <573B91D7.8020002@redhat.com>
References: <1463424410-17196-1-git-send-email-mchristi@redhat.com>
 <1463424410-17196-3-git-send-email-mchristi@redhat.com>
 <573A1826.3050007@sandisk.com> <yq1y479hlmp.fsf@sermon.lab.mkp.net>
 <573B6006.8010206@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070309090404040007000207"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <573B6006.8010206@sandisk.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, socketpair@gmail.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------070309090404040007000207
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 05/17/2016 01:16 PM, Bart Van Assche wrote:
> On 05/16/2016 12:02 PM, Martin K. Petersen wrote:
>>>>>>> "Bart" == Bart Van Assche <bart.vanassche@sandisk.com> writes:
>>
>> Bart> That's a good catch. But seeing this patch makes me wonder whether
>> Bart> this patch introduces a 64-bit division? If so, I'm afraid this
>> Bart> patch will make 32-bit users unhappy. Have you considered to use
>> Bart> do_div() or >> (ilog2(block_size) - 9) instead? For the latter
>> Bart> alternative no 64-bit cast is needed.
>>
>> Please use logical_to_sectors().
> 
> Hello Martin,
> 
> For SCSI initiator devices the logical block size is stored in struct
> scsi_device. logical_to_sectors() gets the logical block size from
> struct scsi_device. LIO however stores the logical block size in struct
> se_dev_attrib. If we want to keep SCSI initiator and SCSI target headers
> separate I think we will need two logical_to_sectors() functions - one
> for SCSI initiator devices and one for SCSI target devices.
> 

Or block layer helpers? Something like the attached patch. It is a
compile only tested patch (just for show and not for submission as I
would break it up and test, etc) that would move the scsi converter to
the block layer, and convert the target layer and scsi to use it.

--------------070309090404040007000207
Content-Type: text/x-patch;
 name="blk-logical-sector-helpers.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="blk-logical-sector-helpers.patch"

diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 654630b..d405400 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -148,7 +148,7 @@ static inline int scsi_medium_access_command(struct scsi_cmnd *scmd)
 
 static inline sector_t logical_to_sectors(struct scsi_device *sdev, sector_t blocks)
 {
-	return blocks << (ilog2(sdev->sector_size) - 9);
+	return blk_logical_to_sector(blocks, sdev->sector_size);
 }
 
 /*
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index a4046ca..95d6112 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -821,13 +821,15 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
  * in ATA and we need to set TPE=1
  */
 bool target_configure_unmap_from_queue(struct se_dev_attrib *attrib,
-				       struct request_queue *q, int block_size)
+				       struct request_queue *q)
 {
+	unsigned short block_size = queue_logical_block_size(q);
+
 	if (!blk_queue_discard(q))
 		return false;
 
-	attrib->max_unmap_lba_count = (q->limits.max_discard_sectors << 9) /
-								block_size;
+	attrib->max_unmap_lba_count = queue_sector_to_logical(q,
+						q->limits.max_discard_sectors);
 	/*
 	 * Currently hardcoded to 1 in Linux/SCSI code..
 	 */
@@ -846,16 +848,7 @@ EXPORT_SYMBOL(target_configure_unmap_from_queue);
  */
 sector_t target_to_linux_sector(struct se_device *dev, sector_t lb)
 {
-	switch (dev->dev_attrib.block_size) {
-	case 4096:
-		return lb << 3;
-	case 2048:
-		return lb << 2;
-	case 1024:
-		return lb << 1;
-	default:
-		return lb;
-	}
+	return blk_logical_to_sector(lb, dev->dev_attrib.block_size);
 }
 EXPORT_SYMBOL(target_to_linux_sector);
 
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 75f0f08..7929186 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -161,8 +161,7 @@ static int fd_configure_device(struct se_device *dev)
 			dev_size, div_u64(dev_size, fd_dev->fd_block_size),
 			fd_dev->fd_block_size);
 
-		if (target_configure_unmap_from_queue(&dev->dev_attrib, q,
-						      fd_dev->fd_block_size))
+		if (target_configure_unmap_from_queue(&dev->dev_attrib, q))
 			pr_debug("IFILE: BLOCK Discard support available,"
 				 " disabled by default\n");
 		/*
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 026a758..3cbe060 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -121,8 +121,7 @@ static int iblock_configure_device(struct se_device *dev)
 	dev->dev_attrib.hw_max_sectors = queue_max_hw_sectors(q);
 	dev->dev_attrib.hw_queue_depth = q->nr_requests;
 
-	if (target_configure_unmap_from_queue(&dev->dev_attrib, q,
-					      dev->dev_attrib.hw_block_size))
+	if (target_configure_unmap_from_queue(&dev->dev_attrib, q))
 		pr_debug("IBLOCK: BLOCK Discard support available,"
 			 " disabled by default\n");
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 669e419..55cb34b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1210,6 +1210,30 @@ static inline unsigned short bdev_logical_block_size(struct block_device *bdev)
 	return queue_logical_block_size(bdev_get_queue(bdev));
 }
 
+static inline sector_t blk_logical_to_sector(sector_t blocks,
+					     unsigned short block_size)
+{
+	return blocks << (ilog2(block_size) - 9);
+}
+
+static inline sector_t queue_logical_to_sector(struct request_queue *q,
+					       sector_t blocks)
+{
+	return blk_logical_to_sector(blocks, queue_logical_block_size(q));
+}
+
+static inline sector_t blk_sector_to_logical(sector_t sectors,
+					     unsigned short block_size)
+{
+	return sectors >> (ilog2(block_size) - 9);
+}
+
+static inline sector_t queue_sector_to_logical(struct request_queue *q,
+					       sector_t sectors)
+{
+	return blk_sector_to_logical(sectors, queue_logical_block_size(q));
+}
+
 static inline unsigned int queue_physical_block_size(struct request_queue *q)
 {
 	return q->limits.physical_block_size;
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 28ee5c2..711322a 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -96,6 +96,6 @@ sense_reason_t passthrough_parse_cdb(struct se_cmd *cmd,
 bool target_sense_desc_format(struct se_device *dev);
 sector_t target_to_linux_sector(struct se_device *dev, sector_t lb);
 bool target_configure_unmap_from_queue(struct se_dev_attrib *attrib,
-				       struct request_queue *q, int block_size);
+				       struct request_queue *q);
 
 #endif /* TARGET_CORE_BACKEND_H */

--------------070309090404040007000207--
