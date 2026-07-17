Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BCF327587D
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 16:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784305940; cv=none; b=MR3DCqp4a/YyKdPgs0bIIEn30KfUplNmX8CZvPiKia4X3oDWuIpeKUCBwZcMs8q1CmhTI8O4AvGiaZC1VPl3MDPQTz8clBuSK2O/VThxwQTEYfgNFAQAJTt/i2T9nC6ItBPWtqfRIVB14Ll7Ki2oN706lP78fPWixrkINQCn3gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784305940; c=relaxed/simple;
	bh=6YQ6aC6nKJF0JGVB68AzjMOkxQDQGxi9k7CKbFCag2o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ubLL3OPw5ditz6aUUJ/0RUIUGB1bZbJopN5dhzs/7SGv7lyokbygji9SAsSjW8Qr/A325Geu1k+lPU9ZZGQUB3dbdzykJUZ9hYg04fVG1I+wg1qcfminbNPVmJz3cejKktELyfHqAJgGhU+Mds38zKxTxcYgC9wayN7Dh8eumfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UcJ3fvzU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UcJ3fvzU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16661F000E9;
	Fri, 17 Jul 2026 16:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784305937;
	bh=MfGIAyxj8wOS7zEA2ITeKv1xkZYP8TIOd2jhWvp7ZgY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UcJ3fvzUBbohxWW6KVwh9JP939jPktOfjXApcHcEyNeDt8G35vz5wiFBwVv0dXc/w
	 EoLgMGLVmD9GGvARhqCcfxMfXdMQXAqGiOrHxVJlAO6VCbJ66yTvpnHJnZEzB8GIZA
	 xt5bR1ahqcm8+aETqk/83J1bhEqPWWG2doI+pYOwFLVFZCyvzCJw8FvLAcMQGQNzbc
	 3o0/Z8w/HFWNQgySqC23P7Zr/q+YEHFaiAE+Vbmimw8XhF7wzD7XW0lAdOJIN7da2x
	 K38yX6Cy0rKBHSOiPPvEX9ORmImkEwmwy6COg1HcFcyr6iZMkyoGP3jQZIGHxr1Hll
	 FfawisRtuAHZA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 4/6] scsi: ufs: rpmb: Validate request frame length
 before parsing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Li Qiang" <liqiang01@kylinos.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717153914.26321-5-liqiang01@kylinos.cn>
References: <cover.1784182493.git.liqiang01@kylinos.cn>
 <20260717153914.26321-1-liqiang01@kylinos.cn>
 <20260717153914.26321-5-liqiang01@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 16:32:16 +0000
Message-Id: <20260717163216.F16661F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing IS_ERR() check for tee_shm_get_va() return values in OP-TE=
E RPMB RPC handler.
- [High] Circular refcount and incorrect use of devm_kzalloc() for a dynami=
cally registered struct device lead to a memory leak and severe Use-After-F=
ree when UFS is unbound.
--

--- Patch [4]: [PATCH v2 4/6] scsi: ufs: rpmb: Validate request frame lengt=
h before parsing ---
commit 1f68e5566b9d9ef98707ec46f344522aaa25cb6b
Author: Li Qiang <liqiang01@kylinos.cn>

scsi: ufs: rpmb: Validate request frame length before parsing

The RPMB core only verifies that request and response buffers are nonempty.
This commit adds a check to ensure a complete RPMB request frame is provided
before reading req_resp at the end of the frame.

> diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
> index ffad049872b9a..431f85b368760 100644
> --- a/drivers/ufs/core/ufs-rpmb.c
> +++ b/drivers/ufs/core/ufs-rpmb.c
> @@ -69,6 +69,10 @@ static int ufs_rpmb_route_frames(struct device *dev, u=
8 *req, unsigned int req_l
> =20
>  	hba =3D ufs_rpmb->hba;

[Severity: High]
This is a pre-existing issue, but does this lead to a use-after-free when t=
he
UFS host is unbound?

Because ufs_rpmb was allocated with devm_kzalloc(), it is automatically fre=
ed
on unbind. However, ufs_rpmb_remove() unregisters ufs_rpmb->dev but fails to
unregister the child rdev. Since rdev->dev implicitly holds a parent refere=
nce
to ufs_rpmb->dev, ufs_rpmb->dev's refcount never drops to zero, and
ufs_rpmb_device_release() is never invoked to call rpmb_dev_unregister().

If a subsequent RPMB request routes a frame, will it extract and dereference
the freed ufs_rpmb object here?

> +	/* req_resp is at the end of an RPMB frame. */
> +	if (req_len < sizeof(*frm_out))
> +		return -EINVAL;
> +
>  	req_type =3D be16_to_cpu(frm_out->req_resp);

[Severity: High]
This isn't a bug introduced by this patch, but can we dereference an error
pointer here?

If drivers/tee/optee/rpc.c:handle_rpc_func_rpmb_frames() receives an
out-of-bounds offset from the Secure World, tee_shm_get_va() returns
ERR_PTR(-EINVAL). Because there is no IS_ERR() check, this error pointer is
passed as 'req' to rpmb_route_frames() and eventually reaches here as frm_o=
ut.

Will accessing frm_out->req_resp cause a panic if the Secure World sends an
invalid offset?

> =20
>  	switch (req_type) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717153914.2632=
1-1-liqiang01@kylinos.cn?part=3D4
