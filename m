Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C95172605
	for <linux-scsi@vger.kernel.org>; Fri, 18 Jul 2025 23:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752881474; cv=none; b=uyV8MyJch0QMSe1GYxZ+hXSFeqJU//jxDjWT4GBz77XyhurU55aOh4i0YdMdyT76GSi8VkswP+oP7WxSTuHqk2OfpxMYi/D1zzlSpuNiUqNLaY41JoFLihlI/dU6yveukv4IZ3si61Z4qYPwfl/XwafOKbmg6QV69qGwhQx9k/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752881474; c=relaxed/simple;
	bh=wyKQcm7FRsVVHy4/wZxvx8WFb4+uvsQcoCBaVGG3kkA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VbKubVphSSAjIaeFDFH435aJlr8gFTghuLPFMv4J1ryEve0EjtwToGjBjk3ylDbnc9fLLyhFd3na71TLl2rNAgpTHQgzYmJMlf698M/la0jb8tOpeaJjP4HrEaA8jFFIzUT741PollhMJlezKq3N/nEK3mFEJrqYKFKV+eUuiFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x0JLxWpO; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x0JLxWpO"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4ab3855fca3so50251cf.1
        for <linux-scsi@vger.kernel.org>; Fri, 18 Jul 2025 16:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752881471; x=1753486271; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A7qVRd75qAo0NhaT8pe3MvptNKMVh4Xqd0bD2B3tv18=;
        b=x0JLxWpObudM9B8qMn9hFEFvwhKYRDAnccminH6e/QEuPFVtRcpVRc0jcFkfIBD/Eq
         B3kSFu+7JzRb9WQ+VBLki8QPKAFBGo3MflOx2dULFSt1c96eoQ+i5AUGP3RPMHSqD9Cb
         2L4+35fGdemZ+c5X00p16rkBbM0ZuKV2dZxmfbRTZKTtdi+BOjZ/tsHBcOwePhQI84qE
         OdGVuGAoGpiuqs1yRKzRJTd+f67bMzGNUxV6eu1D2hoKaIgbgJjnbOpixvtX3gj/2IRr
         pSh6cJx2BnvRRg+Ysm4exfbWUbALpDKJ5GIvUwJyG5qeVuUE4lhomYld8dirhOB7PPzM
         o0+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752881471; x=1753486271;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A7qVRd75qAo0NhaT8pe3MvptNKMVh4Xqd0bD2B3tv18=;
        b=c5P87Pq2DETbDUytBIhQ1BVIDlRh4RJEteC4cSxuaDcr9N+8EUcFetmy9xTcUc4YwI
         lrXLHeEI0EG42yaS0WKFSN+GWu7hTztPDC0k+Cbd3EujCfj/0f4OUmCNsNrmL06rU9zC
         AVO5BP3C3ZZ+J3fxm2cRhzNMwHNufS0tphU1UMzWKEeYBWzBsTSMqZrJwMq2g+64THKO
         4Rh/JK09lc4Iq0dgwTzoA1EL2c2p49N6cdzfV55t2T3IPWJqs6fZtS0PnhQs+Ac41TZx
         m2QbsCmdi1BowoLPYsrSE9RVxnW178y1IPw8vXcpMaaDRdsMHklyPwBQ8U5FCKV35Y1f
         HY/w==
X-Forwarded-Encrypted: i=1; AJvYcCWg8/C/+xjiuLPijdYlH4I60scCRrCBbEs+FxVZSpdZSPgQMP6eejSfC/bCAyKfGIuRSpT9es0+gADn@vger.kernel.org
X-Gm-Message-State: AOJu0Yxzknxsr0vXIXOSvhJjYPpIzdnUZFrTA1pbfiUuFJJ45UzKKwaf
	iaxOzBJ5QsCXGyXcY3IHBYyiztkD/zHO5/p9APfNe6ALZhQXTt7SQ8YMfyM/pLfnWGRx7DylJr2
	bZzLPUMzuSLPGZlSvraNS+hWXzNh+RfYdEbWmozQC
