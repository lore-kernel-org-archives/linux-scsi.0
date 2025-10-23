Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7461F2BA4
	for <linux-scsi@vger.kernel.org>; Thu, 23 Oct 2025 17:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761240634; cv=none; b=NVaCwJoK51lRGwoPhflyQuRmoeC/nQ4iwnaPUg1PXwDaaD8j1sOnjJ19a+nqkhtQQSkTRPAZWf8uLm+a208D0ffTMwRBq9h3tAATkp5eZKAItfgmiWPRDeCFywbSt9kA2rk7J+Hmx1gsCVuxHITrrPQnl1H4SMiNIcBYOEmS9L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761240634; c=relaxed/simple;
	bh=3R3FFQDckzFinPZ9DYjEUNKdg4nDN9YOsYJfidN7V/4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LCZ6Q+I03E0wqRYwL0bzQjSfYffA4FIx5GJZEYFrMiEh/2ZVDjf+WWaxH6AGCLvtct0eZAi6etHT1KeaNF5i9kEQdgFpS8pYR6Yu1Ie7Ps4ld5a8gu9T+kUNjhdw4OYRvRbhUEfVxj1c1rH4/WXXFOPqjRtb8iSjj0tDUly9qpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iDyKTGbI; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iDyKTGbI"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-4439f1df5f6so331641b6e.0
        for <linux-scsi@vger.kernel.org>; Thu, 23 Oct 2025 10:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761240632; x=1761845432; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1q0ZDfwbl/u7cybt8YKpCyUwHveVPSaljmjRaq3VaaQ=;
        b=iDyKTGbIljH5PXCy5JUP4gslZmJvdIGXrhGEzy+1t7omMmLj0sO0arJGllb+McyT1u
         eVKB26+9dklELx2CbWY9y024Qw6r5Cc8Zvp+EAFSy+/aLS530J5S23NHCaKNoseH51pj
         iuoyWsG1Wg6oz/dHInpH7UYWci26DOJniR6z6+yME7fPOjSklfRVk9m7gD+q+ypHMUs/
         6TNsgWZeNh1CarzGvcgPw1E/0r5G1zNCRoYadI3a0W9Mf7LpFeo9PS3bvsyA0twPmnGj
         0gYEPAnwwsa2IUIfM5c/NKRWurLuNZDuqa1X84rjYHbrKRW69QWnVKAOYS85x81oES8p
         4xWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761240632; x=1761845432;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1q0ZDfwbl/u7cybt8YKpCyUwHveVPSaljmjRaq3VaaQ=;
        b=T4NC+QTHlXNOidCC2aGZbQop+2TDSP1XCuib+QWj/9mngBXEThcfT6U4mB/6n3vpHx
         UCj7/EHgsQKvGhU89/V+QAh8ZweoDpJvhcSYH4dA9L++k9ODlsxiurDsqh02/+6TuTO3
         bhmbtitP7DBzORieePbORjyqIGon/ZyAJEJTkTirBbsvb/M1aHLxY+t6YAjSPx1N9/bt
         N8IvHLQJ4Ka6ZM38DwEdH1j0QVTzwYY9xVy+Cthl6AWNnMAlccEfXmP/AsckVtuldghN
         Q9QhQjmNsUg/WcoYycE0zgTMh+CYRboEGHhCaUuIO5YjnQX6ShL0ReTrW0J4guxBkU68
         eZtA==
X-Forwarded-Encrypted: i=1; AJvYcCVwZTY/FDDa3fQABchRFVEpSwDVyw+LhtSPI2JLI+PLTdF3BN/gIcFF/n2R6ijXbFS3O6ly5m/NH+sv@vger.kernel.org
X-Gm-Message-State: AOJu0YwEjSBNCVzr33YGRBZfICzZXQjnSBKVMDW3UTj1ISt2uwXsNk03
	3lL6YClUbrAdAnlO5FDTYFeu6Jl1RJi+rybT5FuUqciJFX5yLCc2bxkys4U341Gm6yw6yB1+0Q9
	oMoubfyfiwp0J63tbxtisOJAQ7IZ+IdjxYm8JKKD+IA==
