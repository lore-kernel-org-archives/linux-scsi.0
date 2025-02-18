Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF05D234987
	for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2025 11:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739876799; cv=none; b=PbUlRcVRr1BjEjBT3FsxQmj77TwzCXz9+lVk6giakmvnccJuuC3p5SsOuGvOYThrLPCfwqPryEpJKMoEYb9elCQ8EE3Ohrw90FslRmwiVxJTGnXFUriypZPAv5dQH2yKjLj6BAhMaWxdvBSyB6jKocohsBoHDHf8Wz1MeOOOn/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739876799; c=relaxed/simple;
	bh=nIFcW1zAQNpDpL9+kzL6B5pY+AHLOIpYOl91ulP2I6U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ayQnsSb6XhD6hiH9ghVgkm4n+JBIcLdp4pSZk4FUcVQHP6ttClZK2FKvmTINP6EFsnS8ImJwqeVgezLYmhVf5rmQq4IdAvcHsj58EYAHja4Q6iVEbBB6JgA0x2vhCxcFXRU6uF9D5HtWDnfn54CxXfrleCxGims2bPXcrsvLVR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xBMY9MNr; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xBMY9MNr"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-6f74b78df93so47249297b3.0
        for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2025 03:06:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739876797; x=1740481597; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZxBzcG+1RCPRksrqYQsyAhoS4ssC4QSuiEWJmIW8two=;
        b=xBMY9MNrSOLEewg/P1qKiONEWuEY9xgOJI/kT9834cbP420ehuod8GqETItTN8z1Cz
         I2jCNa/E9ND8xKBItEs4mIAkIXvXPR+I+6TsVP2ZmUlIlRoX4PJxrZ46TQgV1UL4TomN
         ZU+C6DMzOaqAyJC93PVL2n2uSN0uD5zVjRRs6uhcPNX/2jUnaEXa0NbrOlzG96bF+K1F
         jX9HrC+ySq88z4Oe87CUCrP9dpQ7MxNbLulAI9fT//MrQLTlXIblBQ3aa9WPLRQ9wVip
         aSWukDurDrcojMSlQN5whtyGZb5EUEHrpEPB7dP8Hz8IPoOL+2eKocDFn+YLWoaMWRb8
         r5AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739876797; x=1740481597;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZxBzcG+1RCPRksrqYQsyAhoS4ssC4QSuiEWJmIW8two=;
        b=L8AdNcHNfIlKdEbdbSECSrcjpUEncFAiw8+EEpOdwPjhPakmwzyeh6lCXiY+FVjbWB
         5N/UZVdGDnnInPg0WyC8cqKDZblH/0Vqnu1ydXWWwOOL8GyYYDv4xS3u7V4Zn0Vi9zJw
         Ly78sCwWQm1Kjpk84Z4CK9jY/2LGRn59MREfoQq7h+38CDQB/BoV+TOwWzG7h0FqvElu
         kLfvHAB+YtaVls88LpHmHS08zxp+aj/SGnBzkquOzbRQvQyUyB6bQaEtMN3tOTKKjHcG
         utL/J5GMKdZGtH7t15jZ3cTbxBraNqgbvBMLdz2K+V52ZWhba9WgOlWyiNqfDm+h7hga
         pTsQ==
X-Forwarded-Encrypted: i=1; AJvYcCXRKVSydpsG53ncfyFAgpcwImU09yo2yEKWdRp1CDZZ0MoixQHRVZQUplEXzeOtgVltjxrw2/su4gc4@vger.kernel.org
X-Gm-Message-State: AOJu0YxVYDC3u9rOmEn9FZoyGkXfd+QT0a/EmM4Ct28Mb8G55UUkoBNN
	4NZluyGkQ6b8xQmyJPGEhL1WJU0S1PH9uhPjH+NbUk7FcwBr/euDyMQziT6u7aDQzXFRw/dlw5Y
	GRj10mQQ2yQbuC67p4PPFyj32tqxT/corL8ZHQw==
X-Gm-Gg: ASbGncupoz6l/Y8iIKOlXKVXr1f1rrWVMfv5m0W7sQiSCGtAMhpwzQmDsQppjlgu/3W
	y/UkCFIxWy0hdc1yc9kTCHiqm7Qnr6MgyO/pg27SB/qfGGV/KIEL3b/A9u5xSURU8ACxklaG31A
	==
X-Google-Smtp-Source: AGHT+IHLwVd8/FJ71sPKuZozOz3hvT7H8xMZqgkAwVXdbgbT08OeRrY0+2kxMfjx0SKdM7rJ6iJnri3ipFwnGN4coNk=
X-Received: by 2002:a05:6902:2506:b0:e3c:7c3f:253a with SMTP id
 3f1490d57ef6-e5dc91dd54amr9391445276.36.1739876796754; Tue, 18 Feb 2025
 03:06:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1738736156-119203-1-git-send-email-shawn.lin@rock-chips.com>
 <2579724.BzM5BlMlMQ@diego> <321804ef-f852-47cf-afd7-723666ec8f62@arm.com>
 <5649637.F8r316W7xa@diego> <fa184920-e1f5-4eee-894a-f617e6d8e817@rock-chips.com>
