From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/7] sg_ring: a ring of scatterlist arrays
Date: Sat, 05 Jan 2008 09:31:12 -0600
Message-ID: <1199547072.3399.15.camel@localhost.localdomain>
References: <200712191731.26512.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55084 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753738AbYAEPbT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Jan 2008 10:31:19 -0500
In-Reply-To: <200712191731.26512.rusty@rustcorp.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org


On Wed, 2007-12-19 at 17:31 +1100, Rusty Russell wrote:
> This patch series is the start of my attempt to simplify and make explicit
> the chained scatterlist logic.
> 
> It's not complete: my SATA box boots and seems happy, but all the other
> users of SCSI need to be updated and checked.  But I've gotten far enough
> to believe it's worth persuing.

Sorry for the delay in looking at this, I was busy with Holidays and
things.

When I compare sg_ring with the current sg_chain (and later sg_table)
implementations, I'm actually struck by how similar they are.

The other thing I note is that the problem you're claiming to solve with
sg_ring (the ability to add extra scatterlists to the front or the back
of an existing one) is already solved with sg_chain, so the only real
advantage of sg_ring was that it contains explicit counts, which
sg_table (in -mm) also introduces.

The other differences are that sg_ring only allows adding at the front
or back of an existing sg_ring, it doesn't allow splicing at any point
like sg_chain does, so I'd say it's less functional (not that I actually
want anyone ever to do this, of course ...)

The final point is that sg_ring requires a two level traversal:  ring
list then scatterlist, whereas sg_chain only requires a single level
traversal.  I grant that we can abstract out the traversal into
something that would make users think they're only doing a single level,
but I don't see what the extra level really buys us.

The above analysis seems to suggest that sg_chain is simpler and has
more functionality than sg_ring, unless I've missed anything?

The only thing missing from sg_chain perhaps is an accessor function
that does the splicing, which I can easily construct if you want to try
it out in virtio.

James


