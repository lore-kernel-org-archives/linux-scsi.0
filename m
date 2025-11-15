Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C7127B335
	for <linux-scsi@vger.kernel.org>; Sat, 15 Nov 2025 14:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763217074; cv=none; b=Yl4BfPctx5FaqJZJB3Doz6EhP1kIEDWldgaI5iFHrME1CrCtG58QHANBNTs4VYNexXkWGPIcCm/NCZzA/vRVWchcj4CFvP95H/iWYSTAoKsth9B3wEKG5harYtLqSYNwdAnNo+dhVSjcIV3M1WJ+v0zWI9QGUidyOmLHEUVvLBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763217074; c=relaxed/simple;
	bh=HCh1AbItHBot1NefhnEc/xtCfs1nqqOG8nCz/nzyiIg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jwi3qSBdF9eXybBtEq0NAPF8qRqNWDgx9v+aq1LL1pTjkIOtNFGj9mbC0a41p8OD8F+oLy4HmYkJb2sivLezmQVYGHbRrrbdrMHiyzEjVbRoLSEat3LKlm47YXTwg0UtyING+6G9gPXqHXdRTjTiqegPHm8ly6GYsKZ6Do7Tk2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NRAlSrHD; arc=none smtp.client-ip=209.85.217.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NRAlSrHD"
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-5dd6fbe50c0so1188029137.2
        for <linux-scsi@vger.kernel.org>; Sat, 15 Nov 2025 06:31:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763217071; x=1763821871; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L/zsgxjumAghjp5NTUgp2Dj0RhDrX5umNkGyHZM347g=;
        b=NRAlSrHDk2Lqxx7nwWxyr40CI51y59BznARUEg9urMC6sspKJ4mK0fqD7twJjss1Ub
         kA448AbZO0/Viu7uWCipBjW/XfqzDtopSiCixL71GKr6ljmqxtOjqhUQnNQCSizWAdGx
         WqTYc65gtZBlihDGeVbShDy8NTgXSU7Yczt5Up4lkfnZQ40twP1IxTULqiDCtg4avGNR
         BACC9iorXdZHOq7mfkzjoxHEBEgR2CzwjJf3YhZRBD6QBOTc5E7IrAW7XJaS4VylaQQn
         FvTybrPoxM2bmAizfK/aCxLBPGF0PSwXZhydvHs0dc7Z95N6chAKhw/pSAit9wuOzXT+
         2b2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763217071; x=1763821871;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=L/zsgxjumAghjp5NTUgp2Dj0RhDrX5umNkGyHZM347g=;
        b=RiDaTIl5BoFl+lald968BNM+LB+RtHDWVrO3Jg28umhDtZPFVnkZh+3zreEldHbfkJ
         fdgQ4RE+mX46s0n27jFm3uduAU9txk4sZCNLIoS+IBqvDf6eGIGkGQOH71+riGlUBXWi
         muhmuK2yYvb3uu8UgQxlZJl97OTG16avAhByIJ2Caxi4JORI/KybJguSVJFulX+S0tQZ
         vh6T/XfxhvWq0SmYCQBsDTARxBKqxpvnnvHK0NQPFuD+WI29iHoq4N7eFty6VbJ3mdnK
         VYpZdzSXnVeGEaTdtN6M4NHKDSCKhW6DXqMxKQa4afFyhHPm98OO/76yXyXeZeFnjnOd
         glZg==
X-Forwarded-Encrypted: i=1; AJvYcCWU6/KyhcWXWDWM8j97QZpM2i3POKJdMjwlTX2b2FgTFyVVz9t8IRCsY8bel+uq4lRRGlpxsu660N++@vger.kernel.org
X-Gm-Message-State: AOJu0YzaI0EnEzRWf8gWOgrPcIJPwDD/mvK1Fyy9+9irCFNUnZOT/dHW
	/1byEBWs+KPvtoGAPu7gbz+cDUYOTCDqeFUEoAab1y0HkhpvLLFibaw4A2/yQYtzX1RgDy5lTI8
	pbT4VMWIC0oPlb+TCd9c+ScBVaVfKusI=
