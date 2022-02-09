Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C92F6C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 07:29:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233163AbiBIH3s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 02:29:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiBIH3r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 02:29:47 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540E8C0613CB
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 23:29:50 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 00362210F1;
        Wed,  9 Feb 2022 07:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644391789; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U5yt5xphlp6jfHi72r7fw9IQ/3TNILuiTr+Jlswrnt4=;
        b=wigS+/3R1OKOrZozRkD4S4+Wl/Fku0Dh5DizPhzJ+3DiP0oPylLheeHBwqZ4D0T8Xee6is
        UBT74ICXZcoymLAB5I9mRTiSqGw8DaVnpJvOfRhtOBRbtCBv5Q+B5uSxvedemgXX3taJXc
        dl9GQbnnULkEEEbgUn4X0IuOuwcPVlM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644391789;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U5yt5xphlp6jfHi72r7fw9IQ/3TNILuiTr+Jlswrnt4=;
        b=qqAJOsmFD1yUWMdH7st+9QjlN88na2UOWY+TxBB8lFl+tXd1meO/fUr57AptVGhYpzGkP8
        SrKdGRIVVedxH2DA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 948CF1332F;
        Wed,  9 Feb 2022 07:29:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id nX6BImxtA2LmCAAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 09 Feb 2022 07:29:48 +0000
