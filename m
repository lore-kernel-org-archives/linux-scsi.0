From: Luben Tuikov <tluben@rogers.com>
Subject: Re: [PATCH] introduce scsi_host_alloc
Date: Fri, 06 Jun 2003 16:24:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EE0F86B.4060908@rogers.com>
References: <20030606080103.GC18838@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep04-mail.bloor.is.net.cable.rogers.com ([66.185.86.74]:51161
	"EHLO fep04-mail.bloor.is.net.cable.rogers.com") by vger.kernel.org
	with ESMTP id S262259AbTFFUKj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2003 16:10:39 -0400
In-Reply-To: <20030606080103.GC18838@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> Rediffed version, with Mike's isp fix and taking the new
> scsi_add_host users in usb in account.
> 
> Currently this is juist a new name for scsi_register, but we make
> sure new-style drivers never call scsi_register/scsi_unregister
> but always scsi_host_alloc/scsi_host_put in this patch so the

Why don't you call this scsi_host_free() to complement scsi_host_alloc()?
Why do you need to reveal implementation by naming it scsi_host_put()?
As far as the caller of scsi_host_put() is concerned they MUST NOT
dereference the host thereafter, so you can safely call it scsi_host_free().
(_When_ it is actually it is freed is what is being hidded as implementation.)

-- 
Luben




