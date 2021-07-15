Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C2FFC07E96
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Jul 2021 13:25:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2D7A61360
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Jul 2021 13:25:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237628AbhGON2p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Jul 2021 09:28:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39738 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237627AbhGON2o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 15 Jul 2021 09:28:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626355550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ah4MbGoLYz8PpeIyy6Wrw1o1Gg/0NPYNIWwDGG2q9MQ=;
        b=Yjhgzq/9+T6TYDTj+dynlj69arM5UrkCmKAk20jjnNhSrYVT8URBEC8oqVsOkxcpTH8Lzm
        NKiP1/RUzrLl++zGnllN90+vhBd6bGAsawFHgHDVW7zvmLWRYnatN+PGuJCNg7QfGUhESt
        5FRyJX2omwilLAkjRexwCtZ0wBSrp2s=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-535-y6IXfal5PbO03pOMnj6nZA-1; Thu, 15 Jul 2021 09:25:49 -0400
X-MC-Unique: y6IXfal5PbO03pOMnj6nZA-1
Received: by mail-lj1-f200.google.com with SMTP id m20-20020a2ea5940000b0290186d4298a1cso3187629ljp.10
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jul 2021 06:25:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ah4MbGoLYz8PpeIyy6Wrw1o1Gg/0NPYNIWwDGG2q9MQ=;
        b=KAKicCivG0TaPXStaQ9aK/UPNP6Ws1O/Y99B29zh5GvfZGszterqh/dlLay7Hkr/DG
         k7CRWwm5oq6yYB49cFZ9EhX0ZQComAo/B4j9/wFFhdExs/vMb3r474DKRtxO3oNJkyBw
         qyX6bsxQn4R4nlL42jnxVZoTYSmWr+4h+ezm7kvuW/zXpEA/Cl6Byg7tpIHmIwQoJt8i
         losF+Wt7VXGp73VFQHNTQek8C+dT4zop4ZvbsZWbMoLayy+PJW6P+iLZVyfUbc2IFCfT
         Oz/hefapC7Zdg7H7loXvOcEMbJRdumt6wPUX9r2R0Tyh6i5LyIw4LBdU+zlofEDxPSPi
         UcWw==
X-Gm-Message-State: AOAM530BZPMNtoR1uWx9Bk2DKTV507bt8ZLKVq8Q0TlbuFQ6HYcXrajE
        7GMFWktxUykH5YcchNWYDJoiVS/IqhwBx0sXx02aS4CI9sca1iW/pRLRSOCiUHDN2UpqnGfDzgk
        8bsy0jZNd/+AkjjXRvYEre6Um7u4zQrqsYU8yHA==
X-Received: by 2002:a05:6512:3a86:: with SMTP id q6mr3149858lfu.548.1626355548016;
        Thu, 15 Jul 2021 06:25:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4dI6Pl2Y//20EnkEGgAcCVbyTORH0YWaTKsr2JdguYEYFI2ihDlt/NUiNtPNi9bYu/OMUSwAlGGsYWpUxV5M=
X-Received: by 2002:a05:6512:3a86:: with SMTP id q6mr3149783lfu.548.1626355547649;
 Thu, 15 Jul 2021 06:25:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210713211502.464259-1-nitesh@redhat.com> <20210713211502.464259-7-nitesh@redhat.com>
 <YO7SiFE1dE0dFhkE@unreal> <CAFki+Lm-CpKZai1fV5aMJzEb-x+003m8wLQShSrYpyNh3XC50Q@mail.gmail.com>
 <YO7ggLW78FWE4z+1@unreal>
