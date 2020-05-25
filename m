Return-Path: <SRS0=b1yV=7H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACD15C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 25 May 2020 17:41:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 815882078B
	for <linux-scsi@archiver.kernel.org>; Mon, 25 May 2020 17:41:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fyB1wRIy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389192AbgEYRlA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 May 2020 13:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388182AbgEYRk7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 May 2020 13:40:59 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C59C061A0E
        for <linux-scsi@vger.kernel.org>; Mon, 25 May 2020 10:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=75fA6YYTg+V53H+Vu2xTlNDfd/arTeJZA94D4UHdyx4=; b=fyB1wRIyC2ZeDqRZ2P1Ro63XTM
        /CcszrxHBBJ/g0yVq2j8PcC8esyqIVz7h4apA+G7IZZ6nGmQ/KkoMa13ltxRnRgbtQE6KHIemzVMV
        QF2ReqmWlsqDys2Y+8EMtB4rQ/t033bG2sQMeeIDYhwjjkoImehQ8JKhqClV25exD6hBfcrSYIjGw
        39qgJ69sZq9R8u0RmKz5FxSRfBezJhBtRkpduWhcSlYS1PdB9Kgs7F2RQmh1zMxv5LhL4xX8RLUBG
        63iAA4WBRffhYhTTZGH3WKshO7YqIL8qsTYDu2/di8hnVcURld1g7ngC0X6yLcayizhZWbITGe5Ls
        7I24b2yg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jdH5o-0002zu-Da; Mon, 25 May 2020 17:40:52 +0000
Date:   Mon, 25 May 2020 10:40:52 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Subject: Re: [RFC v2 1/6] scsi: xarray hctl
Message-ID: <20200525174052.GD17206@bombadil.infradead.org>
References: <20200524155814.5895-1-dgilbert@interlog.com>
 <20200524155814.5895-2-dgilbert@interlog.com>
 <6527a0ca-954c-70e8-f0f5-08206c1779f2@suse.de>
 <8dab99d1-a22d-0065-5a7a-fd9b80bc661a@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8dab99d1-a22d-0065-5a7a-fd9b80bc661a@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, May 25, 2020 at 12:30:52PM -0400, Douglas Gilbert wrote:
