Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7EDBC11F64
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 11:07:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9AD761452
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 11:07:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236251AbhGALJi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jul 2021 07:09:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40710 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236195AbhGALJe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2021 07:09:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625137623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qWy1faEU2+6xPaNpOXpQc2Lrpi6aPT/25xHf/Z6cpbw=;
        b=D6Nt9cTm2oS6/Q4+BGtiJB8rYFCPHHvYvznP/67zuSOZJQ1Gp1Zy93bCCtY3AuczQw/a2N
        Gw4bnr7IS2noA8WDN6tJkiHVK6ZFm1z5HTg4t10f9YoOz1D003jqaHuR6S0LI7klQYiSaR
        mCPmfZCEAodRgIpEdwSHApCVGVwCsQM=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-UI7MFQdUPCWGmA3nc-m4Mg-1; Thu, 01 Jul 2021 07:07:02 -0400
X-MC-Unique: UI7MFQdUPCWGmA3nc-m4Mg-1
Received: by mail-pj1-f69.google.com with SMTP id c5-20020a17090a1d05b029016f9eccfcd6so3119714pjd.0
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jul 2021 04:07:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qWy1faEU2+6xPaNpOXpQc2Lrpi6aPT/25xHf/Z6cpbw=;
        b=UWO9AAT9VOzovKVcS17qRFm7lmREhLPNMshBsSJlJDrfD8kiKTFEK8cGvRiMnrJqSZ
         AKyeRCtpkvwchf9bxN7iBZf1OVY6tijdenho8V2fOnRmWhu0f4L0/fcZj9RHEwcSG6fF
         /gpXz+r3RhPZ4QkLl7ihyF2gHxtWmBwA+PSQ1XFYtqBD3TiQHdgef2EHnyF4VW5S/k4a
         ZJB3x14C7/SYPSxl1O89LjsuDuKZ7YhijZaNf9Qlfu0qjjiXFwwQ1GWucrzfluRYIQrc
         O7ddgElPEsYtbQKQL5QW5jpx3VRWHYmhs6To2edDgkN48Dbuv6aLSoxmI348GcL+S9JW
         6oFg==
X-Gm-Message-State: AOAM530zWcULZbNnM/YMZ1EOvHcF9h/zC8Vk8b91yB2t5/IOiqQbr3gy
        3qh5gKAeQllAimCCz1rcEAe0woXmJ5bo1dpaOjVQTQutiT8eTIXveLeMJiRBj4kqqlyeZ1lIGUa
        qnNy3sMFd6pAeUwvHFktrpCJZ42FPKXP/5nl9Lw==
X-Received: by 2002:a62:ee16:0:b029:2fe:ffcf:775a with SMTP id e22-20020a62ee160000b02902feffcf775amr40043872pfi.59.1625137621553;
        Thu, 01 Jul 2021 04:07:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1kVwoyjnIR3qRD8QsEf+6pzFR5H2YZPuZNpfADIZAAKDrY4X0nTDNbSb/S3TOhjXbj1hLppeJRJPQxzNCLxU=
X-Received: by 2002:a62:ee16:0:b029:2fe:ffcf:775a with SMTP id
 e22-20020a62ee160000b02902feffcf775amr40043852pfi.59.1625137621231; Thu, 01
 Jul 2021 04:07:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210628151558.2289-1-mwilck@suse.com> <20210628151558.2289-4-mwilck@suse.com>
 <20210701075629.GA25768@lst.de>
In-Reply-To: <20210701075629.GA25768@lst.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 1 Jul 2021 13:06:50 +0200
Message-ID: <CABgObfYi6TooJM1cCCQrj2pdzz+VHtC+-w1KTycvsSiC+koNVQ@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] dm mpath: add CONFIG_DM_MULTIPATH_SG_IO - failover
 for SG_IO
To:     Christoph Hellwig <hch@lst.de>
Cc:     Martin Wilck <mwilck@suse.com>, Mike Snitzer <snitzer@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>, dm-devel@redhat.com,
        Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>,
        linux-block <linux-block@vger.kernel.org>,
        Benjamin Marzinski <bmarzins@redhat.com>,
        Nils Koenig <nkoenig@redhat.com>,
        Ewan Milne <emilne@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jul 1, 2021 at 9:56 AM Christoph Hellwig <hch@lst.de> wrote:
> On Mon, Jun 28, 2021 at 05:15:58PM +0200, mwilck@suse.com wrote:
> > The qemu "pr-helper" was specifically invented for it. I
> > believe that this is the most important real-world scenario for sending
> > SG_IO ioctls to device-mapper devices.
>
> pr-helper obviously does not SG_IO on dm-multipath as that simply does
> not work.

Right, for the specific case of persistent reservation ioctls, SG_IO is
sent manually to each path via libmpathpersist.

Failover for SG_IO is needed for general-purpose commands (ranging
from INQUIRY/READ CAPACITY to READ/WRITE). The reason to use
SG_IO instead of syscalls is mostly to preserve sense data; QEMU does
have code to convert errno to sense data, but it's fickle. If QEMU can use
sense data directly, it's easier to forward conditions that the guest can
resolve itself (for example unit attentions) and to let the guest operate
at a lower level (e.g. host-managed ZBC can be forwarded and they just
work).

Of course, all this works only for SCSI. As NVMe becomes more common,
and Linux exposes more functionality to userspace with a fabric-neutral
API, QEMU's SBC emulation can start using that functionality and provide
low-level passthrough functionality no matter if the host is using SCSI
or NVMe. Again, the main obstacle for this is sense data; for example,
the SCSI subsystem rightfully eats unit attentions and converts them to
uevents if you go through read/write requests instead of SG_IO.

> More importantly - if you want to use persistent reservations use the
> kernel ioctls for that.  These work on SCSI, NVMe and device mapper
> without any extra magic.

If they provide functionality equivalent to libmpathpersist without having
to do the DM_TABLE_STATUS, I will certainly consider switching! The
only possible issue could be the lost unit attentions.

Paolo

> Failing over SG_IO does not make sense.  It is an interface specically
> designed to leave all error handling to the userspace program using it,
> and we should not change that for one specific error case.  If you
> want the kernel to handle errors for you, use the proper interfaces.
> In this case this is the persistent reservation ioctls.  If they miss
> some features that qemu needs we should add those.

