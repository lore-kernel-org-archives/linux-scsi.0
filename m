Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7686F2777FE
	for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2026 17:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769706628; cv=pass; b=qJ9qXGFgjQ2Eb6QdsFwSYF8rZ4L4uQKmQJhSiF8hqTgPK/ITuoGQ12fwe6Ets+9x9V32j/Y+iSe+d4B7z7xoF6XOcP6gtRP8QGCYwZgllQpm5b9lJb6yDcgVFVfa2SZFzJUdaqKWP2H9y0+1Jb/4meMOpoD6FexlSAQkpUXP/J8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769706628; c=relaxed/simple;
	bh=n3rWul1mPkMvcN6y/hYVs19xbPa6PYVXkQt0laaQL2s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HoQ+51Kp1UAWj5Flr8EVYamVujSRgxBtYLPCc8Ylxq6OapwlzHyM4AH8JgBopIy/9j1mwZex7J5APiaGndQG2pXuFwFniT2GSGWzYCTsS5zGcw4Mn+iS0LCSwt1vJMKcxZSJXDxYB+zqL3o7J72hrXOeBr21oEwMjBktHiw+8d0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net; spf=pass smtp.mailfrom=flipper.net; dkim=pass (2048-bit key) header.d=flipper.net header.i=@flipper.net header.b=p1RxjLD5; arc=pass smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flipper.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flipper.net header.i=@flipper.net header.b="p1RxjLD5"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b883c8dfb00so284018566b.1
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2026 09:10:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769706625; cv=none;
        d=google.com; s=arc-20240605;
        b=NtNKGZ2dlB4rVmSZpXdFJkfCXb1RwuQoTiMNh07sbh+qQy187YbTGpBJhXlrE/OmLe
         AYwaflpulvJIZJ2dsu6lAFas/AkHIYBPivt4ciXOyI8jS24EcqAsmxrQYkaKjz3wJIOy
         SpA8QKorNqzh6f6WYliui5hAHhePcET82ogz3MErEkIY9AnCwDTiSPP3DDC555vevlWc
         wpEjjveoS5vcAerM/SfjHdpd2ibZTNFZ+WcJGVoKbhHLn5EeeN1F8ouRw8XIDdynJaPB
         wBfccOVmOdJgJBDW6hMPSjp2EhUir1qG5Q7WUksQ3T/3OWk3yO5Z8lAFPjDvjTbxB70s
         X1nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=n6OCmwX/j9Xn2LVH5U+aS18pnLbo6JaXYZFOm+PY4+E=;
        fh=K6wTE724htvSMVQivhyrBGDSSZe+sWvAbippmF+WoNk=;
        b=bSQuFMs4udfmBe38b7BIzpUM+FiGn7KAxJVUOIeGuLEk+FbYup0nhoGnoNPRwRz+BU
         1KRhIOaXRq842O3aKMBqtOSDLjfoF2gyNuyCLInNrAZI8V7wRi/PDa6FY6t6twXwFHVK
         HavBj/rRM/CoKsGGZ3dRz1nEO8HQHyviosZwxT7oieurEz9GCzA81df9FcPgmH6xIWcD
         26FxHCvGO2TNQymw69aj0DdOYNpaKAuBaMWUQXxR3dZyHR3DXzIOXDad3o65wx67IEjI
         j1yRKE7zYJS9+n2pD8vTmPyytKuE77Ho6Jqn38EeAs1VGYnLeXvl2IalgGVBonVoIhea
         qi7A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flipper.net; s=google; t=1769706625; x=1770311425; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n6OCmwX/j9Xn2LVH5U+aS18pnLbo6JaXYZFOm+PY4+E=;
        b=p1RxjLD5it9KjvzdLdoZ6xiDoilz9Yh+FZ6XV8XJpyoPKCuAX+WsZVJnczexDlIuch
         2TEokHmhVI2JHsAOes8z/iNpgQB++R8i9mPh3oqi0q0nQFkYC0O2lpCuYhVXox2IF3UF
         sq4XxUQfbuXKWrGyMAUlco9JFe7r/bd2LxQQRI/ZwC6VRk1h6paKq+Pq42xgMtELR7R9
         GE9HpT/DOYBX3TxfIUAZYK4Sg1r+RTKFgECbq7hV2x1mJC6NOW3PXn5o7P19040gM1/t
         3AmBZBvMkOGf7gSeSCU8tuAFiyKFyqHoDmPR5Wgx68xSKhoAMaWgqrbHZ9kR7hf7txF1
         xcBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769706625; x=1770311425;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=n6OCmwX/j9Xn2LVH5U+aS18pnLbo6JaXYZFOm+PY4+E=;
        b=iNGOtVFMSeoXOhd8jeBOaz6xH4ez96MYHMvQXGs3spwq1NJtcoxFo42JhUqahqh3s9
         gLmmn0audO/H8S+Aw8Jo+ibHqVv+IADLo73UB6TSQMRAFLwa9dMb4HaKazly5XWeKI3a
         8b5jEV85WlX2F4hU16po8AOloVhMC8vE6W2v0CtHsMcZA3EsbDeRd7U8NxeHyVF3VkHt
         ujsZHdl0FMWIsBff1NznC12lC9loFvlkGo2vqQwIcxlax17gmqD6dVySvlQrHRmQnWxN
         qJXEGraj/FNeR7kREfTMrgps6rT1MfFR1f1CQK/j3jmkrFmka1GRigtJZSMgIzN5rmgZ
         EX2g==
