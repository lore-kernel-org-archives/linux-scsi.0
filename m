From: Jens Axboe <axboe@suse.de>
Subject: Re: bytes/CDB of SCSI pass thru grossly limited maybe
Date: Mon, 23 Aug 2004 20:17:15 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040823181715.GA24499@suse.de>
References: <20040731141240.GE23697@suse.de> <1092678938.4235.37.camel@patlinux.iomegacorp.com> <20040823154648.GB2301@suse.de> <20040823170827.GC24089@suse.de> <E04775E6-F529-11D8-BFA2-00039398BB5E@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:54742 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S266491AbUHWSRU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Aug 2004 14:17:20 -0400
Content-Disposition: inline
In-Reply-To: <E04775E6-F529-11D8-BFA2-00039398BB5E@ieee.org>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org

On Mon, Aug 23 2004, Pat LaVarre wrote:
> Jens A:
> 
> >What you can shove into the cdb is of lesser interest than the fact 
> >that
> >ATAPI itself cannot do more than
> 
> Yes.
> 
> >the request_queue structure in blkdev.h, you'll find such things as:
> >
> >        unsigned short          max_sectors;
> >        unsigned short          max_phys_segments;
> >        unsigned short          max_hw_segments;
> >        unsigned int            max_segment_size;
> >
> >which are set by the driver and limit how big a request you can submit
> >through SG_IO.
> 
> I will return to study this further.
> 
> Sorry I still do not yet immediately understand precisely who is 
> limiting what.
> 
> I do not see how these 16 and 32 bit limits correspond to a 128 KiB 
> limit on how many bytes of data may accompany a CDB.  Instead I see:
> 
> (1 << (4 + 16)) is 1 Mi.
> (1 << (9 + 16)) is 32 Mi.
> (1 << (11 + 16)) is 128 Mi.
> 
> (1 << 9) is 0.5 Ki, often = B/LBA of HDD
> (1 << 11) is 2 Ki, often = B/LBA of DVD/CD.
> (1 << 12) is 4 Ki, often = B/page of x86 virtual memory
> (1 << 16) is 64 Ki.
> (1 << 32) is 4 Ti.
> 
> No 128 Ki anywhere.
> 
> >What you can shove into the cdb is of lesser interest than the fact 
> >that
> >ATAPI itself cannot do more than 128KiB _per command_.
> 
> Possibly I have misunderstood what is "ATAPI itself"?
> 
> The PIO and DMA I know in PATAPI do not limit data bytes per command.  
> Even PIO limits only data bytes per DRQ, not per command.
> 
> I think PATAPI itself is the standard launched by SFF 8020i that 
> appears now at ANSI/ NCITS t13.org.  I see that standard as a transport 
> for SCSI over IDE, with no definite limit on data per command, though 
> arguably the UDMA CRC may grow less reliable if the host and device 
> neglect to cooperate to insert such CRC often into the data.
> 
> I see PATAPI does limit max bytes of CDB, to 16 (x10) else to 12 (xC), 
> by neglecting to enumerate any other CDB-containing packet lengths for 
> the op xA1 "IDENTIFY" data to request.

Sorry my clowning around, I'm too ATA damaged. You can play with bigger
transfers with something ala this applied, will allow you to pass in <=
512KiB/command.

===== drivers/ide/ide-cd.c 1.89 vs edited =====
--- 1.89/drivers/ide/ide-cd.c	2004-08-13 02:03:53 +02:00
+++ edited/drivers/ide/ide-cd.c	2004-08-23 20:15:52 +02:00
@@ -3138,6 +3138,7 @@
 
 	blk_queue_prep_rq(drive->queue, ide_cdrom_prep_fn);
 	blk_queue_dma_alignment(drive->queue, 31);
+	blk_queue_max_sectors(drive->queue, 1024);
 	drive->queue->unplug_delay = (1 * HZ) / 1000;
 	if (!drive->queue->unplug_delay)
 		drive->queue->unplug_delay = 1;

-- 
Jens Axboe

