Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B953BB57
	for <linux-scsi@vger.kernel.org>; Sat, 26 Sep 2026 09:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790415445; cv=none; b=RNvXAK4XTV+jR3LEAnz3FurHy8lcwZOKXVougeTu2ivzGOv7CKfTX9OkIlRvpJWa46P71Je0RKDeuGKFf3AJNvoX7Toe7yeiywZ8hf2MoaZf+wo3f9C7y12DDe/ZMM6V2PNxlsUCkgmvVhyF2jJ5BUQh4evxFoeccP2bCuwj2rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790415445; c=relaxed/simple;
	bh=YtbJVVgcbvW2SqIjR5HOOrFMR9fXPNnIwYEhMIcLt2w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=IufQ6MDLrZTFJhv9Kag+0KQXrA9a5X+fGcv6PZYaJXbgai61xew4uiMHY31+NcY1zsM8dAHs0DumyBvuS34bU1S7ZJSam7zLb/ZX2/h3GohxLECCZG1YLQ8CSt1a3dbI7sf8AFSObE1vzbDjtCDcHKLdBYZYYjp7bwR6gyskmHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n444Fdpr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n444Fdpr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1230A1F000FF;
	Sat, 26 Sep 2026 09:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790415444;
	bh=T6WXZysHHeqTOVFcTN95/oSk/rpyNAMl8Gu52Yzg3EY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n444Fdpr1uS4ugJwbPasJT4o/sKpIZbDhdMpUcPUH3WSONI8rIsSEBgtdieBRoEiQ
	 BrAyYtuRbdQHegHJcmqW8U+VCIhUzrSIXszDobqkgDzWO8zJhHsgrjBqREjicmoch3
	 5ew7TWrfjeHRZo8vHUkXzJMYO79YO9uBPMAVN+OQJzcaOvUIiyjAD6kjXe5f6BwVyR
	 VQt3u/8MN7s7Tw9ZJgKUnenfHJqRUgrTcOXI27X/Z0LzN0ERA1dTARnqMS31LduRWS
	 PPzlLsIAhARLcrGaoT40QH5QyKbxzyQCc586EjCjA60oKirnTR3VCJlGG1kz9Np0vz
	 dB5Dl2w3h8eSQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 4/4] scsi: target: pin db_root for metadata writes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Runyu Xiao" <runyu.xiao@seu.edu.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260926092148.128937-5-runyu.xiao@seu.edu.cn>
References: <20260926092148.128937-1-runyu.xiao@seu.edu.cn>
 <20260926092148.128937-5-runyu.xiao@seu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 26 Sep 2026 09:37:23 +0000
Message-Id: <20260926093724.1230A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] target: use-after-free and torn read of db_root_path during concur=
rent configfs write
- [Medium] target: target_core_item_dbroot_store returns 0 on error
--

commit c0795bea7761bae07f37ffbb11cf3b1c3410422d
Author: Runyu Xiao <runyu.xiao@seu.edu.cn>

scsi: target: pin db_root for metadata writes

This commit addresses metadata file path resolution in the target subsystem
by resolving db_root once and pinning the resulting path. It aims to
prevent re-entering configfs while holding frag_sem and bypasses via
retargeted symlinks.

Link: https://lore.kernel.org/r/20260818051442.1523210-1-runyu.xiao@seu.edu=
.cn

> diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_co=
re_alua.c
> --- a/drivers/target/target_core_alua.c
> +++ b/drivers/target/target_core_alua.c
> @@ -862,20 +861,23 @@ static int core_alua_write_tpg_metadata(
>  	loff_t pos =3D 0;
>  	int ret;
> =20
> -	if (tsk_is_kthread(current)) {
> -		scoped_with_init_fs()
> -			file =3D filp_open(path, O_RDWR | O_CREAT | O_TRUNC, 0600);
> -	} else {
> -		file =3D filp_open(path, O_RDWR | O_CREAT | O_TRUNC, 0600);
> +	if (!db_root_path.dentry) {

[Severity: High]
Is it possible for this lockless read of db_root_path to race with a
concurrent configfs store operation?

Since ALUA configuration state can be updated for a LUN even when there are
no backend devices present (meaning target_devices evaluates to 0), a
concurrent write to the dbroot configfs attribute wouldn't be blocked.
Could this lead to a torn read of the path structure?

> +		pr_err("db_root is not initialized for ALUA metadata path: %s/%s\n",
> +		       db_root, path);
> +		return -ENODEV;
>  	}

[ ... ]

> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/targe=
t_core_configfs.c
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
[ ... ]
> @@ -107,46 +141,70 @@ static ssize_t target_core_item_dbroot_show(struct =
config_item *item,
>  static ssize_t target_core_item_dbroot_store(struct config_item *item,
>  					const char *page, size_t count)
>  {
[ ... ]
> +	r =3D target_validate_db_root(db_root_stage, &path);
> +	if (r)
> +		goto free_stage;
> +
> +	mutex_lock(&target_devices_lock);
> +	if (target_devices) {
> +		pr_err("db_root: cannot be changed because it's in use\n");
> +		goto unlock_put;
>  	}

[Severity: Medium]
At this point in the execution flow, r is 0 because the call to
target_validate_db_root() succeeded. If we take this goto unlock_put path
due to target_devices being non-zero, doesn't this result in returning 0 to
userspace instead of an error code like -EINVAL?

> -	path_put(&path);
> =20
> +	have_old_path =3D db_root_path.dentry;
> +	if (have_old_path)
> +		old_path =3D db_root_path;
> +	db_root_path =3D path;
> +	path =3D (struct path){};

[Severity: High]
Can this non-atomic update of db_root_path race with the lockless readers in
the metadata write paths?

Since the target_devices check above allows this write to proceed when there
are no backend devices, could this result in a use-after-free or invalid
pointer dereference if the old path is freed while being concurrently
accessed by ALUA or virtual_lun0 PR metadata writers?

>  	strscpy(db_root, db_root_stage);
>  	pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);
> =20
>  	r =3D read_bytes;
> =20
> -unlock:
> +unlock_put:
>  	mutex_unlock(&target_devices_lock);
> +	if (path.dentry)
> +		path_put(&path);
> +	if (have_old_path)
> +		path_put(&old_path);
> +	kfree(db_root_stage);
> +	return r;

[ ... ]

> diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core=
_pr.c
> --- a/drivers/target/target_core_pr.c
> +++ b/drivers/target/target_core_pr.c
> @@ -1965,16 +1964,21 @@ static int __core_scsi3_write_aptpl_to_file(
>  	int ret;
>  	loff_t pos =3D 0;
> =20
> -	path =3D kasprintf(GFP_KERNEL, "%s/pr/aptpl_%s", db_root,
> -			&wwn->unit_serial[0]);
> +	path =3D kasprintf(GFP_KERNEL, "pr/aptpl_%s", &wwn->unit_serial[0]);
>  	if (!path)
>  		return -ENOMEM;
> =20
> -	scoped_with_init_fs()
> -		file =3D filp_open(path, flags, 0600);
> +	if (!db_root_path.dentry) {

[Severity: High]
Similar to the ALUA metadata path, could this locklessly access db_root_path
while it is being updated?

For virtual_lun0, this function can execute when target_devices is 0,
potentially colliding with the configfs writer and leading to a torn read.

> +		pr_err("db_root is not initialized for APTPL metadata path: %s/%s\n",
> +		       db_root, path);
> +		kfree(path);
> +		return -ENODEV;
> +	}
> +
> +	file =3D configfs_open_root(&db_root_path, path, flags, 0600);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260926092148.1289=
37-1-runyu.xiao@seu.edu.cn?part=3D4
