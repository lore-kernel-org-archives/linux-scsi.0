Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54435C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 14:36:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B56860F9B
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 14:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346125AbhIMOhd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 10:37:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53652 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347851AbhIMOff (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Sep 2021 10:35:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631543658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZfryJxpK5ypx39qR3xTFVVXtpOzhn2v4T4s5MYbdHC0=;
        b=dvNIRC3523oN5Xffx5GXLuVd6k/tEiEOAKVmgi/3ggmSnDnSeRVVWWQs9VUUX1DmvuZzKk
        KyMuzwNQe03PGrySqT7hj7LFVhZXIjyEJ/1Zl6VZ66iOxU1t8mwrSp5boUqv4qnbNkNou5
        5hlpijiIzYp6M5krBlCs7LGW+h7VeKQ=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-y2uUXr-SNACKcS0j0YQC8g-1; Mon, 13 Sep 2021 10:34:18 -0400
X-MC-Unique: y2uUXr-SNACKcS0j0YQC8g-1
Received: by mail-lf1-f70.google.com with SMTP id g9-20020a0565123b8900b003f33a027130so1091709lfv.18
        for <linux-scsi@vger.kernel.org>; Mon, 13 Sep 2021 07:34:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZfryJxpK5ypx39qR3xTFVVXtpOzhn2v4T4s5MYbdHC0=;
        b=Ir9TMY+SELEU7SJGnJOqMCK6NWGYBHIKhn/LYaZuRxZTP8G09Fa1FbdGt2kB5tDAYq
         5EPfvPrnf2qiui7fZbwqBAgiKnn+CVVABD/K7VRLz6pHe7/QbAtuMPdOCfXDTcLLMvyx
         tnQRrOuYVh1/NcV9+63970nYiBGSctZHKxtiOhWxPKz8l85LWwDj/Xu0S4wW8sMX/J+O
         XIQzDYwt/3dQvvRj3n35A8I6J9kKx2adzyBi3YXpeyZ3i4l8ywrc27iya7qwZfQMIaG5
         rmt+R3Yj1NpMD7UszlcHGDJJwsJZfHev7UnpLtGc3pnPsCArITgZUgMfc44JP9MjSAOo
         eYfg==
X-Gm-Message-State: AOAM5325ZAwMz4w6phweKh+Wyp2Og9OKBR/paWWp34CneXjOIi6za6Rk
        Fw7LM4qXeZY7xiM7BsIM0q/u2S4r0ypzWGyxi5VeYyu9Ydggd63PyatZPPlqivVmXemC7uhut4H
        KWpClQFiZMPaeioY3zOcy/S9+RzC5+s+FMC/Rdw==
X-Received: by 2002:a2e:8496:: with SMTP id b22mr10580072ljh.496.1631543655364;
        Mon, 13 Sep 2021 07:34:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx5SXCQw8y9VkHHfq5++HMmDEHwpKWfarOYoyKiBkbH/mHk7DKQN7bm1Klq5kHtrFKCMkY+wbutOm0v72aYRO0=
X-Received: by 2002:a2e:8496:: with SMTP id b22mr10580054ljh.496.1631543655145;
 Mon, 13 Sep 2021 07:34:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210903152430.244937-1-nitesh@redhat.com>
In-Reply-To: <20210903152430.244937-1-nitesh@redhat.com>
From:   Nitesh Lal <nilal@redhat.com>
Date:   Mon, 13 Sep 2021 10:34:03 -0400
Message-ID: <CAFki+L=9Hw-2EONFEX6b7k6iRX_yLx1zcS+NmWsDSuBWg8w-Qw@mail.gmail.com>
Subject: Re: [PATCH v6 00/14] genirq: Cleanup the abuse of irq_set_affinity_hint()
To:     Thomas Gleixner <tglx@linutronix.de>,
        Juri Lelli <juri.lelli@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
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
        suganath-prabu.subramani@broadcom.com, ley.foon.tan@intel.com,
        jbrunet@baylibre.com, johannes@sipsolutions.net,
        snelson@pensando.io, lewis.hanly@microchip.com, benve@cisco.com,
        _govind@gmx.com, jassisinghbrar@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 3, 2021 at 11:25 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>
> The drivers currently rely on irq_set_affinity_hint() to either set the
> affinity_hint that is consumed by the userspace and/or to enforce a custom
> affinity.
>
> irq_set_affinity_hint() as the name suggests is originally introduced to
> only set the affinity_hint to help the userspace in guiding the interrupts
> and not the affinity itself. However, since the commit
>
>         e2e64a932556 "genirq: Set initial affinity in irq_set_affinity_hint()"

[...]

>
> Nitesh Narayan Lal (13):
>   iavf: Use irq_update_affinity_hint
>   i40e: Use irq_update_affinity_hint
>   scsi: megaraid_sas: Use irq_set_affinity_and_hint
>   scsi: mpt3sas: Use irq_set_affinity_and_hint
>   RDMA/irdma: Use irq_update_affinity_hint
>   enic: Use irq_update_affinity_hint
>   be2net: Use irq_update_affinity_hint
>   ixgbe: Use irq_update_affinity_hint
>   mailbox: Use irq_update_affinity_hint
>   scsi: lpfc: Use irq_set_affinity
>   hinic: Use irq_set_affinity_and_hint
>   net/mlx5: Use irq_set_affinity_and_hint
>   net/mlx4: Use irq_update_affinity_hint
>
> Thomas Gleixner (1):
>   genirq: Provide new interfaces for affinity hints
>

Any suggestions on what should be the next steps here? Unfortunately, I haven't
been able to get any reviews on the following two patches:
  be2net: Use irq_update_affinity_hint
  hinic: Use irq_set_affinity_and_hint

One option would be to proceed with the remaining patches and I can try
posting these two again when I post patches for the remaining drivers?

-- 
Thanks
Nitesh

