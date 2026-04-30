Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8283D9DC5
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 12:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777550888; cv=none; b=osdgqtzlvrEBdPm5AgyGDv7xZT4SM5eVh389bewujmInoUgrucwLT98aRsdOYLeBOYTWKvf8L4YFk3CwDDfCsiiuz/oesggvct61PxGVHy1CRtjIwSWBKpU27fIrLyDJQvkSb2UasAZgaMdMR892rIHDgmLjHPO/3wOWx1kdjqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777550888; c=relaxed/simple;
	bh=EZZ2E4Hk4P3ioWVMaervDcnw6ADW65oM1zGar71sbpY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k7ZF1RM3hr9OAHBnfck+rUIQGNfZKdSxbwEiL2UUQoGCEenZhudt+YJUNUF9m+/qDH4avcQnwp5AE+htGIuiJJr3OlRIFjMyY7Ra8OgxeG0hZT8ZH126EFj/X4cP2dpbl9PDkFgTZj8bgyvkX0JvFP15y7hawsAE/KrcnlODiMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-69498319ee7so1043080eaf.1
        for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 05:08:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777550886; x=1778155686;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ksIL4rip+tLI1Yx6QhQXSN6krUTnsd9SRkVzjQXrZjA=;
        b=gKkXP8yIhGXyW3AIRUL0R2KexGol/Q7FLulzsKi4zI+RbROLEVbcdND9Dy5Ke+cWaa
         VGKISYxYgI8jGZYDgYK4cLqiMwKrGVt/Lji0jUXr7mRf3yVpAHcPM7XEaV/eGNRZXQhK
         s7FWkLHFzmyC/6cqeQ6X1PAxpLSy5KiIOgdbcbsjFquodaoyepP+2PYOOuzq4Zdag/y0
         MoEhrXV1Us2A6v54McMxA1KQ5wUXz3dLbH8nYZuWY29kLdMOuTXvs5WSMcf0v/g529p0
         xUItX0Z1jhsKNmpm1wLHZ5/4ukbWHJnwPElVv1rnbfH1NYXNlqlmTGgDjFQOqfERMZDn
         haSQ==
X-Forwarded-Encrypted: i=1; AFNElJ9DE/lGUXaXxgR/OoJzu36ZVfGBrjM7qkL3Aij+8E+zGqQLbzezitqMOgv2loI3PEdZJxZDAgmjdHIP@vger.kernel.org
X-Gm-Message-State: AOJu0YwTSC2Eorli5/cnOrcsqWKhQdkRWjAEPgedaBYJkIJp0sB3+kzC
	94CHaOm9gPDM41tu7brUqH2a43kICpTZEgXVH8uetrVVxgjeKKYlnYCvp1/hD++vwEU=
X-Gm-Gg: AeBDiet+f58nB8CJ8Qg1IfPgC7F2cc/JX34OXeQ3lOc7Xvl6BPRBVcbuTXLyokmuwqc
	oq7Patw8A+bSqOgkq3I7V12NwITn2HVnwlwS0JR778/vedHIMCQi2ZMaUD1FyrpgW7YT/ToEPSa
	ujrzja24K1C9knN3RdCeDp7XnnIS3zMLAy9zOHxFcLRQL4KL3znU5AXVaeWlMRGr7evMAkUTHyM
	VOpdOqbRTkCgVIMw4289wgFzxxQdZYbQCMMIwpd7Ezcn7lE+u84SbkUan2a1EqVAKdtBJkrvNdX
	JOpNkrJc21gSRDuDLp7lgd86uLkYBIHN+KdC4SYFI434QNZhGt3tTK24HkqcZQGXO18VYYK535i
	FtjF5OMSUFjLowTrY8U1jXrHUxiow4O9Fu4FPdZyyQMmRXCAaHvGWOL+xAUBSK6G3PGjy7UJimG
	tyXTWiPnJl+jIdajZdQ/91CDkl9njbtKH6NHMQFUBi3oWhBTmPKXPQwIk94OWNjwGPbjbrUiiwU
	lM=
