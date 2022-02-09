Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E63B3C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 08:22:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239591AbiBIIWK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 03:22:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239620AbiBIIWJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 03:22:09 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09B6C05CB85
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 00:22:12 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 8F842210E9;
        Wed,  9 Feb 2022 08:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644394931; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YDnducHcj4cfOIb1rxZY9PoEs0QSvxuPRmHqF8ssdpM=;
        b=PmOVGWIqC8bduKSG6l9ObKZ/O3Gl+ECU2PTn96x6N7rO/Eq+823NMNYNzaW4RcK11f/6Tc
        gS8JsTB+DdWdfHrvYXRxhVaWJgYGGfleB0KwBS9vlofyfHMdJ3qQFpIp5F288ikAFTOJe/
        TX00UCuNa8tSD9rScwTWzJUtit6KQ/o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644394931;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YDnducHcj4cfOIb1rxZY9PoEs0QSvxuPRmHqF8ssdpM=;
        b=AYGQPOECB2k4/00U9fsxwup1DrDSOb8YVP06jnckag+tdKlJBydPXV0gcVTAcMvejd/VGA
        T3TL5LoaZikxkDCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5FA34139D1;
        Wed,  9 Feb 2022 08:22:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id a+jMCbN5A2LGIQAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 09 Feb 2022 08:22:11 +0000
Message-ID: <58365673-eaa8-5c4b-73e5-e5e99956f589@suse.de>
Date:   Wed, 9 Feb 2022 09:22:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 35/44] ppa: Move the SCSI pointer to private command
 data
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-36-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220208172514.3481-36-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/8/22 18:25, Bart Van Assche wrote:
> Set .cmd_size in the SCSI host template instead of using the SCSI pointer
> from struct scsi_cmnd. This patch prepares for removal of the SCSI pointer
> from struct scsi_cmnd.
> 
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/ppa.c | 81 ++++++++++++++++++++++++++++------------------
>   1 file changed, 49 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
> index 003043de23a5..ac948768eba4 100644
> --- a/drivers/scsi/ppa.c
> +++ b/drivers/scsi/ppa.c
> @@ -45,6 +45,17 @@ typedef struct {
>   
>   #include  "ppa.h"
>   
> +struct ppa_cmd_priv {
> +	struct scsi_pointer scsi_pointer;
> +};
> +
> +static struct scsi_pointer *ppa_scsi_pointer(struct scsi_cmnd *cmd)
> +{
> +	struct ppa_cmd_priv *pcmd = scsi_cmd_priv(cmd);
> +
> +	return &pcmd->scsi_pointer;
> +}
> +	

Same here: please use 'struct scsi_pointer' directly.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
