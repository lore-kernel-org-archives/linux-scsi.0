Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5D9251791;
	Fri, 28 Feb 2025 20:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740773447; cv=none; b=KtxOd+OJDnKdQmX919a3hq8Qf44YqtB3QqzCkh6IbGSbENCOGBxe83cPdQOcY0Ib/FY865cuGDutkdgY8hUqqiKScT5xMWjrysG/SSekqZqvU6gFLyVmTFEbqhOlyspwEI+xA3teT2O7pSrZnCl3nhzv5cvRWOk31puAHS0GGno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740773447; c=relaxed/simple;
	bh=u1o2k0KyDpnY3J5fmKctnRTEq8YkFZnm9gmNrKfBZI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VNBj8qhY7aPji+TSmkpqwVkW+aAYC0FP/Oxw3qpAxR+KYyPD1ovntcKDxZ+VapsC4eyDqimtF3qhCijVbZ8ZpsAcZN+iSxnEK8bRxznlFP2AxUF6BHeLGbFOkmnKDjQ5g/wNhFenJVzSOnOJNoGxEmoFWmr4+lP68CYIVvQnIF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CeJwB4Qr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CeJwB4Qr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F58C4CED6;
	Fri, 28 Feb 2025 20:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740773446;
	bh=u1o2k0KyDpnY3J5fmKctnRTEq8YkFZnm9gmNrKfBZI8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CeJwB4QrObCemiMdp0wAypHUn/FzoYrvKRijMa4WYunzEHVac1fyNegGOHZ85a2vO
	 eF9OXljGFTeHBNSsxDCJOzXDmDtD4o8/0qSVfQaQe0QpSs5vJUg1jTvcgvzinjX6nq
	 Ovy9FVk7einGFzHi+gc804nCNbISUWHWW3GAQEIZNVmLch+F7fGzdzSaBd9+K6gHny
	 S3+8TaQyHsJQkCdwoYfIktRIgp9B040YErUA9M+nWhFewHi/g4gbE0HsjPI3MnhgjJ
	 KHB5ksQ7a8Ss3lF53+c3fqLee1FnitCZew6vl5q5iPCwOhPqepzixkGGu8sf5gaBp2
	 gGLvqNQqfyjHw==
Date: Fri, 28 Feb 2025 12:10:43 -0800
From: Kees Cook <kees@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-hardening@vger.kernel.org, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: Replace deprecated strncpy() with strscpy()
Message-ID: <202502281204.CE15A6BA35@keescook>
References: <20250226121003.359876-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226121003.359876-1-thorsten.blum@linux.dev>

On Wed, Feb 26, 2025 at 01:10:03PM +0100, Thorsten Blum wrote:
> Since strncpy() is deprecated for NUL-terminated destination buffers,
> use strscpy() instead.
> 
> Compile-tested only.
> 
> Link: https://github.com/KSPP/linux/issues/90
> Cc: linux-hardening@vger.kernel.org
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/target/target_core_configfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index c40217f44b1b..446682f900e4 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -143,7 +143,7 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
>  	}
>  	filp_close(fp, NULL);
>  
> -	strncpy(db_root, db_root_stage, read_bytes);
> +	strscpy(db_root, db_root_stage, read_bytes);
>  	pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);
>  
>  	r = read_bytes;

When doing strncpy() to strscpy() conversions, please include details
of your analysis for several things:

- why is it safe to be NUL-terminated?
- why is NUL padding needed/not needed?
- why is the maximum length argument correct?

In this case, db_root is used with "%s" format strings, so we know it is
expected to be NUL-terminated. Additionally, it is _only_ ever used with
"5s" format strings, so padding is not needed.

As for length, read_bytes will always be less than DB_ROOT_LEN because
it is explicitly tested for against "count" which, enforced by the
SETATTR API, will always be the number of valid bytes in "page", and
snprintf() will be limited to DB_ROOT_LEN. (snprintf may return more
than its length argument, but because of the "count" check, this should
be impossible.)

While you're in this file, though, can you replace the other strncpy
that is used in target_init_dbroot() also?

-Kees

-- 
Kees Cook
