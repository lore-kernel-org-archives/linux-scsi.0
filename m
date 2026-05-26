Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F7A407CEC
	for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 15:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779807733; cv=none; b=r9dex/5YoLftKoy8LKKDck+0RFJbff+CiMRDJJL9P+s5Raiz3xJFhJ5bq5P6pfWdwmsbPohxcc9fqeJCj/2zgqF0Bqz7uZz8s5HHzBuBqECF4/y4oSkEZLFPwjQNTxuh1T7Ft8SkQKcLdNZBTpu74P82mL2ZMkNTCU/WmwhkvtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779807733; c=relaxed/simple;
	bh=yb+0omux6d1zyLgvLzeZABk2GNuWtKQ1yrpCoQCsmR0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RCs0+0B2MLx2syzjj7stPI7YSHO4ma6ns4e2K++kHGGiz08v3lixRa+xToF18UhPZDujgglOcN4Pp1ePjNTunGSEjhonIAFxxTX/y7oBzvleI+SLFscKutpfp5XvC3U28LeQhDeWM2dP7vs9X0q7d6Dx7hAyrW0MaAZsqm5J8bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-67da63ae541so5674161a12.0
        for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 08:02:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779807730; x=1780412530;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MLTPgXz6PTE+WNmbiors/d1TQS2Sqmrm+U6hNBea8hs=;
        b=DqokIUE1Yz1UZHGrtX8WcxaqpxmD2l2bcJs3KCyfpzt+hRwT/cSJ9f9Q+AlUbTUFKW
         OcUkexuQVfu8+60IdLDhXxXta3WKyQ2lUZs0eeBHHNE5aB5jr9swejv9DrOItUhqQ9xp
         7oVaDRnikNwXekDaxa8cKRaqLfp+0ugeYH1yySV47zvKtLGzXrni6aaqBr3uJ2HKcpm+
         mjry62kKv4DiGm+HEUfcJlzH4RSokqkiF0jPbgep74f0dbnsrUrjUu2Ie/kIq2gpAVhp
         +UrySFB1pHaf9CqgnniDRXATM515dToR+FBFDzAEFJe43/9n/eKfHpdqFJ676WODQd5w
         RE0Q==
X-Forwarded-Encrypted: i=1; AFNElJ8rEkTTq2gEhwlQqvoKnGk/S4VkAHs914cSBh6lEbTN1R6HbVXupV7xl6MI3ycZ/BMUiy8ZBKF/JFwc@vger.kernel.org
X-Gm-Message-State: AOJu0Yzb22YZcza6wY/bLKvFdf/kNR1GVes6gpEVfp9alFGpssNnOQe4
	H5MJnQPAT/wof0Fo8b6SQZkCRf8ZElVi8kuYaYmhKTOCGKBWzTcPpOVWaSkpC5QNV0o=
X-Gm-Gg: Acq92OEhcxrThGcYAaTn1TF7m+kkFuRDKENqWcmoLHTQD+tq6S+wEnnyj/1sB0xvcxJ
	nTUEpIJkxPA3DUiRYyAgWmQVaVPXO0Nj03Xtu+fPVcfo2oUmfA7tFe0gxWyMrGBXVjGb8z5OraY
	UqXjyUmXFVTij8QCi8oWBoYCqnHPw51f8kVynQRgRsuHPT7j4d1Cao5/5bsA3OuBDexTFQZ9vSm
	6lvMHbhj/opqZdSf1m+7zHouVOSZpFBaPGPeAnAa18tMujsxLps1lBpkx1CKPhEHzWW5Ql8/u08
	zN+ZZr6Fo5GW244JQYS9JFu7Q7YME2vdFSS8ePPHYSqMyKGdBNtWz1ZGCyX9pEsVo/ljPYJtn/r
	bP8G78pqStZ9fohCVsH6yOuRZrWC0HWvR5PgRbOw2biKwYr910hWI4oOnsztPjbEPtj2V18qbQy
	GxsRGydF2qY08x53XqWIb4NUDK3+a9LY12rh08QizPGcHAvsh/I0xdmo+L24t6
