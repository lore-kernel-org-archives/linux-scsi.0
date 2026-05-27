Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125B73EF662
	for <linux-scsi@vger.kernel.org>; Wed, 27 May 2026 13:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779887716; cv=none; b=sCogST0jAtcRT31Mbo9+vUfehhxfnoiRzKsIL2ZCkAfEJKinXvvuBoBb3Y7g11bGn/qAn0oInRJPfnkBcNTwtLQqv7nAPKmCai5AUwAvjvkvPUgiFof3XPftv3qwW5iUfmuKcknw9rAVMnARo5n3dBlecspzZ65yOLhd9N2NzI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779887716; c=relaxed/simple;
	bh=NuNvxIHEMMpLcTwcLN317lzyiSS9qhMROyeREEechDs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YaWL5M9o9Nc720XkioguNCDa11sfvtj09gs3L3DQYIhciFdbzTYoJtXb+OjrIrJt4xtWdL/yUu0MGWkOauv2kDzSHUjNEMqeH7t8oo7+DI3mMx0nHzR5o5D00rMxHdOMTMwGkthQbk8E7ovKtgFaO03nGgKt7KrPRagfYvRg9KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-56f72d27e7eso12919188e0c.0
        for <linux-scsi@vger.kernel.org>; Wed, 27 May 2026 06:15:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779887714; x=1780492514;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VJbyg3CmiTY5UdW1iNZoeveCs0jnc1uKWTBV/g2Zt+o=;
        b=PALrFVElGrt7Pn2XQnno+xybhrL6QbdqJ8ksHAqmTeTrAROVnIa6UOsroabzhVYaxL
         yTZZRe9y+JgZSx+ahnsmrPk+Vwb3lebhXCRgon7Jh/OipCfu6xgdE3mQynkZnFxwEtgF
         XGVoUhCmatvFHTLph5tWXQ8txgkKRlTP7fGSkz5eqpRh+ioqnnv3K7ONjDlcCYxxB1zt
         jioOhb6PnNY4PlZDKf5P9qVoolhslNIny+jXm/aD8Yp2iZeXUx5VUV/vbprNXe+H4ssd
         P5ZYfF2YhggdAv4ZwmhiLBFWYc+IETDJUKscC9JcWHdfMA8OX7HSmTg9CcnHqGFJ2wDc
         jJjw==
X-Forwarded-Encrypted: i=1; AFNElJ8aNpWDRFybvjUFpW2+VWXeq21ycpusIlJPkAcWp52lgRljBqk1jx6NlbMQHaTRT1k2Tlvb/OStffOY@vger.kernel.org
X-Gm-Message-State: AOJu0Yz87tfTe/5gtljwdDLyqTgUnJIe3MscIQ/L0ERn7Yv35V3clJFX
	jWzFrjdwYhMxO9kzbe6sjnKDCaV/Q8GX3vTG7zlbqQ8jHZEdWWmxAR3a0f623mL4bmk=
X-Gm-Gg: Acq92OGokTK9RgFRev9uNdpShhUJGWk/zsQL2YLXu2376zUI/RbeYvGtGCgG+2+UcNh
	xwcRhJF+z//0cO77wMMV6z+ARJSzAapIJqXlvSHH51JnxKHPm3B4EUrEuV19i7J3ACToBs3laIe
	j4Bg+YWekiSGmwLuunxdCGk6Q10sni39eegjnPPGRFOTX1kVuurV0FqZEh5eUp71ibIK7zGtuSW
	nKwC21M+elIeuTb1C0mtfV7aDTT+/LTq4IsFQ+tUJ+10L3dZuB6zZFW41K1AUYwZw3Xur4Ves8k
	OGVLJC2tb7uXBNvPuw7DSvRYXkyW7dPachlp1e1mSIFlFrk99HisbtwXKFHNDjE3KCO5HqYToLO
	3qAUEij/40N2Ii1TW9VsUzyAwoinD+6kx/FIGniJiv87H9X1sucTRc5PA1E34s6yH+KQOimbu5L
	Dir5rJFfkL9ucRQUsdYfRFNaOUDqpntfstpWzdzSkXDmdE2R9UQlrbdQP6qKrbBNXSOoyRYR6q2
	oetr00KRQ==
X-Received: by 2002:a05:6122:1d4d:b0:56b:9534:c06f with SMTP id 71dfb90a1353d-58b86e788aamr6435781e0c.3.1779887714020;
        Wed, 27 May 2026 06:15:14 -0700 (PDT)
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com. [209.85.217.50])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-586f25d708bsm21340126e0c.1.2026.05.27.06.15.13
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 06:15:13 -0700 (PDT)
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-6312bdd281eso10662430137.0
        for <linux-scsi@vger.kernel.org>; Wed, 27 May 2026 06:15:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9FVG5yq/pxxzH2I3memx/KtJTAynlFBytuMbOnrCBPFV2bgJqc+Kec1tQ6omF0tfXZqUAV1A0IEbaq@vger.kernel.org
X-Received: by 2002:a67:e905:0:b0:6b1:c09:4202 with SMTP id
 ada2fe7eead31-6b10c094452mr280240137.5.1779887712838; Wed, 27 May 2026
 06:15:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1779803053.git.u.kleine-koenig@baylibre.com> <a20f52aeee9dfcacfaea43ff280fa1867878cbbe.1779803053.git.u.kleine-koenig@baylibre.com>
In-Reply-To: <a20f52aeee9dfcacfaea43ff280fa1867878cbbe.1779803053.git.u.kleine-koenig@baylibre.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 27 May 2026 15:15:00 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWJpPZ2DhrUE7cpF20Dg2+wWqXRL4D6cfDca8XLQegOVw@mail.gmail.com>
X-Gm-Features: AVHnY4JNlHO3xU2ToNfirnyHdNDRJnjKIw-cP8vUt0A5y3NPzppIp4JL0RDJSno
Message-ID: <CAMuHMdWJpPZ2DhrUE7cpF20Dg2+wWqXRL4D6cfDca8XLQegOVw@mail.gmail.com>
Subject: Re: [PATCH v1 1/8] ata: pata_budda: Use named initializer for zorro_device_id
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-ide@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org, 
	"Christian A. Ehrhardt" <christian.ehrhardt@codasip.com>, "Christian A. Ehrhardt" <lk@c--e.de>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 26 May 2026 at 16:18, Uwe Kleine-K=C3=B6nig (The Capable Hub)
<u.kleine-koenig@baylibre.com> wrote:
> Using named initializers is more explicit and thus easier to parse for a
> human.
>
> It's also more robust to changes in the struct definition. This robustnes=
s
> is relevant for a planned change to struct zorro_device_id that replaces
> .driver_data by an anonymous union.
>
> This change doesn't introduce changes to the compiled zorro_device_id
> array.
>
> Signed-off-by: Uwe Kleine-K=C3=B6nig (The Capable Hub) <u.kleine-koenig@b=
aylibre.com>

Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>

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
