Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1863DDB02
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 07:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787039435; cv=none; b=cKCPHZvroS9Dr3c/X9W2A+5KA8cbNEosQNglsdRlUy6DGbQre1Y47xoi+JzNzPVGL0u5Q2cE9a4xGnpQ/fsVtQFGLx9u5lNSeeNouTwL/5jCIb+3tBhp30+jEF2g7DtYa0QJShQT91slzB7x+lmxL2/8NoAIH24JTCbZdZw4vi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787039435; c=relaxed/simple;
	bh=mMyAtKZpgVmx8PD+nmn4OrogejaOxG6r1p1HuagbdEU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EU/7S1Ba71uxyY6tc/PlHjMwEOS3SZdtCm0yhcTv35l4gHIhBA6HbljSkvQJkSjgtHu/6PXOfSI18GL80i4tvxWgzpwpbEjFK1ulYnx1GMybAbgby9Tl8gKwUeGSOo/ISO/C2ahMt0uUmLe/Irmx+W7U4bG3EYb57dZybhM5SWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jAg73PX2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jAg73PX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E96F1F000E9;
	Tue, 18 Aug 2026 07:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787039433;
	bh=o6wp0vzthGvy9eqVoWnmVfK+QQHootdbcVW0lkgWaAc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jAg73PX2oEmufOsW+0PVuoX+fmyNQepooQGNzwH0JyrGrTK2D9KAzcUd76skOK2PF
	 ICyoFQNYZMwzPxLjNyuQLATSSb0Flfzy1jBZZ6sFvQfJVUCSmAIg4Pph6dGJ6joTsN
	 ON4Pv0kxZ1HDuPiFo+cu2PnqdjJXUzheiQo8dMf6XxDZGT+UPY+ME5e8sNHnMrgzKZ
	 Z19lBejY/+OJejkKiLKuciG/8KKx15LqPfra8y/Ee2Re0oOgn24Yf9FvdAwt24rOgN
	 dOyxFCvMttC33YIwawquOFAU1WHEP9KusHa8oLTVzZxiNI77SHpr43zgTWnovqppJr
	 CjOhNhKWSps6A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: target: file: avoid recursive configfs open in
 fd_init_prot()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Runyu Xiao" <runyu.xiao@seu.edu.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260818073539.1555605-1-runyu.xiao@seu.edu.cn>
References: <20260818045807.1519433-1-runyu.xiao@seu.edu.cn>
 <20260818073539.1555605-1-runyu.xiao@seu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 18 Aug 2026 07:50:32 +0000
Message-Id: <20260818075033.6E96F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [High] Double fetch of `d_name.len` allows concurrent rename to cause a h=
eap buffer overflow and use-after-free
- [High] AB-BA deadlock between the directory inode lock (`i_rwsem`) and fi=
lesystem freeze protection (`sb_writers`)
- [High] Synthesizing a `struct path` using a bind mount's vfsmount and the=
 underlying dcache parent creates an invalid VFS object state
- [High] Opening an existing protection sidecar file does not verify its fi=
le type, allowing an unprivileged user to panic the kernel
- [Medium] Usage of the unexported static function `lookup_one_qstr_excl()`=
 causes build failures, and passing an uninitialized `qstr.hash` corrupts t=
he dcache
- [Medium] Missing validation of the backing file's parent directory and ha=
shed state after acquiring the parent inode lock
--

--- Patch [1]: [PATCH v2] scsi: target: file: avoid recursive configfs open=
 in fd_init_prot() ---
commit dff9df1c1570ab279457bc3f5bedd541efae3c74
Author: Runyu Xiao <runyu.xiao@seu.edu.cn>
scsi: target: file: avoid recursive configfs open in fd_init_prot()

This commit addresses a potential recursive configfs open issue when creati=
ng
protection sidecar files. It introduces fd_open_prot_file() to lookup, and
either create or open the protection sidecar directly from the configured
backing file's parent directory, instead of using filp_open() which might
re-enter configfs.

> diff --git a/drivers/target/target_core_file.c b/drivers/target/target_co=
re_file.c
> index 62ced9f5102ff..9872f8eda1ac4 100644
> --- a/drivers/target/target_core_file.c
> +++ b/drivers/target/target_core_file.c

[ ... ]

> @@ -86,6 +90,86 @@ static struct se_device *fd_alloc_device(struct se_hba=
 *hba, const char *name)
