Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45ECC313E24
	for <linux-scsi@vger.kernel.org>; Mon, 24 Nov 2025 16:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764003430; cv=none; b=hLzDA+6vpqB/8SSqyXfxNigBTXA5fGbXZPiiGRiKFRa8mdIpynPc2uKWTJX5VeVG7oUqYm+Xfqej/BF0xK0MgEDUiQnZDMWrs1B10KY+HcRF1+UcbyGk1EHHiC7uzPDhXdht0pUYG3A0vxqZdE62HyfYAfByB3I+M79hXLA3JcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764003430; c=relaxed/simple;
	bh=PfQ4/7NQzFSfsv0ka8gSJEka3ONlJOdaGwYNL1BLIPQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K3tavnzP/ROalwfpSPmh2XUh5YwdDENAdnLcF5kYqFgrgIFq6Ajvj91Zd4Kzcp3FYTR1O3f8w4i7z9Lnbv4K8FvrcEIiTrCVnkdw4MT+skG+K5BhWvUaYnwWgLmfB5jfFNzhEku1oIJB3o1Jl1HrvNkalOUAed4DGjJVKVKrhqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AoT+zpg9; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AoT+zpg9"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7aab7623f42so4673649b3a.2
        for <linux-scsi@vger.kernel.org>; Mon, 24 Nov 2025 08:57:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764003427; x=1764608227; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qUogX7WY7Vd//7PtUJR23B9zmXu2YytI3dxf/G/KQjw=;
        b=AoT+zpg9N/EFVj+whQXkxWcrTuQdXOhb7bA6WlBpaPnTbVkODqoeLkGp4Sf0uw3mlK
         OKcD57pLpKEIlFtww0ftE0BgEwAb/oJwYbOolEdtrRYk6uVTxeD7y5nPzzXR3C4qxeXp
         ygnBIQ49HZlvwDBofadlr2MUrRO62upoZ+QLu8Oa+cDXvlY9A29/7JwfVWhVlRyFYXG8
         zVDP2Y+B5pb3FsOIinKx3acFtfvzMhSkIfrX9hZkI8YiryS3X1XoNAE0+cxPqEJixsiT
         7aRamHMHD7VX2C9gYkDZCRO/Kbcz2TfoQXBv8NvyGt1M3PQ1xcBZPLnWWGNBxtvmYK/a
         AuVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764003427; x=1764608227;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qUogX7WY7Vd//7PtUJR23B9zmXu2YytI3dxf/G/KQjw=;
        b=LYazlhkFAUBJegKSxjR0kfs6WoyyyXuyEukxUXQjVxirKXjkmEButmyq42VDfg4g3g
         ZFxCE19inirkfbbykhnGcyF8ub9Nzx65xm9ltqBKZ8S6kzW55ccYfq7L1x0Ocsr+YBDY
         wzNhWJhwFOHFXibQRdbBCZrxmJ9eEeHVrmgJTdLFtuhz4o7fLjj8M0e4xJlrsCNgQzQk
         IHO4tibbH7PohCi7Oy41fO1fwojqxi7bLAHMiKm9vimPwEdYB70RZ4cVm+hyEs+KcZRf
         GLxVf8S/Z7SNLtKG/Kr/Pw4JxBEf/v/ZQj3c/rHA+qZYDhj/rzM36aj/x0JT6BGXAajU
         O2vQ==
X-Forwarded-Encrypted: i=1; AJvYcCUCAZSaGHWghjX9sKIqPYaMoMbC/19i4lneGYvtzYAsrYPC+jiSgt6Fp6SFqtM6KfMnp5dd1RlEtAiy@vger.kernel.org
X-Gm-Message-State: AOJu0YyPMBTfvHOvFGtBy1tIZkm8xc3M06EF49m8NDHWd/Z3pOg3KlE2
	h7MtH190CYzMN3n7gYZwd8RMgKAUSXvY8IurR4Io3ATd1iq+h48v2bYW
