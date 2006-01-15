From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] sd: use consistant printk prefixes
Date: Sun, 15 Jan 2006 10:58:33 -0800
Message-ID: <1137351513.29486.15.camel@localhost>
References: <20060106170020.GA22994@lst.de>
	 <1136589393.15460.20.camel@localhost> <20060107140658.GB9342@lst.de>
	 <1136655773.15460.28.camel@localhost>  <20060115181012.GA16187@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:21770 "EHLO Perches.com")
	by vger.kernel.org with ESMTP id S1750792AbWAOS6o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Jan 2006 13:58:44 -0500
In-Reply-To: <20060115181012.GA16187@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Sun, 2006-01-15 at 19:10 +0100, Christoph Hellwig wrote:
> this needs rediffing for current mainline because sd_init_command
> changed a little bit.  otherwise it looks really nice, please send it
> to linux-scsi.

whitespace and very mild changes to sd_init_command
timeout could have had a null dereference
fixed sector size comment to match code
changed printk "sd: " to disk->disk_name

signed-off-by: Joe Perches <joe@perches.com>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 930db39..c5c8436 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -230,23 +230,22 @@ static void scsi_disk_put(struct scsi_di
  *
  *	Returns 1 if successful and 0 if error (or cannot be done now).
  **/
-static int sd_init_command(struct scsi_cmnd * SCpnt)
+static int sd_init_command(struct scsi_cmnd *SCpnt)
 {
 	struct scsi_device *sdp = SCpnt->device;
 	struct request *rq = SCpnt->request;
 	struct gendisk *disk = rq->rq_disk;
 	sector_t block = rq->sector;
 	unsigned int this_count = SCpnt->request_bufflen >> 9;
-	unsigned int timeout = sdp->timeout;
 
 	SCSI_LOG_HLQUEUE(1, printk("sd_init_command: disk=%s, block=%llu, "
-			    "count=%d\n", disk->disk_name,
-			 (unsigned long long)block, this_count));
+				   "count=%d\n", disk->disk_name,
+				   (unsigned long long)block, this_count));
 
 	if (!sdp || !scsi_device_online(sdp) ||
  	    block + rq->nr_sectors > get_capacity(disk)) {
 		SCSI_LOG_HLQUEUE(2, printk("Finishing %ld sectors\n", 
-				 rq->nr_sectors));
+					   rq->nr_sectors));
 		SCSI_LOG_HLQUEUE(2, printk("Retry with 0x%p\n", SCpnt));
 		return 0;
 	}
