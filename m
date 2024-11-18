Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0BE1C1F03
	for <linux-scsi@vger.kernel.org>; Mon, 18 Nov 2024 18:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731952823; cv=none; b=Ki3F1Af4R/jI1kV+79ttHL/+lS7vnPO/5tR+c/YFoOvFR00Ol1EV2fWOyv/jISf3Xk052ykfWnGgZvYxihPW/8tQsDi4hhC6XZgthpBCmxkzyG1TWhP4MVoCa2VctkL+I9QM3dFLtG4v35gC6xU+2CeU5S2kBtZJTu+e8Vl6dns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731952823; c=relaxed/simple;
	bh=QsjSrbMQadoK4kWwZoO09P1xz68z2hpgAaGO9d7ls5o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qWyvu6vP/42pNFz6P728cB1EiP63z16ii0RKrRtm+2Zqn8xP2A1iTYF+oBRwAKxHATfRXU/Wn9US0el08Qlv9iza+sNuAVHe1HFCSoSixCoqIDQ6lFuMUHkk9fTUWRerTW2J3IyKeope9AwxSgtEJwBaelvjQ82/o70zoPt8JQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XAI6wHU2; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XAI6wHU2"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-72487ebd2f5so1721825b3a.1
        for <linux-scsi@vger.kernel.org>; Mon, 18 Nov 2024 10:00:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731952821; x=1732557621; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=paCLR7IijVyeUeVe8LL4hZL7nuFgS1QPO7Bsd6hORws=;
        b=XAI6wHU2stTL3lryYCFXJsQASRpddrNLAFT+QUZ+hdLoBL62jISNWh4MWQijOTX3MS
         lQ7ZsdCm7+W5ox2QVDmOxhDDi4pi5muHVyBFg1zVta/8kFtAwA6hbL6nBvuAv0lbGIBL
         x4u+4nC9HyIqFQT2F/+KiPv46Nx1IhETDd/9XezaOWNxzYBBe21BzjjPH68L5LOOuuMU
         4md3M+POizYuNBd0w23+Qpvl97XIPXqXBZ1uLnOBNTmhcgKbysx8BqcNjCQb2ZSBze86
         DSW2kwUZqH5jMzBY5Q79aG+x+VdRNcvqJHstv3L5WTHGj0w5T6wNW23XDJqtjSAtfng0
         sg4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731952821; x=1732557621;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=paCLR7IijVyeUeVe8LL4hZL7nuFgS1QPO7Bsd6hORws=;
        b=QXFiXwjzOC4/xvfuQe5G40b0uOxyZAv3PpwrtZDO6QUpgF/7tAEwgurZqMR325ekQa
         i3mPWxT6wZVJa6N0JgUo5KHP4NAV753aMV5XVUdVEM5niCnMsJVJo6QFI3MjZvbRP3mc
         TKg1mn4gxAn5Q4S5im9ruzmX1SjMgJrz20K9RAs2wTsw8Rf0BwupgY4mI/cQ+bok+fDi
         kTv+wk1GA0/SagviZiG+xUU99e2yccUHcHlJjYSW/xL0XjL+a1R3Er7VhP9/im4BF6If
         SYmHXpfHHy/klwnsVxFDfPWelzarPthRPa/uCUcNxm41cfOT9OqRyWBS+Q/PYrWKqnn0
         kuKw==
X-Forwarded-Encrypted: i=1; AJvYcCU3tASC9JuHvQa+pxcMJ+N3aKNO88pCe5dD3lmKxYzKl76KllwcM0h5cz4HNpNEfV5dF3z9KRd3S1p2@vger.kernel.org
X-Gm-Message-State: AOJu0YyURr7pR5P/pDtSZTbtie+OCP+6cbSes3mOXSj4zs6NOjerbN0w
	1IoWjHDrkGDJZx/PGF7NDgCxbU8dHG+GjEAF8rvUEOM35/BZJj5FYbJSuaKoSCddaGv+BVIUFLk
	P28OjYCP4/lyd1kpfRn8AeYUJ04F1TLnpec65
