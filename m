Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09C528E7
	for <linux-scsi@vger.kernel.org>; Tue, 29 Oct 2024 06:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730184702; cv=none; b=pnixWp/+Lv8UPl8x8KUJioUo/8H5DEtdWQcq2fIvEy+zIGVpYr9o2nCq75PGYAyODaDjbgO92cK1dRTyJEc18Kwr5iHaFMFcggu7upDPnbZnhkarUsiu43OHQPf4ktmiHzmm/kPn2f076Ae5xr92XDcLzT337GHrhGO+Wyxl524=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730184702; c=relaxed/simple;
	bh=Sxffokz0yRTCf3ReE+5QixTTAkV5o3psKtd28IjRcZQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mfSjkDWyubrFE98w3mObihhfc9xkQBad1n+DSZ3v+hmlWCjwPWkiNnD0GKrF2wo01y9TWIczVph6/sRREWcPHOkr3v2zD0mjnXVYGNrxNE3hmMcpPU5dOGslmm3o565v0sgkFulyQXLVafdQ2/HUSrzR02JrBUTMW6isP8K+9ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j7I/vNoL; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j7I/vNoL"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2fb498a92f6so48203881fa.1
        for <linux-scsi@vger.kernel.org>; Mon, 28 Oct 2024 23:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730184698; x=1730789498; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SI/3eu1CnSyerMh7M1JMYijcQ31efPIFLS1WL4u7HNI=;
        b=j7I/vNoLLGiWCD6R3Qr9O95gQtRlsNQLOESASHMMlzPrf/k43CM21x8c8nEU2SUMN5
         /vgCjMJ50N6KITW5nPaePM5hjzb4gp6Fxoztsu18A+V8K9RAO2IhSTsJn8UraD01W/XV
         TsmCN+9uedFiEc4UzXt68FWTkWNptTBseRI+pqdP+FKbCqT/qxHX9aKHDr2SwUeffxcB
         +RKjy0iOOk11MA37/FTZht0SvmEALpJtLrLEsJS28M1uWaMBKJ6/yTjLNBjKQudsrmdQ
         LSmC0VHnaFH8urgoEDPDbxGLo3WY9U9kEOts0n/uGc5IIOVk6Kk3pCSw5uY0dHDb0xn8
         K+pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730184698; x=1730789498;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SI/3eu1CnSyerMh7M1JMYijcQ31efPIFLS1WL4u7HNI=;
        b=O000kXW1gItXtMFFX3lbEKmT5WhNw7N0XvXOU8HKZCSRr8HQghq3hQ++tSiI6OgF05
         xu6g53GeRewx85iniSNolXirdiR/xDxu1eEUfnOdN5F37jbk7rqCcXU8XZW6FIK1gj4m
         WKGwfhLo2fRBa/jeT2w9RxeAXKPzZsUdEqsv1CkG3euFdPPudHaQYuFbPVq21Qz9tHaG
         yuACzOY25gS84PIti4fFZP4VtsUXKnnHU2Tus50O1y1TdZepW3toYKpcUrhMh4X1Z4hu
         8xmKjZKI6FGt2atsWG0ogK4Mr3MCEauL/swWB574aUYbwv3jkCxX1H257SlELXFHoqxQ
         VTvw==
X-Gm-Message-State: AOJu0YwWrXvRitsO5cEisVFsvMSn6vTqnHZA3GZpGVMiRDfxPPfOAM9L
	Go8+rAznTbBYNOaqEfS+Bj3WTLPzFeH4lSLsvAWNCWmLHNEufQFpwUb+gsUgFo0xVhuWEuOZrnV
	8LCiMe3jVRghnsK9kjIkScLL117LkVQ==
X-Google-Smtp-Source: AGHT+IHb9OS9TwiOkpj71n/vKu6JQ52lMWvKvdX4yT2S8NORypc9aNgREZe6yuMR+rIireunDfeZPxVd4H7+EcyGI40=
X-Received: by 2002:a2e:4612:0:b0:2fb:527a:815b with SMTP id
 38308e7fff4ca-2fcbe09ad65mr39987501fa.28.1730184697656; Mon, 28 Oct 2024
 23:51:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+=Fv5QXiwWd+v9vHo89X_H94+P5OsT_0MEs_8dRAYJawWpy1w@mail.gmail.com>
 <yq15xpgdl6j.fsf@ca-mkp.ca.oracle.com> <CA+=Fv5TdeQhdrf_L0D89f6+Q0y8TT3NZy0eQzPPjJfj6fqO=oQ@mail.gmail.com>
 <CA+=Fv5R1c+JCkFFUvY-9=x61FZnks9GOteKETpo2FJV5u3kFzg@mail.gmail.com> <yq18qu7d5jy.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq18qu7d5jy.fsf@ca-mkp.ca.oracle.com>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Tue, 29 Oct 2024 07:51:25 +0100
Message-ID: <CA+=Fv5R3EY_4zPk9PonoY3Q_04KuiW4fohvMv7YSjatEh-yjEQ@mail.gmail.com>
Subject: Re: qla1280 driver for qlogic-1040 on alpha
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I have  qlogic 1020,1040 and 1080 cards and actually a 12160 on the
way from ebay. Those are the cards I'll be able to test for now. I'll
put together a patch with the changes I've made to qla1280.c and post
it to the list. My ES40 will not run the qla1040 without getting
filesystem corruption, when I put more than 2GB ram in it. I guess
qla1040 and large memory 64-bit systems were never a frequent
combination?

On Tue, Oct 29, 2024 at 3:19=E2=80=AFAM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Magnus,
>
> > I've made some changes to the qla1280 driver, the changes include
> > things like checking if the card is in a 64-bit slot and setting
> > DMA_BIT_MASK and enable_64bit_addressing accordingly. Also in the
> > driver information string, it now shows hardware revision on 1040
> > chips as well as printing info on its PCI slot (32 or 64 bit). I've
> > tested it with a ISP1040B card and a ISP1080 and it seems to work
> > fine. This may be of interest to others still running legacy qlogic
> > SCSI-controllers?
>
> It would be great for the driver to have a solid heuristic for running
> the older ISP cards in 32-bit mode.
>
> You don't happen to have a qla1280, do you? I'm afraid I don't have one
> anymore and it's the model that occasionally pops up in bug reports.
> Would be nice to validate your changes against that ASIC.
>
> In the meantime I'll see if I can locate the qla12160 I believe I still
> have.
>
> --
> Martin K. Petersen      Oracle Linux Engineering
