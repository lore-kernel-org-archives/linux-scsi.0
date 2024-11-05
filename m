Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3048D1D4325
	for <linux-scsi@vger.kernel.org>; Tue,  5 Nov 2024 11:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730805476; cv=none; b=UbLiikMjxGCR/4gixWR2ODbiXBs1bx/0jrOxA+uSZ4D+llPe6JuF6xAcOwDTZvwTlZiVgK1r89oSB3H18ZzRBWKyvyuLqvUcZDowQ1p7f2qKlQorXYanyo0iDV52clVUY7yF2HE2X3pLJrdOpiovaxK/d09fa2J2S+0QXZBYElI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730805476; c=relaxed/simple;
	bh=h2nzQHSvEmOQ0i7APXzljzV2efUHb7Wc9CJ3zzIFZjs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YenlX3u/1nXcpg9hzwtj268S5kOUoOAkh6IjuOMsMlMdmrIqeow3K8yKxpt5UWVSo+SWkF6WchEBVQo9tPOfTu3J7Qs0T5V94ty1rEYR0yXRwCjbcVZRcfQZKF7JAXZXlIe76Ilt+/AaNZPB75Y3q33DqfRHWucdh/LeKhWYkrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DmUphTHG; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DmUphTHG"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-539d9fffea1so5501046e87.2
        for <linux-scsi@vger.kernel.org>; Tue, 05 Nov 2024 03:17:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730805473; x=1731410273; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A0xsFr3ehhiA4xfERHzYgCVV2IYmm2FDZy/jkXL6kF4=;
        b=DmUphTHG8stClAn5zbibCrlZoQQ0YAwFA9hFfkm9pFSnOLbTKzfRBiqS2V9gx81rBj
         dbNGF8dwesVJ5FHyGK+UPNfZVa+eN3WTf6oN63zd6UJR8wvzdApGVu5qrwqCBXew28lO
         GlOTYHvf67UHkSNwwCpqIN75cLLURQPEUeeDzuJdwpWMVQFoGx0Jzk6sGbqnDiTxzXdT
         rUvj5ip/7os5Z7VX3TQjGhwR1IP6JKBo4N2QTeo3iwhz814laJIYTVu+gYoX0Mm84s7/
         Eq0I8jrgAr/UQ67hDSO0EDZ43XEqn2CAOY7GdccuVeTW+m41CwBNrVihLCjpYtmOLWf9
         qBAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730805473; x=1731410273;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A0xsFr3ehhiA4xfERHzYgCVV2IYmm2FDZy/jkXL6kF4=;
        b=n1eagO4nnwkUx4B7+dKz48SNwvxenKXrSmIC0n4O3ATZ901PP0fANhHnP3VxDNuIMX
         OiZdgtM277guyycvnInW9/Ye4Z2WcjWdxngHwBMj1gIxGNesUDuNlYs1ieM+ptxdWoJ6
         ZDVzO4W+VfrBe2qaehN3vpDQhOgt231jSYvYH5AvRkjsfP/CPpHSsCWh25HqIfXV09mZ
         PzLBd7H4+TxqWLFbCBpidQZpOg5gsS/d942alpZh6jFu3g/7y6iRquw5zNjIjKRZ4yMi
         6msuAKXIi4XOR5dnZ09J3jM6676Syr18ADpbNGWvYHlKniY0q6Q3JzYIdzfJd3kdHKmQ
         ZjtQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjKJneEsITMWnKpOwghENY98ZX2SnhwY0TunRWZiBmYbqNG2q0ij1ft5GoH0Ax1J+jVnH003ZrTh4d@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0AbaUUF54r+vEDeDz5e7U3R1jNF8gLWqS+dHDGz/Ne4vv6uA8
	+kNVaneunLUGZf2mn10lyhvS9jKZGI4utycWBE5onFVP4aPU3UAAYMubHxrgWtlfqnktdFVujcz
	mZ8ppO5PB6Qq0hZmc2fabVowua30=
