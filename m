Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68249369992
	for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2025 16:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763657224; cv=none; b=S+pOgcnnKltrbxuVjuF0H/TegXjJAPimy4teMkGFzI7oHVtlqZPglAedT8+QJQKHgnGHc3h6J/WOW1Dqelp4x/W2Kq3Jjh4N08fXaMaqBCgtnw2QOT6T+RSjped+ApolxX47k45nnywNLF8UlWra/1EKoVn8g8rzmK6B0E8WHUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763657224; c=relaxed/simple;
	bh=Zt6p2aHZDBzaAD8QhGSLx+Kia8Xu1TI+LxD3yxX2DVI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FIsG7WGeKZ3+2QQ7m/cWqMzOi2d2S4ETYn0Bt6IEgJmMztAkO4NRxyUzT6rL3Cs6BrTeX5uwdD1fC3iFYljPWEp50Ts6f3R9iAiBlfIYn54NWAI4+8fR/WTWNfnkDSaBYLesrIi50M8UZwvjj95G2OY1/LUbu2u50ndQ9xdzOnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=D9HPVrU/; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="D9HPVrU/"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5957ac0efc2so1028541e87.1
        for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2025 08:47:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1763657220; x=1764262020; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yUkejxkwNkJpj7b3XeKPp2fBMSgf3ejNXMmcXfbZUqo=;
        b=D9HPVrU/tux0xufqG17xyQvWqrB3355RO1P9SsHnS01E2upJig2LSuhziJs8n3d7EE
         eieStatmyjiYVbTVnsY9gHf9J8XCKb8GjYpCZqsaCDpohCFyPNO5egIdxlVUjpG+Ww+a
         eY8Q4kz4XqwfTmtSJY91po5u+w7NDdGTNVkqPRfo1YEbH+i38UpR9/08rP90xmZkYNbN
         Gl9QQpSB7rpjT5rLU7QBkwc1RbcuKN0qOhkMB80fRMtDEhrGjsJWt/+yhGZprWEmwOAl
         QKgpO7XToESmJPY3pi6V50BrxQ/iWVuuYGX4oKQcKvpaHFy5Nn8Gyj28G35pfH268UHE
         2Ylg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763657220; x=1764262020;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yUkejxkwNkJpj7b3XeKPp2fBMSgf3ejNXMmcXfbZUqo=;
        b=cnSiZcn/ZRmmLlv8NidPGZRb+4A+hx177G1dhM+EtuFxnXytaUyAe868IDJA4/B97g
         2aWui+YSRpWbv0+WT27BstZBVogLOgkIAArZ470bYvS1rHYhCWj2sGOy1WwxHRmMSGb0
         eBO4JnMqpZ9RjhD/2tB8oTli3rj7rwOfhP7qA2/oeuCBRSCUtvGRux0zWT684TzsoCp0
         cQuFvY4c8gSL5ZVVG67YcBb0e1S6sB6JKruuaJCLm871Hsh3q483h4xPH1IFItsehMvZ
         Wb8EanoZCDwQTwquDWn67ml+IlD2KlFVktUHan7cxIyv25ULmlx9g0KDsFQrt1WDrG/V
         GtvQ==
X-Gm-Message-State: AOJu0Yz7RaHsIVFW6EvJUQfUblEzpDW5Pj7s0L1n1nObMnHOLnhc6m2E
	ItNQYWN4/jONQPGm5J8oHh5Vv378Apj//OSXIAOP2bwk6TYio5xPh6FtYKwZhXoWZYUhJ5zHna5
	PzYJ0QsmKYGytXhDidx2kZT51VdlxiH+7Lgz/EF+gvNkhopYaV/yb4dw=
