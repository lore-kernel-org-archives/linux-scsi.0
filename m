Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D39502BE;
	Sun, 24 Aug 2025 16:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756052992; cv=none; b=SPn55XKZczBF9ULZL0YWGtENC4O63fRT1j2gHlgaGESvVWePtCvZTnTTP69qjQQ4KaAZjC824KAuoMOQyYpC1PeYKsJFBDOU4TdFzaYw6Ddlyn4h9fF45IORBPJ6VsimFpdQs122L9NbSKzfIY6/Lt4E65BTsqCPlGXPaRDXExo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756052992; c=relaxed/simple;
	bh=GwblYkjIF3a3rwnEjGgJECFQlwi4NNCUtP3wZm0JZvc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lIlBDqxxnSZ6oGReVh0fUIQZ7u7YmvIu0q8ZVlAESdPh7GFZeo7MaRpdMJ5aJsblEAD1vgRAvTczeM/77QhGo5C+UoU8AN8xsAMEVDlrAAu+CeaEsmI6kg6RvfiE4/hN/KTUdD01kvVa3VGSS2A77R+no9XdnwPQ0Cm3bZ5NSrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XNyAlLje; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XNyAlLje"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-76e4fc419a9so3137198b3a.0;
        Sun, 24 Aug 2025 09:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756052990; x=1756657790; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ll0rRDyIMVOuxXRn1R6gkhLsmIEuFCm0SjhVkwDDDpo=;
        b=XNyAlLjeKfFZwjMtS+m+YFYstQphOdmd5SSqCJ4zTe/RWIW9V9XNca5b8e9Tz+q9NH
         9tHT28kHYxEYD0RoEjbFiFrZRUzcVwdUlTvDL5BadFSibPqrPSDX2FgsqiEaTZs69tuX
         tATYgcc1ksIHAtGaSwQgaFpWDrhKK34deSAVmM+xAKZrW2SdkkarduB6cVTdcZX5Kyvh
         FuIVJVFppaLHk3SAOOP8JP/ljOsNSdugRW5zGeHRbXSsyroKr4IkeX6IkmEaJZPMdgTn
         zPL40Vvr6gk7Mr1h35vwgyFe/mWrVRRAXTp40ktDvJjI30MHpKk+MF9rG1UrtN+fUJPs
         dSag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756052990; x=1756657790;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ll0rRDyIMVOuxXRn1R6gkhLsmIEuFCm0SjhVkwDDDpo=;
        b=ZNiyZH+fmesPfvXHLCjW2sFxGBDC9qoNyMDJPpDyt7OUG4j9u+YnRnUA18mUrfPH0l
         ZVoA82Fsth+8dkP5Z9H2EYYXKiV8toaolKapZtdLB2kKLQzQ4tYCiCeo1jss57kRmjDB
         5uXUjBsKw5gfkom51qwOUlUK0nC4djh8W6km2z7NkwD7lJXjdea8EKnPdQNRXiU/+rzk
         LEw+oMoKnoBPdhNVx66ztGx4wgajdJZPkPNpDAJwGwYZqYBvYfT7QvXNWOmppEGdX8+k
         CVJ3KNCsJJWZImN5pyvruX2Y3COOmTeiRnC7HOX943cS0GaBVLjQ1eOajoHBibmrGRbv
         Y9oA==
X-Forwarded-Encrypted: i=1; AJvYcCWu7M6yDKC79sMmJ8idwM6ZER5lR6t7d7slnoIjUM//3DERHeg3B2ORVskZMbscFiW3Sz1cas9y5Ow6FOo=@vger.kernel.org, AJvYcCXmYyfc8SqBI7lNRBt6zpjIXXlWBKvKKpEEreVpww7RIvLbI5wucLWBVqX3gCjawu3FckYlqRHvpHcB1Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyz1NcIzT2qeKUfzpzpC6DbaiO2r/tn1gFJFBHoI28/49EgYPSy
	1gNsKPvGPnCJ16wKu7oW/QA402BROZbYm9H5PJ90h1rebI8pQWWTBKMZIRsoYDA/foGQYAugSC3
	dgsVDoK7+jWEyeqPJCGU40rvaO/L6ApE=
X-Gm-Gg: ASbGncua4zVv5PkQtVEDVgBRVHPIbWLpc3ADxuLbNrvCXuCBXP2+eBYDm5OAOh6AxQk
	YLE8SeifKL0WHGYU4jrCF6UM/w0sDjaeTDD/AvcP7B9dxyE4XpNyEmoPjIkIcqt1P4sb0cP6VM6
	n+dNCMOKlqOgoFcB/wWAMDIIwzaRUJGq1L5CASSEYcCslgNQVgjrP+s8DUwd0M2FHY1PyQVYO7v
	p+Jsg==
