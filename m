Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9073D47A0
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 05:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787029981; cv=none; b=SuIE0QAUNx0ZRrbeVIGbsNqDdcu6BKUdL8F07xJbPyrR6Cja21ah4jD7eFZa7wpVi56AHJpRmtENz3nuLS0Lc8Zzm1nJ6bvPuGUAa/tGCQM/ksu42ZddJF6dkJOOsNJDTg+Xwd00kC8a2YbOR3HdMUQNfHWP31/d+a9OQyNjHOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787029981; c=relaxed/simple;
	bh=cQqqfDOSl3Rqj8YgCil5mVpDXLIl01IBs+m8/rOmUqo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jmM8/e9fmEMLoipbcskZylTLnlPGfxTk8hEUCx94bEv0mFMzL4TskheaMq9ial1aIw0R7FlKCqf3fTWcSc4E4x8IFok0sRhuDw/Kvqo2xSqJzQ1tlWX2lh67S2trEYHTSdrJTRqyAnzyH1hJq+4KQ6WBCmKshIvfz+YSvT7Eb4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WedrJFCn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WedrJFCn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0D31F00A3A;
	Tue, 18 Aug 2026 05:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787029979;
	bh=n18gRcuVPFFNTFNmBmy0pIJmxxIQ5FZo6tSaVb12ukI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WedrJFCntRcG4FyKpoqP5z+bNa/hAz1FLXvtpXIMRuFEN7aBIv8sibtVmjGSOd/TK
	 irhvT1n1MtzoUdVJuBXeY+ndjxHTfbS63wBuCJR4wcWso9oMskNejcg7kmr2BHRTTW
	 tCexcWqzFCFGkYB8d7BN7lRtn6bf0+bg1o3/fpxw65lfVbpaEWDrMIC1cNCsmKnPzN
	 JIYTECzLKuDa8xIumLXpfWFbYrej8X1kHfTykX+L8qI7tCz24cIcMzI5HMpzeK2ChR
	 b3gDCthOuIcDu1KvxSB6rqMTtbNoOzlsSnediKjR/riY6IoZfql7vOAreHcVQh6HM6
	 J4fNX9vyOICxA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: target: file: reject configfs-backed paths in
 configfs stores
Reply-To: sashiko-reviews@lists.linux.dev
To: "Runyu Xiao" <runyu.xiao@seu.edu.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260818045807.1519433-1-runyu.xiao@seu.edu.cn>
References: <20260818045807.1519433-1-runyu.xiao@seu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 18 Aug 2026 05:12:56 +0000
Message-Id: <20260818051259.0E0D31F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

New issues:
- [High] A Time-of-Check to Time-of-Use (TOCTOU) race condition allows bypa=
ssing the configfs path validation.
- [High] Validation can be bypassed using stacked filesystems like OverlayF=
S.
- [Medium] Redundant parent directory validation logic guards against an im=
possible deadlock scenario.
- [Low] Call to unexported symbol `kern_path_parent` breaks modular builds.

Pre-existing issues:
- [High] Path validation performs VFS path lookups while holding `frag_sem`=
, creating an AB-BA deadlock with `configfs_rmdir`.
--

--- Patch [1]: [PATCH] scsi: target: file: reject configfs-backed paths in =
configfs stores ---
commit db2f5e66532db6f370e1ba2ab87399c4fbea7e7e
Author: Runyu Xiao <runyu.xiao@seu.edu.cn>
scsi: target: file: reject configfs-backed paths in configfs stores

This commit adds path validation to prevent FILEIO backend paths from
resolving inside configfs, which can cause a deadlock on frag_sem. It
introduces fd_validate_fileio_path() to check the filesystem type of
the resolved path and its parent before calling filp_open().

> diff --git a/drivers/target/target_core_file.c b/drivers/target/target_co=
re_file.c
> index 62ced9f5102ff..ca41e217fa848 100644
> --- a/drivers/target/target_core_file.c
> +++ b/drivers/target/target_core_file.c
[ ... ]
> @@ -86,6 +87,33 @@ static struct se_device *fd_alloc_device(struct se_hba=
 *hba, const char *name)
