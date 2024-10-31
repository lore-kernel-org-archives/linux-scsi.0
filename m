Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3D113AD32
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 22:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730413212; cv=none; b=eZT3nuNvc1zGZgbNy6m8JYGN0FkEN2SsbdxPtzDOdsIJBPJJiF3/LxY2S4M1zZQ+bopoLv5PNlBGUtVRWnAR6TRSIzJNcnMK0N4bDd48aMFuWacZgn6CA6RUqfFuKaunT9Z2yFxQaXqD/hpE01vr52ME2dpddrlZMCMtDeljPYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730413212; c=relaxed/simple;
	bh=wKenHdvD9Xsmwf25KbxDjnZ/E4m6yT+YHw5B2thxC/M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OKjNMzOy143CZN2FzCkzP8Gas1W/bDxPtKar6Y++EgXQFsuMXbq6lqiB35lGNV2ltRXXiT61f1byZxZQfRbIZpnOfC2pyFS7hwmDgilH3d2qg7Z/WJTjnLPNVbuKvG6u0AZV8xVc/fjFM9mhOXWHJmeFoHfpJvriE0gqEAVN9Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gvCalbkS; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gvCalbkS"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-37d538fe5f2so1003694f8f.2
        for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 15:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730413205; x=1731018005; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lPuBt9tGKxU2bYWu//4mDOlZIDxLti1o0AzDDXZfmbs=;
        b=gvCalbkSVpsXkttzX8/quXBo1cQFgNQyZznlKdOeTkVZ9Af3Af2hpYh0wBxEH7ZQyg
         6hmPwHw4tAMtlZvD+U7cN/ag2/06D23ptkTM/NexgP+8YREQMfxEvjPViNLnsDSD+M0S
         ZLDjRvGmnSEYoQnoeaErefxIQ7NQBjxXRj9tfkZvHgIO9pB7P5xKcFaR6NvxDQQars3f
         eeLp5demEzdfmKQpochvCo0dwNqMlGZBzjdAkbs8WYfLuthm+Ki817XCbxSASIlqBCSA
         1SUSwDP/aOTZw0vPfaZ27kDvOfVdg6QdLp/bB13XflkfOaSUnZPJSsdZBulqddVqXwF0
         krdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730413205; x=1731018005;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lPuBt9tGKxU2bYWu//4mDOlZIDxLti1o0AzDDXZfmbs=;
        b=BddS60C4FlKNAMld8X4KJ+0pbqC4Fo59I2Nk/tOs1p6GrftTzAYl061sYpsufQDJzV
         FiW7MFpnZn+3cpl9Bbtk2C3tTvZmo1alUSWqcfw50PSljQlI01HqcgYPeSM4ounHcaeH
         uyxfYztkB7p+NptuBt4GuKVT+B3r8fB7Y9MvzI2a0Y+pK8PA+rgC/17bHuV5D2RHfJSn
         PKc6IHf34S547ZLd2QxvyXaPb1PQVXOVvxJkFElNofZztOx0s7wCJobXSr5pJs+9xZY7
         QlpiQ9xwI4+wnzp7v1WdaS96XPmNlXohH5l5c9ypjPx3tvacnRUpBV02alybfI+LZDk4
         A8ZA==
X-Forwarded-Encrypted: i=1; AJvYcCVGP6mD9hsFxtzeNlcR6gxyf+dVBGoLteaoMq1MCUBVB8h5Ji3jiGQ5KVWc48uPH91EdLSIGB0Q0105@vger.kernel.org
X-Gm-Message-State: AOJu0YyBQs9/rwT7A1VXtVhJedkOkYKaxzuOg2vKl4jzqtBwng/aw/Ff
	y+mmMubAz0iLk5umovz81W93IvSB6gZEgtEP36ekSJ+61DBa30nLNB4QccbLGfGKMjtqqCZVnoq
	R6IxK9gEsalsReAfN4w1jgRldxDw=
X-Google-Smtp-Source: AGHT+IHdtpj1B84273DgTqT1ho/mgEKZKHWjlQHIP3ADb9ejBxpf0tyyupnwAktonqbhvpp5Y/IUh1+n4eNfVDiexuk=
X-Received: by 2002:a5d:6d84:0:b0:37d:5129:f45e with SMTP id
 ffacd0b85a97d-381be7c8137mr4473385f8f.20.1730413204721; Thu, 31 Oct 2024
 15:20:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+=Fv5QXiwWd+v9vHo89X_H94+P5OsT_0MEs_8dRAYJawWpy1w@mail.gmail.com>
 <yq15xpgdl6j.fsf@ca-mkp.ca.oracle.com> <CA+=Fv5TdeQhdrf_L0D89f6+Q0y8TT3NZy0eQzPPjJfj6fqO=oQ@mail.gmail.com>
 <CA+=Fv5R1c+JCkFFUvY-9=x61FZnks9GOteKETpo2FJV5u3kFzg@mail.gmail.com>
 <yq18qu7d5jy.fsf@ca-mkp.ca.oracle.com> <alpine.DEB.2.21.2410300046400.40463@angie.orcam.me.uk>
 <CA+=Fv5SXrc+esaKmJOC9+vtoxfEo1vOhgfQ739CBzmVcArWT8g@mail.gmail.com>
 <20241030102549.572751ec@samweis> <CA+=Fv5RX-u_X9UgpMg6xzwc_FwLZus7ddJJY8rHMMyUUGc3pxA@mail.gmail.com>
 <alpine.DEB.2.21.2410310517330.40463@angie.orcam.me.uk> <CA+=Fv5Q=eS1O4nwiHkJQRpvZ+JiDncnEZtqCUAyBPf1ZOtkzzA@mail.gmail.com>
 <alpine.DEB.2.21.2410311656400.40463@angie.orcam.me.uk>
