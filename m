Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358B13939A3
	for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2026 08:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790498351; cv=none; b=OpFeg5+JnqBuYufPu/3pZV5jkow0pKAFZRztHohXBKVhlpVWV8nAJWlBUO7O/4VF41jQOA9REy8L/fAON5w3tPgnpHgOZqkefZNaKrE2WEbQDPZOwjBuUxQsaxGYQiVl422zrRNBe5rUo3H5bejj5+L/IQAP/c0UAoIMV9Y6c6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790498351; c=relaxed/simple;
	bh=U2j2jIcwd9BeQQ7n571CXix9eVZ7r1O6Pujr1OG+gdw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=C4TcgkaBnr6wUU9lYHtpUyEtYv+XOch+ZMtAJZ1az1KSNX1FMgmXrX3e23f6TUXc/sXb9tR/T7OoQvwSui6I5IAkcKxAzHQ30m/oRe3SEha54Awr1H4EyBWFT3+zGAbdTynIFuhTLy50xijXfUrxPHmUGclPyoSNWYrMNm8wFxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hn+TqeDB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hn+TqeDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2EC21F000FF;
	Sun, 27 Sep 2026 08:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790498349;
	bh=eezotKX/Tz4GrH2XWA/Mtz8/iRXp412jLzLGGv4JoFo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hn+TqeDBtA5FJrXVZvZmD9wRcCdxSOug89vJj8Y6darEzVlALy53+3RdlN9CRe8qd
	 m1M/DJ0KXYPEzaZIfr8LSi3S+SPOVYVB2/O9gHZklGFXpVCjVD7Y/LKrpYYu+Ml6dq
	 cAFdcbtDTvCoLYoC4Yk2bSdswDsVBYz+6JIrcJjVlhEgL5LzxO3C2L8rX3qsjd4gVh
	 6Mn2+EGIA656nOYIJJiTwISnVDe6pubCvI5MTog9xtwbG1lGpcCyKb7X15FcUlI/l7
	 uEGbwmvKmsWj5yu9HzPUdWqG8WG45BCpwhbcgcfZh4DYcq3XQxp0kjShMHKe526O4T
	 KXEWqFhSCuDSA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 1/4] fs: configfs: add helpers for opening
 non-configfs paths
Reply-To: sashiko-reviews@lists.linux.dev
To: "Runyu Xiao" <runyu.xiao@seu.edu.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260927082011.638723-2-runyu.xiao@seu.edu.cn>
References: <20260927082011.638723-1-runyu.xiao@seu.edu.cn>
 <20260927082011.638723-2-runyu.xiao@seu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 27 Sep 2026 08:39:09 +0000
Message-Id: <20260927083909.A2EC21F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] fs: deadlock bypass in configfs_open_root() via mountpoint trave=
rsal
--

commit 493a740e66f883a25d1e14e7e3f3596fe9f2721a
Author: Runyu Xiao <runyu.xiao@seu.edu.cn>

fs: configfs: add helpers for opening non-configfs paths

This commit adds configfs_file_open() and configfs_open_root() to allow
configfs store callbacks to open non-configfs paths without re-entering
configfs. It checks if the provided root is on configfs to prevent
acquiring the non-recursive fragment semaphore again.

Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>

> diff --git a/fs/configfs/mount.c b/fs/configfs/mount.c
> --- a/fs/configfs/mount.c
> +++ b/fs/configfs/mount.c

[ ... ]

> +struct file *configfs_open_root(const struct path *root, const char *nam=
e,
> +				int flags, umode_t mode)
> +{
> +	if (root->dentry->d_sb->s_type =3D=3D &configfs_fs_type)
> +		return ERR_PTR(-EINVAL);
> +
> +	return file_open_root(root, name, flags, mode);

[Severity: Medium]
Could this bypass the deadlock prevention if a configfs mount exists inside=
 the
starting directory?

The check against configfs_fs_type only validates the starting root directo=
ry's
superblock. However, file_open_root() can traverse mountpoints.

If a user mounts configfs inside the non-configfs root directory, the final
resolved file could still be on configfs.

If this happens during a store callback that already holds frag_sem,
file_open_root() opening the file will trigger configfs_open_file(). This
would try to acquire down_read(&frag->frag_sem) again, which could result
in a deadlock.

> +}
> +EXPORT_SYMBOL_GPL(configfs_open_root);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260927082011.6387=
23-1-runyu.xiao@seu.edu.cn?part=3D1
