Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D560FC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 08:14:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237868AbiBIIOB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 03:14:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiBIIOA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 03:14:00 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82BB0C0613CA
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 00:14:04 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3EF171F383;
        Wed,  9 Feb 2022 08:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644394443; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TW1z1PDRQO9PtLxair2LSaDXhct8PTddqLIQxyqYwcU=;
        b=LWspJep2d+3OJtah+st8aTN5hk8Mq4kTPSz6gbs7h1KTdeX/dLqqU0vrv8naJT/TbSOjqV
        k2f8DCnuzpDFQP7qf8046WWr0DXF3htVIqmyCTFC5amo1SQi24o5ouekeJIJy0E34m5kMk
        4TUPKzNfjqhLyWY/TR0fxnkFYhaGYps=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644394443;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TW1z1PDRQO9PtLxair2LSaDXhct8PTddqLIQxyqYwcU=;
        b=a/IxqDG2oFkm/r47n5PAbpjuE30KWLRwCaxQ3cmLxZvFEt1Cmoq2Dii6Y2WaG0eJyVDpXN
        c3xLUPhPpIioL8CQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E65E5139D1;
        Wed,  9 Feb 2022 08:14:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id HsHxNsp3A2KzHQAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 09 Feb 2022 08:14:02 +0000
Message-ID: <8e2ce1a3-ea79-9a91-d32e-b245067bb9a0@suse.de>
Date:   Wed, 9 Feb 2022 09:14:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 27/44] megaraid: Stop using the SCSI pointer
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-28-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220208172514.3481-28-bvanassche@acm.org>
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
>   drivers/scsi/megaraid.c | 13 ++++---------
>   drivers/scsi/megaraid.h | 15 ++++++++++++++-
>   2 files changed, 18 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
> index 2061e3fe9824..a5d8cee2d510 100644
> --- a/drivers/scsi/megaraid.c
> +++ b/drivers/scsi/megaraid.c
> @@ -1644,16 +1644,10 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
>   static void
>   mega_rundoneq (adapter_t *adapter)
>   {
> -	struct scsi_cmnd *cmd;
> -	struct list_head *pos;
> +	struct megaraid_cmd_priv *cmd_priv;
>   
> -	list_for_each(pos, &adapter->completed_list) {
> -
> -		struct scsi_pointer* spos = (struct scsi_pointer *)pos;
> -
> -		cmd = list_entry(spos, struct scsi_cmnd, SCp);
> -		scsi_done(cmd);
> -	}
> +	list_for_each_entry(cmd_priv, &adapter->completed_list, entry)
> +		scsi_done(megaraid_to_scsi_cmd(cmd_priv));
>   
>   	INIT_LIST_HEAD(&adapter->completed_list);
>   }
> @@ -4123,6 +4117,7 @@ static struct scsi_host_template megaraid_template = {
>   	.eh_bus_reset_handler		= megaraid_reset,
>   	.eh_host_reset_handler		= megaraid_reset,
>   	.no_write_same			= 1,
> +	.cmd_size			= sizeof(struct megaraid_cmd_priv),
>   };
>   
>   static int
> diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
> index cce23a086fbe..be809ccb757e 100644
> --- a/drivers/scsi/megaraid.h
> +++ b/drivers/scsi/megaraid.h
> @@ -4,6 +4,7 @@
>   
>   #include <linux/spinlock.h>
>   #include <linux/mutex.h>
> +#include <scsi/scsi_cmnd.h>
>   
>   #define MEGARAID_VERSION	\
>   	"v2.00.4 (Release Date: Thu Feb 9 08:51:30 EST 2006)\n"
> @@ -756,8 +757,20 @@ struct private_bios_data {
>   #define CACHED_IO		0
>   #define DIRECT_IO		1
>   
> +struct megaraid_cmd_priv {
> +	struct list_head entry;
> +};
> +
> +#define SCSI_LIST(scp)							\
> +	(&((struct megaraid_cmd_priv *)scsi_cmd_priv(scp))->entry)
> +
> +static inline struct scsi_cmnd *
> +megaraid_to_scsi_cmd(struct megaraid_cmd_priv *cmd_priv)
> +{
> +	struct scsi_cmnd *cmd = (void *)cmd_priv;
>   
> -#define SCSI_LIST(scp) ((struct list_head *)(&(scp)->SCp))
> +	return cmd - 1;
> +}

cmd - 1? Seriously?

If you need this you'd better introduce a helper
(eg scsi_cmd_from_priv()).

>   
>   /*
>    * Each controller's soft state

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
