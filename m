From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [RFC] Make the SCSI mempool allocations variable
Date: Wed, 10 Mar 2004 02:07:40 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040310100740.GA619810@sgi.com>
References: <1078858977.1756.40.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.sgi.com ([192.48.171.6]:23407 "EHLO zok.sgi.com")
	by vger.kernel.org with ESMTP id S262565AbUCJKIg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Mar 2004 05:08:36 -0500
Content-Disposition: inline
In-Reply-To: <1078858977.1756.40.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: mpm@waste.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Mar 09, 2004 at 02:02:55PM -0500, James Bottomley wrote:
> Based on Jeremy's request to increase max_phys_segments, this is the way
> to do it (SCSI_MAX_PHYS_SEGMENTS) is the value that gets set as the
> queue's max_phys_segments.
> 
> I have to say that when I tried raising it to 256 and hammering a 10GB
> ext2 filesystem, I still didn't generate any >128 segment requests, so
> I'm dubious that raising it has any benefit at all, but feel free to try
> it and publish the figures.
> 
> I did wonder if lowering it might help improve the memory footprint for
> some embedded systems, so I set it up to be lowered as far as 32.
> 
> James


I got a chance to try this tonight and can report excellent results.
I modified the qla2xxx driver to have an sg_tablesize of 256 (default
is SG_ALL, which is 0xFF).  I also modified SCSI_MAX_PHYS_SEGMENTS to
256.

I first tried direct I/O to the block device and found that the max
I/O size increased to 4MB from 2MB.  I then built an XFS filesystem and
tried direct I/O to it, and found the same results.

Believe it or not, there are some h/w RAIDs in which you can get a
significant performance benefit by increasing I/O size to 4MB from
2MB.  I don't have one immediately available to post MB/s numbers,
but you can trust me ('cause I can trust those who told me) :-)

So I heartily approve of this change.

Are you thinking of making SCSI_MAX_PHYS_SEGMENTS a config variable?
Or would you increase it to 256 by default?

Thanks for doing this,

jeremy
