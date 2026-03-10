Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404694301C9
	for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2026 08:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773132140; cv=none; b=DsEfg6QVSDTJB3XadRFO8Ovj9I5H2/oWcC5Kz+p5gjH1iGjnwOl2U0x0JEV/Ftogw452PFK90NYKwn/1rXpoRskC9F8bqwvgr0qYFtF7Obj+PatjLGrOT67d4FX27iUgHtKWh+5uP5LLRhCw2yiUa5M0fHc3cIxwV/ZQInimnDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773132140; c=relaxed/simple;
	bh=+hdxOVwm077ylsjLu0wR0T6SVFeW4T69FussqsDDRHA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DNe4no7rUWWTEn+TeqWnHg6W8KAcZ7tXbMdkzn+Dd68tjATDc2y+FAUfibpdUN7WOhwoOqFsFbv3XbmEOwxL3y7VmSXTdpjjYnjsQyUwiJPwHk/Szd+RrfGhB/XDas2Xze3hr8TnqohagS8Mh6ao3tw/gJJRq3dS1PaB1m9usbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GTvciSqq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GTvciSqq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3674C2BCB3
	for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2026 08:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773132140;
	bh=+hdxOVwm077ylsjLu0wR0T6SVFeW4T69FussqsDDRHA=;
	h=References:In-Reply-To:Reply-To:From:Date:Subject:To:Cc:From;
	b=GTvciSqq+x8/zCMOtuyLli8n1vUX944BWGl817kV9StHpWn/ZCnegugKuRQsP31zc
	 BzAgQT7AReGa+w9FNTeP0MAZpzB8BrfJNqjl8scrI0LyBvBQY7rG+irphiVi9e9Pay
	 H9kcdpBYkJtzeYMnQcffp0/6DqalOD85Ero6OlpmOhuOcyq6hlw5qVhAebzG2/YIXB
	 DnMhuDw8gGVkaM59hP3I087c+z0UZ4KsUJrbnznXy+njrrp6YDnmMQ++sMxHFuRr6G
	 HFUyohjET/eAy2mVYsy+9Qp1f3+sfdypP6FF2U5DFevqkN4m7+QA91ws+sAjszCwIj
	 fWqe+XRjm8C8A==
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5a1443780c4so2867921e87.0
        for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2026 01:42:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVv5FFp4rKGvQiFc397sE8neLDNtl+pO5hEj7BysH5zB3lR9DJtLq7czVYmS0Rs4E6U++k3ZopbTkJw@vger.kernel.org
X-Gm-Message-State: AOJu0YyxTsMemqR0WhZa3NoyMsrDuhqEqjEH/T1DOe9/dEs0+U9cPCjx
	5Siil+avEn205L/JkjeprEZ3Zxq6EecqHfL3p43+5/rdFq7uCTh6tpCi4xUok4cwsVuEGFbPqLP
	P3LgDJ39Xt0EqVe6pIWM3hBJfI0i4oDY=
X-Received: by 2002:a2e:880b:0:b0:388:4329:c054 with SMTP id
 38308e7fff4ca-38a5d04ed61mr6094121fa.15.1773132138304; Tue, 10 Mar 2026
 01:42:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260309190842.927634-1-vladimir.oltean@nxp.com> <20260309190842.927634-22-vladimir.oltean@nxp.com>
In-Reply-To: <20260309190842.927634-22-vladimir.oltean@nxp.com>
Reply-To: wens@kernel.org
From: Chen-Yu Tsai <wens@kernel.org>
Date: Tue, 10 Mar 2026 16:42:04 +0800
X-Gmail-Original-Message-ID: <CAGb2v649jsoT9Uw5=gg5Zzxmgd4E04f8B8St_vUseP3JOrGG5g@mail.gmail.com>
X-Gm-Features: AaiRm50ffNFGTkd49hJolMVvUoYaIAAtO7JRlAyrrCfXMo0y-iPLjdkpqATmeN0
Message-ID: <CAGb2v649jsoT9Uw5=gg5Zzxmgd4E04f8B8St_vUseP3JOrGG5g@mail.gmail.com>
Subject: Re: [PATCH v3 phy-next 21/24] phy: include PHY provider header (1/2)
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
	UNGLinuxDriver@microchip.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 10, 2026 at 3:10=E2=80=AFAM Vladimir Oltean <vladimir.oltean@nx=
p.com> wrote:
>
> The majority of PHY drivers are PHY providers (obviously).
>
> Some are providers *and* consumers (phy-meson-axg-mipi-dphy,
> phy-meson-axg-pcie). These are the Amlogic AXG SoCs, which split the
> physical layer into two chained PHYs: the digital layer and the analog
> layer. The DSI or PCIe controller interacts only with the digital PHY,
> presumably for simplicity.
>
> The rest of PHY drivers which include <linux/phy/phy.h> do so because
> they call phy_set_bus_width(), a consumer function.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> Conflicts in drivers/phy/canaan/phy-k230-usb.c with commit 8787fa1da603
> ("phy: usb: Add driver for Canaan K230 USB 2.0 PHY").
> Conflicts in drivers/phy/eswin/phy-eic7700-sata.c with commit
> 67ee9ccaa34a ("phy: eswin: Create eswin directory and add EIC7700 SATA
> PHY driver")
>
> Both drivers are newly added in linux-phy/next and not present in
> v7.0-rc1. The recommendation is to drop the changes in this patch and
> readd them when merging into linux-phy/next.
>
> v2->v3: add conflict resolution details
> v1->v2: split in two parts to pass through linux-phy mailing list
> moderation
> ---
>  drivers/phy/allwinner/phy-sun4i-usb.c                 | 3 ++-
>  drivers/phy/allwinner/phy-sun50i-usb3.c               | 3 ++-
>  drivers/phy/allwinner/phy-sun6i-mipi-dphy.c           | 4 ++--
>  drivers/phy/allwinner/phy-sun9i-usb.c                 | 3 ++-

Acked-by: Chen-Yu Tsai <wens@kernel.org> # allwinner
