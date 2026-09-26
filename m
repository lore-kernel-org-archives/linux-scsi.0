Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FB83BB57
	for <linux-scsi@vger.kernel.org>; Sat, 26 Sep 2026 09:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790415502; cv=none; b=cGkzV9uIhLTXddw7F6RPQ5Hfr7LjwKxY20KTSAmL1ChhVMnYP4SUBp9CTLiKHjFcWWZIQPxKFNqyEYfKrsqgUXluTleL7SxIoHUsrWrR1LAfEqt34qsNmVWJkrhS4pbLjjHWpcnC6FWzAQzzkqChQgOzjfYm18mSqJAgI8CDH7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790415502; c=relaxed/simple;
	bh=KveynFbi+uq9G2R4BQH3zmBHw1nwef7goKHTY/asa2k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=D4ltxwaCEGx8PURPfioAPIU803N+Yl24K5o9/2u4Eam30STxFpxWi7B58nIeuMMxD0ivNRhUeFlNZ2Ql7SUK61Rs0Aw8BOc8bAtNGWnUob4EXvleOrMkimG0p/2hAMqgVezb6DTdm8xrQPZL28C8Z5jm06vvrIPkLt8+ksv803I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=giLAvB2U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="giLAvB2U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93E51F000FF;
	Sat, 26 Sep 2026 09:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790415500;
	bh=NysTwdGiUVnMwXAgY9bSD+nZ7HghKKjTJyGbH3FHN20=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=giLAvB2UlgIFzIqYW8w7owgKYAbMLvNXgZVwpvablJCChIhnPIob50a8U0mee8kin
	 0W7tQZaQ67D3SqKgXtb95I02RyhGP7EpWrxoD9JXIBcWP5qxu3kdDyVITfcMVnQ2c6
	 RzNtvUA4VPi9k7aBGm2VnVWWxtAA24oXrin95fTUX6z8tqxrZqsPT8eQCWS/uFj0vP
	 Q+2tUNB7ZVOK9Ab8YS1d079WCMfNbKjBndgjr/PKCwTYBzS6fcGaavs8W4wKyNLvGH
	 JIr3/kQIhmf0lXrnymleTlwArk89/s+yHBVl9YsnRmqVL+8pAVeKVXrbeMwrM4JDYP
	 y3QrxBWhDnF8g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 1/4] fs: configfs: add helpers for opening
 non-configfs paths
Reply-To: sashiko-reviews@lists.linux.dev
To: "Runyu Xiao" <runyu.xiao@seu.edu.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260926092148.128937-2-runyu.xiao@seu.edu.cn>
References: <20260926092148.128937-1-runyu.xiao@seu.edu.cn>
 <20260926092148.128937-2-runyu.xiao@seu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 26 Sep 2026 09:38:20 +0000
Message-Id: <20260926093820.B93E51F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] fs: configfs: configfs_file_open() ignores O_NOFOLLOW flag
--

commit 76452a998ac4b5def9cd38ece0706188bd3e3ed4
Author: Runyu Xiao <runyu.xiao@seu.edu.cn>

fs: configfs: add helpers for opening non-configfs paths

This commit adds configfs_open_root() and configfs_file_open() to allow
configfs store callbacks to open non-configfs paths without re-entering
configfs and acquiring the same non-recursive semaphore again.

> diff --git a/fs/configfs/mount.c b/fs/configfs/mount.c
> --- a/fs/configfs/mount.c
> +++ b/fs/configfs/mount.c

[ ... ]

> @@ -118,6 +119,58 @@ static struct file_system_type configfs_fs_type =3D {

[ ... ]

> +struct file *configfs_file_open(const char *filename, int flags, umode_t=
 mode)
> +{
> +	struct file *file;
> +	struct path path;
> +	int ret;
> +
> +	ret =3D kern_path(filename, LOOKUP_FOLLOW, &path);

[Severity: Medium]
Does hardcoding LOOKUP_FOLLOW here bypass the caller's O_NOFOLLOW intent if
it is provided in the flags?

If a caller invokes configfs_file_open() with flags containing O_NOFOLLOW
on a symlink, kern_path() will unconditionally resolve the symlink. The
resolved target is then passed to file_open_root() via configfs_open_root().
Because file_open_root() only checks if the resolved target itself is a
symlink, this successfully bypasses the O_NOFOLLOW intent, silently
traversing the symlink instead of failing.

> +	if (ret)
> +		return ERR_PTR(ret);
> +
> +	file =3D configfs_open_root(&path, "", flags, mode);
> +	path_put(&path);
> +	return file;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260926092148.1289=
37-1-runyu.xiao@seu.edu.cn?part=3D1