X-Gm-Gg: ASbGncua3ftxQXLw173YZgKsePSvayszIOHms8siRHXo5xFVUlHJrFUnZ61GHB0y9me
	qOmztrWcHlGuYDxE1OQocgxdLgex97BSfQttO+0ng4erDUUS8JQWFtuDO5iYPSRcqjm59RG3ASz
	2bh3I4rbCcTj3HB5ZLpLdsD86wOU8rv7zgrz2PcUtsv83frDBl8K0WnDNUeGvHiW1oEw7kwZpSe
	O+kXKS2RQYZmBfhwbT7vIbyrTrNQGp5TG7OXGz1XQVUlnnCKuYaJZVUOWCmiJR3IeavgDwLVY+2
	Uy/jjr1ak/XgDQSONb2Ox2wGKxnD9JafzCUFJlKbk1YNofcDHB+GbH+9Eg==
X-Google-Smtp-Source: AGHT+IEqXthhXr4xd8zhDNKcc8uuAbcCd1a0DH0E8A483J5NHlU1YyQoSY6GhKMrR09mqYLXqhzbYM6XzukHMCRB13Q=
X-Received: by 2002:a05:6102:374e:b0:5db:a6c1:5b13 with SMTP id
 ada2fe7eead31-5dfc5b9e406mr2471341137.33.1763217071323; Sat, 15 Nov 2025
 06:31:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251028145534.95457-1-kubik.bartlomiej@gmail.com>
 <562fa035-c732-4bfc-8439-2279d029f72a@acm.org> <CAPqLRf1-zb3v2hMDexM4zCtAtr+yzwQdeSrkzssfo0rkmLo=mA@mail.gmail.com>
In-Reply-To: <CAPqLRf1-zb3v2hMDexM4zCtAtr+yzwQdeSrkzssfo0rkmLo=mA@mail.gmail.com>
From: =?UTF-8?Q?Bart=C5=82omiej_Kubik?= <kubik.bartlomiej@gmail.com>
Date: Sat, 15 Nov 2025 15:31:00 +0100
X-Gm-Features: AWmQ_bnQWhJkFitrpJackQLV__jZ-yjP9nqpKYf6SwLg52eMCuK1zIXwP1iCp9s
Message-ID: <CAPqLRf2eyK2bRess785AB6C2+Mj4U1CGyT6n4spkJy+_gNc9-A@mail.gmail.com>
Subject: Re: [PATCH RFT v2] driver/scsi/mpi3mr: Fix build warning for mpi3mr_start_watchdog
To: Bart Van Assche <bvanassche@acm.org>
Cc: sathya.prakash@broadcom.com, kashyap.desai@broadcom.com, 
	sumit.saxena@broadcom.com, sreekanth.reddy@broadcom.com, 
	martin.petersen@oracle.com, mpi3mr-linuxdrv.pdl@broadcom.com, 
	linux-scsi@vger.kernel.org, skhan@linuxfoundation.org, khalid@kernel.org, 
	david.hunter.linux@gmail.com, linux-kernel-mentees@lists.linuxfoundation.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Apologies for my previous email - I mistakenly hit send before completing
my full response.

Thanks for your time and review.

