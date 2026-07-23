Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA2039DBD7
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 18:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784830079; cv=none; b=rLW9hWAmYh4OTwiAi4RpQDgkEwcMkhIa7WhNnwiHrvjCW2RWCTRfpvUfEzL4wyQKW6HKnQejhZv+9HLeKkz4/g9WNNqaeOxn3/PdWQw5sPHTayE2O5ZDm23uKL+/0Zxi+cm2zYMPVW+n2hxRKukS1jQgRHmQL4bdA/BBvBJWXMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784830079; c=relaxed/simple;
	bh=5sTUIiBmUAy/Meny6A6KZV81NDPnZjRiOJ7x6XvjrOQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=W714bKmUn8eOCr4WPMxmbkUdXqlgSWfM0KBrDtrCcoX95RzFVG0pUMlDAaQ4VFUl9cFqJ+TFTGGBy9Ao37+O8jkNrnU9xcNpCYngKfFSTN2MKzNB2HgNO7tPhAr0E3TzeofnzVUHlnJqB0v2Q87M8PY1h6crVbOkycDSgLZ0I6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EC8A1F00A3A;
	Thu, 23 Jul 2026 18:07:58 +0000 (UTC)
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 44/56] scsi: qla2xxx: Add 64G/128G port speed setting
 support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-45-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-45-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 18:07:54 +0000
Message-Id: <20260723180758.5EC8A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] User-configured 128G port speed is silently lost upon HBA reset.

Pre-existing issues:
- [High] Applying a user-configured port speed (<=3D 64G) in the Initializa=
tion Control Block inadvertently wipes out other critical firmware flags.
--

--- Patch [44]: [PATCH v6 44/56] scsi: qla2xxx: Add 64G/128G port speed set=
ting support ---
commit 8d7fef6e4c3ea0599d570b41649eeea6750d4564
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Add 64G/128G port speed setting support

This patch adds support for 64G and 128G port speeds by mapping sysfs input=
s=20
to the corresponding PORT_SPEED_* constants. It also updates the ring=20
configuration to only set the data rate in the Initialization Control Block=
=20
(ICB) for speeds up to 64G to prevent overflow.

> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
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
> +		if (ha->set_data_rate <=3D PORT_SPEED_64GB)

[Severity: High]
Does this code silently drop the user-configured 128G port speed upon HBA
reset?

If a user sets the 128G port speed via sysfs, and later a normal operational
reset (such as a LIP reset or driver re-initialization) triggers
qla24xx_config_rings(), the 128G speed won't be set here since it's > 64G.

However, the driver doesn't seem to issue the MBC_DATA_RATE mailbox command
during or after the reset sequence to restore the 128G setting.

Does the adapter fall back to auto-negotiation or the NVRAM default in this
case?

> +			icb->firmware_options_3 =3D
> +			    cpu_to_le32(ha->set_data_rate << 13);

[Severity: High]
This is a pre-existing issue, but does this absolute assignment blindly
overwrite the entire firmware_options_3 register instead of preserving
previously configured bits?

When qla24xx_config_rings() applies a custom port speed (<=3D 64G), it over=
writes
flags like BIT_8 (N2N driver-initiated login) and BIT_0 (RIDA Format2) that
were initialized earlier in qla24xx_nvram_config().

Can this break N2N topology login and other features when a custom port spe=
ed
is used?

>  	}
> =20
>  	/* PCI posting */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D44
