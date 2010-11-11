From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: take advantage of REQ_FUA in the iblock backend
Date: Wed, 10 Nov 2010 23:42:54 -0800
Message-ID: <1289461374.2867.10.camel@haakon2.linux-iscsi.org>
References: <20101110210229.GA24988@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:52593 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757794Ab0KKHsM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2010 02:48:12 -0500
In-Reply-To: <20101110210229.GA24988@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Wed, 2010-11-10 at 16:02 -0500, Christoph Hellwig wrote:
> Since 2.6.37-rc barriers have been replaced with the REQ_FLUSH and
> REQ_FUA flags.  Both flags work on all devices without a need to check
> for barrier functionality.
> 
> Use this fact to simplify the iblock code.  Use the REQ_FUA flag when
> we report a write cache or if the target set the FUA bit, and remove
> all the barrier detection code.
> 
> Btw, I think iblock would benefit from sharing a common option with
> the file backend for enabling or disabling the option to provide
> a voltile write cache to the initiator or not.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Everything looks good, thanks for the cleanup Christoph!  Committed as
67f4b72.

Also just FYI, the modepage caching bit (WCE=1) and EVPD 0x86 volatile
cache supported bit (V_SUP=1) can be explictly disabled by backends
reporting support for write caching emulation
(se_subsystem_api->write_cache_emulated() == 1) with:

echo 0 > /sys/kernel/config/target/core/$HBA/$DEV/attrib/emulate_write_cache

Note the currently available backend overrides for various control bits
look like:

-rw-r--r-- 1 root root 4096 2010-11-09 01:18 emulate_dpo
-rw-r--r-- 1 root root 4096 2010-11-09 01:18 emulate_fua_read
-rw-r--r-- 1 root root 4096 2010-11-09 01:18 emulate_fua_write
-rw-r--r-- 1 root root 4096 2010-11-09 01:18 emulate_tas
-rw-r--r-- 1 root root 4096 2010-11-10 23:39 emulate_tpu
-rw-r--r-- 1 root root 4096 2010-11-10 23:39 emulate_tpws
-rw-r--r-- 1 root root 4096 2010-11-09 01:18 emulate_ua_intlck_ctrl
-rw-r--r-- 1 root root 4096 2010-11-09 01:18 emulate_write_cache


