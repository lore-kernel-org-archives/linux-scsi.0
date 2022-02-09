Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 684C3C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 08:21:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239476AbiBIIVY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 03:21:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbiBIIVX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 03:21:23 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28183C0613CA
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 00:21:27 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id DA296210F8;
        Wed,  9 Feb 2022 08:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644394885; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+dJrQ6EaLeB1VE0W4Hyb133tM3Gq9emw1iKssrUnc8Y=;
        b=tKXgnwbWMq3j+q1Zqg9V/bwfPrzDr1l3ldaJbPQIhE/OCXdj3f3DZJVLpF8c/dgtk87ckz
        OhpqfYBx9rLic687CNv7uLAaDXooCdiVR4eVOgCPb6NKjjlCTkukfHEbP7SucW8P3eBBqn
        NOs9B+dp4DIO4+iS2I/8vkcjTyCQYwg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644394885;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+dJrQ6EaLeB1VE0W4Hyb133tM3Gq9emw1iKssrUnc8Y=;
        b=EWqFX3pyVBxMglJavvwJ5rsd8ZmR9Bey5vRY9YRO6eZ79Or3a6WEWrMroWYquKO+yKU+5G
        kNtrcjG/QSWYQlDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 332B4139D1;
        Wed,  9 Feb 2022 08:21:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id dIMuCYV5A2J/IQAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 09 Feb 2022 08:21:25 +0000
Message-ID: <0370f022-1d43-44ef-66d0-6b8d3e9e071e@suse.de>
Date:   Wed, 9 Feb 2022 09:21:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 34/44] sym53c500_cs: Move the SCSI pointer to private
 command data
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-35-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220208172514.3481-35-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/8/22 18:25, Bart Van Assche wrote:
> Set .cmd_size in the SCSI host template instead of using the SCSI pointer
> from struct scsi_cmnd.
> This patch prepares for removal of the SCSI pointer from struct scsi_cmnd.
> 
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/pcmcia/sym53c500_cs.c | 53 ++++++++++++++++++++----------
>   1 file changed, 35 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
> index fc93d2a57e1e..298df2180bc7 100644
> --- a/drivers/scsi/pcmcia/sym53c500_cs.c
> +++ b/drivers/scsi/pcmcia/sym53c500_cs.c
> @@ -192,6 +192,17 @@ struct sym53c500_data {
>   	int fast_pio;
>   };
>   
> +struct sym53c500_cmd_priv {
> +	struct scsi_pointer scsi_pointer;
> +};
> +
> +static struct scsi_pointer *sym53c500_scsi_pointer(struct scsi_cmnd *cmd)
> +{
> +	struct sym53c500_cmd_priv *scmd = scsi_cmd_priv(cmd);
> +
> +	return &scmd->scsi_pointer;
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
