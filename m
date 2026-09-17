Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCE33AB26B
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 11:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789643866; cv=none; b=HKNGAG1f76RcIVcAfVkMtxIdfkn5ZxZm8QopGPA+w2ZOwfJf+8n+i22n6PN9czNvl5PliQIzCCYL55WyUGPuiUAbjPVjH7FZ2J0qHSPhslf0NjGsHo4qBM2gR+EUEr97ldQVGm4twDB9pQkcrX8Q8e0bIU7xAhLJdIhU1SYTGkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789643866; c=relaxed/simple;
	bh=7B1sMkE/hk3cskMBzckmdKT/vXmvOQiiDcO60spH958=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mu2s9RHqxAIrmnQJK8TVkyMMliEMe96Lf7p4N6139dd/Rao/MQlGpSp3Zd7d1HUZzONr03OwOZf7zkUbKeP6eYcDCM6juQ0h/IcH2+9fOg1Nmv+RD39+HozllFRWGw+rpQans4j04mRsvcKAQi88vVJde4W4s8ubrT6I4d4Mra8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Eawl6eIV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eawl6eIV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFE91F00893;
	Thu, 17 Sep 2026 11:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789643859;
	bh=wU/s0m/VLNj8OmvJANMU2Wxq/enQsOBVBG3oWnfzn7Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Eawl6eIV9WnYizJIgIvDmYJgi2N1e+XrrwmQ+IXBjjOtYm6yGlFDALxVxSpoV80il
	 ScgXaAxodgS5gLjMLFBhiDiSUx7ZWg/a/n1Qvn8gBQaudaIe/MRNsn7m2E9pffsvwR
	 LB/JlrERXbT9rHgns9NL66nCIPNnWTVauWpvBpHkICGjZSyNyeBSNco+y6UQuG/+NZ
	 9KQfq1SqLKyCpV4v/h56L/mLMDoLdPNH26UuHgWJy8IR7J3lcz061IdgwFHCY8IPVR
	 e1gwu7sqCnJUntcsdb2drxLqRI3omb4/IRCz+GqPwaHLSFWnAGbReU9UkUaW2RqZtI
	 HMhLoQrrWvEkA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/4] scsi: scsi_debug: Do not advance the write
 pointer of a failed write
Reply-To: sashiko-reviews@lists.linux.dev
To: "Niklas Cassel" <cassel@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260917110316.1104863-7-cassel@kernel.org>
References: <20260917110316.1104863-6-cassel@kernel.org>
 <20260917110316.1104863-7-cassel@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 11:17:38 +0000
Message-Id: <20260917111738.DFFE91F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: scsi_debug: ZBC specification violation by returning GOOD st=
atus without advancing WP
- [Medium] scsi: scsi_debug: integer overflow in short write check allows i=
ncorrect WP advancement
--

commit 2b6fea07514157218eac4ea45ff1ba17e05b5125
Author: Niklas Cassel <cassel@kernel.org>

scsi: scsi_debug: Do not advance the write pointer of a failed write

This commit modifies the write pointer advancement logic for ZBC sequential
write required zones. It ensures the write pointer is only incremented when
all requested data is successfully written.

> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 6941809dfdb75..3ce2dbdff177c 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -5150,8 +5150,8 @@ static int resp_write_dt0(struct scsi_cmnd *scp, st=
ruct sdebug_dev_info *devip)
>  	if (unlikely(scsi_debug_lbp()))
>  		map_region(sip, lba, num);
> =20
> -	/* If ZBC zone then bump its write pointer */
> -	if (sdebug_dev_is_zoned(devip))
> +	/* If ZBC zone then bump its write pointer, if all data was written */
> +	if (sdebug_dev_is_zoned(devip) && ret =3D=3D num * sdebug_sector_size)

[Severity: Medium]
Could the multiplication num * sdebug_sector_size overflow 32-bit arithmetic
for large num? If the module is loaded with a capacity >=3D 4GB, an extreme=
ly
large num and an empty data-out buffer might cause do_device_access() to
safely return 0. If the multiplication overflows and evaluates to 0, this
check might erroneously pass and incorrectly advance the write pointer.

[Severity: High]
If do_device_access() returns a short count due to a small data-out buffer,
this check prevents advancing the write pointer. However, the function then
proceeds to return 0 (GOOD status) without calling scsi_set_resid(). Does
this violate the ZBC specification, which requires that if a write terminat=
es
with GOOD status, the write pointer must be advanced by the transfer length?

Could this lead to silent data corruption or UNALIGNED WRITE COMMAND errors
on subsequent sequential writes?

>  		zbc_inc_wp(devip, lba, num);
>  	if (meta_data_locked)
>  		sdeb_meta_write_unlock(sip);

[ ... ]

> @@ -5314,8 +5314,8 @@ static int resp_write_scat(struct scsi_cmnd *scp,
>  		 * writes behaviour as possible.
>  		 */
>  		ret =3D do_device_access(sip, scp, sg_off, lba, num, group, true, true=
);
> -		/* If ZBC zone then bump its write pointer */
> -		if (sdebug_dev_is_zoned(devip))
> +		/* If ZBC zone then bump its write pointer, if all data was written */
> +		if (sdebug_dev_is_zoned(devip) && ret =3D=3D num_by)

[Severity: Medium]
Does the num_by variable suffer from a similar 32-bit overflow issue?

Earlier in resp_write_scat(), num_by is calculated as num * lb_size. If
this truncates to 0 on a massive transfer, could this condition falsely
match a 0-byte return from do_device_access(), tricking the driver into
advancing the write pointer anyway?

[Severity: High]
Similar to resp_write_dt0(), if this skips the write pointer advancement for
scattered writes on short buffers, it still continues and eventually returns
0 (GOOD status) at the end of the function. Should this set a residual count
when skipping the write pointer increment to avoid ZBC specification
violations?

>  			zbc_inc_wp(devip, lba, num);
>  		if (unlikely(scsi_debug_lbp()))
>  			map_region(sip, lba, num);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917110316.1104=
863-6-cassel@kernel.org?part=3D1
