From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] 2.5.x add back missing scsi_queue_next_request calls
Date: Thu, 20 Mar 2003 16:24:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E7A317A.702@splentec.com>
References: <20030319184444.A9694@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> The change to use a pool for scsi_cmnd allocations removed some
> scsi_queue_next_request calls, this patch restores the calls, and
> exports scsi_put_command and scsi_get_command.

And there was a point to this removal.  I did mention it on linux-scsi.

Look, don't try to make the code look as it did *before* -- there's
always a point to a change -- I think I mentioned exactly this
before on linux-scsi...

So *ALL* this patch does is REMOVE ONE CALL TO
scsi_queue_next_request(q, NULL).

And in order to accomodate this removal, you contaminate the slab
allocation implementation by introducing ONE MORE needless
__scsi_put_command(), then rename from scsi_put_command() to
__scsi_put_command() and contaminate scsi_put_command()... I think not!

> The extra scsi_queue_next_request calls are needed to handle non-block
> device IO completion (char devices and scsi scanning).

Ok, but this ``handling'' should be accommodated for *elsewhere* in
SCSI Core or in the _respective_ ULDD!  This is important for
modularizaion.

scsi_get_command(), __scsi_get_command() and scsi_put_command()
have EXACTLY defined behaviour.  They are memory management for
scsi command structs -- they have *NOTHING* to do with running/
unplugging of block/request queues and/or getting more requests!

Please, respect the implementation (modularization)!

Moreover, *THAT* was the whole point of the slab allocation patch for
scsi structs -- to modularize the allocation/deallocation.

And by introducing this patch here, we get a spaghetti dish, literally.
Please do not contaminate the command struct slab allocation.

And do not forget that LLDD and ULDD are free to call scsi_get/put_command()
at will.

Here is what you do: centralize the calls to scsi_get/put_command()
*in* SCSI Core and *after* the call to scsi_put_command(), you can do
a few tests to see if you can *indeed*(1) enqueue the next request.
But the slab implementaion should not be contaminated.

(1) You may not be able to... hot plugging, queueing limits, etc...

And please do not introduce __scsi_put_command() to do the dirty
work which should be handled elsewhere.

It was alright to call scsi_queue_next_request(q, NULL) from
scsi_end_request() -- at least logically!!!  But what does
scsi_put_command() have to do with scsi_queue_next_request()???