X-Received: by 2002:a05:6402:40d4:b0:662:ac7e:aac9 with SMTP id 4fb4d7f45d1cf-6889cc4eb4cmr9699055a12.20.1779807728208;
        Tue, 26 May 2026 08:02:08 -0700 (PDT)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-688baf1f0afsm5105500a12.17.2026.05.26.08.02.01
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2026 08:02:03 -0700 (PDT)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-687d82dd690so4855932a12.2
        for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 08:02:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/mpSaMghAAJyMSlTRDv+zTlvNM9fvaPLyRzOo/EAcucfeNkNtWkwXdjhtBcARxAFku0xeu/b480b8i@vger.kernel.org
X-Received: by 2002:a05:6402:360a:b0:674:40c3:f047 with SMTP id
 4fb4d7f45d1cf-6889ca4520cmr9385916a12.12.1779807721391; Tue, 26 May 2026
 08:02:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1779803053.git.u.kleine-koenig@baylibre.com>
In-Reply-To: <cover.1779803053.git.u.kleine-koenig@baylibre.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 26 May 2026 17:01:48 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUVoNg-rSV_hDcvi6KCosmE=SMcxUj2Y8fkoJ=33zMSXw@mail.gmail.com>
X-Gm-Features: AVHnY4KG1TJnpMipnk7rqdd9LGhhF-uK_MvXjYFynbh1jLKZ-eyBikYr9yO02y4
Message-ID: <CAMuHMdUVoNg-rSV_hDcvi6KCosmE=SMcxUj2Y8fkoJ=33zMSXw@mail.gmail.com>
Subject: Re: [PATCH v1 0/8] zorro: Improve handling of pointers in zorro_device_id::driver_data
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@kernel.org>, Max Staudt <max@enpas.org>, Andi Shyti <andi.shyti@kernel.org>, 
	Helge Deller <deller@gmx.de>, linux-ide@vger.kernel.org, linux-m68k@lists.linux-m68k.org, 
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	netdev@vger.kernel.org, linux-i2c@vger.kernel.org, 
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	"Christian A. Ehrhardt" <christian.ehrhardt@codasip.com>, "Christian A. Ehrhardt" <lk@c--e.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Uwe,

On Tue, 26 May 2026 at 16:17, Uwe Kleine-K=C3=B6nig (The Capable Hub)
<u.kleine-koenig@baylibre.com> wrote:
> this series is about improving the handling of pointers in struct
> zorro_device_id's driver_data.
>
> While it's ok on all current Linux platforms to store a pointer in an
> unsigned long variable, it involves casting that loses type information.
> This can be nicely seen in patch #7 where after profiting from patch #6
> the compiler notices a missing const.
>
> Preparing for that change, all zorro_device_ids are converted to use
> named initializers, which is also a nice cleanup that could stand for
> itself, as it improves readability for humans. (That is necessary
> because an anonymous union can be initialized by name, but not using a
> list initializer.)
>
> My motivation for this series is the CHERI hardware extension. With that
> pointers are bigger than longs and thus you cannot store pointers in
> zorro_device_id::driver_data. So this series is also about getting
> support for CHERI into the mainline, but I hope the clean up effects
> mentioned above are justification enough to accept this series.

Thanks for your series!

> The dependencies in this series are as follows:
>
>  - Patch #5 depends on #1, #2

s/5/6/?

>  - Patches #7 and #8 depend on patch #6.
>
> So if the ata maintainers agreed to merge their patch #1 via scsi, and
> Geert agrees to patch #5 and that it's also merged via scsi, patches #1,

s/5/6/?

> #2, #6 and #7 can go in without further coordination.
>
> Patches #3, #4 and #5 are only about using the same initialization style
> for all zorro_device_id and can go in without coordination.
>
> Best regards
> Uwe
>
> Uwe Kleine-K=C3=B6nig (The Capable Hub) (8):
>   ata: pata_budda: Use named initializer for zorro_device_id
>   scsi: Use named initializer for zorro_device_id
>   net: Use named initializer for zorro_device_id arrays
>   i2c: icy: Use named initializer for zorro_device_id arrays
>   video: fm2fb: Use named initializer for zorro_device_id array
>   zorro: Simplify storing pointers in device id struct
>   scsi: zorro7xx: Make use of struct zorro_device_id::driver_data_ptr
>   video: cirrusfb: Make use of struct zorro_device_id::driver_data_ptr

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
