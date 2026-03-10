Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257A93ACEF2
	for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2026 02:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773110716; cv=none; b=OcwYYOpxgK60k4X10a5LaZ8SPe/U6bMQf6hggZBQj5RvrBIzx67CrAyMJicTv9JYNGPwii6ThwbxXW/ZCc/iFRG7lpnqYHL7Tw2Is9o/GyvudI9F/TyIIJfwfNQo7vmPcKjPunvFXNAw5DvxlpeMpJxNVxs9qx9HJQTWGAwrN1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773110716; c=relaxed/simple;
	bh=AiuSbGc4gyF+r0NsVvYBegnqTPdAIt4V0L/szs51RLs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A1yGtiQVYW2piZ0m4Bfqtv7i+3Sw/pCAuKW+9ec/73CPQ0tHInggCb0fjuGUkhdX2yIAZYdR2NqKc9HvlRvzH84Dl0lAxOQcupCg9PXRj/87N4u6QJEAYl6Z4vsBVpjSdxpfM9m7NiYSVuKxP3RobTu3D4G7NnhfTz/oRP5d6H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=deu669Z9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="deu669Z9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F40C2BCC7
	for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2026 02:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773110716;
	bh=AiuSbGc4gyF+r0NsVvYBegnqTPdAIt4V0L/szs51RLs=;
	h=References:In-Reply-To:Reply-To:From:Date:Subject:To:Cc:From;
	b=deu669Z9bCAa3MHzmq85IHa4IIybHro01N3INe+ETq7xl2XbjqfVmZtHlbKEs3Rpw
	 tmDIW2kRFqJXcxnteRZJq11Hw220gZXTp/2BYB4i36vmN3QlYcjnB8SKQqD/eYiveS
	 kdCfsege3WAIPqGpWp0aJs4k8pxbZ0GvI9LVkl3kqCeagxiCHPMyZQh5WFMwuv29jU
	 r0SkhBw5sUyj4Wd28Ft87E8doiuqor0WxSYfGuRbKELjs/txoCHc7aYpv4jk4tB8A/
	 duwiqpP9JaL54dfvTeud0bobzW7DtU/TskHR7IvQ8+D1CzPaM9SU8UO1JxP0q5x6zt
	 BsA6px45ozMxQ==
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-3870778358aso121133721fa.1
        for <linux-scsi@vger.kernel.org>; Mon, 09 Mar 2026 19:45:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXoFkUYlKdw6na2lgJCI4Nf10cheTOnJIJUkgK2bgdHMTj5vsgq/XWeYpAA/iPJD+Hf3MybGl4elQpv@vger.kernel.org
X-Gm-Message-State: AOJu0YzNR675iFawI0L0/hRF5gL774EOQNTkbtFVqvjgdLDjohnVNUmz
	ewpx3iBDlc09y2JDXzrJk82nMOJ0ua3ibcP7xhWfh1TroEdb6eulZ2xKohPYVbE9MFNG9z/eRyQ
	PY/BaLUstE634dSZ37Ga6cEuubwBHlTc=
X-Received: by 2002:a05:651c:1104:b0:385:c21f:37e1 with SMTP id
 38308e7fff4ca-38a40b6a2d2mr40186201fa.15.1773110714064; Mon, 09 Mar 2026
 19:45:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260309190842.927634-1-vladimir.oltean@nxp.com> <20260309190842.927634-18-vladimir.oltean@nxp.com>
In-Reply-To: <20260309190842.927634-18-vladimir.oltean@nxp.com>
Reply-To: wens@kernel.org
From: Chen-Yu Tsai <wens@kernel.org>
Date: Tue, 10 Mar 2026 10:45:01 +0800
X-Gmail-Original-Message-ID: <CAGb2v65surpnqrmv4tbH4TSrx6SaTpdbsQtCsNqwse5xwdb8fA@mail.gmail.com>
X-Gm-Features: AaiRm535EaFxYtCAjq5FIkHiBmgOxc7_e434rO98DZfg5NrM7RTttw3IOCzqW1Y
Message-ID: <CAGb2v65surpnqrmv4tbH4TSrx6SaTpdbsQtCsNqwse5xwdb8fA@mail.gmail.com>
Subject: Re: [PATCH v3 phy-next 17/24] media: sunxi: a83-mips-csi2: include
 PHY provider header
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: linux-phy@lists.infradead.org, Vinod Koul <vkoul@kernel.org>, 
	Neil Armstrong <neil.armstrong@linaro.org>, dri-devel@lists.freedesktop.org, 
	freedreno@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org, 
	linux-arm-msm@vger.kernel.org, linux-can@vger.kernel.org, 
	linux-gpio@vger.kernel.org, linux-ide@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
	linux-pci@vger.kernel.org, linux-renesas-soc@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-rockchip@lists.infradead.org, 
	linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-sunxi@lists.linux.dev, linux-tegra@vger.kernel.org, 
	linux-usb@vger.kernel.org, netdev@vger.kernel.org, spacemit@lists.linux.dev, 
	UNGLinuxDriver@microchip.com, Mauro Carvalho Chehab <mchehab@kernel.org>, 
	Jernej Skrabec <jernej.skrabec@gmail.com>, Samuel Holland <samuel@sholland.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 10, 2026 at 3:10=E2=80=AFAM Vladimir Oltean <vladimir.oltean@nx=
p.com> wrote:
>
> The introduction commit 576d196c522b ("media: sunxi: Add support for the
> A83T MIPI CSI-2 controller") says:
>
>     This implementation splits the protocol and D-PHY registers and
>     uses the PHY framework internally. The D-PHY is not registered as a
>     standalone PHY driver since it cannot be used with any other
>     controller.
>
> However, this does not matter, and is not the only instance of tight PHY
> provider <-> consumer pairing. According to Vinod Koul, having PHY
> provider drivers outside of drivers/phy/ is discouraged, although it
> would be difficult for me to address a proper movement here.
>
> So just include the private provider API header from drivers/phy/ and
> leave a FIXME in place.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Acked-by: Chen-Yu Tsai <wens@kernel.org>

> ---
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Chen-Yu Tsai <wens@kernel.org>
> Cc: Jernej Skrabec <jernej.skrabec@gmail.com>
> Cc: Samuel Holland <samuel@sholland.org>
>
> v1->v3: none
> ---
>  .../media/platform/sunxi/sun8i-a83t-mipi-csi2/sun8i_a83t_dphy.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/sunxi/sun8i-a83t-mipi-csi2/sun8i_a83t=
_dphy.c b/drivers/media/platform/sunxi/sun8i-a83t-mipi-csi2/sun8i_a83t_dphy=
.c
> index 24bbcc85013d..1143feeb4fcb 100644
> --- a/drivers/media/platform/sunxi/sun8i-a83t-mipi-csi2/sun8i_a83t_dphy.c
> +++ b/drivers/media/platform/sunxi/sun8i-a83t-mipi-csi2/sun8i_a83t_dphy.c
> @@ -4,9 +4,9 @@
>   * Author: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
>   */
>
> -#include <linux/phy/phy.h>
>  #include <linux/regmap.h>
>
> +#include "../../../../phy/phy-provider.h" /* FIXME */
>  #include "sun8i_a83t_dphy.h"
>  #include "sun8i_a83t_mipi_csi2.h"
>
> --
> 2.43.0
>
