Return-Path: <SRS0=glVe=EF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4B98C55179
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 08:47:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3616020704
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 08:47:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iCGOZDpt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725875AbgJ3Irf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Oct 2020 04:47:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28224 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbgJ3Irf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Oct 2020 04:47:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604047653;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OowK7sEL9WYawE8HtiZ4y/bzMNMCZEory9yOR9ZIFgY=;
        b=iCGOZDptev63WZfKzyQV0yBX9gYS0GVjVQEVrw2MM1BOw1eWDTQMe/AhJ0y1ntUMwRUsLv
        P2LWYrJDUG1CpV9Yhq0hdzWyQFhbmmJ9o2NUX5VIPmFlrwDYVNS1zDyplpZiH6Ki1iBHEk
        HkLCvvVjo8sG+YbeQ2sq3jC5h+vDv8E=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-SnK6bQsbNda0jL-EwizChg-1; Fri, 30 Oct 2020 04:47:31 -0400
X-MC-Unique: SnK6bQsbNda0jL-EwizChg-1
Received: by mail-wr1-f71.google.com with SMTP id u1so117376wri.6
        for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2020 01:47:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=OowK7sEL9WYawE8HtiZ4y/bzMNMCZEory9yOR9ZIFgY=;
        b=cuqUlhHHjKPixoWB6gtqmC+w3DonX/VY6dkZXhSfFyaq3nYtTdEwanpyzmupMyRUrn
         qv4lMPrTJE6mo9hhVX6qk1Y00X7eglnDj9iJL4it9Q2MO4I1NK8lPctNFfU/kEC6BE5V
         270DtNZZjrd8lN3IkeMFgN/CQ8QUi2kTeqD2z/5YuQFpVov5kKfDbxdAXAH9lPaREVKV
         Dxl6wAwRhuJXWmDHjDDYU1GXt8+RPjcQ5Mnr0zR30DohHsfQfKkrOCc9tXCwuub9oDt/
         cEcky16TTzRSSfj50Y0Na2W7sjwkHM6oWs9D00/M5HJmKPZo9V8CEzDms+FGiTfPqQFj
         UzEw==
X-Gm-Message-State: AOAM530Q8PVq3hicHJGjlptBTnQPuX+BBCbGIEdvGB2dVVniRQdAiHmc
        pF1zhGhPlCQIh9jWamkGByGZ1UnXJa86nj/9l3WzCDlnD2Mymod0RfFUkeuBVEDXNzCMtphOGPI
        1g4AamYhK/VTOYr9SpFcIaA==
X-Received: by 2002:adf:e40e:: with SMTP id g14mr1514368wrm.285.1604047650234;
        Fri, 30 Oct 2020 01:47:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwX0VUnp1F7pR6WRrcOB29Hkdk2r6gE37I/8kD5eGOV2J1UWZXMq2SjTH7D/hE2cwGkfYz5iQ==
X-Received: by 2002:adf:e40e:: with SMTP id g14mr1514342wrm.285.1604047649952;
        Fri, 30 Oct 2020 01:47:29 -0700 (PDT)
Received: from redhat.com (bzq-79-176-118-93.red.bezeqint.net. [79.176.118.93])
        by smtp.gmail.com with ESMTPSA id t7sm9232775wrx.42.2020.10.30.01.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 01:47:29 -0700 (PDT)
Date:   Fri, 30 Oct 2020 04:47:26 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     Jason Wang <jasowang@redhat.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 07/17] vhost scsi: support delayed IO vq creation
Message-ID: <20201030044402-mutt-send-email-mst@kernel.org>
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
 <1603326903-27052-8-git-send-email-michael.christie@oracle.com>
 <9e97ea2a-bc57-d4aa-4711-35dba20b3b9e@redhat.com>
 <49c2fc29-348c-06db-4823-392f7476d318@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49c2fc29-348c-06db-4823-392f7476d318@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Oct 27, 2020 at 12:47:34AM -0500, Mike Christie wrote:
