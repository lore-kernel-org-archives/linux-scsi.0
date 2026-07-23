Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F3D1C861D
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 00:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784767807; cv=none; b=Jx0KeSNW4z/qCZY2T4unNwNMbg3l5c25qRdgVGL0OWtPgxXoaYcHOX0gSYVlcJayhSWMHSH+Nt30OJKfp63y/DvNFuPCT2Gy0qFEJvqQafV1wySwpamY9rUfZpmq1QX8vcgEC0IrMTZWkQuHAesaEeV76zUAGczuVa12ri9IVA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784767807; c=relaxed/simple;
	bh=wUt9aCnkmSH4zWW3iJNAgDH24Um3Z01LZVdx9hB9QjE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rEpQAzA+vpQR+ROdZhnPLO0Nk/0l5fQKJprO/41sPV1hKzn7wVeLEdJPWInp+ttmB6an9zUiDmXi7WgW6ykA9gR1HrBPGYchtoRmvgTSOFbCJREp1QII0De/9YRxUgpHuLJt9rI13LY1+uSdqUaN0/c+9FtbM8u7G3wC73WVUf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oLAfIJ6Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oLAfIJ6Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3B01F000E9;
	Thu, 23 Jul 2026 00:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784767806;
	bh=WiAoridFkcvL2dc6NynHBMkFEf4WLPfwfA8lpGT++JM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oLAfIJ6QDPYT09r89VIAdEoGVvOn+xc/vKtMuKDCUikTtGke2+JDwcc1IM7ihYlEN
	 t13Aq62GAYj9JGUw48xv9upw6iQ6Cq0ds6CgMudeQbdl1qcFSHgy9gU7xBKRICGIuX
	 rWy0tai9hpTC2lzgCsvCgw39Vb5hSUc5UvRwTvSBwHKeLIDlKeMsxEokdibhlYYE9+
	 e3U+H/QxaInI5mRx2P12CeW9ps8fhQuYl8GKSre7JIGNYTHinwKZJFJM6NrKSBD/jP
	 xABJEnDPQCDk5P0tUfUT8bcfak5monymWtZ8M8cO3lGxFRO9bzjQbp3eDd/IPUmL2x
	 //QTmmF7A7gkw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 19/33] ibmvfc: add NVMe/FC Query Target support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723000149.969416-20-tyreld@linux.ibm.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
 <20260723000149.969416-20-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 00:50:05 +0000
Message-Id: <20260723005006.1D3B01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The target's protocol field is never initialized to IBMVFC_PROTO_N=
VME, causing the driver to send SCSI Query Target MADs even for NVMe target=
s.
--

--- Patch [19]: [PATCH v2 19/33] ibmvfc: add NVMe/FC Query Target support -=
--
commit 8e5ca6c48a7f422d595d70e30b62d3daf80b7c82
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: add NVMe/FC Query Target support

This commit adds protocol-specific query-target support for NVMe/FC targets.
It uses the NVMe query-target specific MAD when querying an NVMe target and
updates the associated logging.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 5950f143e9a12..b479537e9e78c 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
[ ... ]
> @@ -4923,7 +4923,10 @@ static void ibmvfc_tgt_query_target(struct ibmvfc_=
target *tgt)
>  	query_tgt =3D &evt->iu.query_tgt;
>  	memset(query_tgt, 0, sizeof(*query_tgt));
>  	query_tgt->common.version =3D cpu_to_be32(1);
> -	query_tgt->common.opcode =3D cpu_to_be32(IBMVFC_QUERY_TARGET);
> +	if (tgt->protocol =3D=3D IBMVFC_PROTO_SCSI)
> +		query_tgt->common.opcode =3D cpu_to_be32(IBMVFC_QUERY_TARGET);
> +	else
> +		query_tgt->common.opcode =3D cpu_to_be32(IBMVFC_NVMF_QUERY_TARGET);

[Severity: High]
Is this NVMe branch reachable?

Looking at ibmvfc_alloc_target(), the target is allocated and zero-initiali=
zed
using memset(), but the protocol field is never assigned. Because
IBMVFC_PROTO_SCSI evaluates to 0, the target implicitly and permanently
becomes a SCSI target:

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_alloc_target() {
	...
	tgt =3D mempool_alloc(vhost->tgt_pool, GFP_NOIO);
	memset(tgt, 0, sizeof(*tgt));
	tgt->scsi_id =3D scsi_id;
	tgt->wwpn =3D wwpn;
	tgt->vhost =3D vhost;
	tgt->need_login =3D 1;
	...
}

Does the protocol field need to be explicitly initialized to IBMVFC_PROTO_N=
VME
somewhere so that NVMe targets don't incorrectly send SCSI Query Target MAD=
s?

>  	query_tgt->common.length =3D cpu_to_be16(sizeof(*query_tgt));
>  	query_tgt->wwpn =3D cpu_to_be64(tgt->ids.port_name);
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723000149.9694=
16-1-tyreld@linux.ibm.com?part=3D19
