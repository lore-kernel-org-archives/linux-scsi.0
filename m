Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="mxWuZrxJ"
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE60BD
	for <linux-scsi@vger.kernel.org>; Tue, 12 Dec 2023 13:23:02 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-6cea5548eb2so5477361b3a.0
        for <linux-scsi@vger.kernel.org>; Tue, 12 Dec 2023 13:23:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1702416182; x=1703020982; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wxuP6rH0bpJQdehhJhYTsKOeIoxa8S/XV7TnZO98Xd8=;
        b=mxWuZrxJdj5bxzeN0YMXVqGpbHbz1nYi4FUG1QpdzI4N9XYOcPH5rnNxNxdtm+ZNLp
         kXqAL6axnAXTby/KaAJBMQcsQ1uvrrBoWNQwTwvMrU9F7k51SMf00lMl2+us5tV0Rhyd
         Hl8fW5++UU5chmaZ2SuFlgp+dwjPkj/9od8c8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702416182; x=1703020982;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wxuP6rH0bpJQdehhJhYTsKOeIoxa8S/XV7TnZO98Xd8=;
        b=A4xZFaiDJpFksM0KOYZuODJCybx+3J6tEk1L68M1U4ik/YwuFMGhc8POZy5LGlDhC2
         NVGxH75iPXUQQQRevclc5i8LsNUSppDVf3QDPH/s83zGgYv2mP3sBor202FKDJzu3S97
         Ln824QK1OGG3yyZZMgR0T6fLh/px8imt1QBVTYngZrEYjxXcfV0TcmrQYTa8k1+D1Aof
         Vc4rh3wNaXmsUyRpAghsglZDbUHltT74hxfp51OZKQwcPiQAh8UoJ9gvgJhzP61SHuD3
         tWGoFWyffdibgDc5qbgsR5/iLUzHAeFzVEC9oyuwsO14dpw/JHqB77G3MaQ7UgRVbVad
         EJKg==
X-Gm-Message-State: AOJu0YwIlLmnxs0Kin0TS2bOO2Oc9OYjVFS0lSpU8YnUutfJixMLBH+W
	bUiu6UWPx9oHv5pV+gYYyGaHIQ==
X-Google-Smtp-Source: AGHT+IGIhzGATDu3oBFvEwndykUJEdWlX+8RRQcdHx5e6X9Trh/t8PqWSN3lz74zp+LOsTuYbP5pCA==
X-Received: by 2002:a05:6a00:b53:b0:6ce:6c54:24a7 with SMTP id p19-20020a056a000b5300b006ce6c5424a7mr7792476pfo.1.1702416182255;
        Tue, 12 Dec 2023 13:23:02 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id x20-20020aa793b4000000b006ce4c7ba448sm8592223pff.25.2023.12.12.13.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Dec 2023 13:23:01 -0800 (PST)
Date: Tue, 12 Dec 2023 13:23:01 -0800
From: Kees Cook <keescook@chromium.org>
To: Justin Stitt <justinstitt@google.com>
Cc: Michael Cyr <mikecyr@linux.ibm.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2] scsi: ibmvscsi_tgt: replace deprecated strncpy with
 strscpy
Message-ID: <202312121321.E15E09BF@keescook>
References: <20231212-strncpy-drivers-scsi-ibmvscsi_tgt-ibmvscsi_tgt-c-v2-1-bdb9a7cd96c8@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231212-strncpy-drivers-scsi-ibmvscsi_tgt-ibmvscsi_tgt-c-v2-1-bdb9a7cd96c8@google.com>

On Tue, Dec 12, 2023 at 01:20:20AM +0000, Justin Stitt wrote:
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
> ... which is NUL-padded already, meaning strscpy() is the best option.
> 
> Considering the above, a suitable replacement is `strscpy` [2] due to
> the fact that it guarantees NUL-termination on the destination buffer
> without unnecessarily NUL-padding.
> 
> However, for cap->name and info let's use strscpy_pad as they are
> allocated via dma_alloc_coherent():
> |       cap = dma_alloc_coherent(&vscsi->dma_dev->dev, olen, &token,
> |                                GFP_ATOMIC);
> &
> |       info = dma_alloc_coherent(&vscsi->dma_dev->dev, sizeof(*info), &token,
> |                                 GFP_ATOMIC);
> 
> Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
> Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html [2]
> Link: https://github.com/KSPP/linux/issues/90
> Cc: linux-hardening@vger.kernel.org
> Signed-off-by: Justin Stitt <justinstitt@google.com>

This looks good to me. The only question that I haven't seen an answer
to from the maintainers is whether this is a __nonstring or not. It
really looks like it should be a C String, so with that assumption:

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
