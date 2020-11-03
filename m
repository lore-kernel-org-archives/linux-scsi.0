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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF739C2D0A3
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 13:24:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EEDD21534
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 13:24:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gcd6DAtG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729228AbgKCNYQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Nov 2020 08:24:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729009AbgKCNYQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2020 08:24:16 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A46C0613D1;
        Tue,  3 Nov 2020 05:24:15 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id k3so24018540ejj.10;
        Tue, 03 Nov 2020 05:24:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zIqARhBc6bc7Ly6ChXcT3ZIFjxtRLSsac7PuzHZQP0Y=;
        b=Gcd6DAtGObepFK+FZ2m9rJQYfnKR6ixwCKExjl5P90L1bPC99KbJ6dEKh5fZtVZ453
         1Y0z7v3VGodY0vrM7tZX/wvXP93NWxhqDis0/Dc+CbQf3n4Vseul+eeIEg2pl1YPH/GK
         GFrjiH7tlyd8685w/C2nohtDGjjW8r7Ui+0WJF1VXbiD1ZNHJrfyb+J/YsU2cGIz0JAo
         tpqtDj5dVc/5eyQJMs9SpPLo61gNYhVTicWy0rcgivDH/+USzh6mMhBnFzGcCiZubAZd
         fIuhKXAntU1jXWNWADSE357scsnv72OoP6RfKyuobcHau1js+36xD93kMbsD+X+n7sOl
         JWOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zIqARhBc6bc7Ly6ChXcT3ZIFjxtRLSsac7PuzHZQP0Y=;
        b=nevi8uEa1k/c7a635xAllRmJn57PCkvmy0EBqWqxUlwZI9wM5jI8Wjq9jsLdsvJpDh
         fc6r0VXBm1B5snEg87MP6XL0gqYnwC0ZjXG5SYfzdVUay+8WxQLx71HPEvynP2//7uTc
         4hmoseaBX36DK92F+6bjOJzTKnhJFuRvkNqHT2uM0YIsMMWT83GetUK1qGNef/Ruug8G
         26AZYU/LQGsgO6ehYJxE0lPgE9QhS6QsfwBkVck5+2gP4L+yMmV0ArMcGgvOuptYu1ao
         cQ6yqlDO630CT7KPBr+o+PJxGD1sSvSX/Mt8e4U5B5XtamhLtG7BMZsSUuXSOMomxAsu
         yvzw==
X-Gm-Message-State: AOAM530JLhwI9fGkOa+vppHKVammd/PTrPsmeqaR10AhjsOcBn0ofBOV
        sU8uDyx7NeRlF/Y8B4feBWhs6BeB8olVKw==
X-Google-Smtp-Source: ABdhPJxnYOjAbPXgo9WaHFqpbQOtjn1W5HqXrghUcQ5TDy2AbIivU6t5Hm/VU3pIXW+DE7PW1uwTwg==
X-Received: by 2002:a17:906:8608:: with SMTP id o8mr2238741ejx.36.1604409854438;
        Tue, 03 Nov 2020 05:24:14 -0800 (PST)
Received: from [192.168.178.40] ([188.192.138.212])
        by smtp.gmail.com with ESMTPSA id og19sm10213946ejb.7.2020.11.03.05.24.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2020 05:24:14 -0800 (PST)
Subject: Re: [PATCH v3 3/4] scatterlist: add sgl_compare_sgl() function
To:     Douglas Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     martin.petersen@oracle.com, axboe@kernel.dk, bvanassche@acm.org
References: <20201019191928.77845-1-dgilbert@interlog.com>
 <20201019191928.77845-4-dgilbert@interlog.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <8868dc96-52fd-5158-0da0-bbc4a0bc682b@gmail.com>