> On 2020-05-25 2:57 a.m., Hannes Reinecke wrote:
> > On 5/24/20 5:58 PM, Douglas Gilbert wrote:
> > > +++ b/drivers/scsi/scsi.c
> > > @@ -554,19 +554,32 @@ EXPORT_SYMBOL(scsi_device_put);
> > >   struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *shost,
> > >                          struct scsi_device *prev)
> > >   {
> > > -    struct list_head *list = (prev ? &prev->siblings : &shost->__devices);
> > > -    struct scsi_device *next = NULL;
> > > -    unsigned long flags;
> > > +    struct scsi_device *next = prev;
> > > +    unsigned long flags, l_idx;
> > >       spin_lock_irqsave(shost->host_lock, flags);
> > > -    while (list->next != &shost->__devices) {
> > > -        next = list_entry(list->next, struct scsi_device, siblings);
> > > -        /* skip devices that we can't get a reference to */
> > > -        if (!scsi_device_get(next))
> > > -            break;
> > > +    if (xa_empty(&shost->__devices)) {
> > >           next = NULL;
> > > -        list = list->next;
> > > +        goto unlock;
> > >       }

You don't need this stanza.  xa_find() will do the right thing (ie return
NULL) with an empty array.

> > > +    do {
> > > +        if (!next) {    /* get first element iff first iteration */
> > > +            l_idx = 0;
> > > +            next = xa_find(&shost->__devices, &l_idx,
> > > +                       scsi_xa_limit_16b.max, XA_PRESENT);

You don't need to use a 16-bit limit here; the XArray code will stop after
the end of the array, and the only thing you might save is scanning the top
node unnecessarily far.  To get there, you'd have to have an index >= 2^12,
and the additional limit would mean that you'd scan the first 16 entries of
the top node instead of all 64.  Kind of pales into insignificance compared
to actually walking all 2^12 elements up to that point ;-)

> > > @@ -391,8 +391,8 @@ static void scsi_single_lun_run(struct
> > > scsi_device *current_sdev)
> > >       spin_lock_irqsave(shost->host_lock, flags);
> > >       if (starget->starget_sdev_user)
> > >           goto out;
> > > -    list_for_each_entry_safe(sdev, tmp, &starget->devices,
> > > -            same_target_siblings) {
> > > +    /* XARRAY: was list_for_each_entry_safe(); is this safe ? */
> > > +    xa_for_each(&starget->devices, l_idx, sdev) {
> > >           if (sdev == current_sdev)
> > >               continue;
> > >           if (scsi_device_get(sdev))
> > 
> > Frankly, I don't know why we're using the _safe variant here.
> > Typically the _safe variant is used to protect against removal
> > (ie if a list element is removed while iterating over the list),
> > but I can't really imagine why starting I/O on the device would
> > cause one entry to be deleted...
> > James?

... to add, xa_for_each() is safe against deletion while walking.
Or addition while walking.

> > > @@ -234,8 +234,9 @@ static struct scsi_device
> > > *scsi_alloc_sdev(struct scsi_target *starget,
> > >       sdev->channel = starget->channel;
> > >       mutex_init(&sdev->state_mutex);
> > >       sdev->sdev_state = SDEV_CREATED;
> > > -    INIT_LIST_HEAD(&sdev->siblings);
> > > -    INIT_LIST_HEAD(&sdev->same_target_siblings);
> > > +    /* XARRAY: INIT_LIST_HEAD()s here on list leaves, why ? */
> > > +    sdev->sh_idx = -1;
> > > +    sdev->starg_idx = -1;        /* for debugging */
> > >       INIT_LIST_HEAD(&sdev->starved_entry);
> > >       INIT_LIST_HEAD(&sdev->event_list);
> > >       spin_lock_init(&sdev->list_lock);
> > 
> > It is good practice to call INIT_LIST_HEAD() on list leaves as then you
> > can call 'list_empty()' to figure out if they are part of a list or not.
> > 
> > But I'm wondering about the 'sh_idx' and the 'starg_idx' here.
> > We already have perfectly good indices with the 'lun' and 'id' entries
> > in struct scsi_device, which (incidentally) _need_ to be unique.
> > 
> > So why not use them?
> 
> Ah now we have something to discuss and perhaps Willy can help
> 
> At the target level we have two indexes:
>    - channel (is 16 bits enough)
>    - target (16 or 32 bits?)
> This could be address to ways:
>    1) introduce struct scsi_channel {int num_chans; scsi_target *t1p;}
>    2) combine channnel and target into one 32 bit integer.
> 
> The xarray type of its index seems to be unsigned long (Willy,
> is that correct?). That is the same size as a pointer, 32 bits
> on a 32 bit machine, 64 bits on a 64 bit machine. That is
> unfortunate, since we can represent the full 64 bit LUN as
> a single index on a 32 bit machine. We could 'hide' that and
> have two xarrays in scsi_device for 32 bit machines.

You aren't the first person to ask about having a 64-bit lookup on
32-bit machines.  Indeed, I remember Hannes asking for a 256 bit lookup
at LinuxCon in Prague.  I have always been reluctant to add such a thing because the XArray uses quite a naive data type underneath.  It works well with
dense arrays but becomes very wasteful of memory for sparse arrays.

My understanding of SCSI-world is that most devices have a single
LUN 0.  Most devices that have multiple LUNs number them sequentially.
Some devices have either an internal structure or essentially pick random
LUNs for the devices they expose.

> So to start with, I took the easy approach, the one that most
> resembles the what include/linux/list.h has been using. There
> is also a (overly ?) complex locking scheme that I really did
> not want to upset.

I think this is currently the best way to use the XArray.  I do have
a project in the works to replace the data structure implementing the
XArray API with a better one, but that project has been underway for
almost two years now, so I would have a hard time suggesting that you
wait for it to be ready.

> Those num_chans, t1p members that I put in scsi_channel is just
> to show the xarray lookup can be bypassed when num_chans=1
> which is very likely. Same approach could be taken in scsi_target
> to scsi_device.

If you do only have a single entry at 0, the XArray is very efficient.
It simplifies to a single pointer.  You don't need to optimise for that
case yourself ;-)

> > > @@ -326,6 +331,7 @@ static void scsi_target_dev_release(struct device *dev)
> > >       struct device *parent = dev->parent;
> > >       struct scsi_target *starget = to_scsi_target(dev);
> > > +    xa_destroy(&starget->devices);

By the way, you don't have to call xa_destroy() if you know the array
is empty.  The IDR used to have that unfortunate requirement, and about a
third of users blissfully ignored it, leaking uncounted amounts of memory.

> > > @@ -445,7 +455,15 @@ static struct scsi_target
> > > *scsi_alloc_target(struct device *parent,
> > >       if (found_target)
> > >           goto found;
> > > -    list_add_tail(&starget->siblings, &shost->__targets);
> > > +    /* XARRAY: was list_add_tail(); may get hole in xarray or tail */
> > > +    res = xa_alloc(&shost->__targets, &u_idx, starget, scsi_xa_limit_16b,
> > > +               GFP_ATOMIC);
> > > +    if (res < 0) {
> > > +        spin_unlock_irqrestore(shost->host_lock, flags);
> > > +        pr_err("%s: xa_alloc failure errno=%d\n", __func__, -res);
> > > +        return NULL;
> > > +    }
> > > +    starget->sh_idx = u_idx;
> > >       spin_unlock_irqrestore(shost->host_lock, flags);
> > >       /* allocate and add */
> > >       transport_setup_device(dev);
> > 
> > 'scsi_xa_limit_16b' ?
> > What's that for?
> 
> See include/linux/xarray.h xa_limit_32b
> 
> This is a 16 bit equivalent. Not sure if that is too restrictive.
> Anyway, the xa_alloc() call amongst others needs an upper and
> lower bound.

I'm happy to have an xa_limit_16b in xarray.h.  I estimate it would have
about 5-10 users across the entire kernel.

> > And, again, if we were to use the target id as an index we could be
> > using 'xa_store' and the problem would be solved...

It may make sense to use an allocating XArray for LUNs and targets, but
use the channel ID directly.  It depends how structured these things
are in SCSI, and I'll admit I haven't been keeping up with how SCSI
numbers things on a modern system (I suspect 99.9% of SCSI devices
are USB keys with one host, one channel, one target, one LUN, but
that the 0.1% of SCSI devices on Linux systems are responsible for 80%
of the performance end of the market)

