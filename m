Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203785674E
	for <linux-scsi@vger.kernel.org>; Tue,  5 Nov 2024 16:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730824078; cv=none; b=C35eMGIM5DbQc8Xvj+vAmPzjSKV3wFVvwO6LnOu+j7xD4LcUizEGuu+kwiDOergN8snFGgsWAs/cDi0aIu3neX1w7M142ke2MwoYEiuPySx0tUXzvDf4dX3tWPumwJlHZACXz8OIPVTi456vsaJli4oq3lCPSGfrcTmWeb6m1UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730824078; c=relaxed/simple;
	bh=6lKEju4tzcGBBXoGLue1fy4v7SHvUr8Lq4qdFA89dvE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=MZQMxV4TX3tqgdlofhCuwCSiKDGObIDmQ1C+xby+HS0XQFhxtTGoc8KDPetmQJd6UsMipUsIDcjfIBk8MS5qOjkkdmqH5WeDXKH9kXPjem6Id8SgcXiGBWdrdFmnZu5tQo0HCsEtrBIaNslGH0hJ9tmuUPYGUkaCdVFy2V5Xqdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ubstt37J; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ubstt37J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730824075;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XYowUcCUvYBTzf8yObVt54/LH6jljftk+yqZghhVZEo=;
	b=Ubstt37J9U+S1qFajqFtYMXVlWvRmk25azXF+Te8fe0wmM+OedaK2vnqsSCp7w5nvb2UTH
	ehiGH5nsp6aIwa/XH1d6KxcDEYxUP17ad+NmH6cOQSuX5cv8NTmM+c1lUKMURUdPdTR3bc
	0lLDE3P9p85Wokxh9uuGF3OrTLXdjyU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-577-SXc0HnViP-q4W8H3ZS2HSg-1; Tue, 05 Nov 2024 11:27:54 -0500
X-MC-Unique: SXc0HnViP-q4W8H3ZS2HSg-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4315cefda02so41708725e9.0
        for <linux-scsi@vger.kernel.org>; Tue, 05 Nov 2024 08:27:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730824073; x=1731428873;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XYowUcCUvYBTzf8yObVt54/LH6jljftk+yqZghhVZEo=;
        b=KGAvid+/MgKOcRgJoUEZwct/t067rSjexeIrHnJnlrtP4d9Rf9B/K4XHW+saTSx3fZ
         T9MtqDKgUHzfnjAJlTXH7AJjcFo/YssYDJvNF0DAcA+6hVbgTVVZ1ugC8cHQ0vqpflVr
         MU1HotCy5XquE9gv2lek/NrkOWyWVTS61wnO2QmRkU2ludihYP/KUzgAhFfn/rOgQuxS
         CqO8F09HBlwS26fN2POW5iaB9biAe4EMLGhyZApCadmFJYPtC4tUbnyYRZ2RXFctvjak
         PwQ5k4iJuK1xBEbIgFRg1rPT6qNKm+qHctsPT/kmlUhonff/XknYUS0YMDkcy2K1lI5m
         pUhQ==
X-Gm-Message-State: AOJu0YxHZ1epDeEXB70KoPPbrnCeJ1SW5JUu++yZrWDCRnp+nlFH57L/
	9YMYxb94kqQhBCUOpM+Rv7zgL/MiTcBjEI02iiAtanug4wvGrFi8O/aO2UTWdefdI4U78AFZJZf
	GD5W+OKUv/hfnpLwU/occIspdfJgXEwLmyNjIFxl/Pg7fft4mfJejRw1bM6QOyBPwGvPy47moSY
	E1TN00RK8jOHBDXzmm329gNwEw3gtO27AmvO+xEJQXeyE=
X-Received: by 2002:a05:600c:3ca8:b0:431:52b7:a499 with SMTP id 5b1f17b1804b1-4327b7019ddmr164329155e9.20.1730824072892;
        Tue, 05 Nov 2024 08:27:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF8qLZJHLIE/cUeUU8jtXMTkzAkfunIJGNZ3dFCsxvlEONkGNj3i3sAGZTJ8fETUGIFx2PBQA==
X-Received: by 2002:a05:600c:3ca8:b0:431:52b7:a499 with SMTP id 5b1f17b1804b1-4327b7019ddmr164328795e9.20.1730824072142;
        Tue, 05 Nov 2024 08:27:52 -0800 (PST)
Received: from [192.168.0.111] (78-80-81-220.customers.tmcz.cz. [78.80.81.220])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431bd9479ebsm220822625e9.23.2024.11.05.08.27.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2024 08:27:51 -0800 (PST)
Message-ID: <026951b5-69ea-49c7-b48b-5d426ccd1ec5@redhat.com>
Date: Tue, 5 Nov 2024 17:27:50 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] megaraid_sas: fix for a potential deadlock
From: Tomas Henzl <thenzl@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: chandrakanth.patil@broadcom.com, sathya.prakash@broadcom.com,
 sumit.saxena@broadcom.com, ranjan.kumar@broadcom.com
References: <20240923174833.45345-1-thenzl@redhat.com>
Content-Language: en-US
In-Reply-To: <20240923174833.45345-1-thenzl@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/23/24 19:48, Tomas Henzl wrote:
> This fixes a 'possible circular locking dependency detected' warning
>       CPU0                    CPU1 
>       ----                    ---- 
>  lock(&instance->reset_mutex); 
>                               lock(&shost->scan_mutex); 
>                               lock(&instance->reset_mutex); 
>  lock(&shost->scan_mutex); 
>  
> 
> Fix this but temporarily releasing the reset_mutex.
> 
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 6c79c350a4d5..253cc1159661 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -8907,8 +8907,11 @@ megasas_aen_polling(struct work_struct *work)
>  						   (ld_target_id / MEGASAS_MAX_DEV_PER_CHANNEL),
>  						   (ld_target_id % MEGASAS_MAX_DEV_PER_CHANNEL),
>  						   0);
> -			if (sdev1)
> +			if (sdev1) {
> +				mutex_unlock(&instance->reset_mutex);
>  				megasas_remove_scsi_device(sdev1);
> +				mutex_lock(&instance->reset_mutex);
> +			}
>  
>  			event_type = SCAN_VD_CHANNEL;
>  			break;

Hi Chandrakanth,

can you please review this patch?

Thanks, Tomas

