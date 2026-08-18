Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA01443A9D
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 09:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787045233; cv=none; b=JiwylPJD9+DYAHmSzfGSAM32pqgCOYBUckr+11iWiWt7ECJWetBMME07V3HMrBvomlmolc3c6CgybNAj7L/ji85z7AkYt2VDcNTP7E3zqrAff+nrgtLy1iU5DB0iT7rWx80bBskFYL2VFhNXfgouqmoWWHsPeZgbCsk6pVoEoGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787045233; c=relaxed/simple;
	bh=5SYgNcVwkgQC4vfUw0vUZMLGASnSwdnUw0Obx5XgmS4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kJO0djWyYK+U281YkcJxPsrgXbyT/Y1dkW/ZNN7HYRyAtxHPWPimheggv6eoHULEVlleDhKVeZOh+YmmxNfLRjPIUX8KEZBypOK6UVL6ngq4F3uzMEm9xGkTbVyt1rhsw+92RkHccHsAZnxWkxoD+Prx8TuPk+qHDcDyko1Rj6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z9+z3mLL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z9+z3mLL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B8D1F000E9;
	Tue, 18 Aug 2026 09:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787045231;
	bh=Mlmrq9Rmy5M35adR4pB4Iy7McK3Zjn2B78/VF9QVg04=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Z9+z3mLL0Rf55IRGP5yyH32dBpRUugYaNYRZBLdBUM8/v8pJIakH76j28VlvVy9Hf
	 2XaWNIsNfud6EzPj2gQAHrB4NaN/4IrPClMuuTnmG3R+w1dkv+b4Dtq9zJqpMNMV5T
	 OhDa7cMqZhbdcy4cGE+tbqQ/2QFE229B6W0/DOqs/GErh1VfYAirq8vC5up1NcOGHB
	 UyvrzG4N1PUAuDogZdgXu8E6xFnQkTqVql+SBNuUBN7ULw/XIx7qFVokN6WnwVDSTo
	 Kjnzjg7tag/pFWXgJeslq5qBHyKtmMzubKizS+oqEBXGM1+F+t7g9S+YJDfJzWtphV
	 ogec59gSQDAnQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] scsi: target: file: avoid recursive configfs open in
 fd_init_prot()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Runyu Xiao" <runyu.xiao@seu.edu.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260818091326.1582200-1-runyu.xiao@seu.edu.cn>
References: <20260818073539.1555605-1-runyu.xiao@seu.edu.cn>
 <20260818091326.1582200-1-runyu.xiao@seu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 18 Aug 2026 09:27:11 +0000
Message-Id: <20260818092711.87B8D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Reopening an existing PI sidecar file using `dentry_open()` bypass=
es `may_open()` and `inode_permission()` checks.
--

--- Patch [1]: [PATCH v3] scsi: target: file: avoid recursive configfs open=
 in fd_init_prot() ---
commit 12b71238378c9751f15927b9f16e21baaa769408
Author: Runyu Xiao <runyu.xiao@seu.edu.cn>

scsi: target: file: avoid recursive configfs open in fd_init_prot()

This patch fixes a recursive configfs open hazard by avoiding the reopening
of a user-controlled pathname. Instead, it derives the protection sidecar
file from the opened backing file itself and opens it directly.

Link: https://lore.kernel.org/r/20260818073539.1555605-1-runyu.xiao@seu.edu=
.cn

> diff --git a/drivers/target/target_core_file.c b/drivers/target/target_co=
re_file.c
> index 62ced9f5102ff..f6c34e69dbfed 100644
> --- a/drivers/target/target_core_file.c
> +++ b/drivers/target/target_core_file.c
[ ... ]
> @@ -86,6 +90,131 @@ static struct se_device *fd_alloc_device(struct se_hb=
a *hba, const char *name)
[ ... ]
> +static int fd_open_prot_file(struct file *file, int flags, umode_t mode,
> +			     struct file **filep)
> +{
[ ... ]
> +	if (d_is_negative(prot_path.dentry)) {
> +		prot_file =3D dentry_create(&prot_path, flags, mode, current_cred());
> +	} else {
> +		if (!d_is_reg(prot_path.dentry)) {
> +			ret =3D -EINVAL;
> +			goto out_dput;
> +		}
> +
> +		inode_unlock(d_inode(parent_path.dentry));
> +		mnt_drop_write_file(file);
> +		release_dentry_name_snapshot(&backing_name);
> +		kfree(prot_name);
> +
> +		prot_file =3D dentry_open(&prot_path, flags & ~O_CREAT,
> +					current_cred());

[Severity: High]
Does this dentry_open() call bypass standard permission checks?

When reopening an existing sidecar file, this goes straight to dentry_open()
without calling inode_permission() or may_open(). This appears to skip
access controls, including standard permissions, security hooks, and checks
for immutable or append-only file attributes.

If someone with configuration access sets up a backend and links an
immutable file (or one they lack write access to) at the sidecar path,
could they use this to overwrite the file since the permission gates
are bypassed?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818091326.1582=
200-1-runyu.xiao@seu.edu.cn?part=3D1
