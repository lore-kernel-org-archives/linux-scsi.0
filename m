From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [dm-devel] Re: [PATCH RFC 0/4] use scatter lists for all block
 pc requests and simplify hw handlers
Date: Tue, 7 Jun 2005 19:26:15 +0300 (EEST)
Message-ID: <Pine.LNX.4.61.0506071914360.3034@kai.makisara.local>
References: <1117847972.23638.62.camel@mina> <1117901234.5005.9.camel@mulgrave>
 <20050607121020.GA6458@infradead.org> <1118146802.4998.3.camel@mulgrave>
 <1118158614.42a5bf160d317@webmail.cs.wisc.edu> <1118159134.42a5c11eb8965@webmail.cs.wisc.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep30-0.kolumbus.fi ([193.229.0.32]:15477 "EHLO
	fep30-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S261926AbVFGQXO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Jun 2005 12:23:14 -0400
In-Reply-To: <1118159134.42a5c11eb8965@webmail.cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Christie <michaelc@cs.wisc.edu>
Cc: device-mapper development <dm-devel@redhat.com>, James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 7 Jun 2005, Michael Christie wrote:

> Quoting Michael Christie <michaelc@cs.wisc.edu>:
> 
> > Quoting James Bottomley <James.Bottomley@SteelEye.com>:
> > 
> > > On Tue, 2005-06-07 at 13:10 +0100, Christoph Hellwig wrote:
> > > > shouldn't blk_rq_map_kern handle a 0 buffer and do nothing more than
> > > > blk_get_request?  It's not exactly a criticial fastpath and that would
> > make
> > > life
> > > > easier for the callers.
> > > 
> > > Yes ... and it should probably do bio bouncing as well, since there's
> > > nothing special we have to do on completion to clean it up.
> > 
> > ok. I just made it like the existing blk_rq_map_user which made the caller
> > do
> > those things.
> > 
> > > 
> > > I also think we might need a blk_rq_kern_iovec call that would take a
> > > vector of user I/O's and map it to a multiple bio request.  This would
> > 
> > Does it need to be a multiple bio request? A single bio should be able to
> > handle
> >  a request's segments and sectors limits.
> >  
> > Will the user assure that the iovec will fit in a single request to handle a
> > case where the iovec is greater than the phys or hw segment limits though?
> > 
> 
> scsi_do/wait_req could do the checking and submit mutliple requests for sg I
> mean.

No, it can't do that. If the user submits one SCSI command, it must result 
in one SCSI command to the device. Otherwise the effect is not what the 
user wants. (You can split a multiple block read/write but this does not 
apply to all commands.)

Michael's question is important. The number of sg segments a HBA supports 
determines the maximum SCSI data size. In some cases (e.g., tape 
reads and writes with multimegabyte blocks) using page size (e.g., 4 kB) 
segments does not allow large enough data size. One solution has been to 
have a kernel space buffer that consists of segments spanning several 
pages. As far as I know, the current bio code requires page size segments. 
It is possible to use chained bios with multimegabyte buffers but the 
user should be sure that the split segments will be merged before the 
request reaches the HBA so that the request fits the HBA sg segment limit.

-- 
Kai
