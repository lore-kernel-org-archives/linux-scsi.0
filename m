From: "Philip R. Auld" <pauld@egenera.com>
Subject: Re: [dm-devel] Re: Is there a grand plan for FC failover?
Date: Thu, 12 Feb 2004 10:17:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040212101705.F27680@vienna.EGENERA.COM>
References: <20040128100236.D11527@vienna.EGENERA.COM> <1075309052.2254.6.camel@mulgrave> <20040128130040.E11527@vienna.EGENERA.COM> <20040128124756.A7232@beaverton.ibm.com> <1075328066.2534.10.camel@mulgrave> <20040128165534.A9202@beaverton.ibm.com> <20040130194826.GC31596@reti> <20040131093037.GR11683@suse.de> <20040131115903.A4881@vienna.EGENERA.COM> <20040131174201.GC11683@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from roadrunner-base.egenera.com ([63.160.166.46]:7884 "EHLO
	coyote.egenera.com") by vger.kernel.org with ESMTP id S266465AbUBLPTz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Feb 2004 10:19:55 -0500
Content-Disposition: inline
In-Reply-To: <20040131174201.GC11683@suse.de>; from axboe@suse.de on Sat, Jan 31, 2004 at 06:42:01PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Joe Thornber <thornber@redhat.com>, dm-devel@sistina.com, James Bottomley <James.Bottomley@steeleye.com>, Simon Kelley <simon@thekelleys.org.uk>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Rumor has it that on Sat, Jan 31, 2004 at 06:42:01PM +0100 Jens Axboe said:
> On Sat, Jan 31 2004, Philip R. Auld wrote:
> > Rumor has it that on Sat, Jan 31, 2004 at 10:30:37AM +0100 Jens Axboe said:
> > > On Fri, Jan 30 2004, Joe Thornber wrote:
> > > > It would be great to get some benchmarks to back up these arguments.
> > > > eg, performance of dm mpath with a simple round robin selector,
> > > > compared to a scsi layer implementation.  Lifting the elevator (or
> > > > lowering dm) is a big piece of work that I wont even consider unless
> > > > there is very good reason; the reason probably needs to be broader
> > > > than just multipath too.  Even if we did decide to do this, it won't
> > > > happen in 2.6.
> > > 
> > > I suspect the problem really isn't that huge in 2.6, since most
> > > performance file systems are using mpage or building their own big
> > > bio's. So in a sense, some of the merging already does happen above dm
> > > (and the io scheduler).
> > 
> > Out of curiosity, where does raw io fit into that in 2.6?
> 
> raw io (or O_DIRECT io, same path) should work even better, always send
> out bio's as big as the underlying device can support.
> 

That size is based on the blocksize? Is there a way to set the block size higher than
512 w/o mounting it? I've gotten really bad rawio performance on 2.4. since I have a 
limit of 32 sg entries. When Rawio uses a 512 byte blocksize IOs are limited to 16K. 

Will this still be a problem in 2.6?

Thanks again,

Phil

> -- 
> Jens Axboe
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Philip R. Auld, Ph.D.  	        	       Egenera, Inc.    
Principal Software Engineer                   165 Forest St.
(508) 858-2628                            Marlboro, MA 01752
