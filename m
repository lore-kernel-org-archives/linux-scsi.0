From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] Fix a bdi reregistration race, v2
Date: Tue, 24 Nov 2015 15:23:21 -0800
Message-ID: <5654F169.6070000@sandisk.com>
References: <564F9AFF.3050605@sandisk.com>
 <20151124231331.GA25591@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20151124231331.GA25591@infradead.org>
Sender: owner-linux-mm@kvack.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@fb.com>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, Hannes Reinecke <hare@suse.de>, Aaro Koskinen <aaro.koskinen@iki.fi>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-mm@kvack.org
List-Id: linux-scsi@vger.kernel.org

On 11/24/2015 03:13 PM, Christoph Hellwig wrote:
> What sort of re-registration is this? Seems like we should only
> release the minor number once the bdi is released.

Hello Christoph,

As you most likely know the BDI device name for disks is based on the 
device major and minor number:

$ ls -l /dev/sda
brw-rw---- 1 root disk 8, 0 Nov 24 14:53 /dev/sda
$ ls -l /sys/block/sda/bdi
lrwxrwxrwx 1 root root 0 Nov 24 15:17 /sys/block/sda/bdi -> 
../../../../../../../../virtual/bdi/8:0

So if a driver stops using a (major, minor) number pair and the same 
device number is reused before the bdi device has been released the 
warning mentioned in the patch description at the start of this thread 
is triggered. This patch fixes that race by removing the bdi device from 
sysfs during the __scsi_remove_device() call instead of when the bdi 
device is released.

Bart.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