X-Google-Smtp-Source: AGHT+IEvP+Hgm5H20x8pvUxEcKp1XAOvvO4NdK41CM3JBoEaSiwByV//WtdDkIh33mYoYd53GkX130MHcohV2iDxSxc=
X-Received: by 2002:a05:6a00:3a14:b0:71e:3b51:e850 with SMTP id
 d2e1a72fcca58-72476b72b0emr18120513b3a.2.1731952820747; Mon, 18 Nov 2024
 10:00:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240709160013.634308-1-tadamsjr@google.com> <784f6b4a-7c43-4484-988e-73fad594c99d@oracle.com>
In-Reply-To: <784f6b4a-7c43-4484-988e-73fad594c99d@oracle.com>
From: TJ Adams <tadamsjr@google.com>
Date: Mon, 18 Nov 2024 10:00:09 -0800
Message-ID: <CAL54JgdupgdfeBQwETPv3jCh8iYROqA_DthLQ8cJf7Th1XSV_g@mail.gmail.com>
Subject: Re: [PATCH] scsi: pm80xx: Remove msleep() loop from pm8001_dev_gone_notify()
To: John Garry <john.g.garry@oracle.com>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sorry for the late response.

> > It's possible to end up in a state where pm8001_dev->running_req never
> > reaches zero.
>
> Is that a driver bug then?

I haven't seen this unless artificially creating the situation. This
is a preventative change rather than a response to a specific issue
seen.

> > In that state we will be sleeping forever.
> >
> > sas_execute_internal_abort_dev() can wait for a response for
> > up to 60 seconds (3 retries x 20 seconds). 60 seconds should be enough
> > for pm8001_dev->running_req to get to zero.

> May I suggest you drop running_req at some stage, and use other methods
> to find how many IOs are active?
I haven't given much thought about better ways to keep track of active
ios, so it will have to come later but definitely noted!

On Tue, Jul 9, 2024 at 9:09=E2=80=AFAM John Garry <john.g.garry@oracle.com>=
 wrote:
>
> On 09/07/2024 17:00, TJ Adams wrote:
> > From: Igor Pylypiv <ipylypiv@google.com>
> >
> > It's possible to end up in a state where pm8001_dev->running_req never
> > reaches zero.
>
> Is that a driver bug then?
>
> > In that state we will be sleeping forever.
> >
> > sas_execute_internal_abort_dev() can wait for a response for
> > up to 60 seconds (3 retries x 20 seconds). 60 seconds should be enough
> > for pm8001_dev->running_req to get to zero.
>
> May I suggest you drop running_req at some stage, and use other methods
> to find how many IOs are active?
>
> >
> > Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
> > Signed-off-by: TJ Adams <tadamsjr@google.com>
> > ---
> >   drivers/scsi/pm8001/pm8001_sas.c | 7 +++++--
> >   1 file changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8=
001_sas.c
> > index a5a31dfa4512..513e9a49838c 100644
> > --- a/drivers/scsi/pm8001/pm8001_sas.c
> > +++ b/drivers/scsi/pm8001/pm8001_sas.c
> > @@ -712,8 +712,11 @@ static void pm8001_dev_gone_notify(struct domain_d=
evice *dev)
> >               if (atomic_read(&pm8001_dev->running_req)) {
> >                       spin_unlock_irqrestore(&pm8001_ha->lock, flags);
> >                       sas_execute_internal_abort_dev(dev, 0, NULL);
> > -                     while (atomic_read(&pm8001_dev->running_req))
> > -                             msleep(20);
> > +                     if (atomic_read(&pm8001_dev->running_req)) {
> > +                             pm8001_dbg(pm8001_ha, FAIL,
> > +                                        "device_id: %u: Failed to abor=
t %d requests!\n",
> > +                                        device_id, atomic_read(&pm8001=
_dev->running_req));
> > +                     }
> >                       spin_lock_irqsave(&pm8001_ha->lock, flags);
> >               }
> >               PM8001_CHIP_DISP->dereg_dev_req(pm8001_ha, device_id);
>
