Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD9518DB35
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 14:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785334141; cv=pass; b=I5zYfeEaROK015Iv1D7cWkMycv6hremAjF5AtMUNnAj6me9SSw8obJxU/kE34CrAYqbBZieKR9tZP/eID7q4K2F2OIdNkD7ytxZpnaD5/NQ7gOuLGCuQj3ZWhaj74BIfA4Pc+ct5vY/L46vl4cchfJ9prkqbVUNY+GSrWGvJTm4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785334141; c=relaxed/simple;
	bh=C9xtxbuUwTl2/4FiNCbCnz92H6bjM6ISYPijuuaBP7M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ftpE6DSIS4COq+hvWNY+xX372YB7EiISlJiA2HW7eUmxLx5lXpz0y7oqljSCQVy/rU/EX7s+H/oo1gJwWZftJ3uGfH33+vQxK4kQFR6IVDX/nDlIELbT9xQzlqYT3rfMMG7nYs943HsfFNPXFMjSdEIyQXSMqp7Zq2ZD0GrM8pc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jjpXqR0Y; arc=pass smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jjpXqR0Y"
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-8143daf89c7so10823947b3.1
        for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 07:08:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785334136; cv=none;
        d=google.com; s=arc-20260327;
        b=I8Uh54bzfBQ/uxEZ1EiwIj5WXPpB2IAoDMOXP0Wn+6TdPC9M+Ya3SPIUmMFbOuookd
         o/xPrU+t5FtKMJVKX4aqcelYinExGZ2TINOrVLTkpkUNEuzY+sLMLIqiYsoeVVtfRmm8
         R/VS8qjo3G09EE/wIyzBbTmSt+t5ilL9WVTZRA1UEE1mtDiIHtHsbfgenE8Zf91vdWir
         GAzkVQ0eOrRRhYBj8aBlQV2oCfEREdMWDznZvcTrsbdbDmu7xelbnvKqOFjLO7/u9qa9
         huXwyXHId1I5Jctjz0GYvIplbWwrpDYA2cyCR6/y48AQLRN12RwwtLWj/4TBkWHgd/F/
         d6SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ILQW7wTx7MCavtjYKz64KhhUuc2hqgjwomjCvbjS/JA=;
        fh=AcTm01PINQ8d96pvd8eXHe5u/9aPXvLvzzdcUnoXEdE=;
        b=YhVTrXsfmNXc8JJMEJysCsbaSx03zdT4QJd7GLTcmRfhp4SJ8aX7OmhXGDI+8M8Kx6
         uGSSoDClcxB4mNc5zgqUQUX3dKYDPb5CMBpFfG+yYxOOnWPtnjuYcrMAvAL+j49O8Spc
         Oq3UATmyLTXiRuL1rbTB1tDhrtxxDuiDot7sJcSHkIBoV+4Xi8SeYIyRvql5mqopgjA4
         ez4f3BbTJeKT9F7HsjGlCn3DkrxJAUtmWIBkHAUQU8tK8MFoucvPKlqpPtfNmTKbayxC
         iJGgI6K+Fxu8ow11a9r62l9R5Ssz8pMWuB3y0lT9COFYZ+nkzVgyHOBr5jVGytgNYqkp
         OVAA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785334136; x=1785938936; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ILQW7wTx7MCavtjYKz64KhhUuc2hqgjwomjCvbjS/JA=;
        b=jjpXqR0YFf6ekhWMsG4jve3XQGUZMPCvLbVCKpbrL9Aw5uxkbvKrZP+89Q9vwa5xpW
         QL+kEpUErsvgomW2e88CJwqZHNz7sLXne1mrM778ANvcvtRCqov4JuQsZqD0caudPRPL
         nGVENNSpLFCIzZe5oQMXm3M4JvetsH2GCuTJXNgYyulRq0EZOHg9uCgvkMUFEnfEbI4a
         8oEYPjfjas+byx4RqOqqAnK3DUIiZETPwMDZO7uVAezcKSecI7cZIK2/WrASqnirreDG
         8+92KUEWgzYHgLn1I28HwQK+LE4CsJe01F8E0huUbjs/fS70Jqlh0J+3jBnivc67zM9V
         cv4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785334136; x=1785938936;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ILQW7wTx7MCavtjYKz64KhhUuc2hqgjwomjCvbjS/JA=;
        b=j5Y2iZ34dcckfdiY/3JfC+dYcKbLJkxiSlJ5B0Yq1+DijgsaJVuqXRev+qsv6YQfVW
         oo1o2kaXvDvTpwJa5Hq8zAFr0/XtpI6lHmMHVBjQvxOU14VXvoxA7mr+vtS8YXgRGEnd
         /pKj7lnEREVdIyjYGcXpDmLVbBpoJfXdRfTsXbk+FWqgMXEVMJQwaCNgdM/D2pGJCaJq
         ZD5bdHKRyMQe877yRkJd1pUpziFdfI1WfxBkMG6vLUkpbH+WP6dtot+MSz7bOniVADDV
         87IJRq6QuFRbuVfe2/ervPgqUPURRKimljjJIg2tU3DEFUbztdKYciKLp5mXHCXRtDwL
         1a+w==
