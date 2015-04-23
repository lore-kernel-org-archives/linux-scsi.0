From: adam radford <aradford@gmail.com>
Subject: Re: [PATCH 1/3] 3w-sas: fix command completion race
Date: Thu, 23 Apr 2015 10:55:44 -0700
Message-ID: <CAHtARFFg8RYHkemrmx+MOO-yDtznAeCSqCiguSP=Mtc4kdeYrA@mail.gmail.com>
References: <1429775331-1017-1-git-send-email-hch@lst.de>
	<1429775331-1017-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:36359 "EHLO
	mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030210AbbDWRzp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Apr 2015 13:55:45 -0400
In-Reply-To: <1429775331-1017-2-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Torsten Luettgert <ml-lkml@enda.eu>, Bernd Kardatzki <Bernd.Kardatzki@med.uni-tuebingen.de>, stable@vger.kernel.org

On Thu, Apr 23, 2015 at 12:48 AM, Christoph Hellwig <hch@lst.de> wrote:
> The 3w-sas driver needs to tear down the dma mappings before returning
> the command to the midlayer, as there is no guarantee the sglist and
> count are valid after that point.  Also remove the dma mapping helpers
> which have another inherent race due to the request_id index.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Torsten Luettgert <ml-lkml@enda.eu>
> Tested-by: Bernd Kardatzki <Bernd.Kardatzki@med.uni-tuebingen.de>
> Cc: stable@vger.kernel.org
> ---
>  drivers/scsi/3w-sas.c | 50 ++++++++++----------------------------------------
>  drivers/scsi/3w-sas.h |  4 ----
>  2 files changed, 10 insertions(+), 44 deletions(-)
>
> diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
> index 2361772..3d4c5f9 100644
> --- a/drivers/scsi/3w-sas.c
> +++ b/drivers/scsi/3w-sas.c
> @@ -290,26 +290,6 @@ static int twl_post_command_packet(TW_Device_Extension *tw_dev, int request_id)
>         return 0;
>  } /* End twl_post_command_packet() */
>
> -/* This function will perform a pci-dma mapping for a scatter gather list */
> -static int twl_map_scsi_sg_data(TW_Device_Extension *tw_dev, int request_id)
> -{
> -       int use_sg;
> -       struct scsi_cmnd *cmd = tw_dev->srb[request_id];
> -
> -       use_sg = scsi_dma_map(cmd);
> -       if (!use_sg)
> -               return 0;
> -       else if (use_sg < 0) {
> -               TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1, "Failed to map scatter gather list");
> -               return 0;
> -       }
> -
> -       cmd->SCp.phase = TW_PHASE_SGLIST;
> -       cmd->SCp.have_data_in = use_sg;
> -
> -       return use_sg;
> -} /* End twl_map_scsi_sg_data() */
> -
>  /* This function hands scsi cdb's to the firmware */
>  static int twl_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id, char *cdb, int use_sg, TW_SG_Entry_ISO *sglistarg)
>  {
> @@ -357,8 +337,8 @@ static int twl_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id,
>         if (!sglistarg) {
>                 /* Map sglist from scsi layer to cmd packet */
>                 if (scsi_sg_count(srb)) {
> -                       sg_count = twl_map_scsi_sg_data(tw_dev, request_id);
> -                       if (sg_count == 0)
> +                       sg_count = scsi_dma_map(srb);
> +                       if (sg_count <= 0)
>                                 goto out;
>
>                         scsi_for_each_sg(srb, sg, sg_count, i) {
> @@ -1102,15 +1082,6 @@ out:
>         return retval;
>  } /* End twl_initialize_device_extension() */
>
> -/* This function will perform a pci-dma unmap */
> -static void twl_unmap_scsi_data(TW_Device_Extension *tw_dev, int request_id)
> -{
> -       struct scsi_cmnd *cmd = tw_dev->srb[request_id];
> -
> -       if (cmd->SCp.phase == TW_PHASE_SGLIST)
> -               scsi_dma_unmap(cmd);
> -} /* End twl_unmap_scsi_data() */
> -
>  /* This function will handle attention interrupts */
>  static int twl_handle_attention_interrupt(TW_Device_Extension *tw_dev)
>  {
> @@ -1251,11 +1222,11 @@ static irqreturn_t twl_interrupt(int irq, void *dev_instance)
>                         }
>
>                         /* Now complete the io */
> +                       scsi_dma_unmap(cmd);
> +                       cmd->scsi_done(cmd);
>                         tw_dev->state[request_id] = TW_S_COMPLETED;
>                         twl_free_request_id(tw_dev, request_id);
>                         tw_dev->posted_request_count--;
> -                       tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
> -                       twl_unmap_scsi_data(tw_dev, request_id);
>                 }
>
>                 /* Check for another response interrupt */
> @@ -1400,10 +1371,12 @@ static int twl_reset_device_extension(TW_Device_Extension *tw_dev, int ioctl_res
>                 if ((tw_dev->state[i] != TW_S_FINISHED) &&
>                     (tw_dev->state[i] != TW_S_INITIAL) &&
>                     (tw_dev->state[i] != TW_S_COMPLETED)) {
> -                       if (tw_dev->srb[i]) {
> -                               tw_dev->srb[i]->result = (DID_RESET << 16);
> -                               tw_dev->srb[i]->scsi_done(tw_dev->srb[i]);
> -                               twl_unmap_scsi_data(tw_dev, i);
> +                       struct scsi_cmnd * cmd = tw_dev->srb[i];
> +
> +                       if (cmd) {
> +                               cmd->result = (DID_RESET << 16);
> +                               scsi_dma_unmap(cmd);
> +                               cmd->scsi_done(cmd);
>                         }
>                 }
>         }
> @@ -1507,9 +1480,6 @@ static int twl_scsi_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_
>         /* Save the scsi command for use by the ISR */
>         tw_dev->srb[request_id] = SCpnt;
>
> -       /* Initialize phase to zero */
> -       SCpnt->SCp.phase = TW_PHASE_INITIAL;
> -
>         retval = twl_scsiop_execute_scsi(tw_dev, request_id, NULL, 0, NULL);
>         if (retval) {
>                 tw_dev->state[request_id] = TW_S_COMPLETED;
> diff --git a/drivers/scsi/3w-sas.h b/drivers/scsi/3w-sas.h
> index d474892..fec6449 100644
> --- a/drivers/scsi/3w-sas.h
> +++ b/drivers/scsi/3w-sas.h
> @@ -103,10 +103,6 @@ static char *twl_aen_severity_table[] =
>  #define TW_CURRENT_DRIVER_BUILD 0
>  #define TW_CURRENT_DRIVER_BRANCH 0
>
> -/* Phase defines */
> -#define TW_PHASE_INITIAL 0
> -#define TW_PHASE_SGLIST  2
> -
>  /* Misc defines */
>  #define TW_SECTOR_SIZE                        512
>  #define TW_MAX_UNITS                         32
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Christoph,

Thanks for the patches!  LGTM.

Acked-by: Adam Radford <aradford@gmail.com>
