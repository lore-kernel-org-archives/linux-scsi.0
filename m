Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795496197;
	b=YQHPIqWP2Lkku9jlg/whSdw6KHucJJSrMxGGWxCsWmAqaiNfZFK1nia/ihY58Dyyzrt6
	 /AiFJUFPqLj990qzbeZDjvih3OxdgicFHsel8dea0wbiPyjBTjdyh+cL58wl+wjjUEHtF
	 +z6NuocQ4y3/OFKSVaK1Pq9rrMwmkoz0JIPn+0MP8UTj56qlC+Atblf4zvK6OoU0kkNwz
	 syBPyZ/iZPfqWjwSNo479mJPQNg0qlD+zuDKJCiCR8eh0bJrCzQi7pThloyVQ/jFCmfsV
	 VSVkxRD1oT398wL7YKPzH5aoqnjX/FQ1LXrt7fzzM43JPmyRwmv5tuHlMDCudktTUxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795496197;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=iYM1Dul2p1M70JuzkmTz1683ZU5ujCLHcJTzbqwKjP0=;
	b=13cC7vOit45Ul/US7oyiW4cPJYy58VX+L0WT9MmUEUkafiPtJDy0PJr4DBXBkZT1xSBE
	 +hGcQ97b/IIwSEiyqe4o+o5/9cBrZKFuDIloRiyqS0geH9fgsVCP+zAr3LvuLoU1/xHxI
	 ACM7Xaz2pJk2KJxh/2pE3CQvS3b68MZc8E7/g/t5WS3p4VQi6V/0vZYKWJ6pAnh83gky5
	 QNYe//n6nB4w6qQ9XeMueWAAYYiZs/ysO4uyQPxhu5BOJgLryK2oLefFIHV89BS1NJSBb
	 6/YoQLYer4sP7ee1ZWv8p36uS/hi69A9iRSCSxGoxSlzWleFb7NS3D5wvMQerFYYStg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dq6Mu6pG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8579D606A31E
	for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 04:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dq6Mu6pG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 865641F000C0;
	Tue, 24 Nov 2026 04:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795496196;
	bh=iYM1Dul2p1M70JuzkmTz1683ZU5ujCLHcJTzbqwKjP0=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=dq6Mu6pGvuDJkbyYJ3W0wIOg6dXcMC2jDtK4kVK1x25bbPfBk90jO/7m0tmAxSc0J
	 PYw2Edqbsn4Estp/kUwCQuq0ifD1/aCCx6eaMJt5uv2r6LAckBCWmVzSBBsWnAOqUB
	 ApHPjBXz5UFPy6VRxRWaElFxjblIOMZYlmj7NPiPNmZes197+aQ27+EjNFmig0shEV
	 cuJQpjaIvDM0degIi6zl+k7HcvLNU1NNRRN9ExlIpb0qnIQrz8z+/AqPAe5hsbXJ4z
	 tEHO6wIKoRvlB9enZXiSdFpus/L1tx01xvNYwIx2eWhXo4gJY2H5oi+OlHtNKucZW1
	 6U0x/PUne2qgQ==
Message-ID: <sashiko-outbox-230532@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: ufs: rpmb: Return -EIO instead of SCSI result on
 failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nayeon Kim" <nayeoni.kim@samsung.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20261124-b4-ufs-3-rpmb-errno-v1-1-65b54643ca21@samsung.com>
References: <20261124-b4-ufs-3-rpmb-errno-v1-1-65b54643ca21@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 04:56:36 +0000
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
- [Low] scsi: ufs: rpmb: missing Fixes trailer for return value fix in
  ufs_sec_submit()
--

commit 04d79d2b7f15b664ba1b55919c7db6dc6388376b
Author: Nayeon Kim <nayeoni.kim@samsung.com>

> scsi: ufs: rpmb: Return -EIO instead of SCSI result on failure
>
> rpmb_route_frames() is documented to return a negative errno on
> failure, but ufs_sec_submit() returns the value of scsi_execute_cmd()
> as is. When a SECURITY PROTOCOL IN/OUT command fails, that value is a
> positive SCSI result such as SAM_STAT_CHECK_CONDITION or
> DID_ERROR << 16. ufs_rpmb_route_frames() passes it up and logs it as
> "ret=3D%d". Since scsi_execute_cmd() sets RQF_QUIET, the sense data is
> not logged anywhere.
>
> handle_rpc_func_rpmb_frames(), the only caller of rpmb_route_frames(),
> checks for a non-zero return, so OP-TEE still sees the failure.
>
> Log the SCSI result and sense data in ufs_sec_submit() and convert
> positive results to -EIO, as ufshcd_set_dev_pwr_mode() does.
>
> Signed-off-by: Nayeon Kim <nayeoni.kim@samsung.com>

[Severity: Low]
This fixes the return value contract of ufs_sec_submit().  Should it
include a Fixes tag:

  Fixes: b06b8c421485 ("scsi: ufs: core: Add OP-TEE based RPMB driver for U=
FS devices")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124-b4-ufs-3-r=
pmb-errno-v1-1-65b54643ca21@samsung.com?part=3D1
