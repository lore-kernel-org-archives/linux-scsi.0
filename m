Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D995C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 08:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235796AbiBIISh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 03:18:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbiBIISg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 03:18:36 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25832C0613CA
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 00:18:40 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D1369210E9;
        Wed,  9 Feb 2022 08:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644394718; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XDVUTvHGmhDEZeQ7IfUhmZEVtAtx8yhcypDMwLYcr38=;
        b=tJUdlTqjRNCEyqyAQ7alpKzq6E+qcu0ui+KqoN9IbXNTAoQ39CpnFPJhAvFe50/flKKBPv
        pbJ/jI2AE3vexIRW21ooAY1WJEalGDmgRFUE3FQce4o3eIxdgnaxvz69o/w4lHFQsLZdl7
        JbF7+c+6M//feedhPbTVDMQr+z/Os5w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644394718;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XDVUTvHGmhDEZeQ7IfUhmZEVtAtx8yhcypDMwLYcr38=;
        b=uNbeO9LWGJId9Eg3tVy6MFJbnzbFbVM6Sp4Gpr/PBWvD1KGNzXKzn0oj9uJ8WxkyR6AK/V
        4xZm0J/SSXjtbfBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 04988139D1;
        Wed,  9 Feb 2022 08:18:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id C2HmMt14A2IjIAAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 09 Feb 2022 08:18:37 +0000
Message-ID: <71cc3897-569e-87e9-0aa3-cb1f539b6b29@suse.de>
Date:   Wed, 9 Feb 2022 09:18:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 32/44] nsp32: Stop using the SCSI pointer
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, GOTO Masanori <gotom@debian.or.jp>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-33-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220208172514.3481-33-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/8/22 18:25, Bart Van Assche wrote:
> Move the SCSI status field to private data. Stop setting the .ptr,
> .this_residual, .buffer and .buffer_residual SCSI pointer members
> since no code in this driver reads these members.
> 
> This patch prepares for removal of the SCSI pointer from struct scsi_cmnd.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/nsp32.c | 20 +++++++-------------
>   drivers/scsi/nsp32.h |  9 +++++++++
>   2 files changed, 16 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
> index bd3ee3bf08ee..75bb0028ed74 100644
> --- a/drivers/scsi/nsp32.c
> +++ b/drivers/scsi/nsp32.c
> @@ -273,6 +273,7 @@ static struct scsi_host_template nsp32_template = {
>   	.eh_abort_handler		= nsp32_eh_abort,
>   	.eh_host_reset_handler		= nsp32_eh_host_reset,
>   /*	.highmem_io			= 1, */
> +	.cmd_size			= sizeof(struct nsp32_cmd_priv),
>   };
>   
>   #include "nsp32_io.h"
> @@ -946,14 +947,9 @@ static int nsp32_queuecommand_lck(struct scsi_cmnd *SCpnt)
>   	show_command(SCpnt);
>   
>   	data->CurrentSC      = SCpnt;
> -	SCpnt->SCp.Status    = SAM_STAT_CHECK_CONDITION;
> +	nsp32_priv(SCpnt)->status = SAM_STAT_CHECK_CONDITION;
>   	scsi_set_resid(SCpnt, scsi_bufflen(SCpnt));
>   
> -	SCpnt->SCp.ptr		    = (char *)scsi_sglist(SCpnt);
> -	SCpnt->SCp.this_residual    = scsi_bufflen(SCpnt);
> -	SCpnt->SCp.buffer	    = NULL;
> -	SCpnt->SCp.buffers_residual = 0;
> -
>   	/* initialize data */
>   	data->msgout_len	= 0;
>   	data->msgin_len		= 0;
> @@ -1376,7 +1372,7 @@ static irqreturn_t do_nsp32_isr(int irq, void *dev_id)
>   		case BUSPHASE_STATUS:
>   			nsp32_dbg(NSP32_DEBUG_INTR, "fifo/status");
>   
> -			SCpnt->SCp.Status = nsp32_read1(base, SCSI_CSB_IN);
> +			nsp32_priv(SCpnt)->status = nsp32_read1(base, SCSI_CSB_IN);
>   
>   			break;
>   		default:
> @@ -1687,18 +1683,18 @@ static int nsp32_busfree_occur(struct scsi_cmnd *SCpnt, unsigned short execph)
>   		/* MsgIn 00: Command Complete */
>   		nsp32_dbg(NSP32_DEBUG_BUSFREE, "command complete");
>   
> -		SCpnt->SCp.Status  = nsp32_read1(base, SCSI_CSB_IN);
> +		nsp32_priv(SCpnt)->status  = nsp32_read1(base, SCSI_CSB_IN);
>   		nsp32_dbg(NSP32_DEBUG_BUSFREE,
>   			  "normal end stat=0x%x resid=0x%x\n",
> -			  SCpnt->SCp.Status, scsi_get_resid(SCpnt));
> +			  nsp32_priv(SCpnt)->status, scsi_get_resid(SCpnt));
>   		SCpnt->result = (DID_OK << 16) |
> -			(SCpnt->SCp.Status << 0);
> +			(nsp32_priv(SCpnt)->status << 0);
>   		nsp32_scsi_done(SCpnt);
>   		/* All operation is done */
>   		return TRUE;
>   	} else if (execph & MSGIN_04_VALID) {
>   		/* MsgIn 04: Disconnect */
> -		SCpnt->SCp.Status  = nsp32_read1(base, SCSI_CSB_IN);
> +		nsp32_priv(SCpnt)->status = nsp32_read1(base, SCSI_CSB_IN);
>   
>   		nsp32_dbg(NSP32_DEBUG_BUSFREE, "disconnect");
>   		return TRUE;
> @@ -1706,8 +1702,6 @@ static int nsp32_busfree_occur(struct scsi_cmnd *SCpnt, unsigned short execph)
>   		/* Unexpected bus free */
>   		nsp32_msg(KERN_WARNING, "unexpected bus free occurred");
>   
> -		/* DID_ERROR? */
> -		//SCpnt->result   = (DID_OK << 16) | (SCpnt->SCp.Status << 0);
>   		SCpnt->result = DID_ERROR << 16;
>   		nsp32_scsi_done(SCpnt);
>   		return TRUE;
> diff --git a/drivers/scsi/nsp32.h b/drivers/scsi/nsp32.h
> index ab0726c070f7..924889f8bd37 100644
> --- a/drivers/scsi/nsp32.h
> +++ b/drivers/scsi/nsp32.h
> @@ -534,6 +534,15 @@ typedef struct _nsp32_sync_table {
>         ---PERIOD-- ---OFFSET--   */
>   #define TO_SYNCREG(period, offset) (((period) & 0x0f) << 4 | ((offset) & 0x0f))
>   
> +struct nsp32_cmd_priv {
> +	enum sam_status status;
> +};
> +
> +static inline struct nsp32_cmd_priv *nsp32_priv(struct scsi_cmnd *cmd)
> +{
> +	return scsi_cmd_priv(cmd);
> +}
> +
>   typedef struct _nsp32_target {
>   	unsigned char	syncreg;	/* value for SYNCREG   */
>   	unsigned char	ackwidth;	/* value for ACKWIDTH  */

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
