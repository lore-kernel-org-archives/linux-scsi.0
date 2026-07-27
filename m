Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BCB62771B
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2026 15:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785165624; cv=none; b=nbFmu2ETSBn+WnHPHgCPaViucRvtBQOpntxOU6xfUN/iJrAYk8q5X9x5ciagL6HtWgt9NEGjlYgs2By2iKtpatPXIAGl456Lw9bCi3Fn6It2iJHGT2l73XznoQhE/aXoHaxKkvmowr5L3oZqbDlpcAp8bDBpdyCDmGVTFp+EzvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785165624; c=relaxed/simple;
	bh=fgy5a5z97H6JhxcfmCHTSUq+Ep+znOLF8cy1QOQe+wA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Akuyf2hT/yXz5ww2jdhcuSdmWDuthUOO3tUHqdrVx6nBlL/yk3uF0fjFOzHRfiybINhAFZcANkeAUyiX3z+O9CQDRk0Ay3CDZUxv/5/+eaOjwMdPQOggvLkCvyIxKWL+purZVeBHQ+G5goNfy2fO0Ct2pLmtu4JpEre0HdjWRok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n37AU7w8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n37AU7w8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01CC1F000E9;
	Mon, 27 Jul 2026 15:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785165622;
	bh=JtJnwJ9MmTYwh3HXnGbM/vhw+k42aLIVpVzqEartroI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n37AU7w8ZfPHduf5SUi3F/mBk4xlU8SA2tL5FBtqXgaBVCiP//ZsNUZK1U2wkMgLU
	 3veX1Q36kLcrHEnTjzpJcf6/0TZIJMaZ8J9DVyHG/537jiOZsmNb4xUjU4SF19YN3q
	 n42/8gtQfb+1y7mk9LycWR7AqKMOTv+XXthh8mBjb9a4kxw7Z9VBeIWwNexCiigb4K
	 h7PBRNWuXqLMrujdaMxb7tfjxlil7YQRlDsLVwxCh0+gX4pjnP57sODc5HvXrjl/5p
	 bSg02pt+pls1k+Yy017TSHowcKGf4lfE09V1GO3EeNX3q1eyE1T0n3aAqXb23JCzNI
	 qMRUY+UQrcNBA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 23/27] scsi: sd: add multipath disk attr groups
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260727144234.3802948-24-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-24-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 15:20:22 +0000
Message-Id: <20260727152022.C01CC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The newly defined multipath disk attribute groups are completely=
 unreferenced and never hooked up to the multipath structures, rendering th=
e feature inactive.
--

--- Patch [23]: [PATCH v5 23/27] scsi: sd: add multipath disk attr groups -=
--
commit 54820f0d02e2f6d8f0530b7358f2376bde300894
Author: John Garry <john.garry@linux.dev>

scsi: sd: add multipath disk attr groups

This commit adds sysfs attribute groups for multipath disks in the SCSI
subsystem. It defines attributes for delayed disk removal and includes
everything from the existing mpath attribute group.

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
Are these newly defined multipath disk attribute groups missing a registrat=
ion
step?=20

They are defined here and explicitly marked with __maybe_unused, but do not
appear to be assigned to any registration structure or hooked up to the act=
ive
multipath structures. Does this leave the new feature inactive and the
attributes unexposed to userspace?

> +
>  /**
>   *	sd_probe - called during driver initialization and whenever a
>   *	new scsi device is attached to the system. It is called once

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727144234.3802=
948-1-john.g.garry@oracle.com?part=3D23
