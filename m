Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="kTJ5AfD1"
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF87133
	for <linux-scsi@vger.kernel.org>; Thu, 30 Nov 2023 13:25:34 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1cfc2d03b3aso12905155ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 30 Nov 2023 13:25:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1701379534; x=1701984334; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=a85qT15pDzdpel5gAuB/Pf8iqGvsBNG0rw6z7GTZ+18=;
        b=kTJ5AfD1oyJZ5xgrDlZ1wWqUF4X2MHy59XeBZO1G+MQvTgxp690SglGE2GDstdGNxg
         adSryWlfdXZXmcA+Xq4n6e72AH60lYqYhvQ9M2Yrk0L/l+j5hLVRCooCVPsv2Haepeix
         HcwReOShiQW2KJEaYHs7ojwRUXVahzvGbIRz4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701379534; x=1701984334;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a85qT15pDzdpel5gAuB/Pf8iqGvsBNG0rw6z7GTZ+18=;
        b=nTod1zeCanb+cxz3RlytDD8uHLs6CJJBIZf1xaGr/pdqBRgZOhkVzPwSQlWJUQnHGJ
         2bOMjqoyqmZYPY96zt3amyRP4lHBv6Le6icytS4QsrCe1MPwYhrDJZHQQeD7XzQXG5Ob
         evIvGgPZyJhT9Hz7c4PiApZwi/FICProg5NwZFjDm+fuapxwYGQR7u+IbS8/TuRzci6T
         JkmNYj/jXH9Yr2Jc6TjBDMWw/XtBYht38Y4UKPQbwYmNkw4YuSTxbyaW3NXewb9TtnBY
         caSbbYxVu2xxU0lY+yyFadAfPcw+LrgTnIHPO36TgCVvYsO9RUEYMkL3svjzM0IXMUyu
         XCaQ==
X-Gm-Message-State: AOJu0Yxpgj0QXetAR3RupURA31LcpIS0DAZXzAqU3LRYlhfEyyledz5m
	xvXMwq/yTDPPe8ephnwjzN8k6A==
X-Google-Smtp-Source: AGHT+IGiYA7iwc3ReI+OQGlKYslymufSwvsJah4H2gMq04CzpdkKFgR/kZAc5Za9Ltu7ai3/MUS0Yw==
X-Received: by 2002:a17:902:e88b:b0:1cf:d404:5e7c with SMTP id w11-20020a170902e88b00b001cfd4045e7cmr18459112plg.42.1701379534271;
        Thu, 30 Nov 2023 13:25:34 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id ja17-20020a170902efd100b001cf7c07be50sm1869304plb.58.2023.11.30.13.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 13:25:33 -0800 (PST)
Date: Thu, 30 Nov 2023 13:25:33 -0800
From: Kees Cook <keescook@chromium.org>
To: Justin Stitt <justinstitt@google.com>
Cc: Michael Cyr <mikecyr@linux.ibm.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: ibmvscsi_tgt: replace deprecated strncpy with
 strscpy
Message-ID: <202311301315.BAB096926@keescook>
References: <20231030-strncpy-drivers-scsi-ibmvscsi_tgt-ibmvscsi_tgt-c-v1-1-859b5ce257fd@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231030-strncpy-drivers-scsi-ibmvscsi_tgt-ibmvscsi_tgt-c-v1-1-859b5ce257fd@google.com>

On Mon, Oct 30, 2023 at 09:43:20PM +0000, Justin Stitt wrote:
> strncpy() is deprecated for use on NUL-terminated destination strings
> [1] and as such we should prefer more robust and less ambiguous string
> interfaces.
> 
> We don't need the NUL-padding behavior that strncpy() provides as vscsi
> is NUL-allocated in ibmvscsis_probe() which proceeds to call
> ibmvscsis_adapter_info():
> |       vscsi = kzalloc(sizeof(*vscsi), GFP_KERNEL);
> 
> ibmvscsis_probe() -> ibmvscsis_handle_crq() -> ibmvscsis_parse_command()
> -> ibmvscsis_mad() -> ibmvscsis_process_mad() -> ibmvscsis_adapter_info()
> 
> Following the same idea, `partition_name` is defiend as:
> |       static char partition_name[PARTITION_NAMELEN] = "UNKNOWN";
> 
> ... which is NUL-padded already, meaning strscpy() is the best option.
> 
> Considering the above, a suitable replacement is `strscpy` [2] due to
> the fact that it guarantees NUL-termination on the destination buffer
> without unnecessarily NUL-padding.

