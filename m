Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89B239FDD
	for <linux-scsi@vger.kernel.org>; Thu, 28 Mar 2024 23:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711667659; cv=none; b=V0YF3OzdFfxhfv2Vh2klWGS75FL3E7i32PFsDujpZGY+D7wCd96qUn1MtxRA/iOTQd/OBuZPz+dGR2QnOznDfh/+0KsfILOBdIx29fyoPvQOQ28sNCh0fL42CjrvKkvUFZFOChdYWzxy98NCIZtuUBFnzYpWNVnFmKxw+kpi2bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711667659; c=relaxed/simple;
	bh=WiXIsSsAAXXP8GI+Q+1vrfltJK8d/e6I9B7eNWiEYqc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tZ09gmW9CjjQ23Am2IPwml9PVWrFfAlcgD7a1p7Ek/3m8j7h1sg59AMyxngLCSdRv9DYBMMmen09F/Cl4zYAkZaN/9O8ujZpj0Cg84siQqjRdnpv2pgZBd/ZsxTX5RNzSSPQq5ocE7ud+A1L80xGNPlqp3tjm5gzkkNCKxHBQlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xjIPwrrx; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xjIPwrrx"
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-36899d11c2cso7534055ab.1
        for <linux-scsi@vger.kernel.org>; Thu, 28 Mar 2024 16:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711667657; x=1712272457; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=msb6psWW+3hiWjyOBZ+wbNycHLPrZ3SKQfLCbuKlM1E=;
        b=xjIPwrrxGEe9Z6zlKB+rcM+faEAPHSin0lwmRTCaif+L+ZTlC3eu5Q980FouZmdqi1
         e3sSCo9ebTGVyBYIrt7cDEYHDWfM0GffYrIfdCogDcl6nDDxuU1PJMxI8t/45ZyWqIEp
         K2g0wlW/spnOrITVaTAbJIOWTjREgtb77jorYJsciLATA4Dx32vt4kd97mIbdsYLuqeb
         zvPwwthVv5Qx2tVKeZchZlRQgpkGHY0uqe6gT1AMLWWrfxigSkZfOJJhiDXyJAiiDnmF
         aEkb75458gOAvvRuA02U9yf1OQjU9KXMEp2K3D9xEfY9vHkSzb6vHAktZ+Rf6sIwHgUZ
         YdpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711667657; x=1712272457;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=msb6psWW+3hiWjyOBZ+wbNycHLPrZ3SKQfLCbuKlM1E=;
        b=FcxPLO+qmuPSchPif8gHZt/eLAZkMormtqnQCsg2fZFoymHaYHujexeQUQGSopevce
         K/vrYcTVJs0COY5ioB05E1toD9o/t6WX4oMMm9WhvINNzgRGYCXZ+8PcN/ZfFTp4eMdU
         24IeXr7tn0KAbhvXMwOa4Edj1uZ3/xbPiD7b8dTusTMWRoF2tR3Zgi9zRyLUDq4h7SEz
         Xy1fhss+yQQLstA7lJggFDS63aslfUQj7yK1CrcmQvqz/rI8Aqe662XB9haOjgc/Yxzz
         Fn8oV52eKlEvdfDLxuLM5Ri9ajKtK5LSEM/V5lim1z3oJBxKgox19vPz0lqgyP28baJ4
         pgRQ==
X-Forwarded-Encrypted: i=1; AJvYcCXa/HJWg1/jfd++txfwSyow7dmQEMansMg2IpV4RmnWzSPSrnrbI3UX+jIOGWRzzcn1N8Yix1Tal8Y3mahnViZabSbHUqL7XPew+w==
X-Gm-Message-State: AOJu0YykpbiHL6aisqwAuwRqcNonLDcZCUGTiiCYk6FRrFy8CR6CZYwu
	jI7I3FYjw3oPccw+ks1GnI/WadEE6fu4cY6Di7dboUC0dmuI7zRwq6xCNDAGPA==
