From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: cciss update [2/2] fixes for Steeleye Lifekeeper
Date: 15 Oct 2004 10:05:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1097852716.1718.9.camel@mulgrave>
References: <20041013212253.GB9866@beardog.cca.cpqcorp.net>
	<20041014083900.GB7747@infradead.org> <1097764660.2198.11.camel@mulgrave>
	<20041014183948.GA12325@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:24026 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267953AbUJOPFk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Oct 2004 11:05:40 -0400
In-Reply-To: <20041014183948.GA12325@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: mikem@beardog.cca.cpqcorp.net, Andrew Morton <akpm@osdl.org>, Jens Axboe <axboe@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-10-14 at 13:39, Christoph Hellwig wrote:
> Such a volume has been configured and set up, and although it's still
> ugly I'd say it's okay.  But the patch also adds one gendisk per controller
> even if no volume is set up.

That's this bit of code:

@@ -2762,7 +2810,9 @@ static int __devinit cciss_init_one(stru
                disk->fops = &cciss_fops;
                disk->queue = hba[i]->queue;
                disk->private_data = drv;
-               if( !(drv->nr_blocks))
+               /* we must register the controller even if no disks
exist */
+               /* this is for the online array utilities */
+               if(!drv->heads && j)
                        continue;
                blk_queue_hardsect_size(hba[i]->queue, drv->block_size);
                set_capacity(disk, drv->nr_blocks);

Mike, is there a way we can only allocate a gendisk when we know there's
actually a device there (if owned by another controller currently)?

James


