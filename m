From: "Philip R. Auld" <pauld@egenera.com>
Subject: Re: Is there a grand plan for FC failover?
Date: Thu, 29 Jan 2004 10:24:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040129102430.G11527@vienna.EGENERA.COM>
References: <401521A7.5030808@thekelleys.org.uk> <1075131446.2290.29.camel@mulgrave> <20040128100236.D11527@vienna.EGENERA.COM> <1075309052.2254.6.camel@mulgrave> <20040128130040.E11527@vienna.EGENERA.COM> <401839A8.307@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from roadrunner-base.egenera.com ([63.160.166.46]:16541 "EHLO
	coyote.egenera.com") by vger.kernel.org with ESMTP id S266209AbUA2P0x
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jan 2004 10:26:53 -0500
Content-Disposition: inline
In-Reply-To: <401839A8.307@us.ibm.com>; from mikenc@us.ibm.com on Wed, Jan 28, 2004 at 02:37:28PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mikenc@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Simon Kelley <simon@thekelleys.org.uk>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Rumor has it that on Wed, Jan 28, 2004 at 02:37:28PM -0800 Mike Christie said:
> Philip R. Auld wrote:
> > Hi James,
> > 	Thanks for the reply. 
> > 
> > Rumor has it that on Wed, Jan 28, 2004 at 10:57:29AM -0600 James Bottomley said:
> > 
> >>On Wed, 2004-01-28 at 09:02, Philip R. Auld wrote:
> >>
> >>>	1) load balancing when possible: it's not enough to be just a 
> >>>		failover mechanism.
> >>
> >>For first out, a failover target supplies most of the needs.  Nothing
> >>prevents an aggregation target being added later, but failover is
> >>essential.
> > 
> > 
> > Yes, failover is necessary, but not sufficient to make a decent multipath driver.
> > I'm a little concerned by the "added later" part. Shouldn't it be designed in? 
> 
> The DM multipath can do both. Unfortunately, some work still needs to be 
> done. For example, when doing load balancing how much IO to send down 
> each path is an issue that the DM maintainer had asked for feedback on. 
> Suggestions?
> 

That leads back to where to put the request merging and elevator code...

The way I currently do load-balancing is on a scsi_cmnd basis. At that point 
the IO is coalesced already.  A shortest queue_depth falling back to 
round-robin algorithm balances really well on individual commands. From a 
logical block level, I'm not sure how. I'm a little unfamiliar (as my posts 
have shown) with how/where the DM code fits in.  (I've also not gotten a good 
look into 2.6 BIO... busy on 2.4 still.)

I think the place to do load balancing would be below the block queue so that
the IOs are coalesced. IMO, until you've merged the individual block requests 
you can't make a good decision about how to balance the load. 
 

-- 
Philip R. Auld, Ph.D.  	        	       Egenera, Inc.    
Principal Software Engineer                   165 Forest St.
(508) 858-2628                            Marlboro, MA 01752
