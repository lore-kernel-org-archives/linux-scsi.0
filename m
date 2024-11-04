Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363031E3DCF
	for <linux-scsi@vger.kernel.org>; Mon,  4 Nov 2024 20:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730753382; cv=none; b=hwNli9QdKgqTH1axTs4l8DR5i7SpxUXKt6Icw5V6yr09NAcnQ8CW1GFDp6pD6GgRl1kMNc377y5JYO3nGTjyleYBNytinobaVzcmyF2IuOk8SsGDyZPFqZFFIBTr2rR/+qepM6QtMkPFW32w3nAXrzS2CN4m+HJ7duzUWIzYQC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730753382; c=relaxed/simple;
	bh=wbGM84LdqtabiW8/wWt5P5US1xkvdioc8Zo/9Mwgvr4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mqkcmxZmKn0KxB/fZ334H+7JZC35wV++HDuKLtMq/B94stByGGMpfdT7zv86A+25y/ya3/c9k7jcWELikPjmYwPPRU9Al5yAukPwrICoLoMbCwWG4ZipmkgxNA9UyJUveUPdaAVTng1Va0e4zdk+svYcphU9cloj9Wl7VJQx5Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DLIhgwcS; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DLIhgwcS"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5c9362c26d8so8632266a12.1
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2024 12:49:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730753379; x=1731358179; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sZjaHG8fwFu3j1sv6V9Mjt5M25a2LOqzbEklcG4xtuU=;
        b=DLIhgwcS1jykanTUZ6tNw7d7UpwJ1GICZazfki3c57RxSF+2coF3ewFTVRESOihqV9
         29/qvyL97zKCQRgSSFsKByakSutoNdyPNdm9NL40RMAjvup1oH+f+c13hHr78XXaCaAf
         0j2krfOe2OCf1dv23SgQlYXsRceVROuLiQp8nI4em7f7KnYIFY7sGWm4QTH7cz+WtQq6
         JbyoBIf7m6a9UKxJwI945JHXpQmWp9qOT9nqRpQ8nfJT4mIciwzBJy6IkyuoXTBGR59r
         ONm+chdvW0iWNk2NWJVDLqZcLeU8wP2EISBFWeJgQLW7tATzmoeFquD6zz7RO10XtvHX
         g+oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730753379; x=1731358179;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sZjaHG8fwFu3j1sv6V9Mjt5M25a2LOqzbEklcG4xtuU=;
        b=qc2TXkrG4QzaTFfotgKcfHmNKXSjEU7MgdwaL1IIUufRiLZqR7oFlH14HiWlLk6KH/
         QFKPKGSbe24Iy85GAQ/dINfBo2FRhTZCBEZQSXnjisLLYAEpH/k5JyMZuyFsu+Qqr5QU
         4YpTIWMRsASzQmFRbCWKkgWpJA0bWq2eqhDgfXuqmzDkwpZ2H4tFNqSk5drbgGd3ga3n
         q74j73Cq2JerjJfAu66uE07K8O4LPBxL/A5XcHpZWivkZaYgekYcU8BuhL+6xDksTtFX
         7Mu2q+PhyPGrr4zFuz5vdtiiEpqGwVKRIH6oDCH8dhrYECz1HmQwxKD8dBC2ApFLRyHO
         3uPw==
X-Gm-Message-State: AOJu0YzBWR68CHqyymROQvdW7TyrqlZ55rQj2jyPxv0gcdNGrz1rDox6
	AjqA6UeKUtPI0eCJ3wqxYc0xAallrVfuVKInpMD5/v5k3wYW3gnKezbP2SGOKgB83+aiz6SzvkA
	rt4JOROpELrfTKhI+8CZDE4H+BfQn4YBv
