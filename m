Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2EC36493F
	for <linux-scsi@vger.kernel.org>; Thu,  9 Jul 2026 15:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783610315; cv=none; b=rgAZxG4VzoOw5cXryaKYdmyGdUfS5Pkjt8eMH9zNI4umFidNWQ/PyIRftl6n/uv70cBiCjCMi46S8uPg8lF7GymxcGrRJ1hSPTwhOCeZlzIdOtUgMyef12CpkOJXYFw2ECXZo7Pzn5Xz3MDSKxBqX0xc5wuPSckHk/V7fR0GmvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783610315; c=relaxed/simple;
	bh=8CnuUARHPCPptTb3hJ90bxeh9e0Sem80Fojq3APBbCA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=G4efQGGm5WYxO0Bo3AbcIqzUepU8Op1QmqwxeSpXjuin2hYZs1J5VjA62c0xOKc1gOJ5LXp+Et7Qygff/RESdPpDuC4xVMYCxxFsdydY8/RAW8X2xz1ASLutGD9NK9WdjXhJdVaqGqh6vsQvOQ8TMljRcS0F+OhXVlaOKYcZT0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PkBQ5WJ7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PkBQ5WJ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF241F000E9;
	Thu,  9 Jul 2026 15:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783610314;
	bh=9zAaTOf4G2i02S6qAVwqr7fnzE21g/d9IazouCzWgiU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PkBQ5WJ7FAhX3SfluEp3lo41kO+vDrGoy6yGcqgM9qA1QnKP3RFmwWvJNAZ4BFzFZ
	 ADdzt6h/Too16fvyRJ1a5ElPAJ3NJJmFngWlVTv7jCAgcTt44LfC9/67IBrGwdv7jM
	 I5JeTaEyGGMTl1/Mukac5U+8Mv4a23AGDviS4IhKz9cyexiHRyUEhW7aqyZoikaGnG
	 fOYhY5HhH50vXI2uSJ3ggGAPDDQ/TQkoNf3R+JIBDN5e6bEko9DpqYuyWHhL/tnQSq
	 jcLFC9XfDdw186dFPF6WgN5xidHcVmFfqiYwfOZuBnVatfg7rEzJtus71fWap5KvwH
	 3YoFtB+HXm6TQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: scsi_debug: fix REPORT ZONES alloc_len underflow
 OOB write
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ibrahim Hashimov" <security@auditcode.ai>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260709150631.45018-1-security@auditcode.ai>
References: <20260709150631.45018-1-security@auditcode.ai>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 09 Jul 2026 15:18:33 +0000
Message-Id: <20260709151834.6FF241F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Rejecting a REPORT ZONES command with an allocation length small=
er than the header size (64 bytes) violates SCSI specifications and breaks =
legitimate host queries.
--

--- Patch [1]: [PATCH] scsi: scsi_debug: fix REPORT ZONES alloc_len underfl=
ow OOB write ---
commit e364d5684dfdc126ea92154dab5b52f73d6c269d
Author: Ibrahim Hashimov <security@auditcode.ai>

scsi: scsi_debug: fix REPORT ZONES alloc_len underflow OOB write

This commit adds a check in resp_report_zones() to reject a report zones
command if the allocation length is smaller than the 64-byte header size.
This is intended to fix an underflow and subsequent out-of-bounds write
when calculating rep_max_zones.

> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 9d1c9c41d0f99..2fa887c65b61b 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c

[ ... ]

> @@ -5911,6 +5911,11 @@ static int resp_report_zones(struct scsi_cmnd *scp,
>  		return check_condition_result;
>  	}
> =20
> +	if (alloc_len < RZONES_DESC_HD) {
> +		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 10, -1);
> +		return check_condition_result;
> +	}
> +

[Severity: Medium]
Does rejecting the command here when alloc_len < RZONES_DESC_HD violate the
SCSI specifications?

The SPC-5 and ZBC standards mandate that allocation length truncation is not
an error. Host applications may probe the zone list length by sending a
report zones command with a small allocation length (between 1 and 63 bytes)
before allocating a full buffer.

Will returning a check condition (invalid field in CDB) break these
legitimate host queries?

>  	rep_max_zones =3D (alloc_len - 64) >> ilog2(RZONES_DESC_HD);
> =20
>  	arr =3D kzalloc(alloc_len, GFP_ATOMIC | __GFP_NOWARN);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260709150631.4501=
8-1-security@auditcode.ai?part=3D1