> This patch applies cleanly on top of the previous "starved" patch, but
> should apply with offsets to the current 2.5.x tree.
> 
> diff -purN -X /home/patman/dontdiff starve-25/drivers/scsi/scsi.c put_cmd-25/drivers/scsi/scsi.c
> --- starve-25/drivers/scsi/scsi.c	Wed Mar 19 18:08:46 2003
> +++ put_cmd-25/drivers/scsi/scsi.c	Wed Mar 19 18:30:47 2003
> @@ -307,7 +307,7 @@ struct scsi_cmnd *scsi_get_command(struc
>  }				
>  
>  /*
> - * Function:	scsi_put_command()
> + * Function:	__scsi_put_command()
>   *
>   * Purpose:	Free a scsi command block
>   *
> @@ -317,7 +317,7 @@ struct scsi_cmnd *scsi_get_command(struc
>   *
>   * Notes:	The command must not belong to any lists.
>   */
> -void scsi_put_command(struct scsi_cmnd *cmd)
> +void __scsi_put_command(struct scsi_cmnd *cmd)
>  {
>  	struct Scsi_Host *shost = cmd->device->host;
>  	unsigned long flags;
> @@ -340,6 +340,23 @@ void scsi_put_command(struct scsi_cmnd *
>  }
>  
>  /*
> + * Function:	scsi_put_command()
> + *
> + * Purpose:	Free a scsi command block and call scsi_q
> + *
> + * Arguments:	cmd	- command block to free
> + *
> + * Returns:	Nothing.
> + */
> +void scsi_put_command(struct scsi_cmnd *cmd)
> +{
> +	struct request_queue *q = cmd->device->request_queue;
> +
> +	__scsi_put_command(cmd);
> +	scsi_queue_next_request(q, NULL);
> +}
> +
> +/*
>   * Function:	scsi_setup_command_freelist()
>   *
>   * Purpose:	Setup the command freelist for a scsi host.
> diff -purN -X /home/patman/dontdiff starve-25/drivers/scsi/scsi.h put_cmd-25/drivers/scsi/scsi.h
> --- starve-25/drivers/scsi/scsi.h	Wed Mar 19 16:36:40 2003
> +++ put_cmd-25/drivers/scsi/scsi.h	Wed Mar 19 18:10:54 2003
> @@ -416,6 +416,7 @@ extern int scsi_maybe_unblock_host(Scsi_
>  extern void scsi_setup_cmd_retry(Scsi_Cmnd *SCpnt);
>  extern void scsi_io_completion(Scsi_Cmnd * SCpnt, int good_sectors,
>  			       int block_sectors);
> +extern void scsi_queue_next_request(request_queue_t *q, Scsi_Cmnd *cmd);
>  extern int scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
>  extern request_queue_t *scsi_alloc_queue(struct Scsi_Host *shost);
>  extern void scsi_free_queue(request_queue_t *q);
> @@ -429,6 +430,7 @@ extern int scsi_dispatch_cmd(Scsi_Cmnd *
>  extern int scsi_setup_command_freelist(struct Scsi_Host *shost);
>  extern void scsi_destroy_command_freelist(struct Scsi_Host *shost);
>  extern struct scsi_cmnd *scsi_get_command(struct scsi_device *dev, int flags);
> +extern void __scsi_put_command(struct scsi_cmnd *cmd);
>  extern void scsi_put_command(struct scsi_cmnd *cmd);
>  extern void scsi_adjust_queue_depth(Scsi_Device *, int, int);
>  extern int scsi_track_queue_full(Scsi_Device *, int);
> diff -purN -X /home/patman/dontdiff starve-25/drivers/scsi/scsi_lib.c put_cmd-25/drivers/scsi/scsi_lib.c
> --- starve-25/drivers/scsi/scsi_lib.c	Wed Mar 19 16:36:40 2003
> +++ put_cmd-25/drivers/scsi/scsi_lib.c	Wed Mar 19 18:10:54 2003
> @@ -351,7 +351,7 @@ void scsi_setup_cmd_retry(struct scsi_cm
>   *		permutations grows as 2**N, and if too many more special cases
>   *		get added, we start to get screwed.
>   */
> -static void scsi_queue_next_request(request_queue_t *q, struct scsi_cmnd *cmd)
> +void scsi_queue_next_request(request_queue_t *q, struct scsi_cmnd *cmd)
>  {
>  	struct scsi_device *sdev, *sdev2;
>  	struct Scsi_Host *shost;
> @@ -487,7 +487,6 @@ static struct scsi_cmnd *scsi_end_reques
>  	 * need to worry about launching another command.
>  	 */
>  	scsi_put_command(cmd);
> -	scsi_queue_next_request(q, NULL);
>  	return NULL;
>  }
>  
> @@ -906,7 +905,7 @@ static int scsi_init_io(struct scsi_cmnd
>  			req->current_nr_sectors);
>  
>  	/* release the command and kill it */
> -	scsi_put_command(cmd);
> +	__scsi_put_command(cmd);
>  	return BLKPREP_KILL;
>  }
>  
> @@ -1014,7 +1013,7 @@ static int scsi_prep_fn(struct request_q
>  		 */
>  		if (unlikely(!sdt->init_command(cmd))) {
>  			scsi_release_buffers(cmd);
> -			scsi_put_command(cmd);
> +			__scsi_put_command(cmd);
>  			return BLKPREP_KILL;
>  		}
>  	}
> diff -purN -X /home/patman/dontdiff starve-25/drivers/scsi/scsi_syms.c put_cmd-25/drivers/scsi/scsi_syms.c
> --- starve-25/drivers/scsi/scsi_syms.c	Wed Mar 19 11:52:25 2003
> +++ put_cmd-25/drivers/scsi/scsi_syms.c	Wed Mar 19 18:10:54 2003
> @@ -60,6 +60,8 @@ EXPORT_SYMBOL(scsi_allocate_request);
>  EXPORT_SYMBOL(scsi_release_request);
>  EXPORT_SYMBOL(scsi_wait_req);
>  EXPORT_SYMBOL(scsi_do_req);
> +EXPORT_SYMBOL(scsi_get_command);
> +EXPORT_SYMBOL(scsi_put_command);
>  
>  EXPORT_SYMBOL(scsi_report_bus_reset);
>  EXPORT_SYMBOL(scsi_block_requests);
> 
> -- Patrick Mansfield
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Luben



