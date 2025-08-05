Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C05B1C84B8;
	Tue,  5 Aug 2025 08:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754383949; cv=none; b=faMIfZobbdB0I2QFqzl404bfQsA08iosrgxqb+71YWmuMbOA7/WQ/GTlHvZGL3G4ZvIR9dgb7iKa6Wykn0mbZFxTJjdL6D0HmxxCtS0Fe3imwMGMky8JWn9I/km3+x8OfEyMsirQVILmXiaJt3K+XlREnlR+scCzRIzkLKCVMwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754383949; c=relaxed/simple;
	bh=YZmcY1piegk1CkntdgiKfdMefpNM5+TLkKyEFcJnSFU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OhIlpPjRN7oKnYybth843KVcjQ/oUSdsTqwuMCKfbHuM6sW6OglO7PbeaZvZtYwu7L4kN9DNAIp6/SW1g8CI5iFxXvWOuhp2P20+4ej/rG5IwNCDNDdO4lCK56mYCEsAUwLY1pIsDZTMqh5WhbAZDS0CN96jMZtAYUsJ5rJkRZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VmIk4F1k; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VmIk4F1k"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ae9c2754a00so1289892066b.2;
        Tue, 05 Aug 2025 01:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754383946; x=1754988746; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jaTy0xj/+3TuAzN0h+oW9IGZMVIadrvVCLKKqc1c/Xc=;
        b=VmIk4F1kj20ue/F9qhlDtwHG94wk1rNRk1fExoAAWLeydvUGmD85rkRzafL/VD5d0A
         q+8SPwUTkOrvtfkVADWpvN97D7kAQxKJCOj3hWBd/j/CDuDwpDJLJDgttNHGL1dfggJj
         fSh8rP84wzLTcI220L7RqGmlPtv269yUlCktsl1prow2VWs/mdBC3vt8bEzBmQMrIQ12
         Ku4NKx7ZYVCNAW6WNB1OHfh/sGcWs+Co10xeTmmEepAfdeNLXW62CrrQovC92d/EjyRW
         /9fT6NtOLomsePR4EbvZcdcwoyKNtpKHvta3MtkYTOdnX691eZTkKWccuESDwizG6zPc
         5fzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754383946; x=1754988746;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jaTy0xj/+3TuAzN0h+oW9IGZMVIadrvVCLKKqc1c/Xc=;
        b=tsa9NmGB0yzYZuyRsZBFL387HczNbWnImn11ocX5uUmBoZ6t90BB5BXlSuUVDASqeQ
         J8ZZ1yBA/dmdkYxfzJHZBjXF0hI5v7JhpMIYhjv9fNWQt1EO+s6abzni/vTQ0T4rtJX3
         xSVb62RfnBueKvOB1VBTT5NMQM0pKmlHFYk8IrqT920BnPELUhXMs415lc5UlBLsHW+p
         xbsxeYZzqnHceI2zxfBqpk9Cf/ECvVXBZHowwWE9NjDmzY1rRLfu9O44Lk8SJTPKRs4B
         zJvxy1DlEfrG2YyK4ve/5VG+oNGVfBgjTZBG+xSS03xnrOPdCx1p6DMY5FB01Khe0qcy
         OROQ==
X-Forwarded-Encrypted: i=1; AJvYcCUhbAMKzVGJ90MPjnPImUK6Wz1U4fENzYTsI1jHWjrg+5cJgAEmZT4GEjJ1kGeMG/gPdDnLLGW2hU+N+A==@vger.kernel.org, AJvYcCWM9XQH15WMFyzJarkSuGzpBrtiVcsz13PMd51iXJaBSCoHOFDJ/WLyn/8B34EEhzEAy+4plrDkGCYS+g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxT3bd6HNHK2AaZa8Ri/t8ChI3o79dRbpCxnjWAQ3s1LP1z249F
	Ax6iXqUAEmo1ForejhMkWZGRaHJjDsv4ZJ7++6WqfOe9TLqGYDzWwGGF5dUpZgTJKuA0bur+eRR
	xIyfW3/7lh3+Gh/6ktkSUJ9A+LDem5apAifQ5
