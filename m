From: "Philip R. Auld" <pauld@egenera.com>
Subject: Re: Is there a grand plan for FC failover?
Date: Wed, 28 Jan 2004 10:02:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040128100236.D11527@vienna.EGENERA.COM>
References: <401521A7.5030808@thekelleys.org.uk> <1075131446.2290.29.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from roadrunner-base.egenera.com ([63.160.166.46]:4292 "EHLO
	coyote.egenera.com") by vger.kernel.org with ESMTP id S265985AbUA1PFA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jan 2004 10:05:00 -0500
Content-Disposition: inline
In-Reply-To: <1075131446.2290.29.camel@mulgrave>; from James.Bottomley@steeleye.com on Mon, Jan 26, 2004 at 09:37:25AM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Simon Kelley <simon@thekelleys.org.uk>, SCSI Mailing List <linux-scsi@vger.kernel.org>


Hi,
	
Rumor has it that on Mon, Jan 26, 2004 at 09:37:25AM -0600 James Bottomley said:
> On Mon, 2004-01-26 at 08:18, Simon Kelley wrote:
>
> > I'm very much in favour of using drivers which are developed in the 
> > kernel mainline but I have an application which needs failover so I 
> > might be forced back to the qlogic-distributed code.
> 
> Yes, the direction coming out of KS/OLS last year was to use the dm or
> md multi-path code to sit the failover driver on top of sd (or any other
> block driver).
> 
> The idea being that the Volume Manager layer is the most stack generic
> place to do this type of thing.  The thread on this is here:
> 
> http://marc.theaimsgroup.com/?t=106005575400003
> 

There are some issues left un-resolved with this approach. 
The one's that come mind are:

	1) load balancing when possible: it's not enough to be just a 
		failover mechanism.

        2) requiring a userspace program to execute for failover is 
	problematic when it could be the root disk that needs 
	failing over.

 	3) Handling partitions is a problem.

I see multipath and md/RAID as two different animals. Multipathing is 
multiple ways to reach the same physical block. That is it's under 
the logical layer. While RAID is multiple ways to reach the same 
logical block. It's basically many-to-one vs one-to-many. Having 
multiple physical paths to a logical partition is a little 
counter-intuitive.

That said, I'm all for getting Linux to have a decent multipath 
implementation, at what ever layer is agreed upon. I'd love to 
be able to use the native Linux multipathing and stop supporting 
the ones I've written.

 
FWIW,

Phil



> James
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Philip R. Auld, Ph.D.  	        	       Egenera, Inc.    
Principal Software Engineer                   165 Forest St.
(508) 858-2628                            Marlboro, MA 01752