My only worry here is that I don't see if %NUL termination is _required_
for these variables. (i.e. do we run the risk of truncating these by 1
byte if they're right at the limit?) Are they __nonstring?

I *think* they're %NUL terminated since they follow the same sizing as
the global "partition_name", but I'm not sure.

Can any of the SCSI authors comment on this?

> 
> However, for cap->name let's use strscpy_pad as cap is allocated via
> dma_alloc_coherent():
> |       cap = dma_alloc_coherent(&vscsi->dma_dev->dev, olen, &token,
> |                                GFP_ATOMIC);

This is also true for the "info" allocation (it comes out of DMA).

> 
> Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
> Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html [2]
> Link: https://github.com/KSPP/linux/issues/90
> Cc: linux-hardening@vger.kernel.org
> Signed-off-by: Justin Stitt <justinstitt@google.com>
> ---
> Note: build-tested only.
> 
> Found with: $ rg "strncpy\("
> ---
>  drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> index 385f812b8793..cd223ef696e5 100644
> --- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> +++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> @@ -1551,17 +1551,17 @@ static long ibmvscsis_adapter_info(struct scsi_info *vscsi,
>  	if (vscsi->client_data.partition_number == 0)
>  		vscsi->client_data.partition_number =
>  			be32_to_cpu(info->partition_number);
> -	strncpy(vscsi->client_data.srp_version, info->srp_version,
> +	strscpy(vscsi->client_data.srp_version, info->srp_version,
>  		sizeof(vscsi->client_data.srp_version));
> -	strncpy(vscsi->client_data.partition_name, info->partition_name,
> +	strscpy(vscsi->client_data.partition_name, info->partition_name,
>  		sizeof(vscsi->client_data.partition_name));
>  	vscsi->client_data.mad_version = be32_to_cpu(info->mad_version);
>  	vscsi->client_data.os_type = be32_to_cpu(info->os_type);
>  
>  	/* Copy our info */
> -	strncpy(info->srp_version, SRP_VERSION,
> +	strscpy(info->srp_version, SRP_VERSION,
>  		sizeof(info->srp_version));
> -	strncpy(info->partition_name, vscsi->dds.partition_name,
> +	strscpy(info->partition_name, vscsi->dds.partition_name,
>  		sizeof(info->partition_name));

Since "info" is from DMA, let's use the _pad variant here just to be
safe.

>  	info->partition_number = cpu_to_be32(vscsi->dds.partition_num);
>  	info->mad_version = cpu_to_be32(MAD_VERSION_1);
> @@ -1645,8 +1645,8 @@ static int ibmvscsis_cap_mad(struct scsi_info *vscsi, struct iu_entry *iue)
>  			 be64_to_cpu(mad->buffer),
>  			 vscsi->dds.window[LOCAL].liobn, token);
>  	if (rc == H_SUCCESS) {
> -		strncpy(cap->name, dev_name(&vscsi->dma_dev->dev),
> -			SRP_MAX_LOC_LEN);
> +		strscpy_pad(cap->name, dev_name(&vscsi->dma_dev->dev),
> +			sizeof(cap->name));

And this is a safe conversion to sizeof():

struct capabilities {
	...
        char name[SRP_MAX_LOC_LEN];


If we can convince ourselves that non of these are __nonstring types,
then I think with the "info" change above, this should be good.

-Kees

-- 
Kees Cook
