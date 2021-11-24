Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65066C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Nov 2021 22:16:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245314AbhKXWTn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:19:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38050 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244993AbhKXWTl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Nov 2021 17:19:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637792190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EEVhKDq1EhBHdoS7pTs0RLbzDWey60atk3W5DA5v0B4=;
        b=OSyF49HBsRBesjnwLpONI2KlKEDOWpy69mX8OXVZYMSAD5PwrVyygjSVVr+H2RaPXoIRW6
        WGqHU7BcTZQPx26kJ4loOyXZdQ44kfYnyS9W0hEmdAZmTqISWgbb7cnjJFShFTucchodyT
        lwvgvkcdp+nHjbvMCRQOZOif6JrjtQo=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-318-XywWK9eqPzq-4jAHTjw3VA-1; Wed, 24 Nov 2021 17:16:29 -0500
X-MC-Unique: XywWK9eqPzq-4jAHTjw3VA-1
Received: by mail-lf1-f70.google.com with SMTP id g38-20020a0565123ba600b004036147023bso2074374lfv.10
        for <linux-scsi@vger.kernel.org>; Wed, 24 Nov 2021 14:16:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EEVhKDq1EhBHdoS7pTs0RLbzDWey60atk3W5DA5v0B4=;
        b=43PJnLuWY0B5UppoIc+GpDGm9p1s75pa7v5Cho9uPoBoDXkilh1Bc/qdodLb3JYjrl
         ed2ZqHJbip6kS+Vv4SAYwVeg/2cOOwrjAdEGWlEab/KdhOr/ewsaKtckbBfsYgcRxAUI
         Yp3NJmJid3YaUYF+eq0LXRsARUlvoqaufGJ5fv5W7FNOJYjpzpwcFT0xaN7r+Oub+Kmm
         23futf1F9g6Pd35m9WtrC285KkHmESOLBoWdA4A3vT7XNUahytTnvUVOJ1AgmXGakquF
         q034SEWag/MioLDsA8g+vBsHnr9iMLIMNCS/Tm6zUT52qtlezzSIYx/39iQvz8gEDXRO
         HvYQ==
X-Gm-Message-State: AOAM530jJYSfvnPfRc1utw6KpS4+f/RoNIfH20nt4LCtySCgXL75BfFE
        4zuVPd9C26Gxblw4VGijnRlf8DLyz+uyFQZ8bpo1QzuENdLA659gHI7809+q+onWr6YtAzusDJG
        eTp+Dkr7lL8Xlu0b4F7f1N2g7N1O2cO+g1aqpNg==
X-Received: by 2002:a05:6512:3096:: with SMTP id z22mr18777555lfd.124.1637792187792;
        Wed, 24 Nov 2021 14:16:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy3HKmtNAafBBlI7bMVT3RazivdW2g2TUcEskctZmuEaRpOF7Jx2bvW50+8WUNSPiqnQC6nZn8f0zY2CSibUtA=
X-Received: by 2002:a05:6512:3096:: with SMTP id z22mr18777505lfd.124.1637792187488;
 Wed, 24 Nov 2021 14:16:27 -0800 (PST)
MIME-Version: 1.0
References: <20210903152430.244937-1-nitesh@redhat.com> <CAFki+L=9Hw-2EONFEX6b7k6iRX_yLx1zcS+NmWsDSuBWg8w-Qw@mail.gmail.com>
 <87bl29l5c6.ffs@tglx>
