Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79A94D5968
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 11:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789644058; cv=none; b=kBvKMuOOVSxp9EvEisvQZmqhQ/7ALCD2QGqmq0/fuu9RPmS1nFjqRvGos+rgYfuurs2gqjyTr6SOD/hmy6Uz+Xi4N5qODo8VKr9pzI95d1tYO1B4cTDZjBi3rEMCMBoGY/3FLPA5kUx1JcoG7O16IaTsI7mrOwTy01l+99W+cDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789644058; c=relaxed/simple;
	bh=V+C8rTx+Q64O3fxgDQzNSmqV/+P1f8JkKlRPj4INu24=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qaDt3lC4HPpQ0ufeNgfkIwXLmAQSvPfGqcdxMsJ5J+4DinPukcEjsWogb1dD6AKljEAR00/ODcT+WazCDp9O0jvVh3Ew8RVQLfbnD0P3sUggZWNKBSRgOVwmB3GeMDrXyflU9ZDqrSDv+9tg6isidMzbGCqvs3XnizPxPrLCc5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZYapJTv/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZYapJTv/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5181F000FF;
	Thu, 17 Sep 2026 11:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789644051;
	bh=cRo2gcX6LFB4e7ywPwV4eoZHiICg0qPjO2L96zTOqKk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZYapJTv/hxir4JUqV3stoYXwgKzeQ2UHMWl8ofBrNGl2144/4nDn1jvI8xSxVTelK
	 HteXTTspuOdMtjPuU89yt8/e9Kdsdop/4IkM5pcVb6Z+pdf4LeZZg3PwbI558HtRu6
	 anshWTf8Ju+6+SCrQyK8ryd6jbynnEDQaxhNJhpCotR2K24L0Ej8XT++O+r9oOXpdk
	 A3bcnWprltasFzXULqAd61yEdIRBto97a29lEZTce7r8mVc3Y9rKkWJ1JW77V4X0D7
	 QMcNMOHaGwCgK+R5whTem1ECEOrjms3NhSIxNYBV2m+od94gzs3h8kyt9zflOiqqDy
	 FBchHX/Z4ne7w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/4] scsi: scsi_debug: Map the region written by
 WRITE ATOMIC (16)
Reply-To: sashiko-reviews@lists.linux.dev
To: "Niklas Cassel" <cassel@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260917110316.1104863-9-cassel@kernel.org>
References: <20260917110316.1104863-6-cassel@kernel.org>
 <20260917110316.1104863-9-cassel@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 11:20:50 +0000
Message-Id: <20260917112051.0F5181F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi_debug: data race between WRITE ATOMIC and UNMAP
--

commit 658af810db2f7f36283a9bf13a41e6b597ba68ec
Author: Niklas Cassel <cassel@kernel.org>

scsi: scsi_debug: Map the region written by WRITE ATOMIC (16)

This commit updates resp_atomic_write() to call map_region() when logical
block provisioning is enabled. This ensures GET LBA STATUS correctly
reports the region as mapped after an atomic write, mirroring the behavior
of standard writes.

> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index ddcc7a920089e..5a08f02130ef6 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -6213,6 +6213,9 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
>  	}
> =20
>  	ret =3D do_device_access(sip, scp, 0, lba, len, 0, true, true);
> +	if (unlikely(scsi_debug_lbp()))
> +		map_region(sip, lba, len);

[Severity: Medium]
Could this introduce a data race with concurrent unmap operations?

In resp_unmap(), unmap_region() modifies the data buffer via memset() and
clears map bits while protected only by sdeb_meta_write_lock(sip), never
acquiring the data lock macc_data_lck. Normal writes like resp_write_dt0()
explicitly acquire sdeb_meta_write_lock(sip) when scsi_debug_lbp() is true
to safely serialize data access with concurrent unmap operations.

However, resp_atomic_write() does not acquire sdeb_meta_write_lock(sip)
when scsi_debug_lbp() is true. It only holds the data lock via
sdeb_data_lock(sip, atomic) during do_device_access(). Since unmap holds
macc_meta_lck and the atomic write holds macc_data_lck, they appear to be
unsynchronized, leading to potential data corruption in the scsi_debug
simulated RAM disk buffer and provisioning map.

While a later patch in this series adds sdeb_meta_write_lock(sip) to
resp_atomic_write(), it appears to do so only for the
sdebug_dev_is_zoned(devip) condition, leaving the scsi_debug_lbp() race
unmitigated in the final state of the series.

Should sdeb_meta_write_lock(sip) be acquired to protect the provisioning
map modifications?

> +
>  	if (unlikely(ret =3D=3D -1))
>  		return DID_ERROR << 16;
>  	if (unlikely(ret !=3D len * sdebug_sector_size))

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917110316.1104=
863-6-cassel@kernel.org?part=3D3
