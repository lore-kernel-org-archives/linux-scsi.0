Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E1CC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 07:58:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233878AbiBIH6w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 02:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiBIH6u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 02:58:50 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B64C0613CA
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 23:58:54 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1FB921F383;
        Wed,  9 Feb 2022 07:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644393533; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ko9GiyuLmrY1z7E7tCN8scuDcFEUpb7WbIrmFvVJmlA=;
        b=gxS5IlU7ghwmTsanTMX5VyIBATA0lsdVPDlVDe1l4hqcOGLXvTf6jJTPe1XgUEeFnV9A/Y
        0kDoFgjDAt0yfnId7RLZudRpD8Tc2nPuavdDzzuGgDpQkK9DCfpQSqZ7y/k1Rr72xg5BpD
        pzSr97IxTaEbLfXAFic4/y95TLiHlSI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644393533;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ko9GiyuLmrY1z7E7tCN8scuDcFEUpb7WbIrmFvVJmlA=;
        b=vkkKG+FLSyo3zV0IdslU8J1RDbrj2VcY39PO2uj4vhG1vaODMe4V4TwDux8vZS5qilkBbc
        07QNgO7JVRT8aaAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EE231139D1;
        Wed,  9 Feb 2022 07:58:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id zg1MOTx0A2KsFAAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 09 Feb 2022 07:58:52 +0000
