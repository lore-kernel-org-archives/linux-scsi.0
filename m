Return-Path: <SRS0=0yur=EJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ACBDC2D0A3
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 13:22:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BEB121534
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 13:22:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FSNu+p+Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729207AbgKCNWf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Nov 2020 08:22:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729205AbgKCNWe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2020 08:22:34 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0C3C0613D1;
        Tue,  3 Nov 2020 05:22:34 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id oq3so22208030ejb.7;
        Tue, 03 Nov 2020 05:22:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Y51Nz46vqk7FKl0bA40zhWT3Uvjs83z5KYe+jNaFjB4=;
        b=FSNu+p+Q3mEiAZKZ77h8iLZLJtVMQHcmI4UUo3IgyiX2sVL4bb5OEpYuRly/wH5wIM
         zlSO13IinpDsmnBHhQ2ZSF5fPZ8ZZYk1P95ELPBgYTHhRgoGjMvmLgyVhA8GNDqbVo7O
         oAib7Cf0efZZsgvdLX0/Ojw0KzBU+VxVKzXltTPOkgypInCpRxJ262SLw4vEKkmM1q/B
         bOj0JhjdaPtoCxmILYFgJzMGgr6Lxlwft/1locGzFuNbomL1ZaJiLiNB6UztP1gHNZ6I
         KkClh4MZNoKm1B69bSm20tRB9AzO6v4ydz2ENz7xHrAofmlP5HUk2MFgZE4MkSz9kXfg
         rzeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y51Nz46vqk7FKl0bA40zhWT3Uvjs83z5KYe+jNaFjB4=;
        b=Vao8dSJaFn4GUZGwKU9canJ/b181bgpHADRCFicjYmr07C198k1agid269lMdXJrzy
         vQVJliA360RsT/hEXEz65SSaNIXrxjV6f0eOttGjTZxb6p49TVZGX8kpgRFLAyfBy6Mq
         KtuGGbkKxzQsHpyLFEQYlL3Id+ZyL6WHFIH6Pi+BgCuI1XY3ZomAs9ZBjzh3dfQqVOwR
         KpIiOo/StP5jqmAmzw7/6ULKas6ubBEhVDCNvqlEpD9aanwAl7BuUDtHPJBc62x/oFjk
         4AXlqbHYtCYtb47xpYYz+ugu729Dmhkofq1NOS4I7sLmUszS3qxHdCryIZqXFwQeerKj
         AJ6w==
X-Gm-Message-State: AOAM532IZgrFcOPDSub2zCr8KM2SvstXfcF9tI8tl+l9by5jff4CCKr1
        dqknpcRBK2c1tvTNyJIMmwI=
X-Google-Smtp-Source: ABdhPJxMlBfyQSw8sxpSrQwZC+d/uMfKG1rDpjZgCaj+60RxiHkcGbkiyYR2pczORnBMJgYrrqmJUA==
X-Received: by 2002:a17:906:854b:: with SMTP id h11mr11646527ejy.273.1604409753205;
        Tue, 03 Nov 2020 05:22:33 -0800 (PST)
Received: from [192.168.178.40] ([188.192.138.212])
        by smtp.gmail.com with ESMTPSA id p8sm6091833ejn.5.2020.11.03.05.22.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2020 05:22:32 -0800 (PST)
Subject: Re: [PATCH v3 2/4] scatterlist: add sgl_copy_sgl() function
To:     Douglas Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     martin.petersen@oracle.com, axboe@kernel.dk, bvanassche@acm.org
References: <20201019191928.77845-1-dgilbert@interlog.com>
 <20201019191928.77845-3-dgilbert@interlog.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <b550e74f-3a7c-f6da-5172-fb38c641436e@gmail.com>
