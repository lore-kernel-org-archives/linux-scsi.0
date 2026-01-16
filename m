Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A6B304BB2
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2026 08:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768552301; cv=pass; b=fgWAGxTLVLn5fj6SNfb4mvyD0q84XZqtQnD6HQrNC7wnZgx++OOC934QkREigwAHLAQW7LSgfXYfav10QYTqqUq8nb8/sr3hbzWIYtzaG9/elEgV40Gva1F1z+OJfH2o449h0QRUxaK8arI7kvHP9ukhnZtXsrNj3bja3arVong=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768552301; c=relaxed/simple;
	bh=lGJaSEjtMz8imsBzKLngD6YwSyeRBN46plAK76096vc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qeqX/5+XNJDk4WfTQC+AGvhYRyuH59FCGG50mTYvVt4x2d+O0CHiL+3V7kQ58Qjjev+sl4r8XZVLcnj5MqChItx4Y56zTV8oPR3RTHJW+2kQu5g6tddwPbAZ1TFyrQ6tE4McRY6MJqIEQ0kkT4yKOqB4FHJD3J7D1/xdYvw304c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zqd1JB3q; arc=pass smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zqd1JB3q"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-64b6f896689so228565a12.0
        for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2026 00:31:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768552298; cv=none;
        d=google.com; s=arc-20240605;
        b=Z/+IvQDwvbkG/sayHY+0qLbaH3XmDyMz9s9kYy2eBEuZIiSj3TlMADVO3+bxrUjbv3
         2Yk8imD0aGCzqo4BEfl8fVQy6mlwvp0Hje+jfpcPDaAx2uk6iWyiqG1ZtWrUHeME4aDn
         ujR7TSbBdDd9xL+Sw7foddY4vC0oknbQDTmfUNX5UGbdnOjT2OxN+6ukvwj7HHQSFQhR
         esT17LjuJh1xtC8SibwQvOl31FTzRI9v83mUkxBDe5nzIS6fLOFI92uboMki2UP3UVaP
         gV1WIAlpT+dw9KlnaMgjputXWzN3HcH1IaepanBXziz1rzfOAA37TWFVVq/3LuljZX0i
         gDCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=s4AM1vJ6VB772nu+HJserptUp16mrPO0KDThuVoz0sw=;
        fh=PLgAqDVPoZSritA3P9nuLk4JWXJzv70TframC4vtO8g=;
        b=K8lOWSRy4/J4eLxuvPtH81iLTw8VoohMZjbvHRqhPGPINzP8VUNzaj5gmX3twJ/n67
         ZcQ/MX8qB1e4egt/aQhwmPEzpK5IJLviYNkC0G/zaeFGIvGmZv7TA/9ahfe2FqkZFiTh
         cpUtNohGMLCktzFjFqD+f/Far1mRpgXR00/mbZkDNkP7T9nNKPpcH2zbCL+xIBF+SYjV
         t1tQxtOicKE4JEKrYiTav+y4LSe4325zVUrA+2aYWUfMr34zobDKmlv0KpFcX1Losqpv
         QO/Y43mEx3PUI+SkhajKii8VwhQgTRqikuRnXN/j7Fz/GGTuktGVXI1cZahuK7wvuL0m
         pl/A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768552298; x=1769157098; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s4AM1vJ6VB772nu+HJserptUp16mrPO0KDThuVoz0sw=;
        b=Zqd1JB3qHVorWIZO4vLyLyS5HE91qE4FsOZfKX/q7OdUSD3UpEoUXK28FeCu7Gp7QF
         q5dnSlNHRnwi9h3JDITWQgD3bPqlV4p8bs9jr4yuVbLtW1KKa9Fb+Q7FR5zYlcFxZE9W
         1XZDWQutZ4QSjAVBh/ukjJTGLEcUWm5RlOj6aYdtjigTdO0e0x7GMS8ldVntmzabIbSq
         /3HxOllA/X0bsuv1xnjU4Vt9RFzilou8P0hLUKjuKB3Hyr39SYRbJ+8gEV64k6ufG1xa
         3QWRdGG2hUnu1GAivTViGM5FOAHZ0Vc6i79BAenCmDabRlRIpp9VTAiuBblBhVA+Birk
         aGNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768552298; x=1769157098;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s4AM1vJ6VB772nu+HJserptUp16mrPO0KDThuVoz0sw=;
        b=oq/KI3wwt41GJgjDDf4CYlVb/VVjXHYU1uQhnnQVka3SDRIRUbFRTnbwEUiTYTQIVn
         V+ts8/isC6JhJDrynip8h22PtMzZU6hFAyUzZJ0V7gl0lieK3uJURxdJ0DVwcPpFFh4s
         YRPuvXi27xR3FxUMm/LdtSsQqGCcYjsOArLk+4jrs69KqXyeIaJP2ZrszZvEWKy0J7+p
         SmNq8Ojre2r5UE7Da89ipT7KBCOnIPJU8s0Win7dcU5ODuawHxqr9+Nm2HNTlhI54+q2
         jFj4XQUJw027deOR0FF7E/qRZmDGnuDi/Axx867/uDim3fm+klG7vKiaBNQr5KqguqG9
         e5cA==
