Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38FE1EB64DC
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jun 2023 20:46:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbjF1Uqj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jun 2023 16:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjF1Uqh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2023 16:46:37 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B0D1FF1
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2023 13:46:36 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-666eb03457cso162373b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2023 13:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1687985196; x=1690577196;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kBhJKyD7bJwEozlu6VGmqEJtVOOTdpq3aGqlzavxyb4=;
        b=QWE+loXzU3wKDS8ejmYVrM1fvW7AcQBsWfrRd9M6KnNwMAdJCD0nJim15NjpalqeuR
         5OK2peY57vRnKl4CjQaw5y7uXU6wWWHy4eQazHd839z585RfywUalJZLfWqcVdvb9ITi
         cHBZuj6woWszwebYdkvbTjAjhSOkwRZJ/ItrU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687985196; x=1690577196;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kBhJKyD7bJwEozlu6VGmqEJtVOOTdpq3aGqlzavxyb4=;
        b=fZpT8IGWr18lMckFmwO1TcF3D100Xo6mwt4uF0L/46mqZmiDkjIYZQZ1x45sCZd8tG
         61mpUT/z1C9kTJlB5r+ddtfWTvpPzrFEROBUmlKrdjMGwmTLG+J+K8xyg4ACf5w4ezOd
         maOmm6o7ExBCsFvICkoyyg0H9NvGR1OdVzKcUK6gI9VW7WiFRzLi+O9BGadl9JPzJaTK
         twe81PN5gfc/zzqcMydHlvHAHrofpUTeWySk/YzizgtGgM7QqJoKfAoXFZip9BE7Fyj0
         SpY13ARWE4+GGGTr6OcwLzoVjzxbFmYV2n6gR+XOEN+qTcbIKk5Fz2G9Hvh1I1u/JLws
         R2xg==
X-Gm-Message-State: AC+VfDwmVLk+yEa724yLZ4/WlYzDcg8nfGadN9EEibiYc02dS9q3lJYo
        +2MU50NaNQVBTyz1HdV6qXa89w==
X-Google-Smtp-Source: ACHHUZ4+7odXJ0w41n+UICBA7a8VNpdAePajhftdeAf+kTzdbAyBRr6TACllyBIVPquapYHBKFcJAA==
X-Received: by 2002:a05:6a00:a29:b0:674:1dde:4c59 with SMTP id p41-20020a056a000a2900b006741dde4c59mr10827321pfh.28.1687985195409;
        Wed, 28 Jun 2023 13:46:35 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id m18-20020aa79012000000b0064d47cd117esm7388086pfo.39.2023.06.28.13.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jun 2023 13:46:34 -0700 (PDT)
Date:   Wed, 28 Jun 2023 13:46:34 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     aacraid@microsemi.com, "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 09/10][next] scsi: aacraid: Replace one-element array
 with flexible-array member in struct sgmap64
Message-ID: <202306281344.FA95C5E@keescook>
References: <cover.1687974498.git.gustavoars@kernel.org>
 <169a28c9e45d1f237308b1ca716122c5d0ee3488.1687974498.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169a28c9e45d1f237308b1ca716122c5d0ee3488.1687974498.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 28, 2023 at 11:57:30AM -0600, Gustavo A. R. Silva wrote:
> Replace one-element array with flexible-array member in struct
> sgmap64 and refactor the rest of the code, accordingly.
> 
> Issue found with the help of Coccinelle and audited and fixed,
> manually.

Like with the sgmap patch, I see (expected) binary differences in
aac_write_block64() and aac_read_block64() due to the simplified
calculations. I don't see anything unaccounted for, so:

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> Link: https://github.com/KSPP/linux/issues/79
> Link: https://github.com/ClangBuiltLinux/linux/issues/1851
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  drivers/scsi/aacraid/aachba.c  | 9 +++------
>  drivers/scsi/aacraid/aacraid.h | 2 +-
>  2 files changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
> index b2849e5cc104..90df697e7c5f 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -1301,8 +1301,7 @@ static int aac_read_block64(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u
>  	if (ret < 0)
>  		return ret;
>  	fibsize = sizeof(struct aac_read64) +
> -		((le32_to_cpu(readcmd->sg.count) - 1) *
> -		 sizeof (struct sgentry64));
> +		  le32_to_cpu(readcmd->sg.count) * sizeof(struct sgentry64);
>  	BUG_ON (fibsize > (fib->dev->max_fib_size -
>  				sizeof(struct aac_fibhdr)));
>  	/*
> @@ -1433,8 +1432,7 @@ static int aac_write_block64(struct fib * fib, struct scsi_cmnd * cmd, u64 lba,
>  	if (ret < 0)
>  		return ret;
>  	fibsize = sizeof(struct aac_write64) +
> -		((le32_to_cpu(writecmd->sg.count) - 1) *
> -		 sizeof (struct sgentry64));
> +		  le32_to_cpu(writecmd->sg.count) * sizeof(struct sgentry64);
>  	BUG_ON (fibsize > (fib->dev->max_fib_size -
>  				sizeof(struct aac_fibhdr)));
>  	/*
> @@ -2271,8 +2269,7 @@ int aac_get_adapter_info(struct aac_dev* dev)
>  			dev->scsi_host_ptr->sg_tablesize =
>  				(dev->max_fib_size -
>  				sizeof(struct aac_fibhdr) -
> -				sizeof(struct aac_write64) +
> -				sizeof(struct sgentry64)) /
> +				sizeof(struct aac_write64)) /
>  					sizeof(struct sgentry64);
>  		} else {
>  			dev->a_ops.adapter_read = aac_read_block;
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
> index 3fbc22ae72b6..fb3d93e4a99e 100644
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -517,7 +517,7 @@ struct user_sgmap {
>  
>  struct sgmap64 {
>  	__le32		count;
> -	struct sgentry64 sg[1];
> +	struct sgentry64 sg[];
>  };
>  
>  struct user_sgmap64 {
> -- 
> 2.34.1
> 

-- 
Kees Cook