X-Gm-Gg: ASbGnctAwUupas8YVM9ZsyWH0DyuFx2jZd298ut/Q7QrXvsTJvRNRYsX5lqxA6BcBhk
	6Bg4ktnOcFfKTSGOkdMH0yUHUXQGYq8ku74aTQfUb7uegQMjVo4XZ5hgiqFNuTDDdLnXNblcGLh
	MVpzxz3ii6hAZYFKnMIwwjpsARQZAFOgtzx5qvkIumRavrnyeB0wnKBQZHcQAiJal1hVaLRIvtT
	hEqbQP/sY0iJIzbidu9cDIQNczXal4LZUY=
X-Google-Smtp-Source: AGHT+IFlfld6v/GsjQw7m8R0jXsegWa6/2P4Mtqon/Cbpq0aXvdr8xYl+dd9FjYvhcv0JVHvrZmQszFmt4yRNCi9rFc=
X-Received: by 2002:a05:622a:48a:b0:48a:ba32:370 with SMTP id
 d75a77b69052e-4abc0f2ed2emr1304301cf.10.1752881470951; Fri, 18 Jul 2025
 16:31:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <30f8ea8d-79c4-4e5c-b354-51ad8146a61c@acm.org> <20250717194025.3218107-1-salomondush@google.com>
 <CAFdVvOx-xegmdGO8xgwpE3i0BvgXD0C1jKjNWKNjTFuifWmuxg@mail.gmail.com>
In-Reply-To: <CAFdVvOx-xegmdGO8xgwpE3i0BvgXD0C1jKjNWKNjTFuifWmuxg@mail.gmail.com>
From: Salomon Dushimirimana <salomondush@google.com>
Date: Fri, 18 Jul 2025 16:31:00 -0700
X-Gm-Features: Ac12FXzuvXdLhzc6ftq7CLhsfjlqhKNIF_PF7tsJ9Fph4me_WgOPpQP3OjALBjs
Message-ID: <CAPE3x15Qxy5+C3_1v6a6YBoz03=NVoJMz-yfc6qih_=_js8=ug@mail.gmail.com>
Subject: Re: [PATCH v2] scsi: mpi3mr: Emit uevent on controller diagnostic fault
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc: bvanassche@acm.org, James.Bottomley@hansenpartnership.com, 
	kashyap.desai@broadcom.com, linux-kernel@vger.kernel.org, 
	linux-scsi@vger.kernel.org, martin.petersen@oracle.com, 
	mpi3mr-linuxdrv.pdl@broadcom.com, sreekanth.reddy@broadcom.com, 
	sumit.saxena@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

When the controller encounters a fatal error event, we want to notify
our userspace tools to react to these events and pull the
corresponding logs/snapdump from the ioc. There's a list of other
drivers doing something similar, such as drivers/scsi/qla2xxx,
drivers/scsi/qedf/qedf_dbg.c, etc.

So the mpi3mr_issue_reset function only supports two types of resets,
i.e MPI3_SYSIF_HOST_DIAG_RESET_ACTION_SOFT_RESET and
MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT for now. From the code,
it seems like only diag fault reset generages a snapdump, soft resets
do not, hence why we only emit the fatal uevent on diag fault.

Thanks,
Salomon Dushimirimana

Salomon Dushimirimana


