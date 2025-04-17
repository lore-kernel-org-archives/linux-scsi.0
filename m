Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0201A7045
	for <linux-scsi@vger.kernel.org>; Thu, 17 Apr 2025 23:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744933832; cv=none; b=j7kY7vPm5fFm3YAYXE3jHclOV9iRCQqdbYGfNdEwsT09uPMCU8YYXLUOUhS8+wKo+H3N+XaE0GC6rswU2S+zsW1qIOcDgKYenB4eQ/12hTNmbbKImceZBmOgNtGf6zgkgU2UAshI1F95iRW+y5h0ZFulEkVlf6Dx0WjXrr7jJFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744933832; c=relaxed/simple;
	bh=QHqNVd85ZFl8xsBHZhkWI7oDS+opVNyxYGMYKO5k/+s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dD4uryCTCH9ze3v/zZ0dFLXIQFqrSEBY/3p47F+agOWPwurbUtNS3UoMAENF7mVOrzoupf5hsvro8QfLlBl7mWr/i9qHRkPfbLLvoERGopnbgjQ3zLY2wqvnpRsFWA+DZWWAn/DA6BVvmgi/zGCeeG24svNec6poWLcli6Ecktc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sOg995bC; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sOg995bC"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2263428c8baso89585ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 17 Apr 2025 16:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744933830; x=1745538630; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=axmNKkL10Icp7dnw5fKVIFJVjkhf304enEMguGPoSWo=;
        b=sOg995bCGgy+k/7wV2iN9x5FmmdpFHzUXnZ7DPbPwRR8WlbYxneNacPIMp+/iFuUZR
         enGztNjO7L33zfqIzvbMs5jNYtNqX8CckF4pHCcf6uEtGuQneDUn93uPt8nyLZFGcetz
         o1zc9j2+4lHVQrZ0g0G+UqdUH1PydVa/qsotNlostrE4+/psmnOTBMY/oZLJfDbCovbM
         Eex4rXuVLhfMiKy125D6xPrWw5wvIRPc/RrtuHbx5fi9BDWJEJXYw9t9uKPwLf3m5jq3
         OxdWUTHrRc327S0nrL2uRD4aJwLpcMauHjZFYYDqJNpSJWOn97G5ZnIonm6fGzfdHBcH
         V6Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744933830; x=1745538630;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=axmNKkL10Icp7dnw5fKVIFJVjkhf304enEMguGPoSWo=;
        b=XMpX2iuh8uH2UhAUQDpSEWaENjDWfBxN5zv+wueDW2IQWSYGMKsvT2t/WJrTOPHpVB
         ZZiVD0BueZNIMbvxbwXwyXMT6PKsw9+4Rifg3F4YpjEfL0WsAV3ddm894N+XMMkasEF3
         Sr7KqxqsFyW+8BAGMpbxmPgUP+WgkPr7vtoJIkqDg6zDXoR2h0dpih0RVO+6Sg8pvTHv
         Q0ZeRE0K4pvkhco9ZV07gTmW0+cPIJQvLOMm0uuNO/NpVABHytlJv1I86QVdgdN1rZFl
         vt+hR5lkO9TzgDMpALgoQUZEXItIvQ8ZT7rcd5bSzEMurFee22IUQMDA8KzWdNrIn87r
         hAFQ==
X-Forwarded-Encrypted: i=1; AJvYcCXFdJ9QV+X5/PVeM3IEEgd7SfbHBX6tiQQz4+widY8eqt0aQrb98lL7Qz0Nilihf95fI0xiRyszrRUS@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8jNOgdIpr+tR9CCTivW6Q3CQg+zn1d87+Oj7jsNDASoYouf1t
	NsnvPxw0ND1nufbnl2wx4YvAQyUJr6tZm8xh9ZjLNzP+oI43377RQ1bWuaYqZg==