Date:   Tue, 3 Nov 2020 14:24:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201019191928.77845-4-dgilbert@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Am 19.10.20 um 21:19 schrieb Douglas Gilbert:
> After enabling copies between scatter gather lists (sgl_s),
> another storage related operation is to compare two sgl_s.
> This new function is modelled on NVMe's Compare command and
> the SCSI VERIFY(BYTCHK=1) command. Like memcmp() this function
> returns false on the first miscompare and stops comparing.
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>   include/linux/scatterlist.h |  4 +++
>   lib/scatterlist.c           | 61 +++++++++++++++++++++++++++++++++++++
>   2 files changed, 65 insertions(+)
> 
> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> index 6649414c0749..ae260dc5fedb 100644
> --- a/include/linux/scatterlist.h
> +++ b/include/linux/scatterlist.h
> @@ -325,6 +325,10 @@ size_t sgl_copy_sgl(struct scatterlist *d_sgl, unsigned int d_nents, off_t d_ski
>   		    struct scatterlist *s_sgl, unsigned int s_nents, off_t s_skip,
>   		    size_t n_bytes);
>   
> +bool sgl_compare_sgl(struct scatterlist *x_sgl, unsigned int x_nents, off_t x_skip,
> +		     struct scatterlist *y_sgl, unsigned int y_nents, off_t y_skip,
> +		     size_t n_bytes);
> +
>   /*
>    * Maximum number of entries that will be allocated in one piece, if
>    * a list larger than this is required then chaining will be utilized.
> diff --git a/lib/scatterlist.c b/lib/scatterlist.c
> index 1f9e093ad7da..49185536acba 100644
> --- a/lib/scatterlist.c
> +++ b/lib/scatterlist.c
> @@ -1049,3 +1049,64 @@ size_t sgl_copy_sgl(struct scatterlist *d_sgl, unsigned int d_nents, off_t d_ski
>   }
>   EXPORT_SYMBOL(sgl_copy_sgl);
>   
> +/**
> + * sgl_compare_sgl - Compare x and y (both sgl_s)
> + * @x_sgl:		 x (left) sgl
> + * @x_nents:		 Number of SG entries in x (left) sgl
> + * @x_skip:		 Number of bytes to skip in x (left) before starting
> + * @y_sgl:		 y (right) sgl
> + * @y_nents:		 Number of SG entries in y (right) sgl
> + * @y_skip:		 Number of bytes to skip in y (right) before starting
> + * @n_bytes:		 The (maximum) number of bytes to compare
> + *
> + * Returns:
> + *   true if x and y compare equal before x, y or n_bytes is exhausted.
> + *   Otherwise on a miscompare, returns false (and stops comparing).
> + *
> + * Notes:
> + *   x and y are symmetrical: they can be swapped and the result is the same.
> + *
> + *   Implementation is based on memcmp(). x and y segments may overlap.
> + *
> + *   The notes in sgl_copy_sgl() about large sgl_s _applies here as well.
> + *
> + **/
> +bool sgl_compare_sgl(struct scatterlist *x_sgl, unsigned int x_nents, off_t x_skip,
> +		     struct scatterlist *y_sgl, unsigned int y_nents, off_t y_skip,
> +		     size_t n_bytes)
> +{
> +	bool equ = true;
> +	size_t len;
> +	size_t offset = 0;
> +	struct sg_mapping_iter x_iter, y_iter;
> +
> +	if (n_bytes == 0)
> +		return true;
> +	sg_miter_start(&x_iter, x_sgl, x_nents, SG_MITER_ATOMIC | SG_MITER_FROM_SG);
> +	sg_miter_start(&y_iter, y_sgl, y_nents, SG_MITER_ATOMIC | SG_MITER_FROM_SG);
> +	if (!sg_miter_skip(&x_iter, x_skip))
> +		goto fini;
> +	if (!sg_miter_skip(&y_iter, y_skip))
> +		goto fini;
> +
> +	while (equ && offset < n_bytes) {
> +		if (!sg_miter_next(&x_iter))
> +			break;
> +		if (!sg_miter_next(&y_iter))
> +			break;
> +		len = min3(x_iter.length, y_iter.length, n_bytes - offset);
> +
> +		equ = !memcmp(x_iter.addr, y_iter.addr, len);
> +		offset += len;
> +		/* LIFO order is important when SG_MITER_ATOMIC is used */
> +		y_iter.consumed = len;
> +		sg_miter_stop(&y_iter);
> +		x_iter.consumed = len;
> +		sg_miter_stop(&x_iter);
> +	}
> +fini:
> +	sg_miter_stop(&y_iter);
> +	sg_miter_stop(&x_iter);
> +	return equ;
> +}
> +EXPORT_SYMBOL(sgl_compare_sgl);
> 

Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>
