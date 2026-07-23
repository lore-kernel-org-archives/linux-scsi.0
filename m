Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91F43F3283
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 10:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784803637; cv=none; b=rpuHZTyMamltgZdNaBGGjQuDtsfHty2qwf/3WkgTdGR1/s9DaDr5B02Fqp0u9igq4R0VLp6itHXqmaO+EHlrWXXthtj8BZRfWJxbckedWi/o2DBHQy5UVx2pqUTKqvA7SUKh5kp7N5h/3yKTCUetTgm4gcspqItkHIJuBP4yNdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784803637; c=relaxed/simple;
	bh=E5O/4TXt8zstXcrSBI4rZzgyjywl2uUyCfywFc3yk5A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cVjWS0ZMTQ7/qEtMit9k8K/KqCgMW2BVd9ASFCj5nXhjBklB5y9zHK7WkMgnfCqVM8+69eJ0zQ0nCCtz882CgwijdgPjhN7lGlnRG7+umXvysuzRJUpIYRE10HM9IkmOMksce4stVH6lYV+aE9MdEX8Tx4oEhkjazqNdjmChMhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O3vvguTo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O3vvguTo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7599B1F000E9;
	Thu, 23 Jul 2026 10:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784803634;
	bh=1d6ahl0Pqvqj7tZxcvdZtTXybSRfojqXxJiW6ol2Jw0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=O3vvguToHZfGJMe+yxHCkZMB3b24G1gtXY22KQMHeKO/YD8AGC4gg4FlNRLLb4BYR
	 y2mJkvREUUvfSABqUqAzHpzhHrjQcC9JERVEysM6oaPPsKDQ3O7mJgB4JfLXuKsEkC
	 /qdoXWmr7GXP52Xg2kGkG2+Op/DczdXjCUfcK4n0Z3G8nZUSJ6Zpaalndjsq9OPKtu
	 QQqtWzIVWMKg1YYfnyjxX87ptv7By5ts+X2XQVHCiKgY2nV4EhxCKspPzXzKP83s3R
	 920wDvcvsVa56NfnG96QkYydudd/L9y05adwd3RtqHJp+0aDinO/+/9Ypl/CTr+3fL
	 0MWGlETjG9MLg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 24/28] scsi: sd: add multipath disk attr groups
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723093627.2327456-25-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-25-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 10:47:13 +0000
Message-Id: <20260723104714.7599B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The patch defines the `sd_mpath_disk_attr_groups` sysfs attribut=
e group and its associated callback functions but never assigns it to any d=
evice or class (e.g., `sd_mpath_disk_class`). This leaves the multipath sys=
fs attributes entirely unexposed and the new code dead.
--

--- Patch [24]: [PATCH v4 24/28] scsi: sd: add multipath disk attr groups -=
--
commit d9075e7051637dd60fcce05f493768de652548d9
Author: John Garry <john.garry@linux.dev>

scsi: sd: add multipath disk attr groups

This commit adds sysfs attribute groups for multipath disks, including
delayed disk removal and the existing mpath attribute group.

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 242a15bc2c5bb..36c745cbb2619 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
[ ... ]
> +static const struct attribute_group sd_mpath_disk_attr_group =3D {
> +	.attrs		=3D sd_mpath_disk_attrs,
> +};
> +
> +__maybe_unused
> +static const struct attribute_group *sd_mpath_disk_attr_groups[] =3D {
> +	&sd_mpath_disk_attr_group,
> +	&mpath_attr_group,
> +	NULL
> +};

[Severity: Medium]
Are these attribute groups actually registered anywhere? It looks like
sd_mpath_disk_attr_groups is defined and marked __maybe_unused, but never
assigned to a device or class to expose the sysfs attributes to userspace,
leaving this code essentially unreachable.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723093627.2327=
456-1-john.g.garry@oracle.com?part=3D24
