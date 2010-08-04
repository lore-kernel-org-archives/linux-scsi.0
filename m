From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, RFC 2/2] dm: support REQ_FLUSH directly
Date: Wed, 4 Aug 2010 10:54:23 +0200
Message-ID: <20100804085423.GA15687@lst.de>
References: <20100727165627.GA474@lst.de> <20100727175418.GF6820@quack.suse.cz> <20100803184939.GA12198@lst.de> <20100803185148.GA12258@lst.de> <4C58F341.9060605@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:39577 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895Ab0HDIzB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Aug 2010 04:55:01 -0400
Content-Disposition: inline
In-Reply-To: <4C58F341.9060605@ct.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, tj@kernel.org, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, linux-raid@vger.kernel.org

On Wed, Aug 04, 2010 at 01:57:37PM +0900, Kiyoshi Ueda wrote:
> > -		if (unlikely(dm_rq_is_flush_request(rq))) {
> > +		if (rq->cmd_flags & REQ_FLUSH) {
> >  			BUG_ON(md->flush_request);
> >  			md->flush_request = rq;
> >  			blk_start_request(rq);
> 
> Current request-based device-mapper's flush code depends on
> the block-layer's barrier behavior which dispatches only one request
> at a time when flush is needed.
> In other words, current request-based device-mapper can't handle
> other requests while a flush request is in progress.
> 
> I'll take a look how I can fix the request-based device-mapper to
> cope with it.  I think it'll take time for carefull investigation.

Given that request based device mapper doesn't even look at the
block numbers from what I can see just removing any special casing
for REQ_FLUSH should probably do it.

