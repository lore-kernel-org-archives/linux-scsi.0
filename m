Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793718093;
	b=eigDgn6WsLKRdvBduZbBCrQpivbYQSEWjXUVR8pb0lORuZL4YeIcAyiFryUSz549k9uN
	 655X4kxib4z+ONDUfuH6Nust+gxQOtZbw1+Hawu/KTN+tYjaSmsfKjkSPVUP/JUQrOlqA
	 DzgfxOQsth76VmR7Bjj2l7d50RRlEq7RWoAct+jsix/8xUhEUNs5pkbztw3t534wTTboR
	 +U4LcsZx4+3H14bz/l8tyIlN+w27SAP6wK+enTBpY69UkkEjvPHKfko7X5C5MBTBI5Cp/
	 cxhcFtHUwrwP1ZeFDlkB6w43sv3UqGkzMFa3X5U+yrp8X9h4wQPxYLuvxGZiKsOkI4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793718093;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=HJo7uhQ8siYxDw0RZS7+3aCaFL/z+RS5DWNp/kEBIgk=;
	b=UPQHvuZFeM8L2ecnCI101+48bM8bwcCC/PDgo1/70tgM3XHXgf5qwEl0WKXRLVmG2PEM
	 BCVGPDjLokvOWjAJwmjRjz5kAFfuV2Zezkt/jZyq7I7hPPeMJqu5S+MbDvz/lG2zF7CQQ
	 HYcTMMzPqEQe9CQyjHZDv6xPC91LCID9IN9WCz2QdLs1CNPbgoYHjLSACrFW2lm64ZqSU
	 RQdBJcCjPUw6tPvE0PC2AodjYBJpel2l6abTvzIJtsQSM6PdvEKEzd7Q+u+WwTEaH37x7
	 dPyza2AYSJ1p7/3FyPqIiUaAGZsWmSv4rUAiSjHRohM+sEov95k1+CWl/VRunPm3/pQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="egO6F/of";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F5A606EE9D;
	Tue,  3 Nov 2026 15:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=egO6F/of
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1CB1F0093A;
	Tue,  3 Nov 2026 15:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793718088;
	bh=HJo7uhQ8siYxDw0RZS7+3aCaFL/z+RS5DWNp/kEBIgk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=egO6F/of7CpTd+PoLOWG9TxuNy/r0bVezlWWB3WedBTqIlqmwFVNqYhzt7VSoW8zF
	 L2Q3+erAo9JrU5hHInrg7k+kxzeqoaIrxxrLW7A1xtt/ncPtwSegLy4+TXN3HzG/hu
	 X8lQ7pFsFkuXEdqfkgkDg+lJrU+5qpItEyIjMQvlvx7yavCortIJIC3nuU0t33yVqs
	 dtJ+2iUHTvZB7QICHjQj8YsMjkOoP8NVFK47FEu6xrH8SbXS5x0lCNVOHCX5Bxz6mY
	 dkiORpDTzbslpgezRG4qDhAij5S0Pzc9kdghBEA/Lbr/FhFJu+yj3tH/1YEccJaQ7R
	 /D3PlZ2sc1PyQ==
Message-ID: <sashiko-outbox-195538@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 11/16] proc: let procfs copy in writes before
 pinning the entry
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, "Jann Horn" <jannh@google.com>, "Josef
 Bacik" <josef@toxicpanda.com>, "Chris Mason" <mason@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, NeilBrown <neil@brown.name>, "Eric Dumazet" <edumazet@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Al Viro" <viro@zeniv.linux.org.uk>, "Jonathan
 Corbet" <corbet@lwn.net>, "Christoph Hellwig" <hch@lst.de>, "Greg
 Kroah-Hartman" <gregkh@suse.de>, "Joel Granados" <joel.granados@kernel.org>, "Kees
 Cook" <kees@kernel.org>, "Jan Kara" <jack@suse.cz>, "Jan Kara" <jack@suse.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, coreteam@netfilter.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-usb@vger.kernel.org, samba-technical@lists.samba.org, sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-serial@vger.kernel.org, "Takashi
 Iwai" <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, tytso@mit.edu, dmitry.torokhov@gmail.com, "Petr
 Pavlu" <petr.pavlu@suse.com>, "Anna Schumaker" <anna@kernel.org>, yukuai@fygo.io, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261102-work-procfs-core-v1-11-75df35e4f8b8@kernel.org>
References: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
 <20261102-work-procfs-core-v1-11-75df35e4f8b8@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:01:26 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] proc: split __free(kvfree) declaration and initialization in pde_wr=
ite_buf()
--

commit d672761b59bb5333b9344e6a78cc97135a5b70b1
Author: Christian Brauner <brauner@kernel.org>

proc: let procfs copy in writes before pinning the entry

This commit introduces ->proc_write_buf() in struct proc_ops so procfs can
copy user write buffers into a NUL-terminated kernel buffer before pinning
the proc_dir_entry, preventing page faults during user copies from blocking
remove_proc_entry().

> diff --git a/fs/proc/inode.c b/fs/proc/inode.c
> index 8425465aae5d7..c0bb40e7ff964 100644
> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c
> @@ -440,11 +440,44 @@ static ssize_t pde_write(struct proc_dir_entry *pde=
, struct file *file, const ch
>  	return -EIO;
>  }
> =20
> +/*
> + * procfs copies in what is written before it pins the entry. A writer t=
hat
> + * faults on its buffer then doesn't hold up remove_proc_entry().
> + */
> +static ssize_t pde_write_buf(struct proc_dir_entry *pde, struct file *fi=
le,
> +			     const char __user *ubuf, size_t count, loff_t *ppos)
> +{
> +	char *buf __free(kvfree) =3D NULL;
> +	size_t size;
> +	ssize_t rv;
> +
> +	size =3D pde->write_size;
> +	if (count > size) {
> +		if (!pde_has_short_writes(pde))
> +			return -EINVAL;
> +		count =3D size;
> +	}
> +	buf =3D kvmalloc(count + 1, GFP_KERNEL);

[Severity: Low]
This isn't a bug, but in pde_write_buf() (called via proc_reg_write()),
buf is declared with __free(kvfree) =3D NULL at the top of the function and
assigned later after the count > size check.

Per the Cleanup API conventions, could buf be defined and initialized in a
single statement at the point of allocation:

	char *buf __free(kvfree) =3D kvmalloc(count + 1, GFP_KERNEL);

after the size check?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-core-v1-0-75df35e4f8b8@kernel.org?part=3D11
