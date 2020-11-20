Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0711C63777
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 12:31:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BFB02087D
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 12:31:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Oeg+aEXh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbgKTMbT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Nov 2020 07:31:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27833 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726559AbgKTMbT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Nov 2020 07:31:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605875477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ocK86ENwpJGmMxdlo0mfB3bMPeCsw3DadrlnqYb0ooI=;
        b=Oeg+aEXhkgRd0O1/JSAl2iysutQ2D0m6qje6XJhWkhRu22QqDXfq6Nsz5u04lko12fRJLE
        kZJrHlyILQDqc+aEvZZ/gV3cThdAmjUjlRRIW/EeJOI8b7AM2tdRKpppWU6By7AxQqrVB1
        nV8MX2bE3+TMWmUqV+pMjW8XUVpimG8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-c5IJV4NvMl2MgPobeuX0QQ-1; Fri, 20 Nov 2020 07:31:15 -0500
X-MC-Unique: c5IJV4NvMl2MgPobeuX0QQ-1
Received: by mail-wm1-f72.google.com with SMTP id o19so3992751wme.2
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2020 04:31:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ocK86ENwpJGmMxdlo0mfB3bMPeCsw3DadrlnqYb0ooI=;
        b=lTpstEvI96owLbh0tswSMjrgCGOUQO91mY/QelkxZPXfeZHwkxta1MANAtsuB+m1vD
         1sZIC3MfXVV1dfM5B4+YjN9VxVlYgqFgYgTybIh8PoArzmMeugZVzsVRJ+OW+RbdHGQ3
         Ivho/fVisuIEb9f3piXEWss5KLPCX+S0IyrNTeHH8o9JpVV+ygW598rFAhQyJ2GUQCSe
         fRMeaj1fuU3FRa8YkfXx+30Xwq6REKzsFcwvr2IzGAB6jPrn1xt3LWj0r5BMxDdoEmYJ
         JcKRHe13DYJUzNaVo4gaXB5S+06uCdCWMEydJ2AHQuPHkeLwaEp4oCG5l6lokZQU9vQM
         b+zA==
X-Gm-Message-State: AOAM532+U6Sq5+6Ft7RWnTowi98bE6nnvunUgaQbc/sl9zdIcPghSAx9
        0ECXPEGDToCkvleTEN3gjlolBWXUWAw/SqK7kL0iEXjfR1yBvLUKoPTOdHivIg8k1ADxK9POR5X
        bfYFE2Kbl/vzkNMKu5LHDvQ==
X-Received: by 2002:a5d:6a83:: with SMTP id s3mr15575451wru.397.1605875474261;
        Fri, 20 Nov 2020 04:31:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz5yeyXryHim+8cbbaVgxlvvJwdtVTGEJ7CX1LFkcQa+sotAPHYcwKeUvV6gKolUT2mX0mACQ==
X-Received: by 2002:a5d:6a83:: with SMTP id s3mr15575426wru.397.1605875474024;
        Fri, 20 Nov 2020 04:31:14 -0800 (PST)
Received: from redhat.com (bzq-79-176-44-197.red.bezeqint.net. [79.176.44.197])
        by smtp.gmail.com with ESMTPSA id v6sm5115620wrb.53.2020.11.20.04.31.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 04:31:12 -0800 (PST)
