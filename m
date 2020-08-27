Return-Path: <SRS0=qcVN=CF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD930C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 08:54:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6B642177B
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 08:54:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgH0IyG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Aug 2020 04:54:06 -0400
Received: from verein.lst.de ([213.95.11.211]:37293 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728001AbgH0Ix6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Aug 2020 04:53:58 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id C68FE68B02; Thu, 27 Aug 2020 10:53:53 +0200 (CEST)
Date:   Thu, 27 Aug 2020 10:53:53 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Denis Efremov <efremov@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org
Subject: Re: [PATCH 01/19] char_dev: replace cdev_map with an xarray
Message-ID: <20200827085353.GA12111@lst.de>
References: <20200826062446.31860-1-hch@lst.de> <20200826062446.31860-2-hch@lst.de> <20200826081905.GB1796103@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200826081905.GB1796103@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 26, 2020 at 10:19:05AM +0200, Greg Kroah-Hartman wrote:
> On Wed, Aug 26, 2020 at 08:24:28AM +0200, Christoph Hellwig wrote:
> > None of the complicated overlapping regions bits of the kobj_map are
> > required for the character device lookup, so just a trivial xarray
> > instead.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Really?  This is ok to use and just as fast?  If so, wonderful, it would
> be great to clean up kobj_map users.

Xarrays provide pretty efficient as long as we have a unsigned long
or smaller index (check, dev_t is small) and the indices are reasonable
clustered (check, minors for the same major).  Memory usage will go down
vs the probes, and lookup speed up.

> > +	mutex_lock(&chrdevs_lock);
> > +	for (i = 0; i < count; i++) {
> > +		error = xa_insert(&cdev_map, dev + i, p, GFP_KERNEL);
> > +		if (error)
> > +			goto out_unwind;
> > +	}
> > +	mutex_unlock(&chrdevs_lock);
> >  
> >  	kobject_get(p->kobj.parent);
> 
> Can't you drop this kobject_get() too?

I'll have to drop it or add back the put on the delete side.  And
I think the latter is safer for now, because..

> 
> And also the "struct kobj" in struct cdev can be gone as well, as the
> kobj_map was the only "real" user of this structure.  I know some
> drivers liked to touch that field as well, but it never actually did
> anything for them, so it was pointless, but it will take some 'make
> allmodconfig' builds to flush them out.

I looked at it, but it does get registered and shows up in sysfs.
I don't really dare to touch this for now, as it can have huge
implications.  Better done in a separate series (if we can actually do
it at all).
