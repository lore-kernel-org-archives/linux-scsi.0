Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="DDVdCf9N"
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8306FC4
	for <linux-scsi@vger.kernel.org>; Thu, 30 Nov 2023 13:13:34 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id 98e67ed59e1d1-2856254bd74so1265210a91.2
        for <linux-scsi@vger.kernel.org>; Thu, 30 Nov 2023 13:13:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1701378814; x=1701983614; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fidcjtTW722GJ2IM4Au/VykloMhm7RTaqk1o/atYAEw=;
        b=DDVdCf9NdUIkcLpOb1uCiufbtpeh1yATfi7M2x5fsKQ3TpKUMymd9+UK7MZsvW2PMt
         SmbZiB2YwKmbYSMt4ybSAE6aCvTj6SaK2/P1iFmPc4BdvZVajNqUqK8AD+UjsaJdRMt8
         j1s2GuYw2ebHozsoahOJfdRiG7VgPikxAZ/4Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701378814; x=1701983614;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fidcjtTW722GJ2IM4Au/VykloMhm7RTaqk1o/atYAEw=;
        b=LaJZTBwiHBrOyOcISDqMThSxUiXvEWAMkg/Q1+EA+tMa8YfKsndBMUl5etSYOAmF76
         3JUz6yWT6pM9DMEywrz8sKtQ7tGcnmKFq4/l8k788flH4sIly5AwGuW1vNEQQ+XGZsXR
         dAkAWtOBBJH24PQJbYrLf85Jah8vvVxH8GFSI4/XyGaLWj8Fnh71HC/0m0Wy24+uibdU
         fBaSdug81V5S16TpGyreCmR9Ouvs41CzQnp/lTWukLqLeoobMSyZhunDdqfJhV/qR1AX
         ki25BLBzlkc7Gl9GTY2mOFN3tmfAanbvPiuVcY88uuokv2eHFCmU3nPpSGAIaX7/Qn0g
         A4lg==
X-Gm-Message-State: AOJu0YwQ8nemRFMESFlHxvBWCq1GTMpU1NFcNsBMtGE5u30f9WFJ/EqB
	FO5M8ZRgL1tPlVJU+FQzhmThjg==
X-Google-Smtp-Source: AGHT+IEKJ/wr7SUlbtYwADUSjvGI7oq2tySAREjzqV7MWT2FI9gP4yoKXMynlqfV5uTQNeEytkLvBg==
X-Received: by 2002:a17:90b:4acf:b0:285:a160:df1b with SMTP id mh15-20020a17090b4acf00b00285a160df1bmr19079170pjb.7.1701378814029;
        Thu, 30 Nov 2023 13:13:34 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id gf18-20020a17090ac7d200b0028098225450sm3743947pjb.1.2023.11.30.13.13.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 13:13:33 -0800 (PST)
Date: Thu, 30 Nov 2023 13:13:32 -0800
From: Kees Cook <keescook@chromium.org>
To: Justin Stitt <justinstitt@google.com>
Cc: Tyrel Datwyler <tyreld@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: ibmvscsi: replace deprecated strncpy with strscpy
Message-ID: <202311301313.6248EF5E@keescook>
References: <20231030-strncpy-drivers-scsi-ibmvscsi-ibmvscsi-c-v1-1-f8b06ae9e3d5@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231030-strncpy-drivers-scsi-ibmvscsi-ibmvscsi-c-v1-1-f8b06ae9e3d5@google.com>

On Mon, Oct 30, 2023 at 08:40:48PM +0000, Justin Stitt wrote:
> strncpy() is deprecated for use on NUL-terminated destination strings
> [1] and as such we should prefer more robust and less ambiguous string
> interfaces.
> 
> We expect partition_name to be NUL-terminated based on its usage with
> format strings:
> |       dev_info(hostdata->dev, "host srp version: %s, "
> |                "host partition %s (%d), OS %d, max io %u\n",
> |                hostdata->madapter_info.srp_version,
> |                hostdata->madapter_info.partition_name,
> |                be32_to_cpu(hostdata->madapter_info.partition_number),
> |                be32_to_cpu(hostdata->madapter_info.os_type),
> |                be32_to_cpu(hostdata->madapter_info.port_max_txu[0]));
> ...
> |       len = snprintf(buf, PAGE_SIZE, "%s\n",
> |                hostdata->madapter_info.partition_name);
> 
> Moreover, NUL-padding is not required as madapter_info is explicitly
> memset to 0:
> |       memset(&hostdata->madapter_info, 0x00,
> |                       sizeof(hostdata->madapter_info));
> 
> Considering the above, a suitable replacement is `strscpy` [2] due to
> the fact that it guarantees NUL-termination on the destination buffer
> without unnecessarily NUL-padding.
> 
> Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
> Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html [2]
> Link: https://github.com/KSPP/linux/issues/90
> Cc: linux-hardening@vger.kernel.org
> Signed-off-by: Justin Stitt <justinstitt@google.com>

Agreed; this conversion looks correct to me too.

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
