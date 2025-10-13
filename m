Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A0326AA94
	for <linux-scsi@vger.kernel.org>; Mon, 13 Oct 2025 12:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760357069; cv=none; b=VIggIpMrodd8saGWHIF6YsEhKdumROZKvdIeMVW9Z5MW8rWCfdB6MJvSW7DZZClh2ehVX2Rf8pw8IOuJbGgmuTumuhTnMc1+R7JYIYNsEjlN9lW8DYGsUvgHvBF8e4MTTc4Eg3fzl+WQFNcSgkyrKYhWUnBTCbwqVyPp4tUGbfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760357069; c=relaxed/simple;
	bh=v0K7ZywmUV5QPqpo9PzmGZDpDzdU4ARzvGPKzS4ALQA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KEJ9yGFmC4jVPI5U9LTS/5WRoih4uKAOMRWQ76UUx9BWPseeMoq85pwMD8daYFNtG6m8zKLAyqCaXcGZhIsCfMW15TTurwDzcvqlrAlebS/LNd345RgVyj+oayom9RemBCNBQLVOmI8a/HfMVufdUco5RlluZv1tbZasGMay/HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ib10ocHX; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ib10ocHX"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-63b6dfd85d4so3892828a12.1
        for <linux-scsi@vger.kernel.org>; Mon, 13 Oct 2025 05:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760357065; x=1760961865; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=v0K7ZywmUV5QPqpo9PzmGZDpDzdU4ARzvGPKzS4ALQA=;
        b=ib10ocHXNAUd49IJ+pYY1Wr4U1uO/ei8wkUJy2x5Ym7VKzQNKt809vfB6zZDw0Vm4x
         cfurXlej5nSJ3fllpKwrKtVk3x+itXwjSBxw8byUZjoBfeiPb9xL9vLRWvz6zMe5plC2
         DdurUTE+UNx/JKgxh77erasZX6frUaeVsK+WwOTFvwRInGNisd4335yrorNWvoW4sQ7q
         Z9yMySHqeTy3asbbCt25+14NBQcKa69F0NS6x4ZyfmRRHMTNohWTSoS+vtYMGJf/+Xbw
         gvUQLnhh1T22yasT/IM5AfkjKRihoAj7fHh2P6a0fF+N0wIUU/kYmInevI/BB3iSR0Y/
         6dFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760357065; x=1760961865;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v0K7ZywmUV5QPqpo9PzmGZDpDzdU4ARzvGPKzS4ALQA=;
        b=cUSIPzjPiqejFN5Qu1FFdOneic8bJSPrBQWGJEBkmMUcCHMCmN0xGwQ19noNbWQ2Um
         J3A/6vnbzSun1sdC9s5Y85khaAOYK4T3aiCQZXHOEQSkHl9nCnYSuK4v0ZoF01l7PXxX
         0cMtJZ8EwCvvTtkvJze2DPPMG6LW0eZlxsPt8ZbarNNuKg5jQIVKRHVlAJzVeFSvn1xD
         3YYQlCDYfDP5LDCaA0ehGHe2/WCyUXwyIFaLhb3C7DVWQblZx+5e9XW5kscFV1pGWfaW
         kLrdd/NyTbVnhrUSUsKxGtrPB4F37BNxdOyuvOxRkmhZd/r8tSApO0ApNuQYKHsYropg
         NmAw==
X-Forwarded-Encrypted: i=1; AJvYcCWgehePA1tEcr1caVEpwL3OjBNtn893y+haC/9yZFGDH05t3oh3I8VX0wIgqLsDTD7OVf6P5gdsqs3Z@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/3oPLbYjUymtSWXvfNoGue8y/+n+zXY6BLwVLmEz3uxUbFpd+
	olWqlsK+Nw7DurxFQF6+V6CwFl+DpWr0k48IEan0orxXMo0PhXRyQ6rc
X-Gm-Gg: ASbGncv3sP4uGS6bUlaRorwWHOgzxgo7+53Ta64DG54O1OUgfGh9X8rJJV+dsBlvDiC
	cSf7XHejp4GGlCQZUNd9NlMlUXE8UQ8PS1484DZwODVYlfpBp4l0um1drq4kRkvWXqro8W6wPdc
	klR+E6VyoBn8523uor503Ncl4d7N7xEktY611kEBcGFI3fZB2zxY+L6zp5HpidgYJmsTmoOGOKu
	VAAb05gHe3+bXSc/Y99CrXol+HE9f/eFsGFdBZ0WVkPsYnRlXGvBiYmpjBmdkpvLKBjjsLu9z5S
	VYWnzQT3NszV4L7LsafGCNBbgFFwmbnmWoknusQL9Km/Yka4G5RSWUSSyNVmd68wEjWlTEWw75Q
	j3wvZdOzSJ4IIWHF0M7UcCUgcw8NO3ZdGqyhGqUJdmD0EUW4zM9dP2kk=
X-Google-Smtp-Source: AGHT+IEwlwnayx0gzu14dd9W3bXJDuF7IW9hSKpZxRxRk5DSh9CB/z4CK6mSYE7XddK8vBzlO98UIQ==
X-Received: by 2002:a17:907:7f0e:b0:b3f:33f6:fb57 with SMTP id a640c23a62f3a-b50a9d59a3bmr1974300466b.9.1760357065125;
        Mon, 13 Oct 2025 05:04:25 -0700 (PDT)