Date:   Tue, 3 Nov 2020 14:22:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201019191928.77845-3-dgilbert@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Am 19.10.20 um 21:19 schrieb Douglas Gilbert:
> Both the SCSI and NVMe subsystems receive user data from the block
> layer in scatterlist_s (aka scatter gather lists (sgl) which are
> often arrays). If drivers in those subsystems represent storage
> (e.g. a ramdisk) or cache "hot" user data then they may also
> choose to use scatterlist_s. Currently there are no sgl to sgl
> operations in the kernel. Start with a sgl to sgl copy. Stops
> when the first of the number of requested bytes to copy, or the
> source sgl, or the destination sgl is exhausted. So the
> destination sgl will _not_ grow.
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>   include/linux/scatterlist.h |  4 ++
>   lib/scatterlist.c           | 75 +++++++++++++++++++++++++++++++++++++
>   2 files changed, 79 insertions(+)
> 
> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> index 80178afc2a4a..6649414c0749 100644
> --- a/include/linux/scatterlist.h
> +++ b/include/linux/scatterlist.h
> @@ -321,6 +321,10 @@ size_t sg_pcopy_to_buffer(struct scatterlist *sgl, unsigned int nents,
>   size_t sg_zero_buffer(struct scatterlist *sgl, unsigned int nents,
>   		       size_t buflen, off_t skip);
>   
> +size_t sgl_copy_sgl(struct scatterlist *d_sgl, unsigned int d_nents, off_t d_skip,
> +		    struct scatterlist *s_sgl, unsigned int s_nents, off_t s_skip,
> +		    size_t n_bytes);
> +
>   /*
>    * Maximum number of entries that will be allocated in one piece, if
>    * a list larger than this is required then chaining will be utilized.
> diff --git a/lib/scatterlist.c b/lib/scatterlist.c
> index d5770e7f1030..1f9e093ad7da 100644
> --- a/lib/scatterlist.c
> +++ b/lib/scatterlist.c
> @@ -974,3 +974,78 @@ size_t sg_zero_buffer(struct scatterlist *sgl, unsigned int nents,
>   	return offset;
>   }
>   EXPORT_SYMBOL(sg_zero_buffer);
> +
> +/**
> + * sgl_copy_sgl - Copy over a destination sgl from a source sgl
> + * @d_sgl:		 Destination sgl
> + * @d_nents:		 Number of SG entries in destination sgl
> + * @d_skip:		 Number of bytes to skip in destination before starting
> + * @s_sgl:		 Source sgl
> + * @s_nents:		 Number of SG entries in source sgl
> + * @s_skip:		 Number of bytes to skip in source before starting
> + * @n_bytes:		 The (maximum) number of bytes to copy
> + *
> + * Returns:
> + *   The number of copied bytes.
> + *
> + * Notes:
> + *   Destination arguments appear before the source arguments, as with memcpy().
> + *
> + *   Stops copying if either d_sgl, s_sgl or n_bytes is exhausted.
> + *
> + *   Since memcpy() is used, overlapping copies (where d_sgl and s_sgl belong
> + *   to the same sgl and the copy regions overlap) are not supported.
> + *
> + *   Large copies are broken into copy segments whose sizes may vary. Those
> + *   copy segment sizes are chosen by the min3() statement in the code below.
> + *   Since SG_MITER_ATOMIC is used for both sides, each copy segment is started
> + *   with kmap_atomic() [in sg_miter_next()] and completed with kunmap_atomic()
> + *   [in sg_miter_stop()]. This means pre-emption is inhibited for relatively
> + *   short periods even in very large copies.
> + *
> + *   If d_skip is large, potentially spanning multiple d_nents then some
> + *   integer arithmetic to adjust d_sgl may improve performance. For example
> + *   if d_sgl is built using sgl_alloc_order(chainable=false) then the sgl
> + *   will be an array with equally sized segments facilitating that
> + *   arithmetic. The suggestion applies to s_skip, s_sgl and s_nents as well.
> + *
> + **/
> +size_t sgl_copy_sgl(struct scatterlist *d_sgl, unsigned int d_nents, off_t d_skip,
> +		    struct scatterlist *s_sgl, unsigned int s_nents, off_t s_skip,
> +		    size_t n_bytes)
> +{
> +	size_t len;
> +	size_t offset = 0;
> +	struct sg_mapping_iter d_iter, s_iter;
> +
> +	if (n_bytes == 0)
> +		return 0;
> +	sg_miter_start(&s_iter, s_sgl, s_nents, SG_MITER_ATOMIC | SG_MITER_FROM_SG);
> +	sg_miter_start(&d_iter, d_sgl, d_nents, SG_MITER_ATOMIC | SG_MITER_TO_SG);
> +	if (!sg_miter_skip(&s_iter, s_skip))
> +		goto fini;
> +	if (!sg_miter_skip(&d_iter, d_skip))
> +		goto fini;
> +
> +	while (offset < n_bytes) {
> +		if (!sg_miter_next(&s_iter))
> +			break;
> +		if (!sg_miter_next(&d_iter))
> +			break;
> +		len = min3(d_iter.length, s_iter.length, n_bytes - offset);
> +
> +		memcpy(d_iter.addr, s_iter.addr, len);
> +		offset += len;
> +		/* LIFO order (stop d_iter before s_iter) needed with SG_MITER_ATOMIC */
> +		d_iter.consumed = len;
> +		sg_miter_stop(&d_iter);
> +		s_iter.consumed = len;
> +		sg_miter_stop(&s_iter);
> +	}
> +fini:
> +	sg_miter_stop(&d_iter);
> +	sg_miter_stop(&s_iter);
> +	return offset;
> +}
> +EXPORT_SYMBOL(sgl_copy_sgl);
> +
> 

Reviewed-by: Bodo Stroesser <bostroesser@gmail.com
