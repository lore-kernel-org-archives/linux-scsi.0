From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: struct request members, etc..
Date: Tue, 2 Jan 2007 13:34:18 +0100
Message-ID: <20070102123418.GW2483@kernel.dk>
References: <200612112159.kBBLxmep005850@fire-2.osdl.org> <20061211141029.9a0b0376.akpm@osdl.org> <20061212103842.GA9619@lst.de> <20061212132600.GA19912@lst.de> <457EBAE3.6090609@panasas.com> <20070102120531.GB7032@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:28691 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964849AbXABMeW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Jan 2007 07:34:22 -0500
Content-Disposition: inline
In-Reply-To: <20070102120531.GB7032@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org

On Tue, Jan 02 2007, Christoph Hellwig wrote:
> This gets a little offtopic for the original issue, so let's cut the Cc
> list and change the subject.
> 
> On Tue, Dec 12, 2006 at 04:21:23PM +0200, Boaz Harrosh wrote:
> > I'm afraid this might not be enough because of code in drivers/ide/ide-cd.c. It does IO off of request->data.
> 
> Only for FS requests, but we do BLOCK_PC requests here.

->buffer is the old style FS requests, ->data is never used for FS
requests. BLOCK_PC requests should use just ->data, but I would not be
surprised if ide-cd and others still map it to ->buffer.

> > [background]
> > pkt_generic_packet and ton of other places mainly cd(s), floppy(s), and
> > other ide code paths, are using what I call BLACK requests. They put some
> > data on request->buffer or request->data stick it in the Q and than advance
> > on them later down the ladder. Remove of "buffer" and "data" from
> > struct request will reveal all these places. At one time I had plans to do
> > just that. But 1/2 way through I gave up, it is too risky, too much
> > Hardware that I don't have, that needs checking.
> 
> Removing this old code would definitly be worthwile, but I understand
> that you don't want to get too deeply into the mess of floppy.c and the
> old ide code :)

I'd suggest moving everything to ->data, and get rid of ->buffer. You
probably cannot remove both without complicating things, I'm not sure
it's worth it.

-- 
Jens Axboe

