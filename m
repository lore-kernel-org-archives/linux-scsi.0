Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2893EAC83
	for <linux-scsi@vger.kernel.org>; Wed, 27 May 2026 13:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779888362; cv=none; b=n5GJDFVjmK9/7S7c9PcF8W8cX/+t6EFgkm7JyQMsgv/4VNgbjDRGkNW5wDmcMKpFzKlTaBviNzgeUzPnqNXD0f9vFu37IZl+Wr+NcVrYlR3yPVcVeB3CiQLs8/MUkb1NZ4dZ9WEyGBVErf4SCy21uzH4dc1vdJk6yPjSjEkUZsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779888362; c=relaxed/simple;
	bh=tmDU4VguE+cwpfpInPS+PXjfh3XEe4XV+vkqOU8kHK4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sySA5Y5Mu0GXxZ5BSfCwA6QTTCxQ1KtoTZXraNRR06QLJZUL5lYzRjCebCbbhC0HdlJtKefT4PeimKoZMb4cn8NROWU7RtsvrKToGuMFUX8VJfDJg/+dqN8JEktnEaGlRjLz3LAFa6XR0XOJgc+zWeE2lFVfbDZacb0Ep7C3CWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-41576c5c01cso7217937fac.3
        for <linux-scsi@vger.kernel.org>; Wed, 27 May 2026 06:26:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779888360; x=1780493160;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9MuSPc8y576tayBCaWdrNcab8/lH09ziazVq9lwM/2k=;
        b=oupIa+0r+8nTJw+kaw0U0SNyVzr8SYf6UOjoqIgSff9KE42cj5xcXl7WOCGRV1b2EA
         0vm2pD4yzKCFx4xbWeod3zhUbSXzEwDhiYNlU9r/8Pg+cDcAhO7Vfp739jcDoI+VFjXD
         5HGJWx6R9mV4Xx8bGUXyRinh2lfHmBGtSiJYFhNg2Szro1+VYGu1WufzjS9YPb/JggK7
         CuQzhNlgvML7oNOOahig3vsQifY4COkyx3sq/G1aWyeOb5fM7GB5es3Ke4Qzcyp9Px5s
         5so9AXZeJVPN/0gPwUbt/AJYt1v+0qbs57UhPToLiovqzWPz33vW6af5YWesZSl78RrO
         ARhg==
X-Forwarded-Encrypted: i=1; AFNElJ+boiy9Y+iC2shieeV9fr2NiwZoRtxVlAVYZQpUiUhdkTJEAHW6uEdmDJxpjwAgWNoEbNc7ZdBB0BmL@vger.kernel.org
X-Gm-Message-State: AOJu0YzPJH8a270pOcxhNDdEDJ2QSiMZ2q3t5Feep+G22uyeSNPiMbyq
	FXf0xFZ0hx0NVBXlgmgKUd6mmel4akkNGyUKHNNP9CJajvM6bVI38UUst/gZZc1UsJ4=
X-Gm-Gg: Acq92OF1k5emm7ldDC78Faa5gdoK9DBvxFzAg9Exc5XhbC1qTvvqC1EyOk4mtZ5PgRz
	oVp+C+isY22TbdRvpvqHOhPNI47DTYgD32VHYiFqcB2k0vnvIozdaLVa1F1PakTklAhfpcuqND9
	P1FX1FAlBXZ9aP/t9GbedkE9NdsNdfx0kBo8k3H5MMHTOYpbSvQT97V1YxYic07xVTiJQld8Zpo
	Z6sErWe/wrNjxXLzBPejYVfDlaBgel31R6SfzPZ2ZYG8XnZyUVpFae9VQ+LMwj62Ow/YHPxabtO
	QYsu8Xf+26eMPnXWwOZy3itjMVhukUVpVcsb3EPrYEJfsWN+VGhLA7m9Y+ICvLj75AQOT5iaWGa
	xkqXUwhlrJ77kZdBry9h2aMNJJbczXTn3OPMt4AmZA9aTUAUtPj8IgORFape0FwEqpUZAsLajLG
	zjT4Qr6vkj9oik3YQh7DRPk+Fb0cWNUJrb9GX3Q9JX8TQIa7LHVOVfu0c1hzDs
X-Received: by 2002:a05:6870:a0b2:b0:439:baac:9069 with SMTP id 586e51a60fabf-43b5aee755bmr14431344fac.35.1779888360181;
        Wed, 27 May 2026 06:26:00 -0700 (PDT)
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com. [209.85.160.53])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-43b639fd705sm17570075fac.15.2026.05.27.06.25.59
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 06:25:59 -0700 (PDT)
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-43bfe055ffbso1313943fac.1
        for <linux-scsi@vger.kernel.org>; Wed, 27 May 2026 06:25:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ89SzhgjlC6zI5hde6g/AUoKEelkJQP8+qowOjuc7oIEtbkgKmKPKh9B4TTXV+QvqGKMPVHq9c4DA3l@vger.kernel.org
X-Received: by 2002:a05:6122:3102:b0:56e:e9cf:7134 with SMTP id
 71dfb90a1353d-5865ee6c055mr11675886e0c.3.1779887909452; Wed, 27 May 2026
 06:18:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1779803053.git.u.kleine-koenig@baylibre.com> <49576a7501128c93ef318566ed7faefce163f1fd.1779803053.git.u.kleine-koenig@baylibre.com>
In-Reply-To: <49576a7501128c93ef318566ed7faefce163f1fd.1779803053.git.u.kleine-koenig@baylibre.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 27 May 2026 15:18:17 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUFCGKUCDBLiX70bLBUGxU7iZRGT0hEipkrM2FkjE3v6Q@mail.gmail.com>
X-Gm-Features: AVHnY4K9MKooRiuSGEh5fNQ2eTKctG0rOT_zroLTx4bk0lQkHEgucmZG57_gNvg
Message-ID: <CAMuHMdUFCGKUCDBLiX70bLBUGxU7iZRGT0hEipkrM2FkjE3v6Q@mail.gmail.com>
Subject: Re: [PATCH v1 6/8] zorro: Simplify storing pointers in device id struct
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@kernel.org>, Max Staudt <max@enpas.org>, Andi Shyti <andi.shyti@kernel.org>, 
	Helge Deller <deller@gmx.de>, linux-m68k@lists.linux-m68k.org, 
	linux-kernel@vger.kernel.org, 
	"Christian A. Ehrhardt" <christian.ehrhardt@codasip.com>, "Christian A. Ehrhardt" <lk@c--e.de>, linux-ide@vger.kernel.org, 
	linux-scsi@vger.kernel.org, netdev@vger.kernel.org, linux-i2c@vger.kernel.org, 
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 26 May 2026 at 16:18, Uwe Kleine-K=C3=B6nig (The Capable Hub)
<u.kleine-koenig@baylibre.com> wrote:
> Technically it is fine (on all current Linux architectures) to store a
> pointer in an unsigned long variable. However this needs explicit
> casting which is an easy source for type mismatches.
>
> By replacing the plain unsigned long .driver_data in struct
> zorro_device_id by an anonymous union, most of the casting can be
> dropped. There is still some implicit casting involved (between a void *
> and a driver specific pointer type), but that's better than the approach
> to store a pointer in an unsigned long variable as this doesn't lose the
> information that the data being pointed to is const.
>
> All users of struct zorro_device_id are initialized in a way that is
> compatible with the new definition, so no adaptions are needed there.
>
> Signed-off-by: Uwe Kleine-K=C3=B6nig (The Capable Hub) <u.kleine-koenig@b=
aylibre.com>

Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
