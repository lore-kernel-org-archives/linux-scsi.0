Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D430A1EEA3C
	for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 13:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773235468; cv=none; b=oQW2AINKvMmy33ZwhrI+gncGuHHDBuGCsHaGL0/sk/NE9jCY8+/CSbS1ZFT0AszztqIF+Ty8lsKKkerUQuGqDd20H6ztQ65/jE6vWu2r3oCzka6O8wjje5GB0sLvlqsjKDSSXnK5IoSEHpZoy6K9SJENh20GmFUPuxstr+xtWr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773235468; c=relaxed/simple;
	bh=bQRlE5OR+3/41N9B/xBGXfMeOTv3hgeQ2WrY6jcTpBY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O21kUIjg0hvg2dSm0snRzoBYY3cLmSZbJG7K9f1FwMKAffdzBSTSuMdsSKDD23oDp0r+ov8aQfb0udNejXQSBNXj1JDGTIsT7tNky/coMarA3NI43b/PAtJomWmgKpZIdG50ybd2NU6Uo6D1Cn+/FuqHBbfcxisD6Dm+vYnkYLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-5675d609621so11793088e0c.2
        for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 06:24:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773235466; x=1773840266;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=34DR94e/1PAvLLEaib58vFA4GW0m5SGe6jvxchEhMek=;
        b=apu+k4To0aoxmWOGe3xZQD7Ascm7omR8jbC5NERTAEvkSeCQIm7yLOafQStlZxpFHD
         7IbleeoJnT1bPDaZrznujYQi3z+3rNjwsZcl4MqfbTIYLoO86G8s8oGoa0nukAtgFvm2
         6CUpL0wxr/vz2M8scFGXwb0hjTR/axo0XzAWiLvboBKCLAzDFh7CorSyRqS9G2vYwa7N
         tc21qpdRYAIW0zDIrBbDJoPoPrSP3umeXs20p+tu+FQXct9MGuWzXBgYw6p50Uqhh6vS
         fjx23pTFVP72VqyJCl489eK5ad1zfeu4dqVy7oai3UMjyyDy7VaiB89v4e/1VALVBnc4
         kBBg==
X-Forwarded-Encrypted: i=1; AJvYcCWp+hKYYrwuP8/tQWzIdgL1k9M7p66vbLwdnq6/Wm9CLir1dmEcxe53rUjqBSR1ZZ3NYROeWadqifKq@vger.kernel.org
X-Gm-Message-State: AOJu0YzTM7XZ+Hv33uQw83zR3A/7Oe20axaaIpc9Lt7mW1wI6yuSNSmB
	OiGFU0B2qyMmxoVioUfJndgFMy9MP7G05l3eKRgOQjq3Q76/ev4M1OspMW37mDKI7ws=
X-Gm-Gg: ATEYQzytB18Igy2KrN+Dyg30iAhVXnSCX+bRp70EcFEIki8KZpFgYAM+l1AAF2FRiQg
	8ZU1+6oYnN4kETGtz128EvCoEw4DP88C6LeKRkAlRYDY/DYCVOKW0w6pon6Ml95vDmtF8GMfye5
	J5L/J8UrvQx1fVUIK4uYMmEHhFYODTwNtwOtEVxKYUHQZOwIUEGT1g4umBLVdLUoEqLjdUt+W9j
	z17OrcLqlWyx0WayMUSx1m9tKgZw4D2AxUaV2eAP4WHwln6e5Yo5TJhFj7+QIQ2c/Y7gG5Jqi+R
	lj2kOta5PnxDATNkYGClJy8+yXLZs91Zg1aB5itMk8MZ/YWznTgaDnjFaY+ufcPQYn4CVNJeaHR
	9hx2P3eEh+mhVlPHkZUcdSCicir8L6pOnk42jIkuvOZ07iapFpgpWts3JIOBLl3Chsa/fQW9vVM
	HFz0dlgnFa1ff4Ug3RO1VsSg7nusuxyDmcyxRT6shi3rNX7xY1CLCvZ9ThSSbI
X-Received: by 2002:a05:6122:54e:b0:56a:f09a:f1f2 with SMTP id 71dfb90a1353d-56b47446ee2mr1000296e0c.4.1773235465797;
        Wed, 11 Mar 2026 06:24:25 -0700 (PDT)
Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com. [209.85.222.47])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-56b4645e8cesm954906e0c.10.2026.03.11.06.24.25
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2026 06:24:25 -0700 (PDT)
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-94de88e52e5so8501091241.0
        for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 06:24:25 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUdFFCqXjXJtuRdFP8nZEme0XKvABVwxrPJZ+wETvZkDlnhw1iOrxc2w+b+Synkfttwg08q8Maugr9q@vger.kernel.org
X-Received: by 2002:a05:6122:1d05:b0:55b:7494:177b with SMTP id
 71dfb90a1353d-56b4752d806mr922396e0c.10.1773234967338; Wed, 11 Mar 2026
 06:16:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de> <20260310-b4-is_err_or_null-v1-36-bd63b656022d@avm.de>
In-Reply-To: <20260310-b4-is_err_or_null-v1-36-bd63b656022d@avm.de>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 11 Mar 2026 14:15:56 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXQ8Q4jvkgFRJYhghz2BZRDC-9Mk6DbXxuaOc6C9DFHZQ@mail.gmail.com>
X-Gm-Features: AaiRm52J84H77ROK64ZWWtJfaiCpnFeKyoSRmPbi-NC8CN6Ju1TJEFxJU9gZQQ8
Message-ID: <CAMuHMdXQ8Q4jvkgFRJYhghz2BZRDC-9Mk6DbXxuaOc6C9DFHZQ@mail.gmail.com>
Subject: Re: [PATCH 36/61] arch/sh: Prefer IS_ERR_OR_NULL over manual NULL check
To: Philipp Hahn <phahn-oss@avm.de>
Cc: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com, 
	bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr, 
	dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, 
	gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org, 
	intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org, 
	linux-bluetooth@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, linux-clk@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-gpio@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org, 
	linux-media@vger.kernel.org, linux-mips@vger.kernel.org, linux-mm@kvack.org, 
	linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org, 
	linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, 
	linux-phy@lists.infradead.org, linux-pm@vger.kernel.org, 
	linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, ntfs3@lists.linux.dev, 
	samba-technical@lists.samba.org, sched-ext@lists.linux.dev, 
	target-devel@vger.kernel.org, tipc-discussion@lists.sourceforge.net, 
	v9fs@lists.linux.dev, Yoshinori Sato <ysato@users.sourceforge.jp>, 
	Rich Felker <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Content-Type: text/plain; charset="UTF-8"

On Tue, 10 Mar 2026 at 12:56, Philipp Hahn <phahn-oss@avm.de> wrote:
> Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
> check.
>
> Change generated with coccinelle.
>
> To: Yoshinori Sato <ysato@users.sourceforge.jp>
> To: Rich Felker <dalias@libc.org>
> To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> Cc: linux-sh@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Philipp Hahn <phahn-oss@avm.de>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