X-Gm-Gg: ASbGnctslqMGKdtgOs9yMxBgV00NQA3obs1AvDXSPWje7D6XRgRdbKlAYyjy1MhkpX1
	deNcEeYiMoUBaC39GDZAx+DzDJMRhFD7mKq9ftuxX4bTrx0NakcWRNO4UW8kmPxg+X9pImYl0PB
	MhIEGZ/OJ7DU3XnHcafY/luMunpmKYkPQ7yyqUDA06w1/xuoxl8ZfA+IC/CNRFDztIXTVWDfzuO
	s351iXnhsBGnzHtPMOiiiRkvhHVyi0QfQqULFSNkr/I7awmEjFHPWqo2BEIEZGCoInqQ/jcO0e8
	XFqZYn8HYFD6rJUeAVzuQExp4ln1fRTCMgEFTfc8FMNTUf2iH9ZzGRey6srna0/mIx/Uwpqywmb
	L2Xgfgy624U1sdsDSBxgyfVkQ5CEW9L726dupm2JlBK8XkpeKYUclk5mvSoMfNHRF4qui+GUH1R
	dUB6XONMTWsDra0SyTBlw+itoPU+G5ftQosDs=
X-Google-Smtp-Source: AGHT+IH4bMrzvbSCDAu0Nr2SVYvmh9S6c4NfxteJlssoS6WoKkg6ffShHh1gjfGea3W559MOrwbA5w==
X-Received: by 2002:a05:6a20:12c2:b0:341:5d9f:8007 with SMTP id adf61e73a8af0-3614eea27aamr14043297637.57.1764003427338;
        Mon, 24 Nov 2025 08:57:07 -0800 (PST)
Received: from [10.0.2.15] ([152.57.124.34])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bd760fafe57sm13738935a12.33.2025.11.24.08.57.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Nov 2025 08:57:06 -0800 (PST)
Message-ID: <2e697dfc-2575-469c-9ba2-4470db34b5d1@gmail.com>
Date: Mon, 24 Nov 2025 22:27:01 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: Prefer kmalloc_array over kmalloc involving
 dynamic size calculations
To: Don Brace <don.brace@microchip.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: storagedev@microchip.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, khalid@kernel.org,
 linux-kernel-mentees@lists.linuxfoundation.org, skhan@linuxfoundation.org,
 david.hunter.linux@gmail.com, cassel@kernel.org
References: <20251007065345.8853-1-bhanuseshukumar@gmail.com>
Content-Language: en-US
From: Bhanu Seshu Kumar Valluri <bhanuseshukumar@gmail.com>
In-Reply-To: <20251007065345.8853-1-bhanuseshukumar@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 07/10/25 12:23, Bhanu Seshu Kumar Valluri wrote:
> As a best practice use kmalloc_array to safely calculate dynamic object
> sizes without overflow.
> 
> Acked-by: Don Brace <don.brace@microchip.com>
> Signed-off-by: Bhanu Seshu Kumar Valluri <bhanuseshukumar@gmail.com>
> ---
>  Note: The patch is tested for compilation.
>  Change log:
>  v1->v2:
>   Updated commit message to refelect correct intention of the patch to 
>   address James Bottomley review in v1.
>   v1 Link : https://lore.kernel.org/all/20251001113935.52596-1-bhanuseshukumar@gmail.com/
>  drivers/scsi/smartpqi/smartpqi_init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index 03c97e60d36f..19b0075eb256 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -8936,7 +8936,7 @@ static int pqi_host_alloc_mem(struct pqi_ctrl_info *ctrl_info,
>  	if (sg_count == 0 || sg_count > PQI_HOST_MAX_SG_DESCRIPTORS)
>  		goto out;
>  
> -	host_memory_descriptor->host_chunk_virt_address = kmalloc(sg_count * sizeof(void *), GFP_KERNEL);
> +	host_memory_descriptor->host_chunk_virt_address = kmalloc_array(sg_count, sizeof(void *), GFP_KERNEL);
>  	if (!host_memory_descriptor->host_chunk_virt_address)
>  		goto out;
>  

Hi,

I just wanted to check if you had a chance to review it or if any changes are needed from my side.

Regards,
Bhanu Seshu Kumar Valluri
