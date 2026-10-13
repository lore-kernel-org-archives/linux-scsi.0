Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B5949C4A4;
	Tue, 13 Oct 2026 10:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791888128; cv=none; b=mQ1T/uGAq3SNXLPrZoI/icT6NZ8grKJzKOXTbpMjwaS5LrFEavDhlXWKJfVkMbUKcarSbNHNYBzS3LXJr5Qjejqzr1sFFxZr95imKxIV7est449Tu5w+gzmKo9A/FsVJ640OseAhEABoRzviQ+SRvHmKtsYd/apFghBUiuuKlRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791888128; c=relaxed/simple;
	bh=/Ld6u9hgodtuqXsqN2RrLY8j8lyuxdpu9yZsquQhBgk=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=F2rQH8z1oZ48DCa2D0B16MmbDHYDv7GIljEo05XaJKfIwmU9VS9dkwjslUFV3J8a+KuK68UId4Y/c/0wCDT7xSe4J5SZ843sr9HYy3FdNi37xpFNSgF6QGxOISImkqj3sTJnw8745V6bzc0aO1/61Y6LrJZIkcZlkCS+jeag4fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lc43VlOO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lc43VlOO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 812B41F000FF;
	Tue, 13 Oct 2026 10:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791888126;
	bh=fcy47mUTjsg9Xo/QA678IIwfAY26i/B6x2jH5CbXa6Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Lc43VlOOn09t9eUrw7oieJTPNfz0du1X3Bjunq2tyTJct11wczcKmDbtuzoCnnDJF
	 O55napKEa5099GtbEIfDBVq5aeGNJDnGnD+tgJ91umUDIvaVEbWKOa/jVa8KS8kqBt
	 U6qZ2LH7sWUUWjqxUEZNLiPiYmDVLYIjzarRo1Kyh42A9YCJrcJ+6AyRvMJLhbGUMF
	 dWmtN2Yn7ynUe4vsUxKc9Ojr93eNqA7adMWZEvbxa2FU7Yd9y/vKXi+5Y3csIUkuJl
	 42iJ4XiJ3KDroOjx1iiaxmiEOTzWwGbIEA/TaDqoOvbBy/nvWjJJ+QUhL/HrP1O7jo
	 852QBiIzDwxTQ==
Message-ID: <sashiko-outbox-169531@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 02/12] ufs: unipro: Move Tx/Rx FSM state definitions
 to unipro.h
Reply-To: sashiko-reviews@lists.linux.dev
To: "Larisa Grigore" <larisa.grigore@oss.nxp.com>
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, imx@lists.linux.dev, robh@kernel.org, conor+dt@kernel.org, Frank.Li@kernel.org
In-Reply-To: <20261013103003.373156-3-larisa.grigore@oss.nxp.com>
References: <20261013103003.373156-1-larisa.grigore@oss.nxp.com>
 <20261013103003.373156-3-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 10:42:06 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] ufs: namespace pollution with generic enum constants in unipro.h
--

commit ebc07859adf01890c26a7b7401dc6900f6ce9105
Author: Larisa Grigore <larisa.grigore@oss.nxp.com>

ufs: unipro: Move Tx/Rx FSM state definitions to unipro.h

This patch moves the Tx/Rx FSM state definitions from a driver-private
header into the subsystem-shared <ufs/unipro.h> header. It also drops
driver-specific definitions and updates checks to use the shared enum
constants.

> diff --git a/include/ufs/unipro.h b/include/ufs/unipro.h
> index 9c168703b1048..e0f490e11c7f7 100644
> --- a/include/ufs/unipro.h
> +++ b/include/ufs/unipro.h
> @@ -466,4 +466,24 @@ enum {
>  	CPORT_CONNECTED,
>  };
> =20
> +/* RX_FSM_State encoding, MIPI M-PHY v6.0 Table 50 (M-RX Status Attribut=
es) */
> +enum ufs_rx_fsm_state {
> +	RX_STATE_DISABLED =3D 0,

[Severity: Low]
Since these highly generic enum constants are now globally visible to any
file including <ufs/unipro.h>, could this cause namespace pollution and
build conflicts with other subsystems?

Would it be better to prefix the constant values with UFS_ or MPHY_
(for example, UFS_RX_STATE_DISABLED)?

> +	RX_STATE_HIBERN8 =3D 1,
> +	RX_STATE_SLEEP =3D 2,
> +	RX_STATE_STALL =3D 3,
> +	RX_STATE_LSBURST =3D 4,
> +	RX_STATE_HSBURST =3D 5,
> +};
> +
> +/* TX_FSM_State encoding, MIPI M-PHY v6.0 Table 47 (M-TX Status Attribut=
es) */
> +enum ufs_tx_fsm_state {
> +	TX_STATE_DISABLED =3D 0,
> +	TX_STATE_HIBERN8 =3D 1,
> +	TX_STATE_SLEEP =3D 2,
> +	TX_STATE_STALL =3D 3,
> +	TX_STATE_LSBURST =3D 4,
> +	TX_STATE_HSBURST =3D 5,
> +};
> +
>  #endif /* _UNIPRO_H_ */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013103003.3731=
56-1-larisa.grigore@oss.nxp.com?part=3D2
