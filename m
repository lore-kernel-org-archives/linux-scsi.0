Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37346C64E8A
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 10:36:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C75002222E
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 10:36:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgLBKgz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 05:36:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59258 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725885AbgLBKgz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 05:36:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606905327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3biZU2ib5viPRJCou3JOHYRY94yDNXXShVi1+6C8pEw=;
        b=IzQXJzBAjycUrhLr9xhHK2p2D74eiS8+5IVu5qzk6/+BnMf7xfXYKkboMIBCPQzYqotPOY
        +QCitP+Xtg5hbCKgbmO3LEz12/rB23vLtpEixYyu8XPVr3+gs9sjX7V98L8VYRE4brqvIJ
        DqIDbz+Jo4FLahwddY7FyWg2NLNWamU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-qC3VUZNAOSulBngPQ1LX4Q-1; Wed, 02 Dec 2020 05:35:26 -0500
X-MC-Unique: qC3VUZNAOSulBngPQ1LX4Q-1
Received: by mail-wm1-f69.google.com with SMTP id z16so1980440wma.1
        for <linux-scsi@vger.kernel.org>; Wed, 02 Dec 2020 02:35:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3biZU2ib5viPRJCou3JOHYRY94yDNXXShVi1+6C8pEw=;
        b=gu8fXSP8rfNPuMBNW/r1bGeU/DNGuSCz1ep5+GTlRp4NamBHgMkgi8rUi6JvpjuMtz
         K4P2RXKFWJe3Z9sF4VdZLFe1nsA+5Ne8ZRRhC33ov6Yzs8VjCY/kBGYp2d7pdtrMroRT
         E5Ac7Z+VnelxFUeMRmo9+cPtsDt3I/R4T6PWNAZkKkw3UEN+DiT2wyOgVlhcDFAflvvE
         al7y2kvVvJoHOZWgKVrRKJunCEm1rErqX9FYCbRJTUccZf4pFCwDRisS8oGhyYT8ky/V
         ZfEJbzyICrucGM9MJK7I4AGGbxHA4g7F9qpNZHFGykLTBPo19dYaZE/AFthzKHnf/+kz
         PZDw==
X-Gm-Message-State: AOAM533hiVN8vkcf1oZ+eqTpSl1c+VJb5JXr8CRGAqD2F6dul8yftOWx
        GSfT2JfT5FfxdV6rUqNtr/RD8Z8/jTSPTA6FL+zZxsm8kXzW2Tkc/YXP+e1vocc1Ihb1U+6SWge
        lPeMMw1+P2TpvNF0M7wXkIQ==
X-Received: by 2002:adf:e444:: with SMTP id t4mr2612647wrm.152.1606905324179;
        Wed, 02 Dec 2020 02:35:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy1G52zx/D6FTjkqg/WRk+lsbXo1JOGnu/Zs55bQdmcV/Xo+k5q5tdEbmGqxIbc8Io7T5XkVg==
X-Received: by 2002:adf:e444:: with SMTP id t4mr2612627wrm.152.1606905323904;
        Wed, 02 Dec 2020 02:35:23 -0800 (PST)
Received: from steredhat (host-79-17-248-175.retail.telecomitalia.it. [79.17.248.175])
        by smtp.gmail.com with ESMTPSA id n189sm1482761wmf.20.2020.12.02.02.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 02:35:23 -0800 (PST)
Date:   Wed, 2 Dec 2020 11:35:20 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        Mike Christie <michael.christie@oracle.com>,
        fam <fam@euphon.net>, linux-scsi <linux-scsi@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        target-devel <target-devel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 00/10] vhost/qemu: thread per IO SCSI vq
