Received: from smtp.smtpout.orange.fr (smtp-15.smtpout.orange.fr [80.12.242.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB913CAE76;
	Sat,  6 Jun 2026 21:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780782169; cv=none; b=AG24kyeMFX8WdrWsYWUgffelIVxWjh86+wD10N+7tnA/6SPXEiK/PLAujYIaRYTLZqYo1b01LhUQ9OM6uLAGKjTMxON3dImD2KeYLbrlth8abVNcKVb8G4rS6wt/JlYzP6QAXTlKRkr9w24DGzWfFgT39LEgd+7vUpJcioasZJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780782169; c=relaxed/simple;
	bh=yPrd+1rNydOLWtJnMKsxEGxyGeswomXF0kX8mX8tMb0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cfHrq6nYf2BnapQ1xsqrfhrE645nd80KyMXcN6tEccHcWCbpzNZuWsNzKx7UuUAj8jDrfggkmPQ83IJHzZ9Q0G01CzDbnaV9CQkYuKYOYWIyxKcduIylmFqscuQ/BzzC/UjLt0l7CPVLyNexsed4/GYm17YGvZzHiyKtFskFmKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=Bs25Rnzt; arc=none smtp.client-ip=80.12.242.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="Bs25Rnzt"
Received: from [IPV6:2a01:cb10:785:b00:8347:f260:7456:7662]
 ([IPv6:2a01:cb10:785:b00:8347:f260:7456:7662])
	by smtp.orange.fr with ESMTPSA
	id Vymrwl9FGlc4mVymrw0Arn; Sat, 06 Jun 2026 23:42:40 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1780782160;
	bh=mqwwAytWVgG1Ww6mpYNbXMwYow8LU48HMujyVeg2fSk=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=Bs25RnzthbEtFgvK7olPg1TGKseAEMnbQMu0hvmSBLu1X5uV0hdzVlX7GQsSvpFZJ
	 tG4BqDG3UuefAC+WA6bdTq6CeivfpEMD0c1+QG0FKJpl4xGsiMJqaiqR3KmnPe6FEr
	 xxbKAUHmiRIHelxm+bUcgum0IProPIoAQccDQs0MngWzuVqF/fv/Y9q8yp6HHqH9ls
	 OusqcazVOdUo1bJI5tKvZj2n6BEd5su/m0/IGdpJY0D+gLAgIkjt5/ne0eaJOwYq7z
	 u3rKoZSeU2f7cllrWwwd6gp89oktKz+PYg7xp/U42a+bU42f0Kmj3swGSsXw5beFGC
	 T72F9plm07McQ==
X-ME-Helo: [IPV6:2a01:cb10:785:b00:8347:f260:7456:7662]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 06 Jun 2026 23:42:40 +0200
X-ME-IP: 2a01:cb10:785:b00:8347:f260:7456:7662
Message-ID: <921d629d-79ac-46c3-8e7e-8ac92a50678a@wanadoo.fr>
Date: Sat, 6 Jun 2026 23:42:36 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next] drivers/scsi/aic7xxx/aic79xx_osm: Use kstrdup()
 instead of kmalloc() and strcpy()
To: david.laight.linux@gmail.com, Kees Cook <kees@kernel.org>,
 linux-hardening@vger.kernel.org, Arnd Bergmann <arnd@kernel.org>,
 linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20260606202633.5018-32-david.laight.linux@gmail.com>
Content-Language: en-US, fr-FR
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20260606202633.5018-32-david.laight.linux@gmail.com>
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
>   drivers/scsi/aic7xxx/aic79xx_osm.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
> index feb1707feb7e..97ebee94230e 100644
> --- a/drivers/scsi/aic7xxx/aic79xx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
> @@ -1233,11 +1233,9 @@ ahd_linux_register_host(struct ahd_softc *ahd, struct scsi_host_template *templa
>   	ahd_set_unit(ahd, ahd_linux_unit++);
>   	ahd_unlock(ahd, &s);
>   	sprintf(buf, "scsi%d", host->host_no);
> -	new_name = kmalloc(strlen(buf) + 1, GFP_ATOMIC);
> -	if (new_name != NULL) {
> -		strcpy(new_name, buf);
> +	new_name = kstrdup(buf, GFP_ATOMIC);

I think that kasprintf() would simplify code and do the same.

Otherwise, s/sprintf/snprintf/ could be done, as in the patch for 
aic7xxx_osm.c

CJ

> +	if (new_name != NULL)
>   		ahd_set_name(ahd, new_name);
> -	}
>   	host->unique_id = ahd->unit;
>   	ahd_linux_initialize_scsi_bus(ahd);
>   	ahd_intr_enable(ahd, TRUE);

