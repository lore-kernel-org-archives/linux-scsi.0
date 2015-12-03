From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 01/10] aacraid: SCSI blk tag support
Date: Thu, 3 Dec 2015 16:52:13 +0100
Message-ID: <5660652D.8080501@redhat.com>
References: <1448973589-9216-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <1448973589-9216-2-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760625AbbLCPwS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Dec 2015 10:52:18 -0500
In-Reply-To: <1448973589-9216-2-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Santosh.Akula@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Rich.Bono@pmcs.com

On 1.12.2015 13:39, Raghava Aditya Renukunta wrote:
> From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
>
> The method to allocate and free FIB's in the present code utilizes
> spinlocks.Multiple IO's have to wait on the spinlock to acquire or
> free fibs creating a performance bottleneck.
>
> An alternative solution would be to use block layer tags to keep track
> of the fibs allocated and freed. To this end 2 functions
> aac_fib_alloc_tag and aac_fib_free_tag were created which utilize the
> blk layer tags to plug into the Fib pool.These functions are used
> exclusively in the IO path. 8 fibs are reserved for the use of AIF
> management software and utilize the previous spinlock based
> implementations.
>
> Signed-off-by: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
> ---
>  drivers/scsi/aacraid/aachba.c  | 35 +++++++++++++++++-------------
>  drivers/scsi/aacraid/aacraid.h |  2 ++
>  drivers/scsi/aacraid/commsup.c | 49 +++++++++++++++++++++++++++++++++++++++---
>  drivers/scsi/aacraid/dpcsup.c  |  4 ++--
>  drivers/scsi/aacraid/linit.c   |  2 ++
>  5 files changed, 72 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
> index e4c2437..06cbab8 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -323,7 +323,7 @@ static inline int aac_valid_context(struct scsi_cmnd *scsicmd,
>  	if (unlikely(!scsicmd || !scsicmd->scsi_done)) {
>  		dprintk((KERN_WARNING "aac_valid_context: scsi command corrupt\n"));
>  		aac_fib_complete(fibptr);
> -		aac_fib_free(fibptr);
> +		aac_fib_free_tag(fibptr);
>  		return 0;
>  	}
>  	scsicmd->SCp.phase = AAC_OWNER_MIDLEVEL;
> @@ -331,7 +331,7 @@ static inline int aac_valid_context(struct scsi_cmnd *scsicmd,
>  	if (unlikely(!device || !scsi_device_online(device))) {
>  		dprintk((KERN_WARNING "aac_valid_context: scsi device corrupt\n"));
>  		aac_fib_complete(fibptr);
> -		aac_fib_free(fibptr);
> +		aac_fib_free_tag(fibptr);
>  		return 0;
>  	}
>  	return 1;
> @@ -541,7 +541,7 @@ static void get_container_name_callback(void *context, struct fib * fibptr)
>  	scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
>  
>  	aac_fib_complete(fibptr);
> -	aac_fib_free(fibptr);
> +	aac_fib_free_tag(fibptr);
>  	scsicmd->scsi_done(scsicmd);
>  }
>  
> @@ -557,7 +557,8 @@ static int aac_get_container_name(struct scsi_cmnd * scsicmd)
>  
>  	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
>  
> -	if (!(cmd_fibcontext = aac_fib_alloc(dev)))
> +	cmd_fibcontext = aac_fib_alloc_tag(dev, scsicmd);
> +	if (!cmd_fibcontext)
>  		return -ENOMEM;
>  
>  	aac_fib_init(cmd_fibcontext);
> @@ -586,7 +587,7 @@ static int aac_get_container_name(struct scsi_cmnd * scsicmd)
>  
>  	printk(KERN_WARNING "aac_get_container_name: aac_fib_send failed with status: %d.\n", status);
>  	aac_fib_complete(cmd_fibcontext);
> -	aac_fib_free(cmd_fibcontext);
> +	aac_fib_free_tag(cmd_fibcontext);
>  	return -1;
>  }
>  
> @@ -1024,7 +1025,7 @@ static void get_container_serial_callback(void *context, struct fib * fibptr)
>  	scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
>  
>  	aac_fib_complete(fibptr);
> -	aac_fib_free(fibptr);
> +	aac_fib_free_tag(fibptr);
>  	scsicmd->scsi_done(scsicmd);
>  }
>  
> @@ -1040,7 +1041,8 @@ static int aac_get_container_serial(struct scsi_cmnd * scsicmd)
>  
>  	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
>  
> -	if (!(cmd_fibcontext = aac_fib_alloc(dev)))
> +	cmd_fibcontext = aac_fib_alloc_tag(dev, scsicmd);
> +	if (!cmd_fibcontext)
>  		return -ENOMEM;
>  
>  	aac_fib_init(cmd_fibcontext);
> @@ -1068,7 +1070,7 @@ static int aac_get_container_serial(struct scsi_cmnd * scsicmd)
>  
>  	printk(KERN_WARNING "aac_get_container_serial: aac_fib_send failed with status: %d.\n", status);
>  	aac_fib_complete(cmd_fibcontext);
> -	aac_fib_free(cmd_fibcontext);
> +	aac_fib_free_tag(cmd_fibcontext);
>  	return -1;
>  }
>  
> @@ -1869,7 +1871,7 @@ static void io_callback(void *context, struct fib * fibptr)
>  		break;
>  	}
>  	aac_fib_complete(fibptr);
> -	aac_fib_free(fibptr);
> +	aac_fib_free_tag(fibptr);
>  
>  	scsicmd->scsi_done(scsicmd);
>  }
> @@ -1954,7 +1956,8 @@ static int aac_read(struct scsi_cmnd * scsicmd)
>  	/*
>  	 *	Alocate and initialize a Fib
>  	 */
> -	if (!(cmd_fibcontext = aac_fib_alloc(dev))) {
> +	cmd_fibcontext = aac_fib_alloc_tag(dev, scsicmd);
> +	if (!cmd_fibcontext) {
>  		printk(KERN_WARNING "aac_read: fib allocation failed\n");
>  		return -1;
>  	}
> @@ -2051,7 +2054,8 @@ static int aac_write(struct scsi_cmnd * scsicmd)
>  	/*
>  	 *	Allocate and initialize a Fib then setup a BlockWrite command
>  	 */
> -	if (!(cmd_fibcontext = aac_fib_alloc(dev))) {
> +	cmd_fibcontext = aac_fib_alloc_tag(dev, scsicmd);
> +	if (!cmd_fibcontext) {
>  		/* FIB temporarily unavailable,not catastrophic failure */
>  
>  		/* scsicmd->result = DID_ERROR << 16;
> @@ -2285,7 +2289,7 @@ static int aac_start_stop(struct scsi_cmnd *scsicmd)
>  	/*
>  	 *	Allocate and initialize a Fib
>  	 */
> -	cmd_fibcontext = aac_fib_alloc(aac);
> +	cmd_fibcontext = aac_fib_alloc_tag(aac, scsicmd);
>  	if (!cmd_fibcontext)
>  		return SCSI_MLQUEUE_HOST_BUSY;
>  
> @@ -3157,7 +3161,7 @@ static void aac_srb_callback(void *context, struct fib * fibptr)
>  	scsicmd->result |= le32_to_cpu(srbreply->scsi_status);
>  
>  	aac_fib_complete(fibptr);
> -	aac_fib_free(fibptr);
> +	aac_fib_free_tag(fibptr);
>  	scsicmd->scsi_done(scsicmd);
>  }
>  
> @@ -3187,9 +3191,10 @@ static int aac_send_srb_fib(struct scsi_cmnd* scsicmd)
>  	/*
>  	 *	Allocate and initialize a Fib then setup a BlockWrite command
>  	 */
> -	if (!(cmd_fibcontext = aac_fib_alloc(dev))) {
> +	cmd_fibcontext = aac_fib_alloc_tag(dev, scsicmd);
> +	if (!cmd_fibcontext)
>  		return -1;
> -	}
> +
>  	status = aac_adapter_scsi(cmd_fibcontext, scsicmd);
>  
>  	/*
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
> index 074878b..da227e8 100644
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -2114,9 +2114,11 @@ int aac_acquire_irq(struct aac_dev *dev);
>  void aac_free_irq(struct aac_dev *dev);
>  const char *aac_driverinfo(struct Scsi_Host *);
>  struct fib *aac_fib_alloc(struct aac_dev *dev);
> +struct fib *aac_fib_alloc_tag(struct aac_dev *dev, struct scsi_cmnd *scmd);
>  int aac_fib_setup(struct aac_dev *dev);
>  void aac_fib_map_free(struct aac_dev *dev);
>  void aac_fib_free(struct fib * context);
> +void aac_fib_free_tag(struct fib *context);
>  void aac_fib_init(struct fib * context);
>  void aac_printf(struct aac_dev *dev, u32 val);
>  int aac_fib_send(u16 command, struct fib * context, unsigned long size, int priority, int wait, int reply, fib_callback callback, void *ctxt);
> diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
> index a1f90fe..b5b653c 100644
> --- a/drivers/scsi/aacraid/commsup.c
> +++ b/drivers/scsi/aacraid/commsup.c
> @@ -156,9 +156,9 @@ int aac_fib_setup(struct aac_dev * dev)
>  	 */
>  	dev->fibs[dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB - 1].next = NULL;
>  	/*
> -	 *	Enable this to debug out of queue space
> -	 */
> -	dev->free_fib = &dev->fibs[0];
> +	*	Set 8 fibs aside for management tools
> +	*/
> +	dev->free_fib = &dev->fibs[dev->scsi_host_ptr->can_queue];
>  	return 0;
>  }
>  
> @@ -166,6 +166,49 @@ int aac_fib_setup(struct aac_dev * dev)
>   *	aac_fib_alloc	-	allocate a fib
>   *	@dev: Adapter to allocate the fib for
>   *
> + *	Allocate a fib from the adapter fib pool using tags
> + *	from the blk layer.
> + */
> +
> +struct fib *aac_fib_alloc_tag(struct aac_dev *dev, struct scsi_cmnd *scmd)
> +{
> +	struct fib *fibptr;
> +
> +	fibptr = &dev->fibs[scmd->request->tag];
> +	/*
> +	 *	Set the proper node type code and node byte size
> +	 */

Can't you just make most of the initialisation below just once when the driver starts?

> +	fibptr->type = FSAFS_NTC_FIB_CONTEXT;
> +	fibptr->size = sizeof(struct fib);
> +	/*
> +	 *	Null out fields that depend on being zero at the start of
> +	 *	each I/O
> +	 */
> +	fibptr->hw_fib_va->header.XferState = 0;
> +	fibptr->flags = 0;

For example the flags field is initialised  here to '0', then
in aac_fib_send again to zero and later is 'fibptr->flags = FIB_CONTEXT_FLAG;'
Removing part of it would help I think.
The code here is not new so, if I am right, please plan it for a next series. 

> +	fibptr->callback = NULL;
> +	fibptr->callback_data = NULL;
> +
> +	return fibptr;
> +}
> +
> +/**
> + *	aac_fib_free_tag	free a fib
> + *	@fibptr: fib to free up
> + *
> + *	Placeholder to free tag allocated fibs
> + *	Does not do anything
> + */
> +
> +void aac_fib_free_tag(struct fib *fibptr)
> +{
> +	(void)fibptr;
> +}

I agree with Johannes, I also don't like the aac_fib_free_tag as it is.
With the aac_fib_free_tag you may add -
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
 
Tomas

