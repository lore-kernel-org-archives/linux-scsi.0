Return-Path: <SRS0=0yur=EJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 614A6C2D0A3
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 13:26:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E52612071E
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 13:26:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M01aSdHa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729194AbgKCN0O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Nov 2020 08:26:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729078AbgKCN0O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2020 08:26:14 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690F2C0613D1;
        Tue,  3 Nov 2020 05:26:13 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id o21so17044904ejb.3;
        Tue, 03 Nov 2020 05:26:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f0+DRriB73LaqMS9m95RE0aSDPuDzXjs8Hubn7teHoM=;
        b=M01aSdHaCvWFw/UYK9iqni5S9uAT+RyUDu8OO3sxHk98JBUBZRIGKnexd/PQQ7aYVj
         3nVVi/OEcbdVe6/aPzhowJXV0R9QCdloH0/KGmngpGEN99uvruEmzkJXnhEamQoEJi5h
         EG8ZlToLrdywDWkkeX0cii0qtxuDOrp/TFJtIiG3LUc/uxDdDKQVfy/zrM5YPzWvlbNy
         tT6nKcdazt8+gX13ktkM0CEyduUKoNj3OfslpqKgv7nIcJ0V5jiF5Tr1fLNOaODBR1Bz
         Qp4vAuZVbWxheQKWdRESKTsXqfPcDMfl7vHF4PJEDlTqNtHI8BgI8cqiV8yzPUGQi0hT
         qAgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f0+DRriB73LaqMS9m95RE0aSDPuDzXjs8Hubn7teHoM=;
        b=HOO+7jlyrVhc7BgR8NnleZ96Lq66z6AybT9UPhzqAfxv0FgJNFSz8FZp2dcStbF18N
         IBFQG/B9IxaT4aL2y3V3d77Lu337pxetlii6OsG2cEFC0xHkrx4TvR/YZUBsXTMmLWj+
         n0YdaQT98xcmKPLmgWzN9vNED3ceV+IHd08miIbqrnVPEd843egZ7RoE0iQiikHICxh2
         sVMzj3XafYnWZBPY3KOQv48/fZ+qm0GdVsALWIv9WW8hF9RKI0qEOeCLjRFVm7vGQ9Jw
         liGZvzd8WwGIbmFaEkbdBAsnCOuV1lixwJwsAGixapJzUjm+zRtIIT41cMpUO7AI/wZh
         dlEA==
X-Gm-Message-State: AOAM530q3ghwWUOLSXNn7B/z9BMZhGivlb+WnQmA589o7JZcXiH0OsSW
        aJ6z0soqeP+tRLI3fJVyPXGbcwdUAKgiDQ==
X-Google-Smtp-Source: ABdhPJzknTBMojDKPVTk6sdSQ8MMUhw3P4g1CYkhGEzIda+oODCXFMRX4e4zV2xMTHobFOLEhRaygg==
X-Received: by 2002:a17:906:ccc5:: with SMTP id ot5mr6978461ejb.248.1604409972040;
        Tue, 03 Nov 2020 05:26:12 -0800 (PST)
Received: from [192.168.178.40] (ipbcc08ad4.dynamic.kabel-deutschland.de. [188.192.138.212])
        by smtp.gmail.com with ESMTPSA id q2sm10882070ejd.20.2020.11.03.05.26.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2020 05:26:11 -0800 (PST)
Subject: Re: [PATCH v3 2/4] scatterlist: add sgl_copy_sgl() function
To:     Douglas Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     martin.petersen@oracle.com, axboe@kernel.dk, bvanassche@acm.org
References: <20201019191928.77845-1-dgilbert@interlog.com>
 <20201019191928.77845-3-dgilbert@interlog.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <1a7b2ffc-b289-f650-576f-fac832fa0489@gmail.com>
Date:   Tue, 3 Nov 2020 14:26:10 +0100
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

Second try, this time with correct tag.

Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>
