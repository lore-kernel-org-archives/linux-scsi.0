From: Michael Christie <michaelc@cs.wisc.edu>
Subject: Re: [dm-devel] Re: [PATCH RFC 0/4] use scatter lists for all block pc requests and simplify hw handlers
Date: Tue,  7 Jun 2005 10:45:34 -0500
Message-ID: <1118159134.42a5c11eb8965@webmail.cs.wisc.edu>
References: <1117847972.23638.62.camel@mina> <1117901234.5005.9.camel@mulgrave> <20050607121020.GA6458@infradead.org> <1118146802.4998.3.camel@mulgrave> <1118158614.42a5bf160d317@webmail.cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from marzipan.cs.wisc.edu ([128.105.7.11]:15786 "EHLO
	marzipan.cs.wisc.edu") by vger.kernel.org with ESMTP
	id S261893AbVFGPpo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Jun 2005 11:45:44 -0400
In-Reply-To: <1118158614.42a5bf160d317@webmail.cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Jens Axboe <axboe@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>

Quoting Michael Christie <michaelc@cs.wisc.edu>:

> Quoting James Bottomley <James.Bottomley@SteelEye.com>:
> 
> > On Tue, 2005-06-07 at 13:10 +0100, Christoph Hellwig wrote:
> > > shouldn't blk_rq_map_kern handle a 0 buffer and do nothing more than
> > > blk_get_request?  It's not exactly a criticial fastpath and that would
> make
> > life
> > > easier for the callers.
> > 
> > Yes ... and it should probably do bio bouncing as well, since there's
> > nothing special we have to do on completion to clean it up.
> 
> ok. I just made it like the existing blk_rq_map_user which made the caller
> do
> those things.
> 
> > 
> > I also think we might need a blk_rq_kern_iovec call that would take a
> > vector of user I/O's and map it to a multiple bio request.  This would
> 
> Does it need to be a multiple bio request? A single bio should be able to
> handle
>  a request's segments and sectors limits.
>  
> Will the user assure that the iovec will fit in a single request to handle a
> case where the iovec is greater than the phys or hw segment limits though?
> 

scsi_do/wait_req could do the checking and submit mutliple requests for sg I
mean.