In-Reply-To: <87bl29l5c6.ffs@tglx>
From:   Nitesh Lal <nilal@redhat.com>
Date:   Wed, 24 Nov 2021 17:16:16 -0500
Message-ID: <CAFki+Lmrv-UjZpuTQWr9c-Rymfm-tuCw9WpwmHgyfjVhJgp--g@mail.gmail.com>
Subject: Re: [PATCH v6 00/14] genirq: Cleanup the abuse of irq_set_affinity_hint()
To:     Thomas Gleixner <tglx@linutronix.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Cc:     Juri Lelli <juri.lelli@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        huangguangbin2@huawei.com, huangdaode@huawei.com,
        Frederic Weisbecker <frederic@kernel.org>,
        Alex Belits <abelits@marvell.com>,
        Bjorn Helgaas <bhelgaas@google.com>, rostedt@goodmis.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Ingo Molnar <mingo@kernel.org>, jbrandeb@kernel.org,
        akpm@linuxfoundation.org, sfr@canb.auug.org.au,
        stephen@networkplumber.org, rppt@linux.vnet.ibm.com,
        chris.friesen@windriver.com, Marc Zyngier <maz@kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>, pjwaskiewicz@gmail.com,
        Stefan Assmann <sassmann@redhat.com>,
        Tomas Henzl <thenzl@redhat.com>, james.smart@broadcom.com,
        Ken Cox <jkc@redhat.com>, faisal.latif@intel.com,
        shiraz.saleem@intel.com, tariqt@nvidia.com,
        Alaa Hleihel <ahleihel@redhat.com>,
        Kamal Heib <kheib@redhat.com>, borisp@nvidia.com,
        saeedm@nvidia.com,
        "Nikolova, Tatyana E" <tatyana.e.nikolova@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        Al Stone <ahs3@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        bjorn.andersson@linaro.org, chunkuang.hu@kernel.org,
        yongqiang.niu@mediatek.com, baolin.wang7@gmail.com,
        Petr Oros <poros@redhat.com>, Ming Lei <minlei@redhat.com>,
        Ewan Milne <emilne@redhat.com>, jejb@linux.ibm.com,
        kabel@kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>, kashyap.desai@broadcom.com,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        shivasharan.srikanteshwara@broadcom.com,
        sathya.prakash@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        suganath-prabu.subramani@broadcom.com, ley.foon.tan@intel.com,
        jbrunet@baylibre.com, johannes@sipsolutions.net,
        snelson@pensando.io, lewis.hanly@microchip.com, benve@cisco.com,
        _govind@gmx.com, jassisinghbrar@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 24, 2021 at 2:30 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Nitesh,
>
> On Mon, Sep 13 2021 at 10:34, Nitesh Lal wrote:
> > On Fri, Sep 3, 2021 at 11:25 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
> >>
> >> The drivers currently rely on irq_set_affinity_hint() to either set the
> >> affinity_hint that is consumed by the userspace and/or to enforce a custom
> >> affinity.
> >>
> >> irq_set_affinity_hint() as the name suggests is originally introduced to
> >> only set the affinity_hint to help the userspace in guiding the interrupts
> >> and not the affinity itself. However, since the commit
> >>
> >>         e2e64a932556 "genirq: Set initial affinity in irq_set_affinity_hint()"
>
> sorry for ignoring this. It fell through the cracks.


No worries, thank you for reviewing.

>
>
> >> Thomas Gleixner (1):
> >>   genirq: Provide new interfaces for affinity hints
>
> Did I actually write this?


Yeap, the idea and the initial patch came from you. :)

>
>
> > Any suggestions on what should be the next steps here? Unfortunately, I haven't
> > been able to get any reviews on the following two patches:
> >   be2net: Use irq_update_affinity_hint
> >   hinic: Use irq_set_affinity_and_hint
> >
> > One option would be to proceed with the remaining patches and I can try
> > posting these two again when I post patches for the remaining drivers?
>
> The more general question is whether I should queue all the others or
> whether some subsystem would prefer to pull in a tagged commit on top of
> rc1. I'm happy to carry them all of course.
>

I am fine either way.
In the past, while I was asking for more testing help I was asked if the
SCSI changes are part of Martins's scsi-fixes tree as that's something
Broadcom folks test to check for regression.
So, maybe Martin can pull this up?

-- 
Thanks
Nitesh

