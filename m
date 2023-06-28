Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D7DAEB64D7
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jun 2023 20:49:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbjF1Utu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jun 2023 16:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjF1Uts (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2023 16:49:48 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EDE1130
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2023 13:49:47 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-6726d5d92afso972288b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2023 13:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1687985386; x=1690577386;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vr1uGKS8yimH0wL2pnkRpehoKj4yux612ywDNz5FjuI=;
        b=Is1rd5GHrGje7AW8Oo1Nyjoj3Yo6Wc9d1X+rAR807gekf0gMd9Qi4avwq3f/BM67HQ
         2MkR1jWYEB6CQxhh8QKpp1JVnOiJdaV7IkzI2yNNgMjSogPeIUOgsEPJnkDzFtGhZBK2
         8B6veo651uzIlQZUHs/8zT0lqVLoz6qRXMC4s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687985386; x=1690577386;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vr1uGKS8yimH0wL2pnkRpehoKj4yux612ywDNz5FjuI=;
        b=l+In17/4+S9p25rByLT5N5rby7pinZlsEvT0r2u3CuSbBeZMrnWwHCzeMi1GaZIY/D
         sed/7kL0XB5vQs7pj0urRSbFVChE+uErF+441IxlKR2nsCWWnOs6R2JWMss/C0Ew2NG0
         qLbNZ2G4R33fXQONauj34mYRedK1E77u8bv+sEzhVA/p+bNBgHSH0DmAR1+v1JK6bs1i
         R7Z1xi0l+qbmcH3icgjdfN8FVs0i5FiP7os4HmJlXRUJ//aDth0GTsv8uROxbDNoZ0Ln
         hai6QOcQr2IuryQFv8S1DBqQ2vhRKUwEOCxnwnFK98Z1josPt58WNGuZPbhzcbXj6sq8
         uEUg==
X-Gm-Message-State: AC+VfDyKxON5/SgxldqqDNghHGi2ehMLfYyMGXBSAPgC/Fu0jikrkRJO
        C7t8WJh+c490w4z42TajNSp5a/q37H65n0Y+Ocg=
X-Google-Smtp-Source: ACHHUZ6wMbb5D8+wuxsmeAWX9doMe9pb0ZXFdgDEFDvZ8PnK8g/Z/X9SwXLqHJQaUTSbJSnCSlbu2Q==
X-Received: by 2002:a17:90a:c906:b0:263:7d8:4a with SMTP id v6-20020a17090ac90600b0026307d8004amr3121008pjt.18.1687985386686;
        Wed, 28 Jun 2023 13:49:46 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id v29-20020a63481d000000b00553d27ab0e0sm7642080pga.69.2023.06.28.13.49.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jun 2023 13:49:46 -0700 (PDT)
Date:   Wed, 28 Jun 2023 13:49:45 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     aacraid@microsemi.com, "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 05/10][next] scsi: aacraid: Replace one-element array
 with flexible-array member in struct sgmapraw
Message-ID: <202306281348.5571090DAD@keescook>
References: <cover.1687974498.git.gustavoars@kernel.org>
 <9dfcdf55597a49ed7e19ba064f5be424b344e175.1687974498.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9dfcdf55597a49ed7e19ba064f5be424b344e175.1687974498.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 28, 2023 at 11:56:12AM -0600, Gustavo A. R. Silva wrote:
> Replace one-element array with flexible-array member in struct
> sgmapraw.
> 
> Issue found with the help of Coccinelle and audited and fixed,
> manually.

As with the other two, I see expected binary changes in
aac_read_raw_io() and aac_write_raw_io() due to the simplified count
calculations.

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> 
> Link: https://github.com/KSPP/linux/issues/79
> Link: https://github.com/ClangBuiltLinux/linux/issues/1851
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  drivers/scsi/aacraid/aachba.c  | 4 ++--
>  drivers/scsi/aacraid/aacraid.h | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
> index fff0550e02e4..b3c0c2255e55 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -1267,7 +1267,7 @@ static int aac_read_raw_io(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u3
>  			return ret;
>  		command = ContainerRawIo;
>  		fibsize = sizeof(struct aac_raw_io) +
> -			((le32_to_cpu(readcmd->sg.count)-1) * sizeof(struct sgentryraw));
> +			  le32_to_cpu(readcmd->sg.count) * sizeof(struct sgentryraw);
>  	}
>  
>  	BUG_ON(fibsize > (fib->dev->max_fib_size - sizeof(struct aac_fibhdr)));
> @@ -1401,7 +1401,7 @@ static int aac_write_raw_io(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u
>  			return ret;
>  		command = ContainerRawIo;
>  		fibsize = sizeof(struct aac_raw_io) +
> -			((le32_to_cpu(writecmd->sg.count)-1) * sizeof (struct sgentryraw));
> +			  le32_to_cpu(writecmd->sg.count) * sizeof(struct sgentryraw);
>  	}
>  
>  	BUG_ON(fibsize > (fib->dev->max_fib_size - sizeof(struct aac_fibhdr)));
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
> index d1fc1ce2e36d..87015dd2abd9 100644
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -527,7 +527,7 @@ struct user_sgmap64 {
>  
>  struct sgmapraw {
>  	__le32		  count;
> -	struct sgentryraw sg[1];
> +	struct sgentryraw sg[];
>  };
>  
>  struct user_sgmapraw {
> -- 
> 2.34.1
> 

-- 
Kees Cook