X-Forwarded-Encrypted: i=1; AJvYcCU53J3LbTHDNIZPTAMfYvcKWHhi0MZ7/Yg5/3i5mqu+1X2ilyI+c1+qIH03TMnFZfvA/W6LJ98EdKnQ@vger.kernel.org
X-Gm-Message-State: AOJu0Yybtij+apWS0ZfPIlsR5PZqR9uBiYaVV+xdsAzHyVAL2hu24UPR
	lHCf1GmYbfVtZVBFu468Otz3mDsoGP3PUqDqTWO2Itea/+UjGdvJ2WVji9fVOo0GhoXO3/VTk53
	9FUeS8luNlpnbYbee3dyJrggPv6mAwlc=
X-Gm-Gg: AY/fxX4xTeTU1XBRDQAwfO0XQIJcMhLT3gTsarGLHrV2s0Uk4LB14s71e9qDqn+g/9C
	pOvmui9wB4/lOLqwunceYno+7v0xZii40onLLa3W0A1yYpOfE4wtYB+e3lL3O0e/KsMXf8W9STL
	whRmqvbNS4sXdfBq5ZIjnNwfhxQAJ7Snsz9V1TSjMLWjsJAuxBuUyakPCQ6f1LrAkw+DLUnV6jv
	F2Q8M62S5yJ9DM4/WhibsfoxzGx7TBdB3QZt51/MyFMdDRYVxdv2bJ00uU6rmaRQvYRl2k=
X-Received: by 2002:a05:6402:1610:b0:655:b07e:95c8 with SMTP id
 4fb4d7f45d1cf-655b07e9923mr292776a12.8.1768552297485; Fri, 16 Jan 2026
 00:31:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260115175427.290819-1-dg573847474@gmail.com> <CAMGffEk3cgah3-xTaokDeiM0RGwKQn1OO43dWLJAwoaVDfHWdQ@mail.gmail.com>
In-Reply-To: <CAMGffEk3cgah3-xTaokDeiM0RGwKQn1OO43dWLJAwoaVDfHWdQ@mail.gmail.com>
From: Chengfeng Ye <dg573847474@gmail.com>
Date: Fri, 16 Jan 2026 16:31:25 +0800
X-Gm-Features: AZwV_Qhek82lyv8_JHrWSf1MfG7thlzmsaWUT56FZeCltxUhZuBIT8FqziYF--c
Message-ID: <CAAo+4rXpSK-LzrHgU0g-c3n=q3xB3j+-GtmUZOLqQ7S44yS_2Q@mail.gmail.com>
Subject: Re: [PATCH v2] scsi: pm8001: Fix data race in sysfs SAS address read
To: Jinpu Wang <jinpu.wang@ionos.com>
Cc: "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bvanassche@acm.org>, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chengfeng Ye <cyeaa@connect.ust.hk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> As James commented, sas address is uniq, not something changing all the t=
ime.

