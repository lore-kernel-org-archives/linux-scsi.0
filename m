Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2F61991CC
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 10:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730370953; cv=none; b=G5z4vo4m4URDYcq3iGGfaFr4T2UEhnH6aeWlo4x7/cxVFRXmtiqosjnciJN0h6VfQen9xmVQXYciNb2ypAPecmVD9/VTLsjbmO8uxoEqJM0XvC2AQ6dRTIGyct0uKgALHVnYEfITqZHc6Qp3l/P10MYq81kKo2u24Qg10r+LvYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730370953; c=relaxed/simple;
	bh=apMxqqAahuyK8uAzmuPF1D1P6AcbOjt+x2EzaDvioBc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hOLYbdLXWpxAx3kbvkc3TkaR52WLRqD8euKJxM3sOm6f70GDumxV5Hs5Zx2q0Y4MS56XNFmPNHff8hLVmiANTULeqek1rPJyBKtHyltDu2+hBqcVhS/lb7phE6wg65IcLAT3hNQZo+RinyLgTorkjtCq1DPsJxLRi+EsBMYICaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ifHojgoN; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ifHojgoN"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a99f1fd20c4so98769666b.0
        for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 03:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730370949; x=1730975749; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZVzJIUNphDU93nu41iWIe3iLQuX/p066gSAyV6EeDbA=;
        b=ifHojgoN1EtAk+zYWtbvUU1DJyAs+XPBFsXq420OtTbN8jUNYLcuXx9aWDUYFxDIvG
         gmhdKpYCR9EBr8YAIKxU0YTl9spM6Xxz17zBUiFUvlLL881a1QstHf/RxNUmwbufm3n7
         dTkrqEupbgZllBXwjh2J4MNM+Bm3hPgSuwvgOjcf6V7wJONcwD4zq4FhM2fewqRRhxms
         m0LfBPz7aHYy7cICF40VAtLKpbFPxqY+MQGnziMZ1O05oJGej6IDMJR6afdu7Zs7hB7/
         2IFzKkPOUDDImpO2l1azw4wbPs31tjDsBMyfzB1XBT5POPxQxK6z5DoKNB+oEcr0zHLP
         lcRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730370949; x=1730975749;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZVzJIUNphDU93nu41iWIe3iLQuX/p066gSAyV6EeDbA=;
        b=L4xugIhXzIPjtFadsdR3OQjGS1U/6gD/kcwZRLjIyfllqcBc3io03D6loUyte2Ay+P
         zqYS4adpS2cAZ6Pt8Uw0cwzpZpLHFCE2Pkha2HFXYGV+3V4klEUZE6ev3nRg9vnMZu+E
         ZS97YXF8sz/7Kbdxl9KyrJEEGVzU/5IcgoM5ehjdAaIac1LEEIKSdG2Vxu5E7lhCW0nU
         vDeLrUWbMFgXIjiy90rMP+uKutj7sxH8yK+VAjQsaoWi5ZPIlApKuQ4p2N1Pehhl7Ebd
         4gX7EW0fLEQysv6GLrduOktQ9b4I4l5f4F9wjKGHrJlJmznTFgOuURoTMRfrQwQc5jZa
         Lz1g==
X-Forwarded-Encrypted: i=1; AJvYcCVDtyvOjc5JAcwR/m9QShmFU8b7/gOf0nAZvySM+NPTta+Ybo60SvdVzTD2l4MLXpAu7NdzlU7ZNJDg@vger.kernel.org
X-Gm-Message-State: AOJu0YxsBB59tPAKJjoa9rKyWIcOZvKDQ2cieThfU+x4snUEGemd8vtZ
	lxHH7or1pFuX8X/GiA5X+SgYJ1tZcXgXyP+OktU4dm6BDALDFQioktjE6OUZeVtMNO4Z6wsyXhv
	bHQdoqmz/+uOUfwqLyYx094kfe/k=
X-Google-Smtp-Source: AGHT+IFR3yFGCcHfuAJlyqDmBwJpdP3kCA4mJX8zSWK5jRlGUSF897/PqfSyM19OsscknTIGJKsQv8inYWta8zrsyF4=
X-Received: by 2002:a17:907:3da1:b0:a9a:4e77:92f with SMTP id
 a640c23a62f3a-a9e50b9e343mr226339466b.56.1730370948817; Thu, 31 Oct 2024
 03:35:48 -0700 (PDT)
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
 <CA+=Fv5SXrc+esaKmJOC9+vtoxfEo1vOhgfQ739CBzmVcArWT8g@mail.gmail.com>
 <20241030102549.572751ec@samweis> <CA+=Fv5RX-u_X9UgpMg6xzwc_FwLZus7ddJJY8rHMMyUUGc3pxA@mail.gmail.com>
 <alpine.DEB.2.21.2410310517330.40463@angie.orcam.me.uk>
