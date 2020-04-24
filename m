Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8B66C2BA1A
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 07:29:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAAFE20724
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 07:29:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgDXH3d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 03:29:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:32952 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbgDXH3d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Apr 2020 03:29:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5871FAA55;
        Fri, 24 Apr 2020 07:29:30 +0000 (UTC)
Date:   Fri, 24 Apr 2020 09:29:30 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, maier@linux.ibm.com,
        bvanassche@acm.org, herbszt@gmx.de, natechancellor@gmail.com,
        rdunlap@infradead.org, hare@suse.de,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: Re: [PATCH v3 04/31] elx: libefc_sli: queue create/destroy/parse
 routines
Message-ID: <20200424072930.f3snaykeuycz3aly@beryllium.lan>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-5-jsmart2021@gmail.com>
 <20200415100445.qdmx34sekrsyjo7r@carbon>
 <a1837942-f6d8-a8bf-d6a6-c2d10ceb5e7e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1837942-f6d8-a8bf-d6a6-c2d10ceb5e7e@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Apr 21, 2020 at 10:05:26PM -0700, James Smart wrote:
> On 4/15/2020 3:04 AM, Daniel Wagner wrote:
> ...
> > > +static void
> > > +__sli_queue_destroy(struct sli4 *sli4, struct sli4_queue *q)
> > > +{
> > > +	if (!q->dma.size)
> > > +		return;
> > > +
> > > +	dma_free_coherent(&sli4->pcidev->dev, q->dma.size,
> > > +			  q->dma.virt, q->dma.phys);
> > > +	memset(&q->dma, 0, sizeof(struct efc_dma));
> > 
> > Is this necessary to clear q->dma? Just asking if it's possible to
> > avoid the additional work.
> 
> unfortunately, yes - at least q->dma.size must be cleared. It's used to
> detect validity (must be non-0).

I see.

> > > +sli_mq_write(struct sli4 *sli4, struct sli4_queue *q,
> > > +	     u8 *entry)
> > > +{
> > > +	u8 *qe = q->dma.virt;
> > > +	u32 qindex;
> > > +	u32 val = 0;
> > > +	unsigned long flags;
> > > +
> > > +	spin_lock_irqsave(&q->lock, flags);
> > > +	qindex = q->index;
> > > +	qe += q->index * q->size;
> > > +
> > > +	memcpy(qe, entry, q->size);
> > > +	q->n_posted = 1;
> > 
> > Shouldn't this be q->n_posted++ ? Or is it garanteed n_posted is 0?
> 
> yes - we post 1 at a time.

Sorry to ask again, but I worried that sli_mq_write() is called while there is
work pending. Maybe it could at least documented with something like
WARN_ON_ONCE(n_posted != 0)
