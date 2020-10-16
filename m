Return-Path: <SRS0=iJzJ=DX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0611AC433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Oct 2020 11:17:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9606B20EDD
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Oct 2020 11:17:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qvCCNdi2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405702AbgJPLRp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Oct 2020 07:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405579AbgJPLRo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Oct 2020 07:17:44 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D66C061755;
        Fri, 16 Oct 2020 04:17:43 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id dg9so1858977edb.12;
        Fri, 16 Oct 2020 04:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZVAWWnJuB1h6iJ/WR3j/fBMynn7pxRiYmVRSmaXSQjk=;
        b=qvCCNdi2wqM9ebEMjd6Rj7W2rwGZBCINZbBnU3h9Xc8SHckjn4oJvIbOrAVf55g2uN
         imKxwGlWj6EnVFxsshqOnlExVfFDQRqC5WOZkMbxEHRe8sY4/8Xiaz0cCi5trdwZPaUh
         YBGje9zECTNsXVY3PnxBKyKka3ur33CIoK+DMDAOu1Gf+T/ss4BXTteYQfTRAVoZg0B2
         E6o0hYO75Xe5uKfcUWCLy7wYClCm8A58jZB1t7iisqsvnl6/0XFwCouSYD7jJMtEObej
         3+NFTu4bWXH08bjDxqkACnOeNdsQlgr5bQ7Zpw/y0qce+2WHcEIzq1oYRq5VbA2jwU5H
         ClVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZVAWWnJuB1h6iJ/WR3j/fBMynn7pxRiYmVRSmaXSQjk=;
        b=eD1Cn6TlDQiG5AaJt9rJnf1t6NBSeHuJXD8NfHuEDn2nSRmHOiojR72ftug/pIGvBC
         ccolIp1XN1D0TE6o55k5kT7hJNXf2QhYVEN863DKsAKavnWaV3hiH56aJ3phUnYoJJRR
         VjDA+VFsjUXp6OPoDsBidYe1Gm/3hN1uHYAShxzu/logkNnhzBeJLAXugt5m6tCFCL3X
         d2KgR5iRC1/Y1Yd8SZ+xD1iJRF1fbzen4hBR0Vsvr0FThnMFzSoqvempQ790qN4+jTJ/
         lYfO1+x4hO9qMiUZCwmj6BrP30EEAfjFoKdkedXaf+kTuu0QixCEsU8nk/UoatCDosDf
         FrNA==
X-Gm-Message-State: AOAM532fP6XdK9SqB9XCGpN8tys9xgVxqgJoQAnSSW/LD2jdxjoqVCYv
        Lv2ptYU0drcDBzAWllQu2teFvorT3tCoWg==
X-Google-Smtp-Source: ABdhPJzx38B2WduBHZJ0ABz/TJnez3futcfvRkQvvfPtBOf89WGsQXx+OvMTTMpmP3PWCDEjm0xxHw==
X-Received: by 2002:a05:6402:22d9:: with SMTP id dm25mr3159053edb.182.1602847061801;
        Fri, 16 Oct 2020 04:17:41 -0700 (PDT)
Received: from [192.168.178.40] (ipbcc08ad4.dynamic.kabel-deutschland.de. [188.192.138.212])
        by smtp.gmail.com with ESMTPSA id a19sm1200024edb.84.2020.10.16.04.17.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2020 04:17:41 -0700 (PDT)
Subject: Re: [PATCH 2/4] scatterlist: add sgl_copy_sgl() function
To:     Douglas Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     martin.petersen@oracle.com, axboe@kernel.dk, bvanassche@acm.org
References: <20201016045258.16246-1-dgilbert@interlog.com>
 <20201016045258.16246-3-dgilbert@interlog.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <e04e9a03-1bbc-54ad-659f-7ad176d81019@gmail.com>
Date:   Fri, 16 Oct 2020 13:17:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201016045258.16246-3-dgilbert@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Douglas,

AFAICS this patch - and also patch 3 - are not correct.
When started with SG_MITER_ATOMIC, sg_miter_next and sg_miter_stop use
the k(un)map_atomic calls. But these have to be used strictly nested
according to docu and code.
The below code uses the atomic mappings in overlapping mode.

