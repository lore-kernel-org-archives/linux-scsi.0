Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F471E3DF7
	for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 11:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730289047; cv=none; b=tIBESXReRYU8Uj8cVRtIV/iTkEMSHKRQ3Q0HHE0KpI/OUEY3XH+hoC8/6CeD0JDAO0y3DdoUMGK97cN/0iO4bOcdvYvWlao0+caUEoO63h+hhfPNInluBNhr7EWEPN+KbCKdF/NOaBoxLFxggpduzDiUkh9yhmDwI4zW4ReEv4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730289047; c=relaxed/simple;
	bh=ZlOwAI7A0ERCqmyT1YMUpxUbRWKzixiIq6yaG8K4oW0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sLTKh6x7/WC1um4noYWTt7DVjhqPqtu+Voo8zaq87GfNqg29nlQSP4LPu2+sUhCwPoyrEj1y3X+y6Tmp4bAPj//5SyDWW0cJZi2AH4xsE5q3Kd4W6Gj7DgAna/rQyWqbvozepg7o3Z8vXTaLL3tNOOOELFnVXGcoLi3zib+Am2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LxlgGKA1; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LxlgGKA1"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5c97c7852e8so9194971a12.1
        for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 04:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730289042; x=1730893842; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZlOwAI7A0ERCqmyT1YMUpxUbRWKzixiIq6yaG8K4oW0=;
        b=LxlgGKA1OqS8uDeBv7txVVYsSXiXIBE/8Ghy7xHkPm1XrUNb+WKM0pXpz+2AYLaYfo
         vCAbinWAawV7zZVOUZ6O8zG3ISbsdrpFXzhoLbIiDIPeK83YxwWLH/bvqAmUHomdA8Bm
         U29vu2ztKos4qF0ouqanbqZc9FKkG6pr0/SgkgU4ZLWBYI5B+5RNX8iFyVKYML6KhoVd
         8Tp5EXeFrppHOPDg39gGIB+q4GbkHmpVhugds3YAwy3bmxQNz8fpijr6OOzPKCwAOLZn
         lTgaRWdqS2TIxsmahfHUvhZBGemF+lJt+d5bsugE58r6jocsVRh6vU/N27ayWR/OnOPl
         hmHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730289042; x=1730893842;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZlOwAI7A0ERCqmyT1YMUpxUbRWKzixiIq6yaG8K4oW0=;
        b=jKovq7M+s5JrdMsReX0YaB2x/F/U8GAC8OZ+fbHGRWzupAIBp+d0r3Gu0PM/vVVsys
         LPNRjmwhF4VSbZZ7EkzRU9PNseruhuqSBRpO/XmijZDI0CiLuhF+9qKg5Bv1TdaUxAEh
         YyjNA6VUfqVKBRcGIY9TJALwiawm1EC+Q5B540oRfALZvpCIRyVue+59u3raTyOo2lcC
         JFlq8y/WtFraSWfgB5xxM1mmimtXDZ3FmG1Lei1o5fbc0GgNfsFH3bljgF//LiofAGI4
         H7YPpmM87JB/GSBDeMLW0CZYlMwVGd1mJ5ByfnxRKxLWuRy63J+o0reLdQ243XSi0kti
         QbFA==
X-Forwarded-Encrypted: i=1; AJvYcCXXXrAg7FFVUFFWfq6aXbSnjikgbgyBRBGUZ0t+egF1V5lLXSU9dZfobmYNT3fgjUPr6hObw1u0a9hZ@vger.kernel.org
X-Gm-Message-State: AOJu0YyEquoAiRelS6bhh3k2lAyWwq7gXjx1B4U4Ymb2mtIvhNNx4IfJ
	JyUrcwU1y7ZGQ53K/3pSxtoskYgNTbKbs/8Xgj1lXY1/gMlOg+um90oi3e/sz/fNE1ieGjLlsP0
	wL4CYE1ar0ZTpABNj3VV+fvFMVos=
X-Google-Smtp-Source: AGHT+IFZUe1/UugYE4pFjQf6jH3htutUMhc9bzj4Ytg1eYHEcQAQA6TJS9KgXpm1OPrfB3Uza/Bcf84aupL9QgOobsY=
X-Received: by 2002:a05:6402:3553:b0:5c8:9f3e:1419 with SMTP id
 4fb4d7f45d1cf-5cbbf88a1d7mr12553703a12.5.1730289042328; Wed, 30 Oct 2024
 04:50:42 -0700 (PDT)
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
 <CA+=Fv5SXrc+esaKmJOC9+vtoxfEo1vOhgfQ739CBzmVcArWT8g@mail.gmail.com> <20241030102549.572751ec@samweis>
In-Reply-To: <20241030102549.572751ec@samweis>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Wed, 30 Oct 2024 12:50:30 +0100
Message-ID: <CA+=Fv5RX-u_X9UgpMg6xzwc_FwLZus7ddJJY8rHMMyUUGc3pxA@mail.gmail.com>
Subject: Re: qla1280 driver for qlogic-1040 on alpha
To: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc: "Maciej W. Rozycki" <macro@orcam.me.uk>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Thanks for your reply, I guess this suggests that this is an
alpha-platform specific problem then? I can run the QL1040 card fine
with the original qla1280.c driver ( in a 64-bit slot on the ES40 )
just as long as I don't put more than 2GB ram in the system, this is
when I start seeing the issues with file system corruption. As soon as
S/G buffers are allocated on addresses above 32-bit, the QL1040 cannot
deal with this, unless enforcing a DMA_BIT_MASK(32). The same card
runs fine under Tru64 UNIX on the same system, however, I don't know
how the Tru64 driver sets the DMA mask, if it enables full 64-bit
addressing or not.

Magnus

> the datasheet is wrong. QL1040 supports 64bit addresses via DAC,
> otherwise it wouldn't work on SGI Origin and SGI Octane systems.
> Your patch breaks them (verified on a Octane).
>
> So your problem might not be in the scsi driver, but a PCI setup
> problem for the bus of the 32bit PCI slot in your system. If this
> bus doesn't support DAC it IMHO shoulnd't allow 64bit PCI addresses.
>
> Thomas.
>
> --
> SUSE Software Solutions Germany GmbH
> HRB 36809 (AG N=C3=BCrnberg)
> Gesch=C3=A4ftsf=C3=BChrer: Ivo Totev, Andrew McDonald, Werner Knoblich
