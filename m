Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB963A2E25
	for <linux-scsi@vger.kernel.org>; Wed,  1 Jul 2026 07:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782889393; cv=none; b=FVUl7hNs1IQCqwF8m8NrfilRfWrgx9Tl7ZKudFWulhZ0Tc1XjkFfMMUTQSBBmVrLUWrUZqYE1pRQpsCe1qhZG2myAo94z+GxucFhI8u2A3+ql+PDKeAlHGoBGkiShwWQLJS4shuR1/V4uU7gttVLo27oke4PnaZxmxiFPNnptms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782889393; c=relaxed/simple;
	bh=HAGRqxc7KIHCCdEKJ9mGxAxGOM1MdtRInQuffYvOB5I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AE5rsmNbwWxjkW7BkdMwfQtCE26kn+GSD3NJKMT5pq7bkjAUo7oLAR4jl6kY1vDdyHMyFzrbb/kEK1g1mhp8llVD1WVrsA4SQQ2xCO6DPTak30N0IJjyLuE4T7zo6nqelPWq1PrTiWahr815v9En91gvfGd0mDnf0f7I0VJsugc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=X8zvc0Kw; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="X8zvc0Kw"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4758b2a9e2aso152362f8f.2
        for <linux-scsi@vger.kernel.org>; Wed, 01 Jul 2026 00:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782889388; x=1783494188; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BEOzJcjGcAIJl3Tht4vVazVfDVw0cfWuXCgpWa0S2Ng=;
        b=X8zvc0KwsgzjfXbOHm9pCvX7x+IwcXEsYhYcAqoG8ehDir4bg1VUpSTknZbahKjwWV
         EpbFU+Bsw991B5LjBUmJXNKtZfR3NmCXmu3SPNeT/GGtXVzpFm4g/ZS7YkGhAyU7yuCJ
         4wd/itNz+D7TYCx1bt5LqQdRsbZrZ0waAwYAWfeRxLV16fh7U3DKbWI4VwTcsQUM35Uf
         gXdz9mCakGToVkR/+qBTI7hsm/XhGP7e5OckHrv6QUOcX8PUauRXQ+cJwumoER/DN1EX
         e7csiO3c6ReyPPu6J5+WFdk5cln3hgKkN1hP/fVCpVg+eDfeR5OM1G9ZiLu+s9Rqtz09
         i3ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782889388; x=1783494188;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BEOzJcjGcAIJl3Tht4vVazVfDVw0cfWuXCgpWa0S2Ng=;
        b=aROGyv8vzJ0l4dDb6tVt4fblU7OzQTaeN1/6/todc5JMCvlS7OLGrD9tcN0QtceDEo
         eWNyqUKn2kgFrdn4UfpY9uAI4sxiE6t7c9xpLYM75fea/P2AS/SdKptGarDVb/D/hKLp
         h6V63VroW7/VQ0DLIVTdDeoVnnJsj0z+2FxV/TLs2dS0xJBoO8cohFciFME9rM8naD9C
         DOYl4XIg1vY4WiM1EHCQ8E7X1t08Y1pFe0nL6jyRwyCrsoMRZ0FxiPW3mWlrOCpiIEo3
         +8cdP3GyErNuAQSrWYdsIT2WhDx0ZBnnX0AWlEXppeJ7w8p9IF922VXSYanxdDSCBcyO
         sg3w==
X-Forwarded-Encrypted: i=1; AFNElJ/D+4ukGCdMR542g6iMscOXP0i3dV6tzPfepPkmqz2cln4Qpf5L+iO97MjtYs3O5y069H2oWqcRX6al@vger.kernel.org
X-Gm-Message-State: AOJu0YxfHkjqQfgotME389jJvCgjs5aqFA4p5R/+dcSf30Zh3B0oaFTq
	JwDqeWh0VPkxBaJj8vPG+34SeGAZ2qFzNqcGauRt5zbG9y9apHYN77Sx3iOMZn/prIE=
