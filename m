Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06EB633E348
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 16:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784307301; cv=none; b=r26kYLBBEhfjUpunGfy5ivwIyOYMMix2CcrXR+6aVo5gxmggZeyth+dQ2MNo5gApl+HS9Hn2sEHeg3vP6BnzraP8Vow+xGHOyeAJ7yh6Y7WtWgFnsmPsybJ604HWWPvs25yXN2L6htQJvv/oM7uwGG1Ta5R9Fi9NnkiL0T9WjeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784307301; c=relaxed/simple;
	bh=3jKaGy4s0uQGpM6iOGa9Tv4jPnCm47MW3aefKzkC84c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JHMHI7AM39nJzQsFusSoJpbv8K0yGcXJN876akyPWho6DuuEm4FWY8aEp6Z9BLOTeYB5hiDeltO1x+MhiYfvrzVdtdnN60GNm8rOF6wqWuGKm8wP/FCSQVvEqN0K28CFZmDFMNsUXepmTO1LA8vMI6bqWAJUTVPOhl2JO4seC+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l45+g37u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l45+g37u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2091F000E9;
	Fri, 17 Jul 2026 16:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784307299;
	bh=W058fzhuqMnVtvdlyBamn8F1sx0o7s3iyAywY6NFpn8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=l45+g37uNOou5figZK5UJBYynOvXl6IM4ILY0fiCDbXfll3fpJ6z1OzJzJGuJr22M
	 /DhcPFaIKXUXueh1/z3PcIjnnGI/kgdAuvoRQTcfwVw9yo5iADEKETmxg6sZ6nWr28
	 hMMWpKWaj7bcNE8fEd59396yWX+7wGfsZDiCjnnl3Dz/oErzYwNYyYIVSYXIpCrUGt
	 tmAwIRKowMetEMZEmZyTm0afQw0Tpu3ryRoHp4IY/VfYTaR5KZdJfKipnMe4f9fHK0
	 DbGwo68X8Skfw3u77BoytEwl0tMCPnGjL48RaR3DXZSTJeVqw67VPqSfwZfkK57PCL
	 Ok/jtwu5xXRHA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 5/6] scsi: ufs: rpmb: Use unaligned accessors for
 RPMB frames
Reply-To: sashiko-reviews@lists.linux.dev
To: "Li Qiang" <liqiang01@kylinos.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717153914.26321-6-liqiang01@kylinos.cn>
References: <cover.1784182493.git.liqiang01@kylinos.cn>
 <20260717153914.26321-1-liqiang01@kylinos.cn>
 <20260717153914.26321-6-liqiang01@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 16:54:59 +0000
Message-Id: <20260717165459.8F2091F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but while the patch =
correctly fixes unaligned memory accesses in the UFS RPMB backend, identica=
l unsafe accesses remain unpatched in the MMC RPMB backend. Additionally, a=
 structural fix using `__packed` on `struct rpmb_frame` is missing, which w=
ould safely handle unaligned access for all backends globally.
--

--- Patch [5]: [PATCH v2 5/6] scsi: ufs: rpmb: Use unaligned accessors for =
RPMB frames ---
commit 521f1f28960728ee9f0014bd2898bd36bb94fa39
Author: Li Qiang <liqiang01@kylinos.cn>

scsi: ufs: rpmb: Use unaligned accessors for RPMB frames

RPMB frame buffers are passed as u8 pointers and do not have an
alignment guarantee. This commit uses unaligned accessors for the req_resp
field to prevent alignment fault traps.

> diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
> index 431f85b368760..53f66b274acac 100644
> --- a/drivers/ufs/core/ufs-rpmb.c
> +++ b/drivers/ufs/core/ufs-rpmb.c
> @@ -73,7 +73,7 @@ static int ufs_rpmb_route_frames(struct device *dev, u8=
 *req, unsigned int req_l
>  	if (req_len < sizeof(*frm_out))
>  		return -EINVAL;
> =20
> -	req_type =3D be16_to_cpu(frm_out->req_resp);
> +	req_type =3D get_unaligned_be16(&frm_out->req_resp);

[Severity: High]
This is a pre-existing issue, but while this correctly fixes the unaligned
memory access in the UFS RPMB backend, does it make sense to fix this globa=
lly
by adding the __packed attribute to struct rpmb_frame in include/linux/rpmb=
.h?

Currently, identical unsafe accesses remain unpatched in the MMC RPMB backe=
nd,
such as in mmc_route_rpmb_frames() in drivers/mmc/core/block.c:

drivers/mmc/core/block.c:mmc_route_rpmb_frames() {
	...
	req_type =3D be16_to_cpu(frm->req_resp);
	...
	resp_frm->req_resp =3D cpu_to_be16(RPMB_RESULT_READ);
	...
}

An RPC call from the TEE secure world (e.g., OP-TEE) passing an unaligned
shm_offs to the kernel for an RPMB routing request
(handle_rpc_func_rpmb_frames) can cause tee_shm_get_va() to return an
unaligned u8 * pointer.

The MMC driver casts this to struct rpmb_frame * and dereferences req_resp,
which can trigger an alignment fault trap and kernel panic on architectures
that do not support unaligned memory access.

Would adding __packed to struct rpmb_frame instruct the compiler to safely
generate unaligned accesses for all members globally, avoiding brittle
driver-by-driver accessor fixes?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717153914.2632=
1-1-liqiang01@kylinos.cn?part=3D5
