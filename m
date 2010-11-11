From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/2] target: remove dead DF_* flags
Date: Thu, 11 Nov 2010 03:07:10 -0800
Message-ID: <1289473630.2867.110.camel@haakon2.linux-iscsi.org>
References: <20101111104040.GA21472@infradead.org>
	 <20101111104056.GB21472@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:59679 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab0KKLMW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2010 06:12:22 -0500
In-Reply-To: <20101111104056.GB21472@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Thu, 2010-11-11 at 05:40 -0500, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
   
> Index: lio-core-2.6/drivers/target/target_core_iblock.c
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/target_core_iblock.c	2010-11-11 11:32:33.198165135 +0100
> +++ lio-core-2.6/drivers/target/target_core_iblock.c	2010-11-11 11:33:55.878165135 +0100
> @@ -180,7 +180,6 @@ static struct se_device *iblock_create_v
>  	dev_limits.hw_queue_depth = IBLOCK_MAX_DEVICE_QUEUE_DEPTH;
>  	dev_limits.queue_depth = IBLOCK_DEVICE_QUEUE_DEPTH;
>  
> -	dev_flags = DF_CLAIMED_BLOCKDEV;
>  	ib_dev->ibd_major = MAJOR(bd->bd_dev);
>  	ib_dev->ibd_minor = MINOR(bd->bd_dev);
>  	ib_dev->ibd_bd = bd;
> Index: lio-core-2.6/drivers/target/target_core_rd.c
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/target_core_rd.c	2010-11-11 11:32:33.214831800 +0100
> +++ lio-core-2.6/drivers/target/target_core_rd.c	2010-11-11 11:33:55.878165135 +0100
> @@ -272,9 +272,6 @@ static struct se_device *rd_create_virtd
>  
>  	memset(&dev_limits, 0, sizeof(struct se_dev_limits));
>  
> -	if (rd_dev->rd_direct)
> -		dev_flags |= DF_TRANSPORT_DMA_ALLOC;
> -
>  	if (rd_build_device_space(rd_dev) < 0)
>  		goto fail;
>  

This is still required by RAMDISK_DR to allow the backend to perform the
se_task->task_sg[] mapping from the ramdisk provided struct scatterlists
using se_subsystem_api->allocate_dma()

So commited as b9f63304e9, w/o dropping DF_TRANSPORT_DMA_ALLOC..

> Index: lio-core-2.6/drivers/target/target_core_transport.c
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/target_core_transport.c	2010-11-11 11:32:57.781498467 +0100
> +++ lio-core-2.6/drivers/target/target_core_transport.c	2010-11-11 11:33:55.881498468 +0100
> @@ -1983,13 +1983,6 @@ static void core_setup_task_attr_emulati
>  		TRANSPORT(dev)->get_device_rev(dev));
>  }
>  
> -/*	transport_add_device_to_core_hba():
> - *
> - *	Note that some plugins (IBLOCK) will pass device_flags ==
> - *	DF_CLAIMED_BLOCKDEV signifying OS that a dependent block_device
> - *	has been claimed.  In exception cases we will release said
> - *	block_device ourselves.
> - */
>  struct se_device *transport_add_device_to_core_hba(
>  	struct se_hba *hba,
>  	struct se_subsystem_api *transport,
> Index: lio-core-2.6/include/target/target_core_transport.h
> ===================================================================
> --- lio-core-2.6.orig/include/target/target_core_transport.h	2010-11-11 11:32:57.788165135 +0100
> +++ lio-core-2.6/include/target/target_core_transport.h	2010-11-11 11:34:28.824831800 +0100
> @@ -59,16 +59,9 @@
>  /*
>   * struct se_device->dev_flags
>   */
> -#define DF_READAHEAD_ACTIVE                     0x00000001
> -#define DF_TRANSPORT_DMA_ALLOC			0x00000002
> -#define DF_TRANSPORT_BUF_ALLOC			0x00000004

Btw, just as a historical note for fun..

The DF_TRANSPORT_BUF_ALLOC flag was originally used by a now extinct
v2.2/v2.4 backend driver (iscsi_target_ata.c) for the old drivers/ide/
code that required a single contigious buffer to be setup on the non
cache coherent MIPS r5900 (the Playstation2 for non linux-mips.org
folks) -> r3000 IOP DMA to the single channel PATA expansion adapter.

Anyways, once some aspring MIPS kernel hacker can take the time to
figure out how to boot a modern Linux/MIPS kernel on the r5900 we can
revist this particular issue again, eg: supporting contigiously
allocated buffer for SCF_SCSI_DATA_SG_IO_CDB type descriptors, which
still is working the same today for modern iSCSI target fabric code.

Anyways this may still be useful for less obsecure cases than the r5900,
but none immediatedly come to mind.  ;)

Thanks!

--nab




