From: "Philip R. Auld" <pauld@egenera.com>
Subject: Re: Is there a grand plan for FC failover?
Date: Wed, 28 Jan 2004 13:00:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040128130040.E11527@vienna.EGENERA.COM>
References: <401521A7.5030808@thekelleys.org.uk> <1075131446.2290.29.camel@mulgrave> <20040128100236.D11527@vienna.EGENERA.COM> <1075309052.2254.6.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from roadrunner-base.egenera.com ([63.160.166.46]:54482 "EHLO
	coyote.egenera.com") by vger.kernel.org with ESMTP id S265981AbUA1SDJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jan 2004 13:03:09 -0500
Content-Disposition: inline
In-Reply-To: <1075309052.2254.6.camel@mulgrave>; from James.Bottomley@steeleye.com on Wed, Jan 28, 2004 at 10:57:29AM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Simon Kelley <simon@thekelleys.org.uk>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi James,
	Thanks for the reply. 

Rumor has it that on Wed, Jan 28, 2004 at 10:57:29AM -0600 James Bottomley said:
> On Wed, 2004-01-28 at 09:02, Philip R. Auld wrote:
> > 	1) load balancing when possible: it's not enough to be just a 
> > 		failover mechanism.
> 
> For first out, a failover target supplies most of the needs.  Nothing
> prevents an aggregation target being added later, but failover is
> essential.

Yes, failover is necessary, but not sufficient to make a decent multipath driver.
I'm a little concerned by the "added later" part. Shouldn't it be designed in? 

> 
> >         2) requiring a userspace program to execute for failover is 
> > 	problematic when it could be the root disk that needs 
> > 	failing over.
> 
> Userspace is required for *configuration* not failover.  The path
> targets failover automatically as they see I/O down particular paths
> timing out or failing.  That being said, nothing prevents async
> notifications via hotplug also triggering a failover (rather than having
> to wait for timeout etc) but it's not required.
> 

There was some discussion about vendor plugins to do proprietary failover
when needed. Say to make a passive path active. My concern is that this be
memory resident and that we not have to go to the disk for such things.

If there is no need for that or it's done in such a way that it doesn't need
the disk this won't be a problem then.

> >  	3) Handling partitions is a problem.
> 
> It is? How? The block approach can sit either above or below partitions
> (assuming a slightly more flexible handling of partitions that dm
> provides).
> 

Great, that works for me.  

> > I see multipath and md/RAID as two different animals. Multipathing is 
> > multiple ways to reach the same physical block. That is it's under 
> > the logical layer. While RAID is multiple ways to reach the same 
> > logical block. It's basically many-to-one vs one-to-many. Having 
> > multiple physical paths to a logical partition is a little 
> > counter-intuitive.
> 
> Nothing in the discussion assumed them to be similar.  The notes were
> that md already had a multi-path target, and that translated error
> indications would be useful to software raid.  Thus designing the
> fastfail to cater to both looks like a good idea, but that's just good
> design.  Robust multi-pathing and raid will be built on top of
> scsi/block fastfail.

Aside from the implicit one made by having a multi-path target in the md 
driver, I guess that's true.

As I said, I think this all sounds great. I just hadn't see these (non?)issues 
addressed on the list after they were raised and want to make sure there was 
some thought given to them.


Cheers,

Phil

> 
> James
> 

-- 
Philip R. Auld, Ph.D.  	        	       Egenera, Inc.    
Principal Software Engineer                   165 Forest St.
(508) 858-2628                            Marlboro, MA 01752