X-Forwarded-Encrypted: i=1; AHgh+RrwLAP0mS48go6EosSw9OdAHGa0mo6uxx7T4eltlpctqitNej+4cO5PTt+vkdkaGKN38YajBSxaTbF1@vger.kernel.org
X-Gm-Message-State: AOJu0YzhfxRQgQ09/yuC3YBXV5c9X0+bMA2Y/lN1yfUOJbb6D5aW6t4K
	QDXeHmSrVopb9Wzy0lurx5x1p+BUKQTSzht+Irtu59OIbDVWKaU0YUsjtg1TevYV3BhI/rFZquZ
	9ymHP/Uz7L5ruJeDf9dOK8Wt+4JMrVSM=
X-Gm-Gg: AR+sD138RnOF79vcu3xIKVKjK8MFGTA3GQsbyv+Xn1Z/jbsx9Brg4CN9uFIs7QcJHFt
	jMzGHyRKbA0FmyNTLQUprnoDLJIfLxbEEJffnouyCDTqR8DRW1npJxUNcVjPTvAx8sFuoOKBFLB
	z06u/nSGHBF7hWsgkSOy7N6ketq1bQdMFoiHO3ufp1n4TRQrol+e5XmLcvo04xkJwgHFJq/pCYm
	3E8MFkqenyU1YOO0PAur+9U+Yh+tocZ/v4vcyAX7uMz6GYxX6qg6865ZEVbl7tH18PSHuUBKMI4
	1YGs1gYfOk78QD/aq1QsqKJE8X8pdNetr39/sSf+UhaXOmcg2kV/kQ==
X-Received: by 2002:a05:690c:f0a:b0:80c:85e5:8741 with SMTP id
 00721157ae682-81f993df989mr36253797b3.63.1785334134768; Wed, 29 Jul 2026
 07:08:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260716230411.2767394-1-tarunsahu@google.com>
 <20260716230411.2767394-5-tarunsahu@google.com> <20260717025913.067B41F000E9@smtp.kernel.org>
In-Reply-To: <20260717025913.067B41F000E9@smtp.kernel.org>
From: David Jeffery <dhjeffery@gmail.com>
Date: Wed, 29 Jul 2026 10:08:43 -0400
X-Gm-Features: AUfX_my5xPWn2PPlT7ZWQqD-dmkDU18YDfPkQgQ3vbI39xQlspjH-YQORqbG6Us
Message-ID: <CANghDUUFrGN3CiJmRhQS0jtDwNnoWbKv490E=UxDXGgKsy6m7A@mail.gmail.com>
Subject: Re: [PATCH v19 4/7] driver core: do not always lock parent in shutdown
To: sashiko-reviews@lists.linux.dev
Cc: Tarun Sahu <tarunsahu@google.com>, linux-pci@vger.kernel.org, 
	linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 16, 2026 at 10:59=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