In-Reply-To: <fa184920-e1f5-4eee-894a-f617e6d8e817@rock-chips.com>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Tue, 18 Feb 2025 12:05:59 +0100
X-Gm-Features: AWEUYZl62zD8xYisGrHF_NbsDrxarZMOFP8pvEVYVbnRWAYdlQmrw0kY_HrKSt8
Message-ID: <CAPDyKFqPZcQOqEbyfy8uC-SO8vx1f=Ck-fPSqvXqiS1H-JJsrA@mail.gmail.com>
Subject: Re: [PATCH v7 4/7] pmdomain: rockchip: Add smc call to inform firmware
To: Shawn Lin <shawn.lin@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>, 
	Steven Price <steven.price@arm.com>, 
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
	YiFeng Zhao <zyf@rock-chips.com>, Liang Chen <cl@rock-chips.com>, linux-scsi@vger.kernel.org, 
	linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org, 
	linux-pm@vger.kernel.org, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 18 Feb 2025 at 01:53, Shawn Lin <shawn.lin@rock-chips.com> wrote:
>
> Hi Heiko, Steven
>
> =E5=9C=A8 2025/2/18 4:50, Heiko St=C3=BCbner =E5=86=99=E9=81=93:
> > Am Montag, 17. Februar 2025, 18:10:32 MEZ schrieb Steven Price:
> >> On 17/02/2025 15:16, Heiko St=C3=BCbner wrote:
> >>> Hi Steven,
> >>>
> >>> Am Montag, 17. Februar 2025, 15:47:21 MEZ schrieb Steven Price:
> >>>> On 05/02/2025 06:15, Shawn Lin wrote:
> >>>>> Inform firmware to keep the power domain on or off.
> >>>>>
> >>>>> Suggested-by: Ulf Hansson <ulf.hansson@linaro.org>
> >>>>> Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
> >>>>> ---
> >>>>
> >>>> This patch is causing my Firefly RK3288 to fail to boot, it hangs
> >>>> shortly after reaching user space, but the bootup messages include t=
he
> >>>> suspicious line "Bad mode in prefetch abort handler detected".
> >>>> I suspect the firmware on this board doesn't support this new SMC
> >>>> correctly. Reverting this patch on top of linux-next gets everything
> >>>> working again.
> >>>
> >>> Is your board actually running some trusted firmware?
> >>
> >> Not as far as I know.
> >>
> >>> Stock rk3288 never had tf-a / psci [0], I did work on that for a whil=
e,
> >>> but don't think that ever took off.
> >>>
> >>> I'm wondering who the smcc call is calling, but don't know about
> >>> about smcc stuff.
> >>
> >> Good question - it's quite possible things are blowing up just because
> >> there's nothing there to handle the SMC. My DTB is as upstream:
> >>
> >>          cpus {
> >>                  #address-cells =3D <0x01>;
> >>                  #size-cells =3D <0x00>;
> >>                  enable-method =3D "rockchip,rk3066-smp";
> >>                  rockchip,pmu =3D <0x06>;
> >>
> >> I haven't investigated why this code is attempting to call an SMC on
> >> this board.
> >
> > I guess the why is easy, something to do with suspend :-) .
> >
> > I did go testing a bit, booting a rk3288-veyron produces the same issue
> > you saw, likely due to the non-existent trusted-firmware.
> >
> > On the arm64-side, I tried a plethora of socs + tfa-versions,
> >
> >    rk3328: v2.5 upstream(?)-tf-a
> >    rk3399: v2.9 upstream-tf-a
> >    px30: v2.4+v2.9 upstream-tf-a
> >    rk3568: v2.3 vendor-tf-a
> >    rk3588: v2.3 vendor-tf-a
> >
> > and all ran just fine.
> > So it really looks like the smcc call going to some unset location is
> > the culprit.
> >
> > Looking at other users of arm_smcc_smc, most of them seem to be handled
> > unguarded, but some older(?) arm32 boards actually check their DTs for =
an
> > optee node before trying their smc-call.
> >
> > I guess in the pm-domain case, we could just wrap the call with:
> >       if(arm_smccc_1_1_get_conduit() !=3D SMCCC_CONDUIT_NONE)
> >
>
> Thanks for the report and helping find out the cause!
>
> @Ulf, if the solution above seems reasonable to you, I can cook a fix-up
> patch.

Seems reasonable to me, thanks!

[...]

Kind regards
Uffe
