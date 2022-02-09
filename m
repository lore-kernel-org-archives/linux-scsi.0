Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3B64C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 07:46:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236318AbiBIHqo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 02:46:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236130AbiBIHqn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 02:46:43 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B02FC0613CA
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 23:46:47 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 42621210E4;
        Wed,  9 Feb 2022 07:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644392806; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Haa8tcnmZdhzJ4ZBqWU3FTVMYvmX6u4K8z2LXhZ5F+A=;
        b=cEkJx8HTvR1byh8c1/MEGDDynU5T2XPXhaY4RcBWOdsqNMJXd10PxFcE0k1HES+0ncpDhC
        iejZUNpcuZyK/h0rXk4YFXY7nKg+219/nB2zwxG3GDNW6tO78jfWV/U5rPrUli/o90ffaB
        fDa22p66zwo1y8HLBSpnaJDeG8jscR4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644392806;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Haa8tcnmZdhzJ4ZBqWU3FTVMYvmX6u4K8z2LXhZ5F+A=;
        b=7IBYu6aQmbA0jU2lO8H0REgNubb8PMvSk4TyeVf4dSr9l3NIj7cspHqjIrNFh1KH9gRdvY
        y6MuHz/0yltXYfDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 08E3E139D1;
        Wed,  9 Feb 2022 07:46:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id zyQhAGZxA2KrDwAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 09 Feb 2022 07:46:46 +0000
Message-ID: <05b9a6dd-79ed-c9d3-a43c-2720c771dda4@suse.de>
Date:   Wed, 9 Feb 2022 08:46:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 18/44] fnic: Fix a tracing statement
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Hiral Patel <hiralpat@cisco.com>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        James Bottomley <JBottomley@Parallels.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-19-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220208172514.3481-19-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/8/22 18:24, Bart Van Assche wrote:
> Report both the command flags and command state instead of only the
> command state.
> 
> Cc: Hiral Patel <hiralpat@cisco.com>
> Fixes: 4d7007b49d52 ("[SCSI] fnic: Fnic Trace Utility")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/fnic/fnic_scsi.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
> index 88c549f257db..549754245f7a 100644
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c
> @@ -604,7 +604,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc)
>   
>   	FNIC_TRACE(fnic_queuecommand, sc->device->host->host_no,
>   		  tag, sc, io_req, sg_count, cmd_trace,
> -		  (((u64)CMD_FLAGS(sc) >> 32) | CMD_STATE(sc)));
> +		  (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
>   
>   	/* if only we issued IO, will we have the io lock */
>   	if (io_lock_acquired)

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