X-Received: by 2002:a05:6820:4c82:b0:696:6cc8:9bdc with SMTP id 006d021491bc7-6967bd820dfmr694300eaf.23.1777550886410;
        Thu, 30 Apr 2026 05:08:06 -0700 (PDT)
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com. [209.85.167.178])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6966be60886sm3128840eaf.13.2026.04.30.05.08.05
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2026 05:08:06 -0700 (PDT)
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-47bdee5bfc4so637087b6e.1
        for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 05:08:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8yQmND53v5duz+LbnIK8pvTnsHpAVmzWMLxm5MKT1RODJx1kMClBX+G/dMSADTMJE/f8x3EXXP5hqE@vger.kernel.org
X-Received: by 2002:a67:e708:0:b0:610:347f:9f3b with SMTP id
 ada2fe7eead31-62afc506100mr613209137.3.1777550404889; Thu, 30 Apr 2026
 05:00:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260430110652.558622-1-vladimir.oltean@nxp.com> <20260430110652.558622-18-vladimir.oltean@nxp.com>
In-Reply-To: <20260430110652.558622-18-vladimir.oltean@nxp.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 30 Apr 2026 13:59:53 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWbeeRmLf6Ae0Fr0un=-z7z5ONc_hDdjebP=KVkXHPbhw@mail.gmail.com>
X-Gm-Features: AVHnY4K0yYb6vTu9KdtDciwvAziqboYRX_ITZ386sa6ttixZ1EP_Mzy9gi4Pi0E
Message-ID: <CAMuHMdWbeeRmLf6Ae0Fr0un=-z7z5ONc_hDdjebP=KVkXHPbhw@mail.gmail.com>
Subject: Re: [PATCH v7 phy-next 17/27] phy: introduce phy_get_max_link_rate()
 helper for consumers
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
	UNGLinuxDriver@microchip.com, Markus Schneider-Pargmann <msp@baylibre.com>, 
	Andrzej Hajda <andrzej.hajda@intel.com>, Robert Foss <rfoss@kernel.org>, 
	Laurent Pinchart <Laurent.pinchart@ideasonboard.com>, Jonas Karlman <jonas@kwiboo.se>, 
	Jernej Skrabec <jernej.skrabec@gmail.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Andy Yan <andy.yan@rock-chips.com>, Marc Kleine-Budde <mkl@pengutronix.de>, 
	Vincent Mailhol <mailhol@kernel.org>, Nicolas Ferre <nicolas.ferre@microchip.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Claudiu Beznea <claudiu.beznea@tuxon.dev>, 
	Geert Uytterhoeven <geert+renesas@glider.be>, Magnus Damm <magnus.damm@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Hi Vladimir,

On Thu, 30 Apr 2026 at 13:07, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> Consumer drivers shouldn't dereference struct phy, not even to get to
> its attributes.
>
> We have phy_get_bus_width() as a precedent for getting the bus_width
> attribute, so let's add phy_get_max_link_rate() and use it in DRM and
> CAN drivers.
>
> In CAN drivers, the transceiver is acquired through devm_phy_optional_get()
> and NULL is given by the API as a non-error case, so the PHY API should
> also tolerate NULL coming back to it. This means we can further simplify
> the call sites that test for the NULL quality of the transceiver.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Acked-by: Markus Schneider-Pargmann <msp@baylibre.com> # m_can

Thanks for your patch!

>  drivers/net/can/rcar/rcar_canfd.c                   | 3 +--

Acked-by: Geert Uytterhoeven <geert+renesas@glider.be> # rcar_canfd

> --- a/include/linux/phy/phy.h
> +++ b/include/linux/phy/phy.h
> @@ -57,6 +57,7 @@ int phy_notify_disconnect(struct phy *phy, int port);
>  int phy_notify_state(struct phy *phy, union phy_notify state);
>  int phy_get_bus_width(struct phy *phy);
>  void phy_set_bus_width(struct phy *phy, int bus_width);
> +u32 phy_get_max_link_rate(struct phy *phy);

This (and all the existing getters) should take a "const struct phy *".

>  #else
>  static inline struct phy *phy_get(struct device *dev, const char *string)
>  {

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