> On 10/25/20 10:51 PM, Jason Wang wrote:
> > 
> > On 2020/10/22 上午8:34, Mike Christie wrote:
> > > Each vhost-scsi device will need a evt and ctl queue, but the number
> > > of IO queues depends on whatever the user has configured in userspace.
> > > This patch has vhost-scsi create the evt, ctl and one IO vq at device
> > > open time. We then create the other IO vqs when userspace starts to
> > > set them up. We still waste some mem on the vq and scsi vq structs,
> > > but we don't waste mem on iovec related arrays and for later patches
> > > we know which queues are used by the dev->nvqs value.
> > > 
> > > Signed-off-by: Mike Christie <michael.christie@oracle.com>
> > > ---
> > >   drivers/vhost/scsi.c | 19 +++++++++++++++----
> > >   1 file changed, 15 insertions(+), 4 deletions(-)
> > 
> > 
> > Not familiar with SCSI. But I wonder if it could behave like vhost-net.
> > 
> > E.g userspace should known the number of virtqueues so it can just open
> > and close multiple vhost-scsi file descriptors.
> > 
> 
> One hiccup I'm hitting is that we might end up creating about 3x more vqs
> than we need. The problem is that for scsi each vhost device has:
> 
> vq=0: special control vq
> vq=1: event vq
> vq=2 and above: SCSI CMD/IO vqs. We want to create N of these.
> 
> Today we do:
> 
> Uerspace does open(/dev/vhost-scsi)
>         vhost_dev_init(create 128 vqs and then later we setup and use N of
> them);
> 
> Qemu does ioctl(VHOST_SET_OWNER)
>         vhost_dev_set_owner()
> 
> For N vqs userspace does:
>         // virtqueue setup related ioctls
> 
> Qemu does ioctl(VHOST_SCSI_SET_ENDPOINT)
>         - match LIO/target port to vhost_dev
> 
> 
> So we could change that to:
> 
> For N IO vqs userspace does
>         open(/dev/vhost-scsi)
>                 vhost_dev_init(create IO, evt, and ctl);
> 
> for N IO vqs Qemu does:
>         ioctl(VHOST_SET_OWNER)
>                 vhost_dev_set_owner()
> 
> for N IO vqs Qemu does:
>         // virtqueue setup related ioctls
> 
> for N IO vqs Qemu does:
>         ioctl(VHOST_SCSI_SET_ENDPOINT)
>                 - match LIO/target port to vhost_dev and assemble the
> multiple vhost_dev device.
> 
> The problem is that we have to setup some of the evt/ctl specific parts at
> open() time when vhost_dev_init does vhost_poll_init for example.
> 
> - At open time, we don't know if this vhost_dev is going to be part of a
> multiple vhost_device device or a single one so we need to create at least 3
> of them
> - If it is a multiple device we don't know if its the first device being
> created for the device or the N'th, so we don't know if the dev's vqs will
> be used for IO or ctls/evts, so we have to create all 3.
> 
> When we get the first VHOST_SCSI_SET_ENDPOINT call for a new style multiple
> vhost_dev device, we can use that dev's evt/ctl vqs for events/controls
> requests. When we get the other VHOST_SCSI_SET_ENDPOINT calls for the
> multiple vhost_dev device then those dev's evt/ctl vqs will be ignored and
> we will only use their IO vqs. So we end up with a lot of extra vqs.

The issue Jason's hinting at is how can admins control the amount
of resources a given qemu instance can consume?
After all vhost vqs all live in host kernel memory ...
Limiting # of open fds would be one way to do that ...

The need to share event/control vqs between devices is a problem though,
and sending lots of ioctls on things like reset is also not that elegant.
Jason, did you have a good solution in mind?

> One other question/issue I have is that qemu can open the /dev/vhost-scsi
> device or it allows tools like libvirtd to open the device and pass in the
> fd to use. For the latter case, would we continue to have those tools pass
> in the leading fd, then have qemu do the other num_queues - 1
> open(/dev/vhost-scsi) calls? Or do these apps that pass in the fd need to
> know about all of the fds for some management reason?

They know about all the fds, for resource control and priveledge
separation reasons.

-- 
MST

