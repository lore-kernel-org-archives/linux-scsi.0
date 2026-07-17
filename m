Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2FD1F7569
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 16:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784305961; cv=none; b=qyJd8wbnAeqyfXpkCGpbjwjOmWrL+jFOSvF65di5//ydlw/bgP0WVD0ZbTZ+ebFOrgLXYWM/0iWkEPN+AsWfLo8ifAa1yJwVBKmETIIoaxymyTx9/OYLr0CFZ/zwQuMSRSnUzBO1+k1GnpNdrGjN3xoEBLD7RYLURYfxRDgpvP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784305961; c=relaxed/simple;
	bh=BUeA82DN2glytlHAFfwNs3rtw5glIYkycswfveMxYD0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=V27nBThqv5g8777mKiOvC9jnGCw4p7VuwEl/EltPwqgOmgW1UW3tPpzJg35WBPRtsy/jCueyabe7JvVm2qrgB2hPCe5sscwoUzJh9/6GLG5W5z4ws4R4pcKJuOmMy+lTolk+HLxQKMWcFhOPPLgJoKk6nkuzOmOHFS2mF4Q76lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c4eQ4d1/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c4eQ4d1/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366441F000E9;
	Fri, 17 Jul 2026 16:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784305958;
	bh=1RSvZTxO8TNUBNoGyKNSvW5DOoI+EW2QoyMVQzHT2tE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=c4eQ4d1/T4i3sC3VhUTbIRxo7wfAHwBGK1+pkd9O6Vh5u48ObUVYhBXRtuPxWDTTv
	 9Hr65Zg7+YOsNlerVdeI5GHT+8bsYANrANIN0j0g66n98ZPnVhXMKLw3Nqq4g4rUci
	 qfFLU2F3w244ztsrZKTghcuo/lUsxoMLtamMGQq0Ml1+zu0049t0CSQXhEe6Z4FrP2
	 q8kAS4uhzSxsNi7vWARErL9F5CJJjKPlIIyzuOmfWk2f1VswOz2VVn1WnJugT07xC2
	 x3h1k+/VtPHd1pcMn8bdToKCsVzYd3lUn4qncu67skHPmlgtuKDdGUVgxzFriYvBTt
	 ICTSD0p5L28IQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 44/56] scsi: qla2xxx: Add 64G/128G port speed setting
 support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-45-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-45-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 16:32:37 +0000
Message-Id: <20260717163238.366441F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] The 128G port speed setting is not re-applied across adapter reset=
s, causing it to silently revert to default speeds (e.g., Auto-negotiation).
- [Medium] A Time-Of-Check to Time-Of-Use race condition on `ha->set_data_r=
ate` can bypass the boundary check, causing an out-of-bounds bit shift that=
 corrupts bit 16.

Pre-existing issues:
- [High] Direct assignment to `icb->firmware_options_3` using `=3D` silentl=
y overwrites and clears previously configured NVRAM-derived flags.
--

--- Patch [44]: [PATCH v5 44/56] scsi: qla2xxx: Add 64G/128G port speed set=
ting support ---
commit 8fb2f0a9558bd7064a13dd344fce6bb250eb5ac0
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Add 64G/128G port speed setting support

The port speed setting paths topped out at 32G. This patch maps the 64 and
128 sysfs inputs to PORT_SPEED_64GB and PORT_SPEED_128GB, and accepts those
values in qla2x00_set_data_rate(). Firmware validates the requested rate.

> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 545066f67e020..5f7bc68aab3c5 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c

[ ... ]

> @@ -4793,7 +4793,14 @@ qla24xx_config_rings(struct scsi_qla_host *vha)
>  		ql_dbg(ql_dbg_init, vha, 0x00fd,
>  		    "Speed set by user : %s Gbps \n",
>  		    qla2x00_get_link_speed_str(ha, ha->set_data_rate));
> -		icb->firmware_options_3 =3D cpu_to_le32(ha->set_data_rate << 13);
> +		/*
> +		 * The ICB data-rate field is 3 bits (bits 13-15); rates above
> +		 * 64G do not fit and would overflow into bit 16 (75 ohm
> +		 * termination select). Such rates are forced via MBC_DATA_RATE.
> +		 */

[Severity: High]
The comment mentions rates above 64G are forced via MBC_DATA_RATE. Is this
compensatory MBC_DATA_RATE command actually sent during the adapter
initialization or reset path?

If a user configures 128G via sysfs and the adapter undergoes an ISP abort =
or
link reset, qla24xx_config_rings() skips setting the speed in the ICB here.
Without a subsequent MBC_DATA_RATE command in the initialization path, does
this cause the 128G setting to be silently lost and revert to default speeds
like Auto-negotiation?

> +		if (ha->set_data_rate <=3D PORT_SPEED_64GB)

[Severity: Medium]
Is there a Time-Of-Check to Time-Of-Use race condition here between the
boundary check and the shift below?

Since ha->set_data_rate can be updated locklessly via the sysfs store
function, if a concurrent write changes the rate from PORT_SPEED_64GB to
PORT_SPEED_128GB exactly between this check and the assignment, will the
shift use the 128GB value?

This could bypass the safety check and cause an out-of-bounds shift
(128 << 13) which overflows into bit 16 and unintentionally toggles the
75 ohm termination select bit on the adapter.

> +			icb->firmware_options_3 =3D
> +			    cpu_to_le32(ha->set_data_rate << 13);

[Severity: High]
This is a pre-existing issue, but does this direct assignment to
icb->firmware_options_3 silently overwrite previously configured
NVRAM-derived flags?

During adapter initialization, functions like qla24xx_nvram_config() set
multiple flags in icb->firmware_options_3, such as BIT_8 for N2N
driver-initiated login. Using an assignment (=3D) instead of a
read-modify-write (|=3D and &=3D ~MASK) appears to wipe out those previously
configured flags.

>  	}
> =20
>  	/* PCI posting */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D44