Message-ID: <9a73879b-cc52-0db3-5fe6-d3226ad709fc@suse.de>
Date:   Wed, 9 Feb 2022 08:58:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 21/44] imm: Move the SCSI pointer to private command
 data
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-22-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220208172514.3481-22-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/8/22 18:24, Bart Van Assche wrote:
> Set .cmd_size in the SCSI host template instead of using the SCSI pointer.
> This patch prepares for removal of the SCSI pointer from struct scsi_cmnd.
> 
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/imm.c | 88 ++++++++++++++++++++++++----------------------
>   drivers/scsi/imm.h | 11 ++++++
>   2 files changed, 56 insertions(+), 43 deletions(-)
> 
> diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
> index 8afdb4dba2be..3d86e3a52866 100644
> --- a/drivers/scsi/imm.c
> +++ b/drivers/scsi/imm.c
> @@ -66,7 +66,7 @@ static void got_it(imm_struct *dev)
>   {
>   	dev->base = dev->dev->port->base;
>   	if (dev->cur_cmd)
> -		dev->cur_cmd->SCp.phase = 1;
> +		imm_scsi_pointer(dev->cur_cmd)->phase = 1;
>   	else
>   		wake_up(dev->waiting);
>   }
> @@ -618,13 +618,14 @@ static inline int imm_send_command(struct scsi_cmnd *cmd)
>    * The driver appears to remain stable if we speed up the parallel port
>    * i/o in this function, but not elsewhere.
>    */
> -static int imm_completion(struct scsi_cmnd *cmd)
> +static int imm_completion(struct scsi_cmnd *const cmd)
>   {
>   	/* Return codes:
>   	 * -1     Error
>   	 *  0     Told to schedule
>   	 *  1     Finished data transfer
>   	 */
> +	struct scsi_pointer *scsi_pointer = imm_scsi_pointer(cmd);
>   	imm_struct *dev = imm_dev(cmd->device->host);
>   	unsigned short ppb = dev->base;
>   	unsigned long start_jiffies = jiffies;
> @@ -660,44 +661,43 @@ static int imm_completion(struct scsi_cmnd *cmd)
>   		 * a) Drive status is screwy (!ready && !present)
>   		 * b) Drive is requesting/sending more data than expected
>   		 */
> -		if (((r & 0x88) != 0x88) || (cmd->SCp.this_residual <= 0)) {
> +		if ((r & 0x88) != 0x88 || scsi_pointer->this_residual <= 0) {
>   			imm_fail(dev, DID_ERROR);
>   			return -1;	/* ERROR_RETURN */
>   		}
>   		/* determine if we should use burst I/O */
>   		if (dev->rd == 0) {
> -			fast = (bulk
> -				&& (cmd->SCp.this_residual >=
> -				    IMM_BURST_SIZE)) ? IMM_BURST_SIZE : 2;
> -			status = imm_out(dev, cmd->SCp.ptr, fast);
> +			fast = bulk && scsi_pointer->this_residual >=
> +				IMM_BURST_SIZE ? IMM_BURST_SIZE : 2;
> +			status = imm_out(dev, scsi_pointer->ptr, fast);
>   		} else {
> -			fast = (bulk
> -				&& (cmd->SCp.this_residual >=
> -				    IMM_BURST_SIZE)) ? IMM_BURST_SIZE : 1;
> -			status = imm_in(dev, cmd->SCp.ptr, fast);
> +			fast = bulk && scsi_pointer->this_residual >=
> +				IMM_BURST_SIZE ? IMM_BURST_SIZE : 1;
> +			status = imm_in(dev, scsi_pointer->ptr, fast);
>   		}
>   
> -		cmd->SCp.ptr += fast;
> -		cmd->SCp.this_residual -= fast;
> +		scsi_pointer->ptr += fast;
> +		scsi_pointer->this_residual -= fast;
>   
>   		if (!status) {
>   			imm_fail(dev, DID_BUS_BUSY);
>   			return -1;	/* ERROR_RETURN */
>   		}
> -		if (cmd->SCp.buffer && !cmd->SCp.this_residual) {
> +		if (scsi_pointer->buffer && !scsi_pointer->this_residual) {
>   			/* if scatter/gather, advance to the next segment */
> -			if (cmd->SCp.buffers_residual--) {
> -				cmd->SCp.buffer = sg_next(cmd->SCp.buffer);
> -				cmd->SCp.this_residual =
> -				    cmd->SCp.buffer->length;
> -				cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
> +			if (scsi_pointer->buffers_residual--) {
> +				scsi_pointer->buffer =
> +					sg_next(scsi_pointer->buffer);
> +				scsi_pointer->this_residual =
> +				    scsi_pointer->buffer->length;
> +				scsi_pointer->ptr = sg_virt(scsi_pointer->buffer);
>   
>   				/*
>   				 * Make sure that we transfer even number of bytes
>   				 * otherwise it makes imm_byte_out() messy.
>   				 */
> -				if (cmd->SCp.this_residual & 0x01)
> -					cmd->SCp.this_residual++;
> +				if (scsi_pointer->this_residual & 0x01)
> +					scsi_pointer->this_residual++;
>   			}
>   		}
>   		/* Now check to see if the drive is ready to comunicate */
> @@ -762,7 +762,7 @@ static void imm_interrupt(struct work_struct *work)
>   	}
>   #endif
>   
> -	if (cmd->SCp.phase > 1)
> +	if (imm_scsi_pointer(cmd)->phase > 1)
>   		imm_disconnect(dev);
>   
>   	imm_pb_dismiss(dev);
> @@ -774,8 +774,9 @@ static void imm_interrupt(struct work_struct *work)
>   	return;
>   }
>   
> -static int imm_engine(imm_struct *dev, struct scsi_cmnd *cmd)
> +static int imm_engine(imm_struct *dev, struct scsi_cmnd *const cmd)
>   {
> +	struct scsi_pointer *scsi_pointer = imm_scsi_pointer(cmd);
>   	unsigned short ppb = dev->base;
>   	unsigned char l = 0, h = 0;
>   	int retv, x;
> @@ -786,7 +787,7 @@ static int imm_engine(imm_struct *dev, struct scsi_cmnd *cmd)
>   	if (dev->failed)
>   		return 0;
>   
> -	switch (cmd->SCp.phase) {
> +	switch (scsi_pointer->phase) {
>   	case 0:		/* Phase 0 - Waiting for parport */
>   		if (time_after(jiffies, dev->jstart + HZ)) {
>   			/*
> @@ -800,7 +801,7 @@ static int imm_engine(imm_struct *dev, struct scsi_cmnd *cmd)
>   
>   	case 1:		/* Phase 1 - Connected */
>   		imm_connect(dev, CONNECT_EPP_MAYBE);
> -		cmd->SCp.phase++;
> +		scsi_pointer->phase++;
>   		fallthrough;
>   
>   	case 2:		/* Phase 2 - We are now talking to the scsi bus */
> @@ -808,7 +809,7 @@ static int imm_engine(imm_struct *dev, struct scsi_cmnd *cmd)
>   			imm_fail(dev, DID_NO_CONNECT);
>   			return 0;
>   		}
> -		cmd->SCp.phase++;
> +		scsi_pointer->phase++;
>   		fallthrough;
>   
>   	case 3:		/* Phase 3 - Ready to accept a command */
> @@ -818,23 +819,23 @@ static int imm_engine(imm_struct *dev, struct scsi_cmnd *cmd)
>   
>   		if (!imm_send_command(cmd))
>   			return 0;
> -		cmd->SCp.phase++;
> +		scsi_pointer->phase++;
>   		fallthrough;
>   
>   	case 4:		/* Phase 4 - Setup scatter/gather buffers */
>   		if (scsi_bufflen(cmd)) {
> -			cmd->SCp.buffer = scsi_sglist(cmd);
> -			cmd->SCp.this_residual = cmd->SCp.buffer->length;
> -			cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
> +			scsi_pointer->buffer = scsi_sglist(cmd);
> +			scsi_pointer->this_residual = scsi_pointer->buffer->length;
> +			scsi_pointer->ptr = sg_virt(scsi_pointer->buffer);
>   		} else {
> -			cmd->SCp.buffer = NULL;
> -			cmd->SCp.this_residual = 0;
> -			cmd->SCp.ptr = NULL;
> +			scsi_pointer->buffer = NULL;
> +			scsi_pointer->this_residual = 0;
> +			scsi_pointer->ptr = NULL;
>   		}
> -		cmd->SCp.buffers_residual = scsi_sg_count(cmd) - 1;
> -		cmd->SCp.phase++;
> -		if (cmd->SCp.this_residual & 0x01)
> -			cmd->SCp.this_residual++;
> +		scsi_pointer->buffers_residual = scsi_sg_count(cmd) - 1;
> +		scsi_pointer->phase++;
> +		if (scsi_pointer->this_residual & 0x01)
> +			scsi_pointer->this_residual++;
>   		fallthrough;
>   
>   	case 5:		/* Phase 5 - Pre-Data transfer stage */
> @@ -851,7 +852,7 @@ static int imm_engine(imm_struct *dev, struct scsi_cmnd *cmd)
>   		if ((dev->dp) && (dev->rd))
>   			if (imm_negotiate(dev))
>   				return 0;
> -		cmd->SCp.phase++;
> +		scsi_pointer->phase++;
>   		fallthrough;
>   
>   	case 6:		/* Phase 6 - Data transfer stage */
> @@ -867,7 +868,7 @@ static int imm_engine(imm_struct *dev, struct scsi_cmnd *cmd)
>   			if (retv == 0)
>   				return 1;
>   		}
> -		cmd->SCp.phase++;
> +		scsi_pointer->phase++;
>   		fallthrough;
>   
>   	case 7:		/* Phase 7 - Post data transfer stage */
> @@ -879,7 +880,7 @@ static int imm_engine(imm_struct *dev, struct scsi_cmnd *cmd)
>   				w_ctr(ppb, 0x4);
>   			}
>   		}
> -		cmd->SCp.phase++;
> +		scsi_pointer->phase++;
>   		fallthrough;
>   
>   	case 8:		/* Phase 8 - Read status/message */
> @@ -922,7 +923,7 @@ static int imm_queuecommand_lck(struct scsi_cmnd *cmd)
>   	dev->jstart = jiffies;
>   	dev->cur_cmd = cmd;
>   	cmd->result = DID_ERROR << 16;	/* default return code */
> -	cmd->SCp.phase = 0;	/* bus free */
> +	imm_scsi_pointer(cmd)->phase = 0;	/* bus free */
>   
>   	schedule_delayed_work(&dev->imm_tq, 0);
>   
> @@ -961,7 +962,7 @@ static int imm_abort(struct scsi_cmnd *cmd)
>   	 * have tied the SCSI_MESSAGE line high in the interface
>   	 */
>   
> -	switch (cmd->SCp.phase) {
> +	switch (imm_scsi_pointer(cmd)->phase) {
>   	case 0:		/* Do not have access to parport */
>   	case 1:		/* Have not connected to interface */
>   		dev->cur_cmd = NULL;	/* Forget the problem */
> @@ -987,7 +988,7 @@ static int imm_reset(struct scsi_cmnd *cmd)
>   {
>   	imm_struct *dev = imm_dev(cmd->device->host);
>   
> -	if (cmd->SCp.phase)
> +	if (imm_scsi_pointer(cmd)->phase)
>   		imm_disconnect(dev);
>   	dev->cur_cmd = NULL;	/* Forget the problem */
>   
> @@ -1109,6 +1110,7 @@ static struct scsi_host_template imm_template = {
>   	.sg_tablesize		= SG_ALL,
>   	.can_queue		= 1,
>   	.slave_alloc		= imm_adjust_queue,
> +	.cmd_size		= sizeof(struct imm_cmd_priv),
>   };
>   
>   /***************************************************************************
> diff --git a/drivers/scsi/imm.h b/drivers/scsi/imm.h
> index 7f2bb35b1b87..12cbc7ee8bba 100644
> --- a/drivers/scsi/imm.h
> +++ b/drivers/scsi/imm.h
> @@ -139,6 +139,17 @@ static char *IMM_MODE_STRING[] =
>   #define w_ctr(x,y)      outb(y, (x)+2)
>   #endif
>   
> +struct imm_cmd_priv {
> +	struct scsi_pointer scsi_pointer;
> +};
> +
Why the indirection?
You can use 'struct scsi_pointer' directly as payload, no?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
