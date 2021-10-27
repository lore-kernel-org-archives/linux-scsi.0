Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD6C3C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 02:55:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A31C0610C7
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 02:55:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238768AbhJ0C5o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 22:57:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29492 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238723AbhJ0C5n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Oct 2021 22:57:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635303318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8XHXmq/zKeHW5Yih9b0wK27BhnoEgmOvb8teFUuALgk=;
        b=OJqnkvd2tzc6bZT2/EgplH8qeRgqRqE+Ku/pUBDjH36q14hyg7YWxF4GBsDfTKRhuSuomz
        UZ9rytsewFID5Gv3dmjqXW3L1UNm6VjdgyqXJvbGQ05Ja+amVQpJk+bVV09UR/C77jND2a
        E02qDH2GwAWOJerlJobPXaGGrohPrR8=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-AQWng--BMOOcnVyzskiuNw-1; Tue, 26 Oct 2021 22:55:17 -0400
X-MC-Unique: AQWng--BMOOcnVyzskiuNw-1
Received: by mail-lf1-f72.google.com with SMTP id d5-20020a0565123d0500b003ffbadeb642so661855lfv.20
        for <linux-scsi@vger.kernel.org>; Tue, 26 Oct 2021 19:55:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8XHXmq/zKeHW5Yih9b0wK27BhnoEgmOvb8teFUuALgk=;
        b=Igfp30MtpJAOrOmeGFyaNgZmDukf2mpTH0ZnsOxE7lG1+iCZFNWnuSLlF8jgSWfHMX
         3QnXuK3F8UNfKfr0b4OxcmMps8U35pjXb/mkwpQoD9xxSgPUtAmcrA/F8w8i7yEX2tEV
         zeOWZcK0EZ9DQD6GXI+h9VGezMToOPQ5nyFau9gGmIe/UEOd8uhYnHNjkIY5zAljhol4
         2RVGqDvWdgYWzEkKICDdNCVeYov+P2m0OPGwppMLBsXCFvZM2eRmo5UnK1FPohfBgrIY
         i7oAMcII2AkU8xUl4EFgfBDnkSOxMpPD2v8/9J2MJs+YsRA2K8hmJqij7nLwVI9y4ii3
         TB2w==
X-Gm-Message-State: AOAM531Upv41Vat1V4SX4lw2HFrop7sAlxESyfaQd3kfVkB6r49iSW4i
        FCDPcpvflxnTxF94FcHVNqHUYqY1nx5HmGHpnoGhVaDzM0+DzftTc5yQoGCOvyi90yEtyDh9KoP
        ekxh0hnthP37CMZjP0CzlostmG0VrcLaaxXNjxA==
X-Received: by 2002:a2e:a5c8:: with SMTP id n8mr29841567ljp.307.1635303315589;
        Tue, 26 Oct 2021 19:55:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyl6bcCWF9TvAy4gzBetlOvaHhdNtU2DeVxvPHRicHeJzfD6Z0vZaZjJVuP5wXMH+9xO8MEAzOcU1OKkMy3n0E=
X-Received: by 2002:a2e:a5c8:: with SMTP id n8mr29841546ljp.307.1635303315380;
 Tue, 26 Oct 2021 19:55:15 -0700 (PDT)
MIME-Version: 1.0
References: <20211022051911.108383-1-michael.christie@oracle.com>
 <20211022051911.108383-13-michael.christie@oracle.com> <8aee8f07-76bd-f111-bc5f-fc5cad46ce56@redhat.com>
 <YXgiYFIUTKtoRJWW@stefanha-x1.localdomain>
In-Reply-To: <YXgiYFIUTKtoRJWW@stefanha-x1.localdomain>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 27 Oct 2021 10:55:04 +0800
Message-ID: <CACGkMEsD=JwjWgTM4XpcKVy+ZKs6siW_1Q=3zzB8jZ3vq1CyZA@mail.gmail.com>
Subject: Re: [PATCH V3 11/11] vhost: allow userspace to create workers
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Mike Christie <michael.christie@oracle.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        pbonzini <pbonzini@redhat.com>, mst <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Oct 26, 2021 at 11:45 PM Stefan Hajnoczi <stefanha@redhat.com> wrot=
e:
>
> On Tue, Oct 26, 2021 at 01:37:14PM +0800, Jason Wang wrote:
> >
> > =E5=9C=A8 2021/10/22 =E4=B8=8B=E5=8D=881:19, Mike Christie =E5=86=99=E9=
=81=93:
> > > This patch allows userspace to create workers and bind them to vqs. Y=
ou
> > > can have N workers per dev and also share N workers with M vqs.
> > >
> > > Signed-off-by: Mike Christie <michael.christie@oracle.com>
> >
> >
> > A question, who is the best one to determine the binding? Is it the VMM
> > (Qemu etc) or the management stack? If the latter, it looks to me it's
> > better to expose this via sysfs?
>
> A few options that let the management stack control vhost worker CPU
> affinity:
>
> 1. The management tool opens the vhost device node, calls
>    ioctl(VHOST_SET_VRING_WORKER), sets up CPU affinity, and then passes
>    the fd to the VMM. In this case the VMM is still able to call the
>    ioctl, which may be undesirable from an attack surface perspective.

Yes, and we can't do post or dynamic configuration afterwards after
the VM is launched?

>
> 2. The VMM calls ioctl(VHOST_SET_VRING_WORKER) itself and the management
>    tool queries the vq:worker details from the VMM (e.g. a new QEMU QMP
>    query-vhost-workers command similar to query-iothreads). The
>    management tool can then control CPU affinity on the vhost worker
>    threads.
>
>    (This is how CPU affinity works in QEMU and libvirt today.)

Then we also need a "bind-vhost-workers" command.

>
> 3. The sysfs approach you suggested. Does sysfs export vq-0/, vq-1/, etc
>    directories with a "worker" attribute?

Something like this.

> Do we need to define a point
>    when the VMM has set up vqs and the management stack is able to query
>    them?

It could be the point that the vhost fd is opened.

>  Vhost devices currently pre-allocate the maximum number of vqs
>    and I'm not sure how to determine the number of vqs that will
>    actually be used?

It requires more information to be exposed. But before this, we should
allow the dynamic binding of between vq and worker.

>
>    One advantage of this is that access to the vq:worker mapping can be
>    limited to the management stack and the VMM cannot access it. But it
>    seems a little tricky because the vhost model today doesn't use sysfs
>    or define a lifecycle where the management stack can configure
>    devices.

Yes.

Thanks

>
> Stefan

