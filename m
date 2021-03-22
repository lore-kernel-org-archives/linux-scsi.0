Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B51C433C1
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 16:40:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33F6C61983
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 16:40:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbhCVQjf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 12:39:35 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:50682 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232148AbhCVQjD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Mar 2021 12:39:03 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 12MGcp36023594;
        Mon, 22 Mar 2021 17:38:51 +0100
Date:   Mon, 22 Mar 2021 17:38:51 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        target-devel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] target: pscsi: avoid Wempty-body warning
Message-ID: <20210322163851.GC23467@1wt.eu>
References: <20210322114441.3479365-1-arnd@kernel.org>
 <20210322154735.GA2079192@infradead.org>
 <20210322155344.GA23040@1wt.eu>
 <CAK8P3a1bb4QvNyM9kkt0KB9k70cdEZ-e+B-CHHtPhaPO6ouxeQ@mail.gmail.com>
 <20210322162601.GB23467@1wt.eu>
 <CAK8P3a3f2vXBsEg_vWoc1qFBdy9dqO7txcwhpSTVCRBpGf9u=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a3f2vXBsEg_vWoc1qFBdy9dqO7txcwhpSTVCRBpGf9u=w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Mar 22, 2021 at 05:34:48PM +0100, Arnd Bergmann wrote:
> On Mon, Mar 22, 2021 at 5:26 PM Willy Tarreau <w@1wt.eu> wrote:
> > On Mon, Mar 22, 2021 at 05:18:23PM +0100, Arnd Bergmann wrote:
> > > and a lot mostly harmless code like
> > >
> > > #ifdef DEBUG_THIS_DRIVER /* always disabled */
> > > #define dprintk(args...) printk(args)
> > > #else
> > > #define dprintk(args...)
> > > #endif
> > >     /* note the mismatched format string */
> > >     dprintk(KERN_WARNING "error %d\n", &object);
> > >
> > > Turning the empty dprintk() into no_printk() means we can catch
> > > the wrong format string during compile testing.
> >
> > Hmmm OK for this one. With this said, given how plenty of warnings seem
> > to consider indent and whatever, I wouldn't be surprised if a difference
> > is made between a totally empty body and one that results from an empty
> > macro. But indeed this one can represent a real bug.
> 
> The -Wempty-body warning is actually really old and predates the compiler's
> understanding of indentation, we just always disabled it by default so far.
> 
> As a lot of subsystems are W=1 clean these days, I just went for the
> final 26 patches to shut up all empty-body warnings in randconfig builds.
> Most of these were in the dprink() category, though none of this last set
> actually had incorrect format strings.

I agree that if it's only 26 patches on the whole kernel to re-enable one
warning it can be worth it for newcomers.

Willy