Message-ID: <20201202103520.qpyzdzsqi3aw7fii@steredhat>
References: <20201119094315-mutt-send-email-mst@kernel.org>
 <ceebdc90-3ffc-1563-ff85-12a848bcba18@oracle.com>
 <CAJSP0QUvSwX5NCPmfSODV_C+D41E21LZT=oXQ2PLc6baAsGGDQ@mail.gmail.com>
 <ffd88f0c-981e-a102-4b08-f29d6b9a0f71@oracle.com>
 <CAJSP0QUfqd=QNFa-RikH4dVcLmfcP-pYCwznP3W0zobYkM+KDw@mail.gmail.com>
 <CAJSP0QVu4P6c+kdFkhw1S_OEaj7B-eiDqFOVDxWAaSOcsAADrA@mail.gmail.com>
 <20201120072802-mutt-send-email-mst@kernel.org>
 <20201201125943.GE585157@stefanha-x1.localdomain>
 <20201201134518.pwrggkmixpyro4sg@steredhat>
 <20201201174338.GB595829@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201201174338.GB595829@stefanha-x1.localdomain>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Dec 01, 2020 at 05:43:38PM +0000, Stefan Hajnoczi wrote:
>On Tue, Dec 01, 2020 at 02:45:18PM +0100, Stefano Garzarella wrote:
>> On Tue, Dec 01, 2020 at 12:59:43PM +0000, Stefan Hajnoczi wrote:
>> > On Fri, Nov 20, 2020 at 07:31:08AM -0500, Michael S. Tsirkin wrote:
>> > > On Fri, Nov 20, 2020 at 08:45:49AM +0000, Stefan Hajnoczi wrote:
>> > > > On Thu, Nov 19, 2020 at 5:08 PM Stefan Hajnoczi <stefanha@gmail.com> wrote:
>> > > > >
>> > > > > On Thu, Nov 19, 2020 at 4:43 PM Mike Christie
>> > > > > <michael.christie@oracle.com> wrote:
>> > > > > >
>> > > > > > On 11/19/20 10:24 AM, Stefan Hajnoczi wrote:
>> > > > > > > On Thu, Nov 19, 2020 at 4:13 PM Mike Christie
>> > > > > > > <michael.christie@oracle.com> wrote:
>> > > > > > >>
>> > > > > > >> On 11/19/20 8:46 AM, Michael S. Tsirkin wrote:
>> > > > > > >>> On Wed, Nov 18, 2020 at 11:31:17AM +0000, Stefan Hajnoczi wrote:
>> > > > > > > struct vhost_run_worker_info {
>> > > > > > >      struct timespec *timeout;
>> > > > > > >      sigset_t *sigmask;
>> > > > > > >
>> > > > > > >      /* List of virtqueues to process */
>> > > > > > >      unsigned nvqs;
>> > > > > > >      unsigned vqs[];
>> > > > > > > };
>> > > > > > >
>> > > > > > > /* This blocks until the timeout is reached, a signal is received, or
>> > > > > > > the vhost device is destroyed */
>> > > > > > > int ret = ioctl(vhost_fd, VHOST_RUN_WORKER, &info);
>> > > > > > >
>> > > > > > > As you can see, userspace isn't involved with dealing with the
>> > > > > > > requests. It just acts as a thread donor to the vhost driver.
>> > > > > > >
>> > > > > > > We would want the VHOST_RUN_WORKER calls to be infrequent to avoid the
>> > > > > > > penalty of switching into the kernel, copying in the arguments, etc.
>> > > > > >
>> > > > > > I didn't get this part. Why have the timeout? When the timeout expires,
>> > > > > > does userspace just call right back down to the kernel or does it do
>> > > > > > some sort of processing/operation?
>> > > > > >
>> > > > > > You could have your worker function run from that ioctl wait for a
>> > > > > > signal or a wake up call from the vhost_work/poll functions.
>> > > > >
>> > > > > An optional timeout argument is common in blocking interfaces like
>> > > > > poll(2), recvmmsg(2), etc.
>> > > > >
>> > > > > Although something can send a signal to the thread instead,
>> > > > > implementing that in an application is more awkward than passing a
>> > > > > struct timespec.
>> > > > >
>> > > > > Compared to other blocking calls we don't expect
>> > > > > ioctl(VHOST_RUN_WORKER) to return soon, so maybe the timeout will
>> > > > > rarely be used and can be dropped from the interface.
>> > > > >
>> > > > > BTW the code I posted wasn't a carefully thought out proposal 
>> > > > > :). The
>> > > > > details still need to be considered and I'm going to be offline for
>> > > > > the next week so maybe someone else can think it through in the
>> > > > > meantime.
>> > > >
>> > > > One final thought before I'm offline for a week. If
>> > > > ioctl(VHOST_RUN_WORKER) is specific to a single vhost device instance
>> > > > then it's hard to support poll-mode (busy waiting) workers because
>> > > > each device instance consumes a whole CPU. If we stick to an interface
>> > > > where the kernel manages the worker threads then it's easier to 
>> > > > share
>> > > > workers between devices for polling.
>> > >
>> > >
>> > > Yes that is the reason vhost did its own reason in the first place.
>> > >
>> > >
>> > > I am vaguely thinking about poll(2) or a similar interface,
>> > > which can wait for an event on multiple FDs.
>> >
>> > I can imagine how using poll(2) would work from a userspace perspective,
>> > but on the kernel side I don't think it can be implemented cleanly.
>> > poll(2) is tied to the file_operations->poll() callback and
>> > read/write/error events. Not to mention there isn't a way to substitue
>> > the vhost worker thread function instead of scheduling out the current
>> > thread while waiting for poll fd events.
>> >
>> > But maybe ioctl(VHOST_WORKER_RUN) can do it:
>> >
>> >  struct vhost_run_worker_dev {
>> >      int vhostfd;      /* /dev/vhost-TYPE fd */
>> >      unsigned nvqs;    /* number of virtqueues in vqs[] */
>> >      unsigned vqs[];   /* virtqueues to process */
>> >  };
>> >
>> >  struct vhost_run_worker_info {
>> >       struct timespec *timeout;
>> >       sigset_t *sigmask;
>> >
>> >       unsigned ndevices;
>> >       struct vhost_run_worker_dev *devices[];
>> >  };
>> >
>> > In the simple case userspace sets ndevices to 1 and we just handle
>> > virtqueues for the current device.
>> >
>> > In the fancier shared worker thread case the userspace process has the
>> > vhost fds of all the devices it is processing and passes them to
>> > ioctl(VHOST_WORKER_RUN) via struct vhost_run_worker_dev elements.
>>
>> Which fd will be used for this IOCTL? One of the 'vhostfd' or we should
>> create a new /dev/vhost-workers (or something similar)?
>>
>> Maybe the new device will be cleaner and can be reused also for other stuff
>> (I'm thinking about vDPA software devices).
>>
>> >
>> > From a security perspective it means the userspace thread has access to
>> > all vhost devices (because it has their fds).
>> >
>> > I'm not sure how the mm is supposed to work. The devices might be
>> > associated with different userspace processes (guests) and therefore
>> > have different virtual memory.
>>
>> Maybe in this case we should do something similar to io_uring SQPOLL kthread
>> where kthread_use_mm()/kthread_unuse_mm() is used to switch virtual memory
>> spaces.
>>
>> After writing, I saw that we already do it this in the vhost_worker() in
>> drivers/vhost/vhost.c
>>
>> >
>> > Just wanted to push this discussion along a little further. I'm buried
>> > under emails and probably wont be very active over the next few days.
>> >
>>
>> I think ioctl(VHOST_WORKER_RUN) might be the right way and also maybe the
>> least difficult one.
>
>Sending an ioctl API proposal email could help progress this 
>discussion.
>
>Interesting questions:
>1. How to specify which virtqueues to process (Mike's use case)?
>2. How to process multiple devices?
>

Okay, I'll try to prepare a tentative proposal next week with that 
questions in mind :-)

Thanks,
Stefano

