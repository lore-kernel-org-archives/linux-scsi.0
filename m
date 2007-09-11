From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH][RFC] Use bio markers for request callback
Date: Tue, 11 Sep 2007 13:11:34 +0200
Message-ID: <20070911111133.GJ15405@kernel.dk>
References: <20070911124446.qs5cek5mskowckcc@imap.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:2907 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbXIKLDC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Sep 2007 07:03:02 -0400
Content-Disposition: inline
In-Reply-To: <20070911124446.qs5cek5mskowckcc@imap.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, k-ueda@ct.jp.nec.com

On Tue, Sep 11 2007, Hannes Reinecke wrote:
> Hi all,
>
> this is a proposal for a different implementation of request callbacks. The 
> existing ->endio callback of a request is actually a destructor function, 
> to be called to terminate a request and free all structures.
>
> However, on certain occasions (like request-based multipathing) it is 
> desirable to have a callback function for a request which is called right 
> after the request is finished, ie in end_that_request_first() before any 
> bio->bi_endio callback is called.
>
> So a simple solution for this is to clone the request and add a new 
> 'marker' bio in front of the bio list of the request. This callback will be 
> attached a structure in bi_private which keeps a pointer to the cloned and 
> the original request, thus serving as a callback for the request itself.
>
> Proposed patch attached. As usual comments are welcome.

Honestly, I think this approach is a much worse design than the NEC
callback option. Exporting __make_request() (which is an INTERNAL
function) aside, this looks like one big hack with pseudo bio attached
to front of list, the enable/disable elevator stuff (does that even work
on stacked devices?).

-- 
Jens Axboe

