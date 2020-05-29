Return-Path: <SRS0=G6Im=7L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 962A4C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 12:50:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 722C02077D
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 12:50:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="C0IWS1dW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgE2Mu2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 May 2020 08:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbgE2Mu1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 May 2020 08:50:27 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81016C03E969
        for <linux-scsi@vger.kernel.org>; Fri, 29 May 2020 05:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=TRH1Ix3mcxAPDs567/EdD/x3xvme63hlmV4ApG80QXg=; b=C0IWS1dWCabKJnwM4vpF4orrsL
        RbbN+8Bo6u+23bTnQmJb2DHbo5rH2EcatftMGk5KvOcaZ6EbM7+sN3/tU13yY1Afr8BmfjPj9opqO
        blsJKl8q8j6erSj9384t3us9ZYCu9hzjJjQqm9zzcDOZwVXFxccEx6BOCvA7DA35vyHtyAaJc8EWM
        ytVULEILO2LNaHfKVVdtPjvMrIjOvzWSI2atWhU5+Gtt8h4aq5oYX2VoT+XK14ghqdilrChF0bn8s
        hTbYZf985JlujymR1uLokdAklm5J7dMPgQTATXrP3VByAzN6oVeFbf4rDvVvIVOUn2NCxBPR5fq1Z
        BYqfahaA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jeeSs-0000tM-K4; Fri, 29 May 2020 12:50:22 +0000
Date:   Fri, 29 May 2020 05:50:22 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Douglas Gilbert <dgilbert@interlog.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Daniel Wagner <daniel.wagner@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/4] scsi: move target device list to xarray
Message-ID: <20200529125022.GA19604@bombadil.infradead.org>
References: <20200528163625.110184-1-hare@suse.de>
 <20200528163625.110184-4-hare@suse.de>
 <a6b85428-f32c-e57b-fa3e-e376400819ac@interlog.com>
 <20200528185402.GP17206@bombadil.infradead.org>
 <c33c3000-caac-4b51-42fd-d6e13a9fd641@suse.de>
 <20200529002056.GS17206@bombadil.infradead.org>
 <8c84ac5f-f64a-0372-5738-fb49f2d01c91@suse.de>
 <20200529112107.GT17206@bombadil.infradead.org>
 <6ed49962-479e-ced7-16b4-095c8f5f70d6@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ed49962-479e-ced7-16b4-095c8f5f70d6@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, May 29, 2020 at 02:46:48PM +0200, Hannes Reinecke wrote:
> On 5/29/20 1:21 PM, Matthew Wilcox wrote:
> > On Fri, May 29, 2020 at 08:50:21AM +0200, Hannes Reinecke wrote:
> > > > I meant just use xa_alloc() for everything instead of using xa_insert for
> > > > 0-255.
> > > > 
> > > But then I'll have to use xa_find() to get to the actual element as the 1:1
> > > mapping between SCSI LUN and array index is lost.
> > > And seeing that most storage arrays will expose only up to 256 LUNs I
> > > thought this was a good improvement on lookup.
> > > Of course, this only makes sense if xa_load() is more efficient than
> > > xa_find(). If not then of course it's a bit futile.
> > 
> > xa_load() is absolutely more efficient than xa_find().  It's just a
> > question of whether it matters ;-)  Carry on ...
> > 
> Thanks. I will.
> 
> BTW, care to update the documentation?
> 
>  * Return: 0 on success, -ENOMEM if memory could not be allocated or
>  * -EBUSY if there are no free entries in @limit.
>  */
> int __xa_alloc(struct xarray *xa, u32 *id, void *entry,
> 		struct xa_limit limit, gfp_t gfp)
> {
> 	XA_STATE(xas, xa, 0);
> 
> 	if (WARN_ON_ONCE(xa_is_advanced(entry)))
> 		return -EINVAL;
> 	if (WARN_ON_ONCE(!xa_track_free(xa)))
> 		return -EINVAL;
> 
> So looks as if the documentation is in need of updating to cover -EINVAL.
> And, please, state somewhere that whenever you want to use xa_alloc() you
> _need_ to specify XA_ALLOC_FLAGS in xa_init_flags(), otherwise
> you trip across the above.

Like this?

Allocating XArrays
------------------

If you use DEFINE_XARRAY_ALLOC() to define the XArray, or
initialise it by passing ``XA_FLAGS_ALLOC`` to xa_init_flags(),
the XArray changes to track whether entries are in use or not.

You can call xa_alloc() to store the entry at an unused index
in the XArray.  If you need to modify the array from interrupt context,
you can use xa_alloc_bh() or xa_alloc_irq() to disable
interrupts while allocating the ID.


> It's not entirely obvious, and took me the better half of a day to figure
> out.

Really?  You get a nice WARN_ON and backtrace so you can see where
you went wrong ... What could I change to make this easier?
