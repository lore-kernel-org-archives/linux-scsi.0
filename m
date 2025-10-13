Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877AA308F39
	for <linux-scsi@vger.kernel.org>; Mon, 13 Oct 2025 15:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370799; cv=none; b=EmmpaOhOUk5LC/uxAyOLNUWc6BIemwLI0xp34y/CQsMNzsyeXX7AIAuB2np+/8fCeCXTYxfniWrbfGTPtDHm+OUv0IjjKDEx6nM3/OWoClo+n2fkfsZgx5NhL8az4Q8VWzwL4avBZHKgEfW2tPQKZU/yGvayi0nfJOBx9tJ9KIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370799; c=relaxed/simple;
	bh=5p9mi92e61fJcAu02iEnX/oA6GBMIXcBIzy4NHED8ak=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mRO4vJ8BmumH91xxdEFl5ZwrxCS+p0poaarS6f6WJ+g9mpf/4q+x0G2C8w5yL11DHnypOpfhfCAiPPO+XrUUknCwFMvPdyPUzMwafoqrqESx0AGtpFyAqmaeerxyDz8jloZFoJLAdsFpr/ztHrmKw2bWJJ9EShLUzmjAcyIRRCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sZXDrG0i; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sZXDrG0i"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-43f8116a163so1965086b6e.1
        for <linux-scsi@vger.kernel.org>; Mon, 13 Oct 2025 08:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760370796; x=1760975596; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o20S0NfSVYB6xSo8Pl7j81A8OLLvps51lMgqxMvCNpg=;
        b=sZXDrG0i6t0S0hgENRR+gDDPZrEwcSG7BCAzThU9G2e7H9dDSRASr4e2VvlRQHsAto
         2SvOFjWuXvH9sqJD6heJnAp+/p1m5hJNM9WLEC8r2CbfHbyVBX3imv3DLc4OlA1HAXzb
         IfzaV1SjZMh6BHP8wzx2JVZL6/TGNg3rezzizfOyPGdiBX55Hxp5v7k7re8yNYiFHgjS
         y/LBq9wNFni2cET4u5YE2X2qW8EdSyzoZMVP58cLZeNucaUsSf44WMHkugSZEmTChyHn
         68uC+FzhJo7xqNokUiojOnba5U9PAiJY+8p64MGQPYobN9+wiW7eTBJDHC/BarkVeGfS
         4KBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760370796; x=1760975596;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o20S0NfSVYB6xSo8Pl7j81A8OLLvps51lMgqxMvCNpg=;
        b=c+TFG+zXiQ5IcnXg/IPNjEdh79Xofkz27+tRD1TtZxvazu+IUtbDdehB3qWOSXWIPm
         zGqAaK2CX/gCoLCbhzGW84UJn8HAz8AJIQ1x5SzSjR/QSTW9CLVFFzjp7GZKeS5bVkKC
         vpdeTCEJjngKpXYgbZew5cmAlBX/nFgsSt9+jTliV+jO6c4l1ud1YJccppuoHDh8ajOE
         lEK7kF7pmA83yMvQma2HIqPe+vsHJu3DdkyoqQ9IMfe8UzOeR8bihCQ5jaufzbuqlARg
         cj8JbCu8MhU+zVSSfQKc+GNFbO8hG5fIzCdNhGGvVbWoApoPzNCSLxXWbAC+HvKjVqyK
         PoyQ==
X-Forwarded-Encrypted: i=1; AJvYcCX8kjR0sOygJpjlY8oNixi0wrs3wo8Bju41ki0y1vAqCh7/xMDuhmHIdrgos3GTuInQnDofjs2BVmOs@vger.kernel.org
X-Gm-Message-State: AOJu0YxFaZ+QLAHxZvil55Im5Nub1ibuFbfyn3tYQ7KFaAe/S9/ZhVD8
	KG90T3KfBBCH8KMgWZtvM3hlA0XC1JbVonNhN2UumMhu1JBru08lBRrcFw0F/0ZHYJcrs0iXXnN
	aMR8DWX/XkvFy6HnwwFNDqfIZn/HlO6tYIreUQ4PC5Q==
