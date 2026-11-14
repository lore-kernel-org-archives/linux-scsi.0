Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794663662;
	b=IzWAzQ/HwOpuj6s1e0JWIUe2Syp4sLKPp7ROYTLSUDfpWQIqweOH2BN1r5dXpdMC/Lek
	 O5mC6dNfFCeZQo8oumOiCBBhAOFyXH2RcqzEnuSyGj8HEg33L0STAcyyTOYl566TOHdae
	 t9TcY0dBK6Gxa7zY2uQGK0GfBMJOipBPe1oFVjzXLbuO40dqajrsjzp1qG6CSfT92gGCQ
	 xr4jxchdKfA/WosCepLOycjsjYVLxIZjgo93HJ1BOIrFri7/VFSR0Ip/hSR/Rzr+ofKvT
	 YbSNmmS7terjfXacScH0FgsytZwp25bkLEShe6rrpMR4FmU10PKdY9aL7nCLkV5GGsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794663662;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=yXQkQV7ghx0H2LCchBrsG02Gbte5BQvNzSrSlI170Mw=;
	b=lfJ0Zc6HhSg8eOFglfRcts4GKXXgS4N0LHKIXfIC3bbTetqIu7oyPKz61MChCofY6XMt
	 vC03UMLFtIYN8QAf1r+t0i0TMafpRH5Hjms8ObzZySH//h4nSfOMPqV1jSUE2HM9crAQP
	 t4ujHsVOQKtXxC74V1bDgNihDz8wHjCLofQnsBBLW7xQrqMonfz7k3y4jQKvs8Vybv22P
	 8n4qW5yg475FsBzl19vpJy4CtveVUiC28cravpcujJRhejaKS/O6kyD5qZBozDX469cxM
	 F4vt7yxiM96V8SA8+oK2cXpNpL4+wWTe0rj/xLR9HueGIRPQu92QYmPje/CdyMhqCfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lmBAsOPf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30AA7606A329;
	Sat, 14 Nov 2026 13:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lmBAsOPf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66CD71F000C4;
	Sat, 14 Nov 2026 13:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794663661;
	bh=yXQkQV7ghx0H2LCchBrsG02Gbte5BQvNzSrSlI170Mw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lmBAsOPfe3o3JaLJ+3oDGJJmLGVY6hAF3tSM3gcWZ1iQrafVf961dhzL/XsCaeGiH
	 GH09TDzUZI8HjZI+icEaMgYAKQiT39BjWBGrgg1c0FcyFD1vGiYBqgh6CN2zXdtPo0
	 G8zLlYuHs0bpRE7qFyKG8f60WQjclKtPOpuPQYZ3Jc/eWVaX4bCXkOIkkCnxwBhaLZ
	 KsMVto+VTz1yzNprKmGZ+rOLvOpbbmQC5iknV/o6rFdWocERI8o2Ex/rNM/H59Eqf6
	 X1wIjaGPZSM01lpgso8X4EBJQts1LTHY82dLV0cVJU5dOvGeEC+ehhgQpAtOXUWRKP
	 3G+b7hu0zPApg==
Message-ID: <sashiko-outbox-214583@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 38/42] fuse: refuse files on pseudo filesystems
 as passthrough backing files
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Jann Horn" <jannh@google.com>, "Chris Mason" <mason@kernel.org>, "Josef
 Bacik" <josef@toxicpanda.com>, "Christoph Hellwig" <hch@lst.de>, linux-nvme@lists.infradead.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Jan Kara" <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, apparmor@lists.ubuntu.com, linux-efi@vger.kernel.org, linux-s390@vger.kernel.org, linux-usb@vger.kernel.org, "Amir
 Goldstein" <amir73il@gmail.com>, "Chuck Lever" <cel@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, "Anna Schumaker" <anna@kernel.org>, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261114-work-loop-pseudo-v2-38-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
 <20261114-work-loop-pseudo-v2-38-98639a2286fb@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 13:40:59 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] fuse: file_check_backing() with FMODE_PATH on unverified ovl
  dentry fails open
--

commit 3377a8521784786f7f79c18bd3aafabd17e04633
Author: Christian Brauner <brauner@kernel.org>

fuse: refuse files on pseudo filesystems as passthrough backing files

This commit calls file_check_backing() in fuse_backing_open_file() to
reject regular files on pseudo filesystems when registering FUSE
passthrough backing files.

> diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
> index 8c21a8a74efb9..7527f3ecb90dc 100644
> --- a/fs/fuse/backing.c
> +++ b/fs/fuse/backing.c
> @@ -147,6 +147,10 @@ static int fuse_backing_open_file(struct fuse_conn *=
fc, struct fuse_backing *fb,
>  		if (inode->i_sb->s_stack_depth >=3D fc->max_stack_depth)
>  			return -ELOOP;
> =20
> +		err =3D file_check_backing(file, FMODE_PATH, 0);
> +		if (err)
> +			return err;

[Severity: Medium]
Can calling file_check_backing() with FMODE_PATH on an O_PATH overlayfs
file trigger a WARN(1) in ovl_d_real() and fail open?

Unlike a normal open(), opening with O_PATH returns from do_dentry_open()
before calling ovl_open() -> ovl_verify_lowerdata().  When
file_check_backing() then calls d_real_inode(file->f_path.dentry),
ovl_d_real() runs ovl_verify_lowerdata() on the unverified dentry:

fs/overlayfs/super.c:ovl_d_real() {
    ...
	err =3D ovl_verify_lowerdata(dentry);
	if (err)
		goto bug;
	lower =3D ovl_dentry_lowerdata(dentry);
	if (!lower)
		goto bug;

real_lower:
	/* Handle recursion into stacked lower fs */
	return d_real(lower, type);

bug:
	WARN(1, "%s(%pd4, %d): real dentry not found\n", __func__, dentry, type);
	return dentry;
}

If ovl_verify_lowerdata() fails (for example, -ENOENT on a broken metacopy
redirect in a data-only lower layer, -EIO on verity failure, or -EINTR in
ovl_maybe_lookup_lowerdata()), ovl_d_real() hits the WARN(1) and returns
the overlayfs dentry itself.  Because the overlayfs superblock does not
have SB_I_PSEUDO set, file_check_backing() returns 0 and registers
fb->path; if the failure was transient, a later fuse_passthrough_open() ->
backing_file_open() -> vfs_open() -> ovl_open() can still resolve the
lower data dentry on a pseudo filesystem.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114-work-loop-=
pseudo-v2-0-98639a2286fb@kernel.org?part=3D38