>  	return &fd_dev->dev;
>  }
> =20
> +static bool fd_backing_file_is_configfs(struct file *file)
> +{
> +	return d_real(file_dentry(file), D_REAL_DATA)->d_sb->s_magic =3D=3D
> +	       CONFIGFS_MAGIC;
> +}
> +
> +static int fd_open_prot_file(struct file *file, int flags, umode_t mode,
> +			     struct file **filep)
> +{
> +	struct dentry *backing_dentry =3D file_dentry(file);
> +	struct path parent_path =3D {
> +		.mnt =3D mntget(file->f_path.mnt),
> +		.dentry =3D dget_parent(backing_dentry),
> +	};

[Severity: High]
Does this create an invalid VFS object state if the backing file is a
file-level bind mount?

If the file was provided via a file-level bind mount, the vfsmount's root is
the file itself. Using dget_parent() escapes this root to the underlying pa=
rent
directory, and passing this disjoint path to dentry_open() or dentry_create=
()
could violate VFS invariants.

> +	struct path prot_path =3D { .mnt =3D parent_path.mnt };
> +	struct file *prot_file;
> +	struct qstr prot_qname;
> +	char *prot_name;
> +	size_t prot_name_len;
> +	int ret;
> +
> +	if (fd_backing_file_is_configfs(file)) {
> +		ret =3D -EINVAL;
> +		goto out_put_parent;
> +	}
> +
> +	prot_name_len =3D backing_dentry->d_name.len + strlen(".protection");
> +	if (prot_name_len > NAME_MAX) {
> +		ret =3D -ENAMETOOLONG;
> +		goto out_put_parent;
> +	}
> +
> +	prot_name =3D kmalloc(prot_name_len + 1, GFP_KERNEL);
> +	if (!prot_name) {
> +		ret =3D -ENOMEM;
> +		goto out_put_parent;
> +	}
> +
> +	memcpy(prot_name, backing_dentry->d_name.name, backing_dentry->d_name.l=
en);

[Severity: High]
Is there a risk of a heap buffer overflow here?

The length of d_name is read without locks to allocate prot_name via kmallo=
c().

If an unprivileged user renames the backing file concurrently to a longer n=
ame,
couldn't the second fetch of d_name.len during memcpy() exceed the allocated
buffer size?

> +	memcpy(prot_name + backing_dentry->d_name.len, ".protection",
> +	       strlen(".protection") + 1);
> +	prot_qname =3D QSTR_INIT(prot_name, prot_name_len);
> +
> +	inode_lock_nested(d_inode(parent_path.dentry), I_MUTEX_PARENT);

[Severity: Medium]
Is there a missing check for concurrent renames or unlinks here?

The parent dentry was fetched locklessly via dget_parent(), but there is no
re-validation that backing_dentry->d_parent still matches parent_path.dentr=
y,
or that the dentry is still hashed, after acquiring the inode lock.

> +	prot_path.dentry =3D lookup_one_qstr_excl(&prot_qname, parent_path.dent=
ry,
> +						LOOKUP_CREATE);

[Severity: Medium]
Will this cause a build failure when compiled as a module?

lookup_one_qstr_excl() is a static function in fs/namei.c and is not export=
ed
to modules.

Additionally, prot_qname is initialized above using QSTR_INIT() without
computing its hash. Does passing a qstr with a zero hash to low-level VFS
functions force dentries into bucket 0 and corrupt the dcache hash table?

> +	if (IS_ERR(prot_path.dentry)) {
> +		ret =3D PTR_ERR(prot_path.dentry);
> +		goto out_unlock;
> +	}
> +
> +	if (d_is_negative(prot_path.dentry)) {
> +		ret =3D mnt_want_write_file(file);

[Severity: High]
Does this invert the standard VFS lock ordering and risk an AB-BA deadlock?

The directory's i_rwsem is currently held via inode_lock_nested(), and
mnt_want_write_file() internally acquires sb_writers (read). The standard
order is sb_writers before i_rwsem, so this could deadlock against a
filesystem freeze which takes sb_writers exclusively.

> +		if (ret)
> +			goto out_dput;
> +
> +		prot_file =3D dentry_create(&prot_path, flags, mode, current_cred());
> +		mnt_drop_write_file(file);
> +	} else {
> +		prot_file =3D dentry_open(&prot_path, flags & ~O_CREAT,
> +					current_cred());

[Severity: High]
Is there a check missing to ensure the existing protection sidecar is a reg=
ular
file?

If an unprivileged user preemptively creates a symlink named with .protecti=
on,
opening it directly via dentry_open() triggers a WARN_ON in do_dentry_open()
because symlinks generally have a NULL i_fop. This can panic the kernel on
systems with panic_on_warn.

> +	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818073539.1555=
605-1-runyu.xiao@seu.edu.cn?part=3D1