> next patch can introduce code specific to legacy drivers in
> the former.  Also cleanup scsi_register/scsi_host_alloc a bit.
> 
> 
> diff -Nru a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
> --- a/drivers/block/cciss_scsi.c	Tue Jun  3 00:42:21 2003
> +++ b/drivers/block/cciss_scsi.c	Tue Jun  3 00:42:21 2003
> @@ -698,7 +698,7 @@
>  {
>  	struct Scsi_Host *sh;
>  
> -	sh = scsi_register(&cciss_driver_template, sizeof(struct ctlr_info *));
> +	sh = scsi_host_alloc(&cciss_driver_template, sizeof(struct ctlr_info *));
>  	if (sh == NULL)
>  		return 0;
>  
> @@ -1357,7 +1357,7 @@
>  	if (sa->registered) {
>  		spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
>  		scsi_remove_host(sa->scsi_host);
> -		scsi_unregister(sa->scsi_host);
> +		scsi_host_put(sa->scsi_host);
>  		spin_lock_irqsave(CCISS_LOCK(ctlr), flags);
>  	}
>  
> diff -Nru a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
> --- a/drivers/ieee1394/sbp2.c	Tue Jun  3 00:42:21 2003
> +++ b/drivers/ieee1394/sbp2.c	Tue Jun  3 00:42:21 2003
> @@ -705,7 +705,7 @@
>  		return hi;
>  
>  	/* Register our host with the SCSI stack. */
> -	scsi_host = scsi_register (&scsi_driver_template, 0);
> +	scsi_host = scsi_host_alloc(&scsi_driver_template, 0);
>  	if (!scsi_host) {
>  		SBP2_ERR("failed to register scsi host");
>  		return NULL;
> @@ -714,7 +714,7 @@
>  	hi = hpsb_create_hostinfo(&sbp2_highlevel, host, sizeof(*hi));
>  	if (!hi) {
>  		SBP2_ERR("failed to allocate hostinfo");
> -		scsi_unregister(hi->scsi_host);
> +		scsi_host_put(hi->scsi_host);
>  	}
>  
>  	hpsb_set_hostinfo_key(&sbp2_highlevel, host, (unsigned long)scsi_host);
> @@ -730,7 +730,7 @@
>  	 * enabled (scsi-host uses classdata member of the device). */
>  	if (scsi_add_host(hi->scsi_host, NULL)) {
>  		SBP2_ERR("failed to add scsi host");
> -		scsi_unregister(hi->scsi_host);
> +		scsi_host_put(hi->scsi_host);
>  		hpsb_destroy_hostinfo(&sbp2_highlevel, host);
>  	}
>  
> @@ -751,7 +751,7 @@
>  
>  	if (hi) {
>  		scsi_remove_host(hi->scsi_host);
> -		scsi_unregister(hi->scsi_host);
> +		scsi_host_put(hi->scsi_host);
>  	}
>  }
>  
> diff -Nru a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
> --- a/drivers/scsi/53c700.c	Tue Jun  3 00:42:21 2003
> +++ b/drivers/scsi/53c700.c	Tue Jun  3 00:42:21 2003
> @@ -293,7 +293,8 @@
>  		tpnt->proc_name = "53c700";
>  	
>  
> -	if((host = scsi_register(tpnt, 4)) == NULL)
> +	host = scsi_host_alloc(tpnt, 4);
> +	if (!host)
>  		return NULL;
>  	memset(hostdata->slots, 0, sizeof(struct NCR_700_command_slot)
>  	       * NCR_700_COMMAND_SLOTS_PER_HOST);
> diff -Nru a/drivers/scsi/NCR_D700.c b/drivers/scsi/NCR_D700.c
> --- a/drivers/scsi/NCR_D700.c	Tue Jun  3 00:42:21 2003
> +++ b/drivers/scsi/NCR_D700.c	Tue Jun  3 00:42:21 2003
> @@ -223,7 +223,7 @@
>  	return 0;
>  
>   irq_failed:
> -	scsi_unregister(host);
> +	scsi_host_put(host);
>  	NCR_700_release(host);
>   detect_failed:
>  	release_region(host->base, 64);
> diff -Nru a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
> --- a/drivers/scsi/aic7xxx/aic79xx_osm.c	Tue Jun  3 00:42:21 2003
> +++ b/drivers/scsi/aic7xxx/aic79xx_osm.c	Tue Jun  3 00:42:21 2003
> @@ -2098,7 +2098,7 @@
>  	u_long	target;
>  
>  	template->name = ahd->description;
> -	host = scsi_register(template, sizeof(struct ahd_softc *));
> +	host = scsi_host_alloc(template, sizeof(struct ahd_softc *));
>  	if (host == NULL)
>  		return (ENOMEM);
>  
> @@ -2308,7 +2308,7 @@
>  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
>  			scsi_remove_host(ahd->platform_data->host);
>  #endif
> -			scsi_unregister(ahd->platform_data->host);
> +			scsi_host_put(ahd->platform_data->host);
>  		}
>  
>  		/* destroy all of the device and target objects */
> diff -Nru a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> --- a/drivers/scsi/aic7xxx/aic7xxx_osm.c	Tue Jun  3 00:42:21 2003
> +++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c	Tue Jun  3 00:42:21 2003
> @@ -1725,7 +1725,7 @@
>  	u_int	 targ_offset;
>  
>  	template->name = ahc->description;
> -	host = scsi_register(template, sizeof(struct ahc_softc *));
> +	host = scsi_host_alloc(template, sizeof(struct ahc_softc *));
>  	if (host == NULL)
>  		return (ENOMEM);
>  
> @@ -1978,7 +1978,7 @@
>  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
>  			scsi_remove_host(ahc->platform_data->host);
>  #endif
> -			scsi_unregister(ahc->platform_data->host);
> +			scsi_host_put(ahc->platform_data->host);
>  		}
>  
>  		/* destroy all of the device and target objects */
> diff -Nru a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
> --- a/drivers/scsi/arm/acornscsi.c	Tue Jun  3 00:42:21 2003
> +++ b/drivers/scsi/arm/acornscsi.c	Tue Jun  3 00:42:21 2003
> @@ -2993,7 +2993,7 @@
>  	AS_Host *ashost;
>  	int ret = -ENOMEM;
>  
> -	host = scsi_register(&acornscsi_template, sizeof(AS_Host));
> +	host = scsi_host_alloc(&acornscsi_template, sizeof(AS_Host));
>  	if (!host)
>  		goto out;
>  
> @@ -3060,7 +3060,7 @@
>   err_2:
>  	release_region(host->io_port + 0x800, 2);
>   err_1:
> -	scsi_unregister(host);
> +	scsi_host_put(host);
>   out:
>  	return ret;
>  }
> @@ -3089,6 +3089,7 @@
>  	msgqueue_free(&ashost->scsi.msgs);
>  	queue_free(&ashost->queues.disconnected);
>  	queue_free(&ashost->queues.issue);
> +	scsi_host_put(host);
>  }
>  
>  static const struct ecard_id acornscsi_cids[] = {
> diff -Nru a/drivers/scsi/arm/cumana_1.c b/drivers/scsi/arm/cumana_1.c
> --- a/drivers/scsi/arm/cumana_1.c	Tue Jun  3 00:42:21 2003
> +++ b/drivers/scsi/arm/cumana_1.c	Tue Jun  3 00:42:21 2003
> @@ -262,7 +262,7 @@
>  	struct Scsi_Host *host;
>  	int ret = -ENOMEM;
>  
> -	host = scsi_register(&cumanascsi_template, sizeof(struct NCR5380_hostdata));
> +	host = scsi_host_alloc(&cumanascsi_template, sizeof(struct NCR5380_hostdata));
>  	if (!host)
>  		goto out;
>  
> @@ -304,7 +304,7 @@
>   out_release:
>  	release_region(host->io_port, host->n_io_port);
>   out_free:
> -	scsi_unregister(host);
> +	scsi_host_put(host);
>   out:
>  	return ret;
>  }
> @@ -318,7 +318,7 @@
>  	scsi_remove_host(host);
>  	free_irq(host->irq, host);
>  	release_region(host->io_port, host->n_io_port);
> -	scsi_unregister(host);
> +	scsi_host_put(host);
>  }
>  
>  static const struct ecard_id cumanascsi1_cids[] = {
> diff -Nru a/drivers/scsi/arm/ecoscsi.c b/drivers/scsi/arm/ecoscsi.c
> --- a/drivers/scsi/arm/ecoscsi.c	Tue Jun  3 00:42:21 2003
> +++ b/drivers/scsi/arm/ecoscsi.c	Tue Jun  3 00:42:21 2003
> @@ -177,7 +177,7 @@
>  static int __init ecoscsi_init(void)
>  {
>  
> -	host = scsi_register(tpnt, sizeof(struct NCR5380_hostdata));
> +	host = scsi_host_alloc(tpnt, sizeof(struct NCR5380_hostdata));
>  	if (!host)
>  		return 0;
>  
> @@ -211,7 +211,7 @@
>  release_reg:
>  	release_region(host->io_port, host->n_io_port);
>  unregister_scsi:
> -	scsi_unregister(host);
> +	scsi_host_put(host);
>  	return -ENODEV;
>  }
>  
> @@ -224,7 +224,7 @@
>  	if (shpnt->io_port)
>  		release_region(shpnt->io_port, shpnt->n_io_port);
>  
> -	scsi_unregister(host);
> +	scsi_host_put(host);
>  	return 0;
>  }
>  
> diff -Nru a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
> --- a/drivers/scsi/arm/fas216.c	Tue Jun  3 00:42:21 2003
> +++ b/drivers/scsi/arm/fas216.c	Tue Jun  3 00:42:21 2003
> @@ -2942,6 +2942,7 @@
>  	scsi_remove_host(host);
>  
>  	fas216_writeb(info, REG_CMD, CMD_RESETCHIP);
> +	scsi_host_put(host);
>  }
>  
>  /**
> diff -Nru a/drivers/scsi/arm/oak.c b/drivers/scsi/arm/oak.c
> --- a/drivers/scsi/arm/oak.c	Tue Jun  3 00:42:21 2003
> +++ b/drivers/scsi/arm/oak.c	Tue Jun  3 00:42:21 2003
> @@ -135,7 +135,7 @@
>  	struct Scsi_Host *host;
>  	int ret = -ENOMEM;
>  
> -	host = scsi_register(&oakscsi_template, sizeof(struct NCR5380_hostdata));
> +	host = scsi_host_alloc(&oakscsi_template, sizeof(struct NCR5380_hostdata));
>  	if (!host)
>  		goto out;
>  
> @@ -163,7 +163,7 @@
>  
>  	release_region(host->io_port, host->n_io_port);
>   unreg:
> -	scsi_unregister(host);
> +	scsi_host_put(host);
>   out:
>  	return ret;
>  }
> @@ -176,7 +176,7 @@
>  	scsi_remove_host(host);
>  
>  	release_region(host->io_port, host->n_io_port);
> -	scsi_unregister(host);
> +	scsi_host_put(host);
>  }
>  
>  static const struct ecard_id oakscsi_cids[] = {
> diff -Nru a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> --- a/drivers/scsi/hosts.c	Tue Jun  3 00:42:21 2003
> +++ b/drivers/scsi/hosts.c	Tue Jun  3 00:42:21 2003
> @@ -135,15 +135,6 @@
>  }
>  
>  /**
> - * scsi_unregister - unregister a scsi host
> - * @shost:	scsi host to be unregistered
> - **/
> -void scsi_unregister(struct Scsi_Host *shost)
> -{
> -	scsi_host_put(shost);
> -}
> -
> -/**
>   * scsi_free_sdev - free a scsi hosts resources
>   * @shost:	scsi host to free 
>   **/
> @@ -172,60 +163,59 @@
>  }
>  
>  /**
> - * scsi_register - register a scsi host adapter instance.
> - * @shost_tp:	pointer to scsi host template
> - * @xtr_bytes:	extra bytes to allocate for driver
> + * scsi_host_alloc - register a scsi host adapter instance.
> + * @sht:	pointer to scsi host template
> + * @privsize:	extra bytes to allocate for driver
>   *
>   * Note:
> - * 	We call this when we come across a new host adapter. We only do
> - * 	this once we are 100% sure that we want to use this host adapter -
> - * 	it is a pain to reverse this, so we try to avoid it 
> + * 	Allocate a new Scsi_Host and perform basic initialization.
> + * 	The host is not published to the scsi midlayer until scsi_add_host
> + * 	is called.
>   *
>   * Return value:
>   * 	Pointer to a new Scsi_Host
>   **/
> -extern int blk_nohighio;
> -struct Scsi_Host * scsi_register(Scsi_Host_Template *shost_tp, int xtr_bytes)
> +struct Scsi_Host *scsi_host_alloc(Scsi_Host_Template *sht, int privsize)
>  {
> -	struct Scsi_Host *shost, *shost_scr;
> -	int gfp_mask, rval;
> -	DECLARE_COMPLETION(sem);
> +	extern int blk_nohighio;
> +	struct Scsi_Host *shost;
> +	int gfp_mask = GFP_KERNEL, rval;
> +	DECLARE_COMPLETION(complete);
> +
> +	if (sht->unchecked_isa_dma && privsize)
> +		gfp_mask |= __GFP_DMA;
>  
>          /* Check to see if this host has any error handling facilities */
> -        if(shost_tp->eh_strategy_handler == NULL &&
> -           shost_tp->eh_abort_handler == NULL &&
> -           shost_tp->eh_device_reset_handler == NULL &&
> -           shost_tp->eh_bus_reset_handler == NULL &&
> -           shost_tp->eh_host_reset_handler == NULL) {
> -		printk(KERN_ERR "ERROR: SCSI host `%s' has no error handling\nERROR: This is not a safe way to run your SCSI host\nERROR: The error handling must be added to this driver\n", shost_tp->proc_name);
> +        if (!sht->eh_strategy_handler && !sht->eh_abort_handler &&
> +	    !sht->eh_device_reset_handler && !sht->eh_bus_reset_handler &&
> +            !sht->eh_host_reset_handler) {
> +		printk(KERN_ERR "ERROR: SCSI host `%s' has no error handling\n"
> +				"ERROR: This is not a safe way to run your "
> +				        "SCSI host\n"
> +				"ERROR: The error handling must be added to "
> +				"this driver\n", sht->proc_name);
>  		dump_stack();
>          }
> -	if(shost_tp->shost_attrs == NULL)
> -		/* if its not set in the template, use the default */
> -		 shost_tp->shost_attrs = scsi_sysfs_shost_attrs;
> -	if(shost_tp->sdev_attrs == NULL)
> -		 shost_tp->sdev_attrs = scsi_sysfs_sdev_attrs;
> -	gfp_mask = GFP_KERNEL;
> -	if (shost_tp->unchecked_isa_dma && xtr_bytes)
> -		gfp_mask |= __GFP_DMA;
>  
> -	shost = kmalloc(sizeof(struct Scsi_Host) + xtr_bytes, gfp_mask);
> -	if (!shost) {
> -		printk(KERN_ERR "%s: out of memory.\n", __FUNCTION__);
> -		return NULL;
> -	}
> +	/* if its not set in the template, use the default */
> +	if (!sht->shost_attrs)
> +		 sht->shost_attrs = scsi_sysfs_shost_attrs;
> +	if (!sht->sdev_attrs)
> +		 sht->sdev_attrs = scsi_sysfs_sdev_attrs;
>  
> -	memset(shost, 0, sizeof(struct Scsi_Host) + xtr_bytes);
> -
> -	shost->host_no = scsi_host_next_hn++; /* XXX(hch): still racy */
> +	shost = kmalloc(sizeof(struct Scsi_Host) + privsize, gfp_mask);
> +	if (!shost)
> +		return NULL;
> +	memset(shost, 0, sizeof(struct Scsi_Host) + privsize);
>  
>  	spin_lock_init(&shost->default_lock);
>  	scsi_assign_lock(shost, &shost->default_lock);
>  	INIT_LIST_HEAD(&shost->my_devices);
>  	INIT_LIST_HEAD(&shost->eh_cmd_q);
>  	INIT_LIST_HEAD(&shost->starved_list);
> -
>  	init_waitqueue_head(&shost->host_wait);
> +
> +	shost->host_no = scsi_host_next_hn++; /* XXX(hch): still racy */
>  	shost->dma_channel = 0xff;
>  
>  	/* These three are default values which can be overridden */
> @@ -240,53 +230,33 @@
>  	 * they actually do something sensible with such commands.
>  	 */
>  	shost->max_cmd_len = 12;
> -	shost->hostt = shost_tp;
> -	shost->host_blocked = 0;
> -	shost->host_self_blocked = FALSE;
> -	shost->max_host_blocked = shost_tp->max_host_blocked ? shost_tp->max_host_blocked : SCSI_DEFAULT_HOST_BLOCKED;
> -
> -#ifdef DEBUG
> -	printk("%s: %x %x: %d\n", __FUNCTION_ (int)shost,
> -	       (int)shost->hostt, xtr_bytes);
> -#endif
> +	shost->hostt = sht;
> +	shost->this_id = sht->this_id;
> +	shost->can_queue = sht->can_queue;
> +	shost->sg_tablesize = sht->sg_tablesize;
> +	shost->cmd_per_lun = sht->cmd_per_lun;
> +	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
> +	shost->use_clustering = sht->use_clustering;
> +	shost->use_blk_tcq = sht->use_blk_tcq;
> +	if (!blk_nohighio)
> +		shost->highmem_io = sht->highmem_io;
> +
> +	if (!sht->max_host_blocked)
> +		shost->max_host_blocked = sht->max_host_blocked;
> +	else
> +		shost->max_host_blocked = SCSI_DEFAULT_HOST_BLOCKED;
>  
>  	/*
> -	 * The next six are the default values which can be overridden if
> -	 * need be
> +	 * If the driver imposes no hard sector transfer limit, start at
> +	 * machine infinity initially.
>  	 */
> -	shost->this_id = shost_tp->this_id;
> -	shost->can_queue = shost_tp->can_queue;
> -	shost->sg_tablesize = shost_tp->sg_tablesize;
> -	shost->cmd_per_lun = shost_tp->cmd_per_lun;
> -	shost->unchecked_isa_dma = shost_tp->unchecked_isa_dma;
> -	shost->use_clustering = shost_tp->use_clustering;
> -	if (!blk_nohighio)
> -		shost->highmem_io = shost_tp->highmem_io;
> -	if (!shost_tp->max_sectors) {
> -		/*
> -		 * Driver imposes no hard sector transfer limit.
> -		 * start at machine infinity initially.
> -		 */
> +	if (sht->max_sectors)
> +		shost->max_sectors = sht->max_sectors;
> +	else
>  		shost->max_sectors = SCSI_DEFAULT_MAX_SECTORS;
> -	} else
> -		shost->max_sectors = shost_tp->max_sectors;
> -	shost->use_blk_tcq = shost_tp->use_blk_tcq;
>  
>  	spin_lock(&scsi_host_list_lock);
> -	/*
> -	 * FIXME When device naming is complete remove this step that
> -	 * orders the scsi_host_list by host number and just do a
> -	 * list_add_tail.
> -	 */
> -	list_for_each_entry(shost_scr, &scsi_host_list, sh_list) {
> -		if (shost->host_no < shost_scr->host_no) {
> -			__list_add(&shost->sh_list, shost_scr->sh_list.prev,
> -				   &shost_scr->sh_list);
> -			goto found;
> -		}
> -	}
>  	list_add_tail(&shost->sh_list, &scsi_host_list);
> -found:
>  	spin_unlock(&scsi_host_list_lock);
>  
>  	rval = scsi_setup_command_freelist(shost);
> @@ -295,23 +265,29 @@
>  
>  	scsi_sysfs_init_host(shost);
>  
> -	shost->eh_notify = &sem;
> -	kernel_thread((int (*)(void *)) scsi_error_handler, (void *) shost, 0);
> -	/*
> -	 * Now wait for the kernel error thread to initialize itself
> -	 * as it might be needed when we scan the bus.
> -	 */
> -	wait_for_completion(&sem);
> +	shost->eh_notify = &complete;
> +	/* XXX(hch): handle error return */
> +	kernel_thread((int (*)(void *))scsi_error_handler, shost, 0);
> +	wait_for_completion(&complete);
>  	shost->eh_notify = NULL;
>  	shost->hostt->present++;
>  	return shost;
> -
> -fail:
> + fail:
>  	spin_lock(&scsi_host_list_lock);
>  	list_del(&shost->sh_list);
>  	spin_unlock(&scsi_host_list_lock);
>  	kfree(shost);
>  	return NULL;
> +}
> +
> +struct Scsi_Host *scsi_register(Scsi_Host_Template *sht, int privsize)
> +{
> +	return scsi_host_alloc(sht, privsize);
> +}
> +
> +void scsi_unregister(struct Scsi_Host *shost)
> +{
> +	scsi_host_put(shost);
>  }
>  
>  /**
> diff -Nru a/drivers/scsi/hosts.h b/drivers/scsi/hosts.h
> --- a/drivers/scsi/hosts.h	Tue Jun  3 00:42:21 2003
> +++ b/drivers/scsi/hosts.h	Tue Jun  3 00:42:21 2003
> @@ -560,23 +560,20 @@
>  #define scsi_unregister_interface(intf) \
>  	class_interface_unregister(intf)
>  
> -/*
> - * HBA allocation/freeing.
> - */
> -extern struct Scsi_Host * scsi_register(Scsi_Host_Template *, int);
> -extern void scsi_unregister(struct Scsi_Host *);
>  
> -/*
> - * HBA registration/unregistration.
> - */
> +extern struct Scsi_Host *scsi_host_alloc(Scsi_Host_Template *, int);
>  extern int scsi_add_host(struct Scsi_Host *, struct device *);
>  extern int scsi_remove_host(struct Scsi_Host *);
> +extern void scsi_host_get(struct Scsi_Host *);
> +extern void scsi_host_put(struct Scsi_Host *t);
> +extern struct Scsi_Host *scsi_host_lookup(unsigned short);
>  
> -/*
> - * Legacy HBA template registration/unregistration.
> - */
> +/* legacy interfaces */
>  extern int scsi_register_host(Scsi_Host_Template *);
>  extern int scsi_unregister_host(Scsi_Host_Template *);
> +extern struct Scsi_Host *scsi_register(Scsi_Host_Template *, int);
> +extern void scsi_unregister(struct Scsi_Host *);
> +
>  
>  /**
>   * scsi_find_device - find a device given the host
> diff -Nru a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
> --- a/drivers/scsi/ide-scsi.c	Tue Jun  3 00:42:21 2003
> +++ b/drivers/scsi/ide-scsi.c	Tue Jun  3 00:42:21 2003
> @@ -612,7 +612,7 @@
>  	drive->disk->fops = ide_fops;
>  
>  	scsi_remove_host(scsihost);
> -	scsi_unregister(scsihost);
> +	scsi_host_put(scsihost);
>  	return 0;
>  }
>  
> @@ -964,7 +964,7 @@
>  	if (!strstr("ide-scsi", drive->driver_req) ||
>  	    !drive->present ||
>  	    drive->media == ide_disk ||
> -	    !(host = scsi_register(&idescsi_template,sizeof(idescsi_scsi_t))))
> +	    !(host = scsi_host_alloc(&idescsi_template,sizeof(idescsi_scsi_t))))
>  		return 1;
>  
>  	host->max_id = 1;
> @@ -984,7 +984,7 @@
>  		ide_unregister_subdriver(drive);
>  	}
>  
> -	scsi_unregister(host);
> +	scsi_host_put(host);
>  	return err;
>  }
>  
> diff -Nru a/drivers/scsi/lasi700.c b/drivers/scsi/lasi700.c
> --- a/drivers/scsi/lasi700.c	Tue Jun  3 00:42:21 2003
> +++ b/drivers/scsi/lasi700.c	Tue Jun  3 00:42:21 2003
> @@ -186,7 +186,7 @@
>  	if(request_irq(dev->irq, NCR_700_intr, SA_SHIRQ, driver_name, host)) {
>  		printk(KERN_ERR "%s: irq problem, detaching\n",
>  		       driver_name);
> -		scsi_unregister(host);
> +		scsi_host_put(host);
>  		NCR_700_release(host);
>  		return 1;
>  	}
> diff -Nru a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
> --- a/drivers/scsi/nsp32.c	Tue Jun  3 00:42:21 2003
> +++ b/drivers/scsi/nsp32.c	Tue Jun  3 00:42:21 2003
> @@ -1621,7 +1621,7 @@
>  	/*
>  	 * register this HBA as SCSI device
>  	 */
> -	host = scsi_register(&nsp32_template, sizeof(nsp32_hw_data));
> +	host = scsi_host_alloc(&nsp32_template, sizeof(nsp32_hw_data));
>  	if (host == NULL) {
>  		nsp32_msg (KERN_ERR, "failed to scsi register");
>  		goto err;
> @@ -1840,7 +1840,7 @@
>  	kfree(data->lunt_list);
>  
>   scsi_unregister:
> -	scsi_unregister(host);
> +	scsi_host_put(host);
>  
>   err:
>  	return 1;
> diff -Nru a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
> --- a/drivers/scsi/pcmcia/nsp_cs.c	Tue Jun  3 00:42:21 2003
> +++ b/drivers/scsi/pcmcia/nsp_cs.c	Tue Jun  3 00:42:21 2003
> @@ -1222,7 +1222,7 @@
>  	DEBUG(0, "%s: this_id=%d\n", __FUNCTION__, sht->this_id);
>  
>  	request_region(data->BaseAddress, data->NumAddress, "nsp_cs");
> -	host		  = scsi_register(sht, 0);
> +	host		  = scsi_host_alloc(sht, 0);
>  	if(host == NULL)
>  		return NULL;
>  
> diff -Nru a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> --- a/drivers/scsi/scsi_debug.c	Tue Jun  3 00:42:21 2003
> +++ b/drivers/scsi/scsi_debug.c	Tue Jun  3 00:42:21 2003
> @@ -1681,7 +1681,7 @@
>  
>  	sdbg_host = to_sdebug_host(dev);
>  
> -        hpnt = scsi_register(&sdebug_driver_template, sizeof(sdbg_host));
> +        hpnt = scsi_host_alloc(&sdebug_driver_template, sizeof(sdbg_host));
>          if (NULL == hpnt) {
>                  printk(KERN_ERR "%s: scsi_register failed\n", __FUNCTION__);
>                  error = -ENODEV;
> @@ -1700,7 +1700,7 @@
>          if (error) {
>                  printk(KERN_ERR "%s: scsi_add_host failed\n", __FUNCTION__);
>                  error = -ENODEV;
> -		scsi_unregister(hpnt);
> +		scsi_host_put(hpnt);
>          }
>  
>  
> @@ -1726,8 +1726,6 @@
>                  return -EBUSY;
>          }
>  
> -        scsi_unregister(sdbg_host->shost);
> -
>          list_for_each_safe(lh, lh_sf, &sdbg_host->dev_info_list) {
>                  sdbg_devinfo = list_entry(lh, struct sdebug_dev_info,
>                                            dev_list);
> @@ -1735,5 +1733,6 @@
>                  kfree(sdbg_devinfo);
>          }
>  
> +        scsi_host_put(sdbg_host->shost);
>          return 0;
>  }
> diff -Nru a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> --- a/drivers/scsi/scsi_priv.h	Tue Jun  3 00:42:21 2003
> +++ b/drivers/scsi/scsi_priv.h	Tue Jun  3 00:42:21 2003
> @@ -55,9 +55,6 @@
>  /* hosts.c */
>  extern void scsi_host_busy_inc(struct Scsi_Host *, Scsi_Device *);
>  extern void scsi_host_busy_dec_and_test(struct Scsi_Host *, Scsi_Device *);
> -extern struct Scsi_Host *scsi_host_lookup(unsigned short);
> -extern void scsi_host_put(struct Scsi_Host *);
> -extern void scsi_host_init(void);
>  
>  /* scsi.c */
>  extern int scsi_dispatch_cmd(struct scsi_cmnd *cmd);
> @@ -107,12 +104,11 @@
>  #endif /* CONFIG_PROC_FS */
>  
>  /* scsi_scan.c */
> -extern void scsi_scan_host(struct Scsi_Host *shost);
> -extern void scsi_forget_host(struct Scsi_Host *shost);
> +extern void scsi_scan_host(struct Scsi_Host *);
> +extern void scsi_forget_host(struct Scsi_Host *);
>  extern void scsi_free_sdev(struct scsi_device *);
>  extern void scsi_free_shost(struct Scsi_Host *);
> -extern void scsi_host_get(struct Scsi_Host *);
> -extern void scsi_rescan_device(struct device *dev);
> +extern void scsi_rescan_device(struct device *);
>  
>  /* scsi_sysfs.c */
>  extern int scsi_device_register(struct scsi_device *);
> diff -Nru a/drivers/scsi/scsi_syms.c b/drivers/scsi/scsi_syms.c
> --- a/drivers/scsi/scsi_syms.c	Tue Jun  3 00:42:21 2003
> +++ b/drivers/scsi/scsi_syms.c	Tue Jun  3 00:42:21 2003
> @@ -33,8 +33,12 @@
>  EXPORT_SYMBOL(scsi_register_interface);
>  EXPORT_SYMBOL(scsi_register_host);
>  EXPORT_SYMBOL(scsi_unregister_host);
> +EXPORT_SYMBOL(scsi_host_alloc);
>  EXPORT_SYMBOL(scsi_add_host);
>  EXPORT_SYMBOL(scsi_remove_host);
> +EXPORT_SYMBOL(scsi_host_get);
> +EXPORT_SYMBOL(scsi_host_put);
> +EXPORT_SYMBOL(scsi_host_lookup);
>  EXPORT_SYMBOL(scsi_register);
>  EXPORT_SYMBOL(scsi_unregister);
>  EXPORT_SYMBOL(scsicam_bios_param);
> diff -Nru a/drivers/scsi/sim710.c b/drivers/scsi/sim710.c
> --- a/drivers/scsi/sim710.c	Tue Jun  3 00:42:21 2003
> +++ b/drivers/scsi/sim710.c	Tue Jun  3 00:42:21 2003
> @@ -143,7 +143,7 @@
>  	return 0;
>  
>   out_unregister:
> -	scsi_unregister(host);
> +	scsi_host_put(host);
>   out_release:
>  	release_region(host->base, 64);
>   out_free:
> diff -Nru a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
> --- a/drivers/usb/storage/usb.c	Tue Jun  3 00:42:21 2003
> +++ b/drivers/usb/storage/usb.c	Tue Jun  3 00:42:21 2003
> @@ -868,7 +868,7 @@
>  	up(&(us->dev_semaphore));
>  
>  	/* now register	*/
> -	us->host = scsi_register(&usb_stor_host_template, sizeof(us));
> +	us->host = scsi_host_alloc(&usb_stor_host_template, sizeof(us));
>  	if (!us->host) {
>  		printk(KERN_WARNING USB_STORAGE
>  			"Unable to register the scsi host\n");
> @@ -965,7 +965,7 @@
>  	};
>  
>  	/* finish SCSI host removal sequence */
> -	scsi_unregister(us->host);
> +	scsi_host_put(us->host);
>  
>  	/* Kill the control threads
>  	 *
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