X-Gm-Gg: ASbGncuj0yh7I2uIP7H0Noz7I1PBmUmuPuSG/0cNUnUeBBgmeoAR0eP6/AsH+bjPySS
	+B2MaJMKr5bZMEZX8atuMdbUDGmeacK1Zp4QZP6BIjq+PAZImFx8f/IYfmfe0bmMk/BDUVTe322
	TZR9izx5Muwm1++Ky1qAAfIOh+x6fqQMRw4zd2aYF480o61QCyp58/ozj33oiQt5u9ebkHfb3Ux
	oTV285p
X-Google-Smtp-Source: AGHT+IHBzuvYOHqAFLPRu7Dv+DS+0hNgKeL15bJ6w48TWJQzYpyb/HUZYWNc+dgs7JiffMVDFytsA7Er/a2uo+t6Vzc=
X-Received: by 2002:a17:906:478c:b0:ae0:e18b:e92f with SMTP id
 a640c23a62f3a-af94000bf11mr1291389966b.23.1754383946132; Tue, 05 Aug 2025
 01:52:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250728163752.9778-1-linmag7@gmail.com> <alpine.DEB.2.21.2507291750390.5060@angie.orcam.me.uk>
In-Reply-To: <alpine.DEB.2.21.2507291750390.5060@angie.orcam.me.uk>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Tue, 5 Aug 2025 10:52:15 +0200
X-Gm-Features: Ac12FXxU-rHEh5gdbPfppvGA6ajPoHppVbPMlauJt4ffpEOxH03xe1TVXQ2oZb8
Message-ID: <CA+=Fv5TJRpFJ=p1MLcORDaqnSG-0AUEtSUw3Kek0vPGKbQZT9g@mail.gmail.com>
Subject: Re: [PATCH 0/1] scsi: qla1280: Make 64-bit DMA addressing a Kconfig option
To: "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-alpha@vger.kernel.org, martin.petersen@oracle.com, 
	James.Bottomley@hansenpartnership.com, hch@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 31, 2025 at 11:49=E2=80=AFAM Maciej W. Rozycki <macro@orcam.me.=
uk> wrote:
ng a simple way
> > to limit DMA addressing to 32-bits is relevant.
>
>  Given the description it seems to me it will best be handled as a quirk
> in arch/alpha/kernel/pci.c, at least in the interim.
>
>  If it turns out a generic issue with DAC handling in the Tsunami chipset=
,
> then a better approach would be a generic workaround for all potentially
> affected devices, but it does not appear we have existing infrastructure
> for that.  Just setting the global DMA mask would unnecessarily cripple
> 64-bit option cards as well, but it seems to me there might be something
> relevant in arch/mips/pci/fixup-sb1250.c; see `quirk_sb1250_pci_dac' and
> the comments above it.
>
>  The situation is a bit different here as the bus is a proper 64-bit one,
> but the quirk could only limit the individual DMA mask to 32 bits for
> devices that have no 64-bit memory BARs.  I suspect there are no proper
> 64-bit PCI option cards that only have I/O bars and I don't think there's
> any explicit status bit to tell 32-bit and 64-bit option cards apart.
>

This approach would probably also work. This would mean limiting
32-bit PCI cards from using DAC/monster window DMA on Tsunami based
Alphas. In practice, I believe that there are very few 32-bit PCI cards tha=
t
are likely to be used on Alphas that have drivers which support 64-bit DMA
addressing. The only example I've found so far is the qla1280 driver.

Since not all tsunami based Alphas support more than 2GB RAM there are
even fewer examples where this will be a real problem. I'm not 100% sure
that there is a generic issue with DAC handling in the Tsunami chipset but
I'm suspecting that there is. I think that for DS20/ES40 systems using
Qlogic ISP1040 SCSI controllers would be the most likely (maybe the only)
real use case that I can think of.

I can put together a v2 patch based on  a similar approach as
`quirk_sb1250_pci_dac' mentioned above, if this is a better approach
than limiting the DMA mask on only the qlogic driver (by using a module opt=
ion)

Regards

Magnus