Date:   Fri, 20 Nov 2020 07:31:08 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     Mike Christie <michael.christie@oracle.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, fam <fam@euphon.net>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        target-devel <target-devel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: Re: [PATCH 00/10] vhost/qemu: thread per IO SCSI vq
Message-ID: <20201120072802-mutt-send-email-mst@kernel.org>
References: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
 <20201117164043.GS131917@stefanha-x1.localdomain>
 <b3343762-bb11-b750-46ec-43b5556f2b8e@oracle.com>
 <20201118113117.GF182763@stefanha-x1.localdomain>
 <20201119094315-mutt-send-email-mst@kernel.org>
 <ceebdc90-3ffc-1563-ff85-12a848bcba18@oracle.com>
 <CAJSP0QUvSwX5NCPmfSODV_C+D41E21LZT=oXQ2PLc6baAsGGDQ@mail.gmail.com>
 <ffd88f0c-981e-a102-4b08-f29d6b9a0f71@oracle.com>
 <CAJSP0QUfqd=QNFa-RikH4dVcLmfcP-pYCwznP3W0zobYkM+KDw@mail.gmail.com>
 <CAJSP0QVu4P6c+kdFkhw1S_OEaj7B-eiDqFOVDxWAaSOcsAADrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJSP0QVu4P6c+kdFkhw1S_OEaj7B-eiDqFOVDxWAaSOcsAADrA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Nov 20, 2020 at 08:45:49AM +0000, Stefan Hajnoczi wrote:
> On Thu, Nov 19, 2020 at 5:08 PM Stefan Hajnoczi <stefanha@gmail.com> wrote:
> >
> > On Thu, Nov 19, 2020 at 4:43 PM Mike Christie
> > <michael.christie@oracle.com> wrote:
> > >
> > > On 11/19/20 10:24 AM, Stefan Hajnoczi wrote:
> > > > On Thu, Nov 19, 2020 at 4:13 PM Mike Christie
> > > > <michael.christie@oracle.com> wrote:
> > > >>
> > > >> On 11/19/20 8:46 AM, Michael S. Tsirkin wrote:
> > > >>> On Wed, Nov 18, 2020 at 11:31:17AM +0000, Stefan Hajnoczi wrote:
> > > > struct vhost_run_worker_info {
> > > >      struct timespec *timeout;
> > > >      sigset_t *sigmask;
> > > >
> > > >      /* List of virtqueues to process */
> > > >      unsigned nvqs;
> > > >      unsigned vqs[];
> > > > };
> > > >
> > > > /* This blocks until the timeout is reached, a signal is received, or
> > > > the vhost device is destroyed */
> > > > int ret = ioctl(vhost_fd, VHOST_RUN_WORKER, &info);
> > > >
> > > > As you can see, userspace isn't involved with dealing with the
> > > > requests. It just acts as a thread donor to the vhost driver.
> > > >
> > > > We would want the VHOST_RUN_WORKER calls to be infrequent to avoid the
> > > > penalty of switching into the kernel, copying in the arguments, etc.
> > >
> > > I didn't get this part. Why have the timeout? When the timeout expires,
> > > does userspace just call right back down to the kernel or does it do
> > > some sort of processing/operation?
> > >
> > > You could have your worker function run from that ioctl wait for a
> > > signal or a wake up call from the vhost_work/poll functions.
> >
> > An optional timeout argument is common in blocking interfaces like
> > poll(2), recvmmsg(2), etc.
> >
> > Although something can send a signal to the thread instead,
> > implementing that in an application is more awkward than passing a
> > struct timespec.
> >
> > Compared to other blocking calls we don't expect
> > ioctl(VHOST_RUN_WORKER) to return soon, so maybe the timeout will
> > rarely be used and can be dropped from the interface.
> >
> > BTW the code I posted wasn't a carefully thought out proposal :). The
> > details still need to be considered and I'm going to be offline for
> > the next week so maybe someone else can think it through in the
> > meantime.
> 
> One final thought before I'm offline for a week. If
> ioctl(VHOST_RUN_WORKER) is specific to a single vhost device instance
> then it's hard to support poll-mode (busy waiting) workers because
> each device instance consumes a whole CPU. If we stick to an interface
> where the kernel manages the worker threads then it's easier to share
> workers between devices for polling.


Yes that is the reason vhost did its own reason in the first place.


I am vaguely thinking about poll(2) or a similar interface,
which can wait for an event on multiple FDs.


> I have CCed Stefano Garzarella, who is looking at similar designs for
> vDPA software device implementations.
> 
> Stefan

