From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: BAD_SG_DMA panic in aha1542
Date: Mon, 30 Apr 2007 19:32:45 +0200
Message-ID: <20070430173243.GP21015@kernel.dk>
References: <20070427214709.DC44BDBA2@gherkin.frus.com> <1177712499.3688.25.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:9171 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031558AbXD3RhH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Apr 2007 13:37:07 -0400
Content-Disposition: inline
In-Reply-To: <1177712499.3688.25.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Bob Tracy <rct@gherkin.frus.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@infradead.org

On Fri, Apr 27 2007, James Bottomley wrote:
> > sgpnt[0:1] page c1ee5af0/0x1ee5af0 length 32
> > Kernel panic - not syncing: Buffer at physical address > 16 Mb used for aha1542
> > 
> > As before, no problems using the sda hard disk (which is the boot drive):
> > everything works reliably until I touch the cdrom drive.
> > 
> > I'll be happy to assist with the debugging, but the system with the
> > aha1542 has no development facilities, i.e., I'll have to build test
> > kernels on a different system, and turnaround is going to be slow :-(.
> 
> I'm interested.
> 
> This is clearly a use_sg==1 path that has failed to bounce the buffer
> for some reason ... and I was contemplating eliminating the GFP_DMA from
> our sr driver because I thought the block bouncing had it covered.
> 
> It might also be helpful to apply this patch.  It should give a stack
> trace of the problem command and not immediately panic the box.

It's due to the crappy ->generic_packet() ioctl stuff, it bypasses the
block layer. So that needs to be converted to use block pc requests and
the block layer interface, then things will just work.

Christoph had a sort-of ready patch for that some time ago. Christoph,
did that ever materialize into a full blown patch?

-- 
Jens Axboe