In-Reply-To: <YO7ggLW78FWE4z+1@unreal>
From:   Nitesh Lal <nilal@redhat.com>
Date:   Thu, 15 Jul 2021 09:25:36 -0400
Message-ID: <CAFki+L=KoVzAv-_tLjAJV91BR+fHTPffMsCs-AgSCNyE0d-0DQ@mail.gmail.com>
Subject: Re: [PATCH v3 06/14] RDMA/irdma: Use irq_set_affinity_and_hint
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-api@vger.kernel.org, linux-pci@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
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
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Ken Cox <jkc@redhat.com>, faisal.latif@intel.com,
        shiraz.saleem@intel.com, tariqt@nvidia.com,
        Alaa Hleihel <ahleihel@redhat.com>,
        Kamal Heib <kheib@redhat.com>, borisp@nvidia.com,
        saeedm@nvidia.com, benve@cisco.com, govind@gmx.com,
        jassisinghbrar@gmail.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        "Nikolova, Tatyana E" <tatyana.e.nikolova@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        Al Stone <ahs3@redhat.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 14, 2021 at 9:03 AM Leon Romanovsky <leonro@nvidia.com> wrote:
>
> On Wed, Jul 14, 2021 at 08:56:41AM -0400, Nitesh Lal wrote:
> > On Wed, Jul 14, 2021 at 8:03 AM Leon Romanovsky <leonro@nvidia.com> wrote:
> > >
> > > On Tue, Jul 13, 2021 at 05:14:54PM -0400, Nitesh Narayan Lal wrote:
> > > > The driver uses irq_set_affinity_hint() to update the affinity_hint mask
> > > > that is consumed by the userspace to distribute the interrupts and to apply
> > > > the provided mask as the affinity for its interrupts. However,
> > > > irq_set_affinity_hint() applying the provided cpumask as an affinity for
> > > > the interrupt is an undocumented side effect.
> > > >
> > > > To remove this side effect irq_set_affinity_hint() has been marked
> > > > as deprecated and new interfaces have been introduced. Hence, replace the
> > > > irq_set_affinity_hint() with the new interface irq_set_affinity_and_hint()
> > > > where the provided mask needs to be applied as the affinity and
> > > > affinity_hint pointer needs to be set and replace with
> > > > irq_update_affinity_hint() where only affinity_hint needs to be updated.
> > > >
> > > > Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> > > > ---
> > > >  drivers/infiniband/hw/irdma/hw.c | 4 ++--
> > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
> > > > index 7afb8a6a0526..7f13a051d4de 100644
> > > > --- a/drivers/infiniband/hw/irdma/hw.c
> > > > +++ b/drivers/infiniband/hw/irdma/hw.c
> > > > @@ -537,7 +537,7 @@ static void irdma_destroy_irq(struct irdma_pci_f *rf,
> > > >       struct irdma_sc_dev *dev = &rf->sc_dev;
> > > >
> > > >       dev->irq_ops->irdma_dis_irq(dev, msix_vec->idx);
> > > > -     irq_set_affinity_hint(msix_vec->irq, NULL);
> > > > +     irq_update_affinity_hint(msix_vec->irq, NULL);
> > > >       free_irq(msix_vec->irq, dev_id);
> > > >  }
> > > >
> > > > @@ -1087,7 +1087,7 @@ irdma_cfg_ceq_vector(struct irdma_pci_f *rf, struct irdma_ceq *iwceq,
> > > >       }
> > > >       cpumask_clear(&msix_vec->mask);
> > > >       cpumask_set_cpu(msix_vec->cpu_affinity, &msix_vec->mask);
> > > > -     irq_set_affinity_hint(msix_vec->irq, &msix_vec->mask);
> > > > +     irq_set_affinity_and_hint(msix_vec->irq, &msix_vec->mask);
> > >
> > > I think that it needs to be irq_update_affinity_hint().
> > >
> >
> > Ah! I got a little confused from our last conversation about mlx5.
> >
> > IIUC mlx5 sub-function use case uses irdma (?) and that's why I thought
> > that perhaps we would also want to define the affinity here from the beginning.
>
> mlx5 is connected to mlx5_ib/mlx5_vdpa e.t.c.
>
> Not sure about that, but I think that only mlx5 implements SIOV model.
>
> >
> > In any case, I will make the change and re-post.
> >

Just FYI, I am hoping to collect more comments in the non-reviewed
patches and address them in v4.
Hence, I will wait for this week if I don't get anything I will just
post another version by making the change in this driver.

-- 
Thanks
Nitesh

