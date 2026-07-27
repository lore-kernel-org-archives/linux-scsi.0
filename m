Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7A5378D8A
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2026 15:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785165261; cv=none; b=acSp8QgFuM7gPbo34AzcBKXSdT85xAsLOdTAjdAo76moHbYqA7WY2BpqVZvcwzclQ9bct4Ez+5+c3rF9/3mqbZkBbyjSG/Vc/VRNgPlr9cMqKkGiSQDTM5du63x3dZTj4DxqypOc+d0VPEEl3JKhDXOopOpbKeXog3nnugD6u34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785165261; c=relaxed/simple;
	bh=1QtvT0ZGR2hOl3OUt9Sbytt82RKDddy7cOCcBo4E70o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iatM/tugyry9CeKbhUJLP4s83r+QTqnGRStN1QZ7yDER7Gjv3Zxuv8WGYJY5N73QKed0p6hdU5DM++dJyOKe0u5yHYdkiT7tzim20h/T/xcL/cmn2SDcVkcpCcICsN1YUL+q5WgDwAmxgclQw2SBDnW8qAol1wynKKOz1j1yIQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NzO+iTjj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NzO+iTjj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41461F000E9;
	Mon, 27 Jul 2026 15:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785165259;
	bh=wvSRa64i/o5xRCGkCKEXIXc5XALcrR/7Qs/weROtUJE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NzO+iTjj9dKKp6vmfQGnBuLevflquYvzkjvR3Zn8IeAu0uRjhA5aHtVp2VEyg5vvO
	 3VWZIiip7ofRYvEQlIe/jsB/6RLvtDxaZ/17uYhvY9ORmTQorDFOuggvY61D2yVdTZ
	 DjQsfu7f9RQU1duGKpHVWeCYue5pKrRDuPTMCDQw7HNawntPGIBaqavY0kR0riCBrp
	 G7s1N2iNWIOiZZ64SN822sKsR5+7wAGAks4r0K4Ck9digucyjCjU4WLIkB5VFJrrrO
	 zYt4fsP74EFO9PY4FZT7dsmqOcA32sQOOorfpZP0fh7SurS8PgCr+REyHiAEHlKb5q
	 OMA/hHT9Uinsg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 22/27] scsi: sd: add multipath disk class
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260727144234.3802948-23-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-23-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 15:14:19 +0000
Message-Id: <20260727151419.B41461F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Empty device release function `sd_mpath_disk_release` violates k=
object API rules, masking a future memory leak or Use-After-Free.
--

--- Patch [22]: [PATCH v5 22/27] scsi: sd: add multipath disk class ---
commit f2a48f7b23ab293ee7178e9c9e97a979e61dbc55
Author: John Garry <john.g.garry@oracle.com>

scsi: sd: add multipath disk class
   =20
This commit adds a new class, sd_mpath_disk_class, which acts as the
multipath version of the scsi_disk class. It also introduces the
sd_mpath_disk structure to manage the multipath gendisk.

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
> +

[Severity: Medium]
Does this empty release function violate the device lifecycle rules?

The kernel core API strictly forbids empty device release functions (often
referred to as 'mocking kobjects'). An empty release callback prevents the
proper freeing of the structure containing the device, which forces the
memory to either be leaked when the reference count drops to zero, or freed
synchronously elsewhere leading to a Use-After-Free.

> +static void sd_mpath_disk_release(struct device *dev)
> +{
> +}
> +
> +static const struct class sd_mpath_disk_class =3D {
> +	.name =3D "scsi_mpath_disk",
> +	.dev_release =3D sd_mpath_disk_release,
> +};

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727144234.3802=
948-1-john.g.garry@oracle.com?part=3D22
