Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F63C2A1A4
	for <linux-scsi@vger.kernel.org>; Sat, 26 Apr 2025 21:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745702687; cv=none; b=fDqmzOk0CCZwjd9skcBzmxfJrkQdOmWcGWNECzfwJQmkbfzZYQ6YjUvBiy2PHWqmfT0QAGiqMxdDQKoKc3V6kszowW4aElDJArcUO5ApRH7tdpWlCovknMlfORmykxrZDcfjlo1lR5RCMjcHBiMPADt6Aq14oAc0ExbA6CMU/iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745702687; c=relaxed/simple;
	bh=Dg3fCarQHR/JTqvGhOBfZR+xsGq8DTqd0lvEpfJG5Ks=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PhfAm/0L2KYjLWkM2HtR5Dzq0u1mlyJMz+WwfPzpf4GUQ0RDRFVawEdKP3UzHyA9jOhqIeROaRb4r+ZOnt7gMgVCjseZKVUn+moVhVtyvUK0uZzueE7dss+xMD+k499kkg8q7x7/EtQ+LRccZIm+MK0Lyc5kF73m+GM0rLKNBPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=g83zWtzu; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="g83zWtzu"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-30effbfaf61so38812471fa.0
        for <linux-scsi@vger.kernel.org>; Sat, 26 Apr 2025 14:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1745702683; x=1746307483; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K1mqAIBnp7KMTnNYtwdmaVxEXl0tUjHzIuN2rlUSfs8=;
        b=g83zWtzuFZFO+Vqj29C01+uQQf515igBwWI/IV3sCGAgUyki5q20OgFlJhio7tTuuK
         k4TqMJKLQcKcciKqJtytQF52SCqGO2wb6XDeYXBZEDIgBoPPGYl7ZehnVaFSjuqK3ZnR
         +Y9u7A5nwkZfKjmXmROG2h0lZUQr4/0Y9JhgCeJOJks0lQrEIBMch4XdS10QPSy0J/bp
         DOvCxeaTL/br3NuP/1pHZJkseo/1z19VaNPltTvSHrhgg3N8bUCZtc1MmL6JGN4oiIn+
         2bS6I2sOmJQWR7rMt4AkebVr2GJG3+vjR16/dOU1cmJhcDQ+h80YKJZ+clyC+2zG9Wz4
         2N0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745702683; x=1746307483;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K1mqAIBnp7KMTnNYtwdmaVxEXl0tUjHzIuN2rlUSfs8=;
        b=Ijc+nhSF+nDfcJkt+Edm+xkFH/b2TWCneXK/KbBDSVVX9Ye1800MvsCqYxEAfUmZN5
         rAPfQ/F9AI3E8qH2IJEIFiW7i6se1CydFMRRZY8lfhDWimhGfNYMlgJYPFy/I5Jr4yzE
         v2elMtiBuxLK6PX0pjUX4bFR397xrnvCeR/oR0Y29hvo/43V/T9oQKuPnBQHaPzVkuy1
         Wt4w/ApFTeMaJCp25Ab7N5GyXZ0agunFnOo7yOipJKO0CE0u19k8VfP0mrIm0l6bznAD
         71UwWdztY1Tn79FNvvUXYT+/+/xMu52cxfC5Z47fWvg8V5r0pqCkAIF6iOfz8rvj7CPf
         Ru0w==
X-Forwarded-Encrypted: i=1; AJvYcCUyGNbOQKUnIJxIW5wOpzvlH5Td9hf0A4BmQUcmIdI4lNUH3SYBLxcM/OQ2YoUDUzl/ohAfkbiRTghV@vger.kernel.org
X-Gm-Message-State: AOJu0YygnvEJzROl3swSUfB3U1/Y+dNJlbJBKDZhi74nJMKeEvPNQaEr
	0LmHDzldmjG3JFYrrNUR+7RI+oWIw74yKLKyw/Z8XEHjFoc09HvkEq5hPezLQqvTE6E4wfGscIS
	y8DOwtGkaaVuLOsduKjlgFOMi3cB/mxH7nFDrgw==
X-Gm-Gg: ASbGncueOMvJpOy4+lF1YlOpvFlOmF38Bexduqo1N6pa1zgTekBqdGEK6hFZKabd1Lu
	5eWGfsDAGaDu/TFH4UfpMGKP1ELgFTGu3ZBu3yJ5lFvlWvM/qjjXzSq/vreHHc5Bsu8j7mbv3JL
	AeedWVLAc6PsHmFJVX3TrFARTpEyisBCu8jg==
X-Google-Smtp-Source: AGHT+IFJMmStyVBuIyxQECB5iELQPgDUnywD2WJ46nDL9IgJLHD7iPOWbRPUoe3umTLlnkE5eoleE6r364MYg9Jxl1Q=
X-Received: by 2002:a05:651c:222a:b0:30b:9f7b:c186 with SMTP id
 38308e7fff4ca-317cc3b4c3dmr33874231fa.1.1745702683231; Sat, 26 Apr 2025
 14:24:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250304181400.78325-1-thorsten.blum@linux.dev>
