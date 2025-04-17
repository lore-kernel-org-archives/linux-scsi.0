Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D788F19DF9A
	for <linux-scsi@vger.kernel.org>; Thu, 17 Apr 2025 03:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744861073; cv=none; b=Lb+JYhvlEM+pNaZp7K4CbXa6unwNgwKamYDsyvfPviFhQxJzvMQKaW3X5VhMbX7SxZiC95maBaHyzrFK6eKHxlftL3Jxrs4FH5vXnkCkEGfJUbXy6TSXU9yTvmHaG+6X8+J42bAErX/rUs5nb56k/j+x4/tMhtLxddWT5Pdg+ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744861073; c=relaxed/simple;
	bh=t1echBw+bczFqrPhFsmw0546c6syW481Y+O1DXFhktQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ge46IfWXlwpD1hZ/6C/IuJOURs/QgYecT5Tkoak+z3/fMiGGBtGuvQUEh90q3WBVwtxf+geCMQHtDLU7G8l1O2ghjb+lW37h7IBW10qdqaKv0rQDHnHdOxqX/s72Bwwtx/L5SCei2R+pcIRtbof26OUziVpd8FuFjqmOTsroJ+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lZWYB0p0; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lZWYB0p0"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2264c9d0295so111855ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 16 Apr 2025 20:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744861071; x=1745465871; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=byt4PX9UGaxEliqpkTDu5dj/2Lanqx2NpRWiOJw5HLU=;
        b=lZWYB0p0lD6IQyFGeYrb0A0Tpy452w4iMHLpZPzZUi0cRyDSORNDVBSZkcxCOu8N6O
         RNKxN2CcGkHyftvu79BrA9CRYuoSQeHpYNoHrCBHVDc21qfjNuUrClXdxZs813HIyM/I
         v5VH2GZ8h34jeQOkbjeEwoOaELAXf5200SdTR4CcghwVi3s1Jr3Efg/NPEvZVJ7GMual
         a5RoqdYKaT90CQyRAQUgLxwFpsunrTs/LnzyneFQ2wRfQGWsgZ000VRSCaIRPJQRBc/r
         cANayizEVVw9oi83VLYX+LX3hl0YncWfSXcT64uP6MYrMigoFEgOqsolRq+e9VHpP1m1
         iWXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744861071; x=1745465871;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=byt4PX9UGaxEliqpkTDu5dj/2Lanqx2NpRWiOJw5HLU=;
        b=eHOSuHcpj44llQHyV3lPuLQyLc8x1qJzli2YpcOFxaWiL0TkXxjT0G+jQt7tx0whNs
         tA0bb7IGaAs0JcZUjNH+PJM9xojRi0hxfWBll+TZI/91402kDX25WTxGfBQ2/d1zHce2
         DjTysmaco9U/QOxTmseJztQ3wJeBB/ISc6yhlsmPJ/dyq5z3xI2calssp/8jLJiHLCpH
         QVevjrY3H3L+oVk3s3r3+wSBHXjFNc2iYChFg/ZKXUhlYWfvJsf2+451LWVgMfAR5Bpn
         DhKCwtDKvkiMvG86w/1IDfqw88UX4+JQYXwF/GZn9WWrfQvRU7biFV+2YDo7LIkMiIB4
         ZFgg==
X-Forwarded-Encrypted: i=1; AJvYcCXuTKmBKVmwDBt8k6dbE2enmqOLhpIiP1+vKT2iGCFrF2EzO48YUqSm27cnuHFAFNwhWAOCpLmYpky/@vger.kernel.org
X-Gm-Message-State: AOJu0YyNFobMmoabDrQVygBsEwRP5jEFHTpKdLwmwCY6fE4v0Mp4n3J7
	F6WImgTSrS68PXOCKxi5uV+Qta3YOApbaFd7sYga0gas8oSeIgfyc0PiAtegBjfZmR/IlbGPjT7
	++Q==
X-Gm-Gg: ASbGncsMN+mY13L1RKJsx5ooauf2In+mexD5UdhybTrXG/P3HIyiaj9r7Ym0oIZTROR
	tLmLglazi5Qq92fRDtpmQAFiyO4SONW/1VmzFVzWp11Z393pNLRCf0TjuUNhF/AbcEbSkWcigeO
	ghSPKmO84kC7vdEffTI0o+obGhnB2wdKqqagNykYRLEQOwm69uiDherNbV31UU4pbWG+pJpwUnN
	4ib12HHzYvwuMRlVB9rojSzybXna12TYW/koJfUR3sUIxke+y2S4XzhuuNILzJWJ7HaYujqMkWF
	N7ax5Oyzh/wEL4269Q8aSRznrfgCp5aniN3zmhNWFc+TQNy/kuQ6ghvLTuPudGNZak01kADwddx
	U
X-Google-Smtp-Source: AGHT+IHJw0ecHSj4SbB77NXiTqm+qJZ6cVlPlqAXUAcNdP6rrjroGUfygsivduvTIobZPW2CxMwE2g==
X-Received: by 2002:a17:903:fad:b0:215:9ab0:402 with SMTP id d9443c01a7336-22c41232d01mr1560175ad.18.1744861070850;
        Wed, 16 Apr 2025 20:37:50 -0700 (PDT)