X-Google-Smtp-Source: AGHT+IFCaHBfi74wGHsUbqTaQ15Y1C6Gqe+ShU36d9sHDWS7dqq84PZsTSbYpDE+OntprGaYm94PJSxSQjVx2SzONBM=
X-Received: by 2002:a17:903:1b06:b0:240:a559:be6a with SMTP id
 d9443c01a7336-2462ef4446amr128269465ad.34.1756052990518; Sun, 24 Aug 2025
 09:29:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250820144511.15329-1-abinashsinghlalotra@gmail.com>
 <20250820144511.15329-2-abinashsinghlalotra@gmail.com> <660498d6-3526-4f1c-99d8-776fa9967747@acm.org>
In-Reply-To: <660498d6-3526-4f1c-99d8-776fa9967747@acm.org>
From: Abinash Singh <abinashsinghlalotra@gmail.com>
Date: Sun, 24 Aug 2025 21:59:39 +0530
X-Gm-Features: Ac12FXz-1u-6KMR5ZeaCRPIsJud4r8UdH1fXOWFw8Hgq0bWLVPeK61UYw0zsVr0
Message-ID: <CAMV7Lq7DM-Kg_cK-w3PhBR8CoH=RkZ3D7s18ByMkMLMYPB0Lwg@mail.gmail.com>
Subject: Re: [PATCH v8 1/2] scsi: sd: Fix build warning in sd_revalidate_disk()
To: Bart Van Assche <bvanassche@acm.org>
Cc: martin.petersen@oracle.com, James.Bottomley@hansenpartnership.com, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dlemoal@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 23, 2025 at 1:17=E2=80=AFAM Bart Van Assche <bvanassche@acm.org=
> wrote:
>
> > > On 8/20/25 7:45 AM, Abinash Singh wrote:
> > > +     lim =3D kmalloc(sizeof(*lim), GFP_KERNEL);
> >>  +     if (!lim) {
> > >+             sd_printk(KERN_WARNING, sdkp,
> > >+                     "sd_revalidate_disk: Disk limit allocation failu=
re.\n");
> > >+             goto out;
> > >+     }
>
>   > From Documentation/process/coding-style.rst:
>
> > These generic allocation functions all emit a stack dump on failure whe=
n
> >used
> >without __GFP_NOWARN so there is no use in emitting an additional failur=
e
> >message when NULL is returned.
>
> > Has this example perhaps been followed? I think it is safe to remove
> > this sd_printk() statement.
>
check patch emits this warning .
   WARNING: Possible unnecessary 'out of memory' message
  #52: FILE: drivers/scsi/sd.c:3716:
  + if (!lim) {
  + sd_printk(KERN_WARNING, sdkp,

So I think Bart is right about it . I will send v9 with these changes.

>
> > Otherwise this patch looks good to me.

In which patch should i remove this sd_printk statement . As it is
there already.
>>       buffer =3D kmalloc(SD_BUF_SIZE, GFP_KERNEL);
> >     if (!buffer) {
> >              sd_printk(KERN_WARNING, sdkp, "sd_revalidate_disk: Memory =
"

If we have to go with a seperate patch for this then  v9  will have
three patches:
                                                             1)  Fix
unnecessary 'out of memory' message in sd_revalidate_disk()
                                                             2)  Fix
build warning in sd_revalidate_disk()
                                                             3)  Make
sd_revalidat_disk() return void
>
> < Thanks,
> < Bart.


Thanks


On Sat, Aug 23, 2025 at 1:17=E2=80=AFAM Bart Van Assche <bvanassche@acm.org=
> wrote:
>
> On 8/20/25 7:45 AM, Abinash Singh wrote:
> > +     lim =3D kmalloc(sizeof(*lim), GFP_KERNEL);
> > +     if (!lim) {
> > +             sd_printk(KERN_WARNING, sdkp,
> > +                     "sd_revalidate_disk: Disk limit allocation failur=
e.\n");
> > +             goto out;
> > +     }
>
>  From Documentation/process/coding-style.rst:
>
> These generic allocation functions all emit a stack dump on failure when
> used
> without __GFP_NOWARN so there is no use in emitting an additional failure
> message when NULL is returned.
>
> >       buffer =3D kmalloc(SD_BUF_SIZE, GFP_KERNEL);
> >       if (!buffer) {
> >               sd_printk(KERN_WARNING, sdkp, "sd_revalidate_disk: Memory=
 "
>
> Has this example perhaps been followed? I think it is safe to remove
> this sd_printk() statement.
>
> Otherwise this patch looks good to me.
>
> Thanks,
>
> Bart.