>
> New issues:
> - [High] Unprotected read of dev->parent introduces a Use-After-Free race=
 with device_move() during reference acquisition.
>
> Pre-existing issues:
> - [High] Dropping and re-acquiring device_lock(dev) allows dev->parent to=
 change, resulting in locking an obsolete parent.

We could add additional locking around device_move to exclude moves
during these times to quiet both the AI tool's concerns. However, both
these concerns are already not possible in reality. The only user of
need_parent_lock in the kernel which will use this code path is usb
devices, and none of the rare devices which use device_move will move
a usb device which has need_parent_lock set. Thus, there is no actual
device_move which can cause these conditions the AI tool complains
about.

The AI tool is finding a non-existent issue by applying a very
specific special state as a general condition. If really wanted, I
could add a patch which locks out moves during these times as a form
of future-proofing, but from my view of the code all it would be doing
is creating additional code and complexity to the driver core while
currently fixing nothing.

> --
>
> --- Patch [4]: [PATCH v19 4/7] driver core: do not always lock parent in =
shutdown ---
> commit 6be56e5bea0fe214a5199c9f806c49e62e60127f
> Author: David Jeffery <djeffery@redhat.com>
>
> driver core: do not always lock parent in shutdown
>
> This patch modifies the device shutdown process to only lock a parent dev=
ice
> if it is strictly needed, rather than unconditionally. It also defers
> acquiring a reference to the parent device until the point where the pare=
nt
> needs to be locked.
>
> > diff --git a/drivers/base/core.c b/drivers/base/core.c
> > index 82a7af1f3ba2e..31f95e86856e0 100644
> > --- a/drivers/base/core.c
> > +++ b/drivers/base/core.c
>
> [ ... ]
>
> > @@ -4925,12 +4921,32 @@ static void shutdown_one_device(struct device *=
dev)
> >  static void shutdown_one_device(struct device *dev)
> >  {
> > +     struct device *parent;
> > +
> > +     device_lock(dev);
> > +
> > +     /* use parent lock if needed to avoid race with probe/release */
> > +     if (dev->bus && dev->bus->need_parent_lock && dev->p && !dev->p->=
dead &&
> > +         (parent =3D get_device(dev->parent))) {
>
> [Severity: High]
> Does moving the parent reference acquisition out of the list_lock critica=
l
> section introduce a race condition where the parent could be freed?
>
> In device_shutdown(), get_device(dev->parent) was previously called while
> holding devices_kset->list_lock. Now that it is evaluated locklessly in
> shutdown_one_device():
>
> CPU1
> shutdown_one_device()
>     evaluates dev->parent, but is preempted before get_device() is called
>
> CPU2
> device_move()
>     changes dev->parent and calls put_device(old_parent)
>     dropping the last reference and freeing the memory
>
> When CPU1 resumes, could it pass the freed pointer into get_device() and
> dereference it?
>
> > +             /* the parent lock needs to be acquired first, so re-lock=
 */
> > +             device_unlock(dev);
> > +
> > +             device_lock(parent);
> > +             device_lock(dev);
> > +
> > +             __shutdown_one_device(dev);
>
> [Severity: High]
> This is a pre-existing issue, but does dropping and re-acquiring the devi=
ce
> lock here allow the topology to change?
>
> If a concurrent device_move() reparents the device while device_lock(dev)
> is dropped, it appears we might lock the obsolete parent. When we re-lock
> dev and call __shutdown_one_device(), we haven't verified that dev->paren=
t
> still matches the locked parent.
>
> Could this defeat the need_parent_lock synchronization and allow a
> concurrent probe or release on the new parent to race with the shutdown?
>
> > +             device_unlock(dev);
> >               device_unlock(parent);
> > +             put_device(parent);
> > +     } else {
> > +             __shutdown_one_device(dev);
> > +             device_unlock(dev);
> > +     }
> >
> >       put_device(dev);
> >  }
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260716230411.27=
67394-1-tarunsahu@google.com?part=3D4
>
