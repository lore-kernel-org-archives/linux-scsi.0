From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [PATCH 13/14] megaraid_sas: NVME passthru command support
Date: Wed, 10 Jan 2018 15:33:30 +0530
Message-ID: <e3e6eca50db6f04ef59a9ce3d7f044f6@mail.gmail.com>
References: <1515159339-26790-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <20180108100531.GA6967@infradead.org> <35aabb7a8b8ffed4040c5ac01c01fb0a@mail.gmail.com>
 <20180109164540.GA11861@infradead.org> <27ebbe5f-e06b-a800-5518-ec63d65d142a@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:40956 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752130AbeAJKDz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jan 2018 05:03:55 -0500
Received: by mail-io0-f169.google.com with SMTP id v30so21811419iov.7
        for <linux-scsi@vger.kernel.org>; Wed, 10 Jan 2018 02:03:55 -0800 (PST)
In-Reply-To: <27ebbe5f-e06b-a800-5518-ec63d65d142a@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, Christoph Hellwig <hch@infradead.org>
Cc: Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org, Sumit Saxena <sumit.saxena@broadcom.com>, linux-nvme@lists.infradead.org, Peter Rivera <peter.rivera@broadcom.com>

> -----Original Message-----
> From: Douglas Gilbert [mailto:dgilbert@interlog.com]
> Sent: Wednesday, January 10, 2018 2:21 AM
> To: Christoph Hellwig; Kashyap Desai
> Cc: Shivasharan Srikanteshwara; linux-scsi@vger.kernel.org; Sumit Saxena;
> linux-nvme@lists.infradead.org; Peter Rivera
> Subject: Re: [PATCH 13/14] megaraid_sas: NVME passthru command support
>
> On 2018-01-09 11:45 AM, Christoph Hellwig wrote:
> > On Tue, Jan 09, 2018 at 10:07:28PM +0530, Kashyap Desai wrote:
> >> Chris -
> >>
> >> Overall NVME support behind MR controller is really a SCSI device. On
> >> top of that, for MegaRaid, NVME device can be part of Virtual Disk
> >> and those drive will not be exposed to the driver. User application
> >> may like to talk to hidden NVME devices (part of VDs). This patch
> >> will extend the existing interface for megaraid product in the same
> >> way it is currently supported for other protocols like SMP, SATA pass-
> through.
> >>
> >> Example - Current smartmon is using megaraid.h (MFI headers) to send
> >> SATA pass-through.
> >>
> >> https://github.com/mirror/smartmontools/blob/master/megaraid.h
> >
> > And that is exactly the example of why we should have never allowed
> > megaraid any private passthrough ioctls to start with.
>
> Christoph,
> Have you tried to do any serious work with <linux/nvme_ioctl.h> and say
> compared it with FreeBSD and Microsoft's approach? No prize for guessing
> which one is worst (and least extensible). Looks like the Linux
> pass-through
> was at the end of a ToDo list and was "designed"
> at 5 a.m in the morning.
>
> RAID cards need a pass-through that allows them to address one of many
> physical disks behind the virtual disk presented to OS.
> Pass-throughs need to have uncommited room for extra parameters that will
> be passed through as-is to the RAID LLD.

Doug - As you mentioned, I notice the same. This type of issue is common for
all RAID controllers vendors.
Whatever Christoph mentioned about NVMe type API to be used is possible, but
may need extra hit in firmware side to convert Linux NVME API to FW specific
OR deal the same in driver.
It may come with it's own pros/cons.  Also may not fulfil the end goal. For
other platforms, we still have to depend upon specialized pass-through code.
So having said that Firmware of RAID cannot use only one interface for
pass-through and they have to choose specialized pass-through code.

NVME-CLI interface is designed for NVME drives attached to block layer.
MegaRaid product is design to keep NVME protocol abstracted (much like SATA
drives behind SAS controller) and attach those drives/virtual disk to SCSI
layer.

>
> So until Christoph gives an example of how that can be done with
> <linux/nvme_ioctl.h> then I would like to see Christoph's objection
> ignored.
>
>
> And as a maintainer of smartmontools, I would like to point out that
> pretty
> well all supported RAIDs, on all platforms need specialized pass-through
> code.

If upstream community like to enhance nvme-cli type interface in
megaraid_sas driver, we may have to come up with one more layer in
megaraid_sas driver to convert NVME-API to specialized pass-through code.
It is really not simple to fit into existing design as NVME-CLI/API is
considering NVME drive associated with nvme.ko modules (/dev/nvmeX). Also we
don't have many sysfs entries nvme-cli is looking for NVME device etc.. We
don't have way to talk to Physical disks which is part of VD etc..

Specialized pass-through code is better to extend in application like
smartmontools etc.

> Start by looking at os_linux.cpp and then at the other OSes. And now
> smartmontools supports NVMe on most platforms and at the pass-through
> level, it is just another one, and not a particularly clean one.
>
> IMO Intel had their chance on the pass-through front, and blew it.
> It is now too late to fix it and that job (impossible ?) should not fall
> to
> MegaRaid maintainers.
>
> Douglas Gilbert
