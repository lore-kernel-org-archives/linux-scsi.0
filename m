From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: I/O topology fixes for big physical block size
Date: Tue, 28 Sep 2010 14:48:47 -0400
Message-ID: <yq1wrq5aels.fsf@sermon.lab.mkp.net>
References: <1285605664-27027-1-git-send-email-martin.petersen@oracle.com>
	<4CA0CC38.5010804@fusionio.com> <20100927172309.GA13874@redhat.com>
	<1285624684.2888.120.camel@mulgrave.site>
	<4CA114A3.4010202@fusionio.com> <yq1hbhadear.fsf@sermon.lab.mkp.net>
	<4CA1198A.2050004@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:51680 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079Ab0I1Suy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2010 14:50:54 -0400
In-Reply-To: <4CA1198A.2050004@fusionio.com> (Jens Axboe's message of "Tue, 28
	Sep 2010 07:24:10 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@suse.de>, Mike Snitzer <snitzer@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>>>>> "Jens" == Jens Axboe <jaxboe@fusionio.com> writes:

Jens> With the revised understanding that this is purely the IO hint,
Jens> then yes I agree we should not clamp it.

Ok, here's an updated sd patch that does not print a warning...


sd: Fix overflow with big physical blocks

The hw_sector_size variable could overflow if a device reported huge
physical blocks.  Switch to the more accurate physical_block_size
terminology and make sure we use an unsigned int to match the range
permitted by READ CAPACITY(16).

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ffa0689..5446c4d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1554,7 +1554,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	}
 
 	/* Logical blocks per physical block exponent */
-	sdkp->hw_sector_size = (1 << (buffer[13] & 0xf)) * sector_size;
+	sdkp->physical_block_size = (1 << (buffer[13] & 0xf)) * sector_size;
 
 	/* Lowest aligned logical block */
 	alignment = ((buffer[14] & 0x3f) << 8 | buffer[15]) * sector_size;
@@ -1567,7 +1567,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		struct request_queue *q = sdp->request_queue;
 
 		sdkp->thin_provisioning = 1;
-		q->limits.discard_granularity = sdkp->hw_sector_size;
+		q->limits.discard_granularity = sdkp->physical_block_size;
 		q->limits.max_discard_sectors = 0xffffffff;
 
 		if (buffer[14] & 0x40) /* TPRZ */
@@ -1635,7 +1635,7 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	}
 
 	sdkp->capacity = lba + 1;
-	sdkp->hw_sector_size = sector_size;
+	sdkp->physical_block_size = sector_size;
 	return sector_size;
 }
 
@@ -1756,10 +1756,10 @@ got_data:
 				  (unsigned long long)sdkp->capacity,
 				  sector_size, cap_str_10, cap_str_2);
 
-			if (sdkp->hw_sector_size != sector_size)
+			if (sdkp->physical_block_size != sector_size)
 				sd_printk(KERN_NOTICE, sdkp,
 					  "%u-byte physical blocks\n",
-					  sdkp->hw_sector_size);
+					  sdkp->physical_block_size);
 		}
 	}
 
@@ -1773,7 +1773,8 @@ got_data:
 	else if (sector_size == 256)
 		sdkp->capacity >>= 1;
 
-	blk_queue_physical_block_size(sdp->request_queue, sdkp->hw_sector_size);
+	blk_queue_physical_block_size(sdp->request_queue,
+				      sdkp->physical_block_size);
 	sdkp->device->sector_size = sector_size;
 }
 
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index f81a930..f947140 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -50,7 +50,7 @@ struct scsi_disk {
 	atomic_t	openers;
 	sector_t	capacity;	/* size in 512-byte sectors */
 	u32		index;
-	unsigned short	hw_sector_size;
+	unsigned int	physical_block_size;
 	u8		media_present;
 	u8		write_prot;
 	u8		protection_type;/* Data Integrity Field */
