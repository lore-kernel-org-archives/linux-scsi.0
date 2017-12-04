From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] SCSI: delay run queue if device is blocked in
 scsi_dev_queue_ready()
Date: Mon, 4 Dec 2017 16:34:46 +0800
Message-ID: <20171204083440.GA10261@ming.t460p>
References: <20171202163150.1273-1-ming.lei@redhat.com>
 <mqdindmoqga.fsf@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <mqdindmoqga.fsf@linux-x5ow.site>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 04, 2017 at 09:19:33AM +0100, Johannes Thumshirn wrote:
> 
> Hi Ming,
> 
> Ming Lei <ming.lei@redhat.com> writes:
> > This issue can be triggered by the following script:
> >
> > 	#!/bin/sh
> > 	rmmod scsi_debug
> > 	modprobe scsi_debug max_queue=1
> >
> > 	DEVICE=`ls -d /sys/bus/pseudo/drivers/scsi_debug/adapter*/host*/target*/*/block/* | head -1 | xargs basename`
> >
> > 	DISK_DIR=`ls -d /sys/block/$DEVICE/device/scsi_disk/*`
> >
> > 	echo "using scsi device $DEVICE"
> > 	echo "-1" >/sys/bus/pseudo/drivers/scsi_debug/every_nth
> > 	echo starting loop $i
> > 	echo "temporary write through" >$DISK_DIR/cache_type
> > 	echo "128" >/sys/bus/pseudo/drivers/scsi_debug/opts
> > 	echo none > /sys/block/$DEVICE/queue/scheduler
> > 	dd if=/dev/$DEVICE of=/dev/null bs=1M iflag=direct count=1 &
> > 	sleep 5
> > 	echo "0" >/sys/bus/pseudo/drivers/scsi_debug/opts
> > 	wait
> > 	echo "SUCCESS"
> 
> Can you please submit a test-case for blktest as well, given you have a
> nice reproducer?

Hi Johannes,

I am happy to do that, but recently I am very busy, so it may be done
a bit late by me.

But anyone should reproduce the issue 100% with V4.15-rc kernel by just
running the above script, not any specific hardware is required at all,
so that means anyone can make a patch for blktest to test block/SCSI
timeout if he/she is interested in doing that.

Thanks,
Ming
