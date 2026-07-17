Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDDF344DB7
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 19:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784316195; cv=none; b=MCNAjezWBS0wYOQ9pxJQja3/SLwoGaQ0RDqOA0upw3L4ySE/C5uHO3y9Wt8wMnL8p1Usf1xsrMlk7WLUB1A4FLVoiRvpJiS5APBBH34moMyjjMnagpAd8lT1aBpFZnAtpyqrJTth0OC2ZAQodoSesw6IExvhdrLgHHbrkCQzCSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784316195; c=relaxed/simple;
	bh=5OU+hdol/tJTEObWCtmpxaXkO60hW07sNPrZ9URg5aY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=T5vZhZy2G6EuffEReANIMN1wR82A1nSaMmptix2LUt9+AKnzjgi2kwVUvi0DgfrXg9APnlyvsc4jUDIoC9zLXs75Hdi5SRPXBv6JfNriPjkQzD2TOWR8oz2LMVWGkbe5LutZ4wDyds8b8QOMu0UsCbKJapmx3dICUNqqUR8tRT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BClU60qA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BClU60qA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D791F000E9;
	Fri, 17 Jul 2026 19:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784316193;
	bh=rp4MAO5IjuZ3/p4k5435UwWDsorLGHq5k1pE5/wAUOs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BClU60qAqlhXdTZ4oKivD7JZL+UcT/meShG/0SHXlStAJL37qzq151GEFs12eM9+a
	 OVjz7tPLU02e+Ov7YV+U2BKy1aoM/oApdTBkwP7cDkwqD2vLYY9PzmI/1QL9a+NcJk
	 HaGlcemnf9ZVLEDR2yyuDWZby4960Blv/Z9XA4tBoYFqgtpZVOwwpbgHsOB+doWaFz
	 MRSCRnPj/AZErkxZsFc+EcNn4Vm0D0Ny5KQoCMe/MNrgnIItlYjp5gp7DSQL2UBDXy
	 /cd/b9TeWGe53/WcgjJ+vIVQYiNFc+B3mtG3JSFyF59HDkz89MT5PLUdYoyrG4Ubru
	 9w6c1F0+4QL6Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: sd: validate device-supplied mode sense lengths
 in cache_type_store
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jay Vadayath" <jay@artiphishell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717191023.15011-1-jay@artiphishell.com>
References: <20260717191023.15011-1-jay@artiphishell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 19:23:13 +0000
Message-Id: <20260717192313.93D791F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Stack out-of-bounds read and write in `scsi_cdl_enable` due to=
 unvalidated device-supplied mode sense lengths.
- [High] Data race on `struct scsi_disk` bitfields between `cache_type_stor=
e` and `sd_revalidate_disk`.
--

--- Patch [1]: [PATCH] scsi: sd: validate device-supplied mode sense length=
s in cache_type_store ---
commit 58b82fd0109d95a6ff61d8f8d2790723466ad640
Author: Jay Vadayath <jay@artiphishell.com>

scsi: sd: validate device-supplied mode sense lengths in cache_type_store

This commit adds bounds checking to cache_type_store() to prevent an
out-of-bounds stack access when parsing device-supplied MODE SENSE lengths.
It explicitly verifies that the combined header and block descriptor
lengths do not exceed the on-stack buffer size before calculating offsets.

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 599e75f333343..4234ce314c9d9 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c

[ ... ]

> @@ -268,10 +268,19 @@ cache_type_store(struct device *dev, struct device_=
attribute *attr,
>  	if (scsi_mode_sense(sdp, 0x08, 8, 0, buffer, sizeof(buffer), SD_TIMEOUT,
>  			    sdkp->max_retries, &data, NULL))
>  		return -EINVAL;
> -	len =3D min_t(size_t, sizeof(buffer), data.length - data.header_length -
> -		  data.block_descriptor_length);
> -	buffer_data =3D buffer + data.header_length +
> -		data.block_descriptor_length;
> +
> +	/*
> +	 * The mode parameter header and block descriptor lengths are
> +	 * supplied by the device and must not be trusted (e.g. a malicious
> +	 * USB mass storage device).  Reject responses that would place the
> +	 * caching mode page (of which we touch the first three bytes)
> +	 * outside of the buffer to avoid an out-of-bounds access below.
> +	 */
> +	offset =3D data.header_length + data.block_descriptor_length;
> +	if (offset + 3 > sizeof(buffer))
> +		return -EINVAL;

[Severity: High]
This is a pre-existing issue, but does modifying bitfields in cache_type_st=
ore()
create a data race with other device events?

Earlier in this same function, the code directly modifies sdkp->cache_overr=
ide:

drivers/scsi/sd.c:cache_type_store() {
    ...
    if (strncmp(buf, temp, sizeof(temp) - 1) =3D=3D 0) {
        buf +=3D sizeof(temp) - 1;
        sdkp->cache_override =3D 1;
    ...
}

Concurrently, during a device rescan or hotplug event, sd_read_cache_type()
modifies adjacent bitfields in the same struct:

drivers/scsi/sd.c:sd_read_cache_type() {
    ...
    sdkp->DPOFUA =3D (data.device_specific & 0x10) !=3D 0;
    ...
}

Since bitfield updates are read-modify-write operations, could a concurrent
sysfs write to cache_type silently corrupt other bitfields like DPOFUA
or lbpme if they aren't protected by a shared lock?

[Severity: Critical]
This is a pre-existing issue, but does a structurally identical out-of-boun=
ds
vulnerability exist in scsi_cdl_enable() in drivers/scsi/scsi.c?

Looking at scsi_cdl_enable(), the same device-supplied lengths are used to
calculate an offset into an on-stack buffer without bounds checking:

drivers/scsi/scsi.c:scsi_cdl_enable() {
    ...
    buf_data =3D buf + data.header_length + data.block_descriptor_length;
    ...
    buf_data[4] &=3D ~0x03;
    ...
}

If a malicious USB device returns a large block_descriptor_length, could
this calculation exceed the stack buffer bounds and lead to memory corrupti=
on,
just like the issue fixed here in cache_type_store()?

> +	len =3D min_t(size_t, sizeof(buffer) - offset, data.length - offset);
> +	buffer_data =3D buffer + offset;
>  	buffer_data[2] &=3D ~0x05;
>  	buffer_data[2] |=3D wce << 2 | rcd;
>  	sp =3D buffer_data[0] & 0x80 ? 1 : 0;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717191023.1501=
1-1-jay@artiphishell.com?part=3D1
