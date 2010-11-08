From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 6/9] target: remove dead blockdevice claim/release code
Date: Mon, 08 Nov 2010 14:35:18 -0800
Message-ID: <1289255718.27226.91.camel@haakon2.linux-iscsi.org>
References: <20101108155601.872926000@canuck.infradead.org>
	 <20101108155648.286575749@canuck.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:54393 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab0KHWkb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2010 17:40:31 -0500
In-Reply-To: <20101108155648.286575749@canuck.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Mon, 2010-11-08 at 10:56 -0500, Christoph Hellwig wrote:
> plain text document attachment (lio-cleanup-claim)
> This code is entirely unused - even the last reference to
> linux_blockdevice_release was unreachable at this point.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Committed as 6c52636e761.  There is still one piece of lio-utils.git
code that depends on this, but I will get this fixed up and pushed into
lio-utils.git/master shortly.

Thanks!

--nab

> 
> Index: lio-core-2.6/drivers/target/target_core_device.c
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/target_core_device.c	2010-11-08 15:52:26.154863014 +0100
> +++ lio-core-2.6/drivers/target/target_core_device.c	2010-11-08 15:57:14.058196347 +0100
> @@ -50,111 +50,6 @@
>  #include "target_core_pr.h"
>  #include "target_core_ua.h"
>  
> -struct block_device *__linux_blockdevice_claim(
> -	int major,
> -	int minor,
> -	void *claim_ptr,
> -	int *ret)
> -{
> -	dev_t dev;
> -	struct block_device *bd;
> -
> -	dev = MKDEV(major, minor);
> -
> -	bd = bdget(dev);
> -	if (!(bd)) {
> -		*ret = -1;
> -		return NULL;
> -	}
> -
> -	if (blkdev_get(bd, FMODE_WRITE|FMODE_READ) < 0) {
> -		*ret = -1;
> -		return NULL;
> -	}
> -	/*
> -	 * If no claim pointer was passed from claimee, use struct block_device.
> -	 */
> -	if (!claim_ptr)
> -		claim_ptr = (void *)bd;
> -
> -	if (bd_claim(bd, claim_ptr) < 0) {
> -		blkdev_put(bd, FMODE_WRITE|FMODE_READ);
> -		*ret = 0;
> -		return bd;
> -	}
> -
> -	*ret = 1;
> -	return bd;
> -}
> -
> -struct block_device *linux_blockdevice_claim(
> -	int major,
> -	int minor,
> -	void *claim_ptr)
> -{
> -	dev_t dev;
> -	struct block_device *bd;
> -
> -	dev = MKDEV(major, minor);
> -
> -	bd = bdget(dev);
> -	if (!(bd))
> -		return NULL;
> -
> -	if (blkdev_get(bd, FMODE_WRITE|FMODE_READ) < 0)
> -		return NULL;
> -	/*
> -	 * If no claim pointer was passed from claimee, use struct block_device.
> -	 */
> -	if (!claim_ptr)
> -		claim_ptr = (void *)bd;
> -
> -	if (bd_claim(bd, claim_ptr) < 0) {
> -		blkdev_put(bd, FMODE_WRITE|FMODE_READ);
> -		return NULL;
> -	}
> -
> -	return bd;
> -}
> -EXPORT_SYMBOL(linux_blockdevice_claim);
> -
> -int linux_blockdevice_release(int major, int minor, struct block_device *bd_p)
> -{
> -	dev_t dev;
> -	struct block_device *bd;
> -
> -	if (!bd_p) {
> -		dev = MKDEV(major, minor);
> -
> -		bd = bdget(dev);
> -		if (!(bd))
> -			return -1;
> -	} else
> -		bd = bd_p;
> -
> -	bd_release(bd);
> -	blkdev_put(bd, FMODE_WRITE|FMODE_READ);
> -
> -	return 0;
> -}
> -EXPORT_SYMBOL(linux_blockdevice_release);
> -
> -int linux_blockdevice_check(int major, int minor)
> -{
> -	struct block_device *bd;
> -
> -	bd = linux_blockdevice_claim(major, minor, NULL);
> -	if (!(bd))
> -		return -1;
> -	/*
> -	 * Blockdevice was able to be claimed, now unclaim it and return success
> -	 */
> -	linux_blockdevice_release(major, minor, NULL);
> -
> -	return 0;
> -}
> -EXPORT_SYMBOL(linux_blockdevice_check);
> -
>  extern int __transport_get_lun_for_cmd(
>  	struct se_cmd *se_cmd,
>  	u32 unpacked_lun)
> Index: lio-core-2.6/drivers/target/target_core_file.c
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/target_core_file.c	2010-11-08 15:54:21.721529679 +0100
> +++ lio-core-2.6/drivers/target/target_core_file.c	2010-11-08 15:55:27.531529681 +0100
> @@ -234,14 +234,7 @@ static struct se_device *fd_create_virtd
>  	dev_limits.max_cdb_len = TCM_MAX_COMMAND_SIZE;
>  	dev_limits.hw_queue_depth = FD_MAX_DEVICE_QUEUE_DEPTH;
>  	dev_limits.queue_depth = FD_DEVICE_QUEUE_DEPTH;
> -	/*
> -	 * Pass dev_flags for linux_blockdevice_claim_bd or
> -	 * linux_blockdevice_claim() from the usage above.
> -	 *
> -	 * Note that transport_add_device_to_core_hba() will call
> -	 * linux_blockdevice_release() internally on failure to
> -	 * call bd_release() on the referenced struct block_device.
> -	 */
> +
>  	dev = transport_add_device_to_core_hba(hba, &fileio_template,
>  				se_dev, dev_flags, (void *)fd_dev,
>  				&dev_limits, "FILEIO", FD_VERSION);
> Index: lio-core-2.6/drivers/target/target_core_file.h
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/target_core_file.h	2010-11-08 15:52:03.078196347 +0100
> +++ lio-core-2.6/drivers/target/target_core_file.h	2010-11-08 15:56:30.278196346 +0100
> @@ -16,10 +16,6 @@
>  #define FD_DATA_NONE		3
>  
>  extern struct se_global *se_global;
> -extern struct block_device *__linux_blockdevice_claim(int, int, void *, int *);
> -extern struct block_device *linux_blockdevice_claim(int, int, void *);
> -extern int linux_blockdevice_release(int, int, struct block_device *);
> -extern int linux_blockdevice_check(int, int);
>  
>  #define RRF_EMULATE_CDB		0x01
>  #define RRF_GOT_LBA		0x02
> Index: lio-core-2.6/drivers/target/target_core_iblock.c
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/target_core_iblock.c	2010-11-08 15:54:21.734863014 +0100
> +++ lio-core-2.6/drivers/target/target_core_iblock.c	2010-11-08 16:03:22.868196349 +0100
> @@ -187,15 +187,7 @@ static struct se_device *iblock_create_v
>  	ib_dev->ibd_major = MAJOR(bd->bd_dev);
>  	ib_dev->ibd_minor = MINOR(bd->bd_dev);
>  	ib_dev->ibd_bd = bd;
> -	ib_dev->ibd_flags |= IBDF_BDEV_EXCLUSIVE;
> -	/*
> -	 * Pass dev_flags for linux_blockdevice_claim() or
> -	 * linux_blockdevice_claim() from the usage above.
> -	 *
> -	 * Note that transport_add_device_to_core_hba() will call
> -	 * linux_blockdevice_release() internally on failure to
> -	 * call bd_release() on the referenced struct block_device.
> -	 */
> +
>  	dev = transport_add_device_to_core_hba(hba,
>  			&iblock_template, se_dev, dev_flags, (void *)ib_dev,
>  			&dev_limits, "IBLOCK", IBLOCK_VERSION);
> @@ -251,25 +243,8 @@ static void iblock_free_device(void *p)
>  {
>  	struct iblock_dev *ib_dev = p;
>  
> -	if (ib_dev->ibd_bd) {
> -		printk(KERN_INFO "IBLOCK: Releasing Major:Minor - %d:%d\n",
> -			ib_dev->ibd_major, ib_dev->ibd_minor);
> -
> -		if (ib_dev->ibd_flags & IBDF_BDEV_EXCLUSIVE)
> -			close_bdev_exclusive(ib_dev->ibd_bd,
> -				FMODE_WRITE|FMODE_READ);
> -		else
> -			linux_blockdevice_release(ib_dev->ibd_major,
> -					ib_dev->ibd_minor, ib_dev->ibd_bd);
> -		ib_dev->ibd_bd = NULL;
> -	}
> -
> -	if (ib_dev->ibd_bio_set) {
> -		DEBUG_IBLOCK("Calling bioset_free ib_dev->ibd_bio_set: %p\n",
> -				ib_dev->ibd_bio_set);
> -		bioset_free(ib_dev->ibd_bio_set);
> -	}
> -
> +	close_bdev_exclusive(ib_dev->ibd_bd, FMODE_WRITE|FMODE_READ);
> +	bioset_free(ib_dev->ibd_bio_set);
>  	kfree(ib_dev);
>  }
>  
> Index: lio-core-2.6/drivers/target/target_core_iblock.h
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/target_core_iblock.h	2010-11-08 15:59:59.918196346 +0100
> +++ lio-core-2.6/drivers/target/target_core_iblock.h	2010-11-08 16:00:08.661529684 +0100
> @@ -23,8 +23,7 @@ struct iblock_req {
>  
>  #define IBDF_HAS_UDEV_PATH		0x01
>  #define IBDF_HAS_FORCE			0x02
> -#define IBDF_BDEV_EXCLUSIVE		0x04
> -#define IBDF_BDEV_ISSUE_FLUSH		0x08
> +#define IBDF_BDEV_ISSUE_FLUSH		0x04
>  
>  struct iblock_dev {
>  	unsigned char ibd_udev_path[SE_UDEV_PATH_LEN];
> Index: lio-core-2.6/drivers/target/target_core_pscsi.h
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/target_core_pscsi.h	2010-11-08 15:53:09.088196347 +0100
> +++ lio-core-2.6/drivers/target/target_core_pscsi.h	2010-11-08 15:56:11.404863014 +0100
> @@ -20,9 +20,6 @@
>  #define PS_TIMEOUT_OTHER	(500*HZ)
>  
>  extern struct se_global *se_global;
> -extern struct block_device *linux_blockdevice_claim(int, int, void *);
> -extern int linux_blockdevice_release(int, int, struct block_device *);
> -extern int linux_blockdevice_check(int, int);
>  
>  #include <linux/device.h>
>  #include <scsi/scsi_driver.h>
> Index: lio-core-2.6/drivers/target/target_core_stgt.h
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/target_core_stgt.h	2010-11-08 15:53:17.704863012 +0100
> +++ lio-core-2.6/drivers/target/target_core_stgt.h	2010-11-08 15:56:13.564863014 +0100
> @@ -12,9 +12,6 @@
>  #define PS_TIMEOUT_OTHER	(500*HZ)
>  
>  extern struct se_global *se_global;
> -extern struct block_device *linux_blockdevice_claim(int, int, void *);
> -extern int linux_blockdevice_release(int, int, struct block_device *);
> -extern int linux_blockdevice_check(int, int);
>  
>  #include <linux/device.h>
>  #include <scsi/scsi_driver.h>
> Index: lio-core-2.6/include/target/target_core_device.h
> ===================================================================
> --- lio-core-2.6.orig/include/target/target_core_device.h	2010-11-08 15:52:18.101529681 +0100
> +++ lio-core-2.6/include/target/target_core_device.h	2010-11-08 15:56:17.911529680 +0100
> @@ -3,10 +3,6 @@
>  
>  extern struct se_global *se_global;
>  
> -extern struct block_device *__linux_blockdevice_claim(int, int, void *, int *);
> -extern struct block_device *linux_blockdevice_claim(int, int, void *);
> -extern int linux_blockdevice_release(int, int, struct block_device *);
> -extern int linux_blockdevice_check(int, int);
>  extern int transport_get_lun_for_cmd(struct se_cmd *, unsigned char *, u32);
>  extern int transport_get_lun_for_tmr(struct se_cmd *, u32);
>  extern struct se_dev_entry *core_get_se_deve_from_rtpi(
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

