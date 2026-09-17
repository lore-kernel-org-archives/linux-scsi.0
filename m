Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4234BE44C
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 13:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789650595; cv=none; b=fQFamyu2HR0CPylldiA8uXPABEaeAGrrO14WxtpP/SoC3305LZC1dFW7ixMu2qEkdKmhCRjMxiCdYgUuPfSp6E4DmSSlBup+xl6EvF9VwQVYgv9DUmWokCsR/6/VjQDrXlRS1LkAyvl52qQklYxuBBxxLYWb/+SdStjzDKQxeck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789650595; c=relaxed/simple;
	bh=6WrdqCqx9k9K1+n+nNP0ElmPHnQgg3uZIgCdUlGtXsk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hdvvGsaQHcAwinu+V6x5Q+ugtlobhW/UIra2uxV9AY5ulz5reuk9O8lBPTH5St4FIp4JS862CteOINrTdqHlch4VDBwAwJe8U/PtxrX/itXRQUVzfKFeZqPbyDNrnBlKupqu+32NfYaUGrgj5tekiUGdY/CRFlfDtMT0cx2hMS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VhFkNGBb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VhFkNGBb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1136F1F000FF;
	Thu, 17 Sep 2026 13:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789650589;
	bh=H02z605fpzWy5gcwE7pplfWPLAm2eibyvl2UJ08314I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VhFkNGBbe9D6T3qCFp42122HmrXM540VumMYYFxh3x50mgCEbB8E1e+nAUVTSv/4v
	 xnOSuW7Gx2iahNnKUcSGiolo0QqXzGX5W6gIh0x0yc9JvSGwbNE1p1KcfkvT3r9tKp
	 6hn78nhNDrGrdazRm+0GSktiJ6oW9rvYyDDn6JEA4DlQRaI6L74nMQUWtqvhcjHXYw
	 BBYOsuu9hv10TuNzVA/y6pl+TwS9rlMGCHaxL1IQ1+bvmp8zrgYYUrjf4ahRzmdGVI
	 FTza4jY4BOfnlsbytBzoAzELD9oR0AxJzSO2SCY1CTWt801GN0XXtTVmAW0KfuGoN1
	 fnuQlVuq632WQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 4/6] scsi: scsi_debug: Enforce physical block
 alignment of zoned writes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Niklas Cassel" <cassel@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260917125445.1376493-12-cassel@kernel.org>
References: <20260917125445.1376493-8-cassel@kernel.org>
 <20260917125445.1376493-12-cassel@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 13:09:48 +0000
Message-Id: <20260917130949.1136F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: scsi_debug: ZBC write physical block boundary check ignore=
s lowest_aligned
--

commit 6fe3c0eff911c1b4e6a4a33707f2eb37306c8d19
Author: Niklas Cassel <cassel@kernel.org>

scsi: scsi_debug: Enforce physical block alignment of zoned writes

This commit enforces the requirement from ZBC-3 that write commands to
sequential write required zones must end on a physical block boundary.
It does this by adding a check in check_zbc_access_params() to ensure
the transfer length aligns with the physical block size.

> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 41c8d958f4458..64f32d97455d6 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -3980,6 +3980,16 @@ static int check_zbc_access_params(struct scsi_cmn=
d *scp,
[ ... ]
> +		/*
> +		 * Writes must end on a physical block boundary, that is, the
> +		 * transfer length must be a multiple of the physical block
> +		 * size.
> +		 */
> +		if (!IS_ALIGNED(lba + num, 1U << sdebug_physblk_exp)) {

[Severity: Medium]
Does this alignment check ignore the physical block offset?

If a ZBC device is configured with lowest_aligned > 0 (for example
zbc=3Dmanaged, physblk_exp > 0, lowest_aligned > 0), valid write commands
to sequential required zones where the ending LBA perfectly aligns with
the advertised physical block boundary (meaning lba + num - lowest_aligned
is a multiple of the physical block size) will be rejected with an ILLEGAL
REQUEST (UNALIGNED WRITE COMMAND) sense key. This breaks device emulation
and fails valid I/O. Invalid writes might also be accepted, violating the
ZBC-3 standard.

Should this check subtract sdebug_lowest_aligned to compute the correct
physical block boundary as required by SBC-5?

> +			mk_sense_buffer(scp, ILLEGAL_REQUEST,
> +					UNALIGNED_WRITE_COMMAND);
> +			return check_condition_result;
> +		}
>  	}
> =20
>  	/* Handle implicit open of closed and empty zones */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917125445.1376=
493-8-cassel@kernel.org?part=3D4
