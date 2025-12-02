Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7947428D84F
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2025 13:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764681442; cv=none; b=OdaQuB/HP4rVwAwPaPF+vlwdL6tF5EiaqE6cF2TkhegLvLtdB2IdiDxsOM9NsYpNqNOz2iFnT8atmfcZZuTI5MWZZAJnDnJE0bgqcUxDnDNj4rVENHKpZeh3tIDQ50Ra3MqZEYDEgV91AlMjlwlVur2a6GhFjPyTo1eYcObNKj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764681442; c=relaxed/simple;
	bh=Ewiiuk9KUm6LnoTRDX9NRpnPqzw1ibXDKYNJ1koqGHE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZXSw0/N6sx4gSL7t3xj7DDaXS0svuT0r3ULLLPIKFb6V8dRS8J8z/AvezjefxA9UXivvNxYGnToBY1YMwtDYu/PoN0d6ClB0CUgeKQuAh7gtuKaba0IRZppSqks/m4oc2slRGiAj7XJI1a5EtAMNFLCje22TiTJmE1TgYSrCRNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PvneQpwY; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PvneQpwY"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-3e89a44007dso3927251fac.1
        for <linux-scsi@vger.kernel.org>; Tue, 02 Dec 2025 05:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764681439; x=1765286239; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+kyLJHEt2VRf/daFqXsdgYLqrzE8AW8JAwgc0paQ7SI=;
        b=PvneQpwYsanCgwdwl5wtNwHnc8dUlhEhYrY+Z0pdeAwYs5bVYHJU4gmJq9fCa0TL69
         Q/ZMIsC3UyQsN06G5lSH0F8gqdhG2CzLgYrMlaX9Vuik2QMpUR5bIf3qoge2zTin6Ktz
         w2qW7xySwHHb0mcAkaYXyi0sRiEfLOI4BK3XdyO2VP/IMF57XI4QSqplDur4RhRi+WLX
         PasG9XWFuarWFkRmpXxRrTHoUanorCsQycCH1fB+JquxYKYn6jU4hO6AagqkOqypde81
         DsvjM5qaUgDU2wc+FfeF9er20jdPi207zpXpqi76ijMnMH7SNb4+D0r625Rfzxr3NPod
         NRGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764681439; x=1765286239;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+kyLJHEt2VRf/daFqXsdgYLqrzE8AW8JAwgc0paQ7SI=;
        b=dz6zRR6radqvKlvTyiuBG8ldt/xYQbRiug6lM/6SnUMqnIO5/tpAjDF7FbSKf9EGbF
         fBvTqD5MTPLRQOGaMA3DZUkR6Zi+3jZ8bzDPuU//Y5kxORjq8AxW/vFL46YfQi6jWaMv
         7uczB1PwzGcox286wNAw6rR/GFD7oXcIDbb7chx3eNpczQSfebNFW0xWCHGvTPazlE31
         UF7+g2ka5ue7IOj5XLWEE02/pB+rPnIUSrP/O54GUxitXQmdNVX6Hve8Blqhoxk6Aamb
         dBLzaabhKPovpXI6D2S0H/49lAGs2+vCBQC/gwVib5gbVszXQBIxux2gOnCDmDv0ov3P
         n2WQ==
X-Forwarded-Encrypted: i=1; AJvYcCVvks2UvH3OGvFXFfVvuyTd6iS6d3Qo2aMhtdohtu7zi0mrt3RgoOLs2bTkUErjaO4Oa5OylKXjrCEU@vger.kernel.org
X-Gm-Message-State: AOJu0YyKourwyljHtC//ZApdnxxZf37p6+N7IJsXseb6JJIcYwJL8HE6
	Mpo16YYxf45PDwWcM6hSKSGZhk0SePxpbflICBni3SRuJNJeYuzSDhWq0LzBPrAXEXpqhFb4eUW
	NdYH7YOgG7ToKkEiW6vm4JFeMAtae/cMGaHFeKnosGw==
