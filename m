Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01207C432BE
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Aug 2021 15:41:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD2AE60F6C
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Aug 2021 15:41:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237621AbhH3PmH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Aug 2021 11:42:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35172 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237589AbhH3PmH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Aug 2021 11:42:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630338073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gPbQCANsnrrCdrVSn7eLIOlLURUqitfm5ZSQa5OvEPY=;
        b=hwkGAMvltCShRNFr/8eg5GqBGI5iYBOKyH9wxL/M4pTQylnRc6ndwD2LRHBRdjuc5m8pUA
        Y7OOQ64+D8zFCKNZyYvE1mI2VaZaMiSTOBWfnCKOQQpLQOpsXM9oq4rl5UazZ9M9F4qd0Y
        s669b0bFG+7PI18p63a4aEKJp2JRFbU=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-KMFLKxDwP7OEYsNoJksn8w-1; Mon, 30 Aug 2021 11:41:11 -0400
X-MC-Unique: KMFLKxDwP7OEYsNoJksn8w-1
Received: by mail-lf1-f72.google.com with SMTP id k20-20020a05651239d400b003d91160994dso3203627lfu.1
        for <linux-scsi@vger.kernel.org>; Mon, 30 Aug 2021 08:41:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gPbQCANsnrrCdrVSn7eLIOlLURUqitfm5ZSQa5OvEPY=;
        b=RgFtDLyKuuijoBJhhVygYuBiTV0oAplaDmovSXqb8LXE4R1Iaqk5HDqFkS3vaoiXqo
         BWzfc54bb4YtxCI3uGkFvOaPve/27dnWTtKZw24YVrugFFLsNOj+Vj/X2rvIhMiLuAw+
         DJP0NpuPmLNMItz7m0RZBJonalNSUBIQLaMOOrlXJUCGXgMuNuPwsV+3CIZJjb4hLEzT
         7yPhZ7Q8kJeREtPIXVX81pTKWh78rLm4d8fsj63RpKqksqGCCXSwfAYhEX6H2wmjPjAD
         7fCOc4PttrPalQhJM6lL/HxmtlVQ6lVXpWzgRxDhvANxDsUZVw/ex2ffMZH/xAdnU5kF
         2iaw==
X-Gm-Message-State: AOAM533h9qMPMUlXH85Rs86JU7+RWehwZ9sX6BJou6Nk15bQY0rXPohq
        87SVYEZ/k6qv2MH6rCBYl5hdcBmpEdHXwStLm+n+glcL+/+1an5d00Azibitq+Zv3VdF37I9UzG
        jdzQhRwYLiCHvigqmxOeUrINHUGu5W1Hn5smtjw==
X-Received: by 2002:a05:6512:31d1:: with SMTP id j17mr12619155lfe.252.1630338069515;
        Mon, 30 Aug 2021 08:41:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyOA7eSQoAskt96OZEYv/uwT6xUpzuLtn/b7kPoWDczLLZXX82Grt6CyXuqBmavCZC7GNFgyKU16h8yzDCOqhU=
X-Received: by 2002:a05:6512:31d1:: with SMTP id j17mr12619127lfe.252.1630338069329;
 Mon, 30 Aug 2021 08:41:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210720232624.1493424-1-nitesh@redhat.com> <CAFki+LkNzk0ajUeuBnJZ6mp1kxB0+zZf60tw1Vfq+nPy-bvftQ@mail.gmail.com>
 <CAFki+LkyTNeorQ5e_6_Ud==X7dt27G38ZjhEewuhqGLfanjw_A@mail.gmail.com> <CAFki+Lmbw=02iaYKs_a0jR1KWLisXQa1B-s0hc-Ej-8F8ryWDQ@mail.gmail.com>
In-Reply-To: <CAFki+Lmbw=02iaYKs_a0jR1KWLisXQa1B-s0hc-Ej-8F8ryWDQ@mail.gmail.com>
From:   Nitesh Lal <nilal@redhat.com>
Date:   Mon, 30 Aug 2021 11:40:57 -0400
Message-ID: <CAFki+LmcagVgj+rNJqAw-LwM=rZFq_AB5QwL5itXvm-bHU8QoA@mail.gmail.com>
Subject: Re: [PATCH v5 00/14] genirq: Cleanup the abuse of irq_set_affinity_hint()
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        huangguangbin2@huawei.com, huangdaode@huawei.com,
        luobin9@huawei.com
Cc:     linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, jbrandeb@kernel.org,
        Frederic Weisbecker <frederic@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Alex Belits <abelits@marvell.com>,
        Bjorn Helgaas <bhelgaas@google.com>, rostedt@goodmis.org,
        Peter Zijlstra <peterz@infradead.org>,
        akpm@linuxfoundation.org, sfr@canb.auug.org.au,
        stephen@networkplumber.org, rppt@linux.vnet.ibm.com,
        chris.friesen@windriver.com, Marc Zyngier <maz@kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>, pjwaskiewicz@gmail.com,
        Stefan Assmann <sassmann@redhat.com>,
        Tomas Henzl <thenzl@redhat.com>, james.smart@broadcom.com,
        Dick Kennedy <dick.kennedy@broadcom.com>,
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
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        kabel@kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>, kashyap.desai@broadcom.com,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        shivasharan.srikanteshwara@broadcom.com,
        sathya.prakash@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        suganath-prabu.subramani@broadcom.com,
        Thomas Gleixner <tglx@linutronix.de>, ley.foon.tan@intel.com,
        jbrunet@baylibre.com, johannes@sipsolutions.net,
        snelson@pensando.io, lewis.hanly@microchip.com, benve@cisco.com,
        _govind@gmx.com, jassisinghbrar@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 30, 2021 at 11:38 AM Nitesh Lal <nilal@redhat.com> wrote:
>
> On Mon, Aug 16, 2021 at 11:50 AM Nitesh Lal <nilal@redhat.com> wrote:
> >
> > On Mon, Aug 2, 2021 at 11:26 AM Nitesh Lal <nilal@redhat.com> wrote:
> > >
> > > On Tue, Jul 20, 2021 at 7:26 PM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
> > > >
> > > > The drivers currently rely on irq_set_affinity_hint() to either set the
> > > > affinity_hint that is consumed by the userspace and/or to enforce a custom
> > > > affinity.
> > > >
> >
>
> [...]
>
> >
> > Any comments on the following patches:
> >
> >   enic: Use irq_update_affinity_hint
> >   be2net: Use irq_update_affinity_hint
> >   mailbox: Use irq_update_affinity_hint
> >   hinic: Use irq_set_affinity_and_hint
> >
> > or any other patches?
> > Any help in testing will also be very useful.
> >
>
> Gentle ping.
> Any comments on the following patches:
>
>   be2net: Use irq_update_affinity_hint
>   hinic: Use irq_set_affinity_and_hint
>
> or any other patches?


Also, I have been trying to reach Bin Luo who maintains the hinic driver
but it seems his email ID has changed so if someone else can help in
reviewing/testing the hinic patch, it would be really helpful.

-- 
Thanks
Nitesh