X-Gm-Gg: ASbGncsqYTibhv0uIa4kvghrU9l9+EwVi6wFGmqpvdQ6pIsaTkPX4Bh8R1Rl6+cSiHQ
	4w7uIm5MVfjOMcQXIX0k5Dj8FxY+4jgrf1KCtGWaKZ8Jv7uw+d9EUL4yLniQWIgI56guv2YfqxF
	OmGN9AL0yFgNsl72LR7sKGVfFnEC7iOlHi6BQtkz+vkVRL+HjrM8c6DN54kzy7/vqTj+LyR756i
	o+n0Nvdq9emIhymgqiw5G4hnDiE
X-Google-Smtp-Source: AGHT+IFkLmceZ5WfJLgB+vu/gJ4u92X3C5X4dHLyX3eG9NwHV1u2xqynqMbxqjysdV+YC53gB6pJi2w4IUxW4cBOy9o=
X-Received: by 2002:a05:6808:17a6:b0:441:c793:d734 with SMTP id
 5614622812f47-441c793e3c6mr3242066b6e.11.1760370796590; Mon, 13 Oct 2025
 08:53:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251001060805.26462-1-beanhuo@iokpp.de> <20251001060805.26462-4-beanhuo@iokpp.de>
 <CAHUa44HA0uoXbkKgyvF4Rb9OJa1Qj-Wh7QAmQxXYAf3grLdktw@mail.gmail.com>
 <893731e9c8e4e74bb0d967ab2e7039e862896dc5.camel@gmail.com>
 <CAHUa44HdV8FJMayVg6TFz7oGZc1b6QntxMsUN8mdTV7pm7vkKQ@mail.gmail.com>
 <a040353e95a67dc3bde09b5f3866aa628150c9db.camel@gmail.com>
 <CAHUa44HYNgiRU5yOrVq8gBwHEEAxGz6TyT0PrBpVOiFfKxYhOQ@mail.gmail.com> <97c39c0cdb6b96d791fe05f8e5496a502a7e6ac6.camel@iokpp.de>
In-Reply-To: <97c39c0cdb6b96d791fe05f8e5496a502a7e6ac6.camel@iokpp.de>
From: Jens Wiklander <jens.wiklander@linaro.org>
Date: Mon, 13 Oct 2025 17:53:05 +0200
X-Gm-Features: AS18NWBfY6qcHPN2KCt3kVJZNcUkMUkWm8tcLo8SQpie6EFEXj14W79vk2cncCY
Message-ID: <CAHUa44FGUvEAe-3nQyNejjuUPnG7JjnaYBgvHzwrs6kUnJYWVw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] scsi: ufs: core: Add OP-TEE based RPMB driver for
 UFS devices
To: Bean Huo <beanhuo@iokpp.de>
Cc: avri.altman@wdc.com, bvanassche@acm.org, alim.akhtar@samsung.com, 
	jejb@linux.ibm.com, martin.petersen@oracle.com, can.guo@oss.qualcomm.com, 
	ulf.hansson@linaro.org, beanhuo@micron.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 13, 2025 at 5:43=E2=80=AFPM Bean Huo <beanhuo@iokpp.de> wrote:
>
> On Mon, 2025-10-13 at 14:22 +0200, Jens Wiklander wrote:
> > >
> > > For certain memory vendors, the serial number is guaranteed to be uni=
que
> > > among
> > > all devices.
> >
> > This is supposed to be generic and not rely on the behavior of only
> > some vendors.
> >
> > >
> > > For partitions or regions, we have appended the region number to the =
end of
> > > the
> > > CID =E2=80=94 please check the patch for details.
> >
> > Yes, but how do you know that you don't overwrite a part of the serial =
number?
> >
> > >
> > > Regarding improving CID uniqueness, we could include the OEM ID or pr=
oduct
> > > number. However, this would make the CID longer than 16 bytes.
> >
> > UFS doesn't have a CID, but there's no need for one either. struct
> > rpmb_descr has dev_id and dev_id_len. It can be any length, within
> > reason.
> >
> > Cheers,
> > Jens
>
>
> Hi Jens,
>
> how about combining wManufacturerID, wManufactureDate, wDeviceVersion,  S=
erial
> Number (in unicode), plus the region number?

Sounds good.

Cheers,
Jens

>
>
> Kind regards,
> Bean
