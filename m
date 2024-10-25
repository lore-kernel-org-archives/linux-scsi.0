Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B1F216E1E
	for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2024 20:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729889335; cv=none; b=jJGQmBzbT1BGFgkILLVVrTy8SxxPdtzNByL/COMIOrIKgWK3Jw27+CEWvj9bdMY4V1CEq4/wMBmQgLnsPQfxCVwJmbWqMjqP17BXcxeIfqathK7QrRG6TsIs8hL+lPxJ1cnLvA6KZ49aKLJyHOL5owGoPx6v0/QvXI0lPrjWpI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729889335; c=relaxed/simple;
	bh=hvjxjB0Wgsn+OMIL93Srt04pQCqu/D45Tj4OFOfsyBk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Oy+6ygWhfMdfDebZgq3HPNOCp6nP8lXojSuhInHojnW1X7PxVmnQ5wYkanbYs0NixogSsxy9/TdgPqlw9vFeZRr1eVLfpYDXHA7JVwHEGFYhPKZDQgDxCjjmM1ntgVbd6k2xGGEe0YY7awBt8/i3gqYB3p0xC8C6S0mICAXsFKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N33dN7Mm; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N33dN7Mm"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5c9850ae22eso3237571a12.3
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2024 13:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729889331; x=1730494131; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zhMP/ZzRrnbSaB6bN9mPeZk4MVhgEafQLBJFxj1tGE8=;
        b=N33dN7MmMMIVN5UiBidEzecDDwvKVkZIUlcxleMsv9wLZmKNWpayLwc5i+kLUdOcdU
         ExXYSQfcV54hV74pmdEn+9Kz190YXQBmSeFpLq0Z1r/jOE6uryczaB5Oer139LwmL9rL
         41iRDksOMSUGyRt0zlqJ9aJNFK+8L4Wn6QX7TPgEAEeWRU9fCSBFRgk7VYVmfoZKNcAU
         EPBOPc2TmBHamBCElWMhn6k28kxBfXs/j/7MBpxT98o5mFlAhCD5lETi6kbsyzJpS0V6
         0ERSQAwJFUT9g5mDTZMuA0YnBuzxOnvlc6twl2dvwebHzwXBYdwFKtimnJieU6HgPG1M
         u3kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729889331; x=1730494131;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zhMP/ZzRrnbSaB6bN9mPeZk4MVhgEafQLBJFxj1tGE8=;
        b=YvknRpTfk0jCHyLZm8FqTgBXAs2Iug8N8iZifucH6TRnoQX1tLXRVuD0f0286878Db
         7LWFtd0AJsmLOg7R6t9lGYwT309tAQ+HeMO5RwkualGiyfLFLFbt5fpSCJwVnUEXkoGw
         NpYdg1FLw/4zMQJsN6xwftZZtOO2mw4p8AuEoNCMLjhVmyHjx3e8305W5oeBhTjP+QcA
         wU7cKt92VDtD2AQpmz9cFANxnc7eIpAvhBx29yhNX2A1ndBSVKsrXezYVcgpxDzYDPNi
         mkzsq0WE9QN+7C7HyHklhSTIh92RGTr5higgZqh/C5rEe0JwWtDuNKKp+EHWFj1uV154
         NLDg==
X-Gm-Message-State: AOJu0YyIu02ouad8n/KYj7E43lMPOqijylLimCfaR0LhLG8CnGNe6r4w
	f9lV2eOOdhDf+FNiEbpB+5sZGCSG+l72E2mBgzIpqnMEQ4CN/c2/5ZuIIsKpDPykLRtuLd+VdOm
	6eN4vq9d8SZ9U4hGpNclVXfuXthx99POX
X-Google-Smtp-Source: AGHT+IFLoL3x14eBJX5E1UCw70pKuczxy7+NVsrGPd2XoIVyJLLiTqAQUUY51UZDCjJ/5EPvjNthVbRRg2sE4Ogz7jg=
X-Received: by 2002:a05:6402:520c:b0:5c8:8416:cda7 with SMTP id
 4fb4d7f45d1cf-5cbbf8b11e8mr355103a12.15.1729889330712; Fri, 25 Oct 2024
 13:48:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+=Fv5QXiwWd+v9vHo89X_H94+P5OsT_0MEs_8dRAYJawWpy1w@mail.gmail.com>
 <yq15xpgdl6j.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq15xpgdl6j.fsf@ca-mkp.ca.oracle.com>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Fri, 25 Oct 2024 22:48:39 +0200