X-Google-Smtp-Source: AGHT+IFKvQ7/53HFcbFk+6y1y4y4CvPYxbZdNZKdrmpFm8anXm7QVAyOCuYkU0VDmFYqYVvqla7/vw==
X-Received: by 2002:a05:6e02:10cf:b0:366:99e7:aa9 with SMTP id s15-20020a056e0210cf00b0036699e70aa9mr2200970ilj.2.1711667657098;
        Thu, 28 Mar 2024 16:14:17 -0700 (PDT)
Received: from google.com (30.64.135.34.bc.googleusercontent.com. [34.135.64.30])
        by smtp.gmail.com with ESMTPSA id l10-20020a05663814ca00b0047edace1dc8sm732jak.137.2024.03.28.16.14.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 16:14:16 -0700 (PDT)
Date: Thu, 28 Mar 2024 23:14:13 +0000
From: Justin Stitt <justinstitt@google.com>
To: Arnd Bergmann <arnd@kernel.org>
Cc: linux-kernel@vger.kernel.org, 
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Arnd Bergmann <arnd@arndb.de>, Chris Down <chris@chrisdown.name>, 
	Petr Mladek <pmladek@suse.com>, Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 02/11] scsi: devinfo: rework scsi_strcpy_devinfo()
Message-ID: <opeccmuhptoldyr2xfwstb4uwwgfiupk3kmjkxvke2itq6cuyn@jcx4v3a5ww2f>
References: <20240328140512.4148825-1-arnd@kernel.org>
 <20240328140512.4148825-3-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328140512.4148825-3-arnd@kernel.org>

Hi,

On Thu, Mar 28, 2024 at 03:04:46PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> scsi_strcpy_devinfo() appears to work as intended but its semantics are
> so confusing that gcc warns about it when -Wstringop-truncation is enabled:
> 
> In function 'scsi_strcpy_devinfo',
>     inlined from 'scsi_dev_info_list_add_keyed' at drivers/scsi/scsi_devinfo.c:370:2:
> drivers/scsi/scsi_devinfo.c:297:9: error: 'strncpy' specified bound 16 equals destination size [-Werror=stringop-truncation]
>   297 |         strncpy(to, from, to_length);
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Reorganize the function to completely separate the nul-terminated from
> the space-padded/non-terminated case. The former is just strscpy_pad(),
> while the latter does not have a standard function.
>

I did the same in a patch sent earlier (few weeks ago):

https://lore.kernel.org/all/20240305-strncpy-drivers-scsi-mpi3mr-mpi3mr_fw-c-v3-5-5b78a13ff984@google.com/

Maybe reviewers can chime in on which version is preferred and go from
there.

> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/scsi/scsi_devinfo.c | 30 ++++++++++++++++++++----------
>  1 file changed, 20 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
> index ba7237e83863..58726c15ebac 100644
> --- a/drivers/scsi/scsi_devinfo.c
> +++ b/drivers/scsi/scsi_devinfo.c
> @@ -290,18 +290,28 @@ static struct scsi_dev_info_list_table *scsi_devinfo_lookup_by_key(int key)
>  static void scsi_strcpy_devinfo(char *name, char *to, size_t to_length,
>  				char *from, int compatible)
>  {
> -	size_t from_length;
> +	int ret;
>  
> -	from_length = strlen(from);
> -	/* This zero-pads the destination */
> -	strncpy(to, from, to_length);
> -	if (from_length < to_length && !compatible) {
> -		/*
> -		 * space pad the string if it is short.
> -		 */
> -		memset(&to[from_length], ' ', to_length - from_length);
> +	if (compatible) {
> +		/* This zero-pads and nul-terminates the destination */
> +		ret = strscpy_pad(to, from, to_length);
> +	} else {
> +		/* no nul-termination but space-padding for short strings */
> +		size_t from_length = strlen(from);
> +		ret = from_length;
> +
> +		if (from_length > to_length) {
> +			from_length = to_length;
> +			ret = -E2BIG;
> +		}
> +
> +		memcpy(to, from, from_length);
> +
> +		if (from_length < to_length)
> +			memset(&to[from_length], ' ', to_length - from_length);
>  	}
> -	if (from_length > to_length)
> +
> +	if (ret < 0)
>  		 printk(KERN_WARNING "%s: %s string '%s' is too long\n",
>  			__func__, name, from);
>  }
> -- 
> 2.39.2
> 
Thanks
Justin
