Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 781CDC4320A
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 06:09:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F73161052
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 06:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbhHIGJe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 02:09:34 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:45642 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbhHIGJd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 02:09:33 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E04B11FD8B;
        Mon,  9 Aug 2021 06:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628489350; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KTsdHLNngBRItLsOeCRct6yXojKSD5xUmCDmuKjap14=;
        b=JZp5iz1gRh9WaJkt05ognGdT6WuP/DxxlWq+RsvzI+WRu32EKaYYr8U/utwsRKunygKj1P
        CPNn4eNjVe7IqBpAz8zM9xumjkIjEtn91Ibz/4AkqXXg0GexbNCBNafbb3P3SWwXYCFeNE
        0fwK5tMONDPHxUE5AxN1DfOex8Y+msc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628489350;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KTsdHLNngBRItLsOeCRct6yXojKSD5xUmCDmuKjap14=;
        b=EyZZGM+VIvrywQG3PHCtHtYVS/kSrYzhy6hWDhROleF2P4PpkRjRr7rxdwmojfyUOBRWiT
        RqSbt5PdbCjBmXCg==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 9951D13318;
        Mon,  9 Aug 2021 06:09:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id Ix7LI4bGEGF3BwAAGKfGzw
        (envelope-from <hare@suse.de>); Mon, 09 Aug 2021 06:09:10 +0000
Subject: Re: [PATCH v4 01/10] libata: fix ata_host_alloc_pinfo()
To:     Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
References: <20210807041859.579409-1-damien.lemoal@wdc.com>
 <20210807041859.579409-2-damien.lemoal@wdc.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <8b4177d7-b23b-e152-1bcc-35d39118e26b@suse.de>
Date:   Mon, 9 Aug 2021 08:09:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210807041859.579409-2-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/7/21 6:18 AM, Damien Le Moal wrote:
> Avoid static checkers warnings about a potential NULL pointer
> dereference for the port info variable pi. To do so, test that at least
> one port info is available on entry to ata_host_alloc_pinfo() and start
> the ata port initialization for loop with pi initialized to a non-NULL
> pointer. Within the for loop, get the next port info (if it is not NULL)
> after initializing the ata port using the previous port info.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>   drivers/ata/libata-core.c | 16 +++++++++++-----
>   1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 61c762961ca8..b17e161c07e2 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -5441,16 +5441,17 @@ struct ata_host *ata_host_alloc_pinfo(struct device *dev,
>   	struct ata_host *host;
>   	int i, j;
>   
> +	/* We must have at least one port info */
> +	if (!ppi[0])
> +		return NULL;
> +
>   	host = ata_host_alloc(dev, n_ports);
>   	if (!host)
>   		return NULL;
>   
> -	for (i = 0, j = 0, pi = NULL; i < host->n_ports; i++) {
> +	for (i = 0, j = 0, pi = ppi[0]; i < host->n_ports; i++) {
>   		struct ata_port *ap = host->ports[i];
>   
> -		if (ppi[j])
> -			pi = ppi[j++];
> -
>   		ap->pio_mask = pi->pio_mask;
>   		ap->mwdma_mask = pi->mwdma_mask;
>   		ap->udma_mask = pi->udma_mask;
> @@ -5458,8 +5459,13 @@ struct ata_host *ata_host_alloc_pinfo(struct device *dev,
>   		ap->link.flags |= pi->link_flags;
>   		ap->ops = pi->port_ops;
>   
> -		if (!host->ops && (pi->port_ops != &ata_dummy_port_ops))
> +		if (!host->ops && pi->port_ops != &ata_dummy_port_ops)
>   			host->ops = pi->port_ops;
> +
> +		if (ppi[j + 1]) {
> +			j++;
> +			pi = ppi[j];
> +		}
>   	}
>   
>   	return host;
> 
This requires a comment as to why this is necessary.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
