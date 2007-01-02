From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: struct request members, etc..
Date: Tue, 2 Jan 2007 13:44:27 +0100
Message-ID: <20070102124427.GY2483@kernel.dk>
References: <200612112159.kBBLxmep005850@fire-2.osdl.org> <20061211141029.9a0b0376.akpm@osdl.org> <20061212103842.GA9619@lst.de> <20061212132600.GA19912@lst.de> <457EBAE3.6090609@panasas.com> <20070102120531.GB7032@lst.de> <20070102123418.GW2483@kernel.dk> <20070102123916.GA8689@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:17310 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964899AbXABMob (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Jan 2007 07:44:31 -0500
Content-Disposition: inline
In-Reply-To: <20070102123916.GA8689@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org

On Tue, Jan 02 2007, Christoph Hellwig wrote:
> On Tue, Jan 02, 2007 at 01:34:18PM +0100, Jens Axboe wrote:
> > On Tue, Jan 02 2007, Christoph Hellwig wrote:
> > > This gets a little offtopic for the original issue, so let's cut the Cc
> > > list and change the subject.
> > > 
> > > On Tue, Dec 12, 2006 at 04:21:23PM +0200, Boaz Harrosh wrote:
> > > > I'm afraid this might not be enough because of code in drivers/ide/ide-cd.c. It does IO off of request->data.
> > > 
> > > Only for FS requests, but we do BLOCK_PC requests here.
> > 
> > ->buffer is the old style FS requests, ->data is never used for FS
> > requests. BLOCK_PC requests should use just ->data, but I would not be
> > surprised if ide-cd and others still map it to ->buffer.
> 
> Actually after my last patch BLOCK_PC request should use neither.
> Nowdays if a BLOCK_PC requests wants to transfer data it must
> use req->bio.

Cool, just worrying that it might complicate some drivers. ide-cd itself
should actually be cleaned up, as we can drop one of the old pc
interrupt handlers as well.

-- 
Jens Axboe