X-Gm-Gg: ASbGnctbMg2e/yYvFQARsqEEm+CKc2ObTBzrbWzXqnwVRbXj5wpk9YqGZUlCCYTDD5E
	T83KJ52JTQB/rh8KVp5kD4v4vlOx6OnXXzIe4NcnjAX09ya8GEIcGCboxG6LC3REZQsjuoqUfzE
	X1PyKgWeQds4c1HFRch5XfdlVpsqxl8twoBAIom95x6nuU3MgVOVHpBOBb0Bs1M+cmWCGcb6Fgw
	LONh8Hwr41d1EIXruhMV4xrFfn2tv6B4TzRPBrI6av/y4HL32tUF7WCAdZuH/XeQfI/KwnEM+OL
	kxBREMjiM5utzjaqxa4n/aOvgJSBTnIjnfFceBTauvz/LW8IdbbIsJQaRra0x+w=
X-Google-Smtp-Source: AGHT+IFaJDmPn3jLrqjAw8ViGhHjcdOsGWXldDFW7AQIhcOj0YjL/GCL+gibvSih04h8BKua6FQ/1iwP5MYGgI5dwFk=
X-Received: by 2002:a05:6512:31c8:b0:594:25c9:2c6e with SMTP id
 2adb3069b0e04-5969f49a320mr1017303e87.25.1763657219933; Thu, 20 Nov 2025
 08:46:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <yq1lelrleqr.fsf@ca-mkp.ca.oracle.com> <4f9794d2-00ed-22da-2b4b-e8afa424bf17@acm.org>
 <d0ac216445c33e9bf98e8c850f4d900acf0787bd.camel@suse.com> <9545766a-298d-1358-46f0-64ccfaf30ca0@suse.de>
 <6A8AA317-32B0-48F4-82DC-82B65A221A9F@purestorage.com> <083141cd-3b79-7c54-9464-df36c06cc59a@suse.de>
 <AE26D869-2E6A-45A9-8739-CFB65C6C0750@purestorage.com>
In-Reply-To: <AE26D869-2E6A-45A9-8739-CFB65C6C0750@purestorage.com>
From: Brian Bunker <brian@purestorage.com>
Date: Thu, 20 Nov 2025 08:46:48 -0800
X-Gm-Features: AWmQ_bmD-Z1O9ulU5S1BGDfkZdhMg2Mbvt171tQ-EzxXYTJeMoHruA32nVlRtgk
Message-ID: <CAHZQxyJTgw3j-DP-fQOnvhVkwMc2oKEQiF03JZ-uaCK7LtKTqw@mail.gmail.com>
Subject: Re: The PQ=1 saga
To: linux-scsi@vger.kernel.org
Cc: Martin Wilck <mwilck@suse.com>, Bart Van Assche <bvanassche@acm.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello all,

I took another shot at this one. This one I think addresses any
concerns that were brought up:

https://lore.kernel.org/linux-scsi/20251114160213.21243-1-brian@purestorage=
.com/

Thanks,
Brian


On Tue, Jan 31, 2023 at 1:00=E2=80=AFPM Brian Bunker <brian@purestorage.com=
> wrote:
>
>
> > On Jan 30, 2023, at 5:35 AM, Hannes Reinecke <hare@suse.de> wrote:
> >
> > On 1/27/23 20:57, Brian Bunker wrote:
> >> I was doing some more testing of this since it has been a while since =
I
> >> ran these tests. It looks like reverting this will make the particular=
 situation
> >> that I am worried about even worse. I will put the detail in.
> >> With this in place (before you revert it). When SCSI devices are disco=
vered
> >> and some have a PQ=3D1 because they are in an unavailable ALUA state:
> >> Jan 27 12:05:29 localhost kernel: scsi 7:0:0:1: scsi scan: peripheral =
device type of 31, no device added
> >> I don=E2=80=99t know if this intentional with the patch or not but any=
 devices with PQ=3D1
> >> will not create SCSI devices. The logging is deceptive too since the d=
evice type
> >> Is 0 and not 31. In my case I have two paths to LUN 1. One is ALUA AO =
and the
> >> other in ALUA unavailable.
> >> With this patch in I only get an sd device and an sg device for the AO=
 path.
> >> The other path to LUN 1 gets no devices created because it is caught i=
n the
> >> If condition logged above.
> >> Because there are no SCSI devices created, when the ALUA state returns
> >> to an active state, a SCSI rescan, which I can trigger from the target=
 will result
