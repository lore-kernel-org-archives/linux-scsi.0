Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE25717C219
	for <linux-scsi@vger.kernel.org>; Tue, 26 Nov 2024 21:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732656851; cv=none; b=LJFDvfn43HTgZoFppC9uJXKsiIMP/CT5UwpldpIS2uc1YHVmVaXbQOKmQaCfb4NfJiZ+/vLqsirU30vCVgsTJE6ruTDbxojZsPOfmQ0fq7tW8w0UlXUCbK3s7ueRcZHSgVa+itDOLox2KQ1UEv7JixtPSzeAnIkg9YntmqjNexk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732656851; c=relaxed/simple;
	bh=AT+pTZr7RXsLK1ui9cbhBL92hxReQpoP6/d8+NxwyZA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YX02jwfEri2Zgx4nXT2GRvDPx0pbw6SZyBjOSgXcGYactdIkN8gjnPOYnLdbuNgM8XHiSuAWN1A2/mubGUNaAjy6SnRO/stcDJNfzTmxUG1uatHGWjLOTcTlclwlMDwK5NSYU7wfzSgpl32sZZ5bVfTXKuYX1+tl6gr75/3tbzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Eea0jGXf; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Eea0jGXf"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5cfcd99846fso7635597a12.1
        for <linux-scsi@vger.kernel.org>; Tue, 26 Nov 2024 13:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732656848; x=1733261648; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dsZQU9yDqd9dbf8fuYY9/l/9nJQlZeFIyBVxxcAn7rM=;
        b=Eea0jGXfGT3zX4y5otl/zy/Txe+5UG5B/U+S8QS40QEBGs/onnFQVJtKryrZvpAhIT
         io9bqbli90Fot1vpgetiu18oOYmqScwlKMabpaKayNvYgEBd5bVQtavZIVnGBNs0BEN5
         5r8NIrcGH3UsVKvzvv7ayfZnRCM3IoWI+KPFrsBg1DvZq+zXifa8HelacA4ONYjkJh2e
         pfXhjbpz023n0qZHe5BRXB8UlQA+TnVsp/gjZ8NeSZPIQtu3ZwibF68QUu+zKq4YK1OZ
         UvD0Wtoy5VHtjQ0uUEd7tt8Lim9If2GcEnQl6OErT9pCJTParqtyS3F6aBAv+D+khwPF
         jdgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732656848; x=1733261648;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dsZQU9yDqd9dbf8fuYY9/l/9nJQlZeFIyBVxxcAn7rM=;
        b=bw7MDh52BBoJy3ipWpBQhBXHgcLKGuoL+GYUam6yZewkmB3+5DfQ300hvQUpZXD88N
         II0mLqk66/rCE6RzoQ6eTouhDFPbzMYtXVoc/q3/7HdfgzRwtO2cS+DuAmMX3Vj1+dMr
         VPC5Kz5RZmsnTw6dqfjQvbUJCU4joazTjCAElkN6GIhrNcZ/WM2FcYSyHBsouHuhSguc
         9kga8sIv+DGVH6XKuc2trlx81yt81D3qzi9FGlRcFVH1FKdvAOw6O+9/dI31HnoL9y+u
         qXVZsWOu7utFNTGQ07R1m7z/QGnpi2/9QJjlYLw9iJBKKzaUlTVAoyjTq4029FCOqeSC
         X8YA==
X-Forwarded-Encrypted: i=1; AJvYcCUft+Tc6Y4Yv24LTzoca4xG4ZvBwsxUpNr3ozgBFQZRybPe+xbBhyP5Jv3gT0iEcNAWpOd3Vu2OLwWL@vger.kernel.org
X-Gm-Message-State: AOJu0YwsfWOVVt6kZAS99TVgpN1jSZGqaaJsEuNUogNbuhJ7fhchJasj
	ZImQIahnOdx7KbmQxAgpvM7bz2MqpfWEgHTTM1CTHJlvShy8itZkg1GwdpdAuY+gXNQjWFXS0JS
	gxIUpV8+tva6F/+8BDhEIOAzZcZMOVVnS
X-Gm-Gg: ASbGncty918GSwDQsmNNyabXmpuQt8uhjKMC3zf0yw5rqnCkHVoijIvrKiCr6S+zOML
	epqYYuM80Ohnk+zg9doctCbBN4pJODTFy
