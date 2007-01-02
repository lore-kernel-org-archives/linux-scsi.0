From: Christoph Hellwig <hch@lst.de>
Subject: struct request members, etc..
Date: Tue, 2 Jan 2007 13:05:31 +0100
Message-ID: <20070102120531.GB7032@lst.de>
References: <200612112159.kBBLxmep005850@fire-2.osdl.org> <20061211141029.9a0b0376.akpm@osdl.org> <20061212103842.GA9619@lst.de> <20061212132600.GA19912@lst.de> <457EBAE3.6090609@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:44898 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964779AbXABMFn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Jan 2007 07:05:43 -0500
Content-Disposition: inline
In-Reply-To: <457EBAE3.6090609@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi@vger.kernel.org, axboe@kernel.dk

This gets a little offtopic for the original issue, so let's cut the Cc
list and change the subject.

On Tue, Dec 12, 2006 at 04:21:23PM +0200, Boaz Harrosh wrote:
> I'm afraid this might not be enough because of code in drivers/ide/ide-cd.c. It does IO off of request->data.

Only for FS requests, but we do BLOCK_PC requests here.

> [background]
> pkt_generic_packet and ton of other places mainly cd(s), floppy(s), and
> other ide code paths, are using what I call BLACK requests. They put some
> data on request->buffer or request->data stick it in the Q and than advance
> on them later down the ladder. Remove of "buffer" and "data" from
> struct request will reveal all these places. At one time I had plans to do
> just that. But 1/2 way through I gave up, it is too risky, too much
> Hardware that I don't have, that needs checking.

Removing this old code would definitly be worthwile, but I understand
that you don't want to get too deeply into the mess of floppy.c and the
old ide code :)

> below patch combined with your patch might get a bit closer for this code
> path.  At struct request I have changed the name of "data" member to
> "user_data". than changed the code paths that used "data" as IO to use
> request->buffer instead. This is just as bad but is a more common practice.
> 
> I suspect there is a problem with what I did in scsi_lib.c Christoph please
> check me out with the new BUG_ON.

They look good to me.

> Mainly what you need from below is only the code in ide-cd.c.
> (And there are 3-4 places that do exactly like pkt_generic_packet, though
> I'm not sure they end up through SCSI.

Do you have a list of those places at hand?  We should try to fix them
up, especially if it's as trivial as the pkt code.