On Wed, 12 Nov 2025 at 21:55, Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 10/28/25 7:55 AM, Bartlomiej Kubik wrote:
> > -     char watchdog_work_q_name[50];
> > +     char watchdog_work_q_name[MPI3MR_WATCHDOG_NAME_LENGTH];
>
>  From include/linux/workqueue.h:
>
>         WQ_NAME_LEN             =3D 32,
>
>         char                    name[WQ_NAME_LEN]; /* I: workqueue name *=
/
>
> In other words, increasing the workqueue name length beyond 32
> characters is not useful because it will get truncated to 32 characters
> anyway. The workqueue implementation complains about longer names as one
> can see in kernel/workqueue.c:
>
>         if (name_len >=3D WQ_NAME_LEN)
>                 pr_warn_once("workqueue: name exceeds WQ_NAME_LEN. Trunca=
ting to: %s\n",
>                              wq->name);

Yes. My mistake: I did not see this before. I walked through the path
where watchdog_work_q_name is used, but I did not go too deep.
I found this when building the kernel and GCC returned a warning.
I saw a couple of months ago that the watchdog_work_q_name size was
increased from 20 to 50, and MPI3MR_NAME_LENGTH was also changed
from 32 to 64.

> > diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3=
mr_fw.c
> > index 8fe6e0bf342e..18b176e358c5 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> > +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> > @@ -2879,8 +2879,7 @@ void mpi3mr_start_watchdog(struct mpi3mr_ioc *mri=
oc)
> >
> >       INIT_DELAYED_WORK(&mrioc->watchdog_work, mpi3mr_watchdog_work);
> >       snprintf(mrioc->watchdog_work_q_name,
> > -         sizeof(mrioc->watchdog_work_q_name), "watchdog_%s%d", mrioc->=
name,
> > -         mrioc->id);
> > +         sizeof(mrioc->watchdog_work_q_name), "watchdog_%s", mrioc->na=
me);
> >       mrioc->watchdog_work_q =3D alloc_ordered_workqueue(
> >               "%s", WQ_MEM_RECLAIM, mrioc->watchdog_work_q_name);
> >       if (!mrioc->watchdog_work_q) {
> Leaving out mrioc->id from the workqueue name seems like an unacceptable
> behavior change to me.

Add twice the same ID one after one. Is it not a mistake ??
If mrioc->name has that same ID at the end.

sprintf(mrioc->name, "%s%d", mrioc->driver_name, mrioc->id)

watchdog_work_q_name is built from mrioc->name which has this ID at the end=
.
If I see correctly, if mrioc->id will be 1 then  watchdog_work_q_name
will look like
watchdog_mpi3mr11, but I think it should be watchdog_mpi3mr1, or am I missi=
ng
something??

> Please consider replacing the proposed changed with this untested patch:

You are correct. I've sent this patch as an RFT because I don't have the
hardware to test this. I would appreciate it if someone could test the prop=
osed
patch for me.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index 6742684e2990..050dcf111a4c 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -1076,7 +1076,6 @@ struct scmd_priv {
>    * @fwevt_worker_thread: Firmware event worker thread
>    * @fwevt_lock: Firmware event lock
>    * @fwevt_list: Firmware event list
> - * @watchdog_work_q_name: Fault watchdog worker thread name
>    * @watchdog_work_q: Fault watchdog worker thread
>    * @watchdog_work: Fault watchdog work
>    * @watchdog_lock: Fault watchdog lock
> @@ -1265,7 +1264,6 @@ struct mpi3mr_ioc {
>         spinlock_t fwevt_lock;
>         struct list_head fwevt_list;
>
> -       char watchdog_work_q_name[50];
>         struct workqueue_struct *watchdog_work_q;
>         struct delayed_work watchdog_work;
>         spinlock_t watchdog_lock;
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> index 8fe6e0bf342e..b564fe5980a6 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -2878,11 +2878,8 @@ void mpi3mr_start_watchdog(struct mpi3mr_ioc *mrio=
c)
>                 return;
>
>         INIT_DELAYED_WORK(&mrioc->watchdog_work, mpi3mr_watchdog_work);
> -       snprintf(mrioc->watchdog_work_q_name,
> -           sizeof(mrioc->watchdog_work_q_name), "watchdog_%s%d", mrioc->=
name,
> -           mrioc->id);
>         mrioc->watchdog_work_q =3D alloc_ordered_workqueue(
> -               "%s", WQ_MEM_RECLAIM, mrioc->watchdog_work_q_name);
> +               "watchdog_%s%d", WQ_MEM_RECLAIM, mrioc->name, mrioc->id);
>         if (!mrioc->watchdog_work_q) {
>                 ioc_err(mrioc, "%s: failed (line=3D%d)\n", __func__, __LI=
NE__);
>                 return;
>
> Thanks,
>
> Bart.

Best regards
Bart=C5=82omiej Kubik