X-Google-Smtp-Source: AGHT+IGF3kgyQ544Mr0SFL3vBGhNYWbhiRLfEoozoj8IekurpRHE60XuhtgksAzEyiDhnzc12EdQ9AYqOIvE6xwxaOU=
X-Received: by 2002:a17:907:3f9f:b0:a9e:c267:78c5 with SMTP id
 a640c23a62f3a-aa58108aa97mr27298266b.55.1732656847788; Tue, 26 Nov 2024
 13:34:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+=Fv5TdeQhdrf_L0D89f6+Q0y8TT3NZy0eQzPPjJfj6fqO=oQ@mail.gmail.com>
 <alpine.DEB.2.21.2410300046400.40463@angie.orcam.me.uk> <CA+=Fv5SXrc+esaKmJOC9+vtoxfEo1vOhgfQ739CBzmVcArWT8g@mail.gmail.com>
 <20241030102549.572751ec@samweis> <CA+=Fv5RX-u_X9UgpMg6xzwc_FwLZus7ddJJY8rHMMyUUGc3pxA@mail.gmail.com>
 <alpine.DEB.2.21.2410310517330.40463@angie.orcam.me.uk> <CA+=Fv5Q=eS1O4nwiHkJQRpvZ+JiDncnEZtqCUAyBPf1ZOtkzzA@mail.gmail.com>
 <alpine.DEB.2.21.2410311656400.40463@angie.orcam.me.uk> <Zyh6tP-eWlABiBG7@infradead.org>
 <CA+=Fv5Q_4GLdezetYYySVntE7KBB2d-zhNGR3rXawsvOh_PHAw@mail.gmail.com>
 <alpine.DEB.2.21.2411042136280.9262@angie.orcam.me.uk> <yq15xp25ulu.fsf@ca-mkp.ca.oracle.com>
 <20241105093416.773fb59e@samweis> <alpine.DEB.2.21.2411051226030.9262@angie.orcam.me.uk>
 <CA+=Fv5Q5Q1BUscm2Tua9y1b=2f33+3SkULNwe0gKQpJFL1PLig@mail.gmail.com>
 <20241112145253.7aa5c2ab@samweis> <CA+=Fv5QF7yUQd=CnrrDSwrFVbBC7wGdzXffJV__AjP9TDxqw=A@mail.gmail.com>
 <alpine.DEB.2.21.2411251925410.44939@angie.orcam.me.uk>
In-Reply-To: <alpine.DEB.2.21.2411251925410.44939@angie.orcam.me.uk>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Tue, 26 Nov 2024 22:33:56 +0100
Message-ID: <CA+=Fv5TVZ7v43EQ8jx7g4RV0n6F6Wb1N83oEbeWnMAQbNQvT5g@mail.gmail.com>
Subject: Re: qla1280 driver for qlogic-1040 on alpha
To: "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc: Thomas Bogendoerfer <tbogendoerfer@suse.de>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 25, 2024 at 8:56=E2=80=AFPM Maciej W. Rozycki <macro@orcam.me.u=
k> wrote:

>  I had hoped for full `lspci -xxx' dumps actually, which could reveal
> differences perhaps in the device-specific range of config registers.

Here we go:
SCSI storage controller: QLogic Corp. ISP1020/1040 Fast-wide SCSI (rev 05)
00: 77 10 20 10 07 00 00 02 05 00 00 01 10 40 00 00
10: 01 a0 00 00 00 00 e1 fa 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 e0 fa 00 00 00 00 00 00 00 00 0b 01 00 00
40: 34 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 77 10 20 10 07 00 00 02 05 00 00 01 10 40 00 00
90: 01 a0 00 00 00 00 e1 fa 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 e0 fa 00 00 00 00 00 00 00 00 0b 01 00 00
c0: 34 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00



>  Given that your HPZ440 system appears to have an IOMMU chances are it's
> used such as to squeeze all PCI-side DMA mappings into the low 32-bit
> range for the very purpose of avoiding issues with odd devices.
>

I've gotten my hands on a Supermicro X9SRA board with 128GB of memory.
BIOS is in legacy mode with all the 64-bit PCI stuff enabled.

The ISP1040 card works fine, no errors reported at boot  or in the message =
file
dma_get_required_mask() returns a 32-bit mask but the card works in w=C3=AD=
th
both 32 and 64 bits masks. The DMA_BIT_MASK seems to have no affect
on how the addresses are generated, they always stay below the full
32-bit range in either case. It seems like the x86_64 will not trigger
the issue with 64-bit addresses on the ISP1040 card.

Maybe I can test this on sparc as well, I'll see what I can put together.


/Magnus
