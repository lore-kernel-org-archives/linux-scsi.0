Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9AC92EAD10
	for <linux-scsi@vger.kernel.org>; Mon, 13 Oct 2025 08:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760343723; cv=none; b=mOAyYrJqQUjPT8GprEju9dM+o2zsY4ES5DTdkYwlWGllr9H7h47dbpF55CbMa6elKqG9x0AOayr8tOXc1EkN9U3/RIuOSXCQijmc1iWcAuF3IUfDqDRDZRp5SgNYSwuMQmK6FMuRuUtTeVSD7N15qGHVNu2T0RyKMU9gKEKe1pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760343723; c=relaxed/simple;
	bh=eAD0+1vST5dCT18sRVdP+XYndG11q3exTERbaeCwb7E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lxHEORKwvlOYZYdoeTmPgRp1qtLsXDIuvIQPrApqeSAa5jyF/QV/sOTfX7oJNSMkveB6d53H3yDjQMX6hLmJ9u4+gP9nq7io8cn3oKa8Ta4JV2GHL4SGMZyBSSDk3DCazpZXZM9PMGbJ/Mj9xqs1AhoZ3lTpQ5vdKHckLst/da0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=N+0q9GZl; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="N+0q9GZl"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7c0e8367d4eso1540426a34.1
        for <linux-scsi@vger.kernel.org>; Mon, 13 Oct 2025 01:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760343719; x=1760948519; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PfkSUSbV0vhiMznuifIKRudfUsRdigA3bUiVnoZZFkE=;
        b=N+0q9GZlzcMVOGl75nNjmjutZV2g/nlm+9VFV+F0o/j2FXrsbNnURWXIZfSQfviX8b
         bWoy84Eg7iyUjrjJ0OsNJfsHGZu6PVzaIJNtdj46rVDpQFcR+AZRp2Jgw+F0UdCg6fpY
         N3Dx///YF9zpELfn3r+VBimlK1KotkddrDXGOOBk+yYFBjh3HYEuSyhpTKW8nmLpw4g1
         L6ZjSCovrL+89Gbr7uEl9gNBeguSo5zT1SDjfCoYpESKTV+4LV3ylQp0eVvBvQEN0Uje
         KOIH6UUY8mVBXWmJna481IN5SLSne6Fb19CBGTslN3j7NYUSWNH+5hEGLQiZvcdEnt8/
         V0Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760343719; x=1760948519;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PfkSUSbV0vhiMznuifIKRudfUsRdigA3bUiVnoZZFkE=;
        b=G1aqdm847RfMR6UduxdEf53qP5RftHyigMZ7TRU/JGbB+Qhvag3X+ALuM97TPqOa0b
         RxhDRcTuum+xBiTuFUTcY+5flSeVNTIejiscBd/9HYAeH4XXkEWvhNrAt5tR/0rsqet1
         36ww9uHpOR+BfmHLuYcg/reX7ZP769lIkNHnIdqyIFiV5dNi7guzists0PyGmkZQy085
         iUamXS0N0g1QSvJ1RXAx+sAitat5tME/DBiug7UtCjsBmJk8kcQqZsbOtHF9Io8L+IcQ
         rTU09MlfvpWI9MhzRsFeOSE39eRYubkPPGEt7w537BDmA6TenxY/bik1f44OkbpebyIh
         R+5A==
X-Forwarded-Encrypted: i=1; AJvYcCWQQ7UukqxF1hq744hs6f12nyV1Z7Fzu01b2s5TU8YdSSuT7DTuz5v7fJ+KHXZD2f3jmv/4dhe28jgn@vger.kernel.org
X-Gm-Message-State: AOJu0Yxp9Xpm05TOlzWk9MaIG6L8WL83XzdrcXwxzbcVfMHpgmU3vsPs
	LOt0CDoSo49ds2YjgXBY7s5jdzm23IHlxLDjrP+aF/J+O2eKZpdQaxqzXwoLm1/FF7laG40KnoV
	ZVTd2dauCwnBwNtZDqOLGlJQxCtXClBZA8+EAk8N0Wg==
X-Gm-Gg: ASbGnct6jQc4HnOIND3E9V7N+LGjNJ06o5YGAJvhj0RuBWZ0inNOQm79d177XM8VgRq
	yNHe/EtfHh6cHmqufVKgl0Po+ksrnfm/IvQ3gWKupXeCOORfvElpLhfdNkTwwFV73fGOxj8FP6w
	MhbyaVWR7VsIjGA9Pg9GFbtlQUF0JssjK4Gitsj7f+zlsXK/ijwK3bznEsoUqgCRC4xdFL+XLeg
	8frrvTnHkr0Nwy29E1aK4KoYbMX