> >> in the devices getting created since the initial scan never created de=
vices.
> >> Jan 27 12:26:04 localhost kernel: scsi 7:0:0:1: scsi scan: INQUIRY pas=
s 1 length 36
> >> Jan 27 12:26:04 localhost kernel: scsi 7:0:0:1: scsi scan: INQUIRY suc=
cessful with code 0x0
> >> Jan 27 12:26:04 localhost kernel: scsi 7:0:0:1: scsi scan: INQUIRY pas=
s 2 length 96
> >> Jan 27 12:26:04 localhost kernel: scsi 7:0:0:1: scsi scan: INQUIRY suc=
cessful with code 0x0
> >> Jan 27 12:26:04 localhost kernel: scsi 7:0:0:1: Direct-Access     PURE=
     FlashArray       8888 PQ: 0 ANSI: 6
> >> Things are good with both paths to LUN 1 showing up. It is not optimal=
 since the
> >> target has to trigger a LUN scan on the initiator affecting all paths =
to those target
> >> ports.
> >> With the revert of this, things are a little different, but the way th=
ey had been in
> >> the past.
> >> Jan 27 13:41:19 localhost kernel: sd 7:0:1:1: Asymmetric access state =
changed
> >> Jan 27 13:41:56 localhost kernel: scsi 7:0:1:1: alua: Detached
> >> Jan 27 13:42:22 localhost kernel: scsi 7:0:1:1: scsi scan: INQUIRY pas=
s 1 length 36
> >> Jan 27 13:42:22 localhost kernel: scsi 7:0:1:1: scsi scan: INQUIRY suc=
cessful with code 0x0
> >> Jan 27 13:42:22 localhost kernel: scsi 7:0:1:1: scsi scan: INQUIRY pas=
s 2 length 96
> >> Jan 27 13:42:22 localhost kernel: scsi 7:0:1:1: scsi scan: INQUIRY suc=
cessful with code 0x0
> >> Jan 27 13:42:22 localhost kernel: scsi 7:0:1:1: Direct-Access     PURE=
     FlashArray       8888 PQ: 1 ANSI: 6
> >> Jan 27 13:42:22 localhost kernel: scsi 7:0:1:1: alua: supports implici=
t TPGS
> >> Jan 27 13:42:22 localhost kernel: scsi 7:0:1:1: alua: device naa.624a9=
370acc31b042de141460001141c port group 0 rel port a
> >> Jan 27 13:42:22 localhost kernel: scsi 7:0:1:1: Attached scsi generic =
sg7 type 0
> >> Now an sg device is created but not an sd device. This means that ther=
e will be
> >> no way for this device to get an sd device created once the ALUA state=
 goes into
> >> an active state.
> >> The same thing done on the target that worked above no longer does:
> >> Jan 27 13:47:48 localhost kernel: scsi 7:0:1:1: scsi scan: device exis=
ts on 7:0:1:1
> >> To get around this, the existing disk must be deleted so it is not cau=
ght in the rescan
> >> check. This cannot be controlled on the target, but it will require ma=
nual intervention
> >> on the initiator.
> >> So the question becomes how should initial scan work when a LUN has a =
PQ=3D1 set.
> >> It is a valid, by spec with ALUA state unavailable but doesn=E2=80=99t=
 seem to be
> >> handled. Why allow an sg device but not an sd one on initial scan in t=
his case? There
> >> are probably many ways to fix this. I think the simplest is to allow s=
d device creation
> >> on LUNs were PQ=3D1, and only restrict PQ=3D3. I am not sure the side =
effect of this on other
> >> targets. The other approach which will no longer work after the revert=
 is to trigger a
