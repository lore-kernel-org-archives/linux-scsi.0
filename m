From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [RFC PATCH 2.6.9-rc2] Add sysfs queue depth override to qla2xxx
Date: Tue, 28 Sep 2004 13:34:58 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040928203458.GA5585@praka.san.rr.com>
References: <B179AE41C1147041AA1121F44614F0B0012AD92B@AVEXCH02.qlogic.org> <20040928193614.GB192475@sgi.com> <1096401196.2008.97.camel@mulgrave> <20040928201257.GA22509@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:15033 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S267860AbUI1Ukl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 16:40:41 -0400
Content-Disposition: inline
In-Reply-To: <20040928201257.GA22509@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jeremy Higdon <jeremy@sgi.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 28 Sep 2004, Jens Axboe wrote:
> On Tue, Sep 28 2004, James Bottomley wrote:
> > On Tue, 2004-09-28 at 15:36, Jeremy Higdon wrote:
> > > I was trying to be conservative -- I didn't know the reason for
> > > that limit.  By all means, let's remove it then.
> > > 
> > > Would you like me to regenerate the patch, or do you just want
> > > to apply it to your internal source that will eventually be
> > > fed back to us?
> > 
> > Well, don't go overboard on this ... there is a limit to the number of
> > outstanding requests any queue can have at one time...there's not much
> > point going over that since the block layer will throttle you when you
> > reach it.  I think it's 128, but it might be 256 ... but anyway, not
> > much larger.
> 
> That depends on both the io scheduler and the nr_requests setting, I
> don't think you should rely on any imposed block layer limit.
> 

So using scsi_device->request_queue->nr_requests as a highwater mark
is out of the question?  Looking through the call-chain during
queue-depth size manipulation:

	scsi_adjust_queue()
	  blk_queue_resize_tags()
	    init_tag_map()

there appears to be a restriction of (rq->nr_requests * 2) entries:

	if (depth > q->nr_requests * 2) {
		depth = q->nr_requests * 2;
		printk(KERN_ERR "%s: adjusted depth to %d\n",
				__FUNCTION__, depth);
	}

What's an acceptable compromise?

--
Andrew
