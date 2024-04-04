Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCD071733
	for <linux-scsi@vger.kernel.org>; Thu,  4 Apr 2024 21:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712266731; cv=none; b=mDdWUB8+ZuScOTSeaLeLHPCXRQomypsvI0xA7LFcTNN62Qc2v3bPqTX1dWk8Z8y4JyHGr570E0DMGm7UjZctxSv07rGMWovRZCOfx/H9lT1iGss1xUwuM8wR7D8ciDMXKs4lkkESeUx3tzrO8s1Jj3uIQVKEbhc9UPX0UNS9Cwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712266731; c=relaxed/simple;
	bh=E/UpqdA/DdH7qXMdG1UtEiHJs0aNHCVgBWGG3Tvajlc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UDnvJzRn5Rfd8dOUx7oLsEmJ70+cnnZr6Ir9T4+Xe8ArwtH1IV1XnjoroBAIVtsUGvgnhUJs4uz6xeNQVOSv8ZBZyoI2PznylUGxafz10KXUMCAdGCWqGJNqwwbYYnrjc25J6Lm60BIGrqMsDpem+aPCnsz/CohbHsrEsLLaaTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LodeHX4V; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LodeHX4V"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-56e0e1d162bso1512019a12.1
        for <linux-scsi@vger.kernel.org>; Thu, 04 Apr 2024 14:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712266728; x=1712871528; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O6dDcyZ/tHAvBWUUlreDvkor5IMuBmQC+VJDEPOgAak=;
        b=LodeHX4VezsygVkIgweC//SKgOj0Vu69m0IbEyCKyP3fm+EkAAqfuq5d3B7Yx+6BPy
         0TI0mE+b0c3jm0mXUFDGNFWgjU5Ja6ffxGgb3wrB8saWmShqVIHKmbe0Ee2iBc2Bz/64
         uNXDZIUhD/LBg4AiDWQbDMJ5eo0FTNwZDnpTfElLtTbrEhl1ekD/6awIZFb2YP4qjgRk
         fo5ctz0KBF/p5tQSCBXJcF9JbbdJLmbewNH5/q82WtjYuOfTmnTNtno/3uSufq0ugfPk
         cEI0ofhSI65Pce/p/XCOOCAARHCXTGSySroLYBas3EQxuXj3riFEZNaMtuoTM1Sz1azg
         ie7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712266728; x=1712871528;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O6dDcyZ/tHAvBWUUlreDvkor5IMuBmQC+VJDEPOgAak=;
        b=CSDtJDyKpBads3rcXJmyHSK1ArgCoLrwdomYXf1joX2gWM4YeifP+zWDV5bn7SRu0d
         BbI+2RGkb9iZgkbpZhRF7zZdHOBLDdY6QCLtqPaTB7gSZwmHXHYfrMHU0X04ZaBkePSq
         yPsiBLWe9rIM7vFUz/KIaX8++b6UA7jURvVebpNOjuBXKHOyBHiUQ2FC+lY2rvqNH+YP
         OuhBavNMVTROGJuDMdLrLQ7gAqcr+QX5dAoG6Aym2hd65dcZc0m+MQsHFmhXNzZhgzxa
         20UypjR9oPLD5OEwBr90jCDFkXpPtXW1r92NPZ+z9RQyFOoL/50TbBA/O4d3eZyXyPo0
         u3Bg==
X-Gm-Message-State: AOJu0YwlUXYe0SXZSiX8SVsjva3uKUYnfjw/A7Sfo2ivWY2mx5kTdRKU
	XITjiJRze/G4YZWvd/abTNSgyxsRgxDJrgXM419fiO6Rogg0aoBIlt50ejB1UZ98sasy5Js3Qm8
	wHMQSoOpBnG6GmmXXTEARmm+nEB/mjK1L5WR2
X-Google-Smtp-Source: AGHT+IH1GAmqnEPSHMvHUPjmUKgJNlOi/EMeWUeguDm5LYYHvKwkE7vzjJo9HAtLKaHbWUVR91/UOVNd8f/td8BIjX4=
X-Received: by 2002:a50:d696:0:b0:56c:5990:813e with SMTP id
 r22-20020a50d696000000b0056c5990813emr2183878edi.13.1712266728344; Thu, 04
 Apr 2024 14:38:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <5445ba0f-3e27-4d43-a9ba-0cc22ada2fce@cox.net>