X-Gm-Gg: ASbGncvfUWa8WsNUi2CiE8edC/NAwbdc6aglJtCqiMKaI24y7zSrj6fZiVoQqWyQaGo
	N7cmof1Hjm3Inz8SlzuFJ0oszSy9NhlsTyrGpqLaLlx5nQDZVunGeoobkzudR//6Us3krnAOAb2
	Moq/J79LYhs9dU5JRJ6qG/0kVMZ8K7KEjmJ9BL63Cj/aBVdZFQzDNFzPmxjYMkTJM5i2LHd9d+x
	MjdAwO8cpNy0E0tFUXimVKoIrIDUhUmjiJik8eorzTAnne6Qj8rumGyuEiw1nmQFKblSZDENFLq
	KmkUgnJfcTCX4UwiKymdNtrooQ==
X-Google-Smtp-Source: AGHT+IEqLMopHE9PtNOLSyt79kw06fN2VVJC20/c1aOL2W+JAnB7NXB6D5xQegm84+GZgjVWZt6JfElfevyKbkZ/iTE=
X-Received: by 2002:a05:6808:6a93:b0:450:c56f:701f with SMTP id
 5614622812f47-4535d3f22d5mr1258545b6e.23.1764681439400; Tue, 02 Dec 2025
 05:17:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251130151508.3076994-1-beanhuo@iokpp.de> <yq1seduunc2.fsf@ca-mkp.ca.oracle.com>
 <251eb7e20d91ae9c539bde847ea102a53af82b94.camel@iokpp.de> <ef4f3e29-95ad-4094-9742-c37742da26e9@acm.org>
 <aff12099702c07370b069b1bb111302ec4660ad1.camel@iokpp.de> <CAHUa44E5-c_rN1omhuVteBt9idz_d91r1tRKNgB2=-AWQDP2Jw@mail.gmail.com>
 <2503bc57443042876541ab5e1f2afed8f83551e6.camel@iokpp.de>
In-Reply-To: <2503bc57443042876541ab5e1f2afed8f83551e6.camel@iokpp.de>
From: Jens Wiklander <jens.wiklander@linaro.org>
Date: Tue, 2 Dec 2025 14:17:07 +0100
X-Gm-Features: AWmQ_bkWXpwnyIldyn2o893IJlP6l64zNRvxvhsSuuldd2YTIGf-RMVT-sYT4lI
Message-ID: <CAHUa44FeKSqRQ68FJneK_NNFNxKHWgynLpd4355GYOuJh=S0vA@mail.gmail.com>
Subject: Re: [PATCH] scsi: ufs: core: Fix link error when CONFIG_RPMB=m
To: Bean Huo <beanhuo@iokpp.de>
Cc: Bart Van Assche <bvanassche@acm.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	avri.altman@sandisk.com, alim.akhtar@samsung.com, jejb@linux.ibm.com, 
	can.guo@oss.qualcomm.com, beanhuo@micron.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>, 
	Ulf Hansson <ulf.hansson@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

[+ Ulf and Arnd in CC]

On Tue, Dec 2, 2025 at 1:17=E2=80=AFPM Bean Huo <beanhuo@iokpp.de> wrote:
>
> On Tue, 2025-12-02 at 12:41 +0100, Jens Wiklander wrote:
> > Hi,
> >
> > On Tue, Dec 2, 2025 at 10:13=E2=80=AFAM Bean Huo <beanhuo@iokpp.de> wro=
te:
> > >
> > > On Mon, 2025-12-01 at 16:53 -0800, Bart Van Assche wrote:
> > > > On 12/1/25 2:42 PM, Bean Huo wrote:
> > > > > On Mon, 2025-12-01 at 12:25 -0500, Martin K. Petersen wrote:
> > > > > > > When CONFIG_SCSI_UFSHCD=3Dy and CONFIG_RPMB=3Dm, the kernel f=
ails to
> > > > > > > link
> > > > > > > with undefined references to ufs_rpmb_probe() and ufs_rpmb_re=
move():
> > > > > > >
> > > > > > >    ld: drivers/ufs/core/ufshcd.c:8950: undefined reference to
> > > > > > > `ufs_rpmb_probe'
> > > > > > >    ld: drivers/ufs/core/ufshcd.c:10505: undefined reference t=
o
> > > > > > > `ufs_rpmb_remove'
> > > > > > >
> > > > > > > The issue occurs because IS_ENABLED(CONFIG_RPMB) evaluates to=
 true
