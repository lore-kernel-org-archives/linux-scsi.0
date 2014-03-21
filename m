From: adam radford <aradford@gmail.com>
Subject: Re: [PATCH 13/39] megaraid: simplify internal command handling
Date: Thu, 20 Mar 2014 18:12:09 -0700
Message-ID: <CAHtARFHYWWgxrjHhYrET+FwzVr728-=+Kga8BiGPgD5HqWpAzQ@mail.gmail.com>
References: <20140317132733.789623766@bombadil.infradead.org>
	<20140317133133.393704189@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140317133133.393704189@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Mar 17, 2014 at 6:27 AM, Christoph Hellwig <hch@infradead.org> wrote:
> We don't use the passed in scsi command for anything, so just add a adapter-
> wide internal status to go along with the internal scb that is used unter
> int_mtx to pass back the return value and get rid of all the complexities
> and abuse of the scsi_cmnd structure.
>
> This gets rid of the only user of scsi_allocate_command/scsi_free_command,
> which can now be removed.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Cc: Sumit.Saxena@lsi.com
> Cc: kashyap.desai@lsi.com
> Cc: megaraidlinux@lsi.com
> ---
>  drivers/scsi/megaraid.c  |  120 ++++++++++++----------------------------------
>  drivers/scsi/megaraid.h  |    3 +-
>  drivers/scsi/scsi.c      |   56 ----------------------
>  include/scsi/scsi_cmnd.h |    3 --
>  4 files changed, 32 insertions(+), 150 deletions(-)
>
> diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
> index 816db12..8bca30f 100644
> --- a/drivers/scsi/megaraid.c
> +++ b/drivers/scsi/megaraid.c
> @@ -531,13 +531,6 @@ mega_build_cmd(adapter_t *adapter, Scsi_Cmnd *cmd, int *busy)
>         int     target = 0;
>         int     ldrv_num = 0;   /* logical drive number */
>
> -
> -       /*
> -        * filter the internal and ioctl commands
> -        */
> -       if((cmd->cmnd[0] == MEGA_INTERNAL_CMD))
> -               return (scb_t *)cmd->host_scribble;
> -
>         /*
>          * We know what channels our logical drives are on - mega_find_card()
>          */
> @@ -1439,19 +1432,22 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
>
>                 cmdid = completed[i];
>
> -               if( cmdid == CMDID_INT_CMDS ) { /* internal command */
> +               /*
> +                * Only free SCBs for the commands coming down from the
> +                * mid-layer, not for which were issued internally
> +                *
> +                * For internal command, restore the status returned by the
> +                * firmware so that user can interpret it.
> +                */
> +               if (cmdid == CMDID_INT_CMDS) {
>                         scb = &adapter->int_scb;
> -                       cmd = scb->cmd;
> -                       mbox = (mbox_t *)scb->raw_mbox;
>
> -                       /*
> -                        * Internal command interface do not fire the extended
> -                        * passthru or 64-bit passthru
> -                        */
> -                       pthru = scb->pthru;
> +                       list_del_init(&scb->list);
> +                       scb->state = SCB_FREE;
>
> -               }
> -               else {
> +                       adapter->int_status = status;
> +                       complete(&adapter->int_waitq);
> +               } else {
>                         scb = &adapter->scb_list[cmdid];
>
>                         /*
> @@ -1640,25 +1636,7 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
>                                 cmd->result |= (DID_BAD_TARGET << 16)|status;
>                 }
>
> -               /*
> -                * Only free SCBs for the commands coming down from the
> -                * mid-layer, not for which were issued internally
> -                *
> -                * For internal command, restore the status returned by the
> -                * firmware so that user can interpret it.
> -                */
> -               if( cmdid == CMDID_INT_CMDS ) { /* internal command */
> -                       cmd->result = status;
> -
> -                       /*
> -                        * Remove the internal command from the pending list
> -                        */
> -                       list_del_init(&scb->list);
> -                       scb->state = SCB_FREE;
> -               }
> -               else {
> -                       mega_free_scb(adapter, scb);
> -               }
> +               mega_free_scb(adapter, scb);
>
>                 /* Add Scsi_Command to end of completed queue */
>                 list_add_tail(SCSI_LIST(cmd), &adapter->completed_list);
> @@ -4133,23 +4111,15 @@ mega_internal_dev_inquiry(adapter_t *adapter, u8 ch, u8 tgt,
>   * The last argument is the address of the passthru structure if the command
>   * to be fired is a passthru command
>   *
> - * lockscope specifies whether the caller has already acquired the lock. Of
> - * course, the caller must know which lock we are talking about.
> - *
>   * Note: parameter 'pthru' is null for non-passthru commands.
>   */
>  static int
>  mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
>  {
> -       Scsi_Cmnd       *scmd;
> -       struct  scsi_device *sdev;
> +       unsigned long flags;
>         scb_t   *scb;
>         int     rval;
>
> -       scmd = scsi_allocate_command(GFP_KERNEL);
> -       if (!scmd)
> -               return -ENOMEM;
> -
>         /*
>          * The internal commands share one command id and hence are
>          * serialized. This is so because we want to reserve maximum number of
> @@ -4160,73 +4130,45 @@ mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
>         scb = &adapter->int_scb;
>         memset(scb, 0, sizeof(scb_t));
>
> -       sdev = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
> -       scmd->device = sdev;
> -
> -       memset(adapter->int_cdb, 0, sizeof(adapter->int_cdb));
> -       scmd->cmnd = adapter->int_cdb;
> -       scmd->device->host = adapter->host;
> -       scmd->host_scribble = (void *)scb;
> -       scmd->cmnd[0] = MEGA_INTERNAL_CMD;
> -
> -       scb->state |= SCB_ACTIVE;
> -       scb->cmd = scmd;
> +       scb->idx = CMDID_INT_CMDS;
> +       scb->state |= SCB_ACTIVE | SCB_PENDQ;
>
>         memcpy(scb->raw_mbox, mc, sizeof(megacmd_t));
>
>         /*
>          * Is it a passthru command
>          */
> -       if( mc->cmd == MEGA_MBOXCMD_PASSTHRU ) {
> -
> +       if (mc->cmd == MEGA_MBOXCMD_PASSTHRU)
>                 scb->pthru = pthru;
> -       }
> -
> -       scb->idx = CMDID_INT_CMDS;
>
> -       megaraid_queue_lck(scmd, mega_internal_done);
> +       spin_lock_irqsave(&adapter->lock, flags);
> +       list_add_tail(&scb->list, &adapter->pending_list);
> +       /*
> +        * Check if the HBA is in quiescent state, e.g., during a
> +        * delete logical drive opertion. If it is, don't run
> +        * the pending_list.
> +        */
> +       if (atomic_read(&adapter->quiescent) == 0)
> +               mega_runpendq(adapter);
> +       spin_unlock_irqrestore(&adapter->lock, flags);
>
>         wait_for_completion(&adapter->int_waitq);
>
> -       rval = scmd->result;
> -       mc->status = scmd->result;
> -       kfree(sdev);
> +       mc->status = rval = adapter->int_status;
>
>         /*
>          * Print a debug message for all failed commands. Applications can use
>          * this information.
>          */
> -       if( scmd->result && trace_level ) {
> +       if( rval && trace_level ) {
>                 printk("megaraid: cmd [%x, %x, %x] status:[%x]\n",
> -                       mc->cmd, mc->opcode, mc->subopcode, scmd->result);
> +                       mc->cmd, mc->opcode, mc->subopcode, rval);
>         }
>
>         mutex_unlock(&adapter->int_mtx);
> -
> -       scsi_free_command(GFP_KERNEL, scmd);
> -
>         return rval;
>  }
>
> -
> -/**
> - * mega_internal_done()
> - * @scmd - internal scsi command
> - *
> - * Callback routine for internal commands.
> - */
> -static void
> -mega_internal_done(Scsi_Cmnd *scmd)
> -{
> -       adapter_t       *adapter;
> -
> -       adapter = (adapter_t *)scmd->device->host->hostdata;
> -
> -       complete(&adapter->int_waitq);
> -
> -}
> -
> -
>  static struct scsi_host_template megaraid_template = {
>         .module                         = THIS_MODULE,
>         .name                           = "MegaRAID",
> diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
> index 4d0ce4e..8f2e026 100644
> --- a/drivers/scsi/megaraid.h
> +++ b/drivers/scsi/megaraid.h
> @@ -853,10 +853,10 @@ typedef struct {
>
>         u8      sglen;  /* f/w supported scatter-gather list length */
>
> -       unsigned char int_cdb[MAX_COMMAND_SIZE];
>         scb_t                   int_scb;
>         struct mutex            int_mtx;        /* To synchronize the internal
>                                                 commands */
> +       int                     int_status;     /* status of internal cmd */
>         struct completion       int_waitq;      /* wait queue for internal
>                                                  cmds */
>
> @@ -1004,7 +1004,6 @@ static int mega_del_logdrv(adapter_t *, int);
>  static int mega_do_del_logdrv(adapter_t *, int);
>  static void mega_get_max_sgl(adapter_t *);
>  static int mega_internal_command(adapter_t *, megacmd_t *, mega_passthru *);
> -static void mega_internal_done(Scsi_Cmnd *);
>  static int mega_support_cluster(adapter_t *);
>  #endif
>
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 2b12983..8b2bc06 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -403,62 +403,6 @@ static void scsi_put_host_cmd_pool(gfp_t gfp_mask)
>  }
>
>  /**
> - * scsi_allocate_command - get a fully allocated SCSI command
> - * @gfp_mask:  allocation mask
> - *
> - * This function is for use outside of the normal host based pools.
> - * It allocates the relevant command and takes an additional reference
> - * on the pool it used.  This function *must* be paired with
> - * scsi_free_command which also has the identical mask, otherwise the
> - * free pool counts will eventually go wrong and you'll trigger a bug.
> - *
> - * This function should *only* be used by drivers that need a static
> - * command allocation at start of day for internal functions.
> - */
> -struct scsi_cmnd *scsi_allocate_command(gfp_t gfp_mask)
> -{
> -       struct scsi_host_cmd_pool *pool = scsi_get_host_cmd_pool(gfp_mask);
> -
> -       if (!pool)
> -               return NULL;
> -
> -       return scsi_pool_alloc_command(pool, gfp_mask);
> -}
> -EXPORT_SYMBOL(scsi_allocate_command);
> -
> -/**
> - * scsi_free_command - free a command allocated by scsi_allocate_command
> - * @gfp_mask:  mask used in the original allocation
> - * @cmd:       command to free
> - *
> - * Note: using the original allocation mask is vital because that's
> - * what determines which command pool we use to free the command.  Any
> - * mismatch will cause the system to BUG eventually.
> - */
> -void scsi_free_command(gfp_t gfp_mask, struct scsi_cmnd *cmd)
> -{
> -       struct scsi_host_cmd_pool *pool = scsi_get_host_cmd_pool(gfp_mask);
> -
> -       /*
> -        * this could trigger if the mask to scsi_allocate_command
> -        * doesn't match this mask.  Otherwise we're guaranteed that this
> -        * succeeds because scsi_allocate_command must have taken a reference
> -        * on the pool
> -        */
> -       BUG_ON(!pool);
> -
> -       scsi_pool_free_command(pool, cmd);
> -       /*
> -        * scsi_put_host_cmd_pool is called twice; once to release the
> -        * reference we took above, and once to release the reference
> -        * originally taken by scsi_allocate_command
> -        */
> -       scsi_put_host_cmd_pool(gfp_mask);
> -       scsi_put_host_cmd_pool(gfp_mask);
> -}
> -EXPORT_SYMBOL(scsi_free_command);
> -
> -/**
>   * scsi_setup_command_freelist - Setup the command freelist for a scsi host.
>   * @shost: host to allocate the freelist for.
>   *
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 414edf9..dd7c998 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -155,9 +155,6 @@ extern void scsi_release_buffers(struct scsi_cmnd *cmd);
>  extern int scsi_dma_map(struct scsi_cmnd *cmd);
>  extern void scsi_dma_unmap(struct scsi_cmnd *cmd);
>
> -struct scsi_cmnd *scsi_allocate_command(gfp_t gfp_mask);
> -void scsi_free_command(gfp_t gfp_mask, struct scsi_cmnd *cmd);
> -
>  static inline unsigned scsi_sg_count(struct scsi_cmnd *cmd)
>  {
>         return cmd->sdb.table.nents;
> --
> 1.7.10.4
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Christoph/James,

I have reviewed this patch, and it looks good to me.
Please consider this ACK'd by the Megaraid driver team.

Acked-by: Adam Radford <aradford@gmail.com>

-Adam