In-Reply-To: <alpine.DEB.2.21.2410310517330.40463@angie.orcam.me.uk>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Thu, 31 Oct 2024 11:35:37 +0100
Message-ID: <CA+=Fv5Q=eS1O4nwiHkJQRpvZ+JiDncnEZtqCUAyBPf1ZOtkzzA@mail.gmail.com>
Subject: Re: qla1280 driver for qlogic-1040 on alpha
To: "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc: Thomas Bogendoerfer <tbogendoerfer@suse.de>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

HI,

I don't have a QLA1040 revC to test with, but I've put together a much
smaller patch which just limits the DMA_BIT_MASK to 32-bit on
1020/1040 cards this should at least not break anything while fixing
the most urgent problems with file system corruption on some
combination of hardware/memory. Thanks for the pointers to tsunami
chipsets though, I'll try to enable some debugging to see what's going
on when I hit this problem with the qlogic card.
I'll clean up the chip revision reporting code to see if I can improve
things there, this will be as a separate patch then.

I have one question regarding the hardware revision on 1040 chips,
according to qla1280.h we have this:

#define ISP_CFG0_HWMSK   0x000f /* Hardware revision mask */
#define ISP_CFG0_1020    BIT_0  /* ISP1020 */
#define ISP_CFG0_1020A   BIT_1  /* ISP1020A */
#define ISP_CFG0_1040    BIT_2  /* ISP1040 */
#define ISP_CFG0_1040A   BIT_3  /* ISP1040A */
#define ISP_CFG0_1040B   BIT_4  /* ISP1040B */
#define ISP_CFG0_1040C   BIT_5  /* ISP1040C */


But when I examine the register it looks more like:

#define ISP_CFG0_HWMSK   0x000f /* Hardware revision mask */
#define ISP_CFG0_1020     1  /* ISP1020 *
#define ISP_CFG0_1020A   2  /* ISP1020A */
#define ISP_CFG0_1040     3  /* ISP1040 */
#define ISP_CFG0_1040A   4  /* ISP1040A */
#define ISP_CFG0_1040B   5  /* ISP1040B */
#define ISP_CFG0_1040C   6  /* ISP1040C */

Which is consistent with how NetBSD does things in their ISP driver.
Also, in this case the HWMSK actually works for filtering out the
hardware revision part of the CFG0 register, since it would actually
require a 6-bit mask to match the current definitions in qla1280.c,
right?


Magnus

On Thu, Oct 31, 2024 at 8:37=E2=80=AFAM Maciej W. Rozycki <macro@orcam.me.u=
k> wrote:

>  I find this interesting.  Documentation for the Tsunami chipset indicate=
s
> DAC support[1]:
>
> "In case of a PCI dual-address cycle command, the high-order PCI address
> bits <63:40> are compared to the constant value 0x0000_01 (that is, bit
> <40> =3D 1; all other bits =3D 0).  If these bits match, a monster window=
 hit
> has occurred and the low-order PCI address bits <34:0> are used unchanged
> as the system address bits <34:0>.  PCI address bits <39:35> are ignored.
> The high-order 32 PCI address bits are available on b_ad<31:0> in the
> second cycle of a DAC, and also on b_ad<63:32> in the first cycle of a DA=
C
> if b_req64_l is asserted."
>
> and I can see it handled in arch/alpha/kernel/pci_iommu.c; allocations ca=
n
> be handed out with the TSUNAMI_DAC_OFFSET bit set.  You might be able to
> see if it triggers by defining DEBUG_ALLOC to 2 and checking messages fro=
m
> DMA mappings in the kernel log.
>
>  I did a little research however and discovered that the DAC capability i=
s
> documented in the ISP1040C datasheet, but not in the ISP1040B one.  So it
> seems to me like it's the matter of the chip revision.  I've skimmed over
> the driver and as far as I can tell there's everything supplied there to
> get this sorted now.
>
> References:
>
> [1] "Tsunami/Typhoon 21272 Chipset Hardware Reference Manual", Revision
>     4.0, Compaq Computer Corporation, Order Number: DS-0025A-TE, 21
>     October 1999, Section 10.1.4.4 "Monster Window DMA Address
>     Translation", p. 10-13
>
>   Maciej
>