X-Gm-Gg: ASbGncss+XYbyD8XEvGolS9HqMvcqCuF3tIjExhKzakL4i75ytx7hVUx2Oicrd63gfJ
	3PJhPS0gX3DWvVvXsXmuMv/IjoF2TshI3OdFi431HV3zJGTKUPLGmxsHY4dP3ofqVcGgsAio3lo
	ssCnrx006ziiGJ9CoKSB1RO7Up410GEQgPKnkhkjfwc14jh7FZrN6LtlLuVgFCL0/iskIqwl2jV
	jQgKI9FgZuVG6znpzNyPdDNL2FOJ+kjJxA1zj+45fPyEVvjkC5HxGx2CPRe2yT5St4miw==
X-Google-Smtp-Source: AGHT+IGQZb/+WiP0CrvwARqmYEBm3+w/xU0bS9W+t7PIXzN81QWPsXUtM+r7NNZB2Chz3CZ4OOyIxS/PfDaH9o77eNQ=
X-Received: by 2002:a05:6808:1304:b0:43f:46fb:cb92 with SMTP id
 5614622812f47-443a3013dc8mr10225394b6e.48.1761240632004; Thu, 23 Oct 2025
 10:30:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251021124254.1120214-1-beanhuo@iokpp.de> <20251021124254.1120214-4-beanhuo@iokpp.de>
 <CAHUa44FfQAPWGgVbfrCnZfF9HkGwW=fgUhV-y9RKrUQf1V6yNg@mail.gmail.com> <9f3d1d277b0d102b5d912b533be21ed78103e142.camel@gmail.com>
In-Reply-To: <9f3d1d277b0d102b5d912b533be21ed78103e142.camel@gmail.com>
From: Jens Wiklander <jens.wiklander@linaro.org>
Date: Thu, 23 Oct 2025 19:30:20 +0200
X-Gm-Features: AS18NWAw--zf1xvWFn8x1bXCYQIGoU7cQtPmENDlCdNol0eKwsUCjkp7RVvRtiI
Message-ID: <CAHUa44FCYnQ7EL8pXH-72ptENus7KZRvfE8Ym1vjN4QiVsVtqQ@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] scsi: ufs: core: Add OP-TEE based RPMB driver for
 UFS devices
To: Bean Huo <huobean@gmail.com>
Cc: avri.altman@wdc.com, avri.altman@sandisk.com, bvanassche@acm.org, 
	alim.akhtar@samsung.com, jejb@linux.ibm.com, martin.petersen@oracle.com, 
	can.guo@oss.qualcomm.com, ulf.hansson@linaro.org, beanhuo@micron.com, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 23, 2025 at 5:09=E2=80=AFPM Bean Huo <huobean@gmail.com> wrote:
>
> On Thu, 2025-10-23 at 15:53 +0200, Jens Wiklander wrote:
> > > +       device_id =3D kasprintf(GFP_KERNEL, "%04X-%04X-%s-%s-%04X-%04=
X",
> > > +                             dev_info->wmanufacturerid, dev_info-
> > > >wspecversion,
> > > +                             dev_info->model, serial_hex, device_ver=
sion,
> > > +                             manufacture_date);
> >
> >
> > The device ID is part of the ABI with the secure world or the firmware
> > we're serving. It might be worth adding a comment so the format isn't
> > changed without understanding the consequences.
> >
> > Cheers,
> > Jens
>
>
> Jens,
>
> I can add, do you have suggestion for this reminder message, for example:
>
> /*
>  * WARNING: This device ID format is part of the stable ABI between
>  * the kernel and secure world (OP-TEE). Any changes to this format
>  * must be coordinated with firmware updates to avoid breaking
>  * communication with the secure world.
>  */
>
> or
>
> /* Device ID format is ABI with secure world - do not change without firm=
ware
> coordination */
>

The latter should be enough.

Thanks,
Jens