X-Forwarded-Encrypted: i=1; AJvYcCWXq649emJCy6B18KAFOQuGbhanlec13/dmYPBJ6DeTgrAjB2Oo3vZSkxD8h4RwLLhZd7MVjVVB7uEh@vger.kernel.org
X-Gm-Message-State: AOJu0YzoL1YdJTzO3JqPc9mRRb22XypsD+hWF4VIH+GFYg0fq04YxAj6
	ZhD349QKf/KqdCd59iabn6Zxmq1wQmeyelGZKVbGAknJS2k3xUNUESA0S9cMNUQASl6k529kGOD
	P8K2/q/eykCZDTeSKx1nuXfCojoTQF5KLhilshhVEYw==
X-Gm-Gg: AZuq6aIwsmJ2lHIAkqBDAT3rF4gX8Efyj3BUD1jupnd/DZ0h96ZQ5MXdU/oTHShQweg
	KaTQXDmkKCw9RoXLCup/2jirKZUQTBfJZo+NGU3blURafIF9tGhoZel8C5Jd3WZgFYZlmj4X3vx
	czi5FrxA1MWCffb135naQo1W7fhHJDhLX/2u0nOqHf9WgLySxcSk30Y/RhGByT84mzRLzJ4Z5MJ
	uyas8yYJl1SXr27gzdat1XjZKYYoswLsbM4bjdQmTIZWThehZcl+jqiPv13KznpPviFVfMyDZl8
	Agl95y75A5rtfmEwb8+Tvn9A8Q5T
X-Received: by 2002:a17:907:1c95:b0:b87:6f58:a845 with SMTP id
 a640c23a62f3a-b8dab330a3amr682929466b.36.1769706624604; Thu, 29 Jan 2026
 09:10:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129-ufs-rpmb-v1-1-691534ab723f@flipper.net> <8149b8cb5a7b36a1543ca05666f33a6373674e0e.camel@gmail.com>
In-Reply-To: <8149b8cb5a7b36a1543ca05666f33a6373674e0e.camel@gmail.com>
From: Alexey Charkov <alchark@flipper.net>
Date: Thu, 29 Jan 2026 21:10:13 +0400
X-Gm-Features: AZwV_QhsPnBR0plQowOsHO5YBq3ZTAUEr4l8UAag9_eqRFlaZuUYqpCOMut7ozs
Message-ID: <CAKTNdwG=He3iJ8cPo4fFbcEwQQRrt_SGzoviMhi2a3kMXAO8hA@mail.gmail.com>
Subject: Re: [PATCH] scsi: ufs: core: Fix RPMB region size detection for UFS 2.2
To: Bean Huo <huobean@gmail.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	Bart Van Assche <bvanassche@acm.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Bean Huo <beanhuo@micron.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 29, 2026 at 8:53=E2=80=AFPM Bean Huo <huobean@gmail.com> wrote:
>
> On Thu, 2026-01-29 at 11:38 +0400, Alexey Charkov wrote:
> > +                       hba->dev_info.rpmb_region_size[0] =3D
> > +                               get_unaligned_be64(desc_buf
> > +                                       +
> > RPMB_UNIT_DESC_PARAM_LOGICAL_BLK_COUNT)
> > +                               <<
> > desc_buf[RPMB_UNIT_DESC_PARAM_LOGICAL_BLK_SIZE]
> > +                               >> 17; /* convert to 128 kBytes units *=
/
> > +               }
> >         }
>
> Hi Alexey,
>
> thanks for your fix, I didn't notice there is UFS 2.x on the market which=
 will
> use UFS OP-TEE RPMB framework.

Hi Bean, it turns out many of the UFS modules for Rockchip RK3576
based devices are 2.2. I'm poking around the OP-TEE support on that
platform, and discovered that the existing driver didn't see the RPMB
at all, spent quite a bit of time trying to figure it out before
spotting the difference between the two spec versions :)

> here is potential u8 Overflow, since for the UFS3.x+, it is u8 in unit
> descriptor, but
>
>
> The calculation can overflow for larger RPMB regions (>32MB):
>   - A u8 can only represent up to 255 =C3=97 128KB =3D ~32MB
>   - The shift result is assigned directly without bounds checking

The spec says it can only be up to 16MB maximum (see section 12.4.3.1
RPMB Resources), so it should always fit. Happy to add a comment about
that.

Best regards,
Alexey
