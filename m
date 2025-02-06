Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E0C3D561;
	Thu,  6 Feb 2025 16:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738860741; cv=none; b=TYdS/CW87Va0ihBaqbloONU3Nm9Kgvj8vo8NyPaHHy0eg/ymXWvsQGhZOxwGhOzv4GXANhGEA7jfezJHj3s5k3gHmVTJ6UvYHx/QEfiQFWb3DcOm+pHNk7Nog72cKpHzB8DjwtLCgKDOimKTtDLhwPRm/JyiSSO6rMAI+Dh3bHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738860741; c=relaxed/simple;
	bh=rK2Twi7TCqnlhJuqwpHhdHS9abCCtkoTAleQPDOS90s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LzfKMHOEGKTwaaic+q1ZfyaZAH/opvSo7DRhL4QmOpF9puWQ/xZmzVroF/iEwWjXaqHAxq04Jb5ygYEgMIS1jhHHOn74jZ5rCQgB9c5cfmYlBsx+eBRyjemm5bI2XTi+T4xB1AKvwmcJtZRMmrOzbVXEjHyklSPHVUnGHuLmG4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=WCIdJI/x; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=wqoQG0wD; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="WCIdJI/x";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="wqoQG0wD"
Date: Thu, 6 Feb 2025 17:52:16 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1738860738;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=To/HERHXKuqedSH3EfTWa/Hor3NDrEMP+jRzMGiNHIU=;
	b=WCIdJI/x9ItXroIFWG94Uz95J5phpoc9Jhx+A/focIsRKq2INmE9RTUtKba6hiu6borvog
	d9K9JWlX3NQjgXfnNn/Spo1AzEJeV5kzM1YbZFp7YxZEDk9hLInC80FNFr2c8keo7eIctp
	TDYOscznOXHMA7qx/JrXMiNV9opYvBFBPUtel1P7ijJt82+XOCluCjIAStM47IrlgTcad1
	8jV9gmhSkrngUq2rgoOvjkHE3oMRI3vdcqQ+idy0306Gj+JYSsafdajmlNyrJA9n8rXukC
	d7QcMuOU2rKZp5ELBYeiuIDS/1XrLYN09GAsDCiYIIPF1kLgAAhpyYLkhCqIVg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1738860738;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=To/HERHXKuqedSH3EfTWa/Hor3NDrEMP+jRzMGiNHIU=;
	b=wqoQG0wDr5ywAGniJMbij2M/OtQL4PnU9/E3EkVqjmysbKh0DNTUFiMC+DqcCwUc4Z/w6A
	YrrrviPLxrz7KECQ==
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Justin Tee <justin.tee@broadcom.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH v1 1/1] scsi: lpfc: Switch to use %ptTs
Message-ID: <20250206174537-a38cd6ae-e0fe-4344-8655-2593e20fd394@linutronix.de>
References: <20250206155822.1126056-1-andriy.shevchenko@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206155822.1126056-1-andriy.shevchenko@linux.intel.com>

On Thu, Feb 06, 2025 at 05:58:22PM +0200, Andy Shevchenko wrote:
> Use %ptTs instead of open-coded variant to print contents of time64_t type
> in human readable form.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/scsi/lpfc/lpfc_init.c | 15 +--------------
>  1 file changed, 1 insertion(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index e360fc79b028..240e92143d73 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -5643,24 +5643,11 @@ void
>  lpfc_cgn_update_tstamp(struct lpfc_hba *phba, struct lpfc_cgn_ts *ts)
>  {
>  	struct timespec64 cur_time;
> -	struct tm tm_val;
>  
>  	ktime_get_real_ts64(&cur_time);
> -	time64_to_tm(cur_time.tv_sec, 0, &tm_val);
> -
> -	ts->month = tm_val.tm_mon + 1;
> -	ts->day	= tm_val.tm_mday;
> -	ts->year = tm_val.tm_year - 100;
> -	ts->hour = tm_val.tm_hour;
> -	ts->minute = tm_val.tm_min;
> -	ts->second = tm_val.tm_sec;
>  
>  	lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT,
> -			"2646 Updated CMF timestamp : "
> -			"%u/%u/%u %u:%u:%u\n",
> -			ts->day, ts->month,
> -			ts->year, ts->hour,
> -			ts->minute, ts->second);
> +			"2646 Updated CMF timestamp : %ptTs\n", cur_time);

All %p<FOO> arguments need to be addresses.
Also %ptT wants a time64_t, not a 'struct timespec64'.
It would work by chance because tv_sec is the first member and time64_t.

Correct: "&cur_time.tv_sec".

>  }
>  
>  /**
> -- 
> 2.43.0.rc1.1336.g36b5255a03ac
> 
