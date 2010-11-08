From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/9] target: remove activate_device/deactivate_device
	methods
Date: Mon, 08 Nov 2010 14:00:30 -0800
Message-ID: <1289253630.27226.72.camel@haakon2.linux-iscsi.org>
References: <20101108155601.872926000@canuck.infradead.org>
	 <20101108155647.147682800@canuck.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:43474 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171Ab0KHWFn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2010 17:05:43 -0500
In-Reply-To: <20101108155647.147682800@canuck.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Mon, 2010-11-08 at 10:56 -0500, Christoph Hellwig wrote:
> plain text document attachment (lio-cleanup-activate-deactivate)
> These are no-ops in all backends.  Also remove the waitqueues around
> kthread start/stop for each device as kthread_run/stop are synchronous.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Committed as a36ceb5.

Thanks!

--nab

> 
> Index: lio-core-2.6/drivers/target/target_core_file.c
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/target_core_file.c	2010-11-06 20:18:44.613011213 +0100
> +++ lio-core-2.6/drivers/target/target_core_file.c	2010-11-06 20:19:08.470663550 +0100
> @@ -266,38 +266,6 @@ fail:
>  	return NULL;
>  }
>  
> -/*	fd_activate_device(): (Part of se_subsystem_api_t template)
> - *
> - *
> - */
> -static int fd_activate_device(struct se_device *dev)
> -{
> -	struct fd_dev *fd_dev = dev->dev_ptr;
> -	struct fd_host *fd_host = fd_dev->fd_host;
> -
> -	printk(KERN_INFO "CORE_FILE[%u] - Activating Device with TCQ: %d at"
> -		" FILEIO Device ID: %d\n", fd_host->fd_host_id,
> -		fd_dev->fd_queue_depth, fd_dev->fd_dev_id);
> -
> -	return 0;
> -}
> -
> -/*	fd_deactivate_device(): (Part of se_subsystem_api_t template)
> - *
> - *
> - */
> -static void fd_deactivate_device(struct se_device *dev)
> -{
> -	struct fd_dev *fd_dev = dev->dev_ptr;
> -	struct fd_host *fd_host = fd_dev->fd_host;
> -
> -	printk(KERN_INFO "CORE_FILE[%u] - Deactivating Device with TCQ: %d at"
> -		" FILEIO Device ID: %d\n", fd_host->fd_host_id,
> -		fd_dev->fd_queue_depth, fd_dev->fd_dev_id);
> -
> -	return;
> -}
> -
>  /*	fd_free_device(): (Part of se_subsystem_api_t template)
>   *
>   *
> @@ -997,8 +965,6 @@ static struct se_subsystem_api fileio_te
>  	.cdb_write_SG		= fd_CDB_write_SG,
>  	.allocate_virtdevice	= fd_allocate_virtdevice,
>  	.create_virtdevice	= fd_create_virtdevice,
> -	.activate_device	= fd_activate_device,
> -	.deactivate_device	= fd_deactivate_device,
>  	.free_device		= fd_free_device,
>  	.dpo_emulated		= fd_emulated_dpo,
>  	.fua_write_emulated	= fd_emulated_fua_write,
> Index: lio-core-2.6/drivers/target/target_core_iblock.c
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/target_core_iblock.c	2010-11-06 20:17:55.062262645 +0100
> +++ lio-core-2.6/drivers/target/target_core_iblock.c	2010-11-06 20:18:39.142005277 +0100
> @@ -247,36 +247,6 @@ failed:
>  	return NULL;
>  }
>  
> -/*	iblock_activate_device(): (Part of se_subsystem_api_t template)
> - *
> - *
> - */
> -static int iblock_activate_device(struct se_device *dev)
> -{
> -	struct iblock_dev *ib_dev = dev->dev_ptr;
> -	struct iblock_hba *ib_hba = ib_dev->ibd_host;
> -
> -	printk(KERN_INFO "CORE_iBLOCK[%u] - Activating Device with TCQ: %d at"
> -		" Major: %d Minor %d\n", ib_hba->iblock_host_id,
> -		ib_dev->ibd_depth, ib_dev->ibd_major, ib_dev->ibd_minor);
> -
> -	return 0;
> -}
> -
> -/*	iblock_deactivate_device(): (Part of se_subsystem_api_t template)
> - *
> - *
> - */
> -static void iblock_deactivate_device(struct se_device *dev)
> -{
> -	struct iblock_dev *ib_dev = dev->dev_ptr;
> -	struct iblock_hba *ib_hba = ib_dev->ibd_host;
> -
> -	printk(KERN_INFO "CORE_iBLOCK[%u] - Deactivating Device with TCQ: %d"
> -		" at Major: %d Minor %d\n", ib_hba->iblock_host_id,
> -		ib_dev->ibd_depth, ib_dev->ibd_major, ib_dev->ibd_minor);
> -}
> -
>  static void iblock_free_device(void *p)
>  {
>  	struct iblock_dev *ib_dev = p;
> @@ -963,8 +933,6 @@ static struct se_subsystem_api iblock_te
>  	.detach_hba		= iblock_detach_hba,
>  	.allocate_virtdevice	= iblock_allocate_virtdevice,
>  	.create_virtdevice	= iblock_create_virtdevice,
> -	.activate_device	= iblock_activate_device,
> -	.deactivate_device	= iblock_deactivate_device,
>  	.free_device		= iblock_free_device,
>  	.dpo_emulated		= iblock_emulated_dpo,
>  	.fua_write_emulated	= iblock_emulated_fua_write,
> Index: lio-core-2.6/drivers/target/target_core_pscsi.c
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/target_core_pscsi.c	2010-11-06 20:18:54.140024065 +0100
> +++ lio-core-2.6/drivers/target/target_core_pscsi.c	2010-11-06 20:19:03.139048436 +0100
> @@ -565,42 +565,6 @@ static struct se_device *pscsi_create_vi
>  	return NULL;
>  }
>  
> -/*	pscsi_activate_device(): (Part of se_subsystem_api_t template)
> - *
> - *
> - */
> -static int pscsi_activate_device(struct se_device *dev)
> -{
> -	struct pscsi_dev_virt *pdv = dev->dev_ptr;
> -	struct pscsi_hba_virt *phv = pdv->pdv_se_hba->hba_ptr;
> -	struct scsi_device *sd = pdv->pdv_sd;
> -	struct Scsi_Host *sh = sd->host;
> -
> -	printk(KERN_INFO "CORE_PSCSI[%d] - Activating Device with TCQ: %d at"
> -		" SCSI Location (Host/Channel/Target/LUN) %d/%d/%d/%d\n",
> -		phv->phv_host_id, sd->queue_depth, sh->host_no, sd->channel,
> -		sd->id, sd->lun);
> -
> -	return 0;
> -}
> -
> -/*	pscsi_deactivate_device(): (Part of se_subsystem_api_t template)
> - *
> - *
> - */
> -static void pscsi_deactivate_device(struct se_device *dev)
> -{
> -	struct pscsi_dev_virt *pdv = dev->dev_ptr;
> -	struct pscsi_hba_virt *phv = pdv->pdv_se_hba->hba_ptr;
> -	struct scsi_device *sd = pdv->pdv_sd;
> -	struct Scsi_Host *sh = sd->host;
> -
> -	printk(KERN_INFO "CORE_PSCSI[%d] - Deactivating Device with TCQ: %d at"
> -		" SCSI Location (Host/Channel/Target/LUN) %d/%d/%d/%d\n",
> -		phv->phv_host_id, sd->queue_depth, sh->host_no, sd->channel,
> -		sd->id, sd->lun);
> -}
> -
>  /*	pscsi_free_device(): (Part of se_subsystem_api_t template)
>   *
>   *
> @@ -1532,8 +1496,6 @@ static struct se_subsystem_api pscsi_tem
>  	.attach_hba		= pscsi_attach_hba,
>  	.detach_hba		= pscsi_detach_hba,
>  	.pmode_enable_hba	= pscsi_pmode_enable_hba,
> -	.activate_device	= pscsi_activate_device,
> -	.deactivate_device	= pscsi_deactivate_device,
>  	.allocate_virtdevice	= pscsi_allocate_virtdevice,
>  	.create_virtdevice	= pscsi_create_virtdevice,
>  	.free_device		= pscsi_free_device,
> Index: lio-core-2.6/drivers/target/target_core_rd.c
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/target_core_rd.c	2010-11-06 20:19:14.701260270 +0100
> +++ lio-core-2.6/drivers/target/target_core_rd.c	2010-11-06 20:19:30.633255381 +0100
> @@ -330,36 +330,6 @@ static struct se_device *rd_MEMCPY_creat
>  	return rd_create_virtdevice(hba, se_dev, p, 0);
>  }
>  
> -/*	rd_activate_device(): (Part of se_subsystem_api_t template)
> - *
> - *
> - */
> -static int rd_activate_device(struct se_device *dev)
> -{
> -	struct rd_dev *rd_dev = dev->dev_ptr;
> -	struct rd_host *rd_host = rd_dev->rd_host;
> -
> -	printk(KERN_INFO "CORE_RD[%u] - Activating Device with TCQ: %d at"
> -		" Ramdisk Device ID: %d\n", rd_host->rd_host_id,
> -		rd_dev->rd_queue_depth, rd_dev->rd_dev_id);
> -
> -	return 0;
> -}
> -
> -/*	rd_deactivate_device(): (Part of se_subsystem_api_t template)
> - *
> - *
> - */
> -static void rd_deactivate_device(struct se_device *dev)
> -{
> -	struct rd_dev *rd_dev = dev->dev_ptr;
> -	struct rd_host *rd_host = rd_dev->rd_host;
> -
> -	printk(KERN_INFO "CORE_RD[%u] - Deactivating Device with TCQ: %d at"
> -		" Ramdisk Device ID: %d\n", rd_host->rd_host_id,
> -		rd_dev->rd_queue_depth, rd_dev->rd_dev_id);
> -}
> -
>  /*	rd_free_device(): (Part of se_subsystem_api_t template)
>   *
>   *
> @@ -1323,8 +1293,6 @@ static struct se_subsystem_api rd_dr_tem
>  	.detach_hba		= rd_detach_hba,
>  	.allocate_virtdevice	= rd_DIRECT_allocate_virtdevice,
>  	.create_virtdevice	= rd_DIRECT_create_virtdevice,
> -	.activate_device	= rd_activate_device,
> -	.deactivate_device	= rd_deactivate_device,
>  	.free_device		= rd_free_device,
>  	.transport_complete	= rd_transport_complete,
>  	.allocate_DMA		= rd_DIRECT_allocate_DMA,
> @@ -1363,8 +1331,6 @@ static struct se_subsystem_api rd_mcp_te
>  	.detach_hba		= rd_detach_hba,
>  	.allocate_virtdevice	= rd_MEMCPY_allocate_virtdevice,
>  	.create_virtdevice	= rd_MEMCPY_create_virtdevice,
> -	.activate_device	= rd_activate_device,
> -	.deactivate_device	= rd_deactivate_device,
>  	.free_device		= rd_free_device,
>  	.transport_complete	= rd_transport_complete,
>  	.allocate_request	= rd_allocate_request,
> Index: lio-core-2.6/drivers/target/target_core_stgt.c
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/target_core_stgt.c	2010-11-06 20:19:40.388254264 +0100
> +++ lio-core-2.6/drivers/target/target_core_stgt.c	2010-11-06 20:19:49.419190498 +0100
> @@ -314,40 +314,6 @@ static struct se_device *stgt_create_vir
>  	return NULL;
>  }
>  
> -/*	stgt_activate_device(): (Part of se_subsystem_api_t template)
> - *
> - *
> - */
> -static int stgt_activate_device(struct se_device *dev)
> -{
> -	struct stgt_dev_virt *sdv = dev->dev_ptr;
> -	struct scsi_device *sd = sdv->sdv_sd;
> -	struct Scsi_Host *sh = sd->host;
> -
> -	printk(KERN_INFO "CORE_STGT[%d] - Activating %s Device with TCQ: %d at"
> -		" SCSI Location (Channel/Target/LUN) %d/%d/%d\n", sh->host_no,
> -		(sdv->sdv_legacy) ? "Legacy" : "REQ",  sd->queue_depth,
> -		sd->channel, sd->id, sd->lun);
> -
> -	return 0;
> -}
> -
> -/*	stgt_deactivate_device(): (Part of se_subsystem_api_t template)
> - *
> - *
> - */
> -static void stgt_deactivate_device(struct se_device *dev)
> -{
> -	struct stgt_dev_virt *sdv = dev->dev_ptr;
> -	struct scsi_device *sd = sdv->sdv_sd;
> -	struct Scsi_Host *sh = sd->host;
> -
> -	printk(KERN_INFO "CORE_STGT[%d] - Deactivating %s Device with TCQ: %d"
> -		" at SCSI Location (Channel/Target/LUN) %d/%d/%d\n",
> -		sh->host_no, (sdv->sdv_legacy) ? "Legacy" : "REQ",
> -		sd->queue_depth, sd->channel, sd->id, sd->lun);
> -}
> -
>  /*	stgt_free_device(): (Part of se_subsystem_api_t template)
>   *
>   *
> @@ -877,8 +843,6 @@ static struct se_subsystem_api stgt_temp
>  	.cdb_write_SG		= stgt_CDB_write_SG,
>  	.attach_hba		= stgt_attach_hba,
>  	.detach_hba		= stgt_detach_hba,
> -	.activate_device	= stgt_activate_device,
> -	.deactivate_device	= stgt_deactivate_device,
>  	.allocate_virtdevice	= stgt_allocate_virtdevice,
>  	.create_virtdevice	= stgt_create_virtdevice,
>  	.free_device		= stgt_free_device,
> Index: lio-core-2.6/drivers/target/target_core_transport.c
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/target_core_transport.c	2010-11-06 20:20:04.617254054 +0100
> +++ lio-core-2.6/drivers/target/target_core_transport.c	2010-11-06 20:28:22.335005310 +0100
> @@ -503,8 +503,6 @@ void transport_init_queue_obj(struct se_
>  	atomic_set(&qobj->queue_cnt, 0);
>  	INIT_LIST_HEAD(&qobj->qobj_list);
>  	init_waitqueue_head(&qobj->thread_wq);
> -	init_completion(&qobj->thread_create_comp);
> -	init_completion(&qobj->thread_done_comp);
>  	spin_lock_init(&qobj->cmd_queue_lock);
>  }
>  EXPORT_SYMBOL(transport_init_queue_obj);
> @@ -2296,11 +2294,18 @@ struct se_device *transport_add_device_t
>  	 */
>  	if (core_setup_alua(dev, force_pt) < 0)
>  		goto out;
> +
>  	/*
>  	 * Startup the struct se_device processing thread
>  	 */
> -	if (transport_generic_activate_device(dev) < 0)
> +	dev->process_thread = kthread_run(transport_processing_thread, dev,
> +					  "LIO_%s", TRANSPORT(dev)->name);
> +	if (IS_ERR(dev->process_thread)) {
> +		printk(KERN_ERR "Unable to create kthread: LIO_%s\n",
> +			TRANSPORT(dev)->name);
>  		goto out;
> +	}
> +
>  	/*
>  	 * Preload the initial INQUIRY const values if we are doing
>  	 * anything virtual (IBLOCK, FILEIO, RAMDISK), but not for TCM/pSCSI
> @@ -2352,10 +2357,7 @@ struct se_device *transport_add_device_t
>  out:
>  	if (!ret)
>  		return dev;
> -	/*
> -	 * Release newly allocated state for struct se_device
> -	 */
> -	transport_generic_deactivate_device(dev);
> +	kthread_stop(dev->process_thread);
>  
>  	spin_lock(&hba->device_lock);
>  	list_del(&dev->dev_list);
> @@ -2372,46 +2374,6 @@ out:
>  }
>  EXPORT_SYMBOL(transport_add_device_to_core_hba);
>  
> -/*	transport_generic_activate_device():
> - *
> - *
> - */
> -int transport_generic_activate_device(struct se_device *dev)
> -{
> -	char name[16];
> -
> -	if (TRANSPORT(dev)->activate_device)
> -		TRANSPORT(dev)->activate_device(dev);
> -
> -	memset(name, 0, 16);
> -	snprintf(name, 16, "LIO_%s", TRANSPORT(dev)->name);
> -
> -	dev->process_thread = kthread_run(transport_processing_thread,
> -			(void *)dev, name);
> -	if (IS_ERR(dev->process_thread)) {
> -		printk(KERN_ERR "Unable to create kthread: %s\n", name);
> -		return -1;
> -	}
> -
> -	wait_for_completion(&dev->dev_queue_obj->thread_create_comp);
> -
> -	return 0;
> -}
> -
> -/*	transport_generic_deactivate_device():
> - *
> - *
> - */
> -void transport_generic_deactivate_device(struct se_device *dev)
> -{
> -	if (TRANSPORT(dev)->deactivate_device)
> -		TRANSPORT(dev)->deactivate_device(dev);
> -
> -	kthread_stop(dev->process_thread);
> -
> -	wait_for_completion(&dev->dev_queue_obj->thread_done_comp);
> -}
> -
>  /*	transport_generic_free_device():
>   *
>   *
> @@ -2421,7 +2383,7 @@ void transport_generic_free_device(struc
>  	if (!(dev->dev_ptr))
>  		return;
>  
> -	transport_generic_deactivate_device(dev);
> +	kthread_stop(dev->process_thread);
>  
>  	if (TRANSPORT(dev)->free_device)
>  		TRANSPORT(dev)->free_device(dev->dev_ptr);
> @@ -9098,8 +9060,6 @@ static int transport_processing_thread(v
>  	recalc_sigpending();
>  	spin_unlock_irq(&current->sighand->siglock);
>  
> -	complete(&dev->dev_queue_obj->thread_create_comp);
> -
>  	while (!(kthread_should_stop())) {
>  		ret = wait_event_interruptible(dev->dev_queue_obj->thread_wq,
>  				atomic_read(&dev->dev_queue_obj->queue_cnt) ||
> @@ -9187,6 +9147,5 @@ get_cmd:
>  out:
>  	transport_release_all_cmds(dev);
>  	dev->process_thread = NULL;
> -	complete(&dev->dev_queue_obj->thread_done_comp);
>  	return 0;
>  }
> Index: lio-core-2.6/drivers/target/tcm_fc/tfc_cmd.c
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/tcm_fc/tfc_cmd.c	2010-11-06 20:23:27.561023505 +0100
> +++ lio-core-2.6/drivers/target/tcm_fc/tfc_cmd.c	2010-11-06 20:24:45.698005617 +0100
> @@ -654,8 +654,6 @@ int ft_thread(void *arg)
>  	recalc_sigpending();
>  	spin_unlock_irq(&current->sighand->siglock);
>  
> -	complete(&qobj->thread_create_comp);
> -
>  	while (!(kthread_should_stop())) {
>  		ret = wait_event_interruptible(qobj->thread_wq,
>  			atomic_read(&qobj->queue_cnt) || kthread_should_stop());
> @@ -667,6 +665,5 @@ int ft_thread(void *arg)
>  	}
>  
>  out:
> -	complete(&qobj->thread_done_comp);
>  	return 0;
>  }
> Index: lio-core-2.6/drivers/target/tcm_fc/tfc_conf.c
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/tcm_fc/tfc_conf.c	2010-11-06 20:23:35.362254054 +0100
> +++ lio-core-2.6/drivers/target/tcm_fc/tfc_conf.c	2010-11-06 20:24:38.170005695 +0100
> @@ -342,7 +342,6 @@ static struct se_portal_group *ft_add_tp
>  		kfree(tpg);
>  		return NULL;
>  	}
> -	wait_for_completion(&tpg->qobj.thread_create_comp);
>  
>  	mutex_lock(&ft_lport_lock);
>  	list_add_tail(&tpg->list, &lacl->tpg_list);
> @@ -359,7 +358,6 @@ static void ft_del_tpg(struct se_portal_
>  		config_item_name(&tpg->se_tpg.tpg_group.cg_item));
>  	
>  	kthread_stop(tpg->thread);
> -	wait_for_completion(&tpg->qobj.thread_done_comp);
>  
>  	/* Wait for sessions to be freed thru RCU, for BUG_ON below */
>  	synchronize_rcu();
> Index: lio-core-2.6/include/target/target_core_base.h
> ===================================================================
> --- lio-core-2.6.orig/include/target/target_core_base.h	2010-11-06 20:23:53.939003740 +0100
> +++ lio-core-2.6/include/target/target_core_base.h	2010-11-06 20:27:11.226005136 +0100
> @@ -415,8 +415,6 @@ struct se_queue_obj {
>  	spinlock_t		cmd_queue_lock;
>  	struct list_head	qobj_list;
>  	wait_queue_head_t	thread_wq;
> -	struct completion	thread_create_comp;
> -	struct completion	thread_done_comp;
>  } ____cacheline_aligned;
>  
>  /*
> Index: lio-core-2.6/include/target/target_core_transport.h
> ===================================================================
> --- lio-core-2.6.orig/include/target/target_core_transport.h	2010-11-06 20:21:04.487003811 +0100
> +++ lio-core-2.6/include/target/target_core_transport.h	2010-11-06 20:21:09.952587550 +0100
> @@ -191,8 +191,6 @@ extern struct se_device *transport_add_d
>  					struct se_subsystem_dev *, u32,
>  					void *, struct se_dev_limits *,
>  					const char *, const char *);
> -extern int transport_generic_activate_device(struct se_device *);
> -extern void transport_generic_deactivate_device(struct se_device *);
>  extern void transport_generic_free_device(struct se_device *);
>  extern int transport_generic_allocate_iovecs(struct se_cmd *);
>  extern void transport_device_setup_cmd(struct se_cmd *);
> @@ -383,14 +381,6 @@ struct se_subsystem_api {
>  	struct se_device *(*create_virtdevice)(struct se_hba *,
>  				struct se_subsystem_dev *, void *);
>  	/*
> -	 * activate_device():
> -	 */
> -	int (*activate_device)(struct se_device *);
> -	/*
> -	 * deactivate_device():
> -	 */
> -	void (*deactivate_device)(struct se_device *);
> -	/*
>  	 * free_device():
>  	 */
>  	void (*free_device)(void *);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

