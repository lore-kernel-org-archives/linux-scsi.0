Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A50232395;
	Fri, 31 Jul 2026 22:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785535649; cv=none; b=JPju/buzvIFJhtlTUd+8dWNbNCHNWihtc8jl9Esb17LVVVtOpYscbEEJvVwtm4NAoXEp3zNUD7fMJZptaKYqwKgMcU9wJfoaJG8iy+rAlshrrOp5HIaYfCN6qyeonMsTcuc08vq5FcPT1Xy+Q6Mx7vDzdn13Ekz/eFwVzBmGE5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785535649; c=relaxed/simple;
	bh=DvCh7BiuqDIXZ+yaTYGJZ3BSedFVCmhNi5IUHsTqR2E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hu+dF4ApjDlCjjgZizP6dozzHYTUbOw/lb+joYQU8+HonJJ44SLDBw3U3YLI5ihuozAPQrrjTYpSC16XpqJTjPX7Vjbg33YyENYLV098080glnAUoePCt7S3GKcrV7pfuNN43SIbHZJFCHb2PFM9Ff2SyQi5GdYbm/TN2vaKuAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MtlT4qBA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MtlT4qBA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3551C1F00AC4;
	Fri, 31 Jul 2026 22:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785535648;
	bh=n6thkXjT/XUjV7go1KyidjVelaYNKy1ds00L0h9TO+s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MtlT4qBA+AW2qP2igW/ijnm3baqXmxI1E3YDv/OWBlee/fclmaoKWFk/jnMNqEowg
	 kOVZReCkerS1/0UerVdXsUa9pMVDkmnv2MV4wt0A/gWEsiI2Hdne9OKtBTjPtrljPe
	 +c7Q0pHbxi8WXDG9lOEnqYwVBTL9r8JCBUN8oHn7Hk5jL6FAVeHWqkuoSjy/3mY7jM
	 QjzBvTpajmi4rC5uWs8Cep6H3XfQK3Ps/pal7kYyJqWWa+wk7+OHrlr5BTZ2sQT+Ro
	 hQ+LMsbz71WTWlVVvuuyOxt6zbYWRVYVDw4KyURv9uZkqtUbiNtsFhdpvZGIyeJRAh
	 ZYSsjNKkXwppg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 3/6] ata: libata-scsi: route non-zero LUN commands
 for multi-LUN ATAPI
Reply-To: sashiko-reviews@lists.linux.dev
To: "Phil Pemberton" <philpem@philpem.me.uk>
Cc: cassel@kernel.org, linux-scsi@vger.kernel.org, dlemoal@kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20260731213503.2379771-4-philpem@philpem.me.uk>
References: <20260731213503.2379771-1-philpem@philpem.me.uk>
 <20260731213503.2379771-4-philpem@philpem.me.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 31 Jul 2026 22:07:27 +0000
Message-Id: <20260731220728.3551C1F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Flawed LUN validation logic in atapi_xlat() incorrectly checks the=
 host's max_lun instead of just the device limit, triggering a WARN_ON_ONCE=
 and failing commands for ATAPI devices attached to SAS HBAs.
- [High] Unconditionally clearing bits 7:5 of CDB byte 1 in `atapi_xlat()` =
corrupts commands that repurpose these bits, such as SECURITY PROTOCOL IN/O=
UT.
--

--- Patch [3]: [PATCH v8 3/6] ata: libata-scsi: route non-zero LUN commands=
 for multi-LUN ATAPI ---
commit 3d48864344b5c5d234865e96735b1a7de55c13b5
Author: Phil Pemberton <philpem@philpem.me.uk>

ata: libata-scsi: route non-zero LUN commands for multi-LUN ATAPI

This commit modifies libata-scsi to support routing commands to non-zero
ATAPI LUNs. It updates __ata_scsi_find_dev to allow non-zero LUNs for
ATAPI devices and modifies atapi_xlat to encode the LUN into the SCSI-2
CDB for non-zero LUNs.

> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -3012,6 +3012,20 @@ static unsigned int atapi_xlat(struct ata_queued_c=
md *qc)
>  	memset(qc->cdb, 0, dev->cdb_len);
>  	memcpy(qc->cdb, scmd->cmnd, scmd->cmd_len);
> =20
> +	/*
> +	 * SCSI-2 CDB LUN encoding: bits 7:5 of byte 1 (3-bit field).
> +	 * Always clear those bits; only set them for non-zero LUNs.
> +	 */
> +	qc->cdb[1] =3D qc->cdb[1] & 0x1f;

[Severity: High]
Does unconditionally clearing bits 7:5 of CDB byte 1 corrupt commands that
repurpose these bits?

For example, in SECURITY PROTOCOL IN (0xA2) and OUT (0xB5) commands, byte 1
is used as the 8-bit Security Protocol field. Stripping the top 3 bits would
mutate protocol 0xEF into 0x0F, which could break features like Trusted
Computing (e.g., AACS on Blu-Ray, Opal) if a userspace application issues=20
raw SG_IO commands to the ATAPI device.

> +	if (unlikely(scmd->device->lun)) {
> +		if (WARN_ON_ONCE(scmd->device->host->max_lun > ATAPI_MAX_LUN ||

[Severity: High]
Will this WARN_ON_ONCE incorrectly trigger and fail commands for ATAPI=20
devices attached to SAS HBAs?

If a multi-LUN ATAPI device is attached to a host controller that advertises
a large max_lun (such as libsas drivers like hisi_sas which set
shost->max_lun =3D ~0), the condition checking if the host's max_lun is
greater than ATAPI_MAX_LUN evaluates to true.

This would unconditionally fail commands directed to non-zero LUNs with
DID_ERROR, breaking multi-LUN ATAPI support on modern HBAs.

> +				 scmd->device->lun >=3D scmd->device->host->max_lun)) {
> +			scmd->result =3D DID_ERROR << 16;
> +			return 1;
> +		}
> +		qc->cdb[1] |=3D (u8)scmd->device->lun << 5;
> +	}
> +
>  	qc->complete_fn =3D atapi_qc_complete;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260731213503.2379=
771-1-philpem@philpem.me.uk?part=3D3
