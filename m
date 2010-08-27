From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH, RFC 2/2] dm: support REQ_FLUSH directly
Date: Fri, 27 Aug 2010 00:08:08 -0400
Message-ID: <20100827040808.GA19488@redhat.com>
References: <20100727165627.GA474@lst.de>
 <20100727175418.GF6820@quack.suse.cz>
 <20100803184939.GA12198@lst.de>
 <20100803185148.GA12258@lst.de>
 <4C58F341.9060605@ct.jp.nec.com>
 <20100804085423.GA15687@lst.de>
 <4C5A1F05.40308@ce.jp.nec.com>
 <20100826225024.GB17832@redhat.com>
 <4C771852.3050500@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab0H0EIk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Aug 2010 00:08:40 -0400
Content-Disposition: inline
In-Reply-To: <4C771852.3050500@ce.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Christoph Hellwig <hch@lst.de>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, jaxboe@fusionio.com, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, James.Bottomley@suse.de, konishi.ryusuke@lab.ntt.co.jp, tj@kernel.org, tytso@mit.edu, swhiteho@redhat.com, chris.mason@oracle.com, dm-devel@redhat.com

On Thu, Aug 26 2010 at  9:43pm -0400,
Jun'ichi Nomura <j-nomura@ce.jp.nec.com> wrote:

> Hi Mike,
> 
> (08/27/10 07:50), Mike Snitzer wrote:
> >> Special casing is necessary because device-mapper may have to
> >> send multiple copies of REQ_FLUSH request to multiple
> >> targets, while normal request is just sent to single target.
> > 
> > Yes, request-based DM is meant to have all the same capabilities as
> > bio-based DM.  So in theory it should support multiple targets but in
> > practice it doesn't.  DM's multipath target is the only consumer of
> > request-based DM and it only ever clones a single flush request
> > (num_flush_requests = 1).
> 
> This is correct. But,
> 
> > So why not remove all of request-based DM's barrier infrastructure and
> > simply rely on the revised block layer to sequence the FLUSH+WRITE
> > request for request-based DM?
> > 
> > Given that we do not have a request-based DM target that requires
> > cloning multiple FLUSH requests its unused code that is delaying DM
> > support for the new FLUSH+FUA work (NOTE: bio-based DM obviously still
> > needs work in this area).
> 
> the above mentioned 'special casing' is not a hard part.
> See the attached patch.

Yes, Tejun suggested something like this in one of the threads.  Thanks
for implementing it.

But do you agree that the request-based barrier code (added in commit
d0bcb8786) could be reverted given the new FLUSH work?

We no longer need waiting now that ordering isn't a concern.  Especially
so given rq-based doesn't support multiple targets.  As you know, from
dm_table_set_type:

        /*
         * Request-based dm supports only tables that have a single target now.
         * To support multiple targets, request splitting support is needed,
         * and that needs lots of changes in the block-layer.
         * (e.g. request completion process for partial completion.)
         */

I think we need to at least benchmark the performance of dm-mpath
without any of this extra, soon to be unnecessary, code.

Maybe my concern is overblown...

> The hard part is discerning the error type for flush failure
> as discussed in the other thread.
> And as Kiyoshi wrote, that's an existing problem so it can
> be worked on as a separate issue than the new FLUSH work.

Right, Mike Christie will be refreshing his patchset that should enable
us to resolve that separate issue.

Thanks,
Mike