Message-ID: <43e1e556-7c3f-d0e6-ffc3-8e6b5fa6e4ab@suse.de>
Date:   Wed, 9 Feb 2022 08:29:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 05/44] NCR5380: Move the SCSI pointer to private
 command data
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Finn Thain <fthain@telegraphics.com.au>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Finn Thain <fthain@linux-m68k.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-6-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220208172514.3481-6-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/8/22 18:24, Bart Van Assche wrote:
> Move the SCSI pointer into the NCR5380 private command data instead of
> using the SCSI pointer from struct scsi_cmnd. This patch prepares for
> removal of the SCSI pointer from struct scsi_cmnd.
> 
> Cc: Finn Thain <fthain@telegraphics.com.au>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Ondrej Zary <linux@rainbow-software.org>
> Cc: Michael Schmitz <schmitzmic@gmail.com>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/NCR5380.c    | 83 +++++++++++++++++++++++----------------
>   drivers/scsi/NCR5380.h    |  8 ++++
>   drivers/scsi/atari_scsi.c |  6 ++-
>   drivers/scsi/g_NCR5380.c  |  5 ++-
>   drivers/scsi/mac_scsi.c   |  6 ++-
>   drivers/scsi/sun3_scsi.c  |  3 +-
>   6 files changed, 70 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> index 55af3e245a92..73c1b2ec6214 100644
> --- a/drivers/scsi/NCR5380.c
> +++ b/drivers/scsi/NCR5380.c
> @@ -145,40 +145,44 @@ static void bus_reset_cleanup(struct Scsi_Host *);
>   
>   static inline void initialize_SCp(struct scsi_cmnd *cmd)
>   {
> +	struct scsi_pointer *scsi_pointer = NCR5380_scsi_pointer(cmd);
> +
>   	/*
>   	 * Initialize the Scsi Pointer field so that all of the commands in the
>   	 * various queues are valid.
>   	 */
>   
>   	if (scsi_bufflen(cmd)) {
> -		cmd->SCp.buffer = scsi_sglist(cmd);
> -		cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
> -		cmd->SCp.this_residual = cmd->SCp.buffer->length;
> +		scsi_pointer->buffer = scsi_sglist(cmd);
> +		scsi_pointer->ptr = sg_virt(scsi_pointer->buffer);
> +		scsi_pointer->this_residual = scsi_pointer->buffer->length;
>   	} else {
> -		cmd->SCp.buffer = NULL;
> -		cmd->SCp.ptr = NULL;
> -		cmd->SCp.this_residual = 0;
> +		scsi_pointer->buffer = NULL;
> +		scsi_pointer->ptr = NULL;
> +		scsi_pointer->this_residual = 0;
>   	}
>   
> -	cmd->SCp.Status = 0;
> -	cmd->SCp.Message = 0;
> +	scsi_pointer->Status = 0;
> +	scsi_pointer->Message = 0;
>   }
>   
>   static inline void advance_sg_buffer(struct scsi_cmnd *cmd)
>   {
> -	struct scatterlist *s = cmd->SCp.buffer;
> +	struct scsi_pointer *scsi_pointer = NCR5380_scsi_pointer(cmd);
> +	struct scatterlist *s = scsi_pointer->buffer;
>   
> -	if (!cmd->SCp.this_residual && s && !sg_is_last(s)) {
> -		cmd->SCp.buffer = sg_next(s);
> -		cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
> -		cmd->SCp.this_residual = cmd->SCp.buffer->length;
> +	if (!scsi_pointer->this_residual && s && !sg_is_last(s)) {
> +		scsi_pointer->buffer = sg_next(s);
> +		scsi_pointer->ptr = sg_virt(scsi_pointer->buffer);
> +		scsi_pointer->this_residual = scsi_pointer->buffer->length;
>   	}
>   }
>   
>   static inline void set_resid_from_SCp(struct scsi_cmnd *cmd)
>   {
> -	int resid = cmd->SCp.this_residual;
> -	struct scatterlist *s = cmd->SCp.buffer;
> +	struct scsi_pointer *scsi_pointer = NCR5380_scsi_pointer(cmd);
> +	int resid = scsi_pointer->this_residual;
> +	struct scatterlist *s = scsi_pointer->buffer;
>   
>   	if (s)
>   		while (!sg_is_last(s)) {
> @@ -757,6 +761,7 @@ static void NCR5380_main(struct work_struct *work)
>   static void NCR5380_dma_complete(struct Scsi_Host *instance)
>   {
>   	struct NCR5380_hostdata *hostdata = shost_priv(instance);
> +	struct scsi_pointer *scsi_pointer;
>   	int transferred;
>   	unsigned char **data;
>   	int *count;
> @@ -764,7 +769,10 @@ static void NCR5380_dma_complete(struct Scsi_Host *instance)
>   	unsigned char p;
>   
>   	if (hostdata->read_overruns) {
> -		p = hostdata->connected->SCp.phase;
> +		struct scsi_pointer *scsi_pointer =
> +			NCR5380_scsi_pointer(hostdata->connected);
> +
> +		p = scsi_pointer->phase;
>   		if (p & SR_IO) {
>   			udelay(10);
>   			if ((NCR5380_read(BUS_AND_STATUS_REG) &
> @@ -801,8 +809,9 @@ static void NCR5380_dma_complete(struct Scsi_Host *instance)
>   	transferred = hostdata->dma_len - NCR5380_dma_residual(hostdata);
>   	hostdata->dma_len = 0;
>   
> -	data = (unsigned char **)&hostdata->connected->SCp.ptr;
> -	count = &hostdata->connected->SCp.this_residual;
> +	scsi_pointer = NCR5380_scsi_pointer(hostdata->connected);
> +	data = (unsigned char **)&scsi_pointer->ptr;
> +	count = &scsi_pointer->this_residual;
>   	*data += transferred;
>   	*count -= transferred;
>   
> @@ -1487,6 +1496,8 @@ static int NCR5380_transfer_dma(struct Scsi_Host *instance,
>   				unsigned char **data)
>   {
>   	struct NCR5380_hostdata *hostdata = shost_priv(instance);
> +	struct scsi_pointer *scsi_pointer =
> +		NCR5380_scsi_pointer(hostdata->connected);
>   	int c = *count;
>   	unsigned char p = *phase;
>   	unsigned char *d = *data;
> @@ -1498,7 +1509,7 @@ static int NCR5380_transfer_dma(struct Scsi_Host *instance,
>   		return -1;
>   	}
>   
> -	hostdata->connected->SCp.phase = p;
> +	scsi_pointer->phase = p;
>   
>   	if (p & SR_IO) {
>   		if (hostdata->read_overruns)
> @@ -1691,6 +1702,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
>   
>   	while ((cmd = hostdata->connected)) {
>   		struct NCR5380_cmd *ncmd = scsi_cmd_priv(cmd);
> +		struct scsi_pointer *scsi_pointer = &ncmd->scsi_pointer;
>   
>   		tmp = NCR5380_read(STATUS_REG);
>   		/* We only have a valid SCSI phase when REQ is asserted */

Why not using the macro you defined below?

> @@ -1712,10 +1724,10 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
>   				if (count > 0) {
>   					if (cmd->sc_data_direction == DMA_TO_DEVICE)
>   						sun3scsi_dma_send_setup(hostdata,
> -						                        cmd->SCp.ptr, count);
> +						                        scsi_pointer->ptr, count);
>   					else
>   						sun3scsi_dma_recv_setup(hostdata,
> -						                        cmd->SCp.ptr, count);
> +						                        scsi_pointer->ptr, count);
>   					sun3_dma_setup_done = cmd;
>   				}
>   #ifdef SUN3_SCSI_VME
> @@ -1758,8 +1770,8 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
>   				advance_sg_buffer(cmd);
>   				dsprintk(NDEBUG_INFORMATION, instance,
>   					"this residual %d, sg ents %d\n",
> -					cmd->SCp.this_residual,
> -					sg_nents(cmd->SCp.buffer));
> +					scsi_pointer->this_residual,
> +					sg_nents(scsi_pointer->buffer));
>   
>   				/*
>   				 * The preferred transfer method is going to be
> @@ -1778,7 +1790,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
>   				if (transfersize > 0) {
>   					len = transfersize;
>   					if (NCR5380_transfer_dma(instance, &phase,
> -					    &len, (unsigned char **)&cmd->SCp.ptr)) {
> +					    &len, (unsigned char **)&scsi_pointer->ptr)) {
>   						/*
>   						 * If the watchdog timer fires, all future
>   						 * accesses to this device will use the
> @@ -1794,13 +1806,13 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
>   					/* Transfer a small chunk so that the
>   					 * irq mode lock is not held too long.
>   					 */
> -					transfersize = min(cmd->SCp.this_residual,
> +					transfersize = min(scsi_pointer->this_residual,
>   							   NCR5380_PIO_CHUNK_SIZE);
>   					len = transfersize;
>   					NCR5380_transfer_pio(instance, &phase, &len,
> -					                     (unsigned char **)&cmd->SCp.ptr,
> +					                     (unsigned char **)&scsi_pointer->ptr,
>   							     0);
> -					cmd->SCp.this_residual -= transfersize - len;
> +					scsi_pointer->this_residual -= transfersize - len;
>   				}
>   #ifdef CONFIG_SUN3
>   				if (sun3_dma_setup_done == cmd)
> @@ -1811,7 +1823,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
>   				len = 1;
>   				data = &tmp;
>   				NCR5380_transfer_pio(instance, &phase, &len, &data, 0);
> -				cmd->SCp.Message = tmp;
> +				scsi_pointer->Message = tmp;
>   
>   				switch (tmp) {
>   				case ABORT:
> @@ -1828,15 +1840,15 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
>   					hostdata->connected = NULL;
>   					hostdata->busy[scmd_id(cmd)] &= ~(1 << cmd->device->lun);
>   
> -					set_status_byte(cmd, cmd->SCp.Status);
> +					set_status_byte(cmd, scsi_pointer->Status);
>   
>   					set_resid_from_SCp(cmd);
>   
>   					if (cmd->cmnd[0] == REQUEST_SENSE)
>   						complete_cmd(instance, cmd);
>   					else {
> -						if (cmd->SCp.Status == SAM_STAT_CHECK_CONDITION ||
> -						    cmd->SCp.Status == SAM_STAT_COMMAND_TERMINATED) {
> +						if (scsi_pointer->Status == SAM_STAT_CHECK_CONDITION ||
> +						    scsi_pointer->Status == SAM_STAT_COMMAND_TERMINATED) {
>   							dsprintk(NDEBUG_QUEUES, instance, "autosense: adding cmd %p to tail of autosense queue\n",
>   							         cmd);
>   							list_add_tail(&ncmd->list,
> @@ -2000,7 +2012,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
>   				len = 1;
>   				data = &tmp;
>   				NCR5380_transfer_pio(instance, &phase, &len, &data, 0);
> -				cmd->SCp.Status = tmp;
> +				scsi_pointer->Status = tmp;
>   				break;
>   			default:
>   				shost_printk(KERN_ERR, instance, "unknown phase\n");
> @@ -2151,6 +2163,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
>   
>   #ifdef CONFIG_SUN3
>   	if (sun3_dma_setup_done != tmp) {
> +		struct scsi_pointer *scsi_pointer = NCR5380_scsi_pointer(tmp);
>   		int count;
>   
>   		advance_sg_buffer(tmp);
> @@ -2160,10 +2173,12 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
>   		if (count > 0) {
>   			if (tmp->sc_data_direction == DMA_TO_DEVICE)
>   				sun3scsi_dma_send_setup(hostdata,
> -				                        tmp->SCp.ptr, count);
> +				                        scsi_pointer->ptr,
> +							count);
>   			else
>   				sun3scsi_dma_recv_setup(hostdata,
> -				                        tmp->SCp.ptr, count);
> +				                        scsi_pointer->ptr,
> +							count);
>   			sun3_dma_setup_done = tmp;
>   		}
>   	}
> diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
> index 845bd2423e66..adaf131aea4d 100644
> --- a/drivers/scsi/NCR5380.h
> +++ b/drivers/scsi/NCR5380.h
> @@ -227,9 +227,17 @@ struct NCR5380_hostdata {
>   };
>   
>   struct NCR5380_cmd {
> +	struct scsi_pointer scsi_pointer;
>   	struct list_head list;
>   };
>   
> +static inline struct scsi_pointer *NCR5380_scsi_pointer(struct scsi_cmnd *cmd)
> +{
> +	struct NCR5380_cmd *ncmd = scsi_cmd_priv(cmd);
> +
> +	return &ncmd->scsi_pointer;
> +}
> +

Seeing that it's open-coded at several places, maybe kill the macro 
entirely?

>   #define NCR5380_PIO_CHUNK_SIZE		256
>   
>   /* Time limit (ms) to poll registers when IRQs are disabled, e.g. during PDMA */
> diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
> index e9d0d99abc86..61fd3244a4ce 100644
> --- a/drivers/scsi/atari_scsi.c
> +++ b/drivers/scsi/atari_scsi.c
> @@ -538,7 +538,8 @@ static int falcon_classify_cmd(struct scsi_cmnd *cmd)
>   static int atari_scsi_dma_xfer_len(struct NCR5380_hostdata *hostdata,
>                                      struct scsi_cmnd *cmd)
>   {
> -	int wanted_len = cmd->SCp.this_residual;
> +	struct scsi_pointer *scsi_pointer = NCR5380_scsi_pointer(cmd);
> +	int wanted_len = scsi_pointer->this_residual;
>   	int possible_len, limit;
>   
>   	if (wanted_len < DMA_MIN_SIZE)
> @@ -610,7 +611,8 @@ static int atari_scsi_dma_xfer_len(struct NCR5380_hostdata *hostdata,
>   	}
>   
>   	/* Last step: apply the hard limit on DMA transfers */
> -	limit = (atari_dma_buffer && !STRAM_ADDR(virt_to_phys(cmd->SCp.ptr))) ?
> +	limit = (atari_dma_buffer &&
> +		 !STRAM_ADDR(virt_to_phys(scsi_pointer->ptr))) ?
>   		    STRAM_BUFFER_SIZE : 255*512;
>   	if (possible_len > limit)
>   		possible_len = limit;
> diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> index 5923f86a384e..fb39a656fd15 100644
> --- a/drivers/scsi/g_NCR5380.c
> +++ b/drivers/scsi/g_NCR5380.c
> @@ -663,7 +663,8 @@ static inline int generic_NCR5380_psend(struct NCR5380_hostdata *hostdata,
>   static int generic_NCR5380_dma_xfer_len(struct NCR5380_hostdata *hostdata,
>                                           struct scsi_cmnd *cmd)
>   {
> -	int transfersize = cmd->SCp.this_residual;
> +	struct scsi_pointer *scsi_pointer = NCR5380_scsi_pointer(cmd);
> +	int transfersize = scsi_pointer->this_residual;
>   
>   	if (hostdata->flags & FLAG_NO_PSEUDO_DMA)
>   		return 0;
> @@ -675,7 +676,7 @@ static int generic_NCR5380_dma_xfer_len(struct NCR5380_hostdata *hostdata,
>   	/* Limit PDMA send to 512 B to avoid random corruption on DTC3181E */
>   	if (hostdata->board == BOARD_DTC3181E &&
>   	    cmd->sc_data_direction == DMA_TO_DEVICE)
> -		transfersize = min(cmd->SCp.this_residual, 512);
> +		transfersize = min(scsi_pointer->this_residual, 512);
>   
>   	return min(transfersize, DMA_MAX_SIZE);
>   }
> diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
> index 71d493a0bb43..f31da6106b72 100644
> --- a/drivers/scsi/mac_scsi.c
> +++ b/drivers/scsi/mac_scsi.c
> @@ -404,11 +404,13 @@ static inline int macscsi_pwrite(struct NCR5380_hostdata *hostdata,
>   static int macscsi_dma_xfer_len(struct NCR5380_hostdata *hostdata,
>                                   struct scsi_cmnd *cmd)
>   {
> +	struct scsi_pointer *scsi_pointer = NCR5380_scsi_pointer(cmd);
> +
>   	if (hostdata->flags & FLAG_NO_PSEUDO_DMA ||
> -	    cmd->SCp.this_residual < setup_use_pdma)
> +	    scsi_pointer->this_residual < setup_use_pdma)
>   		return 0;
>   
> -	return cmd->SCp.this_residual;
> +	return scsi_pointer->this_residual;
>   }
>   
>   static int macscsi_dma_residual(struct NCR5380_hostdata *hostdata)
> diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
> index 82a253270c3b..50cbffbf2dd1 100644
> --- a/drivers/scsi/sun3_scsi.c
> +++ b/drivers/scsi/sun3_scsi.c
> @@ -334,7 +334,8 @@ static int sun3scsi_dma_residual(struct NCR5380_hostdata *hostdata)
>   static int sun3scsi_dma_xfer_len(struct NCR5380_hostdata *hostdata,
>                                    struct scsi_cmnd *cmd)
>   {
> -	int wanted_len = cmd->SCp.this_residual;
> +	struct scsi_pointer *scsi_pointer = NCR5380_scsi_pointer(cmd);
> +	int wanted_len = scsi_pointer->this_residual;
>   
>   	if (wanted_len < DMA_MIN_SIZE || blk_rq_is_passthrough(scsi_cmd_to_rq(cmd)))
>   		return 0;

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
