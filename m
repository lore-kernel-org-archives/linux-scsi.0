Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA82BC4742C
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 10:15:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8040C20709
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 10:15:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728283AbgKPJjB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 04:39:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:33766 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726885AbgKPJjA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Nov 2020 04:39:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 51B68AFEB;
        Mon, 16 Nov 2020 09:38:59 +0000 (UTC)
Subject: Re: [PATCH V4 05/12] sbitmap: export sbitmap_weight
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>
References: <20201116090737.50989-1-ming.lei@redhat.com>
 <20201116090737.50989-6-ming.lei@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <d05cb6bf-35e6-d939-30a5-6ef3a9c8a679@suse.de>
Date:   Mon, 16 Nov 2020 10:38:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201116090737.50989-6-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/16/20 10:07 AM, Ming Lei wrote:
> SCSI's .device_busy will be converted to sbitmap, and sbitmap_weight
> is needed, so export the helper.
> 
> Cc: Omar Sandoval <osandov@fb.com>
> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
> Cc: Ewan D. Milne <emilne@redhat.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Tested-by: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   include/linux/sbitmap.h |  9 +++++++++
>   lib/sbitmap.c           | 11 ++++++-----
>   2 files changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/sbitmap.h b/include/linux/sbitmap.h
> index 103b41c03311..34343ce3ef6c 100644
> --- a/include/linux/sbitmap.h
> +++ b/include/linux/sbitmap.h
> @@ -346,6 +346,15 @@ static inline int sbitmap_test_bit(struct sbitmap *sb, unsigned int bitnr)
>    */
>   void sbitmap_show(struct sbitmap *sb, struct seq_file *m);
>   
> +
> +/**
> + * sbitmap_weight() - Return how many real bits set in a &struct sbitmap.
> + * @sb: Bitmap to check.
> + *
> + * Return: How many real bits set
> + */
> +unsigned int sbitmap_weight(const struct sbitmap *sb);
> +
>   /**
>    * sbitmap_bitmap_show() - Write a hex dump of a &struct sbitmap to a &struct
>    * seq_file.
> diff --git a/lib/sbitmap.c b/lib/sbitmap.c
> index dcd6a89b4d2f..fb1d3c2f70a2 100644
> --- a/lib/sbitmap.c
> +++ b/lib/sbitmap.c
> @@ -342,20 +342,21 @@ static unsigned int __sbitmap_weight(const struct sbitmap *sb, bool set)
>   	return weight;
>   }
>   
> -static unsigned int sbitmap_weight(const struct sbitmap *sb)
> +static unsigned int sbitmap_cleared(const struct sbitmap *sb)
>   {
> -	return __sbitmap_weight(sb, true);
> +	return __sbitmap_weight(sb, false);
>   }
>   
> -static unsigned int sbitmap_cleared(const struct sbitmap *sb)
> +unsigned int sbitmap_weight(const struct sbitmap *sb)
>   {
> -	return __sbitmap_weight(sb, false);
> +	return __sbitmap_weight(sb, true) - sbitmap_cleared(sb);
>   }
> +EXPORT_SYMBOL_GPL(sbitmap_weight);
>   
That is extremely confusing. Why do you change the meaning of 
'sbitmap_weight' from __sbitmap_weight(sb, true) to
__sbitmap_weight(sb, true) - __sbitmap_weight(sb, false)?
Does this mean that the original definition was wrong?
Or does this mean that this patch implies a different meaning of 
'sbitmap_weight'?
In either case, it's not 'just' an export, so it does warrant an 
explanation.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