In-Reply-To: <5445ba0f-3e27-4d43-a9ba-0cc22ada2fce@cox.net>
From: Justin Stitt <justinstitt@google.com>
Date: Thu, 4 Apr 2024 14:38:36 -0700
Message-ID: <CAFhGd8pTAKGcu2uLzUDDxto1sk5-9zQevsrXp-xL0cdPcGYaGg@mail.gmail.com>
Subject: Re: startup BUG at lib/string_helpers.c from scsi fusion mptsas
To: Charles Bertsch <cbertsch@cox.net>
Cc: linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Apr 1, 2024 at 3:43=E2=80=AFPM Charles Bertsch <cbertsch@cox.net> w=
rote:
>
> I have hit a kernel BUG at lib/string_helpers.c:1046, apparently invoked
> from module mptsas.
>
> I use kernels compiled from source from kernel.org.  I hit this when
> trying to step up to linux-6.7.11, after skipping some number of
> versions. Doing git bisect on the steps from 6.6.0 to 6.7.0, I ended with=
 --
>
> 45e833f0e5bb1985721d4a52380db47c5dad2d49 is the first bad commit
> commit 45e833f0e5bb1985721d4a52380db47c5dad2d49
> Author: Justin Stitt <justinstitt@google.com>
> Date:   Tue Oct 3 22:15:45 2023 +0000
>
>      scsi: message: fusion: Replace deprecated strncpy() with strscpy()
>
>      strncpy() is deprecated for use on NUL-terminated destination
> strings [1]
>      and as such we should prefer more robust and less ambiguous string
>      interfaces.
>
> The failure occurs during system startup, the six scsi disks are not
> found, apparently one of the udev tasks is near death holding an open
> file within the /dev directory.
>
> The apparently relevant part of the startup log is attached.
>
> The result of running lspci -v is also attached, as run by an
> unprivileged user, in which the relevant part may be --
>
> 04:00.0 SCSI storage controller: Broadcom / LSI SAS1064ET PCI-Express
> Fusion-MPT SAS (rev 04)
>         Subsystem: Intel Corporation Device 3478
>         Flags: bus master, fast devsel, latency 0, IRQ 17
>         I/O ports at 4000 [size=3D256]
>         Memory at b8910000 (64-bit, non-prefetchable) [size=3D16K]
>         Memory at b8900000 (64-bit, non-prefetchable) [size=3D64K]
>         Expansion ROM at <ignored> [disabled]
>         Capabilities: <access denied>
>         Kernel driver in use: mptsas
>         Kernel modules: mptsas
>
> Only one of the systems I use for testing has this hardware, and has
> this problem.
>
> Trying to follow advice from Documentation/admin-guide/, I built a
> kernel with more recent (most recent?) code, identified as 6.9.0-rc2_64.
>   The problem remains, with a similar start-up log, attached, but now
> with two "cut here" entries, buffer overflow at
> lib/string_helpers.c:1029, noted as "Not tainted", and invalid opcode at
> lib/string_helpers.c:1037, and now listed as "Tainted", presumably from
> the immediately earlier error.
>
> Please let me know what I can do to help.

Interestingly, after viewing the stack trace you provided, the last
line before a fortify panic is

2024-04-01T19:18:28.000000+00:00 zGMT kernel - - -
mptsas_probe_one_phy.constprop.0.isra.0+0x7ff/0x850 [mptsas]

looking at this object file at that offset in gdb we see:

$ gdb $BUILD_DIR/drivers/message/fusion/mptsas.o
(gdb) list *(mptsas_probe_one_phy+0x7ff)
0x2f4f is in mptsas_exp_repmanufacture_info
(../drivers/message/fusion/mptsas.c:2984).
2979                            edev->component_id =3D tmp[0] << 8 | tmp[1]=
;
2980                            edev->component_revision_id =3D
2981
manufacture_reply->component_revision_id;
2982                    }
2983            } else {
2984                    printk(MYIOC_s_ERR_FMT
2985                            "%s: smp passthru reply failed to be
returned\n",
2986                            ioc->name, __func__);
2987                    ret =3D -ENXIO;
2988            }

with the offending line (+2984) being a printk invocation.

I am not sure how my patch [1] is triggering this fortify panic. I
didn't modify this printk or the string arguments (ioc->name), also
the change from strncpy to strscpy did not introduce any strnlen()'s
which seems to be the thing fortify is upset about:
"2024-04-01T19:18:28.000000+00:00 zGMT kernel - - - detected buffer
overflow in strnlen"
or
"2024-04-01T22:23:45.000000+00:00 zGMT kernel - - - strnlen: detected
buffer overflow: 9 byte read of buffer size 8"

Charles, does reverting my patch fix the problems you're seeing?

>
> Charles Bertsch
> 1-480-395-2620
> Phoenix AZ US

[1] https://lore.kernel.org/all/20231003-strncpy-drivers-message-fusion-mpt=
sas-c-v2-1-5ce07e60bd21@google.com/

Thanks
Justin
