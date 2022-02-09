Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31E89C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 07:41:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238802AbiBIHk6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 02:40:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238874AbiBIHko (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 02:40:44 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39C0C05CB87
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 23:40:48 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5FAD31F383;
        Wed,  9 Feb 2022 07:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644392447; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h2ssUGtD6yeY0b8xyf5FfEbleFoaW7KMg6gEcTXy2Ys=;
        b=YtGHvyr1GKEJIaM8t7DImMig9/W6llqbtYxm3aEmCuB+FTnT39SMkCG+TDOO07gVsKVJ/K
        J5dMBA4+6Wqxar6RkmSEuu16gO9M4moS9d5I7sJ/k/aTUAdvaQ7grMDGwSYWrSOnSc1vWz
        LjjApIs2wyAcNNwhMTZlOzh6avCFu1o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644392447;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h2ssUGtD6yeY0b8xyf5FfEbleFoaW7KMg6gEcTXy2Ys=;
        b=a40IVlWAOd90B/ZK9qJ2lIodYJOltVJB5LbMv5TvqYLTPvS4/qhFNC43p3ENLyHzCA/Kef
        lQr90j+871ks91AA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 27FFF13216;
        Wed,  9 Feb 2022 07:40:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id qZwjCP9vA2JADQAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 09 Feb 2022 07:40:47 +0000
Message-ID: <7c9c006c-4bdd-7412-947a-05114eac14fc@suse.de>
Date:   Wed, 9 Feb 2022 08:40:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 13/44] bfa: Stop using the SCSI pointer
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-14-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220208172514.3481-14-bvanassche@acm.org>
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
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/bfa/bfad_im.c | 27 ++++++++++++++-------------
>   drivers/scsi/bfa/bfad_im.h | 16 ++++++++++++++++
>   2 files changed, 30 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
> index 759d2bb1ecdd..8419a1a89485 100644
> --- a/drivers/scsi/bfa/bfad_im.c
> +++ b/drivers/scsi/bfa/bfad_im.c
> @@ -150,10 +150,10 @@ bfa_cb_tskim_done(void *bfad, struct bfad_tskim_s *dtsk,
>   	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dtsk;
>   	wait_queue_head_t *wq;
>   
> -	cmnd->SCp.Status |= tsk_status << 1;
> -	set_bit(IO_DONE_BIT, (unsigned long *)&cmnd->SCp.Status);
> -	wq = (wait_queue_head_t *) cmnd->SCp.ptr;
> -	cmnd->SCp.ptr = NULL;
> +	bfad_priv(cmnd)->status |= tsk_status << 1;
> +	set_bit(IO_DONE_BIT, &bfad_priv(cmnd)->status);
> +	wq = bfad_priv(cmnd)->wq;
> +	bfad_priv(cmnd)->wq = NULL;
>   
>   	if (wq)
>   		wake_up(wq);
> @@ -259,7 +259,7 @@ bfad_im_target_reset_send(struct bfad_s *bfad, struct scsi_cmnd *cmnd,
>   	 * happens.
>   	 */
>   	cmnd->host_scribble = NULL;
> -	cmnd->SCp.Status = 0;
> +	bfad_priv(cmnd)->status = 0;
>   	bfa_itnim = bfa_fcs_itnim_get_halitn(&itnim->fcs_itnim);
>   	/*
>   	 * bfa_itnim can be NULL if the port gets disconnected and the bfa
> @@ -326,8 +326,8 @@ bfad_im_reset_lun_handler(struct scsi_cmnd *cmnd)
>   	 * if happens.
>   	 */
>   	cmnd->host_scribble = NULL;
> -	cmnd->SCp.ptr = (char *)&wq;
> -	cmnd->SCp.Status = 0;
> +	bfad_priv(cmnd)->wq = &wq;
> +	bfad_priv(cmnd)->status = 0;
>   	bfa_itnim = bfa_fcs_itnim_get_halitn(&itnim->fcs_itnim);
>   	/*
>   	 * bfa_itnim can be NULL if the port gets disconnected and the bfa
> @@ -347,10 +347,9 @@ bfad_im_reset_lun_handler(struct scsi_cmnd *cmnd)
>   			    FCP_TM_LUN_RESET, BFAD_LUN_RESET_TMO);
>   	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
>   
> -	wait_event(wq, test_bit(IO_DONE_BIT,
> -			(unsigned long *)&cmnd->SCp.Status));
> +	wait_event(wq, test_bit(IO_DONE_BIT, &bfad_priv(cmnd)->status));
>   
> -	task_status = cmnd->SCp.Status >> 1;
> +	task_status = bfad_priv(cmnd)->status >> 1;
>   	if (task_status != BFI_TSKIM_STS_OK) {
>   		BFA_LOG(KERN_ERR, bfad, bfa_log_level,
>   			"LUN reset failure, status: %d\n", task_status);
> @@ -381,16 +380,16 @@ bfad_im_reset_target_handler(struct scsi_cmnd *cmnd)
>   	spin_lock_irqsave(&bfad->bfad_lock, flags);
>   	itnim = bfad_get_itnim(im_port, starget->id);
>   	if (itnim) {
> -		cmnd->SCp.ptr = (char *)&wq;
> +		bfad_priv(cmnd)->wq = &wq;
>   		rc = bfad_im_target_reset_send(bfad, cmnd, itnim);
>   		if (rc == BFA_STATUS_OK) {
>   			/* wait target reset to complete */
>   			spin_unlock_irqrestore(&bfad->bfad_lock, flags);
>   			wait_event(wq, test_bit(IO_DONE_BIT,
> -					(unsigned long *)&cmnd->SCp.Status));
> +						&bfad_priv(cmnd)->status));
>   			spin_lock_irqsave(&bfad->bfad_lock, flags);
>   
> -			task_status = cmnd->SCp.Status >> 1;
> +			task_status = bfad_priv(cmnd)->status >> 1;
>   			if (task_status != BFI_TSKIM_STS_OK)
>   				BFA_LOG(KERN_ERR, bfad, bfa_log_level,
>   					"target reset failure,"
> @@ -797,6 +796,7 @@ struct scsi_host_template bfad_im_scsi_host_template = {
>   	.name = BFAD_DRIVER_NAME,
>   	.info = bfad_im_info,
>   	.queuecommand = bfad_im_queuecommand,
> +	.cmd_size = sizeof(struct bfad_cmd_priv),
>   	.eh_timed_out = fc_eh_timed_out,
>   	.eh_abort_handler = bfad_im_abort_handler,
>   	.eh_device_reset_handler = bfad_im_reset_lun_handler,
> @@ -819,6 +819,7 @@ struct scsi_host_template bfad_im_vport_template = {
>   	.name = BFAD_DRIVER_NAME,
>   	.info = bfad_im_info,
>   	.queuecommand = bfad_im_queuecommand,
> +	.cmd_size = sizeof(struct bfad_cmd_priv),
>   	.eh_timed_out = fc_eh_timed_out,
>   	.eh_abort_handler = bfad_im_abort_handler,
>   	.eh_device_reset_handler = bfad_im_reset_lun_handler,
> diff --git a/drivers/scsi/bfa/bfad_im.h b/drivers/scsi/bfa/bfad_im.h
> index 829345b514d1..c03b225ea1ba 100644
> --- a/drivers/scsi/bfa/bfad_im.h
> +++ b/drivers/scsi/bfa/bfad_im.h
> @@ -43,6 +43,22 @@ u32 bfad_im_supported_speeds(struct bfa_s *bfa);
>    */
>   #define IO_DONE_BIT			0
>   
> +/**
> + * struct bfad_cmd_priv - private data per SCSI command.
> + * @status: Lowest bit represents IO_DONE. The next seven bits hold a value of
> + * type enum bfi_tskim_status.
> + * @wq: Wait queue used to wait for completion of an operation.
> + */
> +struct bfad_cmd_priv {
> +	unsigned long status;
> +	wait_queue_head_t *wq;
> +};
> +
> +static inline struct bfad_cmd_priv *bfad_priv(struct scsi_cmnd *cmd)
> +{
> +	return scsi_cmd_priv(cmd);
> +}
> +
>   struct bfad_itnim_data_s {
>   	struct bfad_itnim_s *itnim;
>   };

When moving SCSI pointer usage into the command payload, have you 
considered dropping the use of the 'host_scribble' pointer, too?
As we already allocated a command payload it should be easy to increase 
it by another pointer, and move the 'host_scribble' stuff in there.
Hmm?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
