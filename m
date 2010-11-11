From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/2] target: kill CONFIG_TCM_DEBUG_DEV
Date: Thu, 11 Nov 2010 02:46:16 -0800
Message-ID: <1289472376.2867.90.camel@haakon2.linux-iscsi.org>
References: <20101111104040.GA21472@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:36689 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab0KKKv2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2010 05:51:28 -0500
In-Reply-To: <20101111104040.GA21472@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Thu, 2010-11-11 at 05:40 -0500, Christoph Hellwig wrote:
> __iscsi_debug_dev doesn't compile and isn't actually used anywhere.  Remove
> it and the surrounding infrastructure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 

Commited as 67e05b3fde.

Thanks!

> Index: lio-core-2.6/drivers/target/lio-target/iscsi_target.c
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/lio-target/iscsi_target.c	2010-11-11 11:32:02.234831800 +0100
> +++ lio-core-2.6/drivers/target/lio-target/iscsi_target.c	2010-11-11 11:32:57.778165134 +0100
> @@ -939,10 +939,6 @@ static int iscsi_target_detect(void)
>  	spin_lock_init(&iscsi_global->debug_erl_lock);
>  #endif /* DEBUG_ERL */
>  
> -#ifdef DEBUG_DEV
> -	spin_lock_init(&iscsi_global->debug_dev_lock);
> -#endif
> -
>  	dir_entry = proc_mkdir("iscsi_target", 0);
>  	if (!(dir_entry)) {
>  		printk(KERN_ERR "proc_mkdir() failed.\n");
> Index: lio-core-2.6/drivers/target/target_core_transport.c
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/target_core_transport.c	2010-11-11 11:32:33.221498468 +0100
> +++ lio-core-2.6/drivers/target/target_core_transport.c	2010-11-11 11:32:57.781498467 +0100
> @@ -413,71 +413,6 @@ void release_se_global(void)
>  	se_global = NULL;
>  }
>  
> -#ifdef DEBUG_DEV
> -
> -/* warning FIXME: PLUGIN API TODO */
> -int __iscsi_debug_dev(struct se_device *dev)
> -{
> -	int fail_task = 0;
> -	fd_dev_t *fd_dev;
> -	iblock_dev_t *ib_dev;
> -	rd_dev_t *rd_dev;
> -	struct scsi_device *sd;
> -
> -	spin_lock(&se_global->debug_dev_lock);
> -	switch (dev->se_hba->type) {
> -	case PSCSI:
> -		sd = (struct scsi_device *) dev->dev_ptr;
> -		if (dev->dev_flags & DF_DEV_DEBUG) {
> -			printk(KERN_INFO "HBA[%u] - Failing PSCSI Task for"
> -				" %d/%d/%d\n", dev->se_hba->hba_id,
> -				sd->channel, sd->id, sd->lun);
> -			fail_task = 1;
> -		}
> -		break;
> -	case IBLOCK:
> -		ib_dev = (iblock_dev_t *) dev->dev_ptr;
> -		if (dev->dev_flags & DF_DEV_DEBUG) {
> -			printk(KERN_INFO "HBA[%u] - Failing IBLOCK Task for"
> -				" %u/%u\n", dev->se_hba->hba_id,
> -				ib_dev->ibd_major, ib_dev->ibd_minor);
> -			fail_task = 1;
> -		}
> -		break;
> -	case FILEIO:
> -		fd_dev = (fd_dev_t *) dev->dev_ptr;
> -		if (dev->dev_flags & DF_DEV_DEBUG) {
> -			printk(KERN_INFO "HBA[%u] - Failing FILEIO Task for"
> -				" %u\n", dev->se_hba->hba_id,
> -				fd_dev->fd_dev_id);
> -			fail_task = 1;
> -		}
> -		break;
> -	case RAMDISK_DR:
> -	case RAMDISK_MCP:
> -		rd_dev = (rd_dev_t *) dev->dev_ptr;
> -		if (dev->dev_flags & DF_DEV_DEBUG) {
> -			printk(KERN_INFO "HBA[%u] - Failing RAMDISK Task for"
> -				" %u\n", dev->se_hba->hba_id,
> -				rd_dev->rd_dev_id);
> -			fail_task = 1;
> -		}
> -		break;
> -	default:
> -		if (dev->dev_flags & DF_DEV_DEBUG) {
> -			printk(KERN_INFO "HBA[%u] - Failing unknown Task\n",
> -				dev->se_hba->hba_id);
> -			fail_task = 1;
> -		}
> -		break;
> -	}
> -	spin_unlock(&se_global->debug_dev_lock);
> -
> -	return fail_task;
> -}
> -
> -#endif /* DEBUG_DEV */
> -
>  void transport_init_queue_obj(struct se_queue_obj *qobj)
>  {
>  	atomic_set(&qobj->queue_cnt, 0);
> @@ -1229,17 +1164,6 @@ check_task_stop:
>  	}
>  	atomic_dec(&T_TASK(cmd)->t_task_cdbs_timeout_left);
>  
> -#ifdef DEBUG_DEV
> -	if (dev) {
> -		if (__iscsi_debug_dev(dev) != 0) {
> -			success = 0;
> -			task->task_scsi_status = 1;
> -			cmd->transport_error_status =
> -				PYX_TRANSPORT_LU_COMM_FAILURE;
> -		}
> -	}
> -#endif /* DEBUG_DEV */
> -
>  	/*
>  	 * Decrement the outstanding t_task_cdbs_left count.  The last
>  	 * struct se_task from struct se_cmd will complete itself into the
> Index: lio-core-2.6/include/target/target_core_base.h
> ===================================================================
> --- lio-core-2.6.orig/include/target/target_core_base.h	2010-11-11 11:32:02.000000000 +0100
> +++ lio-core-2.6/include/target/target_core_base.h	2010-11-11 11:32:57.784831801 +0100
> @@ -1057,9 +1057,6 @@ struct se_global {
>  	spinlock_t		se_tpg_lock;
>  	spinlock_t		lu_gps_lock;
>  	spinlock_t		plugin_class_lock;
> -#ifdef DEBUG_DEV
> -	spinlock_t		debug_dev_lock;
> -#endif
>  } ____cacheline_aligned;
>  
>  #endif /* TARGET_CORE_BASE_H */
> Index: lio-core-2.6/include/target/target_core_transport.h
> ===================================================================
> --- lio-core-2.6.orig/include/target/target_core_transport.h	2010-11-11 11:32:33.000000000 +0100
> +++ lio-core-2.6/include/target/target_core_transport.h	2010-11-11 11:32:57.788165135 +0100
> @@ -132,9 +132,6 @@ struct se_subsystem_api;
>  
>  extern int init_se_global(void);
>  extern void release_se_global(void);
> -#ifdef DEBUG_DEV
> -extern int __iscsi_debug_dev(struct se_device *);
> -#endif
>  extern void transport_init_queue_obj(struct se_queue_obj *);
>  extern int transport_subsystem_check_init(void);
>  extern int transport_subsystem_register(struct se_subsystem_api *);
> Index: lio-core-2.6/drivers/target/Kbuild
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/Kbuild	2010-11-11 11:32:02.251498468 +0100
> +++ lio-core-2.6/drivers/target/Kbuild	2010-11-11 11:32:57.798165135 +0100
> @@ -16,10 +16,6 @@ target_core_mod-y		:= target_core_config
>  				   target_core_rd.o \
>  				   target_core_mib.o
>  
> -ifdef CONFIG_TCM_DEBUG_DEV
> -EXTRA_CFLAGS			+= -DDEBUG_DEV
> -endif
> -
>  obj-$(CONFIG_TARGET_CORE)	+= target_core_mod.o
>  
>  # Subsystem modules
> Index: lio-core-2.6/drivers/target/Kconfig
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/Kconfig	2010-11-11 11:32:02.261498467 +0100
> +++ lio-core-2.6/drivers/target/Kconfig	2010-11-11 11:32:57.801498468 +0100
> @@ -5,13 +5,6 @@ config TARGET_CORE
>      ---help---
>      Say Y or M here to enable the TCM Storage Engine and ConfigFS enabled control path for target_core_mod.  This includes built-in TCM RAMDISK subsystem logic for virtual LUN 0 access
>  
> -config TCM_DEBUG_DEV
> -	tristate "TCM Debug device code"
> -	depends on TARGET_CORE
> -	default n
> -	---help---
> -	Say Y here to enable the TCM Debug device code
> -
>  config TCM_IBLOCK
>  	tristate "TCM/IBLOCK Subsystem Plugin for Linux/BLOCK"
>  	depends on TARGET_CORE

