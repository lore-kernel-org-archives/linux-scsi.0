From: Tejun Heo <htejun@gmail.com>
Subject: Re: calling scsi_adjust_queue_depth() during I/O...
Date: Sat, 6 Aug 2005 02:15:18 +0900
Message-ID: <20050805171518.GB5046@htj.dyndns.org>
References: <20050804234155.GJ13374@plap.qlogic.org> <20050805075751.GN9369@suse.de> <20050805110911.GA22867@htj.dyndns.org> <42F350E6.2090109@gmail.com> <20050805123301.GA3311@htj.dyndns.org> <20050805155548.GP13374@plap.qlogic.org> <20050805155905.GU5561@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.194]:49266 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S263085AbVHERP1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Aug 2005 13:15:27 -0400
Received: by rproxy.gmail.com with SMTP id i8so563293rne
        for <linux-scsi@vger.kernel.org>; Fri, 05 Aug 2005 10:15:23 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20050805155905.GU5561@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Aug 05, 2005 at 05:59:06PM +0200, Jens Axboe wrote:
> On Fri, Aug 05 2005, Andrew Vasquez wrote:
> > On Fri, 05 Aug 2005, Tejun Heo wrote:
> > 
> > > >  Oops, forget about the previous mail.  Above patch make it into the 
> > > > tree and it's the source of the problem.  My git HEAD was pointing at 
> > > > the latest update but I haven't updated my cache, so I was looking at 
> > > > the old source tree.  My apologies for the hassle and the bug.
> > > > 
> > > >  Original code was broken in the following two points.
> > > > 
> > > >  * tag_index wasn't allocated fully
> > > >  * tag_map's extra bits were always initialized w/ 1's.
> > > > 
> > > >  The first bug is critical and the second bug prevents proper enlarging 
> > > > of tag map.  However, the second bug effectively masks the first bug 
> > > > avoiding critical problem.  My above mentioned patch broke things 
> > > > seriously when reducing tag size on flight.
> > > > 
> > > >  Again, my apologies and patch will soon follow.
> > > 
> > >  Here's the fix.  It basically revives bqt->real_max_depth sans
> > > allocation optimization in init_tag_map.  I've also added a comment
> > > explicitly noting that tag map cannot be shrunk to prevent other
> > > morons like me.  :-( Please try this one and let me know how it works.
> > > If this is the correct fix, I'll repost properly to Jens and lkml with
> > > detailed explanation on how it was broken in the original code and how
> > > I broke it with my previous patch.  Sorry.
> > 
> > OK, 20 minutes into lowering and raising the queue-depth and
> > everything appears to be working fine.  I'll continue banging away
> > with my configuration and let you know if anything else comes up.
> > Looks good so far.
> 
> Thanks for fixing it so quickly, Tejun! I'll be on vacation next week,
> can you make sure it gets to Andrew?
> 

 Meaning... Andrew Morton, right?  I'll make that sure.  Have fun on
your vacation.  :-)

-- 
tejun