Regards,
Bodo

Am 16.10.20 um 06:52 schrieb Douglas Gilbert:
> Both the SCSI and NVMe subsystems receive user data from the block
> layer in scatterlist_s (aka scatter gather lists (sgl) which are
> often arrays). If drivers in those subsystems represent storage
> (e.g. a ramdisk) or cache "hot" user data then they may also
> choose to use scatterlist_s. Currently there are no sgl to sgl
> operations in the kernel. Start with a copy.
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>   include/linux/scatterlist.h |  4 ++
>   lib/scatterlist.c           | 86 +++++++++++++++++++++++++++++++++++++
>   2 files changed, 90 insertions(+)
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
> index d5770e7f1030..1ec2c909c8d4 100644
> --- a/lib/scatterlist.c
> +++ b/lib/scatterlist.c
> @@ -974,3 +974,89 @@ size_t sg_zero_buffer(struct scatterlist *sgl, unsigned int nents,
>   	return offset;
>   }
>   EXPORT_SYMBOL(sg_zero_buffer);
> +
> +/**
> + * sgl_copy_sgl - Copy over a destination sgl from a source sgl
> + * @d_sgl:		 Destination sgl
> + * @d_nents:		 Number of SG entries in destination sgl
> + * @d_skip:		 Number of bytes to skip in destination before copying
> + * @s_sgl:		 Source sgl
> + * @s_nents:		 Number of SG entries in source sgl
> + * @s_skip:		 Number of bytes to skip in source before copying
> + * @n_bytes:		 The number of bytes to copy
> + *
> + * Returns the number of copied bytes.
> + *
> + * Notes:
> + *   Destination arguments appear before the source arguments, as with memcpy().
> + *
> + *   Stops copying if the end of d_sgl or s_sgl is reached.
> + *
> + *   Since memcpy() is used, overlapping copies (where d_sgl and s_sgl belong
> + *   to the same sgl and the copy regions overlap) are not supported.
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
> +	size_t d_off, s_off, len, d_len, s_len;
> +	size_t offset = 0;
> +	struct sg_mapping_iter d_iter;
> +	struct sg_mapping_iter s_iter;
> +
> +	if (n_bytes == 0)
> +		return 0;
> +	sg_miter_start(&d_iter, d_sgl, d_nents, SG_MITER_ATOMIC | SG_MITER_TO_SG);
> +	sg_miter_start(&s_iter, s_sgl, s_nents, SG_MITER_ATOMIC | SG_MITER_FROM_SG);
> +	if (!sg_miter_skip(&d_iter, d_skip))
> +		goto fini;
> +	if (!sg_miter_skip(&s_iter, s_skip))
> +		goto fini;
> +
> +	for (d_off = 0, s_off = 0; true ; ) {
> +		/* Assume d_iter.length and s_iter.length can never be 0 */
> +		if (d_off == 0) {
> +			if (!sg_miter_next(&d_iter))
> +				break;
> +			d_len = d_iter.length;
> +		} else {
> +			d_len = d_iter.length - d_off;
> +		}
> +		if (s_off == 0) {
> +			if (!sg_miter_next(&s_iter))
> +				break;
> +			s_len = s_iter.length;
> +		} else {
> +			s_len = s_iter.length - s_off;
> +		}
> +		len = min3(d_len, s_len, n_bytes - offset);
> +
> +		memcpy(d_iter.addr + d_off, s_iter.addr + s_off, len);
> +		offset += len;
> +		if (offset >= n_bytes)
> +			break;
> +		if (d_len == s_len) {
> +			d_off = 0;
> +			s_off = 0;
> +		} else if (d_len < s_len) {
> +			d_off = 0;
> +			s_off += len;
> +		} else {
> +			d_off += len;
> +			s_off = 0;
> +		}
> +	}
> +fini:
> +	sg_miter_stop(&d_iter);
> +	sg_miter_stop(&s_iter);
> +	return offset;
> +}
> +EXPORT_SYMBOL(sgl_copy_sgl);
> +
> 
