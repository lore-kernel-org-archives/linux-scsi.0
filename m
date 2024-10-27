Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7E013D297
	for <linux-scsi@vger.kernel.org>; Sun, 27 Oct 2024 23:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730070365; cv=none; b=RN7UOjJaXCu5X6RspKelEvadfqLw9pYweeoiV4wP5txsMZCxGshEEp0EipjsdlzBgUO+FXclPDPKgLWurAirdbe9qGhgS5d2sk+HCEnnP2+tVTc5XwN1lwXX56gVhIx6KqYWWqPmQfHE/wV5vvU0BPNguQX4Kg9e/bgC1C80GTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730070365; c=relaxed/simple;
	bh=sqjROUCMVUaxG/lfM+Lhm4C3+Swn13zspPmwhdAbcTo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=At7PtQ20htSRklcquEYRucEr/KKfu2M79SzcMJr4AQ04ISZZ4SazxSLUGZJNCYsd7HpLJdhAMJ0lKohv1ofjVQknQ2k9ccHwDZP/LeCCnV8VRGYaFqoJOZq1X7rctrhGGYJPIg7/HOkXXeRYjJazadwAzxOVkQibTSrXj9QbkRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WeMJ5c9A; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WeMJ5c9A"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5c903f5bd0eso7178849a12.3
        for <linux-scsi@vger.kernel.org>; Sun, 27 Oct 2024 16:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730070362; x=1730675162; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vymhzfpbqekA30QGQJaVebc8i/rFKSx7W34a7J77vBY=;
        b=WeMJ5c9Ac520iqPGX2YAm8s4WHbK0NiCArnyySyk9J+G+ax14kCZuNoTuU8J7FsTvI
         S5ZGocLA5x/FY/nttbaDtOXaYaE9KdYpY5G0IRVwL66G5X23Ik90joRagg/iII09aRjv
         P+iE5DnTD2nw9JAaVVU6JQ5XemIBWoeJWx2z65BiQSUCzlaO4z3f7SrJ6AZQho6WewSd
         vqTywiju3phmKvRAnijpMntYaZLjmAzcAzIxtTXOreGUpkmcE36Ob3fiFIzhDErpS+mX
         28kh2oN+GOXeS/Cd7LjRLGqer+TelGTMevw4bFPBhVbdVykbvhBu+V4QGEABklX41kN7
         sh4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730070362; x=1730675162;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vymhzfpbqekA30QGQJaVebc8i/rFKSx7W34a7J77vBY=;
        b=bOXnbnz3ivaI6D4wHlek3ggkjx3/0cQeWmTJxPs8g1XNHidyqbV1/HMoWbFrQWOm3e
         exTheCod4oYVWwU4tC0XNISRrC/NfZIizp4lsROUa+2894RXj4sbaFlaN1eU9zoMswgD
         UhE/DnfKRpCdo7Ofw6Bll55yeYcM4NYEBtElAwNjmurszcRihzPlgJvTdXecQF8r2YF2
         9Lrm//OwpXxbRwPC9RWffrVvyRIu22zxNShg/QXxDOmQOzm0Xu6xjRMOtrY9QrbuU8kF
         Ujqyai6AMRTHZvAYv8SM57DFF3wpW8VS8v35Vq773bj+eckB9xmQrjyBAqpwViTDGnoI
         6MBg==
X-Gm-Message-State: AOJu0YxC1PXxHab++RMUwJhybErJIRTlEl+teNFi4BS1nIIXyWFYG3SR
	w96mr7TV0EEBH2+PcoRpK21HU7uILGKYxwWqwoOabjpdmjUlJ9FBDoIGglANJ6yxFt3vM10dBnV
	7RofF0mJhlI62GlLXu7MVEeF6H45Z8A==
X-Google-Smtp-Source: AGHT+IGsjQBvZg//o6zkAgHtiyf2+CZUv7hxIZ6hacwee7YgF0LbyGycGQJ1A1apy1odJ9pIGjdcAhVhlFtb8pP7hzM=
X-Received: by 2002:a17:907:94cc:b0:a9a:bbcc:5092 with SMTP id
 a640c23a62f3a-a9de5ee23e6mr616892766b.39.1730070361735; Sun, 27 Oct 2024
 16:06:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+=Fv5QXiwWd+v9vHo89X_H94+P5OsT_0MEs_8dRAYJawWpy1w@mail.gmail.com>
 <yq15xpgdl6j.fsf@ca-mkp.ca.oracle.com> <CA+=Fv5TdeQhdrf_L0D89f6+Q0y8TT3NZy0eQzPPjJfj6fqO=oQ@mail.gmail.com>
In-Reply-To: <CA+=Fv5TdeQhdrf_L0D89f6+Q0y8TT3NZy0eQzPPjJfj6fqO=oQ@mail.gmail.com>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Mon, 28 Oct 2024 00:05:50 +0100
Message-ID: <CA+=Fv5R1c+JCkFFUvY-9=x61FZnks9GOteKETpo2FJV5u3kFzg@mail.gmail.com>
Subject: Re: qla1280 driver for qlogic-1040 on alpha
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I've made some changes to the qla1280 driver, the changes include
things like checking if the card is in a 64-bit slot and setting
DMA_BIT_MASK and enable_64bit_addressing accordingly. Also in the
driver information string, it now shows hardware revision on 1040
chips as well as printing info on its PCI slot (32 or 64 bit). I've
tested it with a ISP1040B card and a ISP1080 and it seems to work
fine. This may be of interest to others still running legacy qlogic
SCSI-controllers?

