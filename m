Received: from smtp.smtpout.orange.fr (smtp-17.smtpout.orange.fr [80.12.242.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2129E218ADD;
	Sat,  6 Jun 2026 21:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780781922; cv=none; b=fgXZo9A4gNdK7YMFL2vjWhqGd8I8bqn2AzqU/7xvOhi8SZoKhAm2f4MLKN9fOpybRizGsxm8Lz5zLyjvf7GLNhe9WE9F08v3gCY0JEMkha+0EFRx6XhaNeRdbKi9r2bQ8Kba0Z3M4ndiLFBIH/nQGDRKvkwtvcBSi1I5W/iuLws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780781922; c=relaxed/simple;
	bh=th2anrzf31Q9eYbbC/St/bnu1dqbxVyP7dAolWSpaNc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VLgNjaKM5AUgyGHbr+ieMPoGqEdlo+R4fhpe9ZMBanmKK0xKJYtKvQ6Ey4v3Ze3SLw9u1d74LE+3t0EYEu0GKbpEbL4/kX7QI8UyiM7BqKdglRBfQQEGRd6cR8dDe1JTh75YnG+kjB56nFw4KLGB8GBaLGi2cDT1IQSEhQRJ06E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=kb3ZpW1D; arc=none smtp.client-ip=80.12.242.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="kb3ZpW1D"
Received: from [IPV6:2a01:cb10:785:b00:8347:f260:7456:7662]
 ([IPv6:2a01:cb10:785:b00:8347:f260:7456:7662])
	by smtp.orange.fr with ESMTPSA
	id VyiqwzoTNPtxAVyiqwYEMg; Sat, 06 Jun 2026 23:38:30 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1780781911;
	bh=fRopwsI+LtIK+AcPNDztTFYPATnMaepA05vHYWcn6T0=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=kb3ZpW1DJJe6PT6TxLDpSYXTddYxmjIJTffbwn/g+A85wCMcOuprOJJ0HvhXSHM86
	 +VC5zWV2XnFUqBXWQwzWYEdABrjn1+BT9g+rFB09F86UyaX69kYPiOoXicLWQBR2Fv
	 Wj+T0FamAUzPMftTgOvp0/ahiStHNZ/mjQbQKQA6fKM0/MZj40PmyDqS9mc3XPysdV
	 vs0WMpjHDZYrZvwlUDZFVqtaEor3/h+XJylUFbE4o9EzQHZfA5QfgUTZrXHOC9d0Im
	 wB9tcM/wob/6WxhwsRGw2AJTukUCb3IfUsHLDIwCSGeBYufZajEoHTo3MoVTv5gWYT
	 ARIDt6Go3heSg==
X-ME-Helo: [IPV6:2a01:cb10:785:b00:8347:f260:7456:7662]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 06 Jun 2026 23:38:31 +0200
X-ME-IP: 2a01:cb10:785:b00:8347:f260:7456:7662
Message-ID: <1b1d419d-5974-4d15-8f5e-58050a83ce2e@wanadoo.fr>
Date: Sat, 6 Jun 2026 23:38:27 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next] drivers/scsi/aic7xxx/aic7xxx_osm: Use kstrdup()
 instead of kmalloc() and strcpy()
To: david.laight.linux@gmail.com, Kees Cook <kees@kernel.org>,
 linux-hardening@vger.kernel.org, Arnd Bergmann <arnd@kernel.org>,
 linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20260606202633.5018-33-david.laight.linux@gmail.com>
Content-Language: en-US, fr-FR
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20260606202633.5018-33-david.laight.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 06/06/2026 à 22:26, david.laight.linux@gmail.com a écrit :
> From: David Laight <david.laight.linux@gmail.com>
> 
> Signed-off-by: David Laight <david.laight.linux@gmail.com>
> ---
> This is one of a group of patches that remove potentially unbounded
> strcpy() calls.
> 
> They are mostly replaced by strscpy() or, when strlen() has just been
> called, with memcpy() (usually including the '\0').
> 
> Calls with copy string literals into arrays are left unchanged.
> They are safe and easily detected as such.
> 
> The changes were made by getting the compiler to detect the calls and
> then fixing the code by hand.
> 
> Note that all the changes are only compile tested.
> 
> Some Makefiles were changed to allow files to contain strcpy().
> As well as 'difficult to fix' files, this included 'show' functions
> as they really need to use sysfs_emit() or seq_printf().
> 
> All the patches are being sent individually to avoid very long cc lists.
> Apologies for the terse commit messages and likely unexpected tags.
> (There are about 100 patches in total.)
> 
>   drivers/scsi/aic7xxx/aic7xxx_osm.c | 8 +++-----
>   1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> index d93b522695eb..d6237aa5beac 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> @@ -1101,12 +1101,10 @@ ahc_linux_register_host(struct ahc_softc *ahc, struct scsi_host_template *templa
>   	ahc_lock(ahc, &s);
>   	ahc_set_unit(ahc, ahc_linux_unit++);
>   	ahc_unlock(ahc, &s);
> -	sprintf(buf, "scsi%d", host->host_no);
> -	new_name = kmalloc(strlen(buf) + 1, GFP_ATOMIC);
> -	if (new_name != NULL) {
> -		strcpy(new_name, buf);
> +	snprintf(buf, sizeof (buf), "scsi%d", host->host_no);
> +	new_name = kstrdup(buf, GFP_ATOMIC);

I think that kasprintf() would simplify code and do the same.

CJ

> +	if (new_name != NULL)
>   		ahc_set_name(ahc, new_name);
> -	}
>   	host->unique_id = ahc->unit;
>   	ahc_linux_initialize_scsi_bus(ahc);
>   	ahc_intr_enable(ahc, TRUE);