Message-ID: <CA+=Fv5TdeQhdrf_L0D89f6+Q0y8TT3NZy0eQzPPjJfj6fqO=oQ@mail.gmail.com>
Subject: Re: qla1280 driver for qlogic-1040 on alpha
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,


As you can see below, the driver  says "enable 64bit addressing=3D0"
when dumping nvram settings. The qlogic-1040 card is only a 32-bit
card plugged into a 64-bit slot. I guess the card is not original to
the ES40, I have other cards that I can use, i.e a  53c8xx is also
present in the system. Would it make sense to have the driver honor
the nvram flag for 64-bit addressing, at least for the 1040 cards? I'm
thinking I should give it a go... btw. the card runs fine even when
the driver is compiled in 64bit mode, just as long as I stay below 2GB
ram or when explicitly setting the DMA_BIT_MASK when building the
driver. (I guess most systems around when the qla1040 was hot stuff
had less than 2GB ram).

This is the output I get from running the driver with debug enabled:

[   19.109365] qla1280: QLA1040 found on PCI bus 2, dev 4
[   19.110341] scsi(0): 64 Bit PCI Addressing Enabled
[   19.110341] Configure PCI space for adapter...
[   19.111318] scsi(2): Verifying chip
[   19.111318] qla1280_chip_diag: Checking mailboxes of chip
[   19.111318] Loading firmware: qlogic/1040.bin
[   19.749013] qla1280_start_firmware: Verifying checksum of loaded RISC co=
de.
[   19.757802] qla1280_start_firmware: start firmware running.
[   19.760732] scsi(2): Configure NVRAM parameters
[   19.760732] Using defaults for NVRAM:
[   19.760732] qla1280 : initiator scsi id bus[0]=3D7
[   19.760732] qla1280 : initiator scsi id bus[1]=3D7
[   19.760732] qla1280 : bus reset delay[0]=3D3
[   19.760732] qla1280 : bus reset delay[1]=3D3
[   19.760732] qla1280 : retry count[0]=3D0
[   19.760732] qla1280 : retry delay[0]=3D1
[   19.760732] qla1280 : retry count[1]=3D0
[   19.760732] qla1280 : retry delay[1]=3D1
[   19.760732] qla1280 : async data setup time[0]=3D6
[   19.760732] qla1280 : async data setup time[1]=3D6
[   19.760732] qla1280 : req/ack active negation[0]=3D1
[   19.760732] qla1280 : req/ack active negation[1]=3D1
[   19.760732] qla1280 : data line active negation[0]=3D1
[   19.760732] qla1280 : data line active negation[1]=3D1
[   19.760732] qla1280 : disable loading risc code=3D0
[   19.760732] qla1280 : enable 64bit addressing=3D0
[   19.760732] qla1280 : selection timeout limit[0]=3D250
[   19.760732] qla1280 : selection timeout limit[1]=3D250
[   19.760732] qla1280 : max queue depth[0]=3D32
[   19.760732] qla1280 : max queue depth[1]=3D32
[   19.772450] scsi(2:0): Resetting SCSI BUS
[   22.812488] scsi host2: QLogic QLA1040 PCI to SCSI Host Adapter
                      Firmware version:  7.65.06, Driver version 3.27.2


On Fri, Oct 25, 2024 at 10:00=E2=80=AFPM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Hi Magnus!
>
> > I've been running linux on alpha (alphaserver es40) for a while, using
> > a qlogic-1040 scsi controller. A few weeks ago I added more RAM to the
> > es40, but as soon as I got above 2GB RAM I started seeing file system
> > corruptions on the drive attached to the qlogic controller.
>
> The qla1280 driver has been used extensively on 64-bit platforms.
>
> Is your isp1040 original to the ES40? My Alphas used 53c8xx series
> controllers if I remember correctly. And with the ES40 being fairly
> recent (21264), I would have thought it would have used a slightly more
> modern controller than a 1040.
>
> > The nvram flag "enable_64bit_addressing" on the qlogic board is not
> > checked nor set by the driver.
>
> That would be a good place to start. Maybe if you could dump the NVRAM
> contents and validate if that is set by the 1040 firmware? I'm afraid I
> don't have a databook. But the 1040 was current right around the time
> the industry transitioned from 32 to 64-bit so it could very well be
> broken.
>
> If you can establish whether that flag is unset on your controller,
> we could use that as a heuristic for configuring DMA.
>
> --
> Martin K. Petersen      Oracle Linux Engineering