Received: from google.com (24.21.230.35.bc.googleusercontent.com. [35.230.21.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c33ef1025sm22825835ad.39.2025.04.16.20.37.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Apr 2025 20:37:50 -0700 (PDT)
Date: Wed, 16 Apr 2025 20:37:45 -0700
From: Igor Pylypiv <ipylypiv@google.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/3] scsi: Improve CDL control
Message-ID: <aAB3iU7ZuQo5cH9z@google.com>
References: <20250416084238.258169-1-dlemoal@kernel.org>
 <20250416084238.258169-4-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250416084238.258169-4-dlemoal@kernel.org>

On Wed, Apr 16, 2025 at 05:42:38PM +0900, Damien Le Moal wrote:
> With ATA devices supporting the CDL feature, using CDL requires that the
> feature be enabled with a SET FEATURES command. This command is issued
> as the translated command for the MODE SELECT command issued by
> scsi_cdl_enable() when the user enables CDL through the device
> cdl_enable sysfs attribute.
> 
> However, the implementation of scsi_cdl_enable() always issues a MODE
> SELECT command for ATA devices when the enable argument is true, even if
> CDL is already enabled on the device. While this does not cause any
> issue with using CDL descriptors with read/write commands (the CDL
> feature will be enabled on the drive), issuing the MODE SELECT command
> even when the device CDL feature is already enabled will cause a reset
> of the ATA device CDL statistics log page (as defined in ACS, any CDL
> enable action must reset the device statistics).
> 
> Avoid this needless actions (and the implied statistics log page reset)
> by modifying scsi_cdl_enable() to issue the MODE SELECT command to
> enable CDL if and only if CDL is not reported as already enabled on the
> device.

Hi Damien,

What happens when a drive spins up with CDL enabled? Last year you sent
a patch to make sure that CDL gets disabled by default. Is that still
the case?

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=52912ca87e2b810e5acdcdc452593d30c9187d8f

Thanks,
Igor

> 
> And while at it, simplify the initialization of the is_ata boolean
> variable and move the declaration of the scsi mode data and sense header
> variables to within the scope of ATA device handling.
> 
> Fixes: 1b22cfb14142 ("scsi: core: Allow enabling and disabling command duration limits")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  drivers/scsi/scsi.c | 36 ++++++++++++++++++++++++------------
>  1 file changed, 24 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 53daf923ad8e..518a252eb6aa 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -707,26 +707,23 @@ void scsi_cdl_check(struct scsi_device *sdev)
>   */
>  int scsi_cdl_enable(struct scsi_device *sdev, bool enable)
>  {
> -	struct scsi_mode_data data;
> -	struct scsi_sense_hdr sshdr;
> -	struct scsi_vpd *vpd;
> -	bool is_ata = false;
>  	char buf[64];
> +	bool is_ata;
>  	int ret;
>  
>  	if (!sdev->cdl_supported)
>  		return -EOPNOTSUPP;
>  
>  	rcu_read_lock();
> -	vpd = rcu_dereference(sdev->vpd_pg89);
> -	if (vpd)
> -		is_ata = true;
> +	is_ata = rcu_dereference(sdev->vpd_pg89);
>  	rcu_read_unlock();
>  
>  	/*
>  	 * For ATA devices, CDL needs to be enabled with a SET FEATURES command.
>  	 */
>  	if (is_ata) {
> +		struct scsi_mode_data data;
> +		struct scsi_sense_hdr sshdr;
>  		char *buf_data;
>  		int len;
>  
> @@ -735,16 +732,30 @@ int scsi_cdl_enable(struct scsi_device *sdev, bool enable)
>  		if (ret)
>  			return -EINVAL;
>  
> -		/* Enable CDL using the ATA feature page */
> +		/* Enable or disable CDL using the ATA feature page */
>  		len = min_t(size_t, sizeof(buf),
>  			    data.length - data.header_length -
>  			    data.block_descriptor_length);
>  		buf_data = buf + data.header_length +
>  			data.block_descriptor_length;
> -		if (enable)
> -			buf_data[4] = 0x02;
> -		else
> -			buf_data[4] = 0;
> +
> +		/*
> +		 * If we want to enable CDL and CDL is already enabled on the
> +		 * device, do nothing. This avoids needlessly resetting the CDL
> +		 * statistics on the device as that is implied by the CDL enable
> +		 * action. Similar to this, there is no need to do anything if
> +		 * we want to disable CDL and CDL is already disabled.
> +		 */
> +		if (enable) {
> +			if ((buf_data[4] & 0x03) == 0x02)
> +				goto out;
> +			buf_data[4] &= ~0x03;
> +			buf_data[4] |= 0x02;
> +		} else {
> +			if ((buf_data[4] & 0x03) == 0x00)
> +				goto out;
> +			buf_data[4] &= ~0x03;
> +		}
>  
>  		ret = scsi_mode_select(sdev, 1, 0, buf_data, len, 5 * HZ, 3,
>  				       &data, &sshdr);
> @@ -756,6 +767,7 @@ int scsi_cdl_enable(struct scsi_device *sdev, bool enable)
>  		}
>  	}
>  
> +out:
>  	sdev->cdl_enable = enable;
>  
>  	return 0;
> -- 
> 2.49.0
> 
> 
