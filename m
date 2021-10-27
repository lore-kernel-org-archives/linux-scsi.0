Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF140C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 06:03:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF23C60F9B
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 06:03:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236171AbhJ0GFh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 02:05:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40498 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236058AbhJ0GFg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Oct 2021 02:05:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635314591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dnZrLkCBaK5wFXfWCooWz6upe3zDfgRxQCNxNm3vRdE=;
        b=T5pjQEFks6xZb9xo1lZtKDa5x5tui86vYH18andxiAEkzppf0u6DwJ6t2jR+8MQEyt+WMl
        0a7AtrdMoqGqEUJZBKrPeEjBOofVZ1Wt103j6dmo/BISYMzvkLwRBDC3uz3SAv+wHGv9uV
        kVn+kKxfL4OlQOw7O3SIjrADG2FY+9A=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-39WL-m-sM7O2sIz2EmFEWg-1; Wed, 27 Oct 2021 02:03:09 -0400
X-MC-Unique: 39WL-m-sM7O2sIz2EmFEWg-1
Received: by mail-lf1-f72.google.com with SMTP id f13-20020a056512228d00b003ffd53671d8so208309lfu.14
        for <linux-scsi@vger.kernel.org>; Tue, 26 Oct 2021 23:03:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dnZrLkCBaK5wFXfWCooWz6upe3zDfgRxQCNxNm3vRdE=;
        b=KfVNgtC09oei/aKZywa3jvcH4+DUfsMWnmKu6Xr5rLaJMwizptBQse5dMTNrMwEgPk
         WeEsylENdifoChRPze2+dexpXqF3YKnrqrG9AsqQGKd5tDqIdtDt1plekrKDAqVpdTZr
         Fm3wfocsoRg4FJLXbsT1eV2hHVheYXwtHGAmZofU6YLe/wisiAETZ/7kowGZRERxn1Tb
         Wn8yx/cJsKj47GQhFmLpit1PaYm+JZnp9FnmCRHlueqZebkIPRfXbwM9OYD8WeePBlJI
         AeVmmWDfWXSKHpfzWmqhnuHqroL878Kd8sz9EAw8pLk0Hi2a6Ku79HAaFWqZuhd0HILn
         V+1w==
X-Gm-Message-State: AOAM533S+h2x6WfsoLPVB1k/yxW42CqYAJwYBJDIq2VFFjVs9NfHiGQ7
        dLXmqRc5olBhgv1PT3Cmeew0SVngwArsNnWGDD9etQ5VFUQCh292NUP0Ey6pT3r0eFJPUtil8R2
        FNnc6ZCNONT8jgmf+TIbrCiK2Ox3p9H/iuO9P2w==
X-Received: by 2002:a05:6512:1291:: with SMTP id u17mr9901983lfs.84.1635314587969;
        Tue, 26 Oct 2021 23:03:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxQkkDQClqmU3dFpYeFR2oDSYbiarQrMX+O5rhSz4qv3ql+2LJ9hYbtYwCNezSdtj25uqo2woqP1s/lx/H+m5g=
X-Received: by 2002:a05:6512:1291:: with SMTP id u17mr9901948lfs.84.1635314587688;
 Tue, 26 Oct 2021 23:03:07 -0700 (PDT)
MIME-Version: 1.0
References: <20211022051911.108383-1-michael.christie@oracle.com>
 <20211022051911.108383-13-michael.christie@oracle.com> <8aee8f07-76bd-f111-bc5f-fc5cad46ce56@redhat.com>
 <4d33b7e1-5efb-3729-ee15-98608704f096@oracle.com>
In-Reply-To: <4d33b7e1-5efb-3729-ee15-98608704f096@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 27 Oct 2021 14:02:56 +0800
Message-ID: <CACGkMEv6_VVFWPT-yxO=35EWvGNz0t9-hopF3+Y7g1ugnPDB4g@mail.gmail.com>
Subject: Re: [PATCH V3 11/11] vhost: allow userspace to create workers
To:     Mike Christie <michael.christie@oracle.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        pbonzini <pbonzini@redhat.com>, mst <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Oct 27, 2021 at 12:49 AM <michael.christie@oracle.com> wrote:
>
> On 10/26/21 12:37 AM, Jason Wang wrote:
> >
> > =E5=9C=A8 2021/10/22 =E4=B8=8B=E5=8D=881:19, Mike Christie =E5=86=99=E9=
=81=93:
> >> This patch allows userspace to create workers and bind them to vqs. Yo=
u
> >> can have N workers per dev and also share N workers with M vqs.
> >>
> >> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> >
> >
> > A question, who is the best one to determine the binding? Is it the VMM=
 (Qemu etc) or the management stack? If the latter, it looks to me it's bet=
ter to expose this via sysfs?
>
> I thought it would be where you have management app settings, then the
> management app talks to the qemu control interface like it does when it
> adds new devices on the fly.
>
> A problem with the management app doing it is to handle the RLIMIT_NPROC
> review comment, this patchset:
>
> https://lore.kernel.org/all/20211007214448.6282-1-michael.christie@oracle=
.com/
>
> basically has the kernel do a clone() from the caller's context. So addin=
g
> a worker is like doing the VHOST_SET_OWNER ioctl where it still has to be=
 done
> from a process you can inherit values like the mm, cgroups, and now RLIMI=
Ts.

Right, so as Stefan suggested, we probably need new QMP commands then
management can help there. Then it can satisfy the model you described
above.

>
>
> >> diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vho=
st_types.h
> >> index f7f6a3a28977..af654e3cef0e 100644
> >> --- a/include/uapi/linux/vhost_types.h
> >> +++ b/include/uapi/linux/vhost_types.h
> >> @@ -47,6 +47,18 @@ struct vhost_vring_addr {
> >>       __u64 log_guest_addr;
> >>   };
> >>   +#define VHOST_VRING_NEW_WORKER -1
> >
> >
> > Do we need VHOST_VRING_FREE_WORKER? And I wonder if using dedicated ioc=
tls are better:
> >
> > VHOST_VRING_NEW/FREE_WORKER
> > VHOST_VRING_ATTACH_WORKER
>
>
> We didn't need a free worker, because the kernel handles it for userspace=
. I
> tried to make it easy for userspace because in some cases it may not be a=
ble
> to do syscalls like close on the device. For example if qemu crashes or f=
or
> vhost-scsi we don't do an explicit close during VM shutdown.
>

Ok, the motivation is that if in some cases (e.g the active number of
queues are changed), qemu can choose to free some resources.

> So we start off with the default worker thread that's used by all vqs lik=
e we do
> today. Userspace can then override it by creating a new worker. That also=
 unbinds/
> detaches the existing worker and does a put on the workers refcount. We a=
lso do a
> put on the worker when we stop using it during device shutdown/closure/re=
lease.
> When the worker's refcount goes to zero the kernel deletes it.
>
> I think separating the calls could be helpful though.
>

Ok.

Thanks