> 
> Index: lio-core-2.6/drivers/target/target_core_iblock.c
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/target_core_iblock.c	2010-11-09 11:23:20.921529680 +0100
> +++ lio-core-2.6/drivers/target/target_core_iblock.c	2010-11-09 12:16:20.918196346 +0100
> @@ -130,8 +130,6 @@ static void *iblock_allocate_virtdevice(
>  	return ib_dev;
>  }
>  
> -static int __iblock_do_sync_cache(struct se_device *);
> -
>  static struct se_device *iblock_create_virtdevice(
>  	struct se_hba *hba,
>  	struct se_subsystem_dev *se_dev,
> @@ -194,14 +192,7 @@ static struct se_device *iblock_create_v
>  		goto failed;
>  
>  	ib_dev->ibd_depth = dev->queue_depth;
> -	/*
> -	 * Check if the underlying struct block_device supports the
> -	 * block/blk-barrier.c:blkdev_issue_flush() call, depending upon
> -	 * which the SCSI mode page bits for WriteCache=1 and DPOFUA=1
> -	 * will be enabled by TCM Core.
> -	 */
> -	if (__iblock_do_sync_cache(dev) == 0)
> -		ib_dev->ibd_flags |= IBDF_BDEV_ISSUE_FLUSH;
> +
>  	/*
>  	 * Check if the underlying struct block_device request_queue supports
>  	 * the QUEUE_FLAG_DISCARD bit for UNMAP/WRITE_SAME in SCSI + TRIM
> @@ -352,51 +343,37 @@ static unsigned long long iblock_emulate
>  	return blocks_long;
>  }
>  
> -static int __iblock_do_sync_cache(struct se_device *dev)
> -{
> -	struct iblock_dev *ib_dev = (struct iblock_dev *)dev->dev_ptr;
> -	sector_t error_sector;
> -	int ret;
> -
> -	ret = blkdev_issue_flush(ib_dev->ibd_bd, GFP_KERNEL, &error_sector);
> -	if (ret != 0) {
> -		printk(KERN_ERR "IBLOCK: block_issue_flush() failed: %d "
> -			" error_sector: %llu\n", ret,
> -			(unsigned long long)error_sector);
> -		return -1;
> -	}
> -	DEBUG_IBLOCK("IBLOCK: Called block_issue_flush()\n");
> -	return 0;
> -}
> -
>  /*
> - * Called by target_core_transport():transport_emulate_control_cdb()
> - * to emulate SYCHRONIZE_CACHE_*
> + * Emulate SYCHRONIZE_CACHE_*
>   */
> -void iblock_emulate_sync_cache(struct se_task *task)
> +static void iblock_emulate_sync_cache(struct se_task *task)
>  {
>  	struct se_cmd *cmd = TASK_CMD(task);
> -	int ret, immed = (T_TASK(cmd)->t_task_cdb[1] & 0x2);
> +	struct iblock_dev *ib_dev = cmd->se_dev->dev_ptr;
> +	int immed = (T_TASK(cmd)->t_task_cdb[1] & 0x2);
> +	sector_t error_sector;
> +	int ret;
> +
>  	/*
>  	 * If the Immediate bit is set, queue up the GOOD response
>  	 * for this SYNCHRONIZE_CACHE op
>  	 */
>  	if (immed)
>  		transport_complete_sync_cache(cmd, 1);
> +
>  	/*
> -	 * block/blk-barrier.c:block_issue_flush() does not support a
> -	 * LBA + Range synchronization method, so for this case we
> -	 * have to flush the entire cache.
> +	 * blkdev_issue_flush() does not support a specifying a range, so
> +	 * we have to flush the entire cache.
>  	 */
> -	ret = __iblock_do_sync_cache(cmd->se_dev);
> -	if (ret < 0) {
> -		if (!(immed))
> -			transport_complete_sync_cache(cmd, 0);
> -		return;
> +	ret = blkdev_issue_flush(ib_dev->ibd_bd, GFP_KERNEL, &error_sector);
> +	if (ret != 0) {
> +		printk(KERN_ERR "IBLOCK: block_issue_flush() failed: %d "
> +			" error_sector: %llu\n", ret,
> +			(unsigned long long)error_sector);
>  	}
>  
> -	if (!(immed))
> -		transport_complete_sync_cache(cmd, 1);
> +	if (!immed)
> +		transport_complete_sync_cache(cmd, ret == 0);
>  }
>  
>  /*
> @@ -405,11 +382,7 @@ void iblock_emulate_sync_cache(struct se
>   */
>  int iblock_emulated_write_cache(struct se_device *dev)
>  {
> -	struct iblock_dev *ib_dev = (struct iblock_dev *)dev->dev_ptr;
> -	/*
> -	 * Only return WCE if ISSUE_FLUSH is supported
> -	 */	
> -	return (ib_dev->ibd_flags & IBDF_BDEV_ISSUE_FLUSH) ? 1 : 0;
> +	return 1;
>  }
>  
>  int iblock_emulated_dpo(struct se_device *dev)
> @@ -423,11 +396,7 @@ int iblock_emulated_dpo(struct se_device
>   */
>  int iblock_emulated_fua_write(struct se_device *dev)
>  {
> -	struct iblock_dev *ib_dev = (struct iblock_dev *)dev->dev_ptr;
> -	/*
> -	 * Only return FUA WRITE if ISSUE_FLUSH is supported
> -	 */
> -	return (ib_dev->ibd_flags & IBDF_BDEV_ISSUE_FLUSH) ? 1 : 0;
> +	return 1;
>  }
>  
>  int iblock_emulated_fua_read(struct se_device *dev)
> @@ -442,8 +411,22 @@ static int iblock_do_task(struct se_task
>  	struct iblock_dev *ibd = (struct iblock_dev *)req->ib_dev;
>  	struct request_queue *q = bdev_get_queue(ibd->ibd_bd);
>  	struct bio *bio = req->ib_bio, *nbio = NULL;
> -	int write = (TASK_CMD(task)->data_direction == DMA_TO_DEVICE);
> -	int ret;
> +	int rw;
> +
> +	if (TASK_CMD(task)->data_direction == DMA_TO_DEVICE) {
> +		/*
> +		 * Force data to disk if we pretend to not have a volatile
> +		 * write cache, or the initiator set the Force Unit Access bit.
> +		 */
> +		if (DEV_ATTRIB(dev)->emulate_write_cache == 0 ||
> +		    (DEV_ATTRIB(dev)->emulate_fua_write > 0 &&
> +		     T_TASK(task->task_se_cmd)->t_tasks_fua))
> +			rw = WRITE_FUA;
> +		else
> +			rw = WRITE;
> +	} else {
> +		rw = READ;
> +	}
>  
>  	while (bio) {
>  		nbio = bio->bi_next;
> @@ -451,30 +434,12 @@ static int iblock_do_task(struct se_task
>  		DEBUG_IBLOCK("Calling submit_bio() task: %p bio: %p"
>  			" bio->bi_sector: %llu\n", task, bio, bio->bi_sector);
>  
> -		submit_bio(write, bio);
> +		submit_bio(rw, bio);
>  		bio = nbio;
>  	}
>  
>  	if (q->unplug_fn)
>  		q->unplug_fn(q);
> -	/*
> -	 * Check for Forced Unit Access WRITE emulation
> -	 */
> -	if ((DEV_ATTRIB(dev)->emulate_write_cache > 0) &&
> -	    (DEV_ATTRIB(dev)->emulate_fua_write > 0) &&
> -	    write && T_TASK(task->task_se_cmd)->t_tasks_fua) {
> -		/*
> -		 * We might need to be a bit smarter here
> -		 * and return some sense data to let the initiator
> -		 * know the FUA WRITE cache sync failed..?
> -		 */
> -		ret = __iblock_do_sync_cache(dev);
> -		if (ret < 0) {
> -			printk(KERN_ERR "__iblock_do_sync_cache()"
> -				" failed for FUA Write\n");
> -		}
> -	}
> -
>  	return PYX_TRANSPORT_SENT_TO_TRANSPORT;
>  }
>  
> Index: lio-core-2.6/drivers/target/target_core_iblock.h
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/target_core_iblock.h	2010-11-09 11:23:25.454863013 +0100
> +++ lio-core-2.6/drivers/target/target_core_iblock.h	2010-11-09 11:23:35.334863016 +0100
> @@ -23,7 +23,6 @@ struct iblock_req {
>  
>  #define IBDF_HAS_UDEV_PATH		0x01
>  #define IBDF_HAS_FORCE			0x02
> -#define IBDF_BDEV_ISSUE_FLUSH		0x04
>  
>  struct iblock_dev {
>  	unsigned char ibd_udev_path[SE_UDEV_PATH_LEN];

