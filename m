From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Is there a grand plan for FC failover?
Date: 28 Jan 2004 10:57:29 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1075309052.2254.6.camel@mulgrave>
References: <401521A7.5030808@thekelleys.org.uk>
	<1075131446.2290.29.camel@mulgrave>
	<20040128100236.D11527@vienna.EGENERA.COM>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:63630 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266090AbUA1Q5j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jan 2004 11:57:39 -0500
In-Reply-To: <20040128100236.D11527@vienna.EGENERA.COM>
List-Id: linux-scsi@vger.kernel.org
To: "Philip R. Auld" <pauld@egenera.com>
Cc: Simon Kelley <simon@thekelleys.org.uk>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-01-28 at 09:02, Philip R. Auld wrote:
> 	1) load balancing when possible: it's not enough to be just a 
> 		failover mechanism.

For first out, a failover target supplies most of the needs.  Nothing
prevents an aggregation target being added later, but failover is
essential.

>         2) requiring a userspace program to execute for failover is 
> 	problematic when it could be the root disk that needs 
> 	failing over.

Userspace is required for *configuration* not failover.  The path
targets failover automatically as they see I/O down particular paths
timing out or failing.  That being said, nothing prevents async
notifications via hotplug also triggering a failover (rather than having
to wait for timeout etc) but it's not required.

>  	3) Handling partitions is a problem.

It is? How? The block approach can sit either above or below partitions
(assuming a slightly more flexible handling of partitions that dm
provides).

> I see multipath and md/RAID as two different animals. Multipathing is 
> multiple ways to reach the same physical block. That is it's under 
> the logical layer. While RAID is multiple ways to reach the same 
> logical block. It's basically many-to-one vs one-to-many. Having 
> multiple physical paths to a logical partition is a little 
> counter-intuitive.

Nothing in the discussion assumed them to be similar.  The notes were
that md already had a multi-path target, and that translated error
indications would be useful to software raid.  Thus designing the
fastfail to cater to both looks like a good idea, but that's just good
design.  Robust multi-pathing and raid will be built on top of
scsi/block fastfail.

James


