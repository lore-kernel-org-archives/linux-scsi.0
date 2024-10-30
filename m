Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC84216452
	for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 15:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730301226; cv=none; b=ltneowp7xlU+ZLOQ22LoTyJmo4t0bSt4IrMH8xUyWRBRLGGPaXYpNrWrDsTAe+Bnlg9nEThVH4o4LYmscqfo7ZCIw0RPH027wVi+hyLnTxy40IyL36rDSlz1esA7/uWhfILivGDmdQi2VnXnLca9IcYHxAsOFgJ4Ykvf2xI3A3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730301226; c=relaxed/simple;
	bh=Kboc7NXdXo+3kfo1Ig38RlRwoliHzf/C12iYA5MLCak=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bHIwCjSFmdrcanvhtv5f3qxcFAHYDbQVme/pgYjwNHE935ltzwEV65u0Kp4qWu2KckDv9wkUkDn9+zWgmglQasGvuv3b0nl2P5+kwpt+T3NckVF9gPoC34846qWRHrs0x1cfRSNl7kjm/adsT393y+OgEDoIpe33ybsuM7ZsLaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kmbKivnK; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kmbKivnK"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2fb5a9c7420so65375011fa.3
        for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 08:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730301222; x=1730906022; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Kboc7NXdXo+3kfo1Ig38RlRwoliHzf/C12iYA5MLCak=;
        b=kmbKivnKMiwKaQNpv6xc2z3LYDFVM9utrLwjg3EVhoHU7hOedvAMOFigs5ll1fsJuz
         vmu9vt8tPxVnIxIi/GFrK2+N/bZeagfFu1EPqdNFQLZyj9gl43y3Ni2ltqSWoIRLJX6D
         JxFMAo0e+GqxThSgfn5NtyVGxJPzzRnbXInh43Uh+laS3GTyGhxYJDw24EyEP/G1Je1Y
         qd2fAegwcfGtJQVXToFMhCuFLkUMgPZ1GDCyU7B2xUa4Tq/NqVCqBL4Affe332S0V1Fj
         2MehdgbMuEIz+aZMTJAl7WcBYkY2p6qsC+/YmvtF87BDGMQbHEBB18xvcMhBWzCRxXiG
         jrTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730301222; x=1730906022;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Kboc7NXdXo+3kfo1Ig38RlRwoliHzf/C12iYA5MLCak=;
        b=ayXplP+8ppm9V1rK7htv+zHkJ38KRjNRcumlgMtrWdx9cblplkyjbzeHuqceRSWdJ9
         VMx6oE3DIpxfqmwKtp05nq2mmHGgk+pdMYwqOLso+e99hGNZK6ozPc3NHab1BN0/c5Mb
         3zbw1NDJb6/ExVCp3YGGf19BU4G/kZqSN9OIi2MhDJLXsJfuIsD1dkjlFPUhq3+bSBIw
         DuylCoj6J5wqGbPqwzEfhUEe/O9em2QL6Pq8idWzwlR/xaTguzzYtT1rBHf3YQSFgqTC
         +RwqnQnuka9xDEOJFyT+W0MnXZaa3MQjIXHXXoLUjJSDqqk+C73L29HDyrw8O8ZVXKi8
         htKg==
X-Forwarded-Encrypted: i=1; AJvYcCXXQKr5luDHy/YZzHsYl4YNODIEC9TzaVn/cs8asIzowDkIlZ2e4xkKpMqGb0MIOXwU0HEdzWv8tjeo@vger.kernel.org
X-Gm-Message-State: AOJu0YwYwzOKAFmR4xHG/7xo5wH6C+5pFaLLJ8YGj6kndHaHnSoo1iE8
	NB0UyqZJHqYO6I9e0xwPZ7tf6j/N5Eb8LapJ55Elwe3KLQ39/WF4
X-Google-Smtp-Source: AGHT+IHjn/PaD/4x3EnL60x47uX6w7pNW7Gk+OqsWXT+59LHbF2GEIS+ANfH5Oy4HNJZ/mex2+2+1Q==
X-Received: by 2002:a05:651c:19a1:b0:2fb:5138:a615 with SMTP id 38308e7fff4ca-2fcbddfcba6mr81762391fa.0.1730301221597;
        Wed, 30 Oct 2024 08:13:41 -0700 (PDT)
Received: from [10.176.235.56] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cbb6348c93sm4753741a12.97.2024.10.30.08.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2024 08:13:41 -0700 (PDT)
Message-ID: <580c23960612b82ae0278ad51d13df2b6c0a9fea.camel@gmail.com>
Subject: Re: [EXT] Re: [PATCH v2] ufs: core: Add WB buffer resize support
From: Bean Huo <huobean@gmail.com>
To: Huan Tang <tanghuan@vivo.com>, beanhuo@micron.com
Cc: bvanassche@acm.org, cang@qti.qualcomm.com, linux-scsi@vger.kernel.org, 
	opensource.kernel@vivo.com, richardp@quicinc.com, luhongfei@vivo.com
Date: Wed, 30 Oct 2024 16:13:38 +0100
In-Reply-To: <20241030093743.659-1-tanghuan@vivo.com>
References: 
	<SA6PR08MB101639506856CD749E433360FDB4B2@SA6PR08MB10163.namprd08.prod.outlook.com>
	 <20241030093743.659-1-tanghuan@vivo.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2024-10-30 at 17:37 +0800, Huan Tang wrote:
> > Hi Bart,
> >=20
> > Thank you for your feedback. That's good point. But I didn't
> > observe the ufs-bsg path bypassing core logic such as clock scaling
> > and clock gating. However, I might be mistaken.=20
> >=20
> > From my understanding, changing certain attributes can indeed
> > bypass the UFS driver tracking. But in this particular patch, there
> > is no parameter or flag associated that is tracked by the UFS
> > driver.
> >=20
> > Best regards,
> > Bean
>=20
> Hi Bean,
>=20
> Thank you for your reply!
>=20
> Actually, there are some parameters related to UFS driver; for
> example: b_presrv_uspc_en, host_sem, etc.
>=20
> Thanks
> Huan


I meant there isn=E2=80=99t a UFS driver parameter tied to adjusting the WB=
 size.=C2=A0
If you think there is issue on changing WB size over ufs-bsg, please
make sure
to emphasize the issue of this and the reason why you add this new
interface in
your patch.


Kind regards,
Bean
