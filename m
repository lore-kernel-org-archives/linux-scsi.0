From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] BUG: nr_phys_segments cannot be less than nr_hw_segments
Date: Thu, 2 Oct 2008 19:13:57 +0200
Message-ID: <20081002171356.GO19428@kernel.dk>
References: <200810021959.33616.knikanth@suse.de> <1222959814.3222.5.camel@localhost.localdomain> <20081002165857.GL19428@kernel.dk> <1222967563.3222.30.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpa.tele.dk ([80.160.77.114]:41683 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754002AbYJBROS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Oct 2008 13:14:18 -0400
Content-Disposition: inline
In-Reply-To: <1222967563.3222.30.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Thu, Oct 02 2008, James Bottomley wrote:
> On Thu, 2008-10-02 at 18:58 +0200, Jens Axboe wrote:
> > On Thu, Oct 02 2008, James Bottomley wrote:
> > > The bug would appear to be that we sometimes only look at q->max_sectors
> > > when deciding on mergability.  Either we have to insist on max_sectors
> > > <= hw_max_sectors, or we have to start using min(q->max_sectors,
> > > q->max_hw_sectors) for this.
> > 
> > q->max_sectors MUST always be <= q->max_hw_sectors, otherwise we could
> > be sending down requests that are too large for the device to handle. So
> > that condition would be a big bug. The sysfs interface checks for this,
> > and blk_queue_max_sectors() makes sure that is true as well.
> 
> Yes, that seems always to be enforced.  Perhaps there are other ways of
> tripping this problem ... I'm still sure if it occurs it's because we do
> a physical merge where a virtual merge is forbidden.
> 
> > The fixes proposed still look weird. There is no phys vs hw segment
> > constraints, the request must adhere to the limits set by both. It's
> > mostly a moot point anyway, as 2.6.28 will get rid of the hw accounting
> > anyway.
> 
> Agree all three proposed fixes look wrong.  However, if it's what I
> think, just getting rid of hw accounting won't fix the problem because
> we'll still have the case where a physical merge is forbidden by iommu
> constraints ... this still needs to be accounted for.
> 
> What we really need is a demonstration of what actually is going
> wrong ...

Yep, IIRC we both asked for that the last time as well... Nikanth?

-- 
Jens Axboe

