Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A6D215C68
	for <linux-scsi@vger.kernel.org>; Tue,  5 Nov 2024 21:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730840784; cv=none; b=FWeFtaxH+tKpYfALAR5rdlefDc3yH9RntsJNby4hSqPYY1EatET+EAKa7mW1i80E4hrixyfYPzZ9kbQqt02s+p76hqJxcK+d1f0MgGL2Iu5HaFpcpYjbkrVv298BM/Dwrjl6Ed2QLUO4In+26kN95JycX4U7VZwkwxjl2Ej1JCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730840784; c=relaxed/simple;
	bh=aAG7RnIF74HMv2mc4mk3cQrhKyWpkR5O5UDjmBtNiQU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s4DYU8efGpA6nhsGdlP1qLFsRi+phmNOCAVJHxaWHcV5W0J7+q+JzNknsLItY/VeDHyj/Rf+70vj/ofdTEP92uEJ5J3pUYgMj0AeGup71Yv31nO4Vd8BmonBrJv7BsOY31Bplf99UhZfP5Ek8gzUOhPWDg6bQ0Y3M0v6F3qkFnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OnnHtur+; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OnnHtur+"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-539f72c913aso9607813e87.1
        for <linux-scsi@vger.kernel.org>; Tue, 05 Nov 2024 13:06:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730840781; x=1731445581; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8mxviS52uVSqjlDqErjZ+hAfIrjY3cTggkwkrpHMhho=;
        b=OnnHtur+vQiuLesH3NiJqUu8cEV4hU8607kMBW2DrGm3m0klA0DCVizRj6/APyS4Nw
         VuKylUZwWsWp3LpvMEEeYijS74v7vcRSm712YI6hKYyDHQShnX59f6Ab73faao6Wppfb
         YOVJ5ONeZwP+6+5gcwHqY0QNdjY3mA7A2r4EqDQXuHsEQuvK8UWfKg33/FT9xITzMEI2
         DHFrPGK+aE1OOtOCeR5isG9ulZEkazCssq3oxGiwj1oxgW6VnXf1UiBoB1BBfb+3gPZJ
         J45tfw1FMDr/EQl+bOnzAZJgltyq79N0VwfFGIlCk80+oHPHOIbwH1N2xaMfGKkZxjQB
         Vi+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730840781; x=1731445581;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8mxviS52uVSqjlDqErjZ+hAfIrjY3cTggkwkrpHMhho=;
        b=ci+sIUxqOmGgkx5uYbMRV6mdYpP8ybXfCLT20eveIgivpqJWTOd1NivQLVfRIkbfQR
         whjbtC1no0Ato/zicgVJ8Ce/XiRpGVD81kTAZSPQylHAH5mv7e01xlq5e2YWgfMIU275
         Z7Jk71Zf2rMt81gPzR4NyneufBEsoRzmW3706zMhczuu7deaT4GktruHY0hxIqEZmj4M
         LFlqXsaTtY17MFTafTJfoNnWxEcbQhASJu2ceEFU1PlaPEFuz/36lHVEWPK2BvoclqiC
         uxU1CLMBeEbsyw/IQV4+5wz/norWKawFjBltVsZErZs4wCQ5xCNuakCKao6fM2yw5DZf
         3dQQ==
X-Forwarded-Encrypted: i=1; AJvYcCVGO1fHZS3ZgbtToauVllmcN/A6PIKGVxzrwjF9aflzrRXIUeP7RG73hXG4e9ffLvpLVBBjLU3FyZR8@vger.kernel.org
X-Gm-Message-State: AOJu0YxlJTIWKWOrMDo3OgbZxV9xPnOyEi8TUG/d5cFEi4ABMH45mJ1/
	HG7ryzXKfJGctzjDyKvf3KDtctzTau8wqVSVr3WgU7u26bw9pL3A64+dyDBZX2lqvC4a8gl8dKT
	XHeZ9V4aIqBLkyn0K00L6r8PHYkA=
X-Google-Smtp-Source: AGHT+IFI4uhxBZbN0oF0CearAGd4jJ0WuZZuDe87D9j4jk+RgtffezOgW8L+pONFuTBovIZWbsLcgKRXbdW6+R+koqQ=
X-Received: by 2002:a05:6512:a92:b0:539:fd10:f07b with SMTP id
 2adb3069b0e04-53b34b39774mr20970405e87.55.1730840780884; Tue, 05 Nov 2024
 13:06:20 -0800 (PST)
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
 <20241105093416.773fb59e@samweis> <alpine.DEB.2.21.2411051226030.9262@angie.orcam.me.uk>
 <yq15xp14fy7.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq15xp14fy7.fsf@ca-mkp.ca.oracle.com>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Tue, 5 Nov 2024 22:06:09 +0100
Message-ID: <CA+=Fv5QSUiUVvgD2zxQA-n7CoUZGO5_8oaZr0bC3fOg9ROKMRw@mail.gmail.com>
Subject: Re: qla1280 driver for qlogic-1040 on alpha
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Maciej W. Rozycki" <macro@orcam.me.uk>, Thomas Bogendoerfer <tbogendoerfer@suse.de>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 5, 2024 at 8:56=E2=80=AFPM Martin K. Petersen
<martin.petersen@oracle.com> wrote:

> It would also be interesting to know what the 'enable 64-bit addressing'
> NVRAM flag is set to on Thomas' system.

This is an interesting note in the revision history of the driver:

    Rev. 3.14 Beta  August 16, 2000   BN  Qlogic
        - Added setting of dma_mask to full 64 bit
          if flags.enable_64bit_addressing is set in NVRAM

This is no longer present in the code, must have been removed along
the way somehow. On my (working full 64bit mask) ISP1080 this flag is
not set (according to the driver). I've tried having it both set/unset
with the ISP1040 but it seems to make no difference. If setting it
through the driver even works?

Magnus
