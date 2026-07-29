Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7007B4963C2
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 13:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785332741; cv=pass; b=NJkVe+FGQ+n5CYbofh0yWLuzhrrr8dWuxOfvlnKTCLA97liM+xE6Y29Zrg80YDb/VhR5oiztN+gr2LLpBTrkB4Kl84+FwVaDjgjsPr2ZMrKXamdsJa7B07YrVQ1OrRrUssJadsvaJtzjKJCornqlJzOKny8D3pHmsI/tjlLlzxI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785332741; c=relaxed/simple;
	bh=UZAhy5157NkSAMSWJcdNZefOEQdqg3ZnXPVybrWCqrM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aj0gOsgUUeuOC6K8FEpwrzbFqssBN4vs1KMhe/H4g+iN9Q1FVuhXWSoMATh8Cm7cjUx4U8GW7IsHm6KylihVnLOMdrEv9/5X+yBotLfX+r32qav6Anr9wg0P3JP9oHwmr4f0kSagt+XipLj7QeZ4sY32ad8Jgu1urLIRRD3Pekg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=chWEUca4; arc=pass smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="chWEUca4"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-81dfdbd86d1so10644807b3.1
        for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 06:45:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785332739; cv=none;
        d=google.com; s=arc-20260327;
        b=mAHHAOF8TqQ14AdVa6G/ltGTuJRyPdbrI1n45dPFwFhxQT+MVrObPEaef1CnFP56su
         0ySe1XREdN4CtCHSJ5/EQOl/HioOaotN1NjCc7Np60ODaERxkbqildMuM7QyJsps6KJl
         2hl9kpR+O6JSMCDFNBNOwIdjn4hjkCraI7u1gcMOYgS7aFCLANj5g6WjM12x5kNa4fot
         EbS8R6GpOqzIVbDmqdmC88gQK1v6L+/XN+md8swpCzvFCWH8sj3EkyZIGeuAl+ZqaVbG
         s5atQho78fSa5y64FOBwcUQvTmpuFBWAX3UwRJ2vhUBwcl0xEWZ3lb1IDvIa8DB+oLeL
         kgHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SHtZAPYn3Wc91D71uLVL563MpKOhtIJrqDFEQxe1/jE=;
        fh=Ty+I8mUVWTooDtiL4oVWzVydXKvOujenM0Ha2RRxzjQ=;
        b=LYbTlyk6XqmZ66iARp5nvCIMQwTcfrwzqcsvI8F4nMfH/AkMkvqeffztVET0m4KH2h
         2dDZvP1SieZsi6lhh0r+1Z7YsfkzQe6a59Vh+gzJtkZlBiy5IRtoMEHD32ufEIkWBlwT
         CHnzVh7t71KOQccBsJgbMV9PzrTAXUGjxgmzznFLoUqOXgJfyJCtO+vnrzt46/ZvwD8X
         8fwaIhoXYpRMTR2ubJReYg6sjVeYemDz9s93/vXu7MR6HLFnXQgLsE7OIqsmbjcPAOvv
         OS75PWAugpe1P34MXQwyBwUtUe+qI59lVndBm9Lo4oTrDKtiAFPRdD4dKhN+rr6eSGFM
         uqEQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785332739; x=1785937539; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SHtZAPYn3Wc91D71uLVL563MpKOhtIJrqDFEQxe1/jE=;
        b=chWEUca4FTVNfCwKcW4Q9TaCtwloZxppT6AI+IxPPO7mjujJKlrQ+ARfITCLQVZFFK
         qjJMeVRGPT+bOLxeCufn+K+zaztiBTgPl6uW0JWN91pEyZtOhufrK4BBE8LR9FVsq15y
         NruhKJBnN7Z0dj7o0CklK2JgXUc5LZwcMce6XBhxNDkXhml0x3ujG0Dk7uYxHgb8Htqi
         S0iu2x61ih1nEDMOw0/tJgI1a6vmt7eKbXOCIPFBOESGdUT5OsFcTrBmxDQ0IzE9RJIX
         8HNpvtDOW9B79d0+pFgcqiKWF1cSilXj4HDYuFiJCLB/4TzSEUQy1oWE3ptmgSi6hlZ9
         rLrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785332739; x=1785937539;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SHtZAPYn3Wc91D71uLVL563MpKOhtIJrqDFEQxe1/jE=;
        b=fcWHKJA7qtR4BfzQmYgDrPFe7OgeT6fZn7vz5CQ7DZ8C4VWNC9iJb5bg1QGLsgc5TW
         6swtCXW3uuhx6AWY8gRNnxspc2+YSD8L+esexSy1NXDIWRqjAh58DPC+qrOUIaNP4ZFQ
         rDConOOJjQhXTb2sBDUu1Rz/UNIKjf4b4Ym+uNAKvIp4GFnOHoHq17X+XJHUrwSq0pCi
         JNFcOmGyOSqv3RGvo/UNJvie7nSlmexPNR9uu7SFtlZy5HIsounwbz7wwn6iVSH4lskl
         CWOQkwzqxKxrn18Gp3vUdQnhYVbuELPIoA6vyS1Eu+1JUHW6eDjbBRyAK/J0vzyqtXL6
         MgpA==
