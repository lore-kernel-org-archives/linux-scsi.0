Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6936EE49AB
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Aug 2023 06:26:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232926AbjHWG0e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Aug 2023 02:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232443AbjHWG0d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2023 02:26:33 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED31E70;
        Tue, 22 Aug 2023 23:26:05 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E49571F38A;
        Wed, 23 Aug 2023 06:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1692771963; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XN7LqX2H6SbWhNZUOepPsDIemoCNTeP1hUkjrQMnJg8=;
        b=PnlH3/MXDHI1G5VSHUSwJpitXWLZwqhVXHd5X6Z8fzkcK/tRvNJ4wBT6nAN/sn8xYOaGtJ
        JgA8naWgSwjR9wfqqiCARSLuuyiGipCGUtY2kQ+JqK/VWye+Qu6Uc0IABXyEsTDuvyfedc
        HEpc+NHnoxhjPKl+6CZEilaAgEBtOOA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1692771963;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XN7LqX2H6SbWhNZUOepPsDIemoCNTeP1hUkjrQMnJg8=;
        b=RR1WmuBmp+ULiqf+0l2Rf8346o1IVs89YHBjgEnWr1qccmrFyWhO28tBMtbsATGPJ45PU0
        0TLw/wk7o7jA/NAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 44BCE13458;
        Wed, 23 Aug 2023 06:26:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id AqV8D3qm5WTLJAAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 23 Aug 2023 06:26:02 +0000
Message-ID: <3562fc36-4bc2-b4fb-a2ad-1e310baf1b47@suse.de>
Date:   Wed, 23 Aug 2023 08:26:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v11 04/16] scsi: core: Introduce a mechanism for
 reordering requests in the error handler
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230822191822.337080-1-bvanassche@acm.org>
 <20230822191822.337080-5-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230822191822.337080-5-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/22/23 21:16, Bart Van Assche wrote:
> Introduce the .eh_needs_prepare_resubmit and the .eh_prepare_resubmit
> function pointers in struct scsi_driver. Make the error handler call
> .eh_prepare_resubmit() before resubmitting commands if any of the
> .eh_needs_prepare_resubmit() invocations return true. A later patch
> will use this functionality to sort SCSI commands by LBA from inside
> the SCSI disk driver before these are resubmitted by the error handler.
> 
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/scsi_error.c  | 65 ++++++++++++++++++++++++++++++++++++++
>   drivers/scsi/scsi_priv.h   |  1 +
>   include/scsi/scsi_driver.h |  2 ++
>   3 files changed, 68 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index c67cdcdc3ba8..c4d817f044a0 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -27,6 +27,7 @@
>   #include <linux/blkdev.h>
>   #include <linux/delay.h>
>   #include <linux/jiffies.h>
> +#include <linux/list_sort.h>
>   
>   #include <scsi/scsi.h>
>   #include <scsi/scsi_cmnd.h>
> @@ -2186,6 +2187,68 @@ void scsi_eh_ready_devs(struct Scsi_Host *shost,
>   }
>   EXPORT_SYMBOL_GPL(scsi_eh_ready_devs);
>   
> +/*
> + * Returns true if .eh_prepare_resubmit should be called for the commands in
> + * @done_q.
> + */
> +static bool scsi_needs_preparation(struct list_head *done_q)
> +{
> +	struct scsi_cmnd *scmd;
> +
> +	list_for_each_entry(scmd, done_q, eh_entry) {
> +		struct scsi_driver *uld = scsi_cmd_to_driver(scmd);
> +		bool (*npr)(struct scsi_cmnd *) = uld->eh_needs_prepare_resubmit;
> +
> +		if (npr && npr(scmd))
> +			return true;
> +	}
> +
> +	return false;
> +}
> + > +/*
> + * Comparison function that allows to sort SCSI commands by ULD driver.
> + */
> +static int scsi_cmp_uld(void *priv, const struct list_head *_a,
> +			const struct list_head *_b)
> +{
> +	struct scsi_cmnd *a = list_entry(_a, typeof(*a), eh_entry);
> +	struct scsi_cmnd *b = list_entry(_b, typeof(*b), eh_entry);
> +
> +	/* See also the comment above the list_sort() definition. */
> +	return scsi_cmd_to_driver(a) > scsi_cmd_to_driver(b);

I have to agree with Christoph here.
Comparing LBA numbers at the SCSI level is really the wrong place.
SCSI commands might be anything, and quite some of these commands don't
even have LBA numbers. So trying to order them will be pointless.

The reordering mechanism really has to go into the block layer, with
the driver failing the request and the block layer resubmitting in-order.

Sorry.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

