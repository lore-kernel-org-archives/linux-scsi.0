Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C9464A
	for <linux-scsi@vger.kernel.org>; Sat, 24 Feb 2024 00:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708734411; cv=none; b=n08syGpHeeWmMrzRWJnerbzL5G7ucdXploBzSOSf1IM0QLx04amIBqmMZQSMozOhNIVXCb4LOgVsUSorSxea6E5dv856Iid+ruY3Jkd/y+X/hO7zC5x5VcATfRcuDwEFuCuRTFBlqG4My/RaCfWf7vl5/o6RHdrM9ULZq/kS8TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708734411; c=relaxed/simple;
	bh=89gfB0d+BJREK94VWt9BdGlk8fqarMCLKkJpNTQiYVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eIzrsHZAEQmbLRDjmDuSaXu0dXExrDw/gIABmefUS+FN8aMBswaIO2bzXUR9hFq9YipaZIQ1BSHEOy2I6FcIrwIOTRYmEwYHm3INujo4oeYNlxRvNvrNGd3Jmol9jL6nEmXpL5gutmaMf2mmy0U0YHyubLeldsL72B/9UHrZ5F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=nwx3sIlT; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="nwx3sIlT"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2997cb49711so573990a91.3
        for <linux-scsi@vger.kernel.org>; Fri, 23 Feb 2024 16:26:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1708734408; x=1709339208; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6k+51jbRVVMRx/YTEEUvH1e+s7J14iTbluUWT/oq6hw=;
        b=nwx3sIlTXije6cmCHkgws1LzyToQrGylwTwiQnj9UHnl33EYRYKAGA6IP9Wl22TTyn
         cS+m+ChFkyfRM0M4b0AUV0fcr0Pzl7DK6ZYtBlX55AyVAdDJ3e7epGRLdk7VTb2mtme1
         oltKUbUEfQmejwko6zNc4AujJB2FmTWag0g0I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708734408; x=1709339208;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6k+51jbRVVMRx/YTEEUvH1e+s7J14iTbluUWT/oq6hw=;
        b=cGvEzJgpMGCZC2xOGitkvPUwORCCVg2/wX6NnLKFsfwQySRQAYUZdGXi3Y8rWsu6oG
         va0/JPAIwSWYVaurjwImab0hBjAMcNGstcgin7FmwHhW74bYCjS2tP9rYnaiPsF0WBq0
         +i7EnJl12yCQgu8mHC/r9L26rGB06DUDfHQHurH8sqhLb+yLAC/IAmUsJO8lYn0kq5qA
         eulFXx/lfvjo8k+K1ZXh44ifMWpTqw0DEs6/EwTKaB2uiVMML4DIh7r6Hsg7B36x/9Vn
         GXrYGnUZW7yBPknqNdxYgUyc/06cFoyv2daJPYrihdQqeZoCmAGkcPMDaf9tIvqY5k1v
         EaeQ==
X-Forwarded-Encrypted: i=1; AJvYcCWVhDS+TBVWxeeGORhbowEAZgvEkR4P3gUyUcDd9ralW3ksTXBUARNPFNTjVW9mTGNOgNekHQkNPFLxO1vEPWn61lmfnDJQKacd9A==
X-Gm-Message-State: AOJu0YxdumpZHG5CvCteW4guj6tUj+YH3ZTqejB3roXwvMzuOjYh8RqB
	AcvLNXQtPVzacx+p+K+Oc0u1dhtUbXp6V734ZVttF2Ox1Q10SVx8u04uUcZnNg==
X-Google-Smtp-Source: AGHT+IHqqByA9RSEB3GXMAbMamhab9AoXKYL3v8UVitxmQZRj5Za8VGsJ6Bh42u273xtu3ctiuMp7w==
X-Received: by 2002:a17:90b:358b:b0:299:544c:4933 with SMTP id mm11-20020a17090b358b00b00299544c4933mr1481060pjb.14.1708734408218;
        Fri, 23 Feb 2024 16:26:48 -0800 (PST)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id g8-20020a17090a640800b00298975077d0sm2070777pjj.19.2024.02.23.16.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Feb 2024 16:26:47 -0800 (PST)
Date: Fri, 23 Feb 2024 16:26:47 -0800
From: Kees Cook <keescook@chromium.org>
To: Justin Stitt <justinstitt@google.com>
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ariel Elior <aelior@marvell.com>,
	Manish Chopra <manishc@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	Don Brace <don.brace@microchip.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	MPT-FusionLinux.pdl@broadcom.com, netdev@vger.kernel.org,
	storagedev@microchip.com
Subject: Re: [PATCH 5/7] scsi: devinfo: replace strncpy and manual pad
Message-ID: <202402231625.0192BA6F@keescook>
References: <20240223-strncpy-drivers-scsi-mpi3mr-mpi3mr_fw-c-v1-0-9cd3882f0700@google.com>
 <20240223-strncpy-drivers-scsi-mpi3mr-mpi3mr_fw-c-v1-5-9cd3882f0700@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223-strncpy-drivers-scsi-mpi3mr-mpi3mr_fw-c-v1-5-9cd3882f0700@google.com>

On Fri, Feb 23, 2024 at 10:23:10PM +0000, Justin Stitt wrote:
> Depending on the state of @compatible, we are going to do different
> things with our @to buffer.
> 
> When @compatible is true we want a NUL-term'd and NUL-padded destination
> buffer. Conversely, if @compatible is false we just want a space-padded
> destination buffer (no NUL-term required).
> 
> As per:
> /**
>  * scsi_dev_info_list_add_keyed - add one dev_info list entry.
>  * @compatible: if true, null terminate short strings.  Otherwise space pad.
> ...
> 
> Note that we can't easily use `strtomem_pad` here as the size of the @to
> buffer is unknown to the compiler due to indirection layers.
> 
> Now, the intent of the code is more clear (I probably didn't even need
> to add a comment -- that's how clear it is).
> 
> Signed-off-by: Justin Stitt <justinstitt@google.com>
> ---
>  drivers/scsi/scsi_devinfo.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
> index 3fcaf10a9dfe..2d3dbce25629 100644
> --- a/drivers/scsi/scsi_devinfo.c
> +++ b/drivers/scsi/scsi_devinfo.c
> @@ -293,14 +293,16 @@ static void scsi_strcpy_devinfo(char *name, char *to, size_t to_length,
>  	size_t from_length;
>  
>  	from_length = strlen(from);
> -	/* This zero-pads the destination */
> -	strncpy(to, from, to_length);

A rare case of the padding intent being expressed! :)

> -	if (from_length < to_length && !compatible) {
> -		/*
> -		 * space pad the string if it is short.
> -		 */
> -		memset(&to[from_length], ' ', to_length - from_length);
> -	}
> +
> +	/*
> +	 * null pad and null terminate if compatible
> +	 * otherwise space pad
> +	 */
> +	if (compatible)
> +		strscpy_pad(to, from, to_length);
> +	else
> +		memcpy_and_pad(to, to_length, from, from_length, ' ');

Yeah, this is much nicer to read.

Reviewed-by: Kees Cook <keescook@chromium.org>

(Some day I want to rename "memcpy_and_pad" ... the "and" seems
verbose...)

-- 
Kees Cook