I think maybe the more noteworthy case is sas address could be read
when it is only partially initialized.
It might happen because the sysfs is mounted by scsi_add_host() at
line 1196 of pm8001_init.c
during probe, prior to the sas address being initialized by the
pm8001_init_sas_add() called
at line 1208. The small window could allow sysfs read return
non-initialized (should be
zero) or partially initialized sas address (due to the non-atomic read/writ=
e)

> Do you see any real issue?

No, I just read the code and spotted this potential issue, and so I reporte=
d it.

Reference: https://github.com/torvalds/linux/blob/master/drivers/scsi/pm800=
1/pm8001_init.c#L1196

Best regards,
Chengfeng




Jinpu Wang <jinpu.wang@ionos.com> =E4=BA=8E2026=E5=B9=B41=E6=9C=8816=E6=97=
=A5=E5=91=A8=E4=BA=94 13:46=E5=86=99=E9=81=93=EF=BC=9A
>
> On Thu, Jan 15, 2026 at 6:55=E2=80=AFPM Chengfeng Ye <dg573847474@gmail.c=
om> wrote:
> >
> > From: Chengfeng Ye <cyeaa@connect.ust.hk>
> >
> > Fix a data race where pm8001_ctl_host_sas_address_show() reads
> > pm8001_ha->sas_addr without synchronization while it can be written
> > from interrupt context in pm8001_mpi_get_nvmd_resp().
> >
> > The write path is already protected by pm8001_ha->lock (held by
> > process_oq() when calling pm8001_mpi_get_nvmd_resp()),
> > but the sysfs read path accesses the 8-byte SAS address without
> > any synchronization, allowing torn reads.
> >
> > Thread interleaving scenario:
> >
> >            Thread A (sysfs read)     |    Thread B (interrupt context)
> > -------------------------------------+---------------------------------=
---
> > pm8001_ctl_host_sas_address_show()  |
> > |- read sas_addr[0..3]               |
> >                                      | process_oq()
> >                                      | |- spin_lock_irqsave(&lock)
> >                                      | |- process_one_iomb()
> >                                      | |  |- pm8001_mpi_get_nvmd_resp()
> >                                      | |     |- memcpy(sas_addr, new, 8=
)
> >                                      | |        /* writes all 8 bytes *=
/
> >                                      | |- spin_unlock_irqrestore(&lock)
> > |- read sas_addr[4..7]               |
> >    /* gets mix of old and new */    |
> >
> > Fix by protecting the sysfs read with the same pm8001_ha->lock
> > using guard(spinlock_irqsave) for automatic lock cleanup.
> >
> > Signed-off-by: Chengfeng Ye <cyeaa@connect.ust.hk>
> As James commented, sas address is uniq, not something changing all the t=
ime.
> Do you see any real issue?
> > ---
> > V1 -> V2: Use guard instead of lock/unlock pair
> >
> >  drivers/scsi/pm8001/pm8001_ctl.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8=
001_ctl.c
> > index cbfda8c04e95..200ee6bbd413 100644
> > --- a/drivers/scsi/pm8001/pm8001_ctl.c
> > +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> > @@ -311,6 +311,8 @@ static ssize_t pm8001_ctl_host_sas_address_show(str=
uct device *cdev,
> >         struct Scsi_Host *shost =3D class_to_shost(cdev);
> >         struct sas_ha_struct *sha =3D SHOST_TO_SAS_HA(shost);
> >         struct pm8001_hba_info *pm8001_ha =3D sha->lldd_ha;
> > +
> > +       guard(spinlock_irqsave)(&pm8001_ha->lock);
> >         return sysfs_emit(buf, "0x%016llx\n",
> >                         be64_to_cpu(*(__be64 *)pm8001_ha->sas_addr));
> >  }
> > --
> > 2.25.1
> >