X-Gm-Gg: AfdE7ck3XaeqoQfXTGoc8MmxLH5QzdnfNdU0JY5zhNIzyikL5tEZPehsVjyLRunLSiR
	Q+hyuIY8KUELgqDJlvZOpCQzt+TqjSTloQI/16gHXPup8V6teBhXvy1YkMr6TjWIqjvPjA98JnT
	LzHRHaSnRXnsultLd9hrLCfYPcUfIxVCdZb5AU8dD2zL87r0jNirgj+rNXtqOTK8rsX1ETdf6XT
	MeMIQM58MA74MFcCfIneYiywz0LrjvlvwUI7GjbvmnZoPwC0apwWACcYZiAjneg4bok1BDpJQgD
	wvFshBOMtkg0PD/LmFu+y0GL9rF2hulYlE9ZycqbXRfHUlrpMsRQ/ihEes4HoSJNUNeJ1fP0gr8
	PKYcowEJ8/+mNXv4v+QnUZgL0T1OZIBGAAh+n+otf3faNHp3OWmc4Mlq6L6i0ZoV1+J1uWu35dB
	VVW/ufWAYDgo5YuchbNNTuKSSf0FFC6kG57Th3gAxanx0HqWw=
X-Received: by 2002:a05:600c:3501:b0:490:d079:2919 with SMTP id 5b1f17b1804b1-493c2b4ce3cmr5715935e9.14.1782889388047;
        Wed, 01 Jul 2026 00:03:08 -0700 (PDT)
Received: from ?IPV6:2001:a62:1403:d01:fcc2:cfc6:9af3:a0c1? ([2001:a62:1403:d01:fcc2:cfc6:9af3:a0c1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4756636cf98sm10981027f8f.22.2026.07.01.00.03.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2026 00:03:07 -0700 (PDT)
Message-ID: <7c8f0e70-f49c-4614-af95-002fb2be11ba@suse.com>
Date: Wed, 1 Jul 2026 09:03:06 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] scsi: ipr: use kmalloc() to allocate IPR dump buffer
 memory
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Brian King <brking@us.ibm.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
 <20260630-b4-scsi-v1-3-494fb37ebe7b@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260630-b4-scsi-v1-3-494fb37ebe7b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/30/26 12:54 PM, Mike Rapoport (Microsoft) wrote:
> IPR dump machinery allocates memory to save adapter's crash dump using
> __get_free_page().
> 
> This memory can be allocated with kmalloc() as there's nothing special
> about it to go directly to the page allocator.
> 
> kmalloc() provides a better API that does not require ugly casts and
> kfree() does not need to know the size of the freed object.
> 
> Replace use of __get_free_page() with kmalloc().
> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   drivers/scsi/ipr.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> index d207e5e81afe..5a212bfdeec2 100644
> --- a/drivers/scsi/ipr.c
> +++ b/drivers/scsi/ipr.c
> @@ -2893,7 +2893,7 @@ static int ipr_sdt_copy(struct ipr_ioa_cfg *ioa_cfg,
>   	       (ioa_dump->hdr.len + bytes_copied) < max_dump_size) {
>   		if (ioa_dump->page_offset >= PAGE_SIZE ||
>   		    ioa_dump->page_offset == 0) {
> -			page = (__be32 *)__get_free_page(GFP_ATOMIC);
> +			page = kmalloc(PAGE_SIZE, GFP_ATOMIC);
>   
>   			if (!page) {
>   				ipr_trace;
> @@ -3226,7 +3226,7 @@ static void ipr_release_dump(struct kref *kref)
>   	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
>   
>   	for (i = 0; i < dump->ioa_dump.next_page_index; i++)
> -		free_page((unsigned long) dump->ioa_dump.ioa_data[i]);
> +		kfree(dump->ioa_dump.ioa_data[i]);
>   
>   	vfree(dump->ioa_dump.ioa_data);
>   	kfree(dump);
> 
I _think_ we can replace this with kvmalloc, and allocate the entire
dump buffer in one go. Once switched to kmalloc() it's kinda pointless
to allocate separate page-sized buffers here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