X-Gm-Gg: ASbGncvPJ4DFqU9gfOzLHHMy/auxOQZLMzqzMZ/O9ioXxlcmDeKDFKspxSU1rjlhGuf
	3h5ItT6K0+Oqd4zc0U3GgvtlMzDSBaxDs/EaHUlhsvAsly5tgF7QzCnux3bGtWA6vqpmEn+A1/Y
	LXYGMh5fPbtB9cinjbmajI6/22XWEW3zRf3UjNa580ZrFQxtciVx0XDmVqHDoj3Pa5ITGCfx6Lr
	1d7HJqVV7WG2MigJJfT3rm1s+7hw+JRAOysF9qq0fgvDCSZ7iVWfKE+3jsyhqcJIVgJH0Q4cWh4
	ADTzCQqZZlX47zwQuVWs8CWiVi5olk2kolLuN6xVLv4x9NlqGBp6pXiiHhtKqg5kbOCSPk4ShN+
	g
X-Google-Smtp-Source: AGHT+IHsbEMgkqIPYgNBlqdEICBwdwTNJqRgCXucSH1SLA1563+ad5x7yd2ss0cA2elpGel9St/hEw==
X-Received: by 2002:a17:902:ce07:b0:216:6ecd:8950 with SMTP id d9443c01a7336-22c54577a9cmr701005ad.19.1744933829618;
        Thu, 17 Apr 2025 16:50:29 -0700 (PDT)
Received: from google.com (24.21.230.35.bc.googleusercontent.com. [35.230.21.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c50ed1a64sm5819915ad.203.2025.04.17.16.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Apr 2025 16:50:28 -0700 (PDT)
Date: Thu, 17 Apr 2025 16:50:24 -0700
From: Igor Pylypiv <ipylypiv@google.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/3] ata: libata-scsi: Fix
 ata_msense_control_ata_feature()
Message-ID: <aAGTwMfhPPOBYrnf@google.com>
References: <20250416084238.258169-1-dlemoal@kernel.org>
 <20250416084238.258169-2-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250416084238.258169-2-dlemoal@kernel.org>

On Wed, Apr 16, 2025 at 05:42:36PM +0900, Damien Le Moal wrote:
> For the ATA features subpage of the control mode page, the T10 SAT-6
> specifications state that:
> 
> For a MODE SENSE command, the SATL shall return the CDL_CTRL field value
> that was last set by an application client.
> 
> However, the function ata_msense_control_ata_feature() always sets the
> CDL_CTRL field to the 0x02 value to indicate support for the CDL T2A and
> T2B pages. This is thus incorrect and the value 0x02 must be reported
> only after the user enables the CDL feature, which is indicated with the
> ATA_DFLAG_CDL_ENABLED device flag. When this flag is not set, the
> CDL_CTRL field of the ATA feature subpage of the control mode page must
> report a value of 0x00.
> 
> Fix ata_msense_control_ata_feature() to report the correct values for
> the CDL_CTRL field, according to the enable/disable state of the device
> CDL feature.
> 
> Fixes: df60f9c64576 ("scsi: ata: libata: Add ATA feature control sub-page translation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Reviewed-by: Igor Pylypiv <ipylypiv@google.com>

> ---
>  drivers/ata/libata-scsi.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 2796c0da8257..e6c652b8a541 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -2453,8 +2453,9 @@ static unsigned int ata_msense_control_ata_feature(struct ata_device *dev,
>  	 */
>  	put_unaligned_be16(ATA_FEATURE_SUB_MPAGE_LEN - 4, &buf[2]);
>  
> -	if (dev->flags & ATA_DFLAG_CDL)
> -		buf[4] = 0x02; /* Support T2A and T2B pages */
> +	if ((dev->flags & ATA_DFLAG_CDL) &&

Do we need to check the ATA_DFLAG_CDL flag? If ATA_DFLAG_CDL_ENABLED is set
then ATA_DFLAG_CDL must be set as well?

ata_mselect_control_ata_feature() only checks the ATA_DFLAG_CDL_ENABLED flag.

> +	    (dev->flags & ATA_DFLAG_CDL_ENABLED))
> +		buf[4] = 0x02; /* T2A and T2B pages enabled */
>  	else
>  		buf[4] = 0;
>  
> -- 
> 2.49.0
> 
> 

Thanks,
Igor