In-Reply-To: <alpine.DEB.2.21.2410311656400.40463@angie.orcam.me.uk>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Thu, 31 Oct 2024 23:19:53 +0100
Message-ID: <CA+=Fv5T5okj3ntmWgYB-509xE7kfoDUUcBGorfroqGpJTNyRoA@mail.gmail.com>
Subject: Re: qla1280 driver for qlogic-1040 on alpha
To: "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc: Thomas Bogendoerfer <tbogendoerfer@suse.de>, Christoph Hellwig <hch@infradead.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 31, 2024 at 6:31=E2=80=AFPM Maciej W. Rozycki <macro@orcam.me.u=
k> wrote:
>
> On Thu, 31 Oct 2024, Magnus Lindholm wrote:
>
> > I don't have a QLA1040 revC to test with, but I've put together a much
> > smaller patch which just limits the DMA_BIT_MASK to 32-bit on
> > 1020/1040 cards this should at least not break anything while fixing
> > the most urgent problems with file system corruption on some
> > combination of hardware/memory. Thanks for the pointers to tsunami
> > chipsets though, I'll try to enable some debugging to see what's going
> > on when I hit this problem with the qlogic card.
>
>  I think Thomas will be unhappy about disabling DAC completely for the
> 1040: as I infer from his response it is indeed required for his Octane t=
o
> operate correctly, and which also presumably implies he does have revisio=
n
> C of the chip to verify your fix with.  Thomas?


From the Tsunami paper:

"The DMA monster window is enabled by PCTL<MWIN>. If enabled, this
window lies from 100.0000.0000 to
100.FFFF.FFFF, which requires a dual-address cycle (DAC) access from
the PCI bus. This window maps to system memory as defined in Section
10.1.4"

When I run the qla1280.c driver with some debugging enabled I see this
output after a while:

es40 kernel: S/G Segment Cont. phys_addr=3D100 7fff8000, len=3D0x10000
es40 kernel: S/G Segment Cont. phys_addr=3D100 80008000, len=3D0x10000
es40 kernel: S/G Segment Cont. phys_addr=3D100 8011e000, len=3D0x10000

Right after the above messages in log files I see failed read/writes
on the drive attached to the qla1040B. So as soon as I hit the
"monster window" in DMA-addressing my files get messed up.  I guess
this never happens if I don't have enough memory in the system, or if
I set the DMA_BIT_MASK. I'll try to enable some more debug logs from
DMA and IOMMU stuff.



> > I'll clean up the chip revision reporting code to see if I can improve
> > things there, this will be as a separate patch then.
>
>  Great!
>
> > I have one question regarding the hardware revision on 1040 chips,
> > according to qla1280.h we have this:
> >
> > #define ISP_CFG0_HWMSK   0x000f /* Hardware revision mask */
> > #define ISP_CFG0_1020    BIT_0  /* ISP1020 */
> > #define ISP_CFG0_1020A   BIT_1  /* ISP1020A */
> > #define ISP_CFG0_1040    BIT_2  /* ISP1040 */
> > #define ISP_CFG0_1040A   BIT_3  /* ISP1040A */
> > #define ISP_CFG0_1040B   BIT_4  /* ISP1040B */
> > #define ISP_CFG0_1040C   BIT_5  /* ISP1040C */
> >
> >
> > But when I examine the register it looks more like:
> >
> > #define ISP_CFG0_HWMSK   0x000f /* Hardware revision mask */
> > #define ISP_CFG0_1020     1  /* ISP1020 *
> > #define ISP_CFG0_1020A   2  /* ISP1020A */
> > #define ISP_CFG0_1040     3  /* ISP1040 */
> > #define ISP_CFG0_1040A   4  /* ISP1040A */
> > #define ISP_CFG0_1040B   5  /* ISP1040B */
> > #define ISP_CFG0_1040C   6  /* ISP1040C */
> >
> > Which is consistent with how NetBSD does things in their ISP driver.
> > Also, in this case the HWMSK actually works for filtering out the
> > hardware revision part of the CFG0 register, since it would actually
> > require a 6-bit mask to match the current definitions in qla1280.c,
> > right?
>

Thanks! I guess changing these definitions in the header file should
be safe, I don't think they are really used anywhere in the code as of
now. Would make a patch for reporting on the hardware revisions of
1040/1020 more consistent with the headers.


>  Well spotted!  This predates kernel.org git history, but I was able to
> track the origin down with a copy of the LMO git tree, and it has always
> been like this since the introduction of these macros in 2.6.9 with
> <https://lore.kernel.org/r/20040606125728.GB31063@lst.de/>.
>
>  This also means that the ISP_CFG0_1040A check also added in 2.6.9 with
> <https://lore.kernel.org/r/20040606125825.GE31063@lst.de/> will never
> match, possibly meaning that this code wasn't actually ever verified with
> affected 1040A hardware.  This might also explain why a later change made
> with commit 0888f4c33128 ("[SCSI] qla1280: don't use bitfields for
> hardware access in isp_config") went unnoticed that changed the semantics
> of the workaround from keeping bursts unconditionally disabled with the
> 1040A to making them enabled in the absence of NVRAM.
>
>  NB comments for the FIFO threshold surely are suspicious too.
>
>  Christoph can you please have a look into it?  It seems like something
> you ought to be quite familiar with if not for the passage of time.
>
>   Maciej
>
