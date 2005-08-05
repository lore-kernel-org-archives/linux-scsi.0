From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: calling scsi_adjust_queue_depth() during I/O...
Date: Fri, 5 Aug 2005 08:55:48 -0700
Message-ID: <20050805155548.GP13374@plap.qlogic.org>
References: <20050804234155.GJ13374@plap.qlogic.org> <20050805075751.GN9369@suse.de> <20050805110911.GA22867@htj.dyndns.org> <42F350E6.2090109@gmail.com> <20050805123301.GA3311@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:48828 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S262970AbVHEPzv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Aug 2005 11:55:51 -0400
Content-Disposition: inline
In-Reply-To: <20050805123301.GA3311@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <axboe@suse.de>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 05 Aug 2005, Tejun Heo wrote:

> >  Oops, forget about the previous mail.  Above patch make it into the 
> > tree and it's the source of the problem.  My git HEAD was pointing at 
> > the latest update but I haven't updated my cache, so I was looking at 
> > the old source tree.  My apologies for the hassle and the bug.
> > 
> >  Original code was broken in the following two points.
> > 
> >  * tag_index wasn't allocated fully
> >  * tag_map's extra bits were always initialized w/ 1's.
> > 
> >  The first bug is critical and the second bug prevents proper enlarging 
> > of tag map.  However, the second bug effectively masks the first bug 
> > avoiding critical problem.  My above mentioned patch broke things 
> > seriously when reducing tag size on flight.
> > 
> >  Again, my apologies and patch will soon follow.
> 
>  Here's the fix.  It basically revives bqt->real_max_depth sans
> allocation optimization in init_tag_map.  I've also added a comment
> explicitly noting that tag map cannot be shrunk to prevent other
> morons like me.  :-( Please try this one and let me know how it works.
> If this is the correct fix, I'll repost properly to Jens and lkml with
> detailed explanation on how it was broken in the original code and how
> I broke it with my previous patch.  Sorry.

OK, 20 minutes into lowering and raising the queue-depth and
everything appears to be working fine.  I'll continue banging away
with my configuration and let you know if anything else comes up.
Looks good so far.

Thanks,
Andrew