> >> rescan from the target. This is sub-optimal since it is disruptive. An=
y approach involving
> >> the ALUA device handler will not help since there is no device to tran=
sition if it is
> >> discovered with PQ=3D1.
> > Sheesh.
> >
> > There _is_ an easy solution for this, and that is to not use PQ=3D1 in =
conjunction with ALUA unavailable :-)
> >
> > Hiding PQ=3D1 devices did serve the purpose for linux as we still canno=
t to a 'real' rescan of a SCSI device; the 'vendor' and 'model' string is p=
retty much fixed for the lifetime of the device, alongside with the entire =
standard inquiry data. So if anything changes here we have to delete the de=
vice before we can properly read it.
> >
> > (which also means that I'll have to retract my earlier comment about th=
is being a good idea ...)
> >
> > And in the absence of that hiding PQ=3D1 devices is the best we can do.
> > The alternative would be to implement a 'real' device rescan; but that =
was too daunting a challenge to be undertaken until now.
> > Things did change in the meantime, so maybe it's time to revisit that.
> >
> > But really, we should ask vendors to _not_ use PQ=3D1 when using ALUA. =
I fail to see the benefit of this as both have roughly the same meaning; if=
 you have ALUA unavailable you can't access the device, hence it's complete=
ly irrelevant what PQ says. And same for the other way round: if PQ=3D1 is =
set really the only ALUA state which makes sense is 'unavailable'.
> >
> > Sadly it's not so easy to fix things up in the SCSI stack, as the PQ se=
tting is evaluated during scanning, and the ALUA state way back later.
> >
> > Cheers,
> >
> > Hannes
> What about something like this? This will remove the device if the PQ=3D1=
 and re-discover it. If the TPG
> remains unavailable, it will just be created in the same way. If the TPG =
has moved to an active state
> the newly created device will be an available sd device. This way at leas=
t target vendors can cause
> the initiator to rescan and get the devices from unavailable to an active=
 state without the manual
> Intervention on each host having to remove the devices with the PQ=3D1 se=
t and rescan manually.
> If the manual removal of devices is required, it does make ALUA unavailab=
le unrealistic.
>
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index f9b18fdc7b3c..9ff9ca1b963e 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1123,6 +1123,36 @@ static unsigned char *scsi_inq_str(unsigned char *=
buf, unsigned char *inq,
>  }
>  #endif
>
> +/**
> + * scsi_remove_offline_device - remove the device if the criteria met
> + * * @sdev:    scsi_device to check
> + *
> + * Description:
> + * A SCSI device which is part of a TPG in the unavailable state will
> + * have the PQ=3D1. If the device is discovered this way, there is no
> + * way for it to transition to an active state. The device must be
> + * removed and rediscovered during rescan in the event that the TPG
> + * has transitioned to an active state.
> + *
> + * Return:
> + * true: the conditions are met for device removal
> + * false: the conditions are not met
> + **/
> +static bool scsi_remove_offline_device(struct scsi_device *sdev)
> +{
> +       if (sdev =3D=3D NULL || sdev->handler =3D=3D NULL)
> +               return false;
> +
> +       if (sdev->inq_periph_qual =3D=3D SCSI_INQ_PQ_NOT_CON &&
> +           (strncmp(sdev->handler->name, "alua", 4) =3D=3D 0)) {
> +               SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
> +                                 "scsi scan: discovered not accessible %=
s\n",
> +                                 dev_name(&sdev->sdev_gendev)));
> +               return true;
> +       }
> +       return false;
> +}
> +
>  /**
>   * scsi_probe_and_add_lun - probe a LUN, if a LUN is found add it
>   * @starget:   pointer to target device structure
> @@ -1161,6 +1191,10 @@ static int scsi_probe_and_add_lun(struct scsi_targ=
et *starget,
>          * host adapter calls into here with rescan =3D=3D 0.
>          */
>         sdev =3D scsi_device_lookup_by_target(starget, lun);
> +       if (scsi_remove_offline_device(sdev)) {
> +               __scsi_remove_device(sdev);
> +               sdev =3D NULL;
> +       }
>         if (sdev) {
>                 if (rescan !=3D SCSI_SCAN_INITIAL || !scsi_device_created=
(sdev)) {
>                         SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
>
> Thanks,
> Brian
>
>


--
Brian Bunker
PURE Storage, Inc.
brian@purestorage.com
