Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1A5253951
	for <linux-scsi@vger.kernel.org>; Mon, 13 Oct 2025 12:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760358161; cv=none; b=bEAykkre3g1W9bPEh66hOVlnsGwBNAlIKITsdbFt8jCSYBr49Dve4SOLLXaYusTmGJBS0Rrh2ZSmI1FmxQwEJq7NhboNjlbVc8j49IL0WR9fcR8tITSuoBCFMDQcyq1a14zBxBHc44spMgiu8qC6yQz4MNhPf8kQRaYVAylBsSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760358161; c=relaxed/simple;
	bh=JEEN7l5OkeehFLiZUEvyupoTz1eaKnAjMCWZiLK9Ih4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rGZjnaSObOPxN5hPru+vFOAMWTm868G266+liG451trob8U6lBIk69TKbt8Y9ycdF1eptev8Dt4DTce1JhnSYTs3KPe7OW45Pdc/TciASz0D2uOalvb5ceHSs2D3ODmgBlCwxoS0hqbRowpzBN1K9MWw4VNQ16egg/vYe3v8z4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NM08LBS3; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NM08LBS3"
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-43f7e0494ecso2441626b6e.3
        for <linux-scsi@vger.kernel.org>; Mon, 13 Oct 2025 05:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760358158; x=1760962958; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ckdYgWLf7VpMshdwBHgpN9kuuhu3Zm0WzeZ4ZRa+ctc=;
        b=NM08LBS3P8vvoiHLBCutnXDx2tQU/EgRFw2KKTWE9rFl5QN7gzoxH6YbTcjN1mdjUL
         7Cr0uICvcv6S9/SYR1J9294R7ihHm7SAtHrOfw3rCSWVBIa7BCfZyHLS6QytMb1VYGS/
         ZnZBrBzRep4CG0s9lwDdrxHCsAm0WI3d596pV9hHmt460Sfu9Vi97dXlKOKlDirVFZwE
         tW4HNSBikaZhMzDVAwHb8kiIbJi6GJJH0b7y2QiGyB8bYRwzUP1eaT1I85iTaleFzHWk
         z6JXhFD+oCg5L4yj1YdBSh8uRsfIxy2jtE3NH3M6JTY5Q6z08+9NJ75OBdrjau9W2Ag4
         nMKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760358158; x=1760962958;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ckdYgWLf7VpMshdwBHgpN9kuuhu3Zm0WzeZ4ZRa+ctc=;
        b=uzzqbANGibAFqBu76iUM0PXVL0FVrKuKkhRTFTiumOHaJFVwbjEF/dyv5OfKQ3PlaB
         avtrkFw5mSiAWpnsJbbAS0eJ16bEJiMixMXbHpEDEpqt05ZS2JqSRggxImxZZsDjpFdj
         /HTfbCQmnt8/6O7f6TobfuOEDRfp4ubfYa3IO22WBydOGsENxEsEdoZTy2Ao/V/oruR0
         Tu8FbTAwA/A4UHJ/DRRxaEc+HbCui5nTNAvHhVCOQx5encWNoLeooaK4HHDWmUEYGS57
         GJIRc7OTt1AqB8n2YW3rB9K+QO4VPwJXt3SwGsvoQysgSCIOA7xHIAtdccH9Skh8WC3J
         0zYQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQz5t6HvI2iostGFWVPWAuP15/KpdO9eM0rbqFdM46HlkjSb2A8nxCapKW4J85+5xBlJ8A1UudzQUH@vger.kernel.org
X-Gm-Message-State: AOJu0YyBukEmBRaiHX+B1hsIt/LWOrjYrU7GOCtffErlMrXARj/tbHF2
	CYi7e+beJvARqasRUJMOTWxzYdQ1vJS1qtJA6yegOZwmAVSpFeeqME2G4UR9/hMiiSA1lbWP1ds
	W9ppQSf15HUzKTcDK3dy2C/+pp1ZuenDqTz22ExPyCg==
