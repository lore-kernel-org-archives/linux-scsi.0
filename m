Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3431C63697
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 15:18:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0F2A20773
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 15:18:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b5rM3KRp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732197AbgKWPSM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 10:18:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56561 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729718AbgKWPSI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Nov 2020 10:18:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606144686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Gjysr2TGm2BHd6PEXB4bmvN9WC4d9mZ2jNM8y3Hhwb0=;
        b=b5rM3KRpboVvjfUCresSJNtz5mgUfnWvnmLcFWrNdPwzxcylDKfP+MDJV3YXu1FFPgGaKw
        Cnkg4BwonuIgAX1JKSwDn7ynhbFZ9O2GSGqOmfrrcvu+p+9QL1vMaWVcPoi1hEUki4HB3W
        w490bNDeUShcx8i92VC38+9OaA2uig8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-8C_y2n_aMUevURm99tY-iQ-1; Mon, 23 Nov 2020 10:18:04 -0500
X-MC-Unique: 8C_y2n_aMUevURm99tY-iQ-1
Received: by mail-wm1-f71.google.com with SMTP id y21so5176194wma.6
        for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2020 07:18:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Gjysr2TGm2BHd6PEXB4bmvN9WC4d9mZ2jNM8y3Hhwb0=;
        b=K85PvKjlA8I/+qfwaoC/Of9lgth0JC2waYJPHRNwBQhs9ITUTiw+Jq8FZBZuX8HfyK
         2c/MxNV9AJFQD/PFSbJvjFwYqlUjbPEGl65FFo/NsKVJSZADpz5ABQl1bW6jdFYRrBb2
         /cJEqUwoAaDAzpXIblbRZF5U9V/fvG6gVH/+Ls1H+ZAf1+n7Z8WIUlow/vg/puGtZTMP
         2jBbIFNLZTXHrEXQW4Zm2OHU9GO3TKhBrR2j1xHmHqRkI6sLISwTdKTp8idD9W3AEHK7
         nI9k+CSe5oWQ58QJJiO1gEII4ueJHbYKJb9Ny6gevBFyTXEHjmEwcmGQGfqp6KkWSKbu
         IHVA==
X-Gm-Message-State: AOAM532lbeczpt7MM+qQ3ZvXp54zYpQBHp2I4aNryjJQ3in9GGNCJT7K
        V5SOCQvB3N7HCXlNqvFpIpPB9TxxNL9Nzgv+zDdB5U3mTS7u/jz0Sw5sQNsINBnVTiXlPDjHIG2
        Icng4gBcD+KdZEtixJULpaQ==
X-Received: by 2002:adf:e84e:: with SMTP id d14mr145424wrn.190.1606144683206;
        Mon, 23 Nov 2020 07:18:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy2R4lL1Mq2Y1aVC5dDdaeyjFkJP6dOyeHTSlEN3C3ieAvijxPn9ns3PNbleWjgoJ6rtHRlSg==
X-Received: by 2002:adf:e84e:: with SMTP id d14mr145403wrn.190.1606144682981;
        Mon, 23 Nov 2020 07:18:02 -0800 (PST)
Received: from steredhat (host-79-17-248-175.retail.telecomitalia.it. [79.17.248.175])
        by smtp.gmail.com with ESMTPSA id n4sm15266610wmc.30.2020.11.23.07.18.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 07:18:02 -0800 (PST)
Date:   Mon, 23 Nov 2020 16:17:58 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     Mike Christie <michael.christie@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, fam <fam@euphon.net>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        target-devel <target-devel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 00/10] vhost/qemu: thread per IO SCSI vq
Message-ID: <20201123151758.5bik46pu4aqrtmd5@steredhat>
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
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAJSP0QVu4P6c+kdFkhw1S_OEaj7B-eiDqFOVDxWAaSOcsAADrA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Nov 20, 2020 at 08:45:49AM +0000, Stefan Hajnoczi wrote:
>On Thu, Nov 19, 2020 at 5:08 PM Stefan Hajnoczi <stefanha@gmail.com> wrote:
>>
>> On Thu, Nov 19, 2020 at 4:43 PM Mike Christie
>> <michael.christie@oracle.com> wrote:
>> >
>> > On 11/19/20 10:24 AM, Stefan Hajnoczi wrote:
>> > > On Thu, Nov 19, 2020 at 4:13 PM Mike Christie
>> > > <michael.christie@oracle.com> wrote:
>> > >>
>> > >> On 11/19/20 8:46 AM, Michael S. Tsirkin wrote:
>> > >>> On Wed, Nov 18, 2020 at 11:31:17AM +0000, Stefan Hajnoczi wrote:
>> > > struct vhost_run_worker_info {
>> > >      struct timespec *timeout;
>> > >      sigset_t *sigmask;
>> > >
>> > >      /* List of virtqueues to process */
>> > >      unsigned nvqs;
>> > >      unsigned vqs[];
>> > > };
>> > >
>> > > /* This blocks until the timeout is reached, a signal is received, or
>> > > the vhost device is destroyed */
>> > > int ret = ioctl(vhost_fd, VHOST_RUN_WORKER, &info);
>> > >
>> > > As you can see, userspace isn't involved with dealing with the
>> > > requests. It just acts as a thread donor to the vhost driver.
>> > >
>> > > We would want the VHOST_RUN_WORKER calls to be infrequent to avoid the
>> > > penalty of switching into the kernel, copying in the arguments, etc.
>> >
>> > I didn't get this part. Why have the timeout? When the timeout expires,
>> > does userspace just call right back down to the kernel or does it do
>> > some sort of processing/operation?
>> >
>> > You could have your worker function run from that ioctl wait for a
>> > signal or a wake up call from the vhost_work/poll functions.
>>
>> An optional timeout argument is common in blocking interfaces like
>> poll(2), recvmmsg(2), etc.
>>
>> Although something can send a signal to the thread instead,
>> implementing that in an application is more awkward than passing a
>> struct timespec.
>>
>> Compared to other blocking calls we don't expect
>> ioctl(VHOST_RUN_WORKER) to return soon, so maybe the timeout will
>> rarely be used and can be dropped from the interface.
>>
>> BTW the code I posted wasn't a carefully thought out proposal :). The
>> details still need to be considered and I'm going to be offline for
>> the next week so maybe someone else can think it through in the
>> meantime.
>
>One final thought before I'm offline for a week. If
>ioctl(VHOST_RUN_WORKER) is specific to a single vhost device instance
>then it's hard to support poll-mode (busy waiting) workers because
>each device instance consumes a whole CPU. If we stick to an interface
>where the kernel manages the worker threads then it's easier to share
>workers between devices for polling.

Agree, ioctl(VHOST_RUN_WORKER) is interesting and perhaps simplifies 
thread management (pinning, etc.), but with kthread would be easier to 
implement polling sharing worker with multiple devices.

>
>I have CCed Stefano Garzarella, who is looking at similar designs for
>vDPA software device implementations.

Thanks, Mike please can you keep me in CC for this work?

It's really interesting since I'll have similar issues to solve with 
vDPA software device.

Thanks,
Stefano

