Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E87E21D5B6
	for <linux-scsi@vger.kernel.org>; Thu,  5 Dec 2024 16:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733415901; cv=none; b=IXSOQicHURqL97LRYZaeCTPUBqiOry53iqcRFdY3inyPpMeisnP/z6JQDBT9QktC1BPagniUDc1FZsMa8I590ZkphAURI4UrZBX8sdSzFCwK3RmR+Iarw/yZV/WuEhQFsehvoRyMHhPaF3y49TxI31BUFk+nR5AccPzF4j3V9Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733415901; c=relaxed/simple;
	bh=R7CVb9LI65y/3Qu32CYYXvSxOe5U0ZYewJNDLJ5FwCc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fz5t12GII9iwnkpRFeggaQ/aUYBKxi4zXLqucg20/yX3o/MC3AG1DaTaOueWkW1lF+Hu5u76xn5wFX1lJqGHLyIuDu47t8mKhC0Yu5zVG6CwLR4cH7A9JDteeTiKL8+p4H2kCRtvRO7W7HxWO0HGNyz21L0wFLlZNQ8liZh4KTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=3ZpoIMZn; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="3ZpoIMZn"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-53dd57589c8so2474118e87.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Dec 2024 08:24:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1733415897; x=1734020697; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ItHEVA7I8S1EP8oyTKl1F93KEEHRVDFUauUtw/1Acb0=;
        b=3ZpoIMZnwjCl4Vv5bu6PGSXVdDmY7k4Cj1zgHc6F/cvtw8CM1rNR1LTJDsCfgmd0g2
         BceSlvbQiLyYiwl1rdWJ3jv2Ns4UxCWRnsrFu4TQEusFPgx7FkT2UIodCH6L3llBjvZX
         XNAHzd6Taqadu0P2fGi/yUIsqcbc2LJaCMf0KU5YlqUl8Ra8J04m6hedyjqo7k0PtBfa
         YzZpvhommBUg5ON/+IUYW1PeMHGPsGOGeDu3G435iCu3IM89jIWqEOC9Hd0bT3dOemUj
         +5wiSeoDLmTU2wBbs3vqgyCGSboeppp2+z3qZoXORDMgU0UpKaORWbQqfQFXw+JpXtdd
         NE3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733415897; x=1734020697;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ItHEVA7I8S1EP8oyTKl1F93KEEHRVDFUauUtw/1Acb0=;
        b=DvG1bgNv4N+S1f+ihB1zlpZxfgfq1slIQ8USNna0QKrn3nL1dmjgQQRAy+dRDeSKeh
         pFSZUGZQs7QoSiJGY3Deqwb/IkVO9NEII5JysE7WUWbtvPc5dzEW6jldc86itBSg4tCf
         uja8eAVkZZO/lDoU8aSfbWeIsr9klun2goDwCWq/gz//lsuuvPfUQyP/74/H5DbpWKu9
         vFHYqLoGuAxX0/4GkwQJI7T8jCiJIfFCxlmFgyuHfnGEZuQetCclBXQujH9B4Iy7Y2BH
         iQ2Pf/0bH0K4H/gGofcM2TT+8MBpRGD4ObAwaJU/GH7THW+Vb7RHl+tQkM4z8v5DTzn5
         KQYA==
X-Forwarded-Encrypted: i=1; AJvYcCVa9eiUHdPzQ1qwFH1DqwzhVkUtpEGeN1G/dJLqtUvob/Qxe13i0pRC68kQVG+VdLy7QvFJ+7sC4n+4@vger.kernel.org
X-Gm-Message-State: AOJu0YzAcy6IxdlqeuJFAT5R9dr9wW+rWqlg+2XOFkaqz0RPZwkO1WIb
	nJrrGAWupR/UQtWnd0KJb4yaEWPc9g2nlqKSi0WTZ90cTpW4q80uRy0vhJ3G9IkJMBEPeuztPZA
	cLq1QZXIqHrsx0MwTsSfl2QF/n8BhMFcLqq8T3w==
