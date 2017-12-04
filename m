From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] SCSI: delay run queue if device is blocked in scsi_dev_queue_ready()
Date: Mon, 04 Dec 2017 09:19:33 +0100
Message-ID: <mqdindmoqga.fsf@linux-x5ow.site>
References: <20171202163150.1273-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171202163150.1273-1-ming.lei@redhat.com> (Ming Lei's message
        of "Sun, 3 Dec 2017 00:31:50 +0800")
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org


Hi Ming,

Ming Lei <ming.lei@redhat.com> writes:
> This issue can be triggered by the following script:
>
> 	#!/bin/sh
> 	rmmod scsi_debug
> 	modprobe scsi_debug max_queue=1
>
> 	DEVICE=`ls -d /sys/bus/pseudo/drivers/scsi_debug/adapter*/host*/target*/*/block/* | head -1 | xargs basename`
>
> 	DISK_DIR=`ls -d /sys/block/$DEVICE/device/scsi_disk/*`
>
> 	echo "using scsi device $DEVICE"
> 	echo "-1" >/sys/bus/pseudo/drivers/scsi_debug/every_nth
> 	echo starting loop $i
> 	echo "temporary write through" >$DISK_DIR/cache_type
> 	echo "128" >/sys/bus/pseudo/drivers/scsi_debug/opts
> 	echo none > /sys/block/$DEVICE/queue/scheduler
> 	dd if=/dev/$DEVICE of=/dev/null bs=1M iflag=direct count=1 &
> 	sleep 5
> 	echo "0" >/sys/bus/pseudo/drivers/scsi_debug/opts
> 	wait
> 	echo "SUCCESS"

Can you please submit a test-case for blktest as well, given you have a
nice reproducer?

Thanks,
        Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
