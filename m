Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9E60C2B9F4
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Jun 2021 21:08:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB3FC6197D
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Jun 2021 21:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbhFYVKn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Jun 2021 17:10:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42929 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229900AbhFYVKk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Jun 2021 17:10:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624655298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8ZDICObM3KXek2Hb3yoYurGVvyXCqbMuKZU9WccmR1E=;
        b=DWfL8hLf6RsN8v6vR+QK3l/KkUsTnb4xTrOPKeCaQuvJ22XJd9/PpXIYkyi8dCO3t/ynyk
        9oq0zDAWEfaXZRuvg6QYmirBVzi248iY+DHLUr//hUGFS1I9n4Y+wG4PjAsFDbePGJllHJ
        0r5WWvPaXf9biEAhxSqXUCBlz1V3YcE=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-axOWV8ddO9yKz-bz6R4nPA-1; Fri, 25 Jun 2021 17:08:16 -0400
X-MC-Unique: axOWV8ddO9yKz-bz6R4nPA-1
Received: by mail-lj1-f200.google.com with SMTP id s22-20020a2eb8d60000b029016f35266595so3782114ljp.3
        for <linux-scsi@vger.kernel.org>; Fri, 25 Jun 2021 14:08:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8ZDICObM3KXek2Hb3yoYurGVvyXCqbMuKZU9WccmR1E=;
        b=MyZ2s6NMIjeC9g4IAk8NxpkBs00VeukKNrMERHh+JqXVzib3+cFgRrv8fkRYjdCtSQ
         sAuWLU/xODod0weyBsWsHVcbUhqEt5sdE/WfvR5aG1RBSdLpx2O8mc8wmGLqpz0z9Uaz
         ANE4U64IS1IFbE2crE1Nls/voSZuTlyzT2I67ARtoWjWL4WOHixlzIQuXO88MYvZrgyY
         KII2/S8mfHsfTLTJWBLQS0PiWTftcNk7XyphcrJJms+fdWwnkcuJXM1Cjj5OCjE0Vrv+
         vUL9KOk8k2ScTb1uKZp9K51JtWCZOJoO4Fx7NPLuUC4chxcZvRO9JWbPLH+IZv2/wyv+
         dgUA==
X-Gm-Message-State: AOAM5323TtvL4TJm/GSplfMvEZuop/DaedLWA4Ci3G+E4L5Wz7OlQTYN
        FOcUvygX7PwNjmm5+uOPWE/Sklss9wZRMiiMOqScMe8pVzKowgLFRJkjAAPI2CsHc2lSYfhxwfR
        ghOv6S1JoaekcsGTaaKSymiodZAotWRwbXiFnyw==
X-Received: by 2002:a19:520b:: with SMTP id m11mr9732678lfb.548.1624655295024;
        Fri, 25 Jun 2021 14:08:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxUexlIFHXeeKXO03SmwGePdENz2CjY0tC2d9T70zel0UdMzzrYS7rF2Shg08+5Cqm1V6fr5JNcCCdgzQuLKqk=
X-Received: by 2002:a19:520b:: with SMTP id m11mr9732628lfb.548.1624655294717;
 Fri, 25 Jun 2021 14:08:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210617182242.8637-1-nitesh@redhat.com> <20210617182242.8637-15-nitesh@redhat.com>
 <YNBHQvo1uDfBbr5c@unreal>
In-Reply-To: <YNBHQvo1uDfBbr5c@unreal>
From:   Nitesh Lal <nilal@redhat.com>
Date:   Fri, 25 Jun 2021 17:08:03 -0400
Message-ID: <CAFki+L=2nVA3FB03BjuXbj+di28LhVUzo9P9WoJyxoQFggt0VQ@mail.gmail.com>
Subject: Re: [PATCH v1 14/14] net/mlx4: Use irq_update_affinity_hint
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-api@vger.kernel.org, linux-pci@vger.kernel.org,
        tglx@linutronix.de, jesse.brandeburg@intel.com,
        robin.murphy@arm.com, mtosatti@redhat.com, mingo@kernel.org,
        jbrandeb@kernel.org, frederic@kernel.org, juri.lelli@redhat.com,
        abelits@marvell.com, bhelgaas@google.com, rostedt@goodmis.org,
        peterz@infradead.org, davem@davemloft.net,
        akpm@linux-foundation.org, sfr@canb.auug.org.au,
        stephen@networkplumber.org, rppt@linux.vnet.ibm.com,
        chris.friesen@windriver.com, maz@kernel.org, nhorman@tuxdriver.com,
        pjwaskiewicz@gmail.com, sassmann@redhat.com, thenzl@redhat.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com,
        sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jkc@redhat.com, faisal.latif@intel.com,
        shiraz.saleem@intel.com, tariqt@nvidia.com, ahleihel@redhat.com,
        kheib@redhat.com, borisp@nvidia.com, saeedm@nvidia.com,
        benve@cisco.com, govind@gmx.com, jassisinghbrar@gmail.com,
        luobin9@huawei.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jun 21, 2021 at 4:02 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Thu, Jun 17, 2021 at 02:22:42PM -0400, Nitesh Narayan Lal wrote:
> > The driver uses irq_set_affinity_hint() to update the affinity_hint mask
> > that is consumed by the userspace to distribute the interrupts. However,
> > under the hood irq_set_affinity_hint() also applies the provided cpumask
> > (if not NULL) as the affinity for the given interrupt which is an
> > undocumented side effect.
> >
> > To remove this side effect irq_set_affinity_hint() has been marked
> > as deprecated and new interfaces have been introduced. Hence, replace the
> > irq_set_affinity_hint() with the new interface irq_update_affinity_hint()
> > that only updates the affinity_hint pointer.
> >
> > Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> > ---
> >  drivers/net/ethernet/mellanox/mlx4/eq.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx4/eq.c b/drivers/net/ethernet/mellanox/mlx4/eq.c
> > index 9e48509ed3b2..f549d697ca95 100644
> > --- a/drivers/net/ethernet/mellanox/mlx4/eq.c
> > +++ b/drivers/net/ethernet/mellanox/mlx4/eq.c
> > @@ -244,9 +244,9 @@ static void mlx4_set_eq_affinity_hint(struct mlx4_priv *priv, int vec)
> >           cpumask_empty(eq->affinity_mask))
> >               return;
> >
> > -     hint_err = irq_set_affinity_hint(eq->irq, eq->affinity_mask);
> > +     hint_err = irq_update_affinity_hint(eq->irq, eq->affinity_mask);
> >       if (hint_err)
> > -             mlx4_warn(dev, "irq_set_affinity_hint failed, err %d\n", hint_err);
> > +             mlx4_warn(dev, "irq_update_affinity_hint failed, err %d\n", hint_err);
> >  }
> >  #endif
> >
> > @@ -1124,7 +1124,7 @@ static void mlx4_free_irqs(struct mlx4_dev *dev)
> >               if (eq_table->eq[i].have_irq) {
> >                       free_cpumask_var(eq_table->eq[i].affinity_mask);
> >  #if defined(CONFIG_SMP)
> > -                     irq_set_affinity_hint(eq_table->eq[i].irq, NULL);
> > +                     irq_update_affinity_hint(eq_table->eq[i].irq, NULL);
> >  #endif
>
> This #if/endif can be deleted.

I think we also can get rid of the other #if/endif CONFIG_SMP
occurrences that are present around mlx4_set_eq_affinity_hint()
definition and call, isn't it?
There is already a check-in interrupt.h so doing it again in the
driver looks like an unwanted repetition IMHO.

>
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
>


-- 
Thanks
Nitesh