X-Gm-Gg: ASbGnctkUkUJPvdH/y6WjpCF8bSOUUN22luJ6ifVf82IbpU+SvPhMuSbVm/IXtT7VrH
	xySQpHQYNQaRXFACfLB1UFXDDVzBOSf7gQbkt12G5PXFd76VTNGasz9hfWIsI6g==
X-Google-Smtp-Source: AGHT+IErYJU9bnmgh/S4XgU0jcrMWfkUEiJSX94XfyJ1xliCjLlWQwaDM6P30GxT6teJ6fjjXCYzQKweIZQ1ynm3Yi8=
X-Received: by 2002:a05:6512:4006:b0:53d:f6bc:23ec with SMTP id
 2adb3069b0e04-53e216f74ecmr1077273e87.5.1733415897149; Thu, 05 Dec 2024
 08:24:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241205-const_dfc_done-v3-0-1611f1486b5a@quicinc.com> <20241205-const_dfc_done-v3-8-1611f1486b5a@quicinc.com>
In-Reply-To: <20241205-const_dfc_done-v3-8-1611f1486b5a@quicinc.com>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 5 Dec 2024 17:24:46 +0100
Message-ID: <CAMRc=Mf--vRm15N2au-zvP89obcxRuk+3OOLqFtrjgg61_LotA@mail.gmail.com>
Subject: Re: [PATCH v3 08/11] gpio: sim: Remove gpio_sim_dev_match_fwnode()
To: Zijun Hu <zijun_hu@icloud.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <ukleinek@kernel.org>, 
	James Bottomley <James.Bottomley@hansenpartnership.com>, 
	=?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas@t-8ch.de>, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-sound@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-cxl@vger.kernel.org, 
	linux1394-devel@lists.sourceforge.net, arm-scmi@vger.kernel.org, 
	linux-efi@vger.kernel.org, linux-gpio@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-mediatek@lists.infradead.org, 
	linux-hwmon@vger.kernel.org, linux-media@vger.kernel.org, 
	linux-pwm@vger.kernel.org, linux-remoteproc@vger.kernel.org, 
	linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, 
	linux-usb@vger.kernel.org, linux-serial@vger.kernel.org, 
	netdev@vger.kernel.org, Zijun Hu <quic_zijuhu@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 5, 2024 at 1:15=E2=80=AFAM Zijun Hu <zijun_hu@icloud.com> wrote=
:
>
> From: Zijun Hu <quic_zijuhu@quicinc.com>
>
> gpio_sim_dev_match_fwnode() is a simple wrapper of device_match_fwnode()
> Remvoe the unnecessary wrapper.
>
> Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
> ---
>  drivers/gpio/gpio-sim.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
>
> diff --git a/drivers/gpio/gpio-sim.c b/drivers/gpio/gpio-sim.c
> index 370b71513bdb529112e157fa22a5451e02502a17..b1f33cbaaaa78aca324f99c45=
a868e7e79a9d672 100644
> --- a/drivers/gpio/gpio-sim.c
> +++ b/drivers/gpio/gpio-sim.c
> @@ -413,11 +413,6 @@ static int gpio_sim_setup_sysfs(struct gpio_sim_chip=
 *chip)
>         return devm_add_action_or_reset(dev, gpio_sim_sysfs_remove, chip)=
;
>  }
>
> -static int gpio_sim_dev_match_fwnode(struct device *dev, const void *dat=
a)
> -{
> -       return device_match_fwnode(dev, data);
> -}
> -
>  static int gpio_sim_add_bank(struct fwnode_handle *swnode, struct device=
 *dev)
>  {
>         struct gpio_sim_chip *chip;
> @@ -503,7 +498,7 @@ static int gpio_sim_add_bank(struct fwnode_handle *sw=
node, struct device *dev)
>         if (ret)
>                 return ret;
>
> -       chip->dev =3D device_find_child(dev, swnode, gpio_sim_dev_match_f=
wnode);
> +       chip->dev =3D device_find_child(dev, swnode, device_match_fwnode)=
;
>         if (!chip->dev)
>                 return -ENODEV;
>
>
> --
> 2.34.1
>
>

Please use get_maintainers.pl to get the complete list of addresses to Cc.

Bartosz
