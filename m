Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5ED1E7C27
	for <linux-scsi@vger.kernel.org>; Tue,  5 Nov 2024 19:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730834714; cv=none; b=H2ncXyVqoVvTP9Qt8iX3LVCD6nD0I/wpY4LCqHUeptrEz4t6QNu47Ho3YmZR6pEyrOwFF/zqMS7j+W0exAGpnH0sbvKev2bQHvlZ/hxBkSLDCXYrfJK1HZRB+5ymeOO6MpbfO4ndsCSfdCG/lwgh/by9LPCzvJuIXJNwV89sRRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730834714; c=relaxed/simple;
	bh=PkcHIbnbE8ebWADDPPm8HHRv567Wao4v6Zr2yKncmqI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AJWDAB6jQGqcINe5hCU20u3nUea+9tA99XT5UQXtygUYxvpOX0n00vYMgejnNBzZAaXO3LkjgDSfZeyEKBrxlXYi17WBV8gllqSPqFxaEmd3KE51/40kYi9mp18ZZxFIbglt7qTW9rK1xhhaZUhP91nxX8qFBYWlc3CTWRIKfvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eMqjUYla; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eMqjUYla"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5cacb76e924so7896765a12.0
        for <linux-scsi@vger.kernel.org>; Tue, 05 Nov 2024 11:25:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730834711; x=1731439511; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=o3tyxR2AQZGkPPlPpW7kTPulNX3WqlxLVprzNw5Lkyw=;
        b=eMqjUYlaCH+iuRM4DC97s7Wjrszxe80jkeiiB4lW0mF0NAeDzpJCXRshyeEl1+x39h
         ciKxzo9Ox1gyGXBnaAP36tEgPVUSaMZGAxVIGq/wXtZGLHbdXrnF0Vzsq57Mmn/zYYhh
         8E12DdJZa2pV0ucToLFdR13lq/BlOUG2F342gJDcHiqOOoAuq4UvAPh8FCB371TvON55
         9qh7snbyPOWf5WkgITXlBQz92z06aEE6n4LTPLSpXu4g2+Lp42RjM/0TZ7vAm+xW3h/p
         B53WYLzhFdcgIgnZbDoQg96BjCidFhwF3k0JrnPYtgHUhzcl64nutBiL22Bw0qkWmjbB
         Zpkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730834711; x=1731439511;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o3tyxR2AQZGkPPlPpW7kTPulNX3WqlxLVprzNw5Lkyw=;
        b=FR4s0gMwC5MmINOUP+EN2lbiI1okV6Pd4DrfzT/oLUE3JYzx8K4On7J975tYhMwCpr
         fexARBSa5UxxmHU7VJVJegwr+rL5pu0WN51c0XK5SjEHfAxtYa9U3souSBWhiG6aQpu0
         ogZ9dPDRaJp4LLiVlO93iv2nALx+UjojlBHHFXa18ywQUNIQ5Z+It4R9K9yjg7pvAWCb
         XTRzR+q77ZdjkYUK6ddhksa1CsX8UETzLvQqa+DhnGhhPJ3TrFApFRhyPIfd7nIB36bO
         4QJarPYioYEXuDf1192mbssVJVYa2WCrXTypBPobe1m92H6mSVaLCKj90qoxqoSGm9x6
         Carw==
X-Forwarded-Encrypted: i=1; AJvYcCWimbF+CNjPigegvZZzrP5Th2XpBNk5HwTBtnnYwBLSf/DjjE9hxNPciBPkK4EtXdmXCZjeVrVgtuU4@vger.kernel.org
X-Gm-Message-State: AOJu0YyiTfsW3eLvUbZoraAXUHNJY6PXAehinbJkEZWKgDX8KFxBKK8N
	XhLX1cJEToMBA5zKm0nWAPPKY6BzIDVVOOr+1VV8IFptK8XlkQ30dz6iWNWNTkcgNAovMXndAH+
	+TwsZyYjmwnAWuXHA4xiDYa+jikcIHffGO/4=
X-Google-Smtp-Source: AGHT+IHYu2e+mP/CX2J6PGEhDsmlwGGmmDOjlvZEz6O2ykbqmE0VpTBn8jalQH+JnTtMiqfim7rbLATF+I+n7D+BQDQ=
X-Received: by 2002:a05:6402:84f:b0:5ce:c7ca:70ca with SMTP id
 4fb4d7f45d1cf-5cec7ca71a0mr9040781a12.34.1730834710751; Tue, 05 Nov 2024
 11:25:10 -0800 (PST)
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
In-Reply-To: <alpine.DEB.2.21.2411051226030.9262@angie.orcam.me.uk>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Tue, 5 Nov 2024 20:24:58 +0100
Message-ID: <CA+=Fv5Q5Q1BUscm2Tua9y1b=2f33+3SkULNwe0gKQpJFL1PLig@mail.gmail.com>
Subject: Re: qla1280 driver for qlogic-1040 on alpha
To: "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc: Thomas Bogendoerfer <tbogendoerfer@suse.de>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

>  Thomas, Magnus, can you please check what hardware revision is actually
> reported by your devices?  Also a dump of the PCI configuration space
> would be very useful, or at the very least the value of the PCI Revision
> ID register, which is independent from the hardware revision reported via
> the device I/O registers.

Below is some info from my Alpha ES40 with an ISP1040. I've added a
printout of hardware revision number to the driver, as previously
pointed out the revision numbers in qla1280.h is wrong so I've used
info from NetBSD
rev5 is a "B" which matches what is actually printed on the chip as
well. This seems to be consistent with PCI Revision ID register.

output from driver:

qla1280: QLA1040 found on PCI bus 2, dev 4
revision=5 <-- printout of cfg0 register 5 = rev B
QLogic QLA1040 PCI to SCSI Host Adapter
Firmware version:  7.65.06, Driver version 3.27.1

#lspci -s 0001:02:04.0 -vvv
0001:02:04.0 SCSI storage controller: QLogic Corp. ISP1020/1040
Fast-wide SCSI (rev 05)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 248, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 52
        Region 0: I/O ports at 200008000 [size=256]
        Region 1: Memory at 209050000 (32-bit, non-prefetchable) [size=4K]
        Expansion ROM at 209040000 [disabled] [size=64K]
        Kernel driver in use: qla1280
        Kernel modules: qla1280


>If all else fails, I would still recommend to disable by default 32-bit
>DMA addressing for pre-ISP1040C hardware, as that matches documentation,
>and then have a platform quirk to enable it specifically for ISP1040B for
>the relevant SGI configurations.  But I do hope there is a better approach
>possible.

I have put together a patch which if we have an ISP1040 chip with chip
revision less than "C" it uses dma_get_required_mask() to se
DMA_BIT_MASK otherwise it will set the full 64-bit mask. If
dma_get_required_mask() works properly on IP30/MIPS it should return a
64bit-something mask, right? Maybe this can be the quirk that makes
this work on both Alpha and SGI/Octane? (Assuming we don't find a
better approach)

Magnus
