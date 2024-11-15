Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8AB16BE20
	for <linux-scsi@vger.kernel.org>; Fri, 15 Nov 2024 23:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731713988; cv=none; b=k27A01pdefiLeo/19al9OhFXsK6MqpgflHOtIeAF2KIbl0shjJaNbbY1ECbtJcLe/3qx4DvpbpmZDcNp+0Hr3msmpFRwsw/ISL6Ika1Xj1vkomoDoE0cs180u9fYXQQCPRIEXRitcp/woWvzQP1aGzzEGoc/HKlJXgrYspYQKxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731713988; c=relaxed/simple;
	bh=Anbzh4P1xWCeOr6fyo8N8P3jjr15KG1IhkZM8bH66sQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=klfzyCyNEa7N3NnEGG9f7vk44V9KCeLKGIjxA0MRwaMrNq/8FFOn7AA3ZeKRRbJpK7Bb98CeOuv8DfxPauF5qOTmp10/P4XpVlWpbPTFxjYITToNyyANgOcOhCxVa0lyBLJ6JB0cLpO4UUPtMq+uy+ypw6HJhWE5ZHnFaaAE2Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bHvDM95R; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bHvDM95R"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2fb5fa911aaso2151061fa.2
        for <linux-scsi@vger.kernel.org>; Fri, 15 Nov 2024 15:39:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731713984; x=1732318784; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Anbzh4P1xWCeOr6fyo8N8P3jjr15KG1IhkZM8bH66sQ=;
        b=bHvDM95RV8rhWmX0WAhwzITvlsqm6KAqz0HNtm7wbAkJIyJrmLWcpP6LYFUCGwW95b
         49shCXAxbh8t791Xv6isDQfJoZ7G3id/k3l/kpj+ATAJt0QSeku4RKuEjJoNYgnQqwS1
         Fspj1wLJuQAg9YlaWiCFqvr/Yqa9yJ4zPzJIgyeXOMVPjnA30dBbcCG7tscR/qXUgoKi
         VJbiKjgx/YyA9h0qteJpUzLr0MwSi+nN+YxmkS23IKbZuWilZrBaay896AK1QLKyhneU
         YQe+ty6q0qqEoW/DxrwIm6G07GBZUnl1xU3SDjbE16bz5ePt+SRKmJVz9SCtiyYRseWn
         V/8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731713984; x=1732318784;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Anbzh4P1xWCeOr6fyo8N8P3jjr15KG1IhkZM8bH66sQ=;
        b=mmA+2Z1lHd3jLLZ3YAsWPE95VL27NNRJFLke9bQ4ONhr8LDlU440iAAJwQUsockMJG
         7fDK0j5VYvaRPKTIcGVnl2PS58NoIDew2eSzQaGx0zwqwyJ1fkoB0SoIRSVBKVhQiirg
         ttGZx/oA76CDLhtdbdzYrcZ5fHOTaDTSi0Hopu/8habOXFGY9QUuVmL/lRTHW1SLnYFz
         HbmbgsNmks6YR+0NFsV/CWUZ/zwx0Vhfts25jII99K8EbjVlFB8E86mrW2zxfe5EYeqG
         sSdoDZvMC2WIcnvfLvhAGrtYiB9JwO9lTfT5Ohw5tWg8b04d/wXd3YsE7HvIf90MZFND
         AAVg==
X-Forwarded-Encrypted: i=1; AJvYcCU+7N2lRwbkaDSPT6UkmIG7kiBFPl9yP+w8HhTWIk1kcyplN7uGMumG/rRFkVNRHgOK2iibaKXw6JBB@vger.kernel.org
X-Gm-Message-State: AOJu0YxvprIhwt8SDNdhQUGThdOvDDrIfZHvBL8YI83ok1oAmmY7tMym
	hf+eDWf6Oy89MCJQ1/27rATocl5CA23y4dYQDdpZa6zQBTgpodtwaCVYZf1D0Zs3Zx5k0dXrZUb
	1c5TGXIL+3UL6moVJmYWVc/G0Rwc=
X-Google-Smtp-Source: AGHT+IFN06x1sdjAbnEhp0Ob5O39BX00Q3Ilta9LfCPU+1Z9uBlJPgMWXeBzI+tTXRIaSEuQ0CrQvvMmJYndOMYLZWs=
X-Received: by 2002:a05:651c:50d:b0:2fa:de13:5c34 with SMTP id
 38308e7fff4ca-2ff60661742mr44943211fa.19.1731713984311; Fri, 15 Nov 2024
 15:39:44 -0800 (PST)
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
 <CA+=Fv5Q5Q1BUscm2Tua9y1b=2f33+3SkULNwe0gKQpJFL1PLig@mail.gmail.com> <20241112145253.7aa5c2ab@samweis>
In-Reply-To: <20241112145253.7aa5c2ab@samweis>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Sat, 16 Nov 2024 00:39:32 +0100
Message-ID: <CA+=Fv5QF7yUQd=CnrrDSwrFVbBC7wGdzXffJV__AjP9TDxqw=A@mail.gmail.com>
Subject: Re: qla1280 driver for qlogic-1040 on alpha
To: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc: "Maciej W. Rozycki" <macro@orcam.me.uk>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Thanks for taking the time to test this on sgi/octane. I guess the
results of your test means that only relying on the chip revision is
not going to do it.

I've put my ISP1040 rev B into a HPZ440 (x86_64) with 128GB RAM. When
booting the system I get
 "PCI Configuration error" when BIOS configures the card. I also see
this in the kernel message log:

"DMAR: [DMA Read NO_PASID] Request device [09:00.0] fault addr
0xfebba000 [fault reason 0x06] PTE Read access is not set"

So the HP workstation and the ISP1040 card do not fully agree.

I've used the standard qla1280 driver and hence enabled full 64-bit
DMA_MASK. Even if I got some generic errors when booting,
the card works and I can mount a drive, format a partition and
copy/paste files without any filesystem corruption.
However, when I enable the debug output I notice that the driver never
uses bus-addresses for DMA transfers that go any
higher than 32-bit. So using DMA_BIT_MASK of 64 or 32 bits does not
have any effect on the actual addresses generated.
The address always stays within a 32-bit mask in both cases.
dma_get_required_mask() returns a 32-bit mask for the
ISP1040 even when the system has 128GB RAM. What does
dma_get_required_mask() return on the sgi/octane?

Magnus

On Tue, Nov 12, 2024 at 2:53=E2=80=AFPM Thomas Bogendoerfer
<tbogendoerfer@suse.de> wrote:
>
> So the Octane 1040 chips are the same revision and working with 64bit add=
ressing.
>
> Thomas.
>
> --
> SUSE Software Solutions Germany GmbH
> HRB 36809 (AG N=C3=BCrnberg)
> Gesch=C3=A4ftsf=C3=BChrer: Ivo Totev, Andrew McDonald, Werner Knoblich