On Fri, Jul 18, 2025 at 8:43=E2=80=AFAM Sathya Prakash Veerichetty
<sathya.prakash@broadcom.com> wrote:
>
> On Thu, Jul 17, 2025 at 1:40=E2=80=AFPM Salomon Dushimirimana
> <salomondush@google.com> wrote:
> >
> > Introduces a uevent mechanism to notify userspace when the controller
> > undergoes a reset due to a diagnostic fault. A new function,
> > mpi3mr_fault_event_emit(), is added and called from the reset path. Thi=
s
> > function filters for a diagnostic fault type
> > (MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT) and generates a uevent
> > containing details about the event:
> >
> > - DRIVER: mpi3mr in this case
> > - HBA_NUM: scsi host id
> > - EVENT_TYPE: indicates fatal error
> > - RESET_TYPE: type of reset that has occurred
> > - RESET_REASON: specific reason for the reset
> >
> > This will allow userspace tools to subscribe to these events and take
> > appropriate action.
> What is the reason for userpace tools to know these events and what
> user space tools we are talking about here?  Also, on what basis it is
> decided only diag fault reset is considered as FATAL.  I would prefer
> to understand the actual requirement before ACKing this patch.  If we
> need this kind of user space notification then it would be better to
> make it generic and let the notification sent for all firmware fault
> codes.
>
> >
> > Signed-off-by: Salomon Dushimirimana <salomondush@google.com>
> > ---
> > Changes in v2:
> > - Addressed feedback from Bart regarding use of __free(kfree) and more
> >
> >  drivers/scsi/mpi3mr/mpi3mr_fw.c | 37 +++++++++++++++++++++++++++++++++
> >  1 file changed, 37 insertions(+)
> >
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3=
mr_fw.c
> > index 1d7901a8f0e40..a050c4535ad82 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> > +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> > @@ -1623,6 +1623,42 @@ static inline void mpi3mr_set_diagsave(struct mp=
i3mr_ioc *mrioc)
> >         writel(ioc_config, &mrioc->sysif_regs->ioc_configuration);
> >  }
> >
> > +/**
> > + * mpi3mr_fault_uevent_emit - Emit uevent for a controller diagnostic =
fault
> > + * @mrioc: Pointer to the mpi3mr_ioc structure for the controller inst=
ance
> > + * @reset_type: The type of reset that has occurred
> > + * @reset_reason: The specific reason code for the reset
> > + *
> > + * This function is invoked when the controller undergoes a reset. It =
specifically
> > + * filters for MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT and ignore=
s other
> > + * reset types, such as soft resets.
> > + */
> > +static void mpi3mr_fault_uevent_emit(struct mpi3mr_ioc *mrioc, u16 res=
et_type,
> > +       u16 reset_reason)
> > +{
> > +       struct kobj_uevent_env *env __free(kfree);
> > +
> > +       if (reset_type !=3D MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAUL=
T)
> > +               return;
> > +
> > +       env =3D kzalloc(sizeof(*env), GFP_KERNEL);
> > +       if (!env)
> > +               return;
> > +
> > +       if (add_uevent_var(env, "DRIVER=3D%s", mrioc->driver_name))
> > +               return;
> > +       if (add_uevent_var(env, "HBA_NUM=3D%u", mrioc->id))
> > +               return;
> > +       if (add_uevent_var(env, "EVENT_TYPE=3DFATAL_ERROR"))
> > +               return;
> > +       if (add_uevent_var(env, "RESET_TYPE=3D%s", mpi3mr_reset_type_na=
me(reset_type)))
> > +               return;
> > +       if (add_uevent_var(env, "RESET_REASON=3D%s", mpi3mr_reset_rc_na=
me(reset_reason)))
> > +               return;
> > +
> > +       kobject_uevent_env(&mrioc->shost->shost_gendev.kobj, KOBJ_CHANG=
E, env->envp);
> > +}
> > +
> >  /**
> >   * mpi3mr_issue_reset - Issue reset to the controller
> >   * @mrioc: Adapter reference
> > @@ -1741,6 +1777,7 @@ static int mpi3mr_issue_reset(struct mpi3mr_ioc *=
mrioc, u16 reset_type,
> >             ioc_config);
> >         if (retval)
> >                 mrioc->unrecoverable =3D 1;
> > +       mpi3mr_fault_uevent_emit(mrioc, reset_type, reset_reason);
> >         return retval;
> >  }
> >
> > --
> > 2.50.0.727.gbf7dc18ff4-goog
> >
