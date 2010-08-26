From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH, RFC 2/2] dm: support REQ_FLUSH directly
Date: Thu, 26 Aug 2010 18:50:24 -0400
Message-ID: <20100826225024.GB17832@redhat.com>
References: <20100727165627.GA474@lst.de>
 <20100727175418.GF6820@quack.suse.cz>
 <20100803184939.GA12198@lst.de>
 <20100803185148.GA12258@lst.de>
 <4C58F341.9060605@ct.jp.nec.com>
 <20100804085423.GA15687@lst.de>
 <4C5A1F05.40308@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155Ab0HZWut (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Aug 2010 18:50:49 -0400
Content-Disposition: inline
In-Reply-To: <4C5A1F05.40308@ce.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Christoph Hellwig <hch@lst.de>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, jaxboe@fusionio.com, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, James.Bottomley@suse.de, konishi.ryusuke@lab.ntt.co.jp, tj@kernel.org, tytso@mit.edu, swhiteho@redhat.com, chris.mason@oracle.com, dm-devel@redhat.com

On Wed, Aug 04 2010 at 10:16pm -0400,
Jun'ichi Nomura <j-nomura@ce.jp.nec.com> wrote:

> Hi Christoph,
> 
> (08/04/10 17:54), Christoph Hellwig wrote:
> > On Wed, Aug 04, 2010 at 01:57:37PM +0900, Kiyoshi Ueda wrote:
> >>> -		if (unlikely(dm_rq_is_flush_request(rq))) {
> >>> +		if (rq->cmd_flags & REQ_FLUSH) {
> >>>  			BUG_ON(md->flush_request);
> >>>  			md->flush_request = rq;
> >>>  			blk_start_request(rq);
> >>
> >> Current request-based device-mapper's flush code depends on
> >> the block-layer's barrier behavior which dispatches only one request
> >> at a time when flush is needed.
> >> In other words, current request-based device-mapper can't handle
> >> other requests while a flush request is in progress.
> >>
> >> I'll take a look how I can fix the request-based device-mapper to
> >> cope with it.  I think it'll take time for carefull investigation.
> > 
> > Given that request based device mapper doesn't even look at the
> > block numbers from what I can see just removing any special casing
> > for REQ_FLUSH should probably do it.
> 
> Special casing is necessary because device-mapper may have to
> send multiple copies of REQ_FLUSH request to multiple
> targets, while normal request is just sent to single target.

Yes, request-based DM is meant to have all the same capabilities as
bio-based DM.  So in theory it should support multiple targets but in
practice it doesn't.  DM's multipath target is the only consumer of
request-based DM and it only ever clones a single flush request
(num_flush_requests = 1).

So why not remove all of request-based DM's barrier infrastructure and
simply rely on the revised block layer to sequence the FLUSH+WRITE
request for request-based DM?

Given that we do not have a request-based DM target that requires
cloning multiple FLUSH requests its unused code that is delaying DM
support for the new FLUSH+FUA work (NOTE: bio-based DM obviously still
needs work in this area).

Once we have a need for using request-based DM for something other than
multipath we can take a fresh look at implementing rq-based FLUSH+FUA.

Mike

p.s. I know how hard NEC worked on request-based DM's barrier support;
so I'm not suggesting this lightly.  For me it just seems like we're
carrying complexity in DM that hasn't ever been required.