X-Google-Smtp-Source: AGHT+IF/QnsUCs/PyqbZ6YWDRixQFjF1oM4EVTif6dscnAcW4KNzLPeg0H7zZmcCc6zqCuGi8U6s79gaYZdbTqc8At0=
X-Received: by 2002:a2e:bc15:0:b0:2fb:6181:8ca1 with SMTP id
 38308e7fff4ca-2fcbdf5f91emr192090251fa.6.1730805472367; Tue, 05 Nov 2024
 03:17:52 -0800 (PST)
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
 <CA+=Fv5Q_4GLdezetYYySVntE7KBB2d-zhNGR3rXawsvOh_PHAw@mail.gmail.com>
 <alpine.DEB.2.21.2411042136280.9262@angie.orcam.me.uk> <yq15xp25ulu.fsf@ca-mkp.ca.oracle.com>
 <20241105093416.773fb59e@samweis>
In-Reply-To: <20241105093416.773fb59e@samweis>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Tue, 5 Nov 2024 12:17:41 +0100
Message-ID: <CA+=Fv5R4S-3BQO3wHVG+WKhaO10MV6=yyc1F1qGcAFAShM6K8w@mail.gmail.com>
Subject: Re: qla1280 driver for qlogic-1040 on alpha
To: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "Maciej W. Rozycki" <macro@orcam.me.uk>, 
	linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

If I look at how some of my other SCSI cards are handling this on
Alpha I see that both sym875 and aic7xxx selects 32-bit masks. aic7xxx
uses dma_get_required_mask() and sym has it configurable in kernel
config but seems to default to 32-bit. I guess it's possible to use
dma_get_required_mask() for chip revisions < ISP1040C . Seeing how
other scsi drivers have similar solutions? I know, again this is
missing the point. The ISP1080 does work with a full 64-bit mask.

From the Tsunami manual we have:

"Table 10=E2=80=935 PCI DMA Address to System Address Via Direct Mapping

Window Size          WSMn<31:20>             Translated Address <34:2>
....                            ....                                 .....
2GB                        111.1111.1111TBA         <34:31>:ad<30:2>
4GB                        N/A
000:ad<34:2> (monster window only)"

"The DMA monster window is enabled by PCTL<MWIN>. If enabled, this
window lies from 100.0000.0000 to 100.FFFF.FFFF, which requires a
dual-address cycle (DAC) access from the PCI bus. This window maps to
system memory as defined in Section 10.1.4. Because the Cchip=E2=80=99s
interface to the CPU and the CAPbus protocol between the Pchip and
Cchip only support 35 bits of addressing..."

From this it seems like any access to the "monster windows" needs to
use DAC, even if the card has full 64-bit addressing capability and is
plugged in 64-bit slot. On Tsunami based alphas, this seems to happen
when you go above 2GB memory according to table 10-5 (or 10-6 for
S/G).

Magnus

On Tue, Nov 5, 2024 at 9:34=E2=80=AFAM Thomas Bogendoerfer
<tbogendoerfer@suse.de> wrote:
>
> On Mon, 04 Nov 2024 20:40:40 -0500
> "Martin K. Petersen" <martin.petersen@oracle.com> wrote:
>
> > Maciej,
> >
> > > force 32-bit DMA addressing for pre-ISP1040C hardware and let the
> > > system determine whether 64-bit DMA addressing is available for
> > > ISP1040C and later devices?
> >
> > Yep, that is the correct approach.
> >
> > Thomas: Can you confirm that your SGI hardware has a C rev 1040 ISP?
>
> they are ISP1040B, so IMHO the revision is not the point.
>
> Thomas.
>
> --
> SUSE Software Solutions Germany GmbH
> HRB 36809 (AG N=C3=BCrnberg)
> Gesch=C3=A4ftsf=C3=BChrer: Ivo Totev, Andrew McDonald, Werner Knoblich