>  	return &fd_dev->dev;
>  }
> =20
> +static int fd_validate_fileio_path(const char *path)
> +{
> +	struct path lookup_path =3D {};
> +	struct dentry *dentry;
> +	int ret;
> +
> +	ret =3D kern_path(path, LOOKUP_FOLLOW, &lookup_path);

[Severity: High]
This isn't a bug introduced by this patch, but does performing VFS path
walks here create an AB-BA deadlock with configfs_rmdir()?

A configfs store callback already holds frag_sem for reading. If kern_path()
or filp_open() traverses a configfs directory, it will block waiting for
i_rwsem to be shared. Concurrently, vfs_rmdir() on that configfs directory
holds i_rwsem exclusively and calls configfs_rmdir(), which will block
waiting for frag_sem exclusively.

> +	if (!ret) {
> +		ret =3D !strcmp(lookup_path.dentry->d_sb->s_type->name, "configfs") ?

[Severity: High]
Is this string comparison sufficient to catch configfs files accessed throu=
gh
stacked filesystems?

If the path points to an OverlayFS mount with configfs as a lower directory,
the superblock name will be "overlay", allowing it to bypass this check. The
subsequent filp_open() would then delegate to the real configfs file, still
triggering the frag_sem deadlock.

> +			-EINVAL : 0;
> +		path_put(&lookup_path);
> +		return ret;
> +	}
> +	if (ret !=3D -ENOENT)
> +		return ret;
> +
> +	dentry =3D kern_path_parent(path, &lookup_path);

[Severity: Low]
Does this break modular builds? kern_path_parent() is not an exported
symbol, so building with CONFIG_TCM_FILEIO=3Dm will result in a linker erro=
r.

[Severity: Medium]
Is this parent directory validation necessary?

The configfs filesystem does not implement the .create callback in
configfs_dir_inode_operations. Because of this, if a file doesn't exist,
VFS lookup_open() will return -EACCES before ever calling
configfs_open_file(). It seems a deadlock is structurally impossible for
non-existent files.

> +	if (IS_ERR(dentry))
> +		return PTR_ERR(dentry);
> +
> +	ret =3D !strcmp(lookup_path.dentry->d_sb->s_type->name, "configfs") ?
> +		-EINVAL : 0;
> +	dput(dentry);
> +	path_put(&lookup_path);
> +	return ret;
> +}
> +
[ ... ]
> @@ -137,6 +165,17 @@ static int fd_configure_device(struct se_device *dev)
>  		flags &=3D ~O_DSYNC;
>  	}
> =20
> +	ret =3D fd_validate_fileio_path(fd_dev->fd_dev_name);
> +	if (ret) {
> +		if (ret =3D=3D -EINVAL)
> +			pr_err("configfs-backed path is not valid for FILEIO backend: %s\n",
> +			       fd_dev->fd_dev_name);
> +		else
> +			pr_err("FILEIO backend path lookup failed for %s: %d\n",
> +			       fd_dev->fd_dev_name, ret);
> +		goto fail;
> +	}
> +
>  	file =3D filp_open(fd_dev->fd_dev_name, flags, 0600);

[Severity: High]
Can a Time-of-Check to Time-of-Use (TOCTOU) race happen here?

There is a window between fd_validate_fileio_path() returning success
and filp_open() resolving the path again. A user could provide a path
containing a symlink, wait for the validation check to complete, and then
replace the symlink to point into configfs before filp_open() is called,
bypassing the protection.

[ ... ]
> @@ -847,6 +886,17 @@ static int fd_init_prot(struct se_device *dev)
>  	snprintf(buf, FD_MAX_DEV_PROT_NAME, "%s.protection",
>  		 fd_dev->fd_dev_name);
> =20
> +	ret =3D fd_validate_fileio_path(buf);
> +	if (ret) {
> +		if (ret =3D=3D -EINVAL)
> +			pr_err("configfs-backed path is not valid for FILEIO protection: %s\n=
",
> +			       buf);
> +		else
> +			pr_err("FILEIO protection path lookup failed for %s: %d\n",
> +			       buf, ret);
> +		return ret;
> +	}
> +
>  	prot_file =3D filp_open(buf, flags, 0600);

[Severity: High]
Does the same TOCTOU race exist here between path validation and
filp_open()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818045807.1519=
433-1-runyu.xiao@seu.edu.cn?part=3D1
