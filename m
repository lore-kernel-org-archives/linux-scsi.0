Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A62B3BBFA7
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 06:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783407170; cv=none; b=sfCBGZC7tG/s+XDzitZ8EU43LDwyuwNpjmXbKASW6ABQXUf4+k+06KWSY0BknTX4TnwqrqMhKqipAPlS2dJQtknPC5usIgQbUWzc6919hiyzQud5ElLSLAr0Z0v14u5PWRv5A+xjmsj0n2QYgNP4QSAh9GAwMvNS2FD2Au92J1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783407170; c=relaxed/simple;
	bh=MNy89YXldidAwM3+otj+aAL2v3luhW6MlhYqmka5EX4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tmWohsk1CVeSwUg15Z/kadez716bt9hl0Buqif2scixObrF2Gd0810MC4cXG7qAi79Znz+yZk+8uxsBadjg9yheIM4+GLpVaO/RgrkFDW2ZlwbjzhK1ZGwgqfwxyUawg3Fcx4VB5+z4rsaQ541BTSSEPVhh7mQLoD5UmUWRZOv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PqDZ5k/F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PqDZ5k/F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC8A1F000E9;
	Tue,  7 Jul 2026 06:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783407159;
	bh=2amau5R1vgjPhw4WcpyNUTW1+Ta2OShpcKh/96iSet0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PqDZ5k/F4cEsp4jigWKB7H8uJqWjDb5RJL34QXzWV8xIJ4wVcrHzL9JX1usCAZjHm
	 7XwRTH/8gtbzlYdw8uDe+dxFfqLIRatABsHoy4Vbt5I/81i7DBbaTOehHzFwA93Cu3
	 iL3bAexLpvSDwhX6Rqnui0UkT912104Zc5A+U/PGYjNeNX3/br0o8E57uUqKf4qLRF
	 6xGiJMpBQYOtOBbOORHHIw0LIkpZ1cdIAKGpGmmpuYpmJwzqbTrldyzeSw8wxaIVwv
	 /KU/wEUHzPxTnm6XQ6KKC/ehqD700gSc6tonBg4nqs9kqWR2cw6QoBdKYcniwF/JKN
	 C7r/9FkviQaqw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 44/88] scsi: qla2xxx: Add 64G/128G port speed setting
 support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-45-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-45-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 06:52:39 +0000
Message-Id: <20260707065239.BDC8A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] The 64GB port speed is silently ignored when read from the firmwar=
e due to a legacy 0x7 exclusion check.
- [High] Setting port speed to 128GB overflows the 3-bit data rate field, c=
onfiguring 1GB speed and mistakenly enabling 75 ohm termination.
--

--- Patch [44]: [PATCH v3 44/88] scsi: qla2xxx: Add 64G/128G port speed set=
ting support ---
commit 64dcf15cf40895ac2298a3903e0d9735e5bc9ed2
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Add 64G/128G port speed setting support

The patch adds support for 64G and 128G port speeds by mapping sysfs inputs=
 to
PORT_SPEED_64GB and PORT_SPEED_128GB, and accepting these values in
qla2x00_set_data_rate().

> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_a=
ttr.c
> index 6cf74f8c9628d..3b24e8a5e29ba 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c

[ ... ]

> @@ -1860,6 +1860,12 @@ qla2x00_port_speed_store(struct device *dev, struc=
t device_attribute *attr,
>  	case 32:
>  		ha->set_data_rate =3D PORT_SPEED_32GB;
>  		break;
> +	case 64:
> +		ha->set_data_rate =3D PORT_SPEED_64GB;
> +		break;
> +	case 128:
> +		ha->set_data_rate =3D PORT_SPEED_128GB;

[Severity: High]
When setting ha->set_data_rate =3D PORT_SPEED_128GB (which is 0x08), does
this overflow the 3-bit data rate field during adapter initialization?

Looking at qla24xx_config_rings() in drivers/scsi/qla2xxx/qla_init.c:

icb->firmware_options_3 =3D cpu_to_le32(ha->set_data_rate << 13);

Since the data rate is a 3-bit field (bits 13-15), shifting 0x08 (binary 10=
00)
by 13 overflows into bit 16.

Bits 13-15 would become 0 (1GB speed), and bit 16 (Enable 75 ohm Termination
Select) would become 1.

Could this cause the hardware to initialize at 1GB instead of 128GB and
erroneously enable hardware termination?

> +		break;
>  	default:

[ ... ]

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index d0894cc904700..ba822c196894b 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c

[ ... ]

> @@ -5720,6 +5720,8 @@ qla2x00_set_data_rate(scsi_qla_host_t *vha, uint16_=
t mode)
>  	case PORT_SPEED_8GB:
>  	case PORT_SPEED_16GB:
>  	case PORT_SPEED_32GB:
> +	case PORT_SPEED_64GB:

[Severity: High]
Since PORT_SPEED_64GB is defined as 0x07, will this new speed be silently
ignored by legacy 0x7 exclusion checks when reading from the firmware?

For example, in qla2x00_get_data_rate() the code explicitly drops 0x7:

drivers/scsi/qla2xxx/qla_mbx.c:qla2x00_get_data_rate() {
    ...
    if (mcp->mb[1] !=3D 0x7)
        ha->link_data_rate =3D mcp->mb[1];
    ...
}

Does this leave the speed as unknown or stale in ha->link_data_rate when the
firmware is operating at 64GB, breaking sysfs port speed reporting?

Similarly, the debug log lower down in this function is also suppressed for
the newly added 64GB speed:

drivers/scsi/qla2xxx/qla_mbx.c:qla2x00_set_data_rate() {
    ...
    if (mcp->mb[1] !=3D 0x7)
        ql_dbg(ql_dbg_mbx, vha, 0x1179,
               "Speed set:0x%x\n", mcp->mb[1]);
    ...
}

> +	case PORT_SPEED_128GB:
>  		val =3D ha->set_data_rate;
>  		break;
>  	default:

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D44
