Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDCD479896
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 16:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785342819; cv=none; b=RQiKslrOxZDLcFmJM9UrWjmEmk1mWx9O7R9dHfmso5ONn/Gp+itySZPnssMUOqgfV2n3Ev0lN38hwFV6Uom6Iyk5bJcTpIfgoyBlxhVm1I5RQSDuJiIUr0LBl1BuN6vCu/muGmgMJklI0/y6ulOuJvvFfrJqoyfp6VZnnXaVzwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785342819; c=relaxed/simple;
	bh=zxs8besaDg7t50gq06hxqVQrdKILcnflYeMkQxDY+q8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=U+AfixBNV2SY6VrE9hPEJ4smh/WCKQnZqgYBGokC6R1wjVV0ti1zWDhev37FHrlRSquuqre0A7xOQuyePDgp1XpHJYDmWgILo3Xa5kb2iHqHsfIhg3p3l/7kMcLJu6KxMtm4M9+sj0aexwbsNFy4N+FkAM4VFiqEh6QBkLKrDQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YVHHfnDM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YVHHfnDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE111F00A3A;
	Wed, 29 Jul 2026 16:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785342818;
	bh=UJCdwvt/rdI0z/zCkAK94f66R51V7jtWtCBVv5LuQTg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YVHHfnDMFGKtzv6gaKfrkLuebuzHtzhEmNaM/3HqC1JX+Mrzb0ziJsNz6DZzMRDPZ
	 mkyIbcPVEZQa+BfNwB9oOcwG33UAOo6l+Y9sb2ECPoz7YK7rE/e88sfT3/WCwQ5hk3
	 nbm0JWWLLptJbi2fGi5nIkxPfLgWVogGoNlL2yttN/dMi7LXL1a1Rous2a/esRTST7
	 k3EvY52V20demAI0+AIb9eHEmCuhtH8/oAOEKzG19G4G8gOm935m5fNhte8AU3ZohV
	 8rI+eBt6p6gbrtptUhzCQzn6HaI2H0woUnj4qeauqt2SsJ9Mpv8rKJQFzV84ffFira
	 L4yO/8daIYPHQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 22/27] scsi: sd: add multipath disk class
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260729105107.255712-23-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
 <20260729105107.255712-23-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 16:33:37 +0000
Message-Id: <20260729163338.1EE111F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Empty `dev_release` callback `sd_mpath_disk_release` bypasses devi=
ce/kobject memory management.
- [Medium] Struct `sd_mpath_disk` is incomplete and fails to manage the mul=
tipath gendisk as claimed.
--

--- Patch [22]: [PATCH v6 22/27] scsi: sd: add multipath disk class ---
commit f604e0ae8b45c7be3d202656fafcb45e6c81e7cf
Author: John Garry <john.g.garry@oracle.com>

scsi: sd: add multipath disk class

Add a new class, sd_mpath_disk_class, which is the multipath version of
the scsi_disk class. Structure sd_mpath_disk is introduced to manage the
multipath gendisk.

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 599e75f333343..242a15bc2c5bb 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
[ ... ]
> @@ -113,6 +114,39 @@ static mempool_t *sd_page_pool;
>  static mempool_t *sd_large_page_pool;
>  static atomic_t sd_large_page_pool_users =3D ATOMIC_INIT(0);
>  static struct lock_class_key sd_bio_compl_lkclass;
> +#ifdef CONFIG_SCSI_MULTIPATH
> +struct sd_mpath_disk {
> +	struct scsi_mpath_head		*scsi_mpath_head;
> +};

[Severity: Medium]
The commit message states that sd_mpath_disk is introduced to manage the
multipath gendisk. However, does this struct lack a struct gendisk pointer
and an embedded struct device? Without these, it doesn't appear capable of
fulfilling its documented purpose of managing the multipath disk.

> +
> +static void sd_mpath_disk_release(struct device *dev)
> +{
> +}

[Severity: High]
Is it safe to provide an empty dev_release callback here?

When a device is assigned to sd_mpath_disk_class and its reference count
reaches zero, this callback is invoked. Providing an empty release callback
circumvents proper resource cleanup, silencing kobject warnings while
guaranteeing that the enclosing structure is never actually freed.

Could this cause a memory leak of the device structure during teardown?

> +
> +static const struct class sd_mpath_disk_class =3D {
> +	.name =3D "scsi_mpath_disk",
> +	.dev_release =3D sd_mpath_disk_release,
> +};

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729105107.2557=
12-1-john.g.garry@oracle.com?part=3D22
