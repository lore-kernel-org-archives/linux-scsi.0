From: Jens Axboe <axboe@suse.de>
Subject: Re: [RFC PATCH 2.6.9-rc2] Add sysfs queue depth override to qla2xxx
Date: Wed, 29 Sep 2004 08:56:58 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040929065657.GD2322@suse.de>
References: <B179AE41C1147041AA1121F44614F0B0012AD92B@AVEXCH02.qlogic.org> <20040928193614.GB192475@sgi.com> <1096401196.2008.97.camel@mulgrave> <20040928201257.GA22509@suse.de> <20040928203458.GA5585@praka.san.rr.com> <20040929062109.GB2322@suse.de> <20040929065753.GB195483@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:19133 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S268260AbUI2G7l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 02:59:41 -0400
Content-Disposition: inline
In-Reply-To: <20040929065753.GB195483@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Sep 28 2004, Jeremy Higdon wrote:
> On Wed, Sep 29, 2004 at 08:21:09AM +0200, Jens Axboe wrote:
> > On Tue, Sep 28 2004, Andrew Vasquez wrote:
> > > On Tue, 28 Sep 2004, Jens Axboe wrote:
> > > > On Tue, Sep 28 2004, James Bottomley wrote:
> > > > > 
> > > > > Well, don't go overboard on this ... there is a limit to the number of
> > > > > outstanding requests any queue can have at one time...there's not much
> > > > > point going over that since the block layer will throttle you when you
> > > > > reach it.  I think it's 128, but it might be 256 ... but anyway, not
> > > > > much larger.
> > > > 
> > > > That depends on both the io scheduler and the nr_requests setting, I
> > > > don't think you should rely on any imposed block layer limit.
> > > > 
> > > 
> > > So using scsi_device->request_queue->nr_requests as a highwater mark
> > > is out of the question?  Looking through the call-chain during
> > 
> > It can change anytime.
> > 
> > > queue-depth size manipulation:
> > > 
> > > 	scsi_adjust_queue()
> > > 	  blk_queue_resize_tags()
> > > 	    init_tag_map()
> > > 
> > > there appears to be a restriction of (rq->nr_requests * 2) entries:
> > > 
> > > 	if (depth > q->nr_requests * 2) {
> > > 		depth = q->nr_requests * 2;
> > > 		printk(KERN_ERR "%s: adjusted depth to %d\n",
> > > 				__FUNCTION__, depth);
> > > 	}
> > > 
> > > What's an acceptable compromise?
> > 
> > Yeah that logic isn't very nice. I think it's a good idea to keep the
> > tag depth at half the software depth, ie depth <= q->nr_requests. But
> > I'll remove the auto-adjust.
> 
> 
> Jens, are you saying that the host driver should enforce this limit?
> Which auto-adjust are you removing?

Sorry, I was not clear. The auto-adjust in the block layer should go
away. With a warning printed, the admin can increase the software queue
depth from user space by writing to the nr_requests sysfs file.

-- 
Jens Axboe

