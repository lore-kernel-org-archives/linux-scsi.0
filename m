From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: bytes/CDB of SCSI pass thru grossly limited maybe
Date: 26 Aug 2004 17:20:20 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1093562420.12881.3.camel@patlinux.iomegacorp.com>
References: <20040731141240.GE23697@suse.de><1092678938.4235.37.camel@patlin
	ux.iomegacorp.com><20040823154648.GB2301@suse.de> <20040823170827.GC24089@s
	use.de><E04775E6-F529-11D8-BFA2-00039398BB5E@ieee.org><20040823181715.GA244
	99@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:41617 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S269708AbUHZXVm
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Aug 2004 19:21:42 -0400
In-Reply-To: <20040823181715.GA24499@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org

Jens A:

> You can play with bigger transfers with something ala this applied,
> will allow you to pass in <= 512KiB/command.

Exactly what we needed, thank you.  As quoted below, I immediately found
I could run up as far as 1 MiB = 2048 * 512 bytes, no worries.

Any chance of a max_sectors setting appearing in /sys for ide-cd ATAPI =
SCSI over IDE, like we have already for SCSI over USB and SCSI over
FireWire?

> ATA damaged.

I remember ATA has a max_sectors of about xFF (255) in the 28-bit LBA
protocol, only the new 48-bit protocol allows xFFFF (65535).  Much
theory argues that x00 and x0000 should represent x100 and x10000, but
hosts often don't take that risk.

Pat LaVarre

+++ linux-2.6.9-rc1-bk2-pel/drivers/ide/ide-cd.c	2004-08-26 17:08:52.944300264 -0600
@@ -3142,6 +3142,7 @@ int ide_cdrom_setup (ide_drive_t *drive)
 
 	blk_queue_prep_rq(drive->queue, ide_cdrom_prep_fn);
 	blk_queue_dma_alignment(drive->queue, 31);
+	blk_queue_max_sectors(drive->queue, 2048);
 	drive->queue->unplug_delay = (1 * HZ) / 1000;
 	if (!drive->queue->unplug_delay)
 		drive->queue->unplug_delay = 1;