Received: from [10.176.235.211] ([137.201.254.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b55d8c124a8sm913666766b.51.2025.10.13.05.04.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 05:04:24 -0700 (PDT)
Message-ID: <a040353e95a67dc3bde09b5f3866aa628150c9db.camel@gmail.com>
Subject: Re: [PATCH v2 3/3] scsi: ufs: core: Add OP-TEE based RPMB driver
 for UFS devices
From: Bean Huo <huobean@gmail.com>
To: Jens Wiklander <jens.wiklander@linaro.org>
Cc: avri.altman@wdc.com, bvanassche@acm.org, alim.akhtar@samsung.com, 
	jejb@linux.ibm.com, martin.petersen@oracle.com, can.guo@oss.qualcomm.com, 
	ulf.hansson@linaro.org, beanhuo@micron.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, beanhuo@iokpp.de
Date: Mon, 13 Oct 2025 14:04:23 +0200
In-Reply-To: <CAHUa44HdV8FJMayVg6TFz7oGZc1b6QntxMsUN8mdTV7pm7vkKQ@mail.gmail.com>
References: <20251001060805.26462-1-beanhuo@iokpp.de>
	 <20251001060805.26462-4-beanhuo@iokpp.de>
	 <CAHUa44HA0uoXbkKgyvF4Rb9OJa1Qj-Wh7QAmQxXYAf3grLdktw@mail.gmail.com>
	 <893731e9c8e4e74bb0d967ab2e7039e862896dc5.camel@gmail.com>
	 <CAHUa44HdV8FJMayVg6TFz7oGZc1b6QntxMsUN8mdTV7pm7vkKQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2025-10-13 at 10:21 +0200, Jens Wiklander wrote:
> Hi Bean,
>=20
>=20
>=20
> On Wed, Oct 8, 2025 at 5:07=E2=80=AFPM Bean Huo <huobean@gmail.com> wrote=
:
> >=20
> > Jens,
> >=20
> > I incorporated your suggestions in my v3 excpet these two:
> >=20
> >=20
> > On Wed, 2025-10-01 at 09:50 +0200, Jens Wiklander wrote:
> > > > diff --git a/drivers/ufs/core/Makefile b/drivers/ufs/core/Makefile
> > > > index cf820fa09a04..51e1867e524e 100644
> > > > --- a/drivers/ufs/core/Makefile
> > > > +++ b/drivers/ufs/core/Makefile
> > > > @@ -2,6 +2,7 @@
> > > >=20
> > > > =C2=A0 obj-$(CONFIG_SCSI_UFSHCD)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 +=3D ufshcd-core.o
> > > > =C2=A0 ufshcd-core-y=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 +=3D ufshcd.o ufs-sysfs.o ufs-
> > > > mcq.o
> > > > +ufshcd-core-$(CONFIG_RPMB)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 +=3D ufs-rpmb.o
> > >=20
> > > SCSI_UFSHCD might need the same trick ("depends on RPMB || !RPMB") in
> > > Kconfig as we have for MMC_BLOCK.
> > >=20
> > > >=20
> > When RPMB=3Dm and SCSI_UFSHCD=3Dy, the ufs-rpmb.o is compiled into the =
built-in
> > ufshcd-core, ufs-rpmb.c calls functions from the OP-TEE RPMB subsystem
> > module,
> > The kernel allows built-in code to reference module symbols (they becom=
e
> > runtime
> > dependencies, not link-time), please check, I tested.
> >=20
> > > >=20
> > > >=20
> > >=20
> > > > +
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct rpmb_descr descr =3D {
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 .type =3D RPMB_TYPE_UFS,
> > >=20
> > > We'll need another type if the device uses the extended RPMB frame
> > > format. How about you clarify this, where RPMB_TYPE_UFS is defined to
> > > avoid confusion?
> >=20
> > As ufs-bsg.c, we could use ARPMB_TYPE_UFS for UFS advanced RPMB frame, =
if it
> > is
> > RPMB, we take it as normal RPMB, the frame should be the same as MMC RP=
MB.
>=20
> Isn't it a bit confusing to set the type to RPMB_TYPE_EMMC when it's
> actually a UFS RPMB, even if it's supposedly compatible enough?
>=20

The RPMB data format is the same for both eMMC RPMB and standard UFS RPMB.
However, the application commands used to access RPMB differ =E2=80=94 eMMC=
 uses MMC
commands, while UFS uses SCSI commands.

Additionally, UFS RPMB supports more RPMB operations than eMMC RPMB. Theref=
ore,
we need to distinguish between them:

RPMB_TYPE_EMMC for eMMC RPMB

RPMB_TYPE_UFS for standard UFS RPMB

ARPMB_TYPE_UFS for advanced UFS RPMB.


> While the frame format works, I'm concerned about the CID. It's
> essentially a namespace of its own for eMMC, and at least the OP-TEE
> implementation makes assumptions about the format by masking out the
> PRV (Product Revision) and CRC (CRC7 checksum) fields from the CID
> when deriving the RPMB key. For this to work reliably, the CID must be
> guaranteed to be unique per RPMB device.
>=20
> From what I understand, for UFS, the serial number is only guaranteed
> to be unique if the manufacturer and the product name are taken into
> account. Combined, these fields can be much larger than 16 bytes, and
> we also have the partition number to consider.
>=20
> By using RPMB_TYPE_UFS we can define a device ID tailored for UFS with
> all the fields we need. Thoughts?
>=20

For certain memory vendors, the serial number is guaranteed to be unique am=
ong
all devices.

For partitions or regions, we have appended the region number to the end of=
 the
CID =E2=80=94 please check the patch for details.

Regarding improving CID uniqueness, we could include the OEM ID or product
number. However, this would make the CID longer than 16 bytes.



Kind regards,
Bean

> Cheers,
> Jens