X-Google-Smtp-Source: AGHT+IHOwPZi87zFuGLhBxbnvWCYYvUua7G4uq/JbQkgdwU7Dk3IOTvcs5Jl4hlEP7h1SrWLxNf57U0twWPOLCt464Y=
X-Received: by 2002:a05:6402:440e:b0:5cb:6715:3498 with SMTP id
 4fb4d7f45d1cf-5ceabee80f2mr18258210a12.3.1730753378881; Mon, 04 Nov 2024
 12:49:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+=Fv5TdeQhdrf_L0D89f6+Q0y8TT3NZy0eQzPPjJfj6fqO=oQ@mail.gmail.com>
 <CA+=Fv5R1c+JCkFFUvY-9=x61FZnks9GOteKETpo2FJV5u3kFzg@mail.gmail.com>
 <yq18qu7d5jy.fsf@ca-mkp.ca.oracle.com> <alpine.DEB.2.21.2410300046400.40463@angie.orcam.me.uk>
 <CA+=Fv5SXrc+esaKmJOC9+vtoxfEo1vOhgfQ739CBzmVcArWT8g@mail.gmail.com>
 <20241030102549.572751ec@samweis> <CA+=Fv5RX-u_X9UgpMg6xzwc_FwLZus7ddJJY8rHMMyUUGc3pxA@mail.gmail.com>
 <alpine.DEB.2.21.2410310517330.40463@angie.orcam.me.uk> <CA+=Fv5Q=eS1O4nwiHkJQRpvZ+JiDncnEZtqCUAyBPf1ZOtkzzA@mail.gmail.com>
 <alpine.DEB.2.21.2410311656400.40463@angie.orcam.me.uk> <Zyh6tP-eWlABiBG7@infradead.org>
In-Reply-To: <Zyh6tP-eWlABiBG7@infradead.org>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Mon, 4 Nov 2024 21:49:27 +0100
Message-ID: <CA+=Fv5Q_4GLdezetYYySVntE7KBB2d-zhNGR3rXawsvOh_PHAw@mail.gmail.com>
Subject: Re: qla1280 driver for qlogic-1040 on alpha
To: linux-scsi@vger.kernel.org
Cc: Thomas Bogendoerfer <tbogendoerfer@suse.de>, "Maciej W. Rozycki" <macro@orcam.me.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi

I'm making another attempt at fixing the qla1280.c driver for ISP1040x
on Alpha, while trying not to break anything on other platforms, like
IP-30/MIPS. This time I'm using dma_get_required_mask(). Is my
understanding that this function should provide the minimum required
mask for the platform, assuming this works it should return something
greater than 32-bits on IP-30/MIPS. From what I can tell by looking at
the kernel source it should return something like a 64-bit MASK for
the sgi/octane but I'm not in the possession of such a system so I'm
unable to verify this.
Maybe Thomas can test the new patch? When I examine other scsi drivers
it seems like most of them select bitmasks that are 32-bit on alpha
systems. Any bitmask below 40-bits will avoid hitting the "monster
window" which is when I see trouble on alpha. Still a much larger mask
is required on SGI/Octane, my hopes are that dma_get_required_mask()
can assist in sorting this out?


Magnus

On Mon, Nov 4, 2024 at 8:41=E2=80=AFAM Christoph Hellwig <hch@infradead.org=
> wrote:
>
> On Thu, Oct 31, 2024 at 05:30:31PM +0000, Maciej W. Rozycki wrote:
> >  This also means that the ISP_CFG0_1040A check also added in 2.6.9 with
> > <https://lore.kernel.org/r/20040606125825.GE31063@lst.de/> will never
> > match, possibly meaning that this code wasn't actually ever verified wi=
th
> > affected 1040A hardware.  This might also explain why a later change ma=
de
> > with commit 0888f4c33128 ("[SCSI] qla1280: don't use bitfields for
> > hardware access in isp_config") went unnoticed that changed the semanti=
cs
> > of the workaround from keeping bursts unconditionally disabled with the
> > 1040A to making them enabled in the absence of NVRAM.
> >
> >  NB comments for the FIFO threshold surely are suspicious too.
> >
> >  Christoph can you please have a look into it?  It seems like something
> > you ought to be quite familiar with if not for the passage of time.
>
> Somewhat surprisingly I don't remember that details of a drive by
> cleanup 20 years ago :)
>
> So whatever fixes you have based on other implementations are probably
> correct.
>
