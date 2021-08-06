Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 528EFC4338F
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 15:52:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3271A60F0F
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 15:52:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244908AbhHFPwg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 11:52:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42508 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244809AbhHFPw3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 11:52:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628265133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ocgP4yowhB/EUlnSIxuQMOG6kjLjSAHTmb8OYmd4EOQ=;
        b=E68K3GZj/NAVqBnVFbgOM2MzFgObDUk8Gx3L41n6wA9i/t/bBsENBqDF0kwFwlIiYMjo03
        p8rMNlgmaoOszeaHrHO/d35RwIU74UrfFAm6KmoFP3oKTPIf50y8alidE63t9YUNbkez9o
        eErBU3MdvGccvq9YICJHyus35rlzKvo=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-WyCXjER2PLWgWeRB3rjSiA-1; Fri, 06 Aug 2021 11:52:11 -0400
X-MC-Unique: WyCXjER2PLWgWeRB3rjSiA-1
Received: by mail-lj1-f198.google.com with SMTP id a14-20020a05651c030eb0290191f8d27e33so2008271ljp.23
        for <linux-scsi@vger.kernel.org>; Fri, 06 Aug 2021 08:52:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ocgP4yowhB/EUlnSIxuQMOG6kjLjSAHTmb8OYmd4EOQ=;
        b=jLu7tiM7aR+SkPymSjJ8st5juB/QYEbCtwdqvONpXg5g7NUDeRVozAsES8yDFFvwkg
         +5gsws8KSWK6ERmYAHp4+QfSx+sDRJ0rvgS7a8U29Y1qKZuJ4kbmWQOT3NnhGWuLG3K/
         RFIoDoUMj4vg1/BRCRkGgQ0+QHD8rMuAWGRUYyiBG9GW8DCuLoC9xSOZIAhdZ0YWUhEt
         rJ8QbTnJ7WfdPDyMJL31KZ/27LN2FfvzCjNQT4FkKOCMCwJM/bCGUQScwm37zvEvId+A
         c5EXkcApWWGjNKerzJnVguxAowQQH+cfU8e0tbbepczJM5vj70dtnpJsYBzmc6IlJ+nC
         UwTg==
X-Gm-Message-State: AOAM533unIqYUYeAiDJVL1pvNT3Dng8egUJ7/p7NSlabviIJORvCOA7P
        wGyHd7GdqowvQUIJ759KEgW0FYT8QeIXCkDR50YU87K4pFkrGyNWjqln9kksaSj/Objnc0FeQNO
        1DS16kYdZsJStC/vXzUZ+VTezewtuR3y4sPTc1A==
X-Received: by 2002:ac2:446d:: with SMTP id y13mr8071797lfl.632.1628265129891;
        Fri, 06 Aug 2021 08:52:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz9NmyUDGHNtqA5+JG3Fj8AovGBdtXdP/uo+X1AK+D5LYRCKOEMar1/c1smD31PF3dDW/0pEabI/MsAyUK/eQ0=
X-Received: by 2002:ac2:446d:: with SMTP id y13mr8071774lfl.632.1628265129728;
 Fri, 06 Aug 2021 08:52:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210720232624.1493424-1-nitesh@redhat.com> <20210720232624.1493424-2-nitesh@redhat.com>
In-Reply-To: <20210720232624.1493424-2-nitesh@redhat.com>
From:   Ming Lei <ming.lei@redhat.com>
Date:   Fri, 6 Aug 2021 23:51:58 +0800
Message-ID: <CAFj5m9+9asdQOCRHb0tZ=XSD-sOj+RLEDVEAObN81Z9y1JcgQg@mail.gmail.com>
Subject: Re: [PATCH v5 01/14] genirq: Provide new interfaces for affinity hints
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-api@vger.kernel.org, linux-pci@vger.kernel.org,
        tglx@linutronix.de, jesse.brandeburg@intel.com,
        Robin Murphy <robin.murphy@arm.com>, mtosatti@redhat.com,
        mingo@kernel.org, jbrandeb@kernel.org, frederic@kernel.org,
        juri.lelli@redhat.com, abelits@marvell.com, bhelgaas@google.com,
        rostedt@goodmis.org, peterz@infradead.org, davem@davemloft.net,
        akpm@linux-foundation.org, sfr@canb.auug.org.au,
        stephen@networkplumber.org, rppt@linux.vnet.ibm.com,
        chris.friesen@windriver.com, maz@kernel.org, nhorman@tuxdriver.com,
        pjwaskiewicz@gmail.com, sassmann@redhat.com, thenzl@redhat.com,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        James Smart <james.smart@broadcom.com>,
        dick.kennedy@broadcom.com, jkc@redhat.com, faisal.latif@intel.com,
        shiraz.saleem@intel.com, tariqt@nvidia.com, ahleihel@redhat.com,
        kheib@redhat.com, borisp@nvidia.com, saeedm@nvidia.com,
        benve@cisco.com, govind@gmx.com, jassisinghbrar@gmail.com,
        ajit.khaparde@broadcom.com, sriharsha.basavapatna@broadcom.com,
        somnath.kotur@broadcom.com, nilal@redhat.com,
        tatyana.e.nikolova@intel.com, mustafa.ismail@intel.com,
        ahs3@redhat.com, leonro@nvidia.com,
        chandrakanth.patil@broadcom.com, bjorn.andersson@linaro.org,
        chunkuang.hu@kernel.org, yongqiang.niu@mediatek.com,
        baolin.wang7@gmail.com, poros@redhat.com,
        Ewan Milne <emilne@redhat.com>, jejb@linux.ibm.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>, _govind@gmx.com,
        kabel@kernel.org, viresh.kumar@linaro.org,
        Tushar.Khandelwal@arm.com, kuba@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 21, 2021 at 7:26 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>
> From: Thomas Gleixner <tglx@linutronix.de>
>
> The discussion about removing the side effect of irq_set_affinity_hint() of
> actually applying the cpumask (if not NULL) as affinity to the interrupt,
> unearthed a few unpleasantries:
>
>   1) The modular perf drivers rely on the current behaviour for the very
>      wrong reasons.
>
>   2) While none of the other drivers prevents user space from changing
>      the affinity, a cursorily inspection shows that there are at least
>      expectations in some drivers.
>
> #1 needs to be cleaned up anyway, so that's not a problem
>
> #2 might result in subtle regressions especially when irqbalanced (which
>    nowadays ignores the affinity hint) is disabled.
>
> Provide new interfaces:
>
>   irq_update_affinity_hint()  - Only sets the affinity hint pointer
>   irq_set_affinity_and_hint() - Set the pointer and apply the affinity to
>                                 the interrupt
>
> Make irq_set_affinity_hint() a wrapper around irq_apply_affinity_hint() and
> document it to be phased out.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> Link: https://lore.kernel.org/r/20210501021832.743094-1-jesse.brandeburg@intel.com

Reviewed-by: Ming Lei <ming.lei@redhat.com>

