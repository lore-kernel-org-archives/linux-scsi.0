From: adam radford <aradford@gmail.com>
Subject: Re: [PATCH 3/3] 3w-9xxx: fix command completion race
Date: Thu, 23 Apr 2015 10:56:09 -0700
Message-ID: <CAHtARFG586a2Z39tHnLJ0X4RCwYb5HUt7EjRUqezyVrVksA_uQ@mail.gmail.com>
References: <1429775331-1017-1-git-send-email-hch@lst.de>
	<1429775331-1017-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1429775331-1017-4-git-send-email-hch@lst.de>
Sender: stable-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Torsten Luettgert <ml-lkml@enda.eu>, Bernd Kardatzki <Bernd.Kardatzki@med.uni-tuebingen.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 23, 2015 at 12:48 AM, Christoph Hellwig <hch@lst.de> wrote:
> The 3w-9xxx driver needs to tear down the dma mappings before returning
> the command to the midlayer, as there is no guarantee the sglist and
> count are valid after that point.  Also remove the dma mapping helpers
> which have another inherent race due to the request_id index.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Cc: stable@vger.kernel.org
> ---
>  drivers/scsi/3w-9xxx.c | 57 ++++++++++++--------------------------------------
>  drivers/scsi/3w-9xxx.h |  5 -----
>  2 files changed, 13 insertions(+), 49 deletions(-)
>
> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
> index 7600639..c3224b6 100644
> --- a/drivers/scsi/3w-9xxx.c
> +++ b/drivers/scsi/3w-9xxx.c
> @@ -149,7 +149,6 @@ static int twa_reset_sequence(TW_Device_Extension *tw_dev, int soft_reset);
>  static int twa_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id, char *cdb, int use_sg, TW_SG_Entry *sglistarg);
>  static void twa_scsiop_execute_scsi_complete(TW_Device_Extension *tw_dev, int request_id);
>  static char *twa_string_lookup(twa_message_type *table, unsigned int aen_code);
> -static void twa_unmap_scsi_data(TW_Device_Extension *tw_dev, int request_id);
>
>  /* Functions */
>
> @@ -1340,11 +1339,11 @@ static irqreturn_t twa_interrupt(int irq, void *dev_instance)
>                                 }
>
>                                 /* Now complete the io */
> +                               scsi_dma_unmap(cmd);
> +                               cmd->scsi_done(cmd);
>                                 tw_dev->state[request_id] = TW_S_COMPLETED;
>                                 twa_free_request_id(tw_dev, request_id);
>                                 tw_dev->posted_request_count--;
> -                               tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
> -                               twa_unmap_scsi_data(tw_dev, request_id);
>                         }
>
>                         /* Check for valid status after each drain */
> @@ -1402,26 +1401,6 @@ static void twa_load_sgl(TW_Device_Extension *tw_dev, TW_Command_Full *full_comm
>         }
>  } /* End twa_load_sgl() */
>
> -/* This function will perform a pci-dma mapping for a scatter gather list */
> -static int twa_map_scsi_sg_data(TW_Device_Extension *tw_dev, int request_id)
> -{
> -       int use_sg;
> -       struct scsi_cmnd *cmd = tw_dev->srb[request_id];
> -
> -       use_sg = scsi_dma_map(cmd);
> -       if (!use_sg)
> -               return 0;
> -       else if (use_sg < 0) {
> -               TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1c, "Failed to map scatter gather list");
> -               return 0;
> -       }
> -
> -       cmd->SCp.phase = TW_PHASE_SGLIST;
> -       cmd->SCp.have_data_in = use_sg;
> -
> -       return use_sg;
> -} /* End twa_map_scsi_sg_data() */
> -
>  /* This function will poll for a response interrupt of a request */
>  static int twa_poll_response(TW_Device_Extension *tw_dev, int request_id, int seconds)
>  {
> @@ -1600,9 +1579,11 @@ static int twa_reset_device_extension(TW_Device_Extension *tw_dev)
>                     (tw_dev->state[i] != TW_S_INITIAL) &&
>                     (tw_dev->state[i] != TW_S_COMPLETED)) {
>                         if (tw_dev->srb[i]) {
> -                               tw_dev->srb[i]->result = (DID_RESET << 16);
> -                               tw_dev->srb[i]->scsi_done(tw_dev->srb[i]);
> -                               twa_unmap_scsi_data(tw_dev, i);
> +                               struct scsi_cmnd * cmd = tw_dev->srb[i];
> +
> +                               cmd->result = (DID_RESET << 16);
> +                               scsi_dma_unmap(cmd);
> +                               cmd->scsi_done(cmd);
>                         }
>                 }
>         }
> @@ -1781,21 +1762,18 @@ static int twa_scsi_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_
>         /* Save the scsi command for use by the ISR */
>         tw_dev->srb[request_id] = SCpnt;
>
> -       /* Initialize phase to zero */
> -       SCpnt->SCp.phase = TW_PHASE_INITIAL;
> -
>         retval = twa_scsiop_execute_scsi(tw_dev, request_id, NULL, 0, NULL);
>         switch (retval) {
>         case SCSI_MLQUEUE_HOST_BUSY:
> +               scsi_dma_unmap(SCpnt);
>                 twa_free_request_id(tw_dev, request_id);
> -               twa_unmap_scsi_data(tw_dev, request_id);
>                 break;
>         case 1:
> -               tw_dev->state[request_id] = TW_S_COMPLETED;
> -               twa_free_request_id(tw_dev, request_id);
> -               twa_unmap_scsi_data(tw_dev, request_id);
>                 SCpnt->result = (DID_ERROR << 16);
> +               scsi_dma_unmap(SCpnt);
>                 done(SCpnt);
> +               tw_dev->state[request_id] = TW_S_COMPLETED;
> +               twa_free_request_id(tw_dev, request_id);
>                 retval = 0;
>         }
>  out:
> @@ -1863,8 +1841,8 @@ static int twa_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id,
>                                 command_packet->sg_list[0].address = TW_CPU_TO_SGL(tw_dev->generic_buffer_phys[request_id]);
>                                 command_packet->sg_list[0].length = cpu_to_le32(TW_MIN_SGL_LENGTH);
>                         } else {
> -                               sg_count = twa_map_scsi_sg_data(tw_dev, request_id);
> -                               if (sg_count == 0)
> +                               sg_count = scsi_dma_map(srb);
> +                               if (sg_count < 0)
>                                         goto out;
>
>                                 scsi_for_each_sg(srb, sg, sg_count, i) {
> @@ -1979,15 +1957,6 @@ static char *twa_string_lookup(twa_message_type *table, unsigned int code)
>         return(table[index].text);
>  } /* End twa_string_lookup() */
>
> -/* This function will perform a pci-dma unmap */
> -static void twa_unmap_scsi_data(TW_Device_Extension *tw_dev, int request_id)
> -{
> -       struct scsi_cmnd *cmd = tw_dev->srb[request_id];
> -
> -       if (cmd->SCp.phase == TW_PHASE_SGLIST)
> -               scsi_dma_unmap(cmd);
> -} /* End twa_unmap_scsi_data() */
> -
>  /* This function gets called when a disk is coming on-line */
>  static int twa_slave_configure(struct scsi_device *sdev)
>  {
> diff --git a/drivers/scsi/3w-9xxx.h b/drivers/scsi/3w-9xxx.h
> index 040f721..0fdc83c 100644
> --- a/drivers/scsi/3w-9xxx.h
> +++ b/drivers/scsi/3w-9xxx.h
> @@ -324,11 +324,6 @@ static twa_message_type twa_error_table[] = {
>  #define TW_CURRENT_DRIVER_BUILD 0
>  #define TW_CURRENT_DRIVER_BRANCH 0
>
> -/* Phase defines */
> -#define TW_PHASE_INITIAL 0
> -#define TW_PHASE_SINGLE  1
> -#define TW_PHASE_SGLIST  2
> -
>  /* Misc defines */
>  #define TW_9550SX_DRAIN_COMPLETED            0xFFFF
>  #define TW_SECTOR_SIZE                        512
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Acked-by: Adam Radford <aradford@gmail.com>
