From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [RFC] Make the SCSI mempool allocations variable
Date: 10 Mar 2004 10:29:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1078932577.10834.44.camel@mulgrave>
References: <1078858977.1756.40.camel@mulgrave>
	<20040310100740.GA619810@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:45252 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262657AbUCJP34 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Mar 2004 10:29:56 -0500
In-Reply-To: <20040310100740.GA619810@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: mpm@waste.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-03-10 at 05:07, Jeremy Higdon wrote:
> I first tried direct I/O to the block device and found that the max
> I/O size increased to 4MB from 2MB.  I then built an XFS filesystem and
> tried direct I/O to it, and found the same results.

Well, I'm glad someone saw a benefit.

> Believe it or not, there are some h/w RAIDs in which you can get a
> significant performance benefit by increasing I/O size to 4MB from
> 2MB.  I don't have one immediately available to post MB/s numbers,
> but you can trust me ('cause I can trust those who told me) :-)
> 
> So I heartily approve of this change.
> 
> Are you thinking of making SCSI_MAX_PHYS_SEGMENTS a config variable?
> Or would you increase it to 256 by default?

Depending on the arch size of struct scatterlist, the 256 enty sglist is
usually around 6k (on 64 bits).  That leads the slab to use order 3
allocations and with a default mempool size of 32, that's eight order 3
allocations that get eaten.

Since my tests showed this pool never to be used on ext3, I certainly
don't think it should be the default if all it does is waste memory for
the majority.

The best course of action is probably to put the patch in (since it has
its current default at 128, it will change nothing) so that people who
wish to play with increasing the allocation can.

To address the question of how you set this, I'd like more information
about which filesystems and workloads find this useful, perhaps with a
view to tying it to an indirect config option (CONFIG_ENTERPRISE or
something).

James