X-Gm-Gg: ASbGncuTNdn/ta+puBK1PZ/NMitM1EEbdM7inw9NdGqkbgRbyaZceds9aQuOhHE+tt7
	LUkYqpy0fgN7VRjEmRAlzeB2Ls3dKEsR1Bb0Y12OnRP5Ztmg9yMLi3f2Xe9IZiG6hcnqhKwJ2mL
	FUh3CiEsgsUfzeRsVTVlL87KnHlfpPU11nF3DGma4eaN+9/kc2QdLfjPplC/mhHXPYmxp8IVHpT
	WeBoOnj5Mnjt3AU+YsCH2JuUogg
X-Google-Smtp-Source: AGHT+IEoQBCqLH2ozdoVH1sRcw07pPQAKVgvNijfvoDm483d6lTz9yEb87u/4psYc3vMcbxKtwk9tX7qFa/t5Bfgqog=
X-Received: by 2002:a05:6808:2120:b0:43f:1c66:bbab with SMTP id
 5614622812f47-4417b48080amr9203732b6e.47.1760358158056; Mon, 13 Oct 2025
 05:22:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251001060805.26462-1-beanhuo@iokpp.de> <20251001060805.26462-4-beanhuo@iokpp.de>
 <CAHUa44HA0uoXbkKgyvF4Rb9OJa1Qj-Wh7QAmQxXYAf3grLdktw@mail.gmail.com>
 <893731e9c8e4e74bb0d967ab2e7039e862896dc5.camel@gmail.com>
 <CAHUa44HdV8FJMayVg6TFz7oGZc1b6QntxMsUN8mdTV7pm7vkKQ@mail.gmail.com> <a040353e95a67dc3bde09b5f3866aa628150c9db.camel@gmail.com>
In-Reply-To: <a040353e95a67dc3bde09b5f3866aa628150c9db.camel@gmail.com>
From: Jens Wiklander <jens.wiklander@linaro.org>
Date: Mon, 13 Oct 2025 14:22:26 +0200
X-Gm-Features: AS18NWBUqqhs4ywfNiDQRHxZL7fNzXhVoY3zu19jmmL8xI5PDTBl5irSqdAZHmo
Message-ID: <CAHUa44HYNgiRU5yOrVq8gBwHEEAxGz6TyT0PrBpVOiFfKxYhOQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] scsi: ufs: core: Add OP-TEE based RPMB driver for
 UFS devices
To: Bean Huo <huobean@gmail.com>
Cc: avri.altman@wdc.com, bvanassche@acm.org, alim.akhtar@samsung.com, 
	jejb@linux.ibm.com, martin.petersen@oracle.com, can.guo@oss.qualcomm.com, 
	ulf.hansson@linaro.org, beanhuo@micron.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, beanhuo@iokpp.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 13, 2025 at 2:04=E2=80=AFPM Bean Huo <huobean@gmail.com> wrote:
