Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793795219;
	b=TxRH7/3omLTUgSL0wzBl96SUEZG5ir7gYcciMTMMXcGQ+gxStCSBhqHyerBX2Xvk1iWO
	 cNAy6mbCGmvo4wgOLW3L1BRvOpr5yVX14W8zXPdW3wFQxjlsb3tbWkOVklZloeyCHw8HA
	 Y0WgTKJ3NQbJwH3JXNT+jWLBoaOsGK3mdAfsleoAL09K4lM6QX+UgFT+sPFHOe7T/ix3z
	 RaiVhFTWRnvE/mYlH9uWG6TvTUTi0s4Lf6Hi2ilJKeVQ4SPDcuRjZSXNoRi+qwd5S0QnJ
	 um6BRqbQ/Wk4Xo83R00bM2vt6bIN8Sd++sH7NcssRC4mCt6mujTH3t4vewOuRbO3npw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793795219;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+yryNNIjSj043lVFb6W0DsHDOZRqFQvvHtuAtyNPqsA=;
	b=Rc+ca+p/qAXoG+uhuyDc5j7oDj5gTdCObT/SFJUl5UTUSTh0wgeJ0EPSnONQRnrL7amh
	 yB+nPaj+iWXn+TvqfxAtxMkUW5Lbfj0j0GTajUZL/Ga/ZFbg5oc1Yb3LGW0ec4NInu0Yu
	 +CRwantW9WLs15nuxj7nMs50v1l3fotC7lvYqOt5Aeniip0Ax6R8jedThGC1g6HQlvTCF
	 VoaZwXr9lHCL8oMFbXcH4P7xGrmi2ywWMNQjKXpfpjShKnodeHDza313q866W25VhsVNB
	 r+Hs3hSAHuxfRVwpoN0NHJQHQuhh0uTDlQoUwQaKVhkITfevCj8e2hVo6hZxqjsSUeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J2Twz9bd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95FC7606A32C
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 12:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J2Twz9bd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AAF01F000C1;
	Wed,  4 Nov 2026 12:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793795219;
	bh=+yryNNIjSj043lVFb6W0DsHDOZRqFQvvHtuAtyNPqsA=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=J2Twz9bdTll26WHHe6WmDtLGJVhDHXhSJMAR22hD9skFZY+4ZRFEgD6TpEJioU54t
	 qWqPg5kEGg7OG008meLNkA5TO/BdaH4IFaLBg35veBTTAZs9PA1XK9xS8DlWDd0duB
	 oAY37AcqMCA74h4ZG/79378XHpT23bWP0sJruKk7lLi+/hcZ/QJNaAJK3mgZ2QEzj9
	 V5DnV+s/ayFtfboAbGblJg/T/g3t+eVzYHywkviRvEM9EZwTaW4G/4GRhyngY5UTFO
	 6hnuvMavE15Z7CSQU1cvDxoj6znLAq4mojXR77+pp1CmzNCxsrYVX55Jv+ijw1Ek+d
	 HcH0VD75O8DkA==
Message-ID: <sashiko-outbox-197249@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 16/21] scsi: mpi3mr: Fix sense buffer use after free on
 BSG command completion
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ranjan Kumar" <ranjan.kumar@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20261104120103.503871-17-ranjan.kumar@broadcom.com>
References: <20261104120103.503871-1-ranjan.kumar@broadcom.com>
 <20261104120103.503871-17-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 12:26:57 +0000
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
- [Low] scsi: mpi3mr: missing kernel-doc for state_lock in struct mpi3mr_dr=
v_cmd
--

commit c6a057ccd37372310fe900ce7c3174bca6fb48f5
Author: Ranjan Kumar <ranjan.kumar@broadcom.com>

scsi: mpi3mr: Fix sense buffer use after free on BSG command completion

This commit adds a spinlock (state_lock) to struct mpi3mr_drv_cmd to
synchronize access to command tracker state and sense buffer pointers
between the BSG ioctl path, the interrupt reply handler, and reset
flushing, and initializes the PEL command trackers in mpi3mr_probe().

> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index 8738fc2ce7e77..deb8a1eea9177 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -898,6 +898,7 @@ struct mpi3mr_sdev_priv_data {
>   */
>  struct mpi3mr_drv_cmd {
>  	struct mutex mutex;
> +	spinlock_t state_lock;

[Severity: Low]
This isn't a bug, but struct mpi3mr_drv_cmd in drivers/scsi/mpi3mr/mpi3mr.h
has a kernel-doc comment block right above it describing all of its members.
Should @state_lock be added to that kernel-doc comment as well so that
running scripts/kernel-doc or building with W=3D1 does not warn about an
undocumented struct member?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104120103.5038=
71-1-ranjan.kumar@broadcom.com?part=3D16
