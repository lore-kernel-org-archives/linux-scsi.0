Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EF56C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 07:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbiBIH4c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 02:56:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiBIH4a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 02:56:30 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22297C0613CA
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 23:56:34 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C8F2A1F383;
        Wed,  9 Feb 2022 07:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644393392; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FB9se7kazWrWz/cgPHifyPX8o4QSQoe0lvs/2wW+UHc=;
        b=ppkCOwbw1WVESefzoBKgup9lA7G2pJzx2If7WBJczy91AGuiJ0AAd68F9GOOAx4lDKjJiv
        qRc3xWwbxiIhi4/vkx3d85RpLPU7mUp4N/tIcS0hY7a5Wtc6W2ud8ZWodsh0k9EuQZQ2al
        KNp57a7ht5rAw72jMO/hewyTi8l+uCA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644393392;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FB9se7kazWrWz/cgPHifyPX8o4QSQoe0lvs/2wW+UHc=;
        b=slUp766V7aGBFheTplDlA77KmGXhhLzECKAe3Hx2p2DBWG9v2rIYTdD2reOOsjWTfPwCYD
        QVAydVxK/gR9dwAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8947A139D1;
        Wed,  9 Feb 2022 07:56:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id WjSqILBzA2JREwAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 09 Feb 2022 07:56:32 +0000
Message-ID: <4f1ff3c2-0365-5a26-2391-e735b2ed4951@suse.de>
Date:   Wed, 9 Feb 2022 08:56:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 19/44] fnic: Stop using the SCSI pointer
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-20-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220208172514.3481-20-bvanassche@acm.org>
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
>   drivers/scsi/fnic/fnic.h      |  27 +++-
>   drivers/scsi/fnic/fnic_main.c |   1 +
>   drivers/scsi/fnic/fnic_scsi.c | 289 +++++++++++++++++-----------------
>   3 files changed, 163 insertions(+), 154 deletions(-)
> 
> diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
> index b95d0063dedb..aa07189fb5fb 100644
> --- a/drivers/scsi/fnic/fnic.h
> +++ b/drivers/scsi/fnic/fnic.h
> @@ -89,15 +89,28 @@
>   #define FNIC_DEV_RST_ABTS_PENDING       BIT(21)
>   
>   /*
> - * Usage of the scsi_cmnd scratchpad.
> + * fnic private data per SCSI command.
>    * These fields are locked by the hashed io_req_lock.
>    */
> -#define CMD_SP(Cmnd)		((Cmnd)->SCp.ptr)
> -#define CMD_STATE(Cmnd)		((Cmnd)->SCp.phase)
> -#define CMD_ABTS_STATUS(Cmnd)	((Cmnd)->SCp.Message)
> -#define CMD_LR_STATUS(Cmnd)	((Cmnd)->SCp.have_data_in)
> -#define CMD_TAG(Cmnd)           ((Cmnd)->SCp.sent_command)
> -#define CMD_FLAGS(Cmnd)         ((Cmnd)->SCp.Status)
> +struct fnic_cmd_priv {
> +	struct fnic_io_req *io_req;
> +	enum fnic_ioreq_state state;
> +	u32 flags;
> +	u16 abts_status;
> +	u16 lr_status;
> +};
> +
> +static inline struct fnic_cmd_priv *fnic_priv(struct scsi_cmnd *cmd)
> +{
> +	return scsi_cmd_priv(cmd);
> +}
> +
> +static inline u64 fnic_flags_and_state(struct scsi_cmnd *cmd)
> +{
> +	struct fnic_cmd_priv *fcmd = fnic_priv(cmd);
> +
> +	return ((u64)fcmd->flags << 32) | fcmd->state;
> +}
>   
>   #define FCPIO_INVALID_CODE 0x100 /* hdr_status value unused by firmware */
>   
> diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
> index 44dbaa662d94..9161bd2fd421 100644
> --- a/drivers/scsi/fnic/fnic_main.c
> +++ b/drivers/scsi/fnic/fnic_main.c
> @@ -124,6 +124,7 @@ static struct scsi_host_template fnic_host_template = {
>   	.max_sectors = 0xffff,
>   	.shost_groups = fnic_host_groups,
>   	.track_queue_depth = 1,
> +	.cmd_size = sizeof(struct fnic_cmd_priv),
>   };
>   
>   static void
> diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
> index 549754245f7a..3c00e5b88350 100644
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c
> @@ -497,8 +497,8 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc)
>   	 * caller disabling them.
>   	 */
>   	spin_unlock(lp->host->host_lock);
> -	CMD_STATE(sc) = FNIC_IOREQ_NOT_INITED;
> -	CMD_FLAGS(sc) = FNIC_NO_FLAGS;
> +	fnic_priv(sc)->state = FNIC_IOREQ_NOT_INITED;
> +	fnic_priv(sc)->flags = FNIC_NO_FLAGS;
>   
Why not keep the macros?
Would be less churn with the driver, no?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
