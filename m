From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [BUG] Oops when SCSI device under multipath is removed
Date: Thu, 11 Aug 2011 09:24:02 +0900
Message-ID: <4E432122.9050101@ce.jp.nec.com>
References: <4E420941.3080601@ce.jp.nec.com> <1313005933.2785.12.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:51022 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab1HKA0s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Aug 2011 20:26:48 -0400
In-Reply-To: <1313005933.2785.12.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: jaxboe@fusionio.com, roland@purestorage.com, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>

Hi James,

On 08/11/11 04:52, James Bottomley wrote:
> On Wed, 2011-08-10 at 13:29 +0900, Jun'ichi Nomura wrote:
>> 2 patches have been proposed but neither of them included:
>>   1) Add QUEUE_FLAG_DEAD check in blk_insert_cloned_request()
>>      https://lkml.org/lkml/2011/7/8/457
>>   2) SCSI to call blk_cleanup_queue() from device's ->release() callback
>>      (before 2.6.39, it used to work like this)
>>      https://lkml.org/lkml/2011/7/2/106
> 
> Well, they both have documented objections.  I asked why we destroy the
> elevator in the del case and didn't get any traction, so let me show the
> actual patch which should fix all of these issues.
> 
> Is there a good reason for not doing this as a bug fix now?
> 
> James
> 
> ---
> diff --git a/block/blk-core.c b/block/blk-core.c
> index b627558..cc72b7d 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -367,11 +367,6 @@ void blk_cleanup_queue(struct request_queue *q)
>  	queue_flag_set_unlocked(QUEUE_FLAG_DEAD, q);
>  	mutex_unlock(&q->sysfs_lock);
>  
> -	if (q->elevator)
> -		elevator_exit(q->elevator);
> -
> -	blk_throtl_exit(q);
> -
>  	blk_put_queue(q);
>  }
>  EXPORT_SYMBOL(blk_cleanup_queue);
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index 0ee17b5..a5a756b 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -477,6 +477,11 @@ static void blk_release_queue(struct kobject *kobj)
>  
>  	blk_sync_queue(q);
>  
> +	if (q->elevator)
> +		elevator_exit(q->elevator);
> +
> +	blk_throtl_exit(q);
> +
>  	if (rl->rq_pool)
>  		mempool_destroy(rl->rq_pool);

I think it doesn't work because elevator_exit() and
blk_throtl_exit() take &q->queue_lock, which may be freed
by LLD after blk_cleanup_queue, before blk_release_queue.

Vivek's comment here describes it in detail:
https://lkml.org/lkml/2011/7/12/279

Vivek Goyal wrote:
> I thought a driver could either rely on spin lock provided by request
> queue or override that by providing its own spinlock.
> 
> blk_init_allocated_queue_node()
>         /* Override internal queue lock with supplied lock pointer */
>         if (lock)
>                 q->queue_lock           = lock;
> So if driver calls blk_cleanup_queue() and drops its reference on queue, then
> it should be free to release any memory it has allocated for spinlock.
> So though queue is around there are no gurantees that q->queue_lock is
> still around. That memory might have been freed by driver and reused.
> 
> I see many drivers are providing their own locks. Some samples from
> drivers/block.
> 
> /virtio_blk.c:	q = vblk->disk->queue = blk_init_queue(do_virtblk_request,
> &vblk->lock);
> ./xd.c:	xd_queue = blk_init_queue(do_xd_request, &xd_lock);
> ./cpqarray.c:	q = blk_init_queue(do_ida_request, &hba[i]->lock);
> ./sx8.c:	q = blk_init_queue(carm_rq_fn, &host->lock);
> ./sx8.c:	q = blk_init_queue(carm_oob_rq_fn, &host->lock);
> ./floppy.c:	disks[dr]->queue = blk_init_queue(do_fd_request, &floppy_lock);
> ./viodasd.c:	q = blk_init_queue(do_viodasd_request, &d->q_lock);
> ./cciss.c:	disk->queue = blk_init_queue(do_cciss_request, &h->lock);
> ./hd.c:	hd_queue = blk_init_queue(do_hd_request, &hd_lock);
> ./DAC960.c:  	RequestQueue = blk_init_queue(DAC960_RequestFunction,&Controller->queue_lock);
> ./z2ram.c:    z2_queue = blk_init_queue(do_z2_request, &z2ram_lock);
> ./amiflop.c:	disk->queue = blk_init_queue(do_fd_request, &amiflop_lock);
> ./xen-blkfront.c:	rq = blk_init_queue(do_blkif_request, &blkif_io_lock);
> ./paride/pd.c:	pd_queue = blk_init_queue(do_pd_request, &pd_lock);
> ./paride/pf.c:	pf_queue = blk_init_queue(do_pf_request, &pf_spin_lock);
> ./paride/pcd.c:	pcd_queue = blk_init_queue(do_pcd_request, &pcd_lock);
> ./mg_disk.c:	host->breq = blk_init_queue(mg_request_poll, &host->lock);
> ./mg_disk.c:	host->breq = blk_init_queue(mg_request, &host->lock);
> ./rbd.c:	q = blk_init_queue(rbd_rq_fn, &rbd_dev->lock);
> ./sunvdc.c:	q = blk_init_queue(do_vdc_request, &port->vio.lock);
> ./swim.c:	swd->queue = blk_init_queue(do_fd_request, &swd->lock);
> ./xsysace.c:	ace->queue = blk_init_queue(ace_request, &ace->lock);
> ./osdblk.c:	q = blk_init_queue(osdblk_rq_fn, &osdev->lock);
> ./ps3disk.c:	queue = blk_init_queue(ps3disk_request, &priv->lock);
> ./swim3.c:	swim3_queue = blk_init_queue(do_fd_request, &swim3_lock);
> ./ub.c:	if ((q = blk_init_queue(ub_request_fn, sc->lock)) == NULL)
> ./nbd.c:	disk->queue = blk_init_queue(do_nbd_request, &nbd_lock);

# SCSI doesn't hit this problem because it uses
# queue_lock embedded in struct request_queue.


Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
