From: Jens Axboe <axboe@suse.de>
Subject: Re: [RFC PATCH 2.6.9-rc2] Add sysfs queue depth override to qla2xxx
Date: Wed, 29 Sep 2004 08:21:09 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040929062109.GB2322@suse.de>
References: <B179AE41C1147041AA1121F44614F0B0012AD92B@AVEXCH02.qlogic.org> <20040928193614.GB192475@sgi.com> <1096401196.2008.97.camel@mulgrave> <20040928201257.GA22509@suse.de> <20040928203458.GA5585@praka.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:52914 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S268224AbUI2GXu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 02:23:50 -0400
Content-Disposition: inline
In-Reply-To: <20040928203458.GA5585@praka.san.rr.com>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>, James Bottomley <James.Bottomley@SteelEye.com>, Jeremy Higdon <jeremy@sgi.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Sep 28 2004, Andrew Vasquez wrote:
> On Tue, 28 Sep 2004, Jens Axboe wrote:
> > On Tue, Sep 28 2004, James Bottomley wrote:
> > > On Tue, 2004-09-28 at 15:36, Jeremy Higdon wrote:
> > > > I was trying to be conservative -- I didn't know the reason for
> > > > that limit.  By all means, let's remove it then.
> > > > 
> > > > Would you like me to regenerate the patch, or do you just want
> > > > to apply it to your internal source that will eventually be
> > > > fed back to us?
> > > 
> > > Well, don't go overboard on this ... there is a limit to the number of
> > > outstanding requests any queue can have at one time...there's not much
> > > point going over that since the block layer will throttle you when you
> > > reach it.  I think it's 128, but it might be 256 ... but anyway, not
> > > much larger.
> > 
> > That depends on both the io scheduler and the nr_requests setting, I
> > don't think you should rely on any imposed block layer limit.
> > 
> 
> So using scsi_device->request_queue->nr_requests as a highwater mark
> is out of the question?  Looking through the call-chain during

It can change anytime.

> queue-depth size manipulation:
> 
> 	scsi_adjust_queue()
> 	  blk_queue_resize_tags()
> 	    init_tag_map()
> 
> there appears to be a restriction of (rq->nr_requests * 2) entries:
> 
> 	if (depth > q->nr_requests * 2) {
> 		depth = q->nr_requests * 2;
> 		printk(KERN_ERR "%s: adjusted depth to %d\n",
> 				__FUNCTION__, depth);
> 	}
> 
> What's an acceptable compromise?

Yeah that logic isn't very nice. I think it's a good idea to keep the
tag depth at half the software depth, ie depth <= q->nr_requests. But
I'll remove the auto-adjust.

-- 
Jens Axboe

