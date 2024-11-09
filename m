Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA9F29CF4
	for <linux-scsi@vger.kernel.org>; Sat,  9 Nov 2024 18:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731176948; cv=none; b=JXs+l+J6ydFourYGe6IvuboyJtyCpMoXDEisCIAhSrUWmsHESuXzpVvv6LfgU68y2dmUCi8k40b0//hnvlmtfyTuqOXbZCHnrHwTTNEaahFUTK4RqGv3XC9Yz8/Xp1QLYGx0+wBprBBjFU2kjzsnCFg5DLH/7oSx+daPVZIDV8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731176948; c=relaxed/simple;
	bh=80Ahthycu0W6a/HWOYqAZmCNpn4BKvD7fomEjXtBxHI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GQ6ORXFThgRI5yKhYq+uFOFl7weo4bMlkI1cZIfWELg0F5QZNlYndKsRoSDx4xT6noxPdUJBPMQJ52iFl/QOoOLxiVOTDJDbNelWybhnk9FVQ5OjjeHSTKi/qv71MxTFIV+z43dEhfT2I/SqPSekMpukQToSaORHBG2GnB35c5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lYUXNxuR; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lYUXNxuR"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5c9634c9160so3821993a12.2
        for <linux-scsi@vger.kernel.org>; Sat, 09 Nov 2024 10:29:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731176945; x=1731781745; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C4JP2yiWQfmqrtv0nvxMd7g2l3h7p3fCovVdtnuuYIY=;
        b=lYUXNxuRq/S7pM1ml6qF4TQySLxZ5gEaydQv9UOHdcWh/t0tkijQW2oP8Q2cTl8g4s
         +ajh8NpEN+eGElqaUnQO3Lu+sWxhXEcRKgUP0lCbhRZIdIBNVVqa4xnEg0x1UIdL3K0+
         ngNKyo8YUqEmV8FiSWc6io1S2tJLvHIy8zXmvynsiNW4LJdw96EB5cRFTYWn2eQpHES0
         7DOQ1ZkjIwI/99Ih8Mw0D44GEpcmzINBal268nxWGcT0T37CMxyr3DKFWVbFnewElhKZ
         xgLF9iKoTVlfhFM2XDvaMT70j+jqhQcMNAUsQTm+b3mfvVRtaGF5Wl3Fya0Bodzvfyqh
         ZZQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731176945; x=1731781745;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C4JP2yiWQfmqrtv0nvxMd7g2l3h7p3fCovVdtnuuYIY=;
        b=WFMVwTgCVNHcPVl3oK9w+52r1PQkCbFjctPXJu8lhuDU7sflfCNwxetYCM9afM+VWO
         F4Vud1odu5jBtHaNbjROPvTZsTKZtS1B+pksKVf6p34QELC2zZwrHXlo8H69694TYx0g
         7xQOJ/KV780uO1a4pl3ncE2dK0Z02tZEjXzvxPzU9gZk3DUCkAkkWrszDFle+4WXHSqM
         p1/UG8IaloOhiGMuckZmrdyU6xioeIV6AheAWR9GdCG2OmbvchWKQa3jwetCrJrhe9yA
         aoR2Ce50KUuhlsIllVXItL17pbbeNL6TfjKa+iWSRp3HyQYbqdCWRGk7t1y/ee3/lzXn
         oO9w==
X-Forwarded-Encrypted: i=1; AJvYcCXC5votzCRohAchoN0q5uWmunHp4WUShm0TBfYFupYEiJzAKUCm1xQbIBHrEcHVqL68/4P4XV517uM0@vger.kernel.org
X-Gm-Message-State: AOJu0Yy27CyOXyaXvF1afsutNUrpWmV080OEv9KJjuNytoft1rQeIacV
	OdjndeDUAKPTTV+5RTcFhCAFUduTY2Xy53+C5SgVxP23i+NP4R9/YN5CpOMdXnSZeb9dPesE7ik
	KJF11vmTQo1agAOFWspuLN5PgFkc=
X-Google-Smtp-Source: AGHT+IFGA+RwbE1CCKv+W/FspC8u5P5t24ryVqXmUho7sCMSNBBLq31I5S71mGtZuA1bKQFGqq0/+QMeo1WBb9fO1r4=
X-Received: by 2002:a05:6402:90a:b0:5ca:e5d:f187 with SMTP id
 4fb4d7f45d1cf-5cf0a323582mr4108988a12.17.1731176944727; Sat, 09 Nov 2024
 10:29:04 -0800 (PST)
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
 <yq15xp14fy7.fsf@ca-mkp.ca.oracle.com> <20241105223319.46c7563a@samweis>
In-Reply-To: <20241105223319.46c7563a@samweis>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Sat, 9 Nov 2024 19:28:53 +0100
Message-ID: <CA+=Fv5St4uQC00KF9YtU6WCHnHDO-NeMJ6er5aB86wgq4ZDxWQ@mail.gmail.com>
Subject: Re: qla1280 driver for qlogic-1040 on alpha
To: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "Maciej W. Rozycki" <macro@orcam.me.uk>, 
	linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

What's your thoughts on his approach:

if    (card is ISP1040 and revision less than C) then use
dma_get_required_mask()
else
     do as before

Assuming dma_get_required_mask() works it should return a
64-something-bit mask on IP30/MIPS but only 32-bits on Alpha.

Magnus

On Tue, Nov 5, 2024 at 10:33=E2=80=AFPM Thomas Bogendoerfer
<tbogendoerfer@suse.de> wrote:
>
> On Tue, 05 Nov 2024 14:56:15 -0500
> "Martin K. Petersen" <martin.petersen@oracle.com> wrote:
>
> > Maciej,
> >
> > >  Thomas, Magnus, can you please check what hardware revision is
> > > actually reported by your devices? Also a dump of the PCI
> > > configuration space would be very useful, or at the very least the
> > > value of the PCI Revision ID register, which is independent from the
> > > hardware revision reported via the device I/O registers.
> >
> > It would also be interesting to know what the 'enable 64-bit addressing=
'
> > NVRAM flag is set to on Thomas' system.
>
> there is no NVRAM on the Octane
>
> Thomas.
>
> --
> SUSE Software Solutions Germany GmbH
> HRB 36809 (AG N=C3=BCrnberg)
> Gesch=C3=A4ftsf=C3=BChrer: Ivo Totev, Andrew McDonald, Werner Knoblich
