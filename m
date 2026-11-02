Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793587048;
	b=MlBI/otYJfPyuIkx0Z7JX+IHrJ5zCgw6XQXUQRR4zaoY1NcU1gdI+HjkH8gnRFhAxIZK
	 hrSqHP9w9FplzEh1TSPae5d7Io3q/fizaqcTTao9ecLJLxKxRzLAI1MgdGI3KHbN6VxCj
	 4OLtmN2W8cvaFeqa8GpKjG56ffh+S7WfKUXxf7NovhbrWyZ7638SJCIDnT2vaDPNExwjJ
	 hacYEO0HaoOEU1hO77apnQqANSSrE/EnOUA+h8GtsViEAk/2bdcYePsMNdgk7kkC66XhS
	 GAS76dnsCGo8ho3+8iFIeYfLsjTxcgo4tMJiiRXLK3jhc+Cmq6vfOKxqnkfofwfAYjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793587048;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=IDYT7EmadIaxjNtfVH7ZbiLAv7WniNS3TI6ADL1GpKY=;
	b=zhk3/3D/wFUJU5wTAb+6v7H7wORkpHrh+T9mHdC0DKKgb7Y7i0q/mm29TUEsZIpf/YF4
	 JjRQ5liCwD96hGxq2xEB1q0Occnksn0vVtj8hC60jVQn0jLg0MxuWodnlQKSoQlphr0o1
	 g5T4BRz+CXM6oJMX3FRLjoMZr/wwozH4hTj09M9IIRCmCHiTiYNdnxHq89cB/d9zKRHGN
	 2imUe0Ma+b5w90t32C14E0OMirciMqOF1pCjUWIfqWtUzODi2COnB9RfcBFx/GuMEYBH8
	 jfVm6wTbQ6YX7jJqukKFpaeQ4s0Ork7ZOBDuwRrxJXRWIt+mLy6nu32qHIPV5HgdpTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PWrWgpsk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4778F606A326
	for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2026 02:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PWrWgpsk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2823A1F000C1;
	Mon,  2 Nov 2026 02:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793587047;
	bh=IDYT7EmadIaxjNtfVH7ZbiLAv7WniNS3TI6ADL1GpKY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PWrWgpsktUNX9da2ZypgLWPaRmEPhptdsR0zOy7Po9oxsLzWTWkO3szeFJbVGBUJC
	 LnD21xhv7b5NXer6nun8RlW///VXxNDi62XsYbxp4kn6bwuIrBA55TUjJB7C/DWWpL
	 jR0gM/3ehaA6OExu4SxGl7cA3B8BROqLMF8/KQBlZRs8bc8fKv50M7Htes6Sr8y2cE
	 NaELynVKLfTfPb7l3KS+cbvnUJdhjJ5OdQ6czooQwjUh3aY2KEWXR1yUTRUIMQgTVr
	 w+excqPiWi5FzBg58Bz0BkPF2h/WrvZOcT2g+xh4DUl4edgeS+NybIotBcvmBxLbXY
	 Yiaiaje46s0Tw==
Message-ID: <sashiko-outbox-192840@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/2] scsi: ufs: core: Move the device initialization
 sequence into a new function
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shawn Lin" <shawn.lin@rock-chips.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261102022154.3903115-2-shawn.lin@rock-chips.com>
References: <20261102022154.3903115-1-shawn.lin@rock-chips.com>
 <20261102022154.3903115-2-shawn.lin@rock-chips.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 02:37:26 +0000
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
- [Low] scsi: ufs: core: inaccurate return doc on ufshcd_full_device_init()
--

commit 92840cc6e92324af86954d841a38c89351f13122
Author: Shawn Lin <shawn.lin@rock-chips.com>

scsi: ufs: core: Move the device initialization sequence into a new function

This commit factors the link startup and device initialization steps out of
ufshcd_init() into a new helper function, ufshcd_full_device_init(), so that
the sequence can be retried as a unit.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index fd52deb72d21c..8a8083a8f024e 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -11215,6 +11215,55 @@ static int ufshcd_add_scsi_host(struct ufs_hba *=
hba)
>  	return err;
>  }
> =20
> +/**
> + * ufshcd_full_device_init - Link startup and full device initialization
> + * @hba: per-adapter instance
> + *
> + * Execute the whole device initialization sequence used during driver
> + * probe: link startup, MCQ configuration, device verification, device
> + * initialization completion and device parameter setup.
> + *
> + * Return: 0 upon success; < 0 upon failure.
> + */
> +static int ufshcd_full_device_init(struct ufs_hba *hba)

[Severity: Low]
This isn't a bug, but is the Return description accurate?

ufshcd_full_device_init() directly returns the status of
ufshcd_link_startup(), ufshcd_verify_dev_init(), ufshcd_complete_dev_init(),
ufshcd_device_params_init(), and ufshcd_post_device_init(). Several of these
callees can return positive (> 0) UFS OCS or UIC hardware status codes on
failure, which is why ufshcd_init() normalizes positive error codes at
out_error:

drivers/ufs/core/ufshcd.c:ufshcd_init() {
	...
out_error:
	return err > 0 ? -EIO : err;
}

Should the kernel-doc comment note that non-zero (or < 0 and > 0) values are
returned upon failure?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102022154.3903=
115-1-shawn.lin@rock-chips.com?part=3D1
