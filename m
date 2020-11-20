Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C565C63777
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 08:46:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 374AB22253
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 08:46:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n8Gqcylg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbgKTIqD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Nov 2020 03:46:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727246AbgKTIqC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Nov 2020 03:46:02 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7116CC0613CF;
        Fri, 20 Nov 2020 00:46:01 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id j19so6717522pgg.5;
        Fri, 20 Nov 2020 00:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zzLhdipAOZ9XDbcgIs0h7PqDNReMT5wMo/AtToftNec=;
        b=n8GqcylgM95SMIeQwGPSut2nXHvOeygSf352H18yjXCxZiKOaeO/jlAMvcHrchT8HY
         TzIU680Wtcs9y2ru8pAdLN94RAd3ywkX70tqYGfhLBHUz1+I7D6EtysIVn8qcMCliVKn
         yB498fx/TXdvr1+NbYvJ2BGM70G00BR001H8UkYxu1SVfNl20G4TVKmRwwT2CuwXNCru
         qrqyU3kPcxGJEb81Am2Nelptu/6ktN7t1k5unnRwOiOrBLzdYVQX0zRQKsOpedUh6kK2
         nutqrMQsdWDUVtCJmTcjiXp+dOMIs+FUYifC93QWZAea7BsQw2+pSjhaTfWVXKslr+NO
         FSHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zzLhdipAOZ9XDbcgIs0h7PqDNReMT5wMo/AtToftNec=;
        b=axliT+qETyGaUR87gn25oZrKkgBcVDRANBgc/EV9XhsZJwE1DazMXqrwxgYemRB+hR
         YqI4P1IdkrH4mauV97XP0JHXK+O8ZehYPRNwzuS8El0I5b+7lzxVDpxHehVosw5lC+Va
         hP5cW3Lt5To2qF1fCdEBU9qua/LqLvGINyIRKZritwvydJ3A7IYgc4AqmRFteGVTck7X
         3Fj/q0veYUPBVUCRXMNYPtt5d01MirAC6qJBBxHETkd07Iy1sgmKMuPu+CJVG0iudU0P
         G0sGW/WtX9p2BAYiTVmcPnKriNVyil1qC2nG5zpVZiPbTuMLz91w9+1OLT7C+yOqiRxt
         uFPg==
X-Gm-Message-State: AOAM533bFIik8goXMZSQlyM0pySCHGyrV+etP0h0QmwC5lh4pEmP5UgL
        hwu9p3jN7OZxKrPuZqfjm+3xniHOSkkD1VNV/ihKOKIqhKBIqA==
X-Google-Smtp-Source: ABdhPJwBAXGphEVi30nMDVfjF2cmDlkL9jj8SyvK56Jd2R64dGyHl7cXJfapXWClM+dJeOj6Ndmy9jW0HRU/cO4mJeY=
X-Received: by 2002:a62:7ac2:0:b029:18b:c5bb:303d with SMTP id
 v185-20020a627ac20000b029018bc5bb303dmr13010657pfc.71.1605861960893; Fri, 20
 Nov 2020 00:46:00 -0800 (PST)
MIME-Version: 1.0
References: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
 <20201117164043.GS131917@stefanha-x1.localdomain> <b3343762-bb11-b750-46ec-43b5556f2b8e@oracle.com>
 <20201118113117.GF182763@stefanha-x1.localdomain> <20201119094315-mutt-send-email-mst@kernel.org>
 <ceebdc90-3ffc-1563-ff85-12a848bcba18@oracle.com> <CAJSP0QUvSwX5NCPmfSODV_C+D41E21LZT=oXQ2PLc6baAsGGDQ@mail.gmail.com>
 <ffd88f0c-981e-a102-4b08-f29d6b9a0f71@oracle.com> <CAJSP0QUfqd=QNFa-RikH4dVcLmfcP-pYCwznP3W0zobYkM+KDw@mail.gmail.com>
In-Reply-To: <CAJSP0QUfqd=QNFa-RikH4dVcLmfcP-pYCwznP3W0zobYkM+KDw@mail.gmail.com>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Fri, 20 Nov 2020 08:45:49 +0000
Message-ID: <CAJSP0QVu4P6c+kdFkhw1S_OEaj7B-eiDqFOVDxWAaSOcsAADrA@mail.gmail.com>
Subject: Re: [PATCH 00/10] vhost/qemu: thread per IO SCSI vq
To:     Mike Christie <michael.christie@oracle.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, fam <fam@euphon.net>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        target-devel <target-devel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Nov 19, 2020 at 5:08 PM Stefan Hajnoczi <stefanha@gmail.com> wrote:
>
> On Thu, Nov 19, 2020 at 4:43 PM Mike Christie
> <michael.christie@oracle.com> wrote:
> >
> > On 11/19/20 10:24 AM, Stefan Hajnoczi wrote:
> > > On Thu, Nov 19, 2020 at 4:13 PM Mike Christie
> > > <michael.christie@oracle.com> wrote:
> > >>
> > >> On 11/19/20 8:46 AM, Michael S. Tsirkin wrote:
> > >>> On Wed, Nov 18, 2020 at 11:31:17AM +0000, Stefan Hajnoczi wrote:
> > > struct vhost_run_worker_info {
> > >      struct timespec *timeout;
> > >      sigset_t *sigmask;
> > >
> > >      /* List of virtqueues to process */
> > >      unsigned nvqs;
> > >      unsigned vqs[];
> > > };
> > >
> > > /* This blocks until the timeout is reached, a signal is received, or
> > > the vhost device is destroyed */
> > > int ret = ioctl(vhost_fd, VHOST_RUN_WORKER, &info);
> > >
> > > As you can see, userspace isn't involved with dealing with the
> > > requests. It just acts as a thread donor to the vhost driver.
> > >
> > > We would want the VHOST_RUN_WORKER calls to be infrequent to avoid the
> > > penalty of switching into the kernel, copying in the arguments, etc.
> >
> > I didn't get this part. Why have the timeout? When the timeout expires,
> > does userspace just call right back down to the kernel or does it do
> > some sort of processing/operation?
> >
> > You could have your worker function run from that ioctl wait for a
> > signal or a wake up call from the vhost_work/poll functions.
>
> An optional timeout argument is common in blocking interfaces like
> poll(2), recvmmsg(2), etc.
>
> Although something can send a signal to the thread instead,
> implementing that in an application is more awkward than passing a
> struct timespec.
>
> Compared to other blocking calls we don't expect
> ioctl(VHOST_RUN_WORKER) to return soon, so maybe the timeout will
> rarely be used and can be dropped from the interface.
>
> BTW the code I posted wasn't a carefully thought out proposal :). The
> details still need to be considered and I'm going to be offline for
> the next week so maybe someone else can think it through in the
> meantime.

One final thought before I'm offline for a week. If
ioctl(VHOST_RUN_WORKER) is specific to a single vhost device instance
then it's hard to support poll-mode (busy waiting) workers because
each device instance consumes a whole CPU. If we stick to an interface
where the kernel manages the worker threads then it's easier to share
workers between devices for polling.

I have CCed Stefano Garzarella, who is looking at similar designs for
vDPA software device implementations.

Stefan
