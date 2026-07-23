Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001EA21FF30
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 00:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784767166; cv=none; b=bSiKY0QpDXJBIIWCHjopVLXQ35B094QrZi9n+ac4qZ3dTbYniU7YHnLt1seBsNQF/4ym3CIbk5MI78nD76fjJeM1GkIsep8ciCWsq/JmfLODQ/FzyfuSQVoiIORgeN2J0o/S74QpqP+Sz2XZ8C75sC94pH9TxxaTPUGFTNCe/6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784767166; c=relaxed/simple;
	bh=nNPYGGDR06+xa2DrASgEFFVrJy8EPJq5uBXJbvOeqxk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hY2QVN8P2vSg6dfixBfgovMAJFXRYq1Fb9lqrYpa4BNpyq4/34qj2jGxyTJlE6FMxlP7vLaKRwkSAsv4MYFwlU3qoklzppXhmPK+a5AZ/C2AoVwnqorT2xs83/9Ds7bYYbzJal/lTVGSJB3lsyxVX3ORd67pByJaLL3lV0dhE2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HQQgh3s1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HQQgh3s1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 637BC1F000E9;
	Thu, 23 Jul 2026 00:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784767164;
	bh=Gm4D2D0uZiGSAmybbgBfV3S1oe00tiTZ7XisN8GPAFQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HQQgh3s1P6AmlxdPe3chQtox/qbbf1k2yK0S/Lh2vIuCB9tIAmxSEemg4pjAE0T7K
	 bxhbMcQ6tJ/qeXD2jr5ul4CVc1IJq2N+2NFxCFOx7RFZ2wupUlV1Rk7/2LJbFK61xR
	 +c0BCZmylDpnZgDJlkdAkejUCoiSMK2aiSMIEI7PuteZGtBYmOtVjWL9/7P0M2t6qh
	 t3IFtzJIxHl4FfOIqPrso4jP16jChWTgZ5vyD3PZac7IsOs/bqzLZgl+0eXTcxOcgA
	 xxkPKPh7BxEuYqUvy8wthRnVwoOebab8h6HEZVKsIJ0VvtRgnUQhBIc3SphhauiprZ
	 Oed98kHBo5IZQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 18/33] ibmvfc: add NVMe/FC Process Login support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723000149.969416-19-tyreld@linux.ibm.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
 <20260723000149.969416-19-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 00:39:23 +0000
Message-Id: <20260723003924.637BC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Missing protocol validation in PRLI response handling allows pro=
tocol mismatch between target and response.
--

--- Patch [18]: [PATCH v2 18/33] ibmvfc: add NVMe/FC Process Login support =
---
commit 6682b3a365a88d88e3d8b2117f28f9fba600bb88
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: add NVMe/FC Process Login support

This commit extends the PRLI handling code in the ibmvfc driver to
support NVMe/FC targets. It issues the NVMe process login MAD when the
target protocol is NVMe/FC, sets the NVMe FC-4 type, and populates the
service parameters, subsequently decoding them to assign the proper
remote-port roles.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
[ ... ]
> @@ -4110,6 +4111,22 @@ static void ibmvfc_tgt_prli_done(struct ibmvfc_eve=
nt *evt)
>  				ibmvfc_retry_tgt_init(tgt, ibmvfc_tgt_send_prli);
>  			else
>  				ibmvfc_del_tgt(tgt);
> +		} else if (parms->type =3D=3D IBMVFC_NVME_FCP_TYPE) {
> +			if (prli_rsp[index].logged_in) {
> +				/* For FC-NVMe PRLI the Image Pair field is always set to zero (see =
6.3.3) */
> +				tgt->need_login =3D 0;
> +				tgt->ids.roles =3D 0;
> +				if (be32_to_cpu(parms->service_parms) & IBMVFC_PRLI_NVME_TARGET)
> +					tgt->ids.roles |=3D FC_PORT_ROLE_NVME_TARGET;
> +				if (be32_to_cpu(parms->service_parms) & IBMVFC_PRLI_NVME_INITIATOR)
> +					tgt->ids.roles |=3D FC_PORT_ROLE_NVME_INITIATOR;
> +				if (be32_to_cpu(parms->service_parms) & IBMVFC_PRLI_NVME_DISCOVERY)
> +					tgt->ids.roles |=3D FC_PORT_ROLE_NVME_DISCOVERY;
> +				tgt->add_rport =3D 1;

[Severity: Medium]
Does this code allow a protocol mismatch if the target returns an unexpected
FC-4 type in the PRLI response?

In ibmvfc_tgt_prli_done(), the response is evaluated purely based on
parms->type without checking if it matches the expected tgt->protocol.

If a target responds to a SCSI PRLI (where tgt->protocol is
IBMVFC_PROTO_SCSI) with the NVMe type (IBMVFC_NVME_FCP_TYPE), would the
driver branch into this NVMe handling block?

This appears to allow registering an FC remote port with the wrong transport
roles if a buggy or malicious target returns a mismatched response type.

> +			} else if (prli_rsp[index].retry)
> +				ibmvfc_retry_tgt_init(tgt, ibmvfc_tgt_send_prli);
> +			else
> +				ibmvfc_del_tgt(tgt);
>  		} else
>  			ibmvfc_del_tgt(tgt);
>  		break;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723000149.9694=
16-1-tyreld@linux.ibm.com?part=3D18