On Fri, Oct 25, 2024 at 10:48=E2=80=AFPM Magnus Lindholm <linmag7@gmail.com=
> wrote:
>
> Hi,
>
>
> As you can see below, the driver  says "enable 64bit addressing=3D0"
> when dumping nvram settings. The qlogic-1040 card is only a 32-bit
> card plugged into a 64-bit slot. I guess the card is not original to
> the ES40, I have other cards that I can use, i.e a  53c8xx is also
> present in the system. Would it make sense to have the driver honor
> the nvram flag for 64-bit addressing, at least for the 1040 cards? I'm
> thinking I should give it a go... btw. the card runs fine even when
> the driver is compiled in 64bit mode, just as long as I stay below 2GB
> ram or when explicitly setting the DMA_BIT_MASK when building the
> driver. (I guess most systems around when the qla1040 was hot stuff
> had less than 2GB ram).
>
> This is the output I get from running the driver with debug enabled:
>
> [   19.109365] qla1280: QLA1040 found on PCI bus 2, dev 4
> [   19.110341] scsi(0): 64 Bit PCI Addressing Enabled
> [   19.110341] Configure PCI space for adapter...
> [   19.111318] scsi(2): Verifying chip
> [   19.111318] qla1280_chip_diag: Checking mailboxes of chip
> [   19.111318] Loading firmware: qlogic/1040.bin
> [   19.749013] qla1280_start_firmware: Verifying checksum of loaded RISC =
code.
> [   19.757802] qla1280_start_firmware: start firmware running.
> [   19.760732] scsi(2): Configure NVRAM parameters
> [   19.760732] Using defaults for NVRAM:
> [   19.760732] qla1280 : initiator scsi id bus[0]=3D7
> [   19.760732] qla1280 : initiator scsi id bus[1]=3D7
> [   19.760732] qla1280 : bus reset delay[0]=3D3
> [   19.760732] qla1280 : bus reset delay[1]=3D3
> [   19.760732] qla1280 : retry count[0]=3D0
> [   19.760732] qla1280 : retry delay[0]=3D1
> [   19.760732] qla1280 : retry count[1]=3D0
> [   19.760732] qla1280 : retry delay[1]=3D1
> [   19.760732] qla1280 : async data setup time[0]=3D6
> [   19.760732] qla1280 : async data setup time[1]=3D6
> [   19.760732] qla1280 : req/ack active negation[0]=3D1
> [   19.760732] qla1280 : req/ack active negation[1]=3D1
> [   19.760732] qla1280 : data line active negation[0]=3D1
> [   19.760732] qla1280 : data line active negation[1]=3D1
> [   19.760732] qla1280 : disable loading risc code=3D0
> [   19.760732] qla1280 : enable 64bit addressing=3D0
> [   19.760732] qla1280 : selection timeout limit[0]=3D250
> [   19.760732] qla1280 : selection timeout limit[1]=3D250
> [   19.760732] qla1280 : max queue depth[0]=3D32
> [   19.760732] qla1280 : max queue depth[1]=3D32
> [   19.772450] scsi(2:0): Resetting SCSI BUS
> [   22.812488] scsi host2: QLogic QLA1040 PCI to SCSI Host Adapter
>                       Firmware version:  7.65.06, Driver version 3.27.2
>
>
> On Fri, Oct 25, 2024 at 10:00=E2=80=AFPM Martin K. Petersen
> <martin.petersen@oracle.com> wrote:
> >
> >
> > Hi Magnus!
> >
> > > I've been running linux on alpha (alphaserver es40) for a while, usin=
g
> > > a qlogic-1040 scsi controller. A few weeks ago I added more RAM to th=
e
> > > es40, but as soon as I got above 2GB RAM I started seeing file system
> > > corruptions on the drive attached to the qlogic controller.
> >
> > The qla1280 driver has been used extensively on 64-bit platforms.
> >
> > Is your isp1040 original to the ES40? My Alphas used 53c8xx series
> > controllers if I remember correctly. And with the ES40 being fairly
> > recent (21264), I would have thought it would have used a slightly more
> > modern controller than a 1040.
> >
> > > The nvram flag "enable_64bit_addressing" on the qlogic board is not
> > > checked nor set by the driver.
> >
> > That would be a good place to start. Maybe if you could dump the NVRAM
> > contents and validate if that is set by the 1040 firmware? I'm afraid I
> > don't have a databook. But the 1040 was current right around the time
> > the industry transitioned from 32 to 64-bit so it could very well be
> > broken.
> >
> > If you can establish whether that flag is unset on your controller,
> > we could use that as a heuristic for configuring DMA.
> >
> > --
> > Martin K. Petersen      Oracle Linux Engineering