In-Reply-To: <20250304181400.78325-1-thorsten.blum@linux.dev>
From: Lee Duncan <lduncan@suse.com>
Date: Sat, 26 Apr 2025 14:24:32 -0700
X-Gm-Features: ATxdqUFRXwxiD0AZ10vGLZVX25IArlcs-9mCmM5d-L5qj3q4zIK9ecGpSwHodS0
Message-ID: <CAPj3X_VKZz_8oq0puSuh96_=ozR+t8xL_whb5+UaNYS0MOrpKw@mail.gmail.com>
Subject: Re: [PATCH] scsi: target: Remove size arguments when calling strscpy()
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 4, 2025 at 10:30=E2=80=AFAM Thorsten Blum <thorsten.blum@linux.=
dev> wrote:
>
> The size parameter of strscpy() is optional because strscpy() uses
> sizeof() to determine the length of the destination buffer if it is not
> provided as an argument. Remove it to simplify the code.
>
> Remove some unnecessary curly braces.
>
> No functional changes intended.
>
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/target/target_core_configfs.c | 20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/targe=
t_core_configfs.c
> index c40217f44b1b..9b2b9786ce2f 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -673,12 +673,10 @@ static ssize_t emulate_model_alias_store(struct con=
fig_item *item,
>                 return ret;
>
>         BUILD_BUG_ON(sizeof(dev->t10_wwn.model) !=3D INQUIRY_MODEL_LEN + =
1);
> -       if (flag) {
> +       if (flag)
>                 dev_set_t10_wwn_model_alias(dev);
> -       } else {
> -               strscpy(dev->t10_wwn.model, dev->transport->inquiry_prod,
> -                       sizeof(dev->t10_wwn.model));
> -       }
> +       else
> +               strscpy(dev->t10_wwn.model, dev->transport->inquiry_prod)=
;
>         da->emulate_model_alias =3D flag;
>         return count;
>  }
> @@ -1433,7 +1431,7 @@ static ssize_t target_wwn_vendor_id_store(struct co=
nfig_item *item,
>         ssize_t len;
>         ssize_t ret;
>
> -       len =3D strscpy(buf, page, sizeof(buf));
> +       len =3D strscpy(buf, page);
>         if (len > 0) {
>                 /* Strip any newline added from userspace. */
>                 stripped =3D strstrip(buf);
> @@ -1464,7 +1462,7 @@ static ssize_t target_wwn_vendor_id_store(struct co=
nfig_item *item,
>         }
>
>         BUILD_BUG_ON(sizeof(dev->t10_wwn.vendor) !=3D INQUIRY_VENDOR_LEN =
+ 1);
> -       strscpy(dev->t10_wwn.vendor, stripped, sizeof(dev->t10_wwn.vendor=
));
> +       strscpy(dev->t10_wwn.vendor, stripped);
>
>         pr_debug("Target_Core_ConfigFS: Set emulated T10 Vendor Identific=
ation:"
>                  " %s\n", dev->t10_wwn.vendor);
> @@ -1489,7 +1487,7 @@ static ssize_t target_wwn_product_id_store(struct c=
onfig_item *item,
>         ssize_t len;
>         ssize_t ret;
>
> -       len =3D strscpy(buf, page, sizeof(buf));
> +       len =3D strscpy(buf, page);
>         if (len > 0) {
>                 /* Strip any newline added from userspace. */
>                 stripped =3D strstrip(buf);
> @@ -1520,7 +1518,7 @@ static ssize_t target_wwn_product_id_store(struct c=
onfig_item *item,
>         }
>
>         BUILD_BUG_ON(sizeof(dev->t10_wwn.model) !=3D INQUIRY_MODEL_LEN + =
1);
> -       strscpy(dev->t10_wwn.model, stripped, sizeof(dev->t10_wwn.model))=
;
> +       strscpy(dev->t10_wwn.model, stripped);
>
>         pr_debug("Target_Core_ConfigFS: Set emulated T10 Model Identifica=
tion: %s\n",
>                  dev->t10_wwn.model);
> @@ -1545,7 +1543,7 @@ static ssize_t target_wwn_revision_store(struct con=
fig_item *item,
>         ssize_t len;
>         ssize_t ret;
>
> -       len =3D strscpy(buf, page, sizeof(buf));
> +       len =3D strscpy(buf, page);
>         if (len > 0) {
>                 /* Strip any newline added from userspace. */
>                 stripped =3D strstrip(buf);
> @@ -1576,7 +1574,7 @@ static ssize_t target_wwn_revision_store(struct con=
fig_item *item,
>         }
>
>         BUILD_BUG_ON(sizeof(dev->t10_wwn.revision) !=3D INQUIRY_REVISION_=
LEN + 1);
> -       strscpy(dev->t10_wwn.revision, stripped, sizeof(dev->t10_wwn.revi=
sion));
> +       strscpy(dev->t10_wwn.revision, stripped);
>
>         pr_debug("Target_Core_ConfigFS: Set emulated T10 Revision: %s\n",
>                  dev->t10_wwn.revision);
> --
> 2.48.1
>
>

Reviewed-by: Lee Duncan <lduncan@suse.com>
