Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77A9BC07E96
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 13:29:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60E1A60E0B
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 13:29:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236624AbhGMNcm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 09:32:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40866 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236588AbhGMNcl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Jul 2021 09:32:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626182991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jdeapieNS3PVuhbaSMCjhCNHL9ow03NjgZ6/hSsB7Qg=;
        b=eVALn4XCl3v0oqQ/4JZZEzt8VcYt0JTODFs+kQHjgovfEcgFuB61tTnNE0ZmOaFGdTsCpO
        au2m6HRIhH8etKICURRj6WBCcr8XWZjB5Eo9wkMbagMuyfbtZePqoxjwDnceR+DwulC503
        +k1NJitUcgIFSrFzWuY6zVi3Il56s3k=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-bgcCPGVzOaq5Yd8P4I5r_g-1; Tue, 13 Jul 2021 09:29:49 -0400
X-MC-Unique: bgcCPGVzOaq5Yd8P4I5r_g-1
Received: by mail-ed1-f72.google.com with SMTP id y18-20020a0564022712b029038ffac1995eso12021649edd.12
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jul 2021 06:29:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jdeapieNS3PVuhbaSMCjhCNHL9ow03NjgZ6/hSsB7Qg=;
        b=Y3j4E6/IE8C1HMgrWcKHIl7rORnLPNdj+MVENFlw4SFayWyW1N10gfUO4KmIaQljYw
         IPBkbH8HQDeBlB0T4Wyg5a7boBCmfoNLFZBXmKf/ManVNbh6S3oGsCH0BNJN33+y23i8
         +vkb3BkuXj0SyA8rII2Xrqf45ZA2BGixgiQHzAENNeEMO15SB2Bs9mZ0rkLckrkMM0k7
         KgFRTY4BDd1r0HKE105e23oDRunWMhIbGJvHyprVH8Qfl4SD6oWJx7W5Hp7YiHLKl8C8
         a5EQKQtn4RXXZMJyNP6A26mF0K3SLhfkEHZBG+ViOekTOE1OAK0SPM4itlrGrDFtVthA
         4kKQ==
X-Gm-Message-State: AOAM5339eH8u5xFYOXyp8/pZO9ZfuhMa3C8kdj77oDoelsdz+pFaE/k9
        6w6vtDUQKKBeHNAnukKd9ulGnihe5yCQxoVnazN/0ghLKJVVhJEX+66C9ZwQYhjHn0xFidCw7s7
        y86qttYluzSL0xg0/6+6Vk2PLxcJaElFVzbWCDQ==
X-Received: by 2002:aa7:dcd2:: with SMTP id w18mr5825655edu.145.1626182988593;
        Tue, 13 Jul 2021 06:29:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5wxQUQPgyLKUdlRZ2gZvYByjQxwh5vHfj9Zl/5/TUt6KM+BkoCgzKzFw3XseQAusiiqmnSZ0tdUwu4kYrB74=
X-Received: by 2002:aa7:dcd2:: with SMTP id w18mr5825614edu.145.1626182988415;
 Tue, 13 Jul 2021 06:29:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210629152746.2953364-1-nitesh@redhat.com> <CAFki+LnUGiEE-7Uf-x8-TQZYZ+3Migrr=81gGLYszxaK-6A9WQ@mail.gmail.com>
 <YOrWqPYPkZp6nRLS@unreal> <CAFki+L=FYOTQ1+-MHWmTuA6ZxTUcZA9t41HRL2URYgv03oFbDg@mail.gmail.com>
 <YO0eKv2GJcADQTHH@unreal>
In-Reply-To: <YO0eKv2GJcADQTHH@unreal>
From:   Nitesh Lal <nilal@redhat.com>
Date:   Tue, 13 Jul 2021 09:29:37 -0400
Message-ID: <CAFki+L=LtHFvL5+h2JtWhKMDdR5=ABzOFnvdXCDcPfGisDb-9A@mail.gmail.com>
Subject: Re: [PATCH v2 00/14] genirq: Cleanup the usage of irq_set_affinity_hint
To:     Leon Romanovsky <leon@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, linux-api@vger.kernel.org,
        linux-pci@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, jbrandeb@kernel.org,
        frederic@kernel.org, Juri Lelli <juri.lelli@redhat.com>,
        Alex Belits <abelits@marvell.com>,
        Bjorn Helgaas <bhelgaas@google.com>, rostedt@goodmis.org,
        peterz@infradead.org, davem@davemloft.net,
        akpm@linux-foundation.org, sfr@canb.auug.org.au,
        stephen@networkplumber.org, rppt@linux.vnet.ibm.com,
        chris.friesen@windriver.com, Marc Zyngier <maz@kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>, pjwaskiewicz@gmail.com,
        Stefan Assmann <sassmann@redhat.com>,
        Tomas Henzl <thenzl@redhat.com>, kashyap.desai@broadcom.com,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        shivasharan.srikanteshwara@broadcom.com,
        sathya.prakash@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        suganath-prabu.subramani@broadcom.com, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, Ken Cox <jkc@redhat.com>,
        faisal.latif@intel.com, shiraz.saleem@intel.com, tariqt@nvidia.com,
        Alaa Hleihel <ahleihel@redhat.com>,
        Kamal Heib <kheib@redhat.com>, borisp@nvidia.com,
        saeedm@nvidia.com, benve@cisco.com, govind@gmx.com,
        jassisinghbrar@gmail.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        "Nikolova, Tatyana E" <tatyana.e.nikolova@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        Al Stone <ahs3@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jul 13, 2021 at 1:01 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Mon, Jul 12, 2021 at 05:27:05PM -0400, Nitesh Lal wrote:
> > Hi Leon,
> >

<snip>

> > > >
> > > > Gentle ping.
> > > > Any comments or suggestions on any of the patches included in this series?
> > >
> > > Please wait for -rc1, rebase and resend.
> > > At least i40iw was deleted during merge window.
> > >
> >
> > In -rc1 some non-trivial mlx5 changes also went in.  I was going through
> > these changes and it seems after your patch
> >
> > e4e3f24b822f: ("net/mlx5: Provide cpumask at EQ creation phase")
> >
> > we do want to control the affinity for the mlx5 interrupts from the driver.
> > Is that correct?
>
> We would like to create devices with correct affinity from the
> beginning. For this, we will introduce extension to devlink to control
> affinity that will be used prior initialization sequence.
>
> Currently, netdev users who don't want irqbalance are digging into
> their procfs, reconfigure affinity on already existing devices and
> hope for the best.
>
> This is even more cumbersome for the SIOV use case, where every physical
> NIC PCI device will/can create thousands of lightweights netdevs that will
> be forwarded to the containers later. These containers are limited to known
> CPU cores, so no reason do not limit netdev device too.
>
> The same goes for other sub-functions of that PCI device, like RDMA,
> vdpa e.t.c.
>
> > This would mean that we should use irq_set_affinity_and_hint() instead
> > of irq_update_affinity_hint().
>
> I think so.
>

Thanks, will make that change in the patch and re-send.
I will also drop your reviewed-by for the mlx5 patch so that you can
have a look at it again, please let me know if you have any
objections.

-- 
Thanks
Nitesh

