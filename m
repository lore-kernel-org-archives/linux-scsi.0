Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794663612;
	b=ay/cIaBjy2DO/6A+bq2jZS+FQRPjiGYca7F9og9UF4MArGXWBr+855YDMcR6XPVBotQs
	 S452lcFh1TXX3xGHaJ5LI5S/nW006x+XdgJrLZnLzV8jF3QbhOq9gGHJk35GLeMkiMcVK
	 qPovjLd34LjCYFzO8FqWFcaubnjH27rG1FljGs1CKrXejqf1crcIRPhS3G4juWS81pzzA
	 wD54GvZdyfHLn571NhmXN0ayYmna5LER+MjcpUdDbCwiGUkPWDxNeVmr7QIcYDMZkxgtg
	 Zp/oBaB+FxSv60Vv7Z3WCatvjvPrk0iPj+zQVIoxM73yS/FzXWHtaybrjVV2j+GRF+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794663612;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=DO/pcsGH2E70PyxeObnmbVUNA7RxRjcw0EQOKMlsdEM=;
	b=fqBxLL74C0HcnagCL6cU3MoOsLaX5AhRMB4G9Rb9UfbYOAOpcxl5WH2WANLECb37fDfk
	 n/AyGY6IO1rolQnLRBjTJYJmM25st/icFw4X3bOKqsD6ror8iiagNv6vFt0xFJlhF5LMB
	 qx/9ZcOOVNC3Int0xQu7Z/qhQKvtNE+GoDssVdL5yqgFnSMn52Rb+/5MWbM+KN4Y0Vf1f
	 36Js+Ujy98hdv1akNz4jxSe9xRF7+qT5FY5VkM3psG1fEby9kiqlA1wLlLO8CAURSWAxX
	 BknRc38eWHLMW/Rt7wGQuVjP85ZNV1AUEQve0TkCPqzdDpJPE2adF0I/3+ZKw/HTlNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EtA9LyX1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4281606A32E;
	Sat, 14 Nov 2026 13:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EtA9LyX1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5EE71F000C4;
	Sat, 14 Nov 2026 13:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794663612;
	bh=DO/pcsGH2E70PyxeObnmbVUNA7RxRjcw0EQOKMlsdEM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EtA9LyX1DQPmqIivWqEued4cucJAK1+nJOQ/GGvKipbsSCBQuo+oZ3kPO9RKq7oYC
	 zIcaqW85WuT+78yc6J4OdCXsw3apCSEsQ7sYevNDP5gzBcxQY0m3Hv+1Ms0/aVZ7H8
	 CDlb2C/w82i3kqyY8BfiXhGvlQIigUINjN/hsFCRLIaM2Ubpq32rCz1dM2EFAIdocF
	 nG9Yz57EvfILKbQDtDytbmBzQCS6+NOxq3b2IHcbiz+ugsNkMobp3XIkLgDnxk7t1p
	 F4jXXVsDKS5hVcmfN7uciWAYXm2W6m4JRPhYfmt9AfelqpBckVtT7QDcKzpdjQSs7B
	 YV7fH2wGKn7Ug==
Message-ID: <sashiko-outbox-214581@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 33/42] fs: add file_check_backing()
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
In-Reply-To: <20261114-work-loop-pseudo-v2-33-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
 <20261114-work-loop-pseudo-v2-33-98639a2286fb@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 13:40:10 +0000
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
- [Medium] fs: unverified overlayfs O_PATH d_real_inode() call in
  file_check_backing()
--

commit 12b4c886c3329cc29a995a96a698923b0df5e8e2
Author: Christian Brauner <brauner@kernel.org>

fs: add file_check_backing()

This commit adds file_check_backing() to validate whether a userspace
file can be used as backing storage by checking its open mode, file type,
pseudo-filesystem status, and read/write iterator operations.

> diff --git a/fs/read_write.c b/fs/read_write.c
> index 6767283108991..cedbe654add65 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -866,6 +866,54 @@ static ssize_t do_loop_readv_writev(struct file *fil=
p, struct iov_iter *iter,
>  	return ret;
>  }
> =20
[ ... ]
> +int file_check_backing(const struct file *file, fmode_t mode, umode_t ty=
pe)
> +{
> +	fmode_t io =3D mode & (FMODE_READ | FMODE_WRITE);
> +	/* Drivers may point ->f_mapping at something else. */
> +	umode_t fmt =3D file_inode(file)->i_mode & S_IFMT;
> +
> +	/* O_PATH files are only fine for callers that just use the path. */
> +	if ((file->f_mode & FMODE_PATH) && !(mode & FMODE_PATH))
> +		return -EBADF;
> +
> +	if ((file->f_mode & io) !=3D io)
> +		return -EBADF;
> +
> +	if (fmt !=3D S_IFREG && !(type =3D=3D S_IFBLK && fmt =3D=3D S_IFBLK))
> +		return -EINVAL;
> +
> +	/* Look through stacking filesystems at the inode with the data. */
> +	if (d_real_inode(file->f_path.dentry)->i_sb->s_iflags & SB_I_PSEUDO)
> +		return -EINVAL;

[Severity: Medium]
Can calling d_real_inode() on an O_PATH overlayfs file trigger a WARN(1)
in ovl_d_real() and bypass the SB_I_PSEUDO check?

When a file is opened with O_PATH, do_dentry_open() returns before calling
f->f_op->open(), so ovl_open() -> ovl_verify_lowerdata() has not run yet.
When file_check_backing() is called with FMODE_PATH, d_real_inode()
invokes ovl_d_real(dentry, D_REAL_DATA):

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

On an overlayfs mount using data-only lower layers or metacopy verity
validation, ovl_verify_lowerdata() takes the inode lock interruptibly via
ovl_inode_lock_interruptible() and performs lazy lowerdata lookup or
verity checks.  If that fails (for instance with -EINTR from a pending
signal, or -ENOENT / -EIO), ovl_d_real() fires WARN(1) and returns the
overlayfs dentry itself.  Because the overlayfs superblock does not set
SB_I_PSEUDO, the check here passes even if the underlying data layer is a
pseudo filesystem.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114-work-loop-=
pseudo-v2-0-98639a2286fb@kernel.org?part=3D33