>
> On Mon, 2025-10-13 at 10:21 +0200, Jens Wiklander wrote:
> > Hi Bean,
> >
> >
> >
> > On Wed, Oct 8, 2025 at 5:07=E2=80=AFPM Bean Huo <huobean@gmail.com> wro=
te:
> > >
> > > Jens,
> > >
> > > I incorporated your suggestions in my v3 excpet these two:
> > >
> > >
> > > On Wed, 2025-10-01 at 09:50 +0200, Jens Wiklander wrote:
> > > > > diff --git a/drivers/ufs/core/Makefile b/drivers/ufs/core/Makefil=
e
> > > > > index cf820fa09a04..51e1867e524e 100644
> > > > > --- a/drivers/ufs/core/Makefile
> > > > > +++ b/drivers/ufs/core/Makefile
> > > > > @@ -2,6 +2,7 @@
> > > > >
> > > > >   obj-$(CONFIG_SCSI_UFSHCD)              +=3D ufshcd-core.o
> > > > >   ufshcd-core-y                          +=3D ufshcd.o ufs-sysfs.=
o ufs-
> > > > > mcq.o
> > > > > +ufshcd-core-$(CONFIG_RPMB)             +=3D ufs-rpmb.o
> > > >
> > > > SCSI_UFSHCD might need the same trick ("depends on RPMB || !RPMB") =
in
> > > > Kconfig as we have for MMC_BLOCK.
> > > >
> > > > >
> > > When RPMB=3Dm and SCSI_UFSHCD=3Dy, the ufs-rpmb.o is compiled into th=
e built-in
> > > ufshcd-core, ufs-rpmb.c calls functions from the OP-TEE RPMB subsyste=
m
> > > module,
> > > The kernel allows built-in code to reference module symbols (they bec=
ome
> > > runtime
> > > dependencies, not link-time), please check, I tested.
> > >
> > > > >
> > > > >
> > > >
> > > > > +
> > > > > +       struct rpmb_descr descr =3D {
> > > > > +               .type =3D RPMB_TYPE_UFS,
> > > >
> > > > We'll need another type if the device uses the extended RPMB frame
> > > > format. How about you clarify this, where RPMB_TYPE_UFS is defined =
to
> > > > avoid confusion?
> > >
> > > As ufs-bsg.c, we could use ARPMB_TYPE_UFS for UFS advanced RPMB frame=
, if it
> > > is
> > > RPMB, we take it as normal RPMB, the frame should be the same as MMC =
RPMB.
> >
> > Isn't it a bit confusing to set the type to RPMB_TYPE_EMMC when it's
> > actually a UFS RPMB, even if it's supposedly compatible enough?
> >
>
> The RPMB data format is the same for both eMMC RPMB and standard UFS RPMB=
.
> However, the application commands used to access RPMB differ =E2=80=94 eM=
MC uses MMC
> commands, while UFS uses SCSI commands.
>
> Additionally, UFS RPMB supports more RPMB operations than eMMC RPMB. Ther=
efore,
> we need to distinguish between them:
>
> RPMB_TYPE_EMMC for eMMC RPMB
>
> RPMB_TYPE_UFS for standard UFS RPMB
>
> ARPMB_TYPE_UFS for advanced UFS RPMB.

Good. A distinction was what I was asking for.

>
>
> > While the frame format works, I'm concerned about the CID. It's
> > essentially a namespace of its own for eMMC, and at least the OP-TEE
> > implementation makes assumptions about the format by masking out the
> > PRV (Product Revision) and CRC (CRC7 checksum) fields from the CID
> > when deriving the RPMB key. For this to work reliably, the CID must be
> > guaranteed to be unique per RPMB device.
> >
> > From what I understand, for UFS, the serial number is only guaranteed
> > to be unique if the manufacturer and the product name are taken into
> > account. Combined, these fields can be much larger than 16 bytes, and
> > we also have the partition number to consider.
> >
> > By using RPMB_TYPE_UFS we can define a device ID tailored for UFS with
> > all the fields we need. Thoughts?
> >
>
> For certain memory vendors, the serial number is guaranteed to be unique =
among
> all devices.

This is supposed to be generic and not rely on the behavior of only
some vendors.

>
> For partitions or regions, we have appended the region number to the end =
of the
> CID =E2=80=94 please check the patch for details.

Yes, but how do you know that you don't overwrite a part of the serial numb=
er?

>
> Regarding improving CID uniqueness, we could include the OEM ID or produc=
t
> number. However, this would make the CID longer than 16 bytes.

UFS doesn't have a CID, but there's no need for one either. struct
rpmb_descr has dev_id and dev_id_len. It can be any length, within
reason.

Cheers,
Jens

>
>
>
> Kind regards,
> Bean
>
> > Cheers,
> > Jens
>