X-Google-Smtp-Source: AGHT+IHbBJMX3XQXIUnh0eL9Gqqi1OX8ycJZAvF31um7+RQ7SUC6Nq+yI9wt5/rT+c82tvoUj+Wt+PHgwJvmIyZts1I=
X-Received: by 2002:a05:6808:50a0:b0:43f:713c:a38e with SMTP id
 5614622812f47-4417b393963mr8040987b6e.30.1760343719075; Mon, 13 Oct 2025
 01:21:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251001060805.26462-1-beanhuo@iokpp.de> <20251001060805.26462-4-beanhuo@iokpp.de>
 <CAHUa44HA0uoXbkKgyvF4Rb9OJa1Qj-Wh7QAmQxXYAf3grLdktw@mail.gmail.com> <893731e9c8e4e74bb0d967ab2e7039e862896dc5.camel@gmail.com>
In-Reply-To: <893731e9c8e4e74bb0d967ab2e7039e862896dc5.camel@gmail.com>
From: Jens Wiklander <jens.wiklander@linaro.org>
Date: Mon, 13 Oct 2025 10:21:47 +0200
X-Gm-Features: AS18NWDSwHNWbhvfTfZVBBArRE_Meet5w9zINg4FG3XlfoXhTtWNhOWUG_vlJ4s
Message-ID: <CAHUa44HdV8FJMayVg6TFz7oGZc1b6QntxMsUN8mdTV7pm7vkKQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] scsi: ufs: core: Add OP-TEE based RPMB driver for
 UFS devices
To: Bean Huo <huobean@gmail.com>
Cc: avri.altman@wdc.com, bvanassche@acm.org, alim.akhtar@samsung.com, 
	jejb@linux.ibm.com, martin.petersen@oracle.com, can.guo@oss.qualcomm.com, 
	ulf.hansson@linaro.org, beanhuo@micron.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Bean,



On Wed, Oct 8, 2025 at 5:07=E2=80=AFPM Bean Huo <huobean@gmail.com> wrote:
>
> Jens,
>
> I incorporated your suggestions in my v3 excpet these two:
>
>
> On Wed, 2025-10-01 at 09:50 +0200, Jens Wiklander wrote:
> > > diff --git a/drivers/ufs/core/Makefile b/drivers/ufs/core/Makefile
> > > index cf820fa09a04..51e1867e524e 100644
> > > --- a/drivers/ufs/core/Makefile
> > > +++ b/drivers/ufs/core/Makefile
> > > @@ -2,6 +2,7 @@
> > >
> > >   obj-$(CONFIG_SCSI_UFSHCD)              +=3D ufshcd-core.o
> > >   ufshcd-core-y                          +=3D ufshcd.o ufs-sysfs.o uf=
s-mcq.o
> > > +ufshcd-core-$(CONFIG_RPMB)             +=3D ufs-rpmb.o
> >
> > SCSI_UFSHCD might need the same trick ("depends on RPMB || !RPMB") in
> > Kconfig as we have for MMC_BLOCK.
> >
> > >
> When RPMB=3Dm and SCSI_UFSHCD=3Dy, the ufs-rpmb.o is compiled into the bu=
ilt-in
> ufshcd-core, ufs-rpmb.c calls functions from the OP-TEE RPMB subsystem mo=
dule,
> The kernel allows built-in code to reference module symbols (they become =
runtime
> dependencies, not link-time), please check, I tested.
>
> > >
> > >
> >
> > > +
> > > +       struct rpmb_descr descr =3D {
> > > +               .type =3D RPMB_TYPE_UFS,
> >
> > We'll need another type if the device uses the extended RPMB frame
> > format. How about you clarify this, where RPMB_TYPE_UFS is defined to
> > avoid confusion?
>
> As ufs-bsg.c, we could use ARPMB_TYPE_UFS for UFS advanced RPMB frame, if=
 it is
> RPMB, we take it as normal RPMB, the frame should be the same as MMC RPMB=
.

Isn't it a bit confusing to set the type to RPMB_TYPE_EMMC when it's
actually a UFS RPMB, even if it's supposedly compatible enough?

While the frame format works, I'm concerned about the CID. It's
essentially a namespace of its own for eMMC, and at least the OP-TEE
implementation makes assumptions about the format by masking out the
PRV (Product Revision) and CRC (CRC7 checksum) fields from the CID
when deriving the RPMB key. For this to work reliably, the CID must be
guaranteed to be unique per RPMB device.

From what I understand, for UFS, the serial number is only guaranteed
to be unique if the manufacturer and the product name are taken into
account. Combined, these fields can be much larger than 16 bytes, and
we also have the partition number to consider.

By using RPMB_TYPE_UFS we can define a device ID tailored for UFS with
all the fields we need. Thoughts?

Cheers,
Jens
