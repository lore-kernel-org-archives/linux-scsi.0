Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794303219;
	b=lz2LudrXaEhAwu6pWkRpHGdbAEnqOzx0lu9y7S3Ubwb2il2kn8kGHFwIKTYCZpw4iOU1
	 6tWKHqlQa6HtU2ICKQc1P08KqUWANVqBXZ57jVFd+QjRdp65S6hIU2fl3ZYABT6dIaglU
	 JWSdudS/n0btwtMRMiWTR2/PIse/elspMGv9Z5E7BqLPirKcu2MuOZJumOJTQceuJNRW/
	 Sf9Ur8tMB/L7uBVgAAugK6QdTv1W0TEKyOUJWEZ145++snvZLVTbt9dE3JhwcroMJvNre
	 RXIF8v9LnAK6jT6t40nI56Diqfl6mjQxa/2K3YkFXEHoAPj6ym8FXobQtUpY22hNU5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794303219;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bww7nw5bSwEPBt04rDt0/bI4su6VmPuV17HzMgP1WVA=;
	b=ltL4WKrt49/hCCK3gEwnsnziY1AcbzXchj0RZww+NtMqb1DduRvgG32s+FCioJGbW3YH
	 eLCTlqghn1WVg5m91d8i3rzDzITn+4QlZqn3NI8TKiQdfmSK5eEkpbSVuPpfxMagiTEpa
	 LzP1r/C7bGpsUE6P4Y8N5JCfu1FFnR5Hwir7gRM7p6sDJpO/rNoShMP0OthoOdGBqnTf7
	 Hx2nAJ1Yacu2i0mUGBwPt/YdoYWoZ1i573/NOp5ZF3yKX88YFPIej+Ul4AuzKL2IfPGZb
	 fffB03rRJgkw4nJibaQ3apuEI6p5D0SfHOpous9/CCThrAC0YVqW6H6TyGrXbmXfi9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IKmf+e1g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A0B606C65F;
	Tue, 10 Nov 2026 09:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IKmf+e1g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C081F0089F;
	Tue, 10 Nov 2026 09:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794303218;
	bh=bww7nw5bSwEPBt04rDt0/bI4su6VmPuV17HzMgP1WVA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IKmf+e1gFKkj418fSwF/WvpYdm5kRAazs7jwnCLr8UBX0mWUP8DQEFBBBEZlbkXZ1
	 XI4prTk7TROigxS8fxK3H7nyiNmObFLtBmkCA0ke0HXW7pt9dEt/aaSRLKtzC4egpf
	 OEHRA7RgND8FIgqLmipqQVPz2GNvvRJE2PgE7T/NOFf640AwOp8vZiaRQth92bBap0
	 HKEfy9pnSL5/wTdbiAfkWabIrGIRQRAr+uE+2HXR6t6FbfBJFofcbxlw42H4vOVzXk
	 w77kmjm4jAJg1fdzTMQ0RDczx8gBsj6Uaq5LnRuUkl/WYcX9JduP6Rs8JOjO15ilQh
	 USFa7wOu4MpQw==
Message-ID: <sashiko-outbox-206765@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 37/41] target: fileio: refuse files on pseudo
 filesystems as backing files
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
In-Reply-To: <20261110-work-loop-pseudo-v1-37-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-37-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 09:33:35 +0000
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
- [Medium] target: fileio: missing file_is_pseudo() check in
  fd_init_prot()
--

commit 4e15db58376b542897dd4203d7acdfd99df1aec4
Author: Christian Brauner <brauner@kernel.org>

target: fileio: refuse files on pseudo filesystems as backing files

This commit rejects files on pseudo filesystems in fd_configure_device() so
that SCSI initiators cannot read or write kernel interfaces such as procfs
or sysfs with kernel credentials.

> diff --git a/drivers/target/target_core_file.c b/drivers/target/target_co=
re_file.c
> index a5391e57e9aa5..7a3cf63dc979b 100644
> --- a/drivers/target/target_core_file.c
> +++ b/drivers/target/target_core_file.c
> @@ -152,6 +152,13 @@ static int fd_configure_device(struct se_device *dev)
>  		goto fail;
>  	}
> =20
> +	if (file_is_pseudo(file)) {
> +		pr_err("FILEIO: %s is on a pseudo filesystem\n",
> +		       fd_dev->fd_dev_name);
> +		ret =3D -EINVAL;
> +		goto fail;
> +	}

[Severity: Medium]
Should fd_init_prot() also check file_is_pseudo() (and ->read_iter /
->write_iter) when opening fd_dev->fd_prot_file?

When DIF protection is enabled via pi_prot_type_store(), fd_init_prot()
opens "%s.protection" by pathname without these checks.  If that path is a
symlink or bind mount to a procfs or sysfs file, fd_execute_rw_buffered() ->
fd_do_rw() will still read and write it with kernel worker credentials.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110-work-loop-=
pseudo-v1-0-4c998976c6c7@kernel.org?part=3D37
