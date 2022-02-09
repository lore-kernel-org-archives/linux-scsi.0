Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 045AFC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 11:53:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiBILxN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 06:53:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiBILxM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 06:53:12 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB64C1DF83D
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 02:43:58 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3A79B1F390;
        Wed,  9 Feb 2022 08:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644396577; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PXVFpB7AqDrku6pUx9jJHTH8e7kwpusD0JXbyQ7bXEY=;
        b=npMg8lrGMYXB/lRWlWjGW35AypX0ZS3sTAr3RBBxDCGCTUp02TSHQpcAEAFcQD1G1iZrTb
        xgPrWQmZiAhn8Pg96r4R+3QZiSiEbiwpxBkAs+8hoA1dzudw/wt9bnCs26tTQRQm7x7vpl
        yyGjBMfBB8HmDYOCBG6TLDEzhqMP17w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644396577;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PXVFpB7AqDrku6pUx9jJHTH8e7kwpusD0JXbyQ7bXEY=;
        b=wsK7LNUKs8zmy1yo298SsFVrhA8+lTzU/2DPGHRLXYnP/s1Pwu5AUlrP2VaSyhq68h40xy
        j1QxBUr3BDlymtDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 11EAC1332F;
        Wed,  9 Feb 2022 08:49:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id WRG3AyGAA2KNLgAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 09 Feb 2022 08:49:37 +0000
Message-ID: <920d216f-185e-b362-6c93-9c6999d85364@suse.de>
Date:   Wed, 9 Feb 2022 09:49:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 29/44] mesh: Move the SCSI pointer to private command
 data
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-30-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220208172514.3481-30-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/8/22 18:24, Bart Van Assche wrote:
> Set .cmd_size in the SCSI host template instead of using the SCSI pointer
> from struct scsi_cmnd. This patch prepares for removal of the SCSI pointer
> from struct scsi_cmnd.
> 
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/mesh.c | 20 +++++++++++++-------
>   drivers/scsi/mesh.h | 11 +++++++++++
>   2 files changed, 24 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
> index ca133e0a140a..de9ae36def42 100644
> --- a/drivers/scsi/mesh.c
> +++ b/drivers/scsi/mesh.c
> @@ -586,10 +586,12 @@ static void mesh_done(struct mesh_state *ms, int start_next)
>   	ms->current_req = NULL;
>   	tp->current_req = NULL;
>   	if (cmd) {
> +		struct scsi_pointer *scsi_pointer = mesh_scsi_pointer(cmd);
> +
>   		set_host_byte(cmd, ms->stat);
> -		set_status_byte(cmd, cmd->SCp.Status);
> +		set_status_byte(cmd, scsi_pointer->Status);
>   		if (ms->stat == DID_OK)
> -			scsi_msg_to_host_byte(cmd, cmd->SCp.Message);
> +			scsi_msg_to_host_byte(cmd, scsi_pointer->Message);
>   		if (DEBUG_TARGET(cmd)) {
>   			printk(KERN_DEBUG "mesh_done: result = %x, data_ptr=%d, buflen=%d\n",
>   			       cmd->result, ms->data_ptr, scsi_bufflen(cmd));
> @@ -603,7 +605,7 @@ static void mesh_done(struct mesh_state *ms, int start_next)
>   			}
>   #endif
>   		}
> -		cmd->SCp.this_residual -= ms->data_ptr;
> +		scsi_pointer->this_residual -= ms->data_ptr;
>   		scsi_done(cmd);
>   	}
>   	if (start_next) {
> @@ -1171,7 +1173,7 @@ static void handle_msgin(struct mesh_state *ms)
>   	if (ms->n_msgin < msgin_length(ms))
>   		goto reject;
>   	if (cmd)
> -		cmd->SCp.Message = code;
> +		mesh_scsi_pointer(cmd)->Message = code;
>   	switch (code) {
>   	case COMMAND_COMPLETE:
>   		break;
> @@ -1262,7 +1264,7 @@ static void set_dma_cmds(struct mesh_state *ms, struct scsi_cmnd *cmd)
>   	if (cmd) {
>   		int nseg;
>   
> -		cmd->SCp.this_residual = scsi_bufflen(cmd);
> +		mesh_scsi_pointer(cmd)->this_residual = scsi_bufflen(cmd);
>   
>   		nseg = scsi_dma_map(cmd);
>   		BUG_ON(nseg < 0);
> @@ -1592,10 +1594,13 @@ static void cmd_complete(struct mesh_state *ms)
>   			break;
>   		case statusing:
>   			if (cmd) {
> -				cmd->SCp.Status = mr->fifo;
> +				struct scsi_pointer *scsi_pointer =
> +					mesh_scsi_pointer(cmd);
> +
> +				scsi_pointer->Status = mr->fifo;
>   				if (DEBUG_TARGET(cmd))
>   					printk(KERN_DEBUG "mesh: status is %x\n",
> -					       cmd->SCp.Status);
> +					       scsi_pointer->Status);
>   			}
>   			ms->msgphase = msg_in;
>   			break;
> @@ -1837,6 +1842,7 @@ static struct scsi_host_template mesh_template = {
>   	.sg_tablesize			= SG_ALL,
>   	.cmd_per_lun			= 2,
>   	.max_segment_size		= 65535,
> +	.cmd_size			= sizeof(struct mesh_cmd_priv),
>   };
>   
>   static int mesh_probe(struct macio_dev *mdev, const struct of_device_id *match)
> diff --git a/drivers/scsi/mesh.h b/drivers/scsi/mesh.h
> index ee53c05ace95..1afa8b37295b 100644
> --- a/drivers/scsi/mesh.h
> +++ b/drivers/scsi/mesh.h
> @@ -8,6 +8,17 @@
>   #ifndef _MESH_H
>   #define _MESH_H
>   
> +struct mesh_cmd_priv {
> +	struct scsi_pointer scsi_pointer;
> +};
> +
> +static inline struct scsi_pointer *mesh_scsi_pointer(struct scsi_cmnd *cmd)
> +{
> +	struct mesh_cmd_priv *mcmd = scsi_cmd_priv(cmd);
> +
> +	return &mcmd->scsi_pointer;
> +}
> +
>   /*
>    * Registers in the MESH controller.
>    */

Also here, please use 'struct scsi_pointer' directly.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