@@ -263,8 +262,8 @@ static int sd_init_command(struct scsi_c
 				   disk->disk_name, (unsigned long long)block));
 
 	/*
-	 * If we have a 1K hardware sectorsize, prevent access to single
-	 * 512 byte sectors.  In theory we could handle this - in fact
+	 * If we have a 1K, 2K, or 4K hardware sectorsize, prevent access
+	 * to smaller sectors.  In theory we could handle this - in fact
 	 * the scsi cdrom driver must be able to handle this because
 	 * we typically use 1K blocksizes, and cdroms typically have
 	 * 2K hardware sectorsizes.  Of course, things are simpler
@@ -274,50 +273,41 @@ static int sd_init_command(struct scsi_c
 	 * for this.
 	 */
 	if (sdp->sector_size == 1024) {
-		if ((block & 1) || (rq->nr_sectors & 1)) {
-			printk(KERN_ERR "sd: Bad block number requested");
-			return 0;
-		} else {
-			block = block >> 1;
-			this_count = this_count >> 1;
-		}
-	}
-	if (sdp->sector_size == 2048) {
-		if ((block & 3) || (rq->nr_sectors & 3)) {
-			printk(KERN_ERR "sd: Bad block number requested");
-			return 0;
-		} else {
-			block = block >> 2;
-			this_count = this_count >> 2;
-		}
-	}
-	if (sdp->sector_size == 4096) {
-		if ((block & 7) || (rq->nr_sectors & 7)) {
-			printk(KERN_ERR "sd: Bad block number requested");
-			return 0;
-		} else {
-			block = block >> 3;
-			this_count = this_count >> 3;
-		}
+		if ((block & 1) || (rq->nr_sectors & 1))
+			goto bad_block;
+		block = block >> 1;
+		this_count = this_count >> 1;
+	}
+	else if (sdp->sector_size == 2048) {
+		if ((block & 3) || (rq->nr_sectors & 3))
+			goto bad_block;
+		block = block >> 2;
+		this_count = this_count >> 2;
+	}
+	else if (sdp->sector_size == 4096) {
+		if ((block & 7) || (rq->nr_sectors & 7))
+			goto bad_block;
+		block = block >> 3;
+		this_count = this_count >> 3;
 	}
 	if (rq_data_dir(rq) == WRITE) {
-		if (!sdp->writeable) {
+		if (!sdp->writeable)
 			return 0;
-		}
 		SCpnt->cmnd[0] = WRITE_6;
 		SCpnt->sc_data_direction = DMA_TO_DEVICE;
 	} else if (rq_data_dir(rq) == READ) {
 		SCpnt->cmnd[0] = READ_6;
 		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
 	} else {
-		printk(KERN_ERR "sd: Unknown command %lx\n", rq->flags);
+		printk(KERN_ERR "%s: Unknown command %lx\n", disk->disk_name, rq->flags);
 /* overkill 	panic("Unknown sd command %lx\n", rq->flags); */
 		return 0;
 	}
 
 	SCSI_LOG_HLQUEUE(2, printk("%s : %s %d/%ld 512 byte blocks.\n", 
-		disk->disk_name, (rq_data_dir(rq) == WRITE) ? 
-		"writing" : "reading", this_count, rq->nr_sectors));
+				   disk->disk_name,
+				   (rq_data_dir(rq) == WRITE) ? "writing" : "reading",
+				   this_count, rq->nr_sectors));
 
 	SCpnt->cmnd[1] = 0;
 	
@@ -359,7 +349,8 @@ static int sd_init_command(struct scsi_c
 			 * during operation and thus turned off
 			 * use_10_for_rw.
 			 */
-			printk(KERN_ERR "sd: FUA write on READ/WRITE(6) drive\n");
+			printk(KERN_ERR "%s: FUA write on READ/WRITE(6) drive\n",
+			       disk->disk_name);
 			return 0;
 		}
 
@@ -380,7 +371,7 @@ static int sd_init_command(struct scsi_c
 	SCpnt->transfersize = sdp->sector_size;
 	SCpnt->underflow = this_count << 9;
 	SCpnt->allowed = SD_MAX_RETRIES;
-	SCpnt->timeout_per_command = timeout;
+	SCpnt->timeout_per_command = sdp->timeout;
 
 	/*
 	 * This is the completion routine we use.  This is matched in terms
@@ -393,6 +384,11 @@ static int sd_init_command(struct scsi_c
 	 * queued.
 	 */
 	return 1;
+
+bad_block:
+	printk(KERN_ERR "%s: Bad block number requested: %llu (sector size: %d, sector: %lu)\n",
+	       disk->disk_name, (unsigned long long)block, sdp->sector_size, rq->nr_sectors);
+	return 0;
 }
 
 /**
@@ -679,12 +675,13 @@ static int sd_sync_cache(struct scsi_dev
 			break;
 	}
 
-	if (res) {		printk(KERN_WARNING "FAILED\n  status = %x, message = %02x, "
-				    "host = %d, driver = %02x\n  ",
-				    status_byte(res), msg_byte(res),
-				    host_byte(res), driver_byte(res));
-			if (driver_byte(res) & DRIVER_SENSE)
-				scsi_print_sense_hdr("sd", &sshdr);
+	if (res) {
+		printk(KERN_WARNING "FAILED\n  status = %x, message = %02x, "
+		       "host = %d, driver = %02x\n  ",
+		       status_byte(res), msg_byte(res),
+		       host_byte(res), driver_byte(res));
+		if (driver_byte(res) & DRIVER_SENSE)
+			scsi_print_sense_hdr("sd", &sshdr);
 	}
 
 	return res;