X-Forwarded-Encrypted: i=1; AHgh+RovB5/jrgS+sswoT52AS0qfMU9wNNbkchEc16HCHnzvsM8s8UF1GuO/IyL0YPcJ0PZv69yaeFM8DbJ0@vger.kernel.org
X-Gm-Message-State: AOJu0YyMcVrwoBWzLLIuJmx2U+zxgl2+5bbUkOsljcCbIp+JgQLN9Eox
	AYHMByCwQk+HK/vWZgOH1dJvIRr7WSQ3RLwXFMdnhNffkEwLZadCiOL7TcMfqxIIRhiU1F8qS0T
	4Vq/4CBUN1lfpNCEHfjXkIaxhZtlW2P8=
X-Gm-Gg: AR+sD12ZbWPB0j356keox9uDXRSRCN2FxprhFAMsmHCXdZzQd7WnNzqwb3u/z9LRtJn
	vhOX7GmBkUifLoQyOSGI3zqxLtSFwgFH0sWmMmacUhxy7QNn3ZioAPQEQ5WJxIdIo1fRh4NAm5t
	4G1wWs/Mlr5hoRH23ubGk9DD4tI9NbVpMSOSc9S+wNgJ/C4scvXseUIQ+eRHGHSsQLHTWPYuHLU
	W36MdwDM0tS/OekoDnVTzgqQEdkqhTljgzO3JuS5bVfds04477OJuXKPgCEwoC9gZaFpM2w29vu
	b77FSf1bKMQOjvf/AcCA0Rqwfsx5XvKWuI25zPno9T8=
X-Received: by 2002:a05:690c:6c01:b0:81e:1437:5763 with SMTP id
 00721157ae682-81f99247c84mr32859177b3.62.1785332739192; Wed, 29 Jul 2026
 06:45:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260716230411.2767394-1-tarunsahu@google.com>
 <20260716230411.2767394-4-tarunsahu@google.com> <20260717024938.128D91F000E9@smtp.kernel.org>
In-Reply-To: <20260717024938.128D91F000E9@smtp.kernel.org>
From: David Jeffery <dhjeffery@gmail.com>
Date: Wed, 29 Jul 2026 09:45:27 -0400
X-Gm-Features: AUfX_myRPaVDt58yJr6A2eZEJEygxGVewYG3ucJaoFeFR_lLDJKTrjk92Ni0vOU
Message-ID: <CANghDUVJNULztJ+-8G=PD9eXjdBF=QuHyXhYszzZO5rtzyj5ag@mail.gmail.com>
Subject: Re: [PATCH v19 3/7] driver core: separate function to shutdown one device
To: sashiko-reviews@lists.linux.dev
Cc: Tarun Sahu <tarunsahu@google.com>, linux-pci@vger.kernel.org, 
	linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 16, 2026 at 10:50=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [High] The refactored `device_shutdown` discards the parent device poin=
ter returned by `get_device(dev->parent)` and re-reads `dev->parent` inside=
 `shutdown_one_device()`, creating a TOCTOU race condition that can lead to=
 reference leaks and use-after-free.

This gets cleaned up in the next patch, but I'll rework it so that
this patch has no functional code changes and is only a code move into
a separate function.

> --
>
> --- Patch [3]: [PATCH v19 3/7] driver core: separate function to shutdown=
 one device ---
> commit c3cdb15ac9b6efba6077cade25c652c124eaa9c7
> Author: David Jeffery <djeffery@redhat.com>
>
> driver core: separate function to shutdown one device
>
> This commit refactors device_shutdown() by extracting the shutdown logic =
for a
> single device into a new separate function, shutdown_one_device(). This c=
hange
> is intended as a preparatory step for supporting asynchronous device shut=
down.
>
> > diff --git a/drivers/base/core.c b/drivers/base/core.c
> > index 78b90326addb6..82a7af1f3ba2e 100644
> > --- a/drivers/base/core.c
> > +++ b/drivers/base/core.c
> > @@ -4898,12 +4898,48 @@ int device_change_owner(struct device *dev, kui=
d_t kuid, kgid_t kgid)
> >       return error;
> >  }
> >
> > +static void shutdown_one_device(struct device *dev)
> > +{
> > +     struct device *parent =3D dev->parent;
>
> [Severity: High]
> Does this lockless read of dev->parent introduce a race condition?
>
> In the old code, the parent device pointer was captured and pinned in
> device_shutdown() using parent =3D get_device(dev->parent).
>
> With this refactoring, dev->parent is re-read here. If the parent changes
> concurrently (for example, via device_move()), could we end up operating =
on a
> parent device that we do not hold a reference to?
>
> > +
> > +     /* hold lock to avoid race with probe/release */
> > +     if (parent)
> > +             device_lock(parent);
>
> [ ... ]
>
> > @@ -4925,7 +4961,7 @@ void device_shutdown(void)
> >                * prevent it from being freed because parent's
> >                * lock is to be held
> >                */
> > -             parent =3D get_device(dev->parent);
> > +             get_device(dev->parent);
>
> [Severity: High]
> Is there a reference leak here since the return value of get_device() is =
now
> discarded?
>
> If dev->parent changes right after this call, the original parent's refer=
ence
> will be leaked. Later, shutdown_one_device() will lock and drop a referen=
ce
> to the new parent instead, potentially leading to unbalanced reference co=
unts
> and use-after-free.
>
> Should we pass the pinned parent device pointer into shutdown_one_device(=
)
> as an argument to ensure we lock and release the exact same device we too=
k a
> reference to?
>
> >               get_device(dev);
> >               /*
> >                * Make sure the device is off the kset list, in the
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260716230411.27=
67394-1-tarunsahu@google.com?part=3D3
>