> > > > > > > when CONFIG_RPMB=3Dm, causing the header to declare the real =
function
> > > > > > > prototypes.
> > > > > >
> > > > > > This now breaks the modular build for me.
> > > > >
> > > > > I tested both IS_BUILTIN and IS_REACHABLE for the RPMB dependenci=
es both
> > > > > work
> > > > > correctly in my configuration.
> > > > >
> > > > > IS_REACHABLE would provide more flexibility for module configurat=
ions,
> > > > > but
> > > > > in
> > > > > practice, I don't have experience with UFS being used as a module=
.
> > > > >
> > > > > Would you prefer IS_REACHABLE for theoretical flexibility, or is
> > > > > IS_BUILTIN
> > > > > acceptable given the typical UFS built-in configuration?
> > > >
> > > > Hi Martin and Bean,
> > > >
> > > > Unless someone comes up with a better solution, I propose to apply =
this
> > > > patch before sending a pull request to Linus and look into making R=
PMB
> > > > tristate again at a later time:
> > > >
> > > > diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> > > > index 9d1de68dee27..e0b7f8fb6ecb 100644
> > > > --- a/drivers/misc/Kconfig
> > > > +++ b/drivers/misc/Kconfig
> > > > @@ -105,7 +105,7 @@ config PHANTOM
> > > >           say N here.
> > > >
> > > >   config RPMB
> > > > -       tristate "RPMB partition interface"
> > > > +       bool "RPMB partition interface"
> > > >         depends on MMC || SCSI_UFSHCD
> > > >         help
> > > >           Unified RPMB unit interface for RPMB capable devices such=
 as
> > > > eMMC
> > > > and
> > > >
> > > > Thanks,
> > > >
> > > > Bart.
> > >
> > > Hi Bart, Martin, (and Jens - adding you to this thread),
> > >
> > > Bart, thanks for the proposed solution to change RPMB from tristate
> > > to bool. This makes sense given our use case that UFS is typically
> > > built-in, and RPMB should follow the same pattern.
> > >
> > >
> > > Hi Jens,
> > >
> > > we wanted to make sure you're aware of this proposed change. The reas=
oning
> > > is:
> > > 1, avoids module dependency complexity between UFS and RPMB
> > > 2, matches typical usage where both are built-in
> > >
> > > Let me know if there are concerns with making RPMB bool instead of tr=
istate.
> >
> > We use "depends on RPMB || !RPMB" in drivers/tee/optee/Kconfig and
> > drivers/mmc/core/Kconfig to handle this problem. Could the same
> > pattern be used here?
> >
>
> Jens,
>
> The pattern/dependecy used in MMC and OP-TEE doesn't apply UFS due to dif=
ferent
> dependency structures:
>
> MMC: The core MMC config doesn't depend on RPMB. Only MMC_BLOCK (a sub-la=
yer)
> has "depends on RPMB || !RPMB", avoiding the cycle.
>
> OP-TEE: RPMB doesn't depend on OPTEE, so "depends on RPMB || !RPMB" in OP=
TEE
> creates no cycle.
>
> and for UFS:
>
> UFS: This creates a direct circular dependency:
>
> drivers/misc/Kconfig: RPMB depends on SCSI_UFSHCD
> drivers/ufs/Kconfig: SCSI_UFSHCD depends on RPMB
>
> This is why Bart's suggestion to make RPMB bool instead of tristate may b=
e the
> cleaner solution.
>

What will that mean for OPTEE and MMC? That they can't be modules if
RPMB is enabled? Are we moving the problem somewhere else?

Cheers,
Jens
